Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB2E353924
	for <lists+kvm@lfdr.de>; Sun,  4 Apr 2021 19:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhDDRYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Apr 2021 13:24:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231468AbhDDRX0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 4 Apr 2021 13:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617557001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eOYpukDLmGfOzd0Aol5byEkjqVTZ4sRQkcES7s56wrE=;
        b=LQ0Bp/jJ4UWQtG1rFfaCfrCdK8TdVK2Y8PQ/FhaMF5boMfj0MTJ0ElAA76boosMyf600Tl
        VJJ8SSgUNELGFUtkSzqGDwVur/vJ+1wj1B7dm0E3U1kXD+EtHOjLK5VnwFaVwkt3uzw5Rx
        HmPMtIpfsF2F2c/+iOShnSD87FrDaVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-B1LXOZf1PRyB_4VxhHNF5g-1; Sun, 04 Apr 2021 13:23:19 -0400
X-MC-Unique: B1LXOZf1PRyB_4VxhHNF5g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55469189CD04;
        Sun,  4 Apr 2021 17:23:18 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36D2710027C4;
        Sun,  4 Apr 2021 17:23:14 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v5 7/8] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for userspace
Date:   Sun,  4 Apr 2021 19:22:42 +0200
Message-Id: <20210404172243.504309-8-eric.auger@redhat.com>
In-Reply-To: <20210404172243.504309-1-eric.auger@redhat.com>
References: <20210404172243.504309-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
reporting of GICR_TYPER.Last for userspace") temporarily fixed
a bug identified when attempting to access the GICR_TYPER
register before the redistributor region setting, but dropped
the support of the LAST bit.

Emulating the GICR_TYPER.Last bit still makes sense for
architecture compliance though. This patch restores its support
(if the redistributor region was set) while keeping the code safe.

We introduce a new helper, vgic_mmio_vcpu_rdist_is_last() which
computes whether a redistributor is the highest one of a series
of redistributor contributor pages.

With this new implementation we do not need to have a uaccess
read accessor anymore.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v4 -> v5:
- redist region list now is sorted by @base
- change the implementation according to Marc's understanding of
  the spec
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 58 +++++++++++++++++-------------
 include/kvm/arm_vgic.h             |  1 +
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index e1ed0c5a8eaa..03a253785700 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -251,45 +251,52 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 		vgic_enable_lpis(vcpu);
 }
 
+static bool vgic_mmio_vcpu_rdist_is_last(struct kvm_vcpu *vcpu)
+{
+	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_redist_region *iter, *rdreg = vgic_cpu->rdreg;
+
+	if (!rdreg)
+		return false;
+
+	if (vgic_cpu->rdreg_index < rdreg->free_index - 1) {
+		return false;
+	} else if (rdreg->count && vgic_cpu->rdreg_index == (rdreg->count - 1)) {
+		struct list_head *rd_regions = &vgic->rd_regions;
+		gpa_t end = rdreg->base + rdreg->count * KVM_VGIC_V3_REDIST_SIZE;
+
+		/*
+		 * the rdist is the last one of the redist region,
+		 * check whether there is no other contiguous rdist region
+		 */
+		list_for_each_entry(iter, rd_regions, list) {
+			if (iter->base == end && iter->free_index > 0)
+				return false;
+		}
+	}
+	return true;
+}
+
 static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 					      gpa_t addr, unsigned int len)
 {
 	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	struct vgic_redist_region *rdreg = vgic_cpu->rdreg;
 	int target_vcpu_id = vcpu->vcpu_id;
-	gpa_t last_rdist_typer = rdreg->base + GICR_TYPER +
-			(rdreg->free_index - 1) * KVM_VGIC_V3_REDIST_SIZE;
 	u64 value;
 
 	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
 	value |= ((target_vcpu_id & 0xffff) << 8);
 
-	if (addr == last_rdist_typer)
+	if (vgic_has_its(vcpu->kvm))
+		value |= GICR_TYPER_PLPIS;
+
+	if (vgic_mmio_vcpu_rdist_is_last(vcpu))
 		value |= GICR_TYPER_LAST;
-	if (vgic_has_its(vcpu->kvm))
-		value |= GICR_TYPER_PLPIS;
 
 	return extract_bytes(value, addr & 7, len);
 }
 
-static unsigned long vgic_uaccess_read_v3r_typer(struct kvm_vcpu *vcpu,
-						 gpa_t addr, unsigned int len)
-{
-	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
-	int target_vcpu_id = vcpu->vcpu_id;
-	u64 value;
-
-	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
-	value |= ((target_vcpu_id & 0xffff) << 8);
-
-	if (vgic_has_its(vcpu->kvm))
-		value |= GICR_TYPER_PLPIS;
-
-	/* reporting of the Last bit is not supported for userspace */
-	return extract_bytes(value, addr & 7, len);
-}
-
 static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
 					     gpa_t addr, unsigned int len)
 {
@@ -612,7 +619,7 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_TYPER,
 		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi,
-		vgic_uaccess_read_v3r_typer, vgic_mmio_uaccess_write_wi, 8,
+		NULL, vgic_mmio_uaccess_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
@@ -714,6 +721,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	vgic_cpu->rdreg = rdreg;
+	vgic_cpu->rdreg_index = rdreg->free_index;
 
 	rd_base = rdreg->base + rdreg->free_index * KVM_VGIC_V3_REDIST_SIZE;
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3d74f1060bd1..ec621180ef09 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -322,6 +322,7 @@ struct vgic_cpu {
 	 */
 	struct vgic_io_device	rd_iodev;
 	struct vgic_redist_region *rdreg;
+	u32 rdreg_index;
 
 	/* Contains the attributes and gpa of the LPI pending tables. */
 	u64 pendbaser;
-- 
2.26.3


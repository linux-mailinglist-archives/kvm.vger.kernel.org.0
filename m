Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9971D41B696
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242291AbhI1Stw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbhI1Stv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 14:49:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF38C06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f8-20020a2585480000b02905937897e3daso25575738ybn.2
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WAqYgSZANBQPGrSP2/3EiNP0xOOtjEK+EoXAoDp+T4U=;
        b=FVBMJgpfmWUBj6QARIX+xdJjaaGUEQoe0zbBl69lT+k3AhTFlydw5VN6+1xN23pk2B
         mpStAxsUAY6FhRP29Lt3oKt0dKV9Y3xgQCLgO9ab9thvP0LBOLneJj7nb0WWS7nClmA2
         gjFN2Y2snAfAK2vmPr8evtrvk3DOjhqZPAsvBamXsQ7SGV54WR9PEJy5V+SP4+02Vlmm
         klOuVWVQnFFCF/RC6DuhomYxb9MB7LC21L7KM+5sKZ6VNkbgqHjkzap//uE2sZldvL5y
         /CZJJVjI+NhPmEYCyL6VbCgjzukC84SPGlGfRD8MqTOpIGNQIMw22pZur/+k2P04S5Y3
         4otA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WAqYgSZANBQPGrSP2/3EiNP0xOOtjEK+EoXAoDp+T4U=;
        b=HV21Z3cDT29xDgcvcxMtNKpNdUz4bDwUobwIUY7L6cMEuL5bQ/X2vt2Cx61RZvoF0t
         IqPsSQB5/f+uE8t/wVaCYdpA27b3oNJKYgR9fI7RVPopPOP5nxHKB36n/KzsflnFFot5
         OqSWAZZvI0GHwsEL7+GjCOBwzFwcRClEsb1fJy5rApMRw7J1hRn8XlzFKlbG9tohTQ9h
         K/nkFhAEnMPCi0434erJLa3Vx7n9k+JrHeoW9/KNV51dpDaVgNyk7gq6PYVKjS6NxLLg
         xs0oMn1JNaNnf4DhAlEhV4aCtYgm9QrK8FN7GyRGJMR2RG1hDZYmFK+DUX9lUGCe084I
         K/OQ==
X-Gm-Message-State: AOAM533THCM7GqnP2RfHVhC5kr2Mi0vpEv5O6k54vF6WeCxvcN/cgPKr
        IJd9DqPZJK+4mX5EPuTrAgbOD1btRd7H6fLqIfTXmt31wNaPHiQ7kpCVO5BbXpuDd8RTfBdPs+e
        +gyY59t2SHyCZdzYPFxItL9LRsJCfE3QTmDzgFAi5ECHDKafPxWuZWs5r052ugwE=
X-Google-Smtp-Source: ABdhPJxNlbd9xaIVWBlb06ZLVfi9me310h22AXk1NuCxq0eUX+iIm+qoIj+aT5WJbHCnDzueUzbGxNWaI4HRKg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:76c9:: with SMTP id
 r192mr7253464ybc.481.1632854890485; Tue, 28 Sep 2021 11:48:10 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:47:56 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the redistributor regions do not extend beyond the
VM-specified IPA range (phys_size). This can happen when using
KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
with:

  base + size > phys_size AND base < phys_size

Add the missing check into vgic_v3_alloc_redist_region() which is called
when setting the regions, and into vgic_v3_check_base() which is called
when attempting the first vcpu-run. The vcpu-run check does not apply to
KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
before the first vcpu-run. Note that using the REDIST_REGIONS API
results in a different check, which already exists, at first vcpu run:
that the number of redist regions is enough for all vcpus.

Finally, this patch also enables some extra tests in
vgic_v3_alloc_redist_region() by calculating "size" early for the legacy
redist api: like checking that the REDIST region can fit all the already
created vcpus.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++++--
 arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a09cdc0b953c..9be02bf7865e 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 	struct vgic_dist *d = &kvm->arch.vgic;
 	struct vgic_redist_region *rdreg;
 	struct list_head *rd_regions = &d->rd_regions;
-	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
+	int nr_vcpus = atomic_read(&kvm->online_vcpus);
+	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE
+			    : nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
 	int ret;
 
 	/* cross the end of memory ? */
@@ -840,7 +842,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 
 	rdreg->base = VGIC_ADDR_UNDEF;
 
-	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
+	ret = vgic_check_iorange(kvm, &rdreg->base, base, SZ_64K, size);
 	if (ret)
 		goto free;
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 21a6207fb2ee..27ee674631b3 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -486,6 +486,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
 		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
 			rdreg->base)
 			return false;
+
+		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
+			kvm_phys_size(kvm))
+			return false;
 	}
 
 	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
-- 
2.33.0.685.g46640cef36-goog


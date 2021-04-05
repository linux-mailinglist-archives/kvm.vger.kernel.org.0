Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E212235455F
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242470AbhDEQkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:40:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242471AbhDEQkR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Apr 2021 12:40:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617640811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/zxucnPItRI/WVimK5acRn5RS6yMBNn5B7shhgyqn64=;
        b=Q1YmdXcttv/LuPDr/h3xP9hiMxG2Qu78p+rOhXy2UNTOlyXPV5jfFzvgeso2Sz8P8G5Heo
        Xw+ovCfhUaWZNhemK8fyfVPRTDcrQ3TXPGZBAhWtq+E787ZEf3gVqRdCho3hvpyB0Dj8ep
        0T8A5GX3UE873vqTKmSB8K3wWyXTE0Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-q5s3OFVFO0GT-eiZtGQZNw-1; Mon, 05 Apr 2021 12:40:07 -0400
X-MC-Unique: q5s3OFVFO0GT-eiZtGQZNw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90C23E49E3;
        Mon,  5 Apr 2021 16:40:05 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0A0919715;
        Mon,  5 Apr 2021 16:40:02 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v6 4/9] KVM: arm/arm64: vgic: Reset base address on kvm_vgic_dist_destroy()
Date:   Mon,  5 Apr 2021 18:39:36 +0200
Message-Id: <20210405163941.510258-5-eric.auger@redhat.com>
In-Reply-To: <20210405163941.510258-1-eric.auger@redhat.com>
References: <20210405163941.510258-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On vgic_dist_destroy(), the addresses are not reset. However for
kvm selftest purpose this would allow to continue the test execution
even after a failure when running KVM_RUN. So let's reset the
base addresses.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- use dist-> in the else and add braces
---
 arch/arm64/kvm/vgic/vgic-init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 052917deb149..cf6faa0aeddb 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -335,13 +335,16 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	kfree(dist->spis);
 	dist->spis = NULL;
 	dist->nr_spis = 0;
+	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
 
-	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list) {
 			list_del(&rdreg->list);
 			kfree(rdreg);
 		}
 		INIT_LIST_HEAD(&dist->rd_regions);
+	} else {
+		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
 	}
 
 	if (vgic_has_its(kvm))
@@ -362,6 +365,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	vgic_flush_pending_lpis(vcpu);
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 }
 
 /* To be called with kvm->lock held */
-- 
2.26.3


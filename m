Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2921449849
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 16:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240812AbhKHPbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 10:31:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238984AbhKHPbP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 10:31:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636385310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PpImbiSK/JTgTmgweCfAlTVhQ8mU+Foko1Bhpj/Of2U=;
        b=Xr7NrLnNC30bxcR9kQQl35k1KQvyeH5sbOSzn6zy5gXbFJQmNw2416OQbpAsec7tL59Gx/
        tUmLDzN1ulIQqmEBELbYFbMLQi44796LV7VTq+9u0kBzcI/oslFf/VGyZR+naOdwFLuDCZ
        bbVM0WuI37yNIo8/4qq1T2FKzHNeBtM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-pTotu3F-O_uFkVhbLFue7w-1; Mon, 08 Nov 2021 10:28:26 -0500
X-MC-Unique: pTotu3F-O_uFkVhbLFue7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F9A41023F4D;
        Mon,  8 Nov 2021 15:28:25 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73AEC794A9;
        Mon,  8 Nov 2021 15:28:23 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: Rename kvm_lapic_enable_pv_eoi()
Date:   Mon,  8 Nov 2021 16:28:18 +0100
Message-Id: <20211108152819.12485-2-vkuznets@redhat.com>
In-Reply-To: <20211108152819.12485-1-vkuznets@redhat.com>
References: <20211108152819.12485-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_lapic_enable_pv_eoi() is a misnomer as the function is also
used to disable PV EOI. Rename it to kvm_lapic_set_pv_eoi().

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 4 ++--
 arch/x86/kvm/lapic.c  | 2 +-
 arch/x86/kvm/lapic.h  | 2 +-
 arch/x86/kvm/x86.c    | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4f15c0165c05..4a555f32885a 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1472,7 +1472,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 
 		if (!(data & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE)) {
 			hv_vcpu->hv_vapic = data;
-			if (kvm_lapic_enable_pv_eoi(vcpu, 0, 0))
+			if (kvm_lapic_set_pv_eoi(vcpu, 0, 0))
 				return 1;
 			break;
 		}
@@ -1490,7 +1490,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 			return 1;
 		hv_vcpu->hv_vapic = data;
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-		if (kvm_lapic_enable_pv_eoi(vcpu,
+		if (kvm_lapic_set_pv_eoi(vcpu,
 					    gfn_to_gpa(gfn) | KVM_MSR_ENABLED,
 					    sizeof(struct hv_vp_assist_page)))
 			return 1;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..3573b50d9036 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2852,7 +2852,7 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
 	return 0;
 }
 
-int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
+int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 {
 	u64 addr = data & ~KVM_MSR_ENABLED;
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.pv_eoi.data;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d7c25d0c1354..2b44e533fc8d 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -127,7 +127,7 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 
-int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
+int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_exit(void);
 
 #define VEC_POS(v) ((v) & (32 - 1))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..41d4fe7374f5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3517,7 +3517,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
 			return 1;
 
-		if (kvm_lapic_enable_pv_eoi(vcpu, data, sizeof(u8)))
+		if (kvm_lapic_set_pv_eoi(vcpu, data, sizeof(u8)))
 			return 1;
 		break;
 
-- 
2.31.1


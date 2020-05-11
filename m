Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7151CE0E3
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 18:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbgEKQsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 12:48:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49303 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730740AbgEKQsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 12:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589215694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=35hTdl5yNDphj6Z3O0jEEa/SyBb7SmQCZfgkS6ZID9I=;
        b=E6AzSBN7AewtbXdbQ2P1HkLtMVODR48+dIS9EEGt1CN+7UalPwnjT4yu+WBO54Mq6N9jOK
        b9i7i/ier2Vqrb2m4IrVAKnMhrZYE1thSWgnb97zu0xDscQh9i6ZfQ8fvnFIwugB6jAAMS
        AjVt9MriIfXDWwJ8qQeiFwj8SLEkI1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-fteJNXIRN5aMh7U1MEqFLw-1; Mon, 11 May 2020 12:48:13 -0400
X-MC-Unique: fteJNXIRN5aMh7U1MEqFLw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EAD01899520;
        Mon, 11 May 2020 16:48:11 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23FCD196AE;
        Mon, 11 May 2020 16:48:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with token info
Date:   Mon, 11 May 2020 18:47:46 +0200
Message-Id: <20200511164752.2158645-3-vkuznets@redhat.com>
In-Reply-To: <20200511164752.2158645-1-vkuznets@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, APF mechanism relies on the #PF abuse where the token is being
passed through CR2. If we switch to using interrupts to deliver page-ready
notifications we need a different way to pass the data. Extent the existing
'struct kvm_vcpu_pv_apf_data' with token information for page-ready
notifications.

The newly introduced apf_put_user_ready() temporary puts both reason
and token information, this will be changed to put token only when we
switch to interrupt based notifications.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
 arch/x86/kvm/x86.c                   | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 2a8e0b6b9805..e3602a1de136 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -113,7 +113,8 @@ struct kvm_mmu_op_release_pt {
 
 struct kvm_vcpu_pv_apf_data {
 	__u32 reason;
-	__u8 pad[60];
+	__u32 pageready_token;
+	__u8 pad[56];
 	__u32 enabled;
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index edd4a6415b92..28868cc16e4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2662,7 +2662,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	}
 
 	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
-					sizeof(u32)))
+					sizeof(u64)))
 		return 1;
 
 	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
@@ -10352,8 +10352,17 @@ static void kvm_del_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 	}
 }
 
-static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
+static inline int apf_put_user_notpresent(struct kvm_vcpu *vcpu)
 {
+	u32 reason = KVM_PV_REASON_PAGE_NOT_PRESENT;
+
+	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &reason,
+				      sizeof(reason));
+}
+
+static inline int apf_put_user_ready(struct kvm_vcpu *vcpu, u32 token)
+{
+	u64 val = (u64)token << 32 | KVM_PV_REASON_PAGE_READY;
 
 	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &val,
 				      sizeof(val));
@@ -10398,7 +10407,7 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
 
 	if (kvm_can_deliver_async_pf(vcpu) &&
-	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
+	    !apf_put_user_notpresent(vcpu)) {
 		fault.vector = PF_VECTOR;
 		fault.error_code_valid = true;
 		fault.error_code = 0;
@@ -10431,7 +10440,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
 
 	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
-	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
+	    !apf_put_user_ready(vcpu, work->arch.token)) {
 			fault.vector = PF_VECTOR;
 			fault.error_code_valid = true;
 			fault.error_code = 0;
-- 
2.25.4


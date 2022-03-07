Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219414D01CF
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 15:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiCGOvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 09:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239426AbiCGOvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 09:51:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 857D985BE0
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 06:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646664636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7MOEJ5RjWZDPZbxRbiRpMy10rB9WaSfKp6mdphZp9/c=;
        b=WNOzw1qLngO8j96zzJ8d5vVSHKo5IceF9fLltqNa6NMB2ykLGamf18Xw27pOTk7cBH0prw
        jKNTOB7NrANr163ddW9+07qoafhAVUolUUtE4ae6ACZTrJicnbRN9pCkHL41pIlcWRBCA2
        buLZF/KP1W6auqPQRkg246sGs/VMndw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-5tjVvB2LPxC0Eu7S7MJRGg-1; Mon, 07 Mar 2022 09:50:31 -0500
X-MC-Unique: 5tjVvB2LPxC0Eu7S7MJRGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23DFC801DDC;
        Mon,  7 Mar 2022 14:50:30 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.193.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F07487F0D7;
        Mon,  7 Mar 2022 14:50:27 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 01/19] KVM: x86: hyper-v: Resurrect dedicated KVM_REQ_HV_TLB_FLUSH flag
Date:   Mon,  7 Mar 2022 15:50:05 +0100
Message-Id: <20220307145023.1913205-2-vkuznets@redhat.com>
In-Reply-To: <20220307145023.1913205-1-vkuznets@redhat.com>
References: <20220307145023.1913205-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation to implementing fine-grained Hyper-V TLB flush and
Direct TLB flush, resurrect dedicated KVM_REQ_HV_TLB_FLUSH request
bit. As KVM_REQ_TLB_FLUSH_GUEST is a stronger operation, clear
KVM_REQ_HV_TLB_FLUSH request in kvm_service_local_tlb_flush_requests()
when KVM_REQ_TLB_FLUSH_GUEST was also requested.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/hyperv.c           | 4 ++--
 arch/x86/kvm/x86.c              | 7 ++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index da2f3a21e37b..11bcae77bba4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -104,6 +104,8 @@
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_HV_TLB_FLUSH \
+	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a32f54ab84a2..0cad1fed6007 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1890,11 +1890,11 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	 * analyze it here, flush TLB regardless of the specified address space.
 	 */
 	if (all_cpus) {
-		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
+		kvm_make_all_cpus_request(kvm, KVM_REQ_HV_TLB_FLUSH);
 	} else {
 		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
 
-		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST, vcpu_mask);
+		kvm_make_vcpus_request_mask(kvm, KVM_REQ_HV_TLB_FLUSH, vcpu_mask);
 	}
 
 ret_success:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f79bf4552082..14f539fb9c02 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3339,7 +3339,12 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
 		kvm_vcpu_flush_tlb_current(vcpu);
 
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
+	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
+		kvm_vcpu_flush_tlb_guest(vcpu);
+		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+	}
+
+	if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
 		kvm_vcpu_flush_tlb_guest(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
-- 
2.35.1


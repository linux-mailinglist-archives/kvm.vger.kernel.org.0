Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0DE7C0112
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbjJJQEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbjJJQD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:03:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F243DAC
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696953789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xyOFdvwjZ+xxDeHG2VVNVrJrkXBiFcGsu54eo0pRt4I=;
        b=H5tqgXoT5OSldV4iPFkvOMYodvY5gwW42eXzQVHNfWYqPJ2lzxl+d360kuq9nkbD7VVW00
        IHefWwkojWDRQZsUJRsQ3fRo8EzdgHYF2zp7H43VbkZEdX3EGqRuoUI1pmQbXGriWjPcG5
        IILHanwFaKX/2YWHGwuVTQDFGXrR73s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-YROgcB0TOFG-LQf36gX9NA-1; Tue, 10 Oct 2023 12:03:04 -0400
X-MC-Unique: YROgcB0TOFG-LQf36gX9NA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A72D1019C88;
        Tue, 10 Oct 2023 16:03:04 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AEFF1B94;
        Tue, 10 Oct 2023 16:03:03 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH RFC 02/11] KVM: x86: hyper-v: Move Hyper-V partition assist page out of Hyper-V emulation context
Date:   Tue, 10 Oct 2023 18:02:51 +0200
Message-ID: <20231010160300.1136799-3-vkuznets@redhat.com>
In-Reply-To: <20231010160300.1136799-1-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hyper-V partition assist page is used when KVM runs on top of Hyper-V and
is not used for Windows/Hyper-V guests on KVM, this means that 'hv_pa_pg'
placement in 'struct kvm_hv' is unfortunate. As a preparation to making
Hyper-V emulation optional, move 'hv_pa_pg' to 'struct kvm_arch' and put it
under CONFIG_HYPERV.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm/svm_onhyperv.c | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/x86.c              | 4 +++-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e5d4b8a44630..711dc880a9f0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1115,7 +1115,6 @@ struct kvm_hv {
 	 */
 	unsigned int synic_auto_eoi_used;
 
-	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
 };
 
@@ -1436,6 +1435,7 @@ struct kvm_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
+	struct hv_partition_assist_pg *hv_pa_pg;
 #endif
 	/*
 	 * VM-scope maximum vCPU ID. Used to determine the size of structures
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 7af8422d3382..d19666f9b9ac 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -19,7 +19,7 @@ int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_vmcb_enlightenments *hve;
 	struct hv_partition_assist_pg **p_hv_pa_pg =
-			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
+		&vcpu->kvm->arch.hv_pa_pg;
 
 	if (!*p_hv_pa_pg)
 		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 72e3943f3693..b7dc7acf14be 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -524,7 +524,7 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct hv_enlightened_vmcs *evmcs;
 	struct hv_partition_assist_pg **p_hv_pa_pg =
-			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
+		&vcpu->kvm->arch.hv_pa_pg;
 	/*
 	 * Synthetic VM-Exit is not enabled in current code and so All
 	 * evmcs in singe VM shares same assist page.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..e273ce8e0b3f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12291,7 +12291,9 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_free_vm(struct kvm *kvm)
 {
-	kfree(to_kvm_hv(kvm)->hv_pa_pg);
+#if IS_ENABLED(CONFIG_HYPERV)
+	kfree(kvm->arch.hv_pa_pg);
+#endif
 	__kvm_arch_free_vm(kvm);
 }
 
-- 
2.41.0


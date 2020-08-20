Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F89624B1D1
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 11:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgHTJN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 05:13:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726816AbgHTJNt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 05:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597914828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSob+rKVUvO19l6gKXUXMaxMphnCEdWrm7lz8bngft0=;
        b=W0owkLxe2nZGPdmLQx2a1Uwxr7qyGIixr4u3/de9i7gZYC7l5we1QlSviXnz3ixkkAb8Ju
        V26gClPwrghhy0Levlf0rK8vSIUjQCt6TfhSRtfz4R06305wYRWuQYllhWikvkGPx+/XAC
        mRbTHLeJpsCAQ4U47zxFq9GWbFbhxnc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-_-D0NhNgPNa5PIeqpatExA-1; Thu, 20 Aug 2020 05:13:46 -0400
X-MC-Unique: _-D0NhNgPNa5PIeqpatExA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0BF11074644;
        Thu, 20 Aug 2020 09:13:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BC46747B0;
        Thu, 20 Aug 2020 09:13:40 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/8] KVM: SVM: refactor msr permission bitmap allocation
Date:   Thu, 20 Aug 2020 12:13:22 +0300
Message-Id: <20200820091327.197807-4-mlevitsk@redhat.com>
In-Reply-To: <20200820091327.197807-1-mlevitsk@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace svm_vcpu_init_msrpm with svm_vcpu_alloc_msrpm, that also allocates
the msr bitmap and add svm_vcpu_free_msrpm to free it.

This will be used later to move the nested msr permission bitmap allocation
to nested.c

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 45 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4338d2a2596e..e072ecace466 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -609,18 +609,29 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 	msrpm[offset] = tmp;
 }
 
-static void svm_vcpu_init_msrpm(u32 *msrpm)
+static u32 *svm_vcpu_alloc_msrpm(void)
 {
 	int i;
+	u32 *msrpm;
+	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
+
+	if (!pages)
+		return NULL;
 
+	msrpm = page_address(pages);
 	memset(msrpm, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
 
 	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
 		if (!direct_access_msrs[i].always)
 			continue;
-
 		set_msr_interception(msrpm, direct_access_msrs[i].index, 1, 1);
 	}
+	return msrpm;
+}
+
+static void svm_vcpu_free_msrpm(u32 *msrpm)
+{
+	__free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
 }
 
 static void add_msr_offset(u32 offset)
@@ -1172,9 +1183,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb_page;
-	struct page *msrpm_pages;
 	struct page *hsave_page;
-	struct page *nested_msrpm_pages;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
@@ -1185,21 +1194,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (!vmcb_page)
 		goto out;
 
-	msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
-	if (!msrpm_pages)
-		goto free_page1;
-
-	nested_msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
-	if (!nested_msrpm_pages)
-		goto free_page2;
-
 	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!hsave_page)
-		goto free_page3;
+		goto free_page1;
 
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto free_page4;
+		goto free_page2;
 
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
@@ -1210,11 +1211,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm->nested.hsave = page_address(hsave_page);
 	clear_page(svm->nested.hsave);
 
-	svm->msrpm = page_address(msrpm_pages);
-	svm_vcpu_init_msrpm(svm->msrpm);
+	svm->msrpm = svm_vcpu_alloc_msrpm();
+	if (!svm->msrpm)
+		goto free_page2;
 
-	svm->nested.msrpm = page_address(nested_msrpm_pages);
-	svm_vcpu_init_msrpm(svm->nested.msrpm);
+	svm->nested.msrpm = svm_vcpu_alloc_msrpm();
+	if (!svm->nested.msrpm)
+		goto free_page3;
 
 	svm->vmcb = page_address(vmcb_page);
 	clear_page(svm->vmcb);
@@ -1227,12 +1230,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
-free_page4:
-	__free_page(hsave_page);
 free_page3:
-	__free_pages(nested_msrpm_pages, MSRPM_ALLOC_ORDER);
+	svm_vcpu_free_msrpm(svm->msrpm);
 free_page2:
-	__free_pages(msrpm_pages, MSRPM_ALLOC_ORDER);
+	__free_page(hsave_page);
 free_page1:
 	__free_page(vmcb_page);
 out:
-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB66254BBB
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 19:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgH0RM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 13:12:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30977 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727820AbgH0RM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 13:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598548344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z9HwJLjNCnZ8FyxzkvUNBGMCw11CMJz/sGhvSdVH40A=;
        b=W40uqHJFh5qRcLHRfNgsQd3QvUmAgrNA7vHa7xKLlG5rixh+cC//Ntr4wmVwIStEYEBonK
        NpwXqFCSLp41BO9fhckR2y6hN6iaNOGVdQBAcva48Mddby9xrzyVyJI+v6VhynOv0I0/MD
        IZte8m85tNUwcuNz9KWLtjksAM7KRmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-SWOOdYeHPWWvgUBXEF6PEQ-1; Thu, 27 Aug 2020 13:12:23 -0400
X-MC-Unique: SWOOdYeHPWWvgUBXEF6PEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1CC5801AAB;
        Thu, 27 Aug 2020 17:12:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E5965D9E8;
        Thu, 27 Aug 2020 17:12:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 4/8] KVM: SVM: use __GFP_ZERO instead of clear_page
Date:   Thu, 27 Aug 2020 20:11:41 +0300
Message-Id: <20200827171145.374620-5-mlevitsk@redhat.com>
In-Reply-To: <20200827171145.374620-1-mlevitsk@redhat.com>
References: <20200827171145.374620-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Another small refactoring.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ddbb05614af4f..290b2d0cd78e3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1190,11 +1190,11 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	vmcb_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!vmcb_page)
 		goto out;
 
-	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!hsave_page)
 		goto free_page1;
 
@@ -1209,7 +1209,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		svm->avic_is_running = true;
 
 	svm->nested.hsave = page_address(hsave_page);
-	clear_page(svm->nested.hsave);
 
 	svm->msrpm = svm_vcpu_init_msrpm();
 	if (!svm->msrpm)
@@ -1220,7 +1219,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		goto free_page3;
 
 	svm->vmcb = page_address(vmcb_page);
-	clear_page(svm->vmcb);
 	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb_page) << PAGE_SHIFT);
 	svm->asid_generation = 0;
 	init_vmcb(svm);
-- 
2.26.2


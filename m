Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6ED254B90
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 19:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgH0RFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 13:05:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25561 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727831AbgH0RFH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 13:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598547906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/YGWSLvG6lY5R83KUArknDiX8BRYjrRNnmUZit1EZI=;
        b=it1TP+nhbyvKMKD4sqVyQ2F5VGiXfY8qo4YyFAMugQBl3TrpEnW7rTZcB7M0woaKZ2VAaz
        cD5Wlt+s2+PyJMwxJwnnyVfMUhc+fxK7F1YFtFFuCtzy2XddU53PCZ66qjVSN4cA5LVXFC
        AeyZ026sMq7Roh4HzottpeSNQ0JOOXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-6nczjpt-Ol2xEaivnHONIQ-1; Thu, 27 Aug 2020 13:05:04 -0400
X-MC-Unique: 6nczjpt-Ol2xEaivnHONIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41B1818BFEC4;
        Thu, 27 Aug 2020 17:05:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEB3B196F3;
        Thu, 27 Aug 2020 17:04:56 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5/8] KVM: SVM: refactor exit labels in svm_create_vcpu
Date:   Thu, 27 Aug 2020 20:04:31 +0300
Message-Id: <20200827170434.284680-6-mlevitsk@redhat.com>
In-Reply-To: <20200827170434.284680-1-mlevitsk@redhat.com>
References: <20200827170434.284680-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kernel coding style suggests not to use labels like error1,error2

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 290b2d0cd78e3..b617579095277 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1196,11 +1196,11 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!hsave_page)
-		goto free_page1;
+		goto error_free_vmcb_page;
 
 	err = avic_init_vcpu(svm);
 	if (err)
-		goto free_page2;
+		goto error_free_hsave_page;
 
 	/* We initialize this flag to true to make sure that the is_running
 	 * bit would be set the first time the vcpu is loaded.
@@ -1212,11 +1212,11 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm->msrpm = svm_vcpu_init_msrpm();
 	if (!svm->msrpm)
-		goto free_page2;
+		goto error_free_hsave_page;
 
 	svm->nested.msrpm = svm_vcpu_init_msrpm();
 	if (!svm->nested.msrpm)
-		goto free_page3;
+		goto error_free_msrpm;
 
 	svm->vmcb = page_address(vmcb_page);
 	svm->vmcb_pa = __sme_set(page_to_pfn(vmcb_page) << PAGE_SHIFT);
@@ -1228,11 +1228,11 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	return 0;
 
-free_page3:
+error_free_msrpm:
 	svm_vcpu_free_msrpm(svm->msrpm);
-free_page2:
+error_free_hsave_page:
 	__free_page(hsave_page);
-free_page1:
+error_free_vmcb_page:
 	__free_page(vmcb_page);
 out:
 	return err;
-- 
2.26.2


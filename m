Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FBE254B91
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgH0RFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 13:05:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46273 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727046AbgH0RFB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 13:05:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598547899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z9HwJLjNCnZ8FyxzkvUNBGMCw11CMJz/sGhvSdVH40A=;
        b=G4F0ClBp5XwZiaQXLW5N1SI0tnLnmmfiugQN33LqURS+83fqAeigFH6EbnNfwnSn6yBQVA
        mwK5UpNlu61W9UEueMr+8jviedVJXrb+fzUt2/ze3/F8avApyswXTvU6nX8viradRFf5Y5
        rZI/mI2vjQck3xp4aJ58Mu/8rRkwsQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-h45REhTFOc-mk5j2ZEpJjQ-1; Thu, 27 Aug 2020 13:04:58 -0400
X-MC-Unique: h45REhTFOc-mk5j2ZEpJjQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C451107464C;
        Thu, 27 Aug 2020 17:04:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA8F4196F3;
        Thu, 27 Aug 2020 17:04:52 +0000 (UTC)
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
Subject: [PATCH 4/8] KVM: SVM: use __GFP_ZERO instead of clear_page
Date:   Thu, 27 Aug 2020 20:04:30 +0300
Message-Id: <20200827170434.284680-5-mlevitsk@redhat.com>
In-Reply-To: <20200827170434.284680-1-mlevitsk@redhat.com>
References: <20200827170434.284680-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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


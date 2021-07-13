Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD423C7201
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbhGMOXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:23:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236857AbhGMOXc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 10:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L69UkkrjyTZZpLbJ/QuitM5Y28grXL4EjHWDP41CjFM=;
        b=aFy1lQf1qV6xk14Q4sdZTMgknc+5DRB7+5ESyD4s5XD3kCG8Y+r+Kze6dsLtTRflQ6nMIr
        6MGZpU15VI1hm43UmMihWEtC86A9fiiw8x10IG4PYj1XTVE4BkVa3y9rV6Ud0H5gVgInSo
        tzQ/f/YYpssTxZ1UCxCJ4Wfm2O5zwnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-T6sK9xBnMbG4kIiPyf7_pw-1; Tue, 13 Jul 2021 10:20:41 -0400
X-MC-Unique: T6sK9xBnMbG4kIiPyf7_pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75867BBEE3;
        Tue, 13 Jul 2021 14:20:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DCAF5D6AB;
        Tue, 13 Jul 2021 14:20:34 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/8] KVM: SVM: tweak warning about enabled AVIC on nested entry
Date:   Tue, 13 Jul 2021 17:20:17 +0300
Message-Id: <20210713142023.106183-3-mlevitsk@redhat.com>
In-Reply-To: <20210713142023.106183-1-mlevitsk@redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is possible that AVIC was requested to be disabled but
not yet disabled, e.g if the nested entry is done right
after svm_vcpu_after_set_cpuid.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dca20f949b63..253847f7d9aa 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -505,7 +505,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	 * Also covers avic_vapic_bar, avic_backing_page, avic_logical_id,
 	 * avic_physical_id.
 	 */
-	WARN_ON(svm->vmcb01.ptr->control.int_ctl & AVIC_ENABLE_MASK);
+	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
 
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	svm->vmcb->control.nested_ctl = svm->vmcb01.ptr->control.nested_ctl;
-- 
2.26.3


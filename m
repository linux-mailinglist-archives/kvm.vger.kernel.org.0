Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE433B18F4
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhFWLdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:33:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230496AbhFWLc5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:32:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L69UkkrjyTZZpLbJ/QuitM5Y28grXL4EjHWDP41CjFM=;
        b=TGSKak/BX5GU3w1HSDUg9x0DerSlPmzq/8ON4mQY1HhsvwLJDl/xyXg/7Yn5Uepd/x8g/5
        0UB20ixTXICOJHblavis5VQIdJkjTRdJP/WNbZVNgFGk4xDo52I3wCsXFgWupU4EhW2Rbh
        Ece3e8oVEDjIt8BCDdSFP0+APfpzhB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-kl9VhzVdNLyRuROY5yd2ow-1; Wed, 23 Jun 2021 07:30:38 -0400
X-MC-Unique: kl9VhzVdNLyRuROY5yd2ow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7637F19067E3;
        Wed, 23 Jun 2021 11:30:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 869C05D6D7;
        Wed, 23 Jun 2021 11:30:32 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 06/10] KVM: SVM: tweak warning about enabled AVIC on nested entry
Date:   Wed, 23 Jun 2021 14:29:58 +0300
Message-Id: <20210623113002.111448-7-mlevitsk@redhat.com>
In-Reply-To: <20210623113002.111448-1-mlevitsk@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
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


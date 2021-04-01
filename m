Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3E4351D16
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbhDASXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:23:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234914AbhDASVF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:21:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M16ZJaJZ+NL22pADrEtYc0OkKhjeTILetSpppsN0Jrg=;
        b=h6271OZ8qGQDSzEc0YX7Ns2A6kpp7YGDdOppdsBQBuQ6S+GTn+KTNKynP6okJuP9S7WU0S
        ajsC4GJY7cvVDDJzhMW4JWu5WWdGfS9cQcWixSQ0KgZixK3fUTQi095SR+wvnkPwVcNDDQ
        d+Q5FRpv/K6Fy6d6bF2HO4ggFc6um+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-sBYoBrEVPPqJd9FR_V-Otw-1; Thu, 01 Apr 2021 10:19:02 -0400
X-MC-Unique: sBYoBrEVPPqJd9FR_V-Otw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C820180A09B;
        Thu,  1 Apr 2021 14:18:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0F0959464;
        Thu,  1 Apr 2021 14:18:28 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/6] KVM: x86: introduce kvm_register_clear_available
Date:   Thu,  1 Apr 2021 17:18:11 +0300
Message-Id: <20210401141814.1029036-4-mlevitsk@redhat.com>
In-Reply-To: <20210401141814.1029036-1-mlevitsk@redhat.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small refactoring that will be used in the next patch.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 7 +++++++
 arch/x86/kvm/svm/svm.c        | 6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 2e11da2f5621..07d607947805 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -55,6 +55,13 @@ static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
+static inline void kvm_register_clear_available(struct kvm_vcpu *vcpu,
+					       enum kvm_reg reg)
+{
+	__clear_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+	__clear_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+}
+
 static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
 					   enum kvm_reg reg)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 271196400495..2843732299a2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3880,10 +3880,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		vcpu->arch.apf.host_apf_flags =
 			kvm_read_and_reset_apf_flags();
 
-	if (npt_enabled) {
-		vcpu->arch.regs_avail &= ~(1 << VCPU_EXREG_PDPTR);
-		vcpu->arch.regs_dirty &= ~(1 << VCPU_EXREG_PDPTR);
-	}
+	if (npt_enabled)
+		kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
 
 	/*
 	 * We need to handle MC intercepts here before the vcpu has a chance to
-- 
2.26.2


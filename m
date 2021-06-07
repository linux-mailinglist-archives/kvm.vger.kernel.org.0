Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9FD39D82E
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhFGJEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:04:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231163AbhFGJEn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:04:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623056572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mPKSMhqz1uksXtrztghDIQDbf6ez5SFIQVW1f3+NEiQ=;
        b=MZC/L2kPTarZ0tYNkHxDm1s4K0EF/gjvMteUoJgTNTYQrDaMHNSR+veXqgOJtKOQYIayXW
        Hi2x+grT5BZVte0phjfMH/WWbUw469AFTnxWG6W2kvLVfAkrbSr228htPGuMwFc6DI1Wxq
        1G5XWijkwQb+b7OT3I1SiOW8FvY4vyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267--sc4Rl4cOyybHHoGAUHUvQ-1; Mon, 07 Jun 2021 05:02:50 -0400
X-MC-Unique: -sc4Rl4cOyybHHoGAUHUvQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BA6A107ACF9;
        Mon,  7 Jun 2021 09:02:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC3C0100EB3D;
        Mon,  7 Jun 2021 09:02:43 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 6/8] KVM: x86: introduce kvm_register_clear_available
Date:   Mon,  7 Jun 2021 12:02:01 +0300
Message-Id: <20210607090203.133058-7-mlevitsk@redhat.com>
In-Reply-To: <20210607090203.133058-1-mlevitsk@redhat.com>
References: <20210607090203.133058-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 3db5c42c9ecd..b8559b83c4ca 100644
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
index dfa351e605de..491833ff2495 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3848,10 +3848,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
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
2.26.3


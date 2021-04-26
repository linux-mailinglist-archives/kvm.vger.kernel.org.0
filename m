Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC53436B23A
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 13:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhDZLPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 07:15:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233262AbhDZLPI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 07:15:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619435666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HjxS0PwgHyzJEmi0AU6IitMB7uQo4Hn4kBAi0PEBp3c=;
        b=IvItHnU/c629BhJScHgpcZqBkrNj6iey2fpzmh6oDjN79k+2g42SPowIqyZL+VTSWeaecx
        zSGxHQm1jDx7tYhMdKC9FJ6iFgrV8aZ9cRgFoNg4AoXG+mcb8bpMU9huY576EneSwWzaBx
        3skOuBbKI8btfPmKdtx0qmvKGgBh6EY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-GhIMCWXqO2CAGB_7hANqHQ-1; Mon, 26 Apr 2021 07:14:23 -0400
X-MC-Unique: GhIMCWXqO2CAGB_7hANqHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 476B38A2C4A;
        Mon, 26 Apr 2021 11:13:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 836AE5D9D0;
        Mon, 26 Apr 2021 11:13:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 3/6] KVM: x86: introduce kvm_register_clear_available
Date:   Mon, 26 Apr 2021 14:13:30 +0300
Message-Id: <20210426111333.967729-4-mlevitsk@redhat.com>
In-Reply-To: <20210426111333.967729-1-mlevitsk@redhat.com>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 14ff7f0963e9..c596bf1a4ae8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3868,10 +3868,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
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


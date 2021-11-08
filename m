Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D2C447FB3
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbhKHMsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239780AbhKHMsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:48:08 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A66DC061225;
        Mon,  8 Nov 2021 04:45:24 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id x131so10689058pfc.12;
        Mon, 08 Nov 2021 04:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TmKbYqg9m5arRUZ1yoqUsfhIjoLn2jM25Bi3woDZ7Y0=;
        b=TS5T3BOEfcFbwXedPw5SQlHGYER9dzbE2MGMUzpOVp61wtiNOlSDGyfFphYYW7e8vv
         kvwIcTAWC5SS0AZWQVjfYHvRF8OYfkoT6pkY4Fq625e4xYQY0kEFjFHPfNR4ewKPGuXG
         es6pdEQ0d1BsjUlTvoV45pyunHhU5rwgOrZHrZo+Bdd4XrHU++n+Op+mCINNvW0cHkhz
         AzPUlIk9uL3JOkCqcuBhH/hpIkq2TCRqd3n4EMjDbLre75QbAU+5gr8lMvw/4LOd971P
         hWmjGAf+mVnzOXTtDLUUwPBMkCM/bnKRreL0cLfBhq7VvDTZdKy9VgqgAWUP6WjvLsVz
         ydlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TmKbYqg9m5arRUZ1yoqUsfhIjoLn2jM25Bi3woDZ7Y0=;
        b=2HXzObYLNQdSX07lYDqAsjS9/9MZbkkFIINFU5maENJPiaJRT9LpZpq9Mk6YLNmNWH
         1r9zVgMmgcEMcu0W55Oown/eECV2avgoqZw9Rb+nzyKGr28x8lWkpRO2sTZtNyCJvMjx
         wdq9bxWEm7L9Upe0R9nMX7p+O2v1Rm8vDbwHtU7GkQWQey7W128TkX++G0o10f3Jy8+K
         iQtD0/9K5INgN5WFFqRB8Q2KYZoGFh7MFyUd5L00nd2FN6jqKpHrEwPlxt9hduTLyu3G
         mLVwGRQ+rXnsSpxDRFqmB787BW2Yl8A6vnroTXIcnTf6QtlC/VgPL33KunQlFKqLXgc0
         KJWA==
X-Gm-Message-State: AOAM532bjTOHGx7Xrc6QOoMsA8mCfhADxn9Dm1EC9MasFR0+UDpt3TKS
        kxlpkmMelkEwCZmvsRk0Igmhf3hai6g=
X-Google-Smtp-Source: ABdhPJyFsaYpfmszc9hhnb+Dy6cSfwkjtylHDvxvBq5PdoJUz0xbxZV8tvxJsYgWyHuDu0vlA/nMzQ==
X-Received: by 2002:a63:6881:: with SMTP id d123mr43841319pgc.68.1636375523761;
        Mon, 08 Nov 2021 04:45:23 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id k14sm12709952pga.65.2021.11.08.04.45.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:45:23 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 13/15] KVM: SVM: Add and use svm_register_cache_reset()
Date:   Mon,  8 Nov 2021 20:44:05 +0800
Message-Id: <20211108124407.12187-14-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

It resets all the appropriate bits like vmx.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/svm/svm.c |  3 +--
 arch/x86/kvm/svm/svm.h | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b7da66935e72..ba9cfddd2875 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3969,8 +3969,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 	vmcb_mark_all_clean(svm->vmcb);
-
-	kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
+	svm_register_cache_reset(vcpu);
 
 	/*
 	 * We need to handle MC intercepts here before the vcpu has a chance to
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0d7bbe548ac3..1cf5d5e2d0cd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -274,6 +274,32 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
         return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
 }
 
+static inline void svm_register_cache_reset(struct kvm_vcpu *vcpu)
+{
+/*
+ * SVM_REGS_AVAIL_SET - The set of registers that will be updated in cache on
+ *			demand.  Other registers not listed here are synced to
+ *			the cache immediately after VM-Exit.
+ *
+ * SVM_REGS_DIRTY_SET - The set of registers that might be outdated in
+ *			architecture. Other registers not listed here are synced
+ *			to the architecture immediately when modifying.
+ *
+ *			Special case: VCPU_EXREG_CR3 should be in this set due
+ *			to the fact.  But KVM_REQ_LOAD_MMU_PGD is always
+ *			requested when the cache vcpu->arch.cr3 is changed and
+ *			svm_load_mmu_pgd() always syncs the new CR3 value into
+ *			the architecture.  So the dirty information of
+ *			VCPU_EXREG_CR3 is not used which means VCPU_EXREG_CR3
+ *			isn't required to be put in this set.
+ */
+#define SVM_REGS_AVAIL_SET	(1 << VCPU_EXREG_PDPTR)
+#define SVM_REGS_DIRTY_SET	(0)
+
+	vcpu->arch.regs_avail &= ~SVM_REGS_AVAIL_SET;
+	vcpu->arch.regs_dirty &= ~SVM_REGS_DIRTY_SET;
+}
+
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
-- 
2.19.1.6.gb485710b


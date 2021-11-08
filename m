Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE34E447F9B
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbhKHMq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239608AbhKHMq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:46:57 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAED4C061714;
        Mon,  8 Nov 2021 04:44:13 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso8724538pjb.0;
        Mon, 08 Nov 2021 04:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mxz8tU8qCanqhr03iDJonw9Th0/vdIsQXvtH3Lb3WMg=;
        b=UaEoyOKG8I8rKvakfVaqp1eZJev17NelYQcBytqBieIkAQ9viW38oHk6Gp3WrdVqSa
         miNJ/2ZaNRGzGtuBWzISIJ9qx7i462B1vDFJFSI1CJANze5PCgrCmgxVpATnEZZfQ9cA
         ZiM/Mlxb7H0LvuuBCku540zhBSYmfRebanMQog+hOpbyeP0zYGdLaIGl//3AJ5X+gDD6
         7OjhT2fWZgU4krf535+0AQm9FTRDRnHFLY0by4Tp0tLknfAdp2CfQ72AEKZ9Oe9mFP1+
         ck2ZxOxS3T+EPYacE5yaLT3rXjg5bFIaGweLUECbQla+a+nuLOKhvb2VJc1lgcuRHWic
         JDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mxz8tU8qCanqhr03iDJonw9Th0/vdIsQXvtH3Lb3WMg=;
        b=LGc/AqMGJP4D09I2xuHdll9Q8Lu1erEAXNGEDvSjIQR6QJ8MUO0bjdr+j+vVyAYjmJ
         MPwYXjUACUP6S5w9F/oRxGlo9eLktBAGudZ+29vzcmT5xplxt0dANg++1I48YotDRwLM
         GwGxD56+B6iOozJKIs2MQu8imoX2vy3UmMztuS3TMK5ws8nKKEqjYafRKD81JJxYNe9M
         zz/HqwIG3rG55KpqxJwDzpWbI86FALNQ/8Xik2KmkA0mrfO+ihtUcCvx/On8dlihlmPA
         ylmrHasrpLtbs+tLdVpDzDkzh6rNf1HfQQ5i9fanxnByt9XGDv8cfy0Y0+oJeHxvo/EL
         qtwA==
X-Gm-Message-State: AOAM530cvNq42YXIysiVjszgwJL7dgYch51n0NGSXc4FE1mNH430DbGZ
        o9zF6P2X7RAEKyo1fcVKi41o9j2DqwM=
X-Google-Smtp-Source: ABdhPJzvnGKIejSHtGzdnoXxS/QQJchyfKdKgafUeAPUHAKE+xzHrlStonjr4WLE+5Gqp+KRi7jEzg==
X-Received: by 2002:a17:90a:6b0a:: with SMTP id v10mr51372402pjj.130.1636375452979;
        Mon, 08 Nov 2021 04:44:12 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id e7sm12425773pgk.90.2021.11.08.04.44.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:44:12 -0800 (PST)
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
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
Subject: [PATCH 01/15] KVM: X86: Ensure the dirty PDPTEs to be loaded
Date:   Mon,  8 Nov 2021 20:43:53 +0800
Message-Id: <20211108124407.12187-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

For VMX, the dirty PDPTEs needs to be loaded before the coming VMENTER
via vmx_load_mmu_pgd() if EPT is enabled.

But not all paths that call load_pdptrs() will cause vmx_load_mmu_pgd()
to be invoked.  Normally, kvm_mmu_reset_context() and KVM_REQ_LOAD_MMU_PGD
are used to launch later vmx_load_mmu_pgd().

The commit d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and
CR0.NW are changed") skips kvm_mmu_reset_context() after load_pdptrs()
when changing CR0.CD and CR0.NW.

The commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
PCID on MOV CR3 w/ flush") skips KVM_REQ_LOAD_MMU_PGD after
load_pdptrs() when rewriting the CR3 with the same value.

The commit a91a7c709600("KVM: X86: Don't reset mmu context when
toggling X86_CR4_PGE") skips kvm_mmu_reset_context() after
load_pdptrs() when changing CR4.PGE.

Fixes: d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
Fixes: 21823fbda552("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
Fixes: a91a7c709600("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..034c233ea5a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -830,6 +830,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+	/* Ensure the dirty PDPTEs to be loaded. */
+	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 	vcpu->arch.pdptrs_from_userspace = false;
 
 	return 1;
-- 
2.19.1.6.gb485710b


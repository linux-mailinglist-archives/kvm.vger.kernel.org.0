Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D5E4767D0
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 03:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhLPCTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 21:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbhLPCTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 21:19:36 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E46C061574;
        Wed, 15 Dec 2021 18:19:35 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so1694818pjw.2;
        Wed, 15 Dec 2021 18:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHlWYBDqh6v+8Eq26iyVB49QB3lf0Qk0ytsCop7ODN4=;
        b=Y3kaugLFNrv4YjGCNhO/0pRNlkKaKvAGA92q6IpF9FewQI7Epb3FhgL3k6IFTH76ui
         AOuYW1J249XDeTHW7yGxpTUR37EcafQwEnebq1l+BS5NMysoRr8XmO4KLonzvvt6TvRX
         AQu4oT4Hto5x73vD3kdwfWjwCRjSIKvXO/eYVAVzB23o6n6nlm0uwkp1SZdWkxhh2sPE
         D3lrBfUW5KgtCJRXDpg68o/d/sRImGgApdnc74E3SavNAdi1+pQZ0pU9NS+uTLsy/afA
         WAfy3aXt0oyM1aIW09Q0Q0d6tjKx4EoIdZa6xuuxFkJWDo1TKF6Erl1Y+UW293p3Yfvw
         7gMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHlWYBDqh6v+8Eq26iyVB49QB3lf0Qk0ytsCop7ODN4=;
        b=coCs551IiHcb/QIF0TuZkTp4cA6KQiXn7FJzjnv/BXxN9BaxWUXWtiRD/8vxj+gUD+
         uIjud/5iDYrFMGv8Mqi2UNZ5cd9ytMGqv1R2IBb6X8MoE5Xr/HJalo9VdfOmXcYHX86F
         KQ5z+j4z5y8Tj0sPhtSEUuDwJkWsnyjy4+KY2sR9GSwmn2noR6I/fnThYdtAu09ntQBT
         4GlOljiwbJtZMP3FfQ5vgW6m7gaepbOC24vBiEAJqFGb4Yo2E6WM2+odjHNxVgSvSPcY
         aOy+Y5xVzebfbpVBu5BnUdSGXao3x+6+oHyoSzq5Z1UoZ6Wbp7/BLuH9BCc5AfuDm9m/
         3pJw==
X-Gm-Message-State: AOAM530Hq5vuPi0JTYXePr0/CU1VyERgZOgNCoo4pTWqfNtSf+VfE3Gr
        IDbDpzSbIf2aD2BFu/IBniwh4HDH/unzPA==
X-Google-Smtp-Source: ABdhPJyPMQ7DyLG96vUVz2FgfH181oTmVeKmaIfbmV17Hvb0ZyxSDWT7OzAtjzTan0LuOsmQbF8dmw==
X-Received: by 2002:a17:90b:1e4f:: with SMTP id pi15mr3294970pjb.181.1639621175018;
        Wed, 15 Dec 2021 18:19:35 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id k22sm4057959pfu.72.2021.12.15.18.19.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Dec 2021 18:19:34 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
Subject: [PATCH V2 2/3] KVM: x86/mmu: Ensure pae_root to be reconstructed for shadow paging if the guest PDPTEs is changed
Date:   Thu, 16 Dec 2021 10:19:37 +0800
Message-Id: <20211216021938.11752-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211216021938.11752-1-jiangshanlai@gmail.com>
References: <20211216021938.11752-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

For shadow paging, the pae_root needs to be reconstructed before the
coming VMENTER if the guest PDPTEs is changed.

But not all paths that call load_pdptrs() will cause the pae_root to be
reconstructed. Normally, kvm_mmu_reset_context() and kvm_mmu_free_roots()
are used to launch later reconstruction.

The commit d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and
CR0.NW are changed") skips kvm_mmu_reset_context() after load_pdptrs()
when changing CR0.CD and CR0.NW.

The commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
PCID on MOV CR3 w/ flush") skips kvm_mmu_free_roots() after
load_pdptrs() when rewriting the CR3 with the same value.

The commit a91a7c709600("KVM: X86: Don't reset mmu context when
toggling X86_CR4_PGE") skips kvm_mmu_reset_context() after
load_pdptrs() when changing CR4.PGE.

Guests like linux would keep the PDPTEs unchanged for every instance of
pagetable, so this missing reconstruction has no problem for linux
guests.

Fixes: d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
Fixes: 21823fbda552("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
Fixes: a91a7c709600("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af22ad79e081..71c389a47801 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -841,6 +841,13 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 		}
 	}
 
+	/*
+	 * Marking VCPU_EXREG_PDPTR dirty doesn't work for !tdp_enabled.
+	 * Shadow page roots need to be reconstructed instead.
+	 */
+	if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
+		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
+
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
-- 
2.19.1.6.gb485710b


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092EE447FA1
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239631AbhKHMrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbhKHMrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:16 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB7DC061714;
        Mon,  8 Nov 2021 04:44:31 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id p8so13711429pgh.11;
        Mon, 08 Nov 2021 04:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tufklCvQLXjLmL93FLlua3ov52AUTNVIPedxDPFEtnU=;
        b=oGARxUBotZQ2W3nb/efsf/1by+ygeBAnVm0MouFdlFYtFOXPHEzMguUIyoeDa43zFH
         KA4nwD8IhhVbXn7wV5SyXs5aMthCf485iLegmcp15LMK4N+FnBlbt4e2r+gHkoPJ0pdI
         bJh9pINGfWzV4hXsLTKwACySLa9UBoTwuPkue1wRrKBcca9KBpgWNWhk2LSRYBQM0RYl
         S7E0z4qOjfM+LMNB9lNTYMCav8hMviPFQCUhZ5HqtE9NveeKw9BxcR6zJ6AepcfaLO3J
         cyCBvAIq1aEHzcMfraOc7J6/nui8i5h/qH+OzRHCqxhUpCZRTSfmaPy6PdiIniRZAti2
         ouFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tufklCvQLXjLmL93FLlua3ov52AUTNVIPedxDPFEtnU=;
        b=S/tMunwISV1K6e+meViWz9gobdSwoD8ICHpPcK8dGg1ZhI2kLoEofzBuuOpsgfSv9N
         6yLivJtdE9Evg9ohHfZGeTynBOiYS0GORANJqsNbXQQ54TSaNd68mRKpabHbMtX4OxKH
         yaLK50Ns5cxyt6AHKKYk87SAZGsZbhcwJ6yqZxdHAuFv3KX0CLGJXKZX5LX79R5L1+yU
         vlAyJG82H9fWKfGW+iC7d2NJWQ/kgo259bFj+ot5Q0L8m3v6xMFzotx3hc8as56Rh3CZ
         0gZm8GKTyJQkEQVTQ23VRi4AJKH6dQmyv4MQ7AqiMsSHjWZZ7Cs79A4YNqA38OrDVGSY
         6cwQ==
X-Gm-Message-State: AOAM533nrdsCIgtb8FRDO4Au8Ev+XZbZTWT/kH0v4VhlRqfi8fQ5Qz6h
        ZzgjNAV7/t6q2gWdRBgr7mJn8fa2dj0=
X-Google-Smtp-Source: ABdhPJxVQMSkAAyqB29vEoilI7bdxZpenTzrsPHDEuLs3THJ+ZglltxW/jDrq9+Qko0r1KZMU3PfnA==
X-Received: by 2002:a63:854a:: with SMTP id u71mr46731407pgd.174.1636375471310;
        Mon, 08 Nov 2021 04:44:31 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id u11sm2587076pfk.152.2021.11.08.04.44.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:44:30 -0800 (PST)
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
Subject: [PATCH 04/15] KVM: VMX: Add and use X86_CR4_TLB_BITS when !enable_ept
Date:   Mon,  8 Nov 2021 20:43:56 +0800
Message-Id: <20211108124407.12187-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In set_cr4_guest_host_mask(), X86_CR4_PGE is set to be intercepted when
!enable_ept just because X86_CR4_PGE is the only bit that is
responsible for flushing TLB but listed in KVM_POSSIBLE_CR4_GUEST_BITS.

It is clearer and self-documented to use X86_CR4_TLB_BITS instead.

No functionality changed.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 2 ++
 arch/x86/kvm/vmx/vmx.c        | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 90e1ffdc05b7..8fe036efa654 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -9,6 +9,8 @@
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
 
+#define X86_CR4_TLB_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)
+
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
 {									      \
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 79e5df5fbb32..1795702dc6de 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4107,7 +4107,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
 					  ~vcpu->arch.cr4_guest_rsvd_bits;
 	if (!enable_ept)
-		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_PGE;
+		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_TLB_BITS;
 	if (is_guest_mode(&vmx->vcpu))
 		vcpu->arch.cr4_guest_owned_bits &=
 			~get_vmcs12(vcpu)->cr4_guest_host_mask;
-- 
2.19.1.6.gb485710b


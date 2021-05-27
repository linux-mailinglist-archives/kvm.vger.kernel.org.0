Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408BA392DE5
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbhE0MZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 08:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbhE0MZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 08:25:50 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C43C061574;
        Thu, 27 May 2021 05:24:17 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d78so434697pfd.10;
        Thu, 27 May 2021 05:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DNgCYPsiAmP4Dyq0SqF2LavFgHResxue5gZuOKqTCTo=;
        b=LZbQvTSspQCnXldbjiWssLU4xUYEJSH54s7488V+enpYivJpUUOQGCCqM5zVbQdIam
         +5gWZMoMBNMqaXY+tWtvoFKGn+jcZgkFCTzF/KmuxgMnxpBTVt9aCB5Jk6p3a+GZ2Alw
         np89SubG+3zL1FrZ9xlk8vybHAP0aGJlI0qqSWX+5ffSgNO8/Xv2IW7ypcOgh/hU+ME9
         m8enROfUH5oQnfQFv1gOExuUB5xkfZiBBQmzKNFKZY9bj7qwsZKv2P5k4jk/AxCbod6G
         JGErIXfGCeFwvgkFjnWodECTXvr+9ll2w2nA8CR/dL6MV2IYNhN/qXxvpMFrot8t+9vc
         0Erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DNgCYPsiAmP4Dyq0SqF2LavFgHResxue5gZuOKqTCTo=;
        b=GBJdQJIE8gg8esUHiEiV9KhmJsSKbU+iA9+xRDFRFoKRvCj7ghULka5RuGCzbGrPJm
         KXwHcrH2kF+2V0EQSh0lLDzdsNFkTtXNW6Vj03xN0xQA/tLJixCI2uctumkB1sAuuw8t
         11mJ/Qkdebq5WB0fdcCIOkbxtnNroNmH58d2Jj6qGe16yyJ2gCy5qd00hpOS7EiwagVm
         ItqaZLn4a+K2G+ETo0LeK9Cp1qONMLmLlvyJKda527F3yXuy+oZ0sTJNPldqF09S9OIH
         lB8kTN3u04dm9bc0coHDySZeJLUyaFHVaoA/qVa4wHpHDY7A12gcKkCaKEsTiKED2paN
         ZzGw==
X-Gm-Message-State: AOAM531W2UTxRBfumW0RutHMrbCO3ahJm0kX85h9U3heQ5QgeovwULZj
        TKHjfCPPnayPgmcGWaxOHXxtO2cB4Pw=
X-Google-Smtp-Source: ABdhPJxm1lkzPIGUYRgLyp5+PcNfUfq+BDc4a2l+8W32D0pUn1mm61ACUdaZesQPVCWEzlukDQtsSw==
X-Received: by 2002:a63:7048:: with SMTP id a8mr3537645pgn.194.1622118256436;
        Thu, 27 May 2021 05:24:16 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id p1sm1825576pfp.137.2021.05.27.05.24.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 May 2021 05:24:15 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH] KVM: X86: fix tlb_flush_guest()
Date:   Thu, 27 May 2021 10:39:21 +0800
Message-Id: <20210527023922.2017-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

For KVM_VCPU_FLUSH_TLB used in kvm_flush_tlb_multi(), the guest expects
the hypervisor do the operation that equals to native_flush_tlb_global()
or invpcid_flush_all() in the specified guest CPU.

When TDP is enabled, there is no problem to just flush the hardware
TLB of the specified guest CPU.

But when using shadowpaging, the hypervisor should have to sync the
shadow pagetable at first before flushing the hardware TLB so that
it can truely emulate the operation of invpcid_flush_all() in guest.

The problem exists since the first implementation of KVM_VCPU_FLUSH_TLB
in commit f38a7b75267f ("KVM: X86: support paravirtualized help for TLB
shootdowns").  But I don't think it would be a real world problem that
time since the local CPU's tlb is flushed at first in guest before queuing
KVM_VCPU_FLUSH_TLB to other CPUs.  It means that the hypervisor syncs the
shadow pagetable before seeing the corresponding KVM_VCPU_FLUSH_TLBs.

After commit 4ce94eabac16 ("x86/mm/tlb: Flush remote and local TLBs
concurrently"), the guest doesn't flush local CPU's tlb at first and
the hypervisor can handle other VCPU's KVM_VCPU_FLUSH_TLB earlier than
local VCPU's tlb flush and might flush the hardware tlb without syncing
the shadow pagetable beforehand.

Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
 arch/x86/kvm/vmx/vmx.c |  8 +++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 05eca131eaf2..f4523c859245 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3575,6 +3575,20 @@ void svm_flush_tlb(struct kvm_vcpu *vcpu)
 		svm->current_vmcb->asid_generation--;
 }
 
+static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * When NPT is enabled, just flush the ASID.
+	 *
+	 * When NPT is not enabled, the operation should be equal to
+	 * native_flush_tlb_global(), invpcid_flush_all() in guest.
+	 */
+	if (npt_enabled)
+		svm_flush_tlb(vcpu);
+	else
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
+}
+
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4486,7 +4500,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.tlb_flush_all = svm_flush_tlb,
 	.tlb_flush_current = svm_flush_tlb,
 	.tlb_flush_gva = svm_flush_tlb_gva,
-	.tlb_flush_guest = svm_flush_tlb,
+	.tlb_flush_guest = svm_flush_tlb_guest,
 
 	.run = svm_vcpu_run,
 	.handle_exit = handle_exit,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bceb5ca3a89..1913504e3472 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3049,8 +3049,14 @@ static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	 * are required to flush GVA->{G,H}PA mappings from the TLB if vpid is
 	 * disabled (VM-Enter with vpid enabled and vpid==0 is disallowed),
 	 * i.e. no explicit INVVPID is necessary.
+	 *
+	 * When EPT is not enabled, the operation should be equal to
+	 * native_flush_tlb_global(), invpcid_flush_all() in guest.
 	 */
-	vpid_sync_context(to_vmx(vcpu)->vpid);
+	if (enable_ept)
+		vpid_sync_context(to_vmx(vcpu)->vpid);
+	else
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 }
 
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu)
-- 
2.19.1.6.gb485710b


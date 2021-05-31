Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA71396BBF
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 05:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhFADJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 23:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhFADJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 23:09:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E13C061574;
        Mon, 31 May 2021 20:07:52 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so590040pjp.4;
        Mon, 31 May 2021 20:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fnde0TSdARqxO9kSs13/SSOz1om8WwuYNp5DKhajpUY=;
        b=B/qoPp6wf4jPcO8Jz07KXKT1S/lni56MpVc8gv5FXgnq/Vqeq5l0vRSAWxXrFQ5VYp
         tWZh8zM+qsVxQ4T480LymaylbeVv2YVEaEUKWBmYMP6caq8AHf9MNihrwzgj2Y1bKzUS
         IbCzVmgzR7d3OawZuKrjCh1+PRei2sOGlg3jj9YaA5Lqai23sj4n80IzNYlHJIJqHHTm
         o5hUkrwfgn7qu24BpwYyr0GdkqXmGyXRmxEVGdZ08snv0r5jY/RsyOzPZQQn25Xd/41W
         ffTOUyoTNIxS3P3p32dhKwp9WpyvA1SFLVhMqHGL0d/bZSOYbIMPHpLA9/LK/u0fO3qV
         Wvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fnde0TSdARqxO9kSs13/SSOz1om8WwuYNp5DKhajpUY=;
        b=BMIFrcp0oWwopdrJzkm592rB8FZ592tt5ElaTymc5JDNHnDFdCvT/aWIjLhbOE+hP8
         BHdD6PB54ki8CWaGzr0iOFGnyzxWMvRIpqhyRrNYHABL+s2CV+F2u532q0B+htTKKtc1
         9OrgktvDStznLdKlRXnX/wz9V8oDexw4ZsgejaeevnpBDSOFFnF28XOFaAaCeZaDxgh7
         K5dI41C05egipJYmgccwBy36pqonNRVcf9nRlZq+Kzr96Ll9B8UNV8Gzyw2LOuaO9+2U
         uc79/myZy6cZaNH0ua/AqhajO4BuwYXhZ8cTNMkxFWopeEtuXEhNUiDpqKaJ0qkyoguh
         14Cw==
X-Gm-Message-State: AOAM533VDpCHj1Fi3rJD6pg9akiPk0z2dZjAERAANPnQTT++IkGv1RrR
        0Kf4BZ1Z/FG8dD4c08KdlFVliXQS8pw=
X-Google-Smtp-Source: ABdhPJwIX7XSgfzQDQRsvlKuOyZxokTUu4ySbjnqiDpZWKPLdxB+5vzrCxUQ8WXR/0dmkxMXLninLA==
X-Received: by 2002:a17:902:ed82:b029:ef:48c8:128e with SMTP id e2-20020a170902ed82b02900ef48c8128emr23538047plj.72.1622516871966;
        Mon, 31 May 2021 20:07:51 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id h63sm2992888pfe.104.2021.05.31.20.07.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 May 2021 20:07:51 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
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
Subject: [PATCH V2] KVM: X86: fix tlb_flush_guest()
Date:   Tue,  1 Jun 2021 01:22:56 +0800
Message-Id: <20210531172256.2908-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <4c3ef411ba68ca726531a379fb6c9d16178c8513.camel@redhat.com>
References: <4c3ef411ba68ca726531a379fb6c9d16178c8513.camel@redhat.com>
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

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
Changed from V1
	Use kvm_mmu_unload() instead of KVM_REQ_MMU_RELOAD to avoid
	causing unneeded iteration of vcpu_enter_guest().

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04e67ad..27248e330767 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3072,6 +3072,22 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
+
+	if (!tdp_enabled) {
+		/*
+		 * When two dimensional paging is not enabled, the
+		 * operation should equal to native_flush_tlb_global()
+		 * or invpcid_flush_all() on the guest's behalf via
+		 * synchronzing shadow pagetable and flushing.
+		 *
+		 * kvm_mmu_unload() results consequent kvm_mmu_load()
+		 * before entering guest which will do the required
+		 * pagetable synchronzing and TLB flushing.
+		 */
+		kvm_mmu_unload(vcpu);
+		return;
+	}
+
 	static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 
-- 
2.19.1.6.gb485710b


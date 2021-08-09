Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E917E3E5181
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 05:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbhHJD3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 23:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbhHJD2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 23:28:44 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7888FC06179A;
        Mon,  9 Aug 2021 20:28:22 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c16so19096809plh.7;
        Mon, 09 Aug 2021 20:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQaSu3/uNQlLHnyxKtqiLR/ueYipRzXi0gFVIbgJ54I=;
        b=F5Cq35dGPpe5HlnZMU3GHX7E7V9ET5CZBOUM6Vyvf7JLIr07COtmMYAzqcdjhvgCdN
         9C5HkyX6UWAnN2dKNH1cjen4z3X2QG6r/O7A62viI6Sbxnk/6Prl6QEqO9SF1V14n0V8
         BehTnXMfSYyyx4nykirRBJNVyB2o521fa/00s3uPQ+0MuscZ8O2gOA5ziGX4lqJMh3zk
         0oxQWFc10qo//DvQmXaYzFU7OSxPaznTsrg7SrmEjtYQMaBAEjCh3hLxNwBoLeI2IuEU
         PiIAlTEazqTv31iWiY16gVNKRoB1caL8GQAIrT3/SN5V/2/xo8ofdlJEjKkMSy2d5AtQ
         7TKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQaSu3/uNQlLHnyxKtqiLR/ueYipRzXi0gFVIbgJ54I=;
        b=WZGkH1Rui0g1aFbGjggsLlKW6af6tSYk/+6pSYFhVu0DVaYqO0BmhV9bdpIp53RcVq
         FT/vCvKRoD1uZGR4cCVUGwmBD+CRTeHIr1rd9Q17bnBWYsBhgIVnUPxNpqIIhWVCTSVz
         aHohjnkiOSAUNkMD59B54E+VsDFMkZzY7dqxeI2bQcorvmHHUfK7NylAcH5jBwCNq8jJ
         hUxZQ63VxNEoONn+dxBm2A7N46Eyq+cyldGEsejH2at/JGa+sGXhH1NqxJZxI3pVyqlW
         KdHlpA+oKhqE2KPX5Bt5py8WZsj85pWZDcKFR8PYJWtpwEPwwAIJx5UNgsgnePx6cJq/
         cQ7g==
X-Gm-Message-State: AOAM5317znHvzjUbv7/4ZilvM+W6AsikgsCwoU9G/46pfSaL1y33K9T8
        MSrbruIVTwvuFTlm720NPjmmWvooI3w=
X-Google-Smtp-Source: ABdhPJzEjXv5vh/rIyYWJn3jIsi83U0AqC8CMvkaWXbITe3simdU5QuMcmARBJF8OPPzkukw3JqxiQ==
X-Received: by 2002:a65:6658:: with SMTP id z24mr52181pgv.266.1628566101983;
        Mon, 09 Aug 2021 20:28:21 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id e12sm19862037pjh.33.2021.08.09.20.28.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 20:28:21 -0700 (PDT)
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
        kvm@vger.kernel.org
Subject: [PATCH V2 3/3] KVM: X86: Reset DR6 only when KVM_DEBUGREG_WONT_EXIT
Date:   Tue, 10 Aug 2021 01:43:07 +0800
Message-Id: <20210809174307.145263-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210809174307.145263-1-jiangshanlai@gmail.com>
References: <YRFdq8sNuXYpgemU@google.com>
 <20210809174307.145263-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The commit efdab992813fb ("KVM: x86: fix escape of guest dr6 to the host")
fixed a bug by reseting DR6 unconditionally when the vcpu being scheduled out.

But writing to debug registers is slow, and it can be shown in perf results
sometimes even neither the host nor the guest activate breakpoints.

It'd be better to reset it conditionally and this patch moves the code of
reseting DR6 to the path of VM-exit and only reset it when
KVM_DEBUGREG_WONT_EXIT which is the only case that DR6 is guest value.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2aa49722064..f40cdd7687d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4309,12 +4309,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
-	/*
-	 * If userspace has set any breakpoints or watchpoints, dr6 is restored
-	 * on every vmexit, but if not, we might have a stale dr6 from the
-	 * guest. do_debug expects dr6 to be cleared after it runs, do the same.
-	 */
-	set_debugreg(0, 6);
 }
 
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
@@ -9630,6 +9624,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
+		/* Reset Dr6 which is guest value. */
+		set_debugreg(DR6_RESERVED, 6);
 	}
 
 	/*
-- 
2.19.1.6.gb485710b


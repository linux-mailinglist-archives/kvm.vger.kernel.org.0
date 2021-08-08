Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDC03E423D
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 11:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbhHIJOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 05:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhHIJOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 05:14:31 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F22C0613CF;
        Mon,  9 Aug 2021 02:14:11 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f3so5040926plg.3;
        Mon, 09 Aug 2021 02:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9+lePBuSqGbHWb7b9q5oyrUY4RW0y6COAp8Vm5hWWA=;
        b=o8UBzIGNDTZsevHxmWwA3WBb89p0jwDO1lHlqeiwBcM1ugNsdBGxf1RJWyLXCpFqjB
         W5ln2eG/mRL+yPvSDn/tyw7U0KP6bevUxRsx4XFrXCzUnCYjN0IYdw151LVZ3VN5/XLK
         6TiV9pcsVDUsWcSgfbWy2sqXaxKKEA4J4laKWS4mHIXXTNGOxAdazyoYGRAAL8N/sJW7
         PG1gpCN41Tw+LwB+W2O0lUmBidnQHy1Ttu6gl6KpOR4Sj9rqvD/Far3kjXAxc6xY3mHr
         Am+0+hG4CATnZro2xDA6EzOEj7ivV3sCSqVMG+ocm57I+6NBVrFbhdM/xK81p26Q257x
         i6eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9+lePBuSqGbHWb7b9q5oyrUY4RW0y6COAp8Vm5hWWA=;
        b=RANLm9knY2h/ohzGKp8t9Y74GPHy7pgZYrchIC9ire7iuXEdrDZdxDJatp4F3katg/
         9sQ/4nyPk147RKKSx+QjTD3Bdf9wqOpR7xbMSutZ/qRSH+/pVTf19LPFngejpP8vWv+p
         hXjNpbXJ7O4ZRwvx6dJVOkPyLpOazB0Pv+zSoJb0+yAcSFZ98fZa0d27a1tRlARjrb4i
         s9Mx702rBEGDZo+L2x/idNiMwNvS6FZLsc2h7XzeBN03priNTmvYp5iMe6Xr5J1JJp5A
         B2WcqnjD/rszrIVaeQ736Bnr8bkyfeHAZQ7LiJKD1LbFuoWYEb8OKY2mPbgu4yL5/VPr
         a8vA==
X-Gm-Message-State: AOAM533DSvHu8CnhX0DddRFnNp8eaBNWatii1aFxWOWY7fvBRl9etVw1
        0+u8dbgw45jkFT075nIFvlQDRFx1x/A=
X-Google-Smtp-Source: ABdhPJwcZy4LkWv84hU5BIzfGMBWQfnbLuErD9eHQ/sOHXJ06SLTnvMKnw0MmM3oa8VJOCDTqTA7bQ==
X-Received: by 2002:a05:6a00:188e:b029:3c3:1142:15f2 with SMTP id x14-20020a056a00188eb02903c3114215f2mr23050720pfh.36.1628500450924;
        Mon, 09 Aug 2021 02:14:10 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id fa21sm1179426pjb.20.2021.08.09.02.14.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:14:10 -0700 (PDT)
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
Subject: [PATCH] KVM: X86: Don't reset dr6 unconditionally when the vcpu being scheduled out
Date:   Mon,  9 Aug 2021 07:29:19 +0800
Message-Id: <20210808232919.862835-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The commit efdab992813fb ("KVM: x86: fix escape of guest dr6 to the host")
fixed a bug.  It did a great job and reset dr6 unconditionally when the
vcpu being scheduled out since the linux kernel only activates breakpoints
in rescheduling (perf events).

But writing to debug registers is slow, and it can be shown in perf results
sometimes even neither the host nor the guest activate breakpoints.

It'd be better to reset it conditionally and this patch moves the code of
reseting dr6 to the path of VM-exit where we can check the related
conditions.  And the comment is also updated.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
And even in the future, the linux kernel might activate breakpoint
in interrupts (rather than in rescheduling only),  the host would
not be confused by the stale dr6 after this patch.  The possible future
author who would implement it wouldn't need to care about how the kvm
mananges debug registers since it sticks to the host's expectations.

Another solution is changing breakpoint.c and make the linux kernel
always reset dr6 in activating breakpoints.  So that dr6 is allowed
to be stale when host breakpoints is not enabled and we don't need
to reset dr6 in this case. But it would be no harm to reset it even in
both places and killing stale states is good in programing.

 arch/x86/kvm/x86.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4116567f3d44..39b5dad2dd19 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4310,12 +4310,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
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
@@ -9375,6 +9369,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	fastpath_t exit_fastpath;
 
 	bool req_immediate_exit = false;
+	bool reset_dr6 = false;
 
 	/* Forbid vmenter if vcpu dirty ring is soft-full */
 	if (unlikely(vcpu->kvm->dirty_ring_size &&
@@ -9601,6 +9596,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 		set_debugreg(vcpu->arch.dr6, 6);
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
+		reset_dr6 = true;
 	} else if (unlikely(hw_breakpoint_active())) {
 		set_debugreg(0, 7);
 	}
@@ -9631,17 +9627,34 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_update_dr0123(vcpu);
 		kvm_update_dr7(vcpu);
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
+		reset_dr6 = true;
 	}
 
 	/*
 	 * If the guest has used debug registers, at least dr7
 	 * will be disabled while returning to the host.
+	 *
+	 * If we have active breakpoints in the host, restore the old state.
+	 *
 	 * If we don't have active breakpoints in the host, we don't
-	 * care about the messed up debug address registers. But if
-	 * we have some of them active, restore the old state.
+	 * care about the messed up debug address registers but dr6
+	 * which is expected to be cleared normally.  Otherwise we might
+	 * leak a stale dr6 from the guest and confuse the host since
+	 * neither the host reset dr6 on activating next breakpoints nor
+	 * the hardware clear it on dilivering #DB.  The Intel SDM says:
+	 *
+	 *   Certain debug exceptions may clear bits 0-3. The remaining
+	 *   contents of the DR6 register are never cleared by the
+	 *   processor. To avoid confusion in identifying debug
+	 *   exceptions, debug handlers should clear the register before
+	 *   returning to the interrupted task.
+	 *
+	 * Keep it simple and live up to expectations: clear DR6 immediately.
 	 */
 	if (hw_breakpoint_active())
 		hw_breakpoint_restore();
+	else if (unlikely(reset_dr6))
+		set_debugreg(DR6_RESERVED, 6);
 
 	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
-- 
2.19.1.6.gb485710b


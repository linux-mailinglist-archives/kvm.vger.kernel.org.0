Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABEC30C6CA
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbhBBQ6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhBBQ4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 11:56:05 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6F5C061573
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 08:55:50 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id d8so15384272qvs.1
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 08:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=4vQ54utvl5pYCDc2RGTnD5j/mRhLCg57OZJNdDMaGn4=;
        b=T0Z94yO1HKcNcauNpnGQV5NoiEPiLhWX96qMGEYfVm8iVuHq3WK0T3f48qxJmcP/L0
         MwxkiWpkpJeDBnPwg5tv2PaZ/LlFqABU9ikuqKHO6ZpJZ1dABjxSvbXfpvBwiY098jKA
         CNgR7EmkK/37q4cQxSJ/Wzz8piqqe6W5zPB2LfP3+00EisR/SeN9et5mgJnEY8jhMstA
         B6k0pMdDcmaJTtK1pHBQcle76Kvux6qaxNgGuqHtBG/rjy1/n7tu67JKcXlVVU88ukJQ
         9X5fhCz2DR2Bk05KxHXzM91nASnHsBSFGRrT76s8M27iZzfK+zXxTuBrWVilTqmbsYK+
         Is6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=4vQ54utvl5pYCDc2RGTnD5j/mRhLCg57OZJNdDMaGn4=;
        b=isAYUJqmI2vThM/exOr8rQx0GPptPWzsSa4hqI+CxNzpaWEhu0XLiz7oBIM0j4ZrIM
         3f3TCfTwPZwMp7m965bT9ZOE8SWKSnyNz6SJsVNG68stwQUsfjVlW+CrXeBhmZloVDtN
         Wh7h/3uuvO5XoHthahcDCYu8pMmLneL11DN9auxD8viyUsHAf3lqcDRWhfpY/9gpREhf
         4JZmyldn8wGC8QpZUhBeRHK4xC/MwdzN/785ogxUr7VFU1YcHUe10LmeAc+qFluBeUMi
         6qtkqyiweI3hxsZE8HXLtD342VaSnzgJ8mhNkdyeI+QzN176jl3GN9U2DA7AO9gz+AXs
         U1HQ==
X-Gm-Message-State: AOAM530W+YENMbvxMkXNILuh3KsNIlnoyQND7B3dw8mdUX7Lj101wfiH
        C8+K+1EMoCRe4DXf0NuYtQN/4Tvk+jI=
X-Google-Smtp-Source: ABdhPJxkq5VoLdV5TO59a0Enr0ROoksiV8FPHe+Pg9IjpRVfG1jvvaeGXaLW05XydcJXmkuiCs+SgAY6tpo=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
 (user=seanjc job=sendgmr) by 2002:ad4:4cd0:: with SMTP id i16mr21054987qvz.49.1612284949841;
 Tue, 02 Feb 2021 08:55:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Feb 2021 08:55:46 -0800
Message-Id: <20210202165546.2390296-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH] KVM: x86: Update emulator context mode if SYSENTER xfers to
 64-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonny Barker <jonny@jonnybarker.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the emulator context to PROT64 if SYSENTER transitions from 32-bit
userspace (compat mode) to a 64-bit kernel, otherwise the RIP update at
the end of x86_emulate_insn() will incorrectly truncate the new RIP.

Note, this bug is mostly limited to running an Intel virtual CPU model on
an AMD physical CPU, as other combinations of virtual and physical CPUs
do not trigger full emulation.  On Intel CPUs, SYSENTER in compatibility
mode is legal, and unconditionally transitions to 64-bit mode.  On AMD
CPUs, SYSENTER is illegal in compatibility mode and #UDs.  If the vCPU is
AMD, KVM injects a #UD on SYSENTER in compat mode.  If the pCPU is Intel,
SYSENTER will execute natively and not trigger #UD->VM-Exit (ignoring
guest TLB shenanigans).

Fixes: fede8076aab4 ("KVM: x86: handle wrap around 32-bit address space")
Cc: stable@vger.kernel.org
Signed-off-by: Jonny Barker <jonny@jonnybarker.com>
[sean: wrote changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 56cae1ff9e3f..66a08322988f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2879,6 +2879,8 @@ static int em_sysenter(struct x86_emulate_ctxt *ctxt)
 	ops->get_msr(ctxt, MSR_IA32_SYSENTER_ESP, &msr_data);
 	*reg_write(ctxt, VCPU_REGS_RSP) = (efer & EFER_LMA) ? msr_data :
 							      (u32)msr_data;
+	if (efer & EFER_LMA)
+		ctxt->mode = X86EMUL_MODE_PROT64;
 
 	return X86EMUL_CONTINUE;
 }
-- 
2.30.0.365.g02bc693789-goog


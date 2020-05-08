Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9471CB90F
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 22:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgEHUhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 16:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727119AbgEHUhD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 16:37:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF5FC05BD09
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 13:37:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e2so3483431ybm.19
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 13:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bDA1/4UWq3adzuN/eFYQ6blf4dCGtForBLd4rlJVQeQ=;
        b=KmJ03/aH3GNYNIjMppA4tkWIBFQOpt/I9LWla5xHPJOe2xUqR1mXebaYnz+u43orHd
         ksABti4aur9lE2CaeeXV8L5OZg+zbw4+Pr3N3D9U0nds/H5NByo/VAojx/Ht9BWz3txy
         FJ64rA0hKG1FZrjNap/oZHV1PBe9HaXotsbRb9JGfsqaXlgAt18YLnelLnPb58XhLc56
         Ic8JR1pR97RwGgh1D8lC5FIyZBLjNQbDmB+bP0cfBMIGepQUhzhGPBScP84AR+X4+l/w
         FpLceRZiFmsM8+5RchzuneWNzLFCigbYk3ssVkK94VMdHel4f2aWS9/p0X2qZCgd4S+t
         o4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bDA1/4UWq3adzuN/eFYQ6blf4dCGtForBLd4rlJVQeQ=;
        b=qEXKjZc/OO+BygQJkuaA4yMEwVPFXU4TeHVwgCVS2Lk/PlPQX7Cb8lAZUfhAI0s3Yw
         kVpQqw6as/A4D4ARfEEVCkNFZm4vegHJi2ekLEpwh2CwF+mpcS7AofACBt9Mx43yIT8f
         BX2smQigcarY3iDW2dUxB9WMlDhLP1gQo6tB+d/ypYx73KnzK9rae6MgPf4LJ1z5b5j2
         sPAaC1rxBkmf8MsqUuStLHbc860y7P4UGK9tSMUmKB+S3kR058w8eMIb0XeaCE4Et3eQ
         mJubDCzN17jSaL3MQ5N/Jk7U8ZymyjE1MDcayp6qveoZz8c0yX6SZgvjsDwM7nQYK3Wv
         cF4w==
X-Gm-Message-State: AGi0PuaHeIhpkyUEVibtX6JPeZrKh0Is+1tt2JK8JX9+OUzbzFsZgNgX
        1SBiqxa+/URr80LUlzaw/6OzCFI0ZW09/WYEw8X+oP7btZgsxlF+69IVAFqwzOLY4FviL87222w
        iv98q2UZj47Pn6hCH/1MD+LOfjfPFgGhgkdAkVwFnC5K/4kVhHVaQLPddgms13cI=
X-Google-Smtp-Source: APiQypLLKa9+gLSOiHY7sDhxzhx+tvo03jD6CV3zZ4lMk9RLpxYBNHJvvfIFNrQjcKigi5IfEsnBg1FBmzhNwg==
X-Received: by 2002:a25:ce88:: with SMTP id x130mr1178224ybe.523.1588970222696;
 Fri, 08 May 2020 13:37:02 -0700 (PDT)
Date:   Fri,  8 May 2020 13:36:42 -0700
In-Reply-To: <20200508203643.85477-1-jmattson@google.com>
Message-Id: <20200508203643.85477-3-jmattson@google.com>
Mime-Version: 1.0
References: <20200508203643.85477-1-jmattson@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH 2/3] KVM: nVMX: Change emulated VMX-preemption timer hrtimer
 to absolute
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare for migration of this hrtimer, by changing it from relative to
absolute. (I couldn't get migration to work with a relative timer.)

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1f7fe6f47cbc..3ca792e3cd66 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2041,7 +2041,8 @@ static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
 	preemption_timeout *= 1000000;
 	do_div(preemption_timeout, vcpu->arch.virtual_tsc_khz);
 	hrtimer_start(&vmx->nested.preemption_timer,
-		      ns_to_ktime(preemption_timeout), HRTIMER_MODE_REL_PINNED);
+		      ktime_add_ns(ktime_get(), preemption_timeout),
+		      HRTIMER_MODE_ABS_PINNED);
 }
 
 static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
@@ -4614,7 +4615,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 		goto out_shadow_vmcs;
 
 	hrtimer_init(&vmx->nested.preemption_timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_REL_PINNED);
+		     HRTIMER_MODE_ABS_PINNED);
 	vmx->nested.preemption_timer.function = vmx_preemption_timer_fn;
 
 	vmx->nested.vpid02 = allocate_vpid();
-- 
2.26.2.645.ge9eca65c58-goog


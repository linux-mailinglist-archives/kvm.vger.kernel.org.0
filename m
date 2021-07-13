Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B133C74AB
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhGMQgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhGMQgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:41 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FD8C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:48 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id w16-20020a05620a4450b02903b88832b7cfso3103610qkp.5
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aiokP7gXEi/+lm4t4Nc0wlY5UTXEFoQdvF62MxbIn5k=;
        b=hY+meXs2gYW7Dto1FpL154fzd3T6mmPiVvvxWryypZ0ivIdoK3bMWkMbY25DhEfegn
         WnFele0LERdxBEro8TKORykXPOpJq+YCFT4B7+YJQ/CVpub97MzMr6p6xVrljB6ieD7Q
         vjjNswgIS4i5uHMOSW3uNyyfv1YkHcK56jJWb85X/a5YBPGBvWsMgMxfOqQt3chTxGPX
         gPX1qDtoqrG8/+k7qmQh6UoTyfXeZq5mIORWe1zs6ZGmMBzD8g9v5O7kCDjOKsyJB/vo
         +L8PL4EOU208ctZ+zIRwmUGppTPjjMkmcVulIuXJINLJGKGPrCVm19fq94ltXl1WKjHi
         etCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aiokP7gXEi/+lm4t4Nc0wlY5UTXEFoQdvF62MxbIn5k=;
        b=q7++S+NcFKOYXhc941GJVtuqMsiekz2euZlaaICsXIF5Zyi9lAahzKEBjwbwPmFyPh
         fzWKikfHxEwpdc7xV7i297lTomVBaL8c7FB5kfy11zbmtlJiOvDCk8jNz7M/pJRQAhFu
         2LdvXk9BSjN/I9m951OUcav95BnltnzjDpLqzM3xtVuRLH6g9XCYHccbkby94XpGDKPD
         lSyvS4WXXgV0ep86MG1HhozmzrOb/K3p2J7x2LuINaVIw3bHPjHiUTz8qli849fbazZu
         hFKd+sieOAoWe6B4GxjC085RQQajJgaBcIowPlVOUJxWvxSgMrXvaXnnLIYkhUha6KRz
         n5qQ==
X-Gm-Message-State: AOAM530MU+LCm8aJQmyIhJZikVS2cAYuseMKj3qUsqhEWK+U3Ou6kKVW
        hHGlnjBUeVgzN/C6zEFAkTo9zhOFd94=
X-Google-Smtp-Source: ABdhPJxyYzNmCbK+8PVWv/wDB2e4DroqBp9Dv2IeQbdBVHp7UYLkLgMXU7AWD+mJQV5ENWWNA3cpTjmCbT0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a05:6214:16ca:: with SMTP id
 d10mr5659095qvz.59.1626194027964; Tue, 13 Jul 2021 09:33:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:45 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 07/46] KVM: VMX: Remove explicit MMU reset in enter_rmode()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop an explicit MMU reset when entering emulated real mode now that the
vCPU INIT/RESET path correctly handles conditional MMU resets, e.g. if
INIT arrives while the vCPU is in 64-bit mode.

Note, while there are multiple other direct calls to vmx_set_cr0(), i.e.
paths that change CR0 without invoking kvm_post_set_cr0(), only the INIT
emulation can reach enter_rmode().  CLTS emulation only toggles CR.TS,
VM-Exit (and late VM-Fail) emulation cannot architecturally transition to
Real Mode, and VM-Enter to Real Mode is possible if and only if
Unrestricted Guest is enabled (exposed to L1).

This effectively reverts commit 8668a3c468ed ("KVM: VMX: Reset mmu
context when entering real mode")

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 825197f21700..0f5e97a904e5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2852,8 +2852,6 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	fix_rmode_seg(VCPU_SREG_DS, &vmx->rmode.segs[VCPU_SREG_DS]);
 	fix_rmode_seg(VCPU_SREG_GS, &vmx->rmode.segs[VCPU_SREG_GS]);
 	fix_rmode_seg(VCPU_SREG_FS, &vmx->rmode.segs[VCPU_SREG_FS]);
-
-	kvm_mmu_reset_context(vcpu);
 }
 
 int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
-- 
2.32.0.93.g670b81a890-goog


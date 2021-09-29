Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DD441CF30
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 00:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347250AbhI2W0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 18:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347230AbhI2W0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 18:26:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151C8C061767
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 15:24:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q8-20020a056902150800b005b640f67812so5440400ybu.8
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 15:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jA/+yZNk/JxzrXam1X26D9mO2Jamcx7+j7YB1HqfRTs=;
        b=ilWYhUpKoSu+A9Ev0z+ev9IThNEBLKSd8QUpjpNG8wRfE+H1q92qOq9xpgCFIsmaE/
         oxDA+AWW3VBV2zJEbhoGfhG2KZDVkXJGDz6wGaD3uoOa82D3AkAxQcDV/YHGAydCalAT
         v/m1GcF1c8E7tjkvzbNdibUzpKPOy6JpgeraXFGZf6EXz/DrsPmKFTWxPgbmSMyXAuCU
         kIbNMk3EofmN2l4pqxWQu0kNrR0ApaGluQGy9/7PZWUpvdKrBz3JotnCpQTvy5iEUEah
         NEQHJe1IjDt3d76g4/ZfgfUbTkemrVlH356IADfxPViNADdlmAsmTBOxhSW+1jQAIQjK
         dFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jA/+yZNk/JxzrXam1X26D9mO2Jamcx7+j7YB1HqfRTs=;
        b=fZJhagGU3ec0iGAvOIvEusLcwAa23GlFfvc3pBgcEF/oSW6OYn1ggxaK14lW6FX+X/
         6JiWPiEmfCb1RBGkI5uZ0Hs0uBOKXy3b7gA5J8/oP/FTDNGs9EkGCJfMBwZpzsQnysvH
         9hZNG7MMHgwxRbQLKKcFxFEF/iii05cs03qe40rfx4oazi0jSuSx6YwwtsveMx4Ux/qW
         LgoV+4vCoChad9XIg4j52ciDLrQB7Wh6z28t4xcUiykQeDXvX6OSlpPHhHk7AmR9zcyW
         aGQ8Nsqh991/10kO2X5fOp7FdmqqNG0uANLfrgFZZtuNUhfIA9h/7yiOZrMuBpGeN6xy
         b+YA==
X-Gm-Message-State: AOAM532ZwNMgxOFy0hGAVJ4nSwglP/h6+OD0rY29zB9hIKjMZveY+4MA
        8tNfyO+TVK3uDN5CGIBQMZAl1cI9Zlg=
X-Google-Smtp-Source: ABdhPJxZRQcUdjVezrrr0JGH7/t+OgTZL2k3hWSrPR1EwbkVi0PtwWxEBliTk5TWZ/5kc0JvNQ0By5+7NYQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e777:43b7:f76f:da52])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102a:: with SMTP id
 x10mr3036342ybt.36.1632954273353; Wed, 29 Sep 2021 15:24:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 29 Sep 2021 15:24:26 -0700
In-Reply-To: <20210929222426.1855730-1-seanjc@google.com>
Message-Id: <20210929222426.1855730-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210929222426.1855730-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 2/2] KVM: x86: Manually retrieve CPUID.0x1 when getting FMS
 for RESET/INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Manually look for a CPUID.0x1 entry instead of bouncing through
kvm_cpuid() when retrieving the Family-Model-Stepping information for
vCPU RESET/INIT.  This fixes a potential undefined behavior bug due to
kvm_cpuid() using the uninitialized "dummy" param as the ECX _input_,
a.k.a. the index.

A more minimal fix would be to simply zero "dummy", but the extra work in
kvm_cpuid() is wasteful, and KVM should be treating the FMS retrieval as
an out-of-band access, e.g. same as how KVM computes guest.MAXPHYADDR.
Both Intel's SDM and AMD's APM describe the RDX value at RESET/INIT as
holding the CPU's FMS information, not as holding CPUID.0x1.EAX.  KVM's
usage of CPUID entries to get FMS is simply a pragmatic approach to avoid
having yet another way for userspace to provide inconsistent data.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46ee9bf61df4..14562ea5d78d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10941,9 +10941,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
+	struct kvm_cpuid_entry2 *cpuid_0x1;
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
 	unsigned long new_cr0;
-	u32 eax, dummy;
 
 	/*
 	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
@@ -11025,12 +11025,11 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 * if no CPUID match is found.  Note, it's impossible to get a match at
 	 * RESET since KVM emulates RESET before exposing the vCPU to userspace,
 	 * i.e. it'simpossible for kvm_cpuid() to find a valid entry on RESET.
-	 * But, go through the motions in case that's ever remedied.
+	 * But, go through the motions in case that's ever remedied.  Note, the
+	 * index for CPUID.0x1 is not significant, arbitrarily specify '0'.
 	 */
-	eax = 1;
-	if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
-		eax = 0x600;
-	kvm_rdx_write(vcpu, eax);
+	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
+	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
 
 	vcpu->arch.ia32_xss = 0;
 
-- 
2.33.0.685.g46640cef36-goog


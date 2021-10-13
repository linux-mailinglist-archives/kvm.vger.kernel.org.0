Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CCD42C419
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbhJMO5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35376 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbhJMO5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:37 -0400
Message-ID: <20211013145322.451439983@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=oSFTRrG1M7hlRW5/Fmh7mVM82LlOghgD5/z1wLXfyOM=;
        b=ZaGT+Hg9QfbmHBPeWzQMFLdrI1a+5uSiAbB5/FrcLRmsJiVaCEEVGJX2DzV+HD5KRRTnJN
        tqfWgCYbs7PTp5/yb3tVd6Nj8sDK+5UXPZX0efWcqNAZ0B13Fks2Czv0KQA9bYn+PjAgsr
        3nvBH4u+AVyXSfUIohWnKRjF+9Qv2v0Bpd3VsvHWZuPhu54TG3C8FshpGRdpNWuh35a4vL
        blWoNLX1sui18YQANwmLgxYE457V6VsZbuAxzUQwc21EaS5kK9mqRMagA7igC+Wnameban
        lVQNdWXfNcAOo1Bt06+spfii/OH6lr+EqW9f1agjdOx7tyxySFGgHFXRgbWEkQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=oSFTRrG1M7hlRW5/Fmh7mVM82LlOghgD5/z1wLXfyOM=;
        b=21leFw/TEhfyMBih/O5xKvcojw1jvXiPXaAoXUR7jQncYVLmZQ+KZiXKF/DjQv+NPNVi48
        4tAudzovnQgBV7BA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 05/21] x86/KVM: Convert to fpstate
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:33 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert KVM code to the new register storage mechanism in preparation for
dynamically sized buffers.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/x86.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10389,7 +10389,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct k
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
+	fxsave = &vcpu->arch.guest_fpu->fpstate->regs.fxsave;
 	memcpy(fpu->fpr, fxsave->st_space, 128);
 	fpu->fcw = fxsave->cwd;
 	fpu->fsw = fxsave->swd;
@@ -10412,7 +10412,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu->state.fxsave;
+	fxsave = &vcpu->arch.guest_fpu->fpstate->regs.fxsave;
 
 	memcpy(fxsave->st_space, fpu->fpr, 128);
 	fxsave->cwd = fpu->fcw;


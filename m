Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43385429A2B
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbhJLAJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbhJLAIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E7BC061762;
        Mon, 11 Oct 2021 17:06:29 -0700 (PDT)
Message-ID: <20211011223610.645433623@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=B1tkVTwLBzXQ1kd/oYzbsyoZ3TVakIxSQFbsR2tD+XI=;
        b=DRU3FrOhoijfg/uXLgY3S+4aT1sYBLS1OesJ3aT9QARSczsVuAId/+8dyToLgHiaO8EyBn
        gxWXy34aRoEAKqmxSX3c+KcsdzH6KiwwlUquCxENgoFDHGIcYK9Cp/omnuan1IB+Z3qicR
        imuItG0/vaVI6Zl/1ZhQSBYOuCkS5lTV+/ZC5aTePbjHyRNEWtmTNed8jW9l8TmmLbllhg
        4IESelGZrw0OU5I5beHH8bpQzfDe5rzBhatyUf6u7sNxvYxQRIUgCs355OKD16tjEgPuyg
        LxYV7TDHdT3JyV45a+wsg2yLSobZqsX31d8Hjfm0vf26u2DiTUptgt+iTNZZxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=B1tkVTwLBzXQ1kd/oYzbsyoZ3TVakIxSQFbsR2tD+XI=;
        b=Snd0N896VA7Xdp4/T/V0MNqdfAZnstLxbiKrNKP77s0vBGysIj1skuG+NldaW/ZpBtYfZN
        bli3cooIXxz6iOAg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 06/31] x86/fpu: Remove pointless memset in fpu_clone()
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:07 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zeroing the forked task's FPU register buffer to avoid leaking init
optimized stale data into the clone is a pointless exercise for the case
where the current task has TIF_NEED_FPU_LOAD set. In that case the FPU
register state is copied from current's FPU register buffer which can
contain stale init optimized data as well.

The alledged information leak is non-existant because this stale
init optimized data is nowhere used and cannot leak anywhere.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/core.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -260,12 +260,6 @@ int fpu_clone(struct task_struct *dst)
 		return 0;
 
 	/*
-	 * Don't let 'init optimized' areas of the XSAVE area
-	 * leak into the child task:
-	 */
-	memset(&dst_fpu->state.xsave, 0, fpu_kernel_xstate_size);
-
-	/*
 	 * If the FPU registers are not owned by current just memcpy() the
 	 * state.  Otherwise save the FPU registers directly into the
 	 * child's FPU context, without any memory-to-memory copying.


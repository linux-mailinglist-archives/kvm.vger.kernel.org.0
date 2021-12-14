Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE2C47435C
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 14:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhLNNYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 08:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhLNNYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 08:24:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E82C061574;
        Tue, 14 Dec 2021 05:24:54 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639488291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ojo5CfB1kqd6Oz7Ue8byTDePBgU77WIcGI14kiPW2MY=;
        b=FiWW4gr6J2vA6cw2HzsxieR2sV6BeH3/U/R6EURFyJOchc5jCxYyeEMD4AwsLOWHPZ/0yL
        aXEMO8jEdM5B44wl92TbdB3kvlJOaX0muBcRsTZ4xwxFgV0+RFlNCTqwNb/INH2LJasbhA
        H7IKpmLqrza3iZeEOcXfiTwvxnTviwdhHwtsFfW6WnJWF+Glh2DUYPgUmOHrpyPbbxlm9q
        6S/fCR8477PuRcoX0nAEF06uqe4e7XM/K7zwHhGy1FmMLJjNkyovlVMn2HBwArYIDGz/d9
        EIM7keOxwAHlX151vZPq7QeHmXkRTkmNwrIiE3yFZN4WDSutkBrEqIykS7FJ2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639488291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ojo5CfB1kqd6Oz7Ue8byTDePBgU77WIcGI14kiPW2MY=;
        b=RceVS/6e5lVGJTjqWYYH9Syhhuib5UMpTVTmXSrR+sJvh59TQJFz4A6ibOewOmPReo9rhC
        qbbH5gOecp7yc+CA==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [patch 0/6] x86/fpu: Preparatory changes for guest AMX support
In-Reply-To: <09e06d62-33f5-b41f-e913-a8c5e43ba881@redhat.com>
References: <20211214022825.563892248@linutronix.de>
 <09e06d62-33f5-b41f-e913-a8c5e43ba881@redhat.com>
Date:   Tue, 14 Dec 2021 14:24:51 +0100
Message-ID: <877dc7tj30.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14 2021 at 11:42, Paolo Bonzini wrote:
> On 12/14/21 03:50, Thomas Gleixner wrote:
>> The only remaining issue is the KVM XSTATE save/restore size checking which
>> probably requires some FPU core assistance. But that requires some more
>> thoughts vs. the IOCTL interface extension and once that is settled it
>> needs to be solved in one go. But that's an orthogonal issue to the above.
>
> That's not a big deal because KVM uses the uncompacted format.  So 
> KVM_CHECK_EXTENSION and KVM_GET_XSAVE can just use CPUID to retrieve the 
> size and uncompacted offset of the largest bit that is set in 
> kvm_supported_xcr0, while KVM_SET_XSAVE can do the same with the largest 
> bit that is set in the xstate_bv.

For simplicity you can just get that information from guest_fpu. See
below.

Thanks,

        tglx
---
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -518,6 +518,11 @@ struct fpu_guest {
 	u64				perm;
 
 	/*
+	 * @uabi_size:			Size required for save/restore
+	 */
+	unsigned int			uabi_size;
+
+	/*
 	 * @fpstate:			Pointer to the allocated guest fpstate
 	 */
 	struct fpstate			*fpstate;
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -240,6 +240,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_user_cfg.default_features;
 	gfpu->perm		= fpu_user_cfg.default_features;
+	gfpu->uabi_size		= fpu_user_cfg.default_size;
 	fpu_init_guest_permissions(gfpu);
 
 	return true;
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1545,6 +1545,7 @@ static int fpstate_realloc(u64 xfeatures
 		newfps->is_confidential = curfps->is_confidential;
 		newfps->in_use = curfps->in_use;
 		guest_fpu->xfeatures |= xfeatures;
+		guest_fpu->uabi_size = usize;
 	}
 
 	fpregs_lock();

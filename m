Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573A6470DF0
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 23:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbhLJWgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 17:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbhLJWgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 17:36:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911D0C061746;
        Fri, 10 Dec 2021 14:33:17 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639175596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vbX7Me+Iuj5O8j5bYO3awQijjUsTa6w2R7JU9/YavGg=;
        b=P1qKuHgRFVejPuxfJb02B86ESWeFC7HmMUfwFg39IEuaGIKqDW0G5cGsfgBZtwoDwEfqQo
        Udv/n8asTTrYkpoTFwwF2k9Tcsiv+FebrWIN9FKi7erwBWpSSiiZIBvCFXSxlJdhCTO4LB
        1U7CQshW/Yswv2zal93IEj34CmiB0R1HZBDxh697SOp1AyaRQLJTH8mMZnWMIh4RSVPjmI
        lHUC5UZa+NorJNU+oQDzKmUlp166rk9Xqz+T+tQSbX3WuOGAMLaHzcBsEyowUP94EFLDvh
        onjQbR3XbUxX5etBH8ce/o35oUvOzWFaeNHGc733bmeWz8hyR+hOjxw/nRMEJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639175596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vbX7Me+Iuj5O8j5bYO3awQijjUsTa6w2R7JU9/YavGg=;
        b=iYdDUhvg6nAv3zrB6ZK0WMEz73XfUzI10zCfr5yHsYPkDdHxVq3DFoxUc9b5NVGsPqaqp4
        gVFYNVLMD69bo2BQ==
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 05/19] x86/fpu: Move xfd initialization out of
 __fpstate_reset() to the callers
In-Reply-To: <20211208000359.2853257-6-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-6-yang.zhong@intel.com>
Date:   Fri, 10 Dec 2021 23:33:15 +0100
Message-ID: <877dccxf84.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yang, Jing,

On Tue, Dec 07 2021 at 19:03, Yang Zhong wrote:
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index fe592799508c..fae44fa27cdb 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -231,6 +231,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>  	if (!fpstate)
>  		return false;
>  
> +	/* Leave xfd to 0 (the reset value defined by spec) */
>  	__fpstate_reset(fpstate);

That change makes me a bit wary simply because the comment here is above
__fpstate_reset() which makes no sense. It does make sense to you at the
time, but does it make sense to you when you look at it 6 month down the
road?

So I'd rather make this very obvious what's going. See below.

Thanks,

        tglx
---

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -199,7 +199,7 @@ void fpu_reset_from_exception_fixup(void
 }
 
 #if IS_ENABLED(CONFIG_KVM)
-static void __fpstate_reset(struct fpstate *fpstate);
+static void __fpstate_reset(struct fpstate *fpstate, u64 xfd);
 
 static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
 {
@@ -231,7 +231,8 @@ bool fpu_alloc_guest_fpstate(struct fpu_
 	if (!fpstate)
 		return false;
 
-	__fpstate_reset(fpstate);
+	/* Leave xfd to 0 (the reset value defined by spec) */
+	__fpstate_reset(fpstate, 0);
 	fpstate_init_user(fpstate);
 	fpstate->is_valloc	= true;
 	fpstate->is_guest	= true;
@@ -454,21 +455,21 @@ void fpstate_init_user(struct fpstate *f
 		fpstate_init_fstate(fpstate);
 }
 
-static void __fpstate_reset(struct fpstate *fpstate)
+static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
 {
 	/* Initialize sizes and feature masks */
 	fpstate->size		= fpu_kernel_cfg.default_size;
 	fpstate->user_size	= fpu_user_cfg.default_size;
 	fpstate->xfeatures	= fpu_kernel_cfg.default_features;
 	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
-	fpstate->xfd		= init_fpstate.xfd;
+	fpstate->xfd		= xfd;
 }
 
 void fpstate_reset(struct fpu *fpu)
 {
 	/* Set the fpstate pointer to the default fpstate */
 	fpu->fpstate = &fpu->__fpstate;
-	__fpstate_reset(fpu->fpstate);
+	__fpstate_reset(fpu->fpstate, init_fpstate.xfd);
 
 	/* Initialize the permission related info in fpu */
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;

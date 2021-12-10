Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD0C470E67
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 00:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344876AbhLJXNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 18:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhLJXN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 18:13:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5A6C061746;
        Fri, 10 Dec 2021 15:09:51 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639177788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yK9ojmVsvB5GuT8NeWP2jAu6EcoAr0wcXW592I/lvxY=;
        b=SMjhZmWoK/a5TO0f0y1C9d4WJwUuYAJHiZLbzT69aecQWqz/WPBlcps5E8o4R0qufPNxaq
        a80+i7WenKWsyt0PDV/8eQpzS/Ex567fqTNEo0/OEO3qGSzKA05sN8RNU9Kk9Y7gSr/QFS
        abQPj1+xnGJgh2xVPHod9911EkI/hQGFAsJoFyLCL0bNqBsXm56aOWTLJ9yAql3gHhIJ7Z
        zi2w0XxT4V9p8+FUe+N6+GzFDtbAev6SDTsvRKCUNCB1JeobX6+EFGLI8M4OUStVS02ilO
        SByYwkXf9K06lD6JACOrTmsFQG31chZ9baF5vjoUCYNFNntrHdV21VjX7+GgKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639177788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yK9ojmVsvB5GuT8NeWP2jAu6EcoAr0wcXW592I/lvxY=;
        b=u0mUjjMQNRUBH97fY+iL2jZN2huxEUeVfeEmLhXws0qlqp3dAukzCZJjF7EvBRErJIiDur
        ZDTLvC0ZGxUeC+DA==
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
In-Reply-To: <20211208000359.2853257-11-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
Date:   Sat, 11 Dec 2021 00:09:47 +0100
Message-ID: <87zgp8vyys.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07 2021 at 19:03, Yang Zhong wrote:
> +
> +		/*
> +		 * Update IA32_XFD to the guest value so #NM can be
> +		 * raised properly in the guest. Instead of directly
> +		 * writing the MSR, call a helper to avoid breaking
> +		 * per-cpu cached value in fpu core.
> +		 */
> +		fpregs_lock();
> +		current->thread.fpu.fpstate->xfd = data;
> +		xfd_update_state(current->thread.fpu.fpstate);
> +		fpregs_unlock();
> +		break;

Now looking at the actual callsite the previous patch really should be
something like the below. Why?

It preserves the inline which allows the compiler to generate better
code in the other hotpathes and it keeps the FPU internals to the core
code. Hmm?

Thanks,

        tglx

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -125,8 +125,10 @@ DECLARE_PER_CPU(struct fpu *, fpu_fpregs
 /* Process cleanup */
 #ifdef CONFIG_X86_64
 extern void fpstate_free(struct fpu *fpu);
+extern void fpu_update_xfd_state(u64 xfd);
 #else
 static inline void fpstate_free(struct fpu *fpu) { }
+static inline void fpu_update_xfd_state(u64 xfd) { }
 #endif
 
 /* fpstate-related functions which are exported to KVM */
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -322,6 +322,19 @@ int fpu_swap_kvm_fpstate(struct fpu_gues
 }
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
 
+#ifdef CONFIG_X86_64
+void fpu_update_xfd_state(u64 xfd)
+{
+	struct fpstate *fps = current->thread.fpu.fpstate;
+
+	fpregs_lock();
+	fps->xfd = xfd;
+	xfd_update_state(fps);
+	fpregs_unlock();
+}
+EXPORT_SYMBOL_GPL(fpu_update_xfd_state);
+#endif
+
 void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
 				    unsigned int size, u32 pkru)
 {



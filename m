Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28B82F75FB
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 10:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbhAOJz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 04:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbhAOJz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 04:55:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EDBC061757;
        Fri, 15 Jan 2021 01:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YUrXB4fWZdMIAFHCoVFWkOQJGOgpwtS7j2DvuWA7jYQ=; b=kC55jiDiBvo64i8ItVq8hGAGm9
        xt2OTTbaLKhhWQnfvHqMLjNpNgOUe9pm/7ndGzY/LowHqFsVxoetH1ES6VsqOkQP6BFF+1CU04mqb
        hJEWK5/kP7eD5uTjWcrLJt+EqwOP67EiziCd6xAk/5bAKvA4/T8+FYKuCMCCrlnJB0GbaoZ4895IN
        9ccSCTiEoHpwVIch3gcg4DaALr1hbDxQLVhNJkpdEwbqSj67XfGpDJJjZepaxe3XlbG/U4g1DsK6a
        c1tQigfHdGOAfCeDMYDqKBATGnKywktNJYrH0RXOJQNOFAS81AZTd15JPHrBehXC4oyDVMVW4m7a6
        Y6TgKPIA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l0Lnk-008kjZ-5l; Fri, 15 Jan 2021 09:53:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DA1763010CF;
        Fri, 15 Jan 2021 10:53:51 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BCB352C01E6E2; Fri, 15 Jan 2021 10:53:51 +0100 (CET)
Date:   Fri, 15 Jan 2021 10:53:51 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jason Baron <jbaron@akamai.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: x86: use static calls to reduce kvm_x86_ops
 overhead
Message-ID: <YAFmLzVnVzzUit4T@hirez.programming.kicks-ass.net>
References: <cover.1610680941.git.jbaron@akamai.com>
 <e057bf1b8a7ad15652df6eeba3f907ae758d3399.1610680941.git.jbaron@akamai.com>
 <YAFkTSnSut1h/jWt@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAFkTSnSut1h/jWt@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 15, 2021 at 10:45:49AM +0100, Peter Zijlstra wrote:
> On Thu, Jan 14, 2021 at 10:27:56PM -0500, Jason Baron wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 5060922..9d4492b 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1350,7 +1350,7 @@ void kvm_arch_free_vm(struct kvm *kvm);
> >  static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
> >  {
> >  	if (kvm_x86_ops.tlb_remote_flush &&
> > -	    !kvm_x86_ops.tlb_remote_flush(kvm))
> > +	    !static_call(kvm_x86_tlb_remote_flush)(kvm))
> >  		return 0;
> >  	else
> >  		return -ENOTSUPP;
> 
> Would you be able to use something like this?
> 
>   https://lkml.kernel.org/r/20201110101307.GO2651@hirez.programming.kicks-ass.net
> 
> we could also add __static_call_return1(), if that would help.

Something like so on top of the above.

--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -17,6 +17,7 @@ static void __ref __static_call_transfor
 	 * disp16 disp16 xorq %rax, %rax - a single 5 byte instruction that clears %rax
 	 */
 	static const u8 ret0[5] = { 0x66, 0x66, 0x48, 0x31, 0xc0 };
+	static const u8 ret1[5] = { 0xb8, 0x01, 0x00, 0x00, 0x00 }; /* mov $0x1,%eax */
 	int size = CALL_INSN_SIZE;
 	const void *emulate = NULL;
 	const void *code;
@@ -27,7 +28,11 @@ static void __ref __static_call_transfor
 		if (func == &__static_call_return0) {
 			emulate = code;
 			code = ret0;
+		} else if (func == &__static_call_return1) {
+			emulate = code;
+			code = ret1;
 		}
+
 		break;
 
 	case NOP:
--- a/include/linux/static_call.h
+++ b/include/linux/static_call.h
@@ -137,6 +137,7 @@ extern void arch_static_call_transform(v
 #ifdef CONFIG_HAVE_STATIC_CALL_INLINE
 
 extern long __static_call_return0(void);
+extern long __static_call_return1(void);
 
 extern int __init static_call_init(void);
 
@@ -190,6 +191,7 @@ extern int static_call_text_reserved(voi
 #elif defined(CONFIG_HAVE_STATIC_CALL)
 
 static inline long __static_call_return0(void) { return 0; }
+static inline long __static_call_return0(void) { return 1; }
 
 static inline int static_call_init(void) { return 0; }
 
@@ -239,6 +241,7 @@ static inline int static_call_text_reser
 #else /* Generic implementation */
 
 static inline long __static_call_return0(void) { return 0; }
+static inline long __static_call_return0(void) { return 1; }
 
 static inline int static_call_init(void) { return 0; }
 
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -443,6 +443,11 @@ long __static_call_return0(void)
 	return 0;
 }
 
+long __static_call_return1(void)
+{
+	return 1;
+}
+
 #ifdef CONFIG_STATIC_CALL_SELFTEST
 
 static int func_a(int x)

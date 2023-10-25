Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5197D6F5C
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344557AbjJYOWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344550AbjJYOWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:22:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB94B9
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:22:20 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9f973d319so45637945ad.0
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698243740; x=1698848540; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UBKcY3PTFSrO9ZLn4V0uAyxFec2EF562aCVgDc00c5Q=;
        b=n2SD6gVqGtK7M5570KDR+FkUDZRFLvYjAmz5Buf7L5oQkTc5XyXSvzt/fyWRJD5mmM
         DH23+7m/z4XpCrYvQl7mgGV2mRhKG1+euGFkqlJxeVOFvcvEB5ZGl0ShxhEOaYW1jZun
         09CL7yy4kjtnb4cnvTxC5VPT5STQSmbj5X6ijwfLr3BdOg9TCioskEpfCVDs6YVh80Xc
         GhUPJd+KqBNBN9sIFEYWNrdZ1+sFNsV5ODU92wcuKyQHO6JcV5mDD7MftYTGLzWmnUfG
         1f74RCGOPHtYaf4ZipuHzb5F4/HnMEfMAFqSWLIfDUuHmu7SGP3QmNL63+dlVBisy5iY
         ieiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698243740; x=1698848540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UBKcY3PTFSrO9ZLn4V0uAyxFec2EF562aCVgDc00c5Q=;
        b=om0a4rxIyJCyiYhtwwD8j9eYsS1lxq6zC0LuBqJ3TiwvaYubh+VgHp7e7cslQo0cTg
         hrZrGDGeVjsk7rLC+Kq7Gdynbq8xZYHdVykyhZ4wU6LJUPQpbmz1+UYM3TCMbfl4snCi
         IBthOHqB2su/bDBVNb2nJVrYjdf8N9vhdH+Y9vo8wQ08Va2SiZNnvCnqjVTxERr08wQX
         4FCOWx0torz+Z8ic9im7mMfUWi9CbQRz8cDjhPByGopDeaa/vo4pr1fRoFnPmCTRvZ9o
         k27rHt9H34OYQwEJWDbHPVnQsJbMrI6+L+QzTEMaO3dZoWL/WXF5RE5xSDzLlU0XXoGf
         gZBA==
X-Gm-Message-State: AOJu0Yw5vBvuqbxgTnhMPR6XUwzioAAEz+yLwITR2i8b8QP3eb3fzZXS
        G6GtjI9+fbDrBOrPJSvNPTC1geDfs5c=
X-Google-Smtp-Source: AGHT+IHZKoRSEHlXrSTk7gXfGGMtoiiYgI7x2ddN7SPaYK+7MnNM5VmYunvYPrmqzbCB+sPrMcS19w1ctes=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:200a:b0:1ca:a251:786e with SMTP id
 s10-20020a170903200a00b001caa251786emr245057pla.6.1698243740202; Wed, 25 Oct
 2023 07:22:20 -0700 (PDT)
Date:   Wed, 25 Oct 2023 14:22:18 +0000
In-Reply-To: <87a5s73w53.fsf@redhat.com>
Mime-Version: 1.0
References: <20231025055914.1201792-1-xiaoyao.li@intel.com>
 <20231025055914.1201792-2-xiaoyao.li@intel.com> <87a5s73w53.fsf@redhat.com>
Message-ID: <ZTkkmgs_oCnDCGvd@google.com>
Subject: Re: [PATCH v2 1/2] x86/kvm/async_pf: Use separate percpu variable to
 track the enabling of asyncpf
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023, Vitaly Kuznetsov wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index b8ab9ee5896c..388a3fdd3cad 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -65,6 +65,7 @@ static int __init parse_no_stealacc(char *arg)
> >  
> >  early_param("no-steal-acc", parse_no_stealacc);
> >  
> > +static DEFINE_PER_CPU_READ_MOSTLY(bool, async_pf_enabled);
> 
> Would it make a difference is we replace this with a cpumask? I realize
> that we need to access it on all CPUs from hotpaths but this mask will
> rarely change so maybe there's no real perfomance hit?

FWIW, I personally prefer per-CPU booleans from a readability perspective.  I
doubt there is a meaningful performance difference for a bitmap vs. individual
booleans, the check is already gated by a static key, i.e. kernels that are NOT
running as KVM guests don't care.

Actually, if there's performance gains to be had, optimizing kvm_read_and_reset_apf_flags()
to read the "enabled" flag if and only if it's necessary is a more likely candidate.
Assuming the host isn't being malicious/stupid, then apf_reason.flags will be '0'
if PV async #PFs are disabled.  The only question is whether or not apf_reason.flags
is predictable enough for the CPU.

Aha!  In practice, the CPU already needs to resolve a branch based on apf_reason.flags,
it's just "hidden" up in __kvm_handle_async_pf().

If we really want to micro-optimize, provide an __always_inline inner helper so
that __kvm_handle_async_pf() doesn't need to make a CALL just to read the flags.
Then in the common case where a #PF isn't due to the host swapping out a page,
the paravirt happy path doesn't need a taken branch and never reads the enabled
variable.  E.g. the below generates:

   0xffffffff81939ed0 <+0>:	41 54              	push   %r12
   0xffffffff81939ed2 <+2>:	31 c0              	xor    %eax,%eax
   0xffffffff81939ed4 <+4>:	55                 	push   %rbp
   0xffffffff81939ed5 <+5>:	53                 	push   %rbx
   0xffffffff81939ed6 <+6>:	48 83 ec 08        	sub    $0x8,%rsp
   0xffffffff81939eda <+10>:	65 8b 2d df 81 6f 7e	mov    %gs:0x7e6f81df(%rip),%ebp        # 0x320c0 <apf_reason>
   0xffffffff81939ee1 <+17>:	85 ed              	test   %ebp,%ebp
   0xffffffff81939ee3 <+19>:	75 09              	jne    0xffffffff81939eee <__kvm_handle_async_pf+30>
   0xffffffff81939ee5 <+21>:	48 83 c4 08        	add    $0x8,%rsp
   0xffffffff81939ee9 <+25>:	5b                 	pop    %rbx
   0xffffffff81939eea <+26>:	5d                 	pop    %rbp
   0xffffffff81939eeb <+27>:	41 5c              	pop    %r12
   0xffffffff81939eed <+29>:	c3                 	ret


diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b8ab9ee5896c..b24133dc0731 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -240,22 +240,29 @@ void kvm_async_pf_task_wake(u32 token)
 }
 EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
 
-noinstr u32 kvm_read_and_reset_apf_flags(void)
+static __always_inline u32 __kvm_read_and_reset_apf_flags(void)
 {
-       u32 flags = 0;
+       u32 flags = __this_cpu_read(apf_reason.flags);
 
-       if (__this_cpu_read(apf_reason.enabled)) {
-               flags = __this_cpu_read(apf_reason.flags);
-               __this_cpu_write(apf_reason.flags, 0);
+       if (unlikely(flags)) {
+               if (likely(__this_cpu_read(apf_reason.enabled)))
+                       __this_cpu_write(apf_reason.flags, 0);
+               else
+                       flags = 0;
        }
 
        return flags;
 }
+
+u32 kvm_read_and_reset_apf_flags(void)
+{
+       return __kvm_read_and_reset_apf_flags();
+}
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_apf_flags);
 
 noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 {
-       u32 flags = kvm_read_and_reset_apf_flags();
+       u32 flags = __kvm_read_and_reset_apf_flags();
        irqentry_state_t state;
 
        if (!flags)

> >  static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
> >  DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
> >  static int has_steal_clock = 0;
> > @@ -244,7 +245,7 @@ noinstr u32 kvm_read_and_reset_apf_flags(void)
> >  {
> >  	u32 flags = 0;
> >  
> > -	if (__this_cpu_read(apf_reason.enabled)) {
> > +	if (__this_cpu_read(async_pf_enabled)) {
> >  		flags = __this_cpu_read(apf_reason.flags);
> >  		__this_cpu_write(apf_reason.flags, 0);
> >  	}
> > @@ -295,7 +296,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
> >  
> >  	inc_irq_stat(irq_hv_callback_count);
> >  
> > -	if (__this_cpu_read(apf_reason.enabled)) {
> > +	if (__this_cpu_read(async_pf_enabled)) {
> >  		token = __this_cpu_read(apf_reason.token);
> >  		kvm_async_pf_task_wake(token);
> >  		__this_cpu_write(apf_reason.token, 0);
> > @@ -362,7 +363,7 @@ static void kvm_guest_cpu_init(void)
> >  		wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
> >  
> >  		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
> > -		__this_cpu_write(apf_reason.enabled, 1);
> > +		__this_cpu_write(async_pf_enabled, 1);
> 
> As 'async_pf_enabled' is bool, it would probably be more natural to
> write
> 
> 	__this_cpu_write(async_pf_enabled, true);

+1000

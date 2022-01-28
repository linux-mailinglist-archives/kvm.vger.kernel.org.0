Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76DC4A0304
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 22:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348274AbiA1Vkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 16:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbiA1Vkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 16:40:47 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131F8C06173B
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 13:40:47 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id e28so7356392pfj.5
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 13:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=k6jLROMjFao7umAdNdU2nps7DNd/2hCKqNaRX+GNrNE=;
        b=pOYMyVsviS5ZXyX7QpGw6+81A8UaDif16k7CLTQFrvekf8dwrkBhGLAWdz93ScVtOu
         WMnDA2tm/ZDx7NT4hH8D/wd3r/3ErWY8XEErncthtxDnP/u9tNqoFOAEgc+0PPU2BJi2
         n+M2JJO5eDxOGM6u+sFuk6CAapVGxZuYUp/vh0JHmvgNjNfxun9dnMJoJopoU1rGVGJ8
         4S3p0HKBn8N6qFb+mHlD4p6yJ4iwqGMZkmGm7jODd0R1VotNaJJQTkA/qFyXVTme98Az
         9kXNWt1Giuo9RQEEEapqrs4qhvm4WVPV3X5mTU+69VWMFb+xqjd/FXkBBgMByFvYHn2U
         axAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=k6jLROMjFao7umAdNdU2nps7DNd/2hCKqNaRX+GNrNE=;
        b=zCnHmCAVomF47UOuYG9iEIgspP4RE+7zXAvu6N1vL8BF8NHbcT+fbbfilqVmMLNl9f
         2JzT+qWa68coGwD90G6NGWbvkwPSzquEQolMsM/R+4QvNKURtxQpyPU7fzD1LFrVYUUZ
         BF+XX6rBnD7Zv/A9+pEa/ww99ErDif0e7T70k2i35l5JouDuGc1f0UkS/M/65bOMmtUb
         IJPJ6z1+QmiP9HxBBGd4NHeB78GZtpSav45j66rmaGyUT4YDC/uR6fRaX8wRRT7P8pQ1
         NNq0G4OJQKhY6GvTTTYN8DNrhRny2Z7iluLZU5BcUwFTpY1D+s37h2yX0SxH6tuV0Zgu
         3u5w==
X-Gm-Message-State: AOAM532K/pzBGYTbR3UE9hxyb4w9OhxHXnuKwl0U/k0+a5jBwwVbWOw7
        B73/xNjDyyOuPuignSldi7DZfg==
X-Google-Smtp-Source: ABdhPJzXoBblVcuVDnL1lifFneIqQS9ZvH4X/NVw99B5JBvAaq0FNjqEHxxVES3PMPWNKxnlAGqtBQ==
X-Received: by 2002:a63:2a92:: with SMTP id q140mr8072875pgq.379.1643406046304;
        Fri, 28 Jan 2022 13:40:46 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u16sm10756333pfg.192.2022.01.28.13.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 13:40:45 -0800 (PST)
Date:   Fri, 28 Jan 2022 21:40:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
Message-ID: <YfRi2sY0hVfri5eR@google.com>
References: <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
 <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org>
 <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com>
 <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org>
 <1401c5a1-c8a2-cca1-e548-cab143f59d8f@amd.com>
 <2bfb13ed5d565ab09bd794f69a6ef2b1b75e507a.camel@infradead.org>
 <b798bcef-d750-ce42-986c-0d11d0bb47b0@amd.com>
 <41e63d89f1b2debc0280f243d7c8c3212e9499ee.camel@infradead.org>
 <c3dbd3b9-accf-bc28-f808-1d842d642309@amd.com>
 <7e92a196e67b1bfa37c1e61a789f2b75a735c06f.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e92a196e67b1bfa37c1e61a789f2b75a735c06f.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 28, 2022, David Woodhouse wrote:
> On Fri, 2021-12-17 at 14:55 -0600, Tom Lendacky wrote:
> > On 12/17/21 2:13 PM, David Woodhouse wrote:
> > > On Fri, 2021-12-17 at 13:46 -0600, Tom Lendacky wrote:
> > > > There's no WARN or PANIC, just a reset. I can look to try and capture some
> > > > KVM trace data if that would help. If so, let me know what events you'd
> > > > like captured.
> > > 
> > > 
> > > Could start with just kvm_run_exit?
> > > 
> > > Reason 8 would be KVM_EXIT_SHUTDOWN and would potentially indicate a
> > > triple fault.
> > 
> > qemu-system-x86-24093   [005] .....  1601.759486: kvm_exit: vcpu 112 reason shutdown rip 0xffffffff81070574 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x80000b08 error_code 0x00000000
> > 
> > # addr2line -e woodhouse-build-x86_64/vmlinux 0xffffffff81070574
> > /root/kernels/woodhouse-build-x86_64/./arch/x86/include/asm/desc.h:272
> > 
> > Which is: asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
> 
> So, I remain utterly bemused by this, and the Milan *guests* I have
> access to can't even kexec with a stock kernel; that is also "too fast"
> and they take a triple fault during the bringup in much the same way —
> even without my parallel patches, and even going back to fairly old
> kernels.
> 
> I wasn't able to follow up with raw serial output during the bringup to
> pinpoint precisely where it happens, because the VM would tear itself
> down in response to the triple fault without actually flushing the last
> virtual serial output :)
> 
> It would be really useful to get access to a suitable host where I can
> spawn this in qemu and watch it fail. I am suspecting a chip-specific
> quirk or bug at this point.

Nope.  You missed a spot.  This also reproduces on a sufficiently large Intel
system (and Milan).  initial_gs gets overwritten by common_cpu_up(), which leads
to a CPU getting the wrong MSR_GS_BASE and then the wrong raw_smp_processor_id(),
resulting in cpu_init_exception_handling() stuffing the wrong GDT and leaving a
NULL TR descriptor for itself.

You also have a lurking bug in the x2APIC ID handling.  Stripping the boot flags
from the prescribed APICID needs to happen before retrieving the x2APIC ID from
CPUID, otherwise bits 31:16 of the ID will be lost.

You owe me two beers ;-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index dcdf49a137d6..23df88c86a0e 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -208,11 +208,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
         * in smpboot_control:
         * Bit 0-15     APICID if STARTUP_USE_CPUID_0B is not set
         * Bit 16       Secondary boot flag
-        * Bit 17       Parallel boot flag
+        * Bit 17       Parallel boot flag (STARTUP_USE_CPUID_0B)
         */
        testl   $STARTUP_USE_CPUID_0B, %eax
-       jz      .Lsetup_AP
+       jnz     .Luse_cpuid_0b
+       andl    $0xFFFF, %eax
+       jmp     .Lsetup_AP

+.Luse_cpuid_0b:
        mov     $0x0B, %eax
        xorl    %ecx, %ecx
        cpuid
@@ -220,7 +223,6 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)

 .Lsetup_AP:
        /* EAX contains the APICID of the current CPU */
-       andl    $0xFFFF, %eax
        xorl    %ecx, %ecx
        leaq    cpuid_to_apicid(%rip), %rbx

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 04f5c8de5606..e7fda406f39a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1093,6 +1093,17 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
        return boot_error;
 }

+static bool do_parallel_bringup = true;
+
+static int __init no_parallel_bringup(char *str)
+{
+       do_parallel_bringup = false;
+
+       return 0;
+}
+early_param("no_parallel_bringup", no_parallel_bringup);
+
+
 int common_cpu_up(unsigned int cpu, struct task_struct *idle)
 {
        int ret;
@@ -1112,7 +1123,8 @@ int common_cpu_up(unsigned int cpu, struct task_struct *idle)
        /* Stack for startup_32 can be just as for start_secondary onwards */
        per_cpu(cpu_current_top_of_stack, cpu) = task_top_of_stack(idle);
 #else
-       initial_gs = per_cpu_offset(cpu);
+       if (!do_parallel_bringup)
+               initial_gs = per_cpu_offset(cpu);
 #endif
        return 0;
 }
@@ -1336,16 +1348,6 @@ int do_cpu_up(unsigned int cpu, struct task_struct *tidle)
        return ret;
 }

-static bool do_parallel_bringup = true;
-
-static int __init no_parallel_bringup(char *str)
-{
-       do_parallel_bringup = false;
-
-       return 0;
-}
-early_param("no_parallel_bringup", no_parallel_bringup);
-
 int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
        int ret;


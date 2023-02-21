Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90A269DBD9
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 09:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjBUIZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 03:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjBUIZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 03:25:14 -0500
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3356D20059;
        Tue, 21 Feb 2023 00:25:13 -0800 (PST)
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 9F46E123AC91;
        Tue, 21 Feb 2023 09:25:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1676967908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RlDwttwnbhqYBrOWhJDWVTjB+F85C40HjekkKQ5uE7s=;
        b=nSmMILXUq9FQJPXkCEz31jy6cxHVR1YFkZ8DuL2k928cguoQYftMmkn7J63/KU+cmKI4Zw
        dzARuBiFv2pKO6zVJSVegBG4PzFG0jxVDBWP9ssV0YmH3lHfW+Hl+dm6Wi1boquFKR0vB8
        rrmq66EqbZC+MB9FVOCwnuK+qOUTfBY=
MIME-Version: 1.0
Date:   Tue, 21 Feb 2023 09:25:08 +0100
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
Message-ID: <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
X-Sender: oleksandr@natalenko.name
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.02.2023 09:17, David Woodhouse wrote:
> On Tue, 2023-02-21 at 09:05 +0100, Oleksandr Natalenko wrote:
>> 
>> Please see here: http://ix.io/4oLm
> 
> Was that just for one CPU? Can we have them all please?
> 
> The interesting part is the line starting 00000001. We're looking at
> the top 8 bits of EBX:
> 
> Leaf     Subleaf    EAX            EBX            ECX            EDX
> 00000000 00000000:  00000010 ....  68747541 Auth  444d4163 cAMD  
> 69746e65 enti
> 00000001 00000000:  00a20f12 ....  00200800 .. .  7ef8320b .2.~  
> 178bfbff ....
>                                    ↑↑
> 
> So the first CPU is CPU0. Could have told you that... what about the 
> others? :)

Right, sorry. Here it is: http://ix.io/4oLq

> If anyone can reproduce this with a serial port, can you try this?
> 
> From 98ad11d0fb88f081f49f7b1496420dbfbeff8833 Mon Sep 17 00:00:00 2001
> From: David Woodhouse <dwmw@amazon.co.uk>
> Date: Sat, 4 Feb 2023 15:20:24 +0000
> Subject: [PATCH] parallel debug
> 
> ---
>  arch/x86/kernel/head_64.S | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 0e4e53d231db..da7f4d2d9951 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -281,6 +281,15 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, 
> SYM_L_GLOBAL)
> 
>  .Lsetup_AP:
>  	/* EDX contains the APIC ID of the current CPU */
> +#if 1
> +	/* Test hack: Print APIC ID and then CPU# when we find it. */
> +	mov	%edx, %ecx
> +	mov	%edx, %eax
> +	addb	$'A', %al
> +	mov	$0x3f8, %dx
> +	outb    %al, %dx
> +	mov	%ecx, %edx
> +#endif
>  	xorq	%rcx, %rcx
>  	leaq	cpuid_to_apicid(%rip), %rbx
> 
> @@ -302,6 +311,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, 
> SYM_L_GLOBAL)
> 
>  .Linit_cpu_data:
>  	/* Get the per cpu offset for the given CPU# which is in ECX */
> +#if 1
> +	mov	%rcx, %rax
> +	shr	$3, %rax
> +	addb	$'a', %al
> +
> +	mov	$0x3f8, %dx
> +	outb    %al, %dx
> +#endif
>  	leaq	__per_cpu_offset(%rip), %rbx
>  	movq	(%rbx,%rcx,8), %rbx
>  	/* Save it for GS BASE setup */

-- 
   Oleksandr Natalenko (post-factum)

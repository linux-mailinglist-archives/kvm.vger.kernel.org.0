Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C733F13AB
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 08:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhHSGke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 02:40:34 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:35743 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230483AbhHSGkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 02:40:33 -0400
Received: from [192.168.0.2] (ip5f5aedd3.dynamic.kabel-deutschland.de [95.90.237.211])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 95E4761E64760;
        Thu, 19 Aug 2021 08:39:54 +0200 (CEST)
Subject: Re: [PATCH] x86: kvm: Demote level of already loaded message from
 error to info
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210818114956.7171-1-pmenzel@molgen.mpg.de>
 <f9ba6fec-f764-dae7-e4f9-c532f4672359@maciej.szmigiero.name>
 <YR2Id14e9kagM6u0@google.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <1c5ac4f8-4c39-a969-9ffa-2f527535a4b1@molgen.mpg.de>
Date:   Thu, 19 Aug 2021 08:39:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YR2Id14e9kagM6u0@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sean,


Am 19.08.21 um 00:23 schrieb Sean Christopherson:
> On Wed, Aug 18, 2021, Maciej S. Szmigiero wrote:
>> On 18.08.2021 13:49, Paul Menzel wrote:
>>> In scripts, running
>>>
>>>       modprobe kvm_amd     2>/dev/null
>>>       modprobe kvm_intel   2>/dev/null
>>>
>>> to ensure the modules are loaded causes Linux to log errors.
>>>
>>>       $ dmesg --level=err
>>>       [    0.641747] [Firmware Bug]: TSC_DEADLINE disabled due to Errata; please update microcode to version: 0x3a (or later)
>>>       [   40.196868] kvm: already loaded the other module
>>>       [   40.219857] kvm: already loaded the other module
>>>       [   55.501362] kvm [1177]: vcpu0, guest rIP: 0xffffffff96e5b644 disabled perfctr wrmsr: 0xc2 data 0xffff
>>>       [   56.397974] kvm [1418]: vcpu0, guest rIP: 0xffffffff81046158 disabled perfctr wrmsr: 0xc1 data 0xabcd
>>>       [1007981.827781] kvm: already loaded the other module
>>>       [1008000.394089] kvm: already loaded the other module
>>>       [1008030.706999] kvm: already loaded the other module
>>>       [1020396.054470] kvm: already loaded the other module
>>>       [1020405.614774] kvm: already loaded the other module
>>>       [1020410.140069] kvm: already loaded the other module
>>>       [1020704.049231] kvm: already loaded the other module
>>>
>>> As one of the two KVM modules is already loaded, KVM is functioning, and
>>> their is no error condition. Therefore, demote the log message level to
>>> informational.
> 
> Hrm, but there is an error condition.  Userspace explicitly requested something
> and KVM couldn't satisfy the request.

Yes, that’s the other perspective. ;-) I’d argue, as the Intel/AMD 
module can’t work on AMD/Intel, the load failure is expected and error. 
But as “error condition” is not well defined:

     $ dmesg -h
     […]
     Supported log levels (priorities):
        emerg - system is unusable
        alert - action must be taken immediately
         crit - critical conditions
          err - error conditions
         warn - warning conditions
       notice - normal but significant condition
         info - informational
        debug - debug-level messages

> KVM is also going to complain at level=err one way or another, e.g. if a script
> probes kvm_amd before kvm_intel on an Intel CPU it's going to get "kvm: no hardware
> support", so this isn't truly fixing the problem.

In my case, modprobe already errors out in that case, which is fine for me.

     $ lsmod | grep kvm
     kvm_intel             249856  0
     kvm                   851968  1 kvm_intel
     irqbypass              16384  1 kvm
     $ sudo modprobe -r kvm_intel
     $ sudo modprobe kvm_amd
     modprobe: ERROR: could not insert 'kvm_amd': Operation not supported
     $ dmesg | tail -2
     [212685.034278] has_svm: not amd or hygon
     [212685.037998] kvm: no hardware support

> Is the issue perhaps that this particular message isn't ratelimited?

It would help my use case, as I am not interested in the error, and 
would be another solution than just changing the log levle. But for your 
viewpoint “Userspace explicitly requested something and KVM couldn't 
satisfy the request”, the user wouldn’t see the immediate error at the 
end of the output of `dmesg`.

> It's also easy for the script to grep /proc/cpuinfo, so it's hard to feel too
> bad about the kludgy message, e.g. look for a specific vendor, 'vmx' or 'svm', etc...
> 
> if [[ -z $kvm ]]; then
>      grep vendor_id "/proc/cpuinfo" | grep -q AuthenticAMD
>      if [[ $? -eq 0 ]]; then
>          kvm=kvm_amd
>      else
>          kvm=kvm_intel
>      fi
> fi

Yes, it could be worked around.

>> Shouldn't this return ENODEV when loading one of these modules instead
>> as there is no hardware that supports both VMX and SVM?
> 
> Probably not, as KVM would effectively be speculating, e.g. someone could load an
> out-of-tree variant of kvm_{intel,amd}.  Maybe instead of switching to ENODEV,
> reword the comment, make it ratelimited, and shove it down?  That way the message
> and -EEXIST fires iff the vendor module actually has some chance of being loaded.
> 
>  From 3528e66bd5107d5ac4f6a6ae50503cf64446866a Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 18 Aug 2021 15:17:43 -0700
> Subject: [PATCH] KVM: x86: Tweak handling and message when vendor module is
>   already loaded
> 
> Reword KVM's error message if a vendor module is already loaded to state
> exactly that instead of assuming "the other" module is loaded,

The rewording is definitely an improvement.

> ratelimit
> said message to match the other errors, and move the check down below the
> basic functionality checks so that attempting to load an unsupported
> module provides the same result regardless of whether or not a supported
> vendor module is already loaded.

Maybe add an example, how it would log the error before, and how it’s 
done now.

> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Cc: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fdc0c18339fb..15bd4bd3c81d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8357,12 +8357,6 @@ int kvm_arch_init(void *opaque)
>   	struct kvm_x86_init_ops *ops = opaque;
>   	int r;
> 
> -	if (kvm_x86_ops.hardware_enable) {
> -		printk(KERN_ERR "kvm: already loaded the other module\n");
> -		r = -EEXIST;
> -		goto out;
> -	}
> -
>   	if (!ops->cpu_has_kvm_support()) {
>   		pr_err_ratelimited("kvm: no hardware support\n");
>   		r = -EOPNOTSUPP;
> @@ -8374,6 +8368,12 @@ int kvm_arch_init(void *opaque)
>   		goto out;
>   	}
> 
> +	if (kvm_x86_ops.hardware_enable) {
> +		pr_err_ratelimited("kvm: already loaded a vendor module\n");
> +		r = -EEXIST;
> +		goto out;
> +	}
> +
>   	/*
>   	 * KVM explicitly assumes that the guest has an FPU and
>   	 * FXSAVE/FXRSTOR. For example, the KVM_GET_FPU explicitly casts the
> --
> 2.33.0.rc2.250.ged5fa647cd-goog

Sounds also good at first sight. No idea, if monitoring scripts in 
userspace would get confused now.


Kind regards,

Paul

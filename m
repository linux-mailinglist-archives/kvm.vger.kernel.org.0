Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0ED5735763
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 14:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjFSMxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 08:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjFSMxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 08:53:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D7D10DC
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 05:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687179128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=usnwe/tASw/wAaW+kGK0ObxoIGkFy36hF/mR+fiZ/Zo=;
        b=SxksAB0s2XTLSU1Nljbo75vVnlui9oQKCJdQhunbAPLKVYs93jVYri87EVCUgabUH5An0b
        ncU+FCrQAPKsQhtMOSveQ3o/W3OEJN9viDVVOUsxHPLsKLMw1x+ESCrJJ7dNurfj/X3Bnu
        bPrN7iLmQPaTncn56/wt7p0In8IYn+E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-qZwBi8PvO6a0Z7_n65gybA-1; Mon, 19 Jun 2023 08:52:07 -0400
X-MC-Unique: qZwBi8PvO6a0Z7_n65gybA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f9b19cb170so4527295e9.3
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 05:52:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687179126; x=1689771126;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=usnwe/tASw/wAaW+kGK0ObxoIGkFy36hF/mR+fiZ/Zo=;
        b=T1h6Qj++p6LYFezA+/zZszWJQnEt7ftrQrcjAhb3//raeJuyeTQj3VkwhY+UwKJbCJ
         P7+Q3J7fl50EdT7l/FRxCgXYaeiGPcoZ5/2MnheRgwz/qK2xFs/YDeFS84Mv+K6LsGOq
         tUI4ck0hMvzEkHhHsgM2VhX2WqANpQF4NOLBJWB+wCvG3KRXZETOVf2osOlWoxlEUsCZ
         6J4cBh+jvgbzky9O16tIaIFHJcUYEjoXrCDgi0sfJ3EIks7yp+neWL3fT7grqPQU5zbV
         vIqQHqK7nN2CKQFoO9J/3TJzThOxYXcdbFUCQz2Xiq7sV5ZXFXStV4s2zQ+5tN42Mpy2
         OrjA==
X-Gm-Message-State: AC+VfDzYFz6n9CLp/Ra92JJhY3UqlIfCYXAojXWqJXw6tchMNiOqeNdv
        H8CTP2ggSHu8j85OQcAETHPQ26ndG0L6gjPMBSwCubjdYQ3FrKend35VyQIaqBcjffpoplcd4mu
        vWqonsVOs7s/i
X-Received: by 2002:a05:600c:228b:b0:3f7:26f8:4cd0 with SMTP id 11-20020a05600c228b00b003f726f84cd0mr8032130wmf.16.1687179126340;
        Mon, 19 Jun 2023 05:52:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6qNgZczslpun3cTWcOMwroQQgbukwP3O7vMg2jnLFSw7CbI/w20j92/l09YrAOdzgJjx6c9g==
X-Received: by 2002:a05:600c:228b:b0:3f7:26f8:4cd0 with SMTP id 11-20020a05600c228b00b003f726f84cd0mr8032099wmf.16.1687179125851;
        Mon, 19 Jun 2023 05:52:05 -0700 (PDT)
Received: from ?IPV6:2003:cb:c72f:7100:cede:6433:a77b:41e9? (p200300cbc72f7100cede6433a77b41e9.dip0.t-ipconnect.de. [2003:cb:c72f:7100:cede:6433:a77b:41e9])
        by smtp.gmail.com with ESMTPSA id a2-20020a05600c224200b003f9b53959a4sm188667wmm.43.2023.06.19.05.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 05:52:05 -0700 (PDT)
Message-ID: <759e3af5-6aec-7e50-c432-c5e0a0c3cf36@redhat.com>
Date:   Mon, 19 Jun 2023 14:52:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1685887183.git.kai.huang@intel.com>
 <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v11 05/20] x86/virt/tdx: Add SEAMCALL infrastructure
In-Reply-To: <ec640452a4385d61bec97f8b761ed1ff38898504.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.06.23 16:27, Kai Huang wrote:
> TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).  This
> mode runs only the TDX module itself or other code to load the TDX
> module.
> 
> The host kernel communicates with SEAM software via a new SEAMCALL
> instruction.  This is conceptually similar to a guest->host hypercall,
> except it is made from the host to SEAM software instead.  The TDX
> module establishes a new SEAMCALL ABI which allows the host to
> initialize the module and to manage VMs.
> 
> Add infrastructure to make SEAMCALLs.  The SEAMCALL ABI is very similar
> to the TDCALL ABI and leverages much TDCALL infrastructure.
> 
> SEAMCALL instruction causes #GP when TDX isn't BIOS enabled, and #UD
> when CPU is not in VMX operation.  Currently, only KVM code mocks with
> VMX enabling, and KVM is the only user of TDX.  This implementation
> chooses to make KVM itself responsible for enabling VMX before using
> TDX and let the rest of the kernel stay blissfully unaware of VMX.
> 
> The current TDX_MODULE_CALL macro handles neither #GP nor #UD.  The
> kernel would hit Oops if SEAMCALL were mistakenly made w/o enabling VMX
> first.  Architecturally, there is no CPU flag to check whether the CPU
> is in VMX operation.  Also, if a BIOS were buggy, it could still report
> valid TDX private KeyIDs when TDX actually couldn't be enabled.
> 
> Extend the TDX_MODULE_CALL macro to handle #UD and #GP to return error
> codes.  Introduce two new TDX error codes for them respectively so the
> caller can distinguish.
> 
> Also add a wrapper function of SEAMCALL to convert SEAMCALL error code
> to the kernel error code, and print out SEAMCALL error code to help the
> user to understand what went wrong.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---

I agree with Dave that a buggy bios is not a good motivation for this 
patch. The real strength of this infrastructure IMHO is central error 
handling and expressive error messages. Maybe it makes some corner cases 
(reboot -f) easier to handle. That would make a better justification 
than buggy bios -- and should be spelled out in the patch description.

[...]


> +/*
> + * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
> + * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
> + * leaf function return code and the additional output respectively if
> + * not NULL.
> + */
> +static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +				    u64 *seamcall_ret,
> +				    struct tdx_module_output *out)
> +{
> +	int cpu, ret = 0;
> +	u64 sret;
> +
> +	/* Need a stable CPU id for printing error message */
> +	cpu = get_cpu();
> +
> +	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +


Why not

cpu = get_cpu();
sret = __seamcall(fn, rcx, rdx, r8, r9, out);
put_cpu();


> +	/* Save SEAMCALL return code if the caller wants it */
> +	if (seamcall_ret)
> +		*seamcall_ret = sret;
> +
> +	/* SEAMCALL was successful */
> +	if (!sret)
> +		goto out;

Why not move that into the switch statement below to avoid th goto?
If you do the put_cpu() early, you can avoid "ret" as well.

switch (sret) {
case 0:
	/* SEAMCALL was successful */
	return 0;
case TDX_SEAMCALL_GP:
	pr_err_once("[firmware bug]: TDX is not enabled by BIOS.\n");
	return -ENODEV;
...
}

[...]

> +
>   static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
>   					    u32 *nr_tdx_keyids)
>   {
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> new file mode 100644
> index 000000000000..48ad1a1ba737
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _X86_VIRT_TDX_H
> +#define _X86_VIRT_TDX_H
> +
> +#include <linux/types.h>
> +
> +struct tdx_module_output;
> +u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +	       struct tdx_module_output *out);
> +#endif
> diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> index 49a54356ae99..757b0c34be10 100644
> --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> @@ -1,6 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   #include <asm/asm-offsets.h>
>   #include <asm/tdx.h>
> +#include <asm/asm.h>
>   
>   /*
>    * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
> @@ -45,6 +46,7 @@
>   	/* Leave input param 2 in RDX */
>   
>   	.if \host
> +1:
>   	seamcall
>   	/*
>   	 * SEAMCALL instruction is essentially a VMExit from VMX root
> @@ -57,10 +59,23 @@
>   	 * This value will never be used as actual SEAMCALL error code as
>   	 * it is from the Reserved status code class.
>   	 */
> -	jnc .Lno_vmfailinvalid
> +	jnc .Lseamcall_out
>   	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
> -.Lno_vmfailinvalid:
> +	jmp .Lseamcall_out
> +2:
> +	/*
> +	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
> +	 * the trap number.  Convert the trap number to the TDX error
> +	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
> +	 *
> +	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
> +	 * only accepts 32-bit immediate at most.

Not sure if that comment is really helpful here. It's a common pattern 
for large immediates, no?

> +	 */
> +	mov $TDX_SW_ERROR, %r12
> +	orq %r12, %rax
>   
> +	_ASM_EXTABLE_FAULT(1b, 2b)
> +.Lseamcall_out:
>   	.else
>   	tdcall
>   	.endif

-- 
Cheers,

David / dhildenb


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7A173569C
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 14:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjFSMW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 08:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjFSMW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 08:22:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E3C128
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 05:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687177298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIB4Pfs9fbpMTO7m6AmZ/9HnKP7cCuS9gi+tv9YLZxo=;
        b=MZotyI8M6CrPjy5CdJ04kNOM/si4AIwvfYFS3lLHPDlcCjXC1P6/fnKCuM/OA1XxevUEdQ
        rQ2jkhAkt8LFzPVnBTUrE4MEsFUFMenx58wYBTJhCGaHz+Hlk7uf4Q8reFaKsHQ+0Ze+U2
        PqWORe0rO9L7ANykLUh4llm8ltPJpFA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-X5ht2TsyPICjaHNS34euDw-1; Mon, 19 Jun 2023 08:21:36 -0400
X-MC-Unique: X5ht2TsyPICjaHNS34euDw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f86d450b01so751567e87.0
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 05:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687177295; x=1689769295;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pIB4Pfs9fbpMTO7m6AmZ/9HnKP7cCuS9gi+tv9YLZxo=;
        b=QhXDBFFifJTw7FP/UrLJayBF8ZgeC04hJtMpjUYXV9mqRvdmIVoF6ggV9dP0uMzl/h
         SZ72tJMMfsG5XgTn2watK5eGpNZVD/yC1YY17AeEb+5yOUj6aqS4fFlXzp05jtPwSH0+
         KydG/KIxp1yg+CIdLN/ylcKi9SOFOJr/rQXMZ27+inrS0RXaglQv03xNKzMDXe29q5Gs
         A4vNS73e4FBqFZTywkg6036LuL40i+SaMuVzOSxplJpvUn6+Zc5ImzkRyeQzRWoaKorS
         tKTRaXddUgv6jp2J9ZyZgKwJ833B1t16ERgtNyoYS5ickPOtgU1ni+moc3XT4pO0MChz
         rqKQ==
X-Gm-Message-State: AC+VfDz+9xKaIGkA4/l6j1koyAZPZrLQH3E91gBpK8YnAEoK7zZ2eLkR
        5FIy9ZDPFEFQ3Y5SPIRNNciJw5Er6xy2YKEYugDAIs0WKdpKJ55Vs0zHsj6xURv2nigkR7cAa23
        pR4UgqVje88ad
X-Received: by 2002:a05:6512:3286:b0:4f8:7127:9b9d with SMTP id p6-20020a056512328600b004f871279b9dmr1478948lfe.37.1687177295326;
        Mon, 19 Jun 2023 05:21:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Ja7N7ynoEdw3gVBRjtgeD5bqeanvdmHPH1S5c1ZXM6MVwIxYJ0TZf0dca8krz+8Q4ueDjKA==
X-Received: by 2002:a05:6512:3286:b0:4f8:7127:9b9d with SMTP id p6-20020a056512328600b004f871279b9dmr1478921lfe.37.1687177294844;
        Mon, 19 Jun 2023 05:21:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c72f:7100:cede:6433:a77b:41e9? (p200300cbc72f7100cede6433a77b41e9.dip0.t-ipconnect.de. [2003:cb:c72f:7100:cede:6433:a77b:41e9])
        by smtp.gmail.com with ESMTPSA id m9-20020a056000008900b0030ae499da59sm31424013wrx.111.2023.06.19.05.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 05:21:34 -0700 (PDT)
Message-ID: <723dd9da-ebd5-edb0-e9e5-2d8c14aaffe2@redhat.com>
Date:   Mon, 19 Jun 2023 14:21:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
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
 <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.06.23 16:27, Kai Huang wrote:
> TDX memory has integrity and confidentiality protections.  Violations of
> this integrity protection are supposed to only affect TDX operations and
> are never supposed to affect the host kernel itself.  In other words,
> the host kernel should never, itself, see machine checks induced by the
> TDX integrity hardware.
> 
> Alas, the first few generations of TDX hardware have an erratum.  A
> "partial" write to a TDX private memory cacheline will silently "poison"
> the line.  Subsequent reads will consume the poison and generate a
> machine check.  According to the TDX hardware spec, neither of these
> things should have happened.
> 
> Virtually all kernel memory accesses operations happen in full
> cachelines.  In practice, writing a "byte" of memory usually reads a 64
> byte cacheline of memory, modifies it, then writes the whole line back.
> Those operations do not trigger this problem.

So, ordinary writes to TD private memory are not a problem? I thought 
one motivation for the unmapped-guest-memory discussion was to prevent 
host (userspace) writes to such memory because it would trigger a MC and 
eventually crash the host.

I recall that this would happen easily (not just in some weird "partial" 
case and that the spec would allow for it)

1) Does that, in general, not happen anymore (was the hardware fixed?)?

2) Will new hardware prevent/"fix" that completely (was the spec updated?)?


... or was my understanding wrong?

Thanks!

> 
> This problem is triggered by "partial" writes where a write transaction
> of less than cacheline lands at the memory controller.  The CPU does
> these via non-temporal write instructions (like MOVNTI), or through
> UC/WC memory mappings.  The issue can also be triggered away from the
> CPU by devices doing partial writes via DMA.
> 
> With this erratum, there are additional things need to be done around
> machine check handler and kexec(), etc.  Similar to other CPU bugs, use
> a CPU bug bit to indicate this erratum, and detect this erratum during
> early boot.  Note this bug reflects the hardware thus it is detected
> regardless of whether the kernel is built with TDX support or not.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v10 -> v11:
>   - New patch
> 
> ---
>   arch/x86/include/asm/cpufeatures.h |  1 +
>   arch/x86/kernel/cpu/intel.c        | 21 +++++++++++++++++++++
>   2 files changed, 22 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index cb8ca46213be..dc8701f8d88b 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -483,5 +483,6 @@
>   #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
>   #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
>   #define X86_BUG_SMT_RSB			X86_BUG(29) /* CPU is vulnerable to Cross-Thread Return Address Predictions */
> +#define X86_BUG_TDX_PW_MCE		X86_BUG(30) /* CPU may incur #MC if non-TD software does partial write to TDX private memory */
>   
>   #endif /* _ASM_X86_CPUFEATURES_H */
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 1c4639588ff9..251b333e53d2 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -1552,3 +1552,24 @@ u8 get_this_hybrid_cpu_type(void)
>   
>   	return cpuid_eax(0x0000001a) >> X86_HYBRID_CPU_TYPE_ID_SHIFT;
>   }
> +
> +/*
> + * These CPUs have an erratum.  A partial write from non-TD
> + * software (e.g. via MOVNTI variants or UC/WC mapping) to TDX
> + * private memory poisons that memory, and a subsequent read of
> + * that memory triggers #MC.
> + */
> +static const struct x86_cpu_id tdx_pw_mce_cpu_ids[] __initconst = {
> +	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, NULL),
> +	{ }
> +};
> +
> +static int __init tdx_erratum_detect(void)
> +{
> +	if (x86_match_cpu(tdx_pw_mce_cpu_ids))
> +		setup_force_cpu_bug(X86_BUG_TDX_PW_MCE);
> +
> +	return 0;
> +}
> +early_initcall(tdx_erratum_detect);

-- 
Cheers,

David / dhildenb


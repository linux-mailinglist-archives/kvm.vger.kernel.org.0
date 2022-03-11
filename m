Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A6D4D5E5D
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 10:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347477AbiCKJYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 04:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347464AbiCKJYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 04:24:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB8E862135
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 01:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646990606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KZy6BPxycAJaka0W+AV2zCpor0oUVfNi2iR5X6RpaRg=;
        b=HIncIemFBG00nLhJ0ef100LdmjOtV8OLEBMFYeAR+KzMOCSWvyKpfSzTglrafWPGXaIlip
        +GHojIsVbLwCYJiX/r6wo80E93fOziSAVDT0Fs4Aovt84lmXrXNUD//Z0qfDDtIabVsOiW
        S3+K0yBz+mqpnKwcU5xX3YYUkiZFpwA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-X0DM2WIXPQSfuzOTkl3k1Q-1; Fri, 11 Mar 2022 04:23:25 -0500
X-MC-Unique: X0DM2WIXPQSfuzOTkl3k1Q-1
Received: by mail-ej1-f72.google.com with SMTP id el10-20020a170907284a00b006db9df1f3bbso1211034ejc.5
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 01:23:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KZy6BPxycAJaka0W+AV2zCpor0oUVfNi2iR5X6RpaRg=;
        b=yHipQ8jEjoddvF2u4NlV1/XFo/1v1MnGgtH9cWAnpTJHvpGmF5FPoaSWMtiWdwrxAN
         8yhOAgobKhrt4CUOBaTsfXnsiGiCaqqdBU/kRYmoBuCMc8JW+JJEdK9RjZolXcELkXzE
         wGrMfJd6+O0r+784pov23zLpWL84EqiSFYh/0OiQMA6dRN2PjnIpCHKCIuowTuAFV3dj
         UqUHj5i6DvhYxuaNRTaD71X0THkcnKKp86sXAV6meHuCcvmZnfw59eGe1fSsny9fqM35
         /tYwBbNIUAiRHTkPSgjAyYITS+k1be93OZHC8C/6u3i6pQfPE01X/EQ6LdgCrBdpPwDr
         ebMQ==
X-Gm-Message-State: AOAM533UTmlHZA99AsSPmZRLX+53l6xqaYEHPfDfueJDE5LHFCznNLXi
        gBECcOPn9kPT+KF7kR6fpJlFOvFckJNTYHHH2Lhzt30T2+oP/qufVW2DN2ERZSXOkCu/R2ew3YW
        ORw2GDG4WPgBKti/hNAJJgI/+h4oMHpjmsXQS2i6txPh1AlZaI7UtDjaQjH+/puUH
X-Received: by 2002:a17:906:7304:b0:6da:9243:865 with SMTP id di4-20020a170906730400b006da92430865mr7722535ejc.665.1646990604027;
        Fri, 11 Mar 2022 01:23:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyg6ktZq/p2wn7aGR4nCdUvXHDS4TXu9ovOWhhookzQBwQNB90SyHFawfKKEPoRuAamdnRlKQ==
X-Received: by 2002:a17:906:7304:b0:6da:9243:865 with SMTP id di4-20020a170906730400b006da92430865mr7722513ejc.665.1646990603635;
        Fri, 11 Mar 2022 01:23:23 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q5-20020aa7cc05000000b004129baa5a94sm2989712edt.64.2022.03.11.01.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 01:23:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     jmattson@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: synthesize CPUID leaf 0x80000021h if useful
In-Reply-To: <20220309170928.1032664-3-pbonzini@redhat.com>
References: <20220309170928.1032664-1-pbonzini@redhat.com>
 <20220309170928.1032664-3-pbonzini@redhat.com>
Date:   Fri, 11 Mar 2022 10:23:22 +0100
Message-ID: <8735joalmd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Guests should have X86_BUG_NULL_SEG if and only if the host has the bug.
> Use the info from static_cpu_has_bug to form the 0x80000021 CPUID leaf
> that was defined for Zen3.  Userspace can then set the bit even on older
> CPUs that do not have the bug, such as Zen2.
>
> Do the same for X86_FEATURE_LFENCE_RDTSC as well, since various processors
> have had very different ways of detecting it and not all of them are
> available to userspace.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 30832aad402f..58b0b4e0263c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -723,6 +723,19 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>  		/* Hypervisor leaves are always synthesized by __do_cpuid_func.  */
>  		return entry;
>  
> +	case 0x80000000:
> +		/*
> +		 * 0x80000021 is sometimes synthesized by __do_cpuid_func, which
> +		 * would result in out-of-bounds calls to do_host_cpuid.
> +		 */
> +		{
> +			static int max_cpuid_80000000;
> +			if (!READ_ONCE(max_cpuid_80000000))
> +				WRITE_ONCE(max_cpuid_80000000, cpuid_eax(0x80000000));
> +			if (function > READ_ONCE(max_cpuid_80000000))

Out of pure curiosity: what READ_ONCE/WRITE_ONCEs are for here?

> +				return entry;
> +		}
> +

This hunk seems to have a small side effect beyond its description:
previously, KVM_CPUID_FLAG_SIGNIFCANT_INDEX was always returned for
0x8000001d leaf, even when it wasn't present on the host. With the
change, we will return 'entry' directly from here, with no flag
set. This is likely insignificant in the absence of the leaf.


>  	default:
>  		break;
>  	}
> @@ -1069,6 +1082,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	case 0x80000000:
>  		entry->eax = min(entry->eax, 0x80000021);
> +		/*
> +		 * Serializing LFENCE is reported in a multitude of ways,
> +		 * and NullSegClearsBase is not reported in CPUID on Zen2;
> +		 * help userspace by providing the CPUID leaf ourselves.
> +		 */
> +		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC)
> +		    || !static_cpu_has_bug(X86_BUG_NULL_SEG))
> +			entry->eax = max(entry->eax, 0x80000021);
>  		break;
>  	case 0x80000001:
>  		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
> @@ -1155,6 +1176,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		 *   EAX      13     PCMSR, Prefetch control MSR
>  		 */
>  		entry->eax &= BIT(0) | BIT(2) | BIT(6);
> +		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
> +			entry->eax |= BIT(2);
> +		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
> +			entry->eax |= BIT(6);
>  		break;
>  	/*Add support for Centaur's CPUID instruction*/
>  	case 0xC0000000:

-- 
Vitaly


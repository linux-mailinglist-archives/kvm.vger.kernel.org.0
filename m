Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103D73668B4
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 12:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbhDUKBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 06:01:05 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:39637 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234678AbhDUKBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 06:01:02 -0400
Received: by mail-wm1-f42.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so931494wmq.4;
        Wed, 21 Apr 2021 03:00:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bDvQUUz8ej1+0YImN7WeZqcWme2grbE/EnUCkHf+ALc=;
        b=GMX/fhuUG9KcVNlBjVZMgOhRbhA37P6q1eyMm0JBV80PC4Uv4mv7hQXTE/k7aAwyCd
         qty8AGcNBcye15i6sd0VQ562T59nlAdiPCIYKWEiaKx4w/EkiHeeLlG5cqXEbtGgfqqT
         DgHPiYFk4ea5DiTJCrI0O62DA+0XKrKZUFlvTPkFkiGawGSIx+yAdTKlSANCcuKGjKO3
         Pt1z5CL8tdLL4O1/Twcz0JP999iaJ9EjCDMothI4LhoGceuofRzDMANsfQzWdHWDMfUF
         cZo2epBLGL/t7M6bdHisxazBfMZ5iJMOXGoe4cJAH8VyxbWZwxk9LeKXTEU9TcnoMH5K
         KfSg==
X-Gm-Message-State: AOAM531euvwR3hg0ktIIOlNUPiWFGuBWAekMQQZ3njeChT4H93Tsqtp4
        kUPns3GZGH4thjMApmAxKm4=
X-Google-Smtp-Source: ABdhPJxf9b7fxa5IUtu8ExJXHsiNgLCEAni5N5dBXLj6L3+vQfEL3WH/Nd7sFk5p/8IGeNCpkSFiNg==
X-Received: by 2002:a1c:f608:: with SMTP id w8mr9098399wmc.44.1618999228362;
        Wed, 21 Apr 2021 03:00:28 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id v7sm2534897wrs.2.2021.04.21.03.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 03:00:28 -0700 (PDT)
Date:   Wed, 21 Apr 2021 10:00:26 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 2/7] hyperv: SVM enlightened TLB flush support flag
Message-ID: <20210421100026.4hcgrxeri444if45@liuwe-devbox-debian-v2>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <3fd0cdfb9a4164a3fb90351db4dc10f52a7c4819.1618492553.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fd0cdfb9a4164a3fb90351db4dc10f52a7c4819.1618492553.git.viremana@linux.microsoft.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 01:43:37PM +0000, Vineeth Pillai wrote:
> Bit 22 of HYPERV_CPUID_FEATURES.EDX is specific to SVM and specifies
> support for enlightened TLB flush. With this enlightenment enabled,
> ASID invalidations flushes only gva->hpa entries. To flush TLB entries
> derived from NPT, hypercalls should be used
> (HvFlushGuestPhysicalAddressSpace or HvFlushGuestPhysicalAddressList)
> 
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 606f5cc579b2..005bf14d0449 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -133,6 +133,15 @@
>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
>  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
>  
> +/*
> + * This is specific to AMD and specifies that enlightened TLB flush is
> + * supported. If guest opts in to this feature, ASID invalidations only
> + * flushes gva -> hpa mapping entries. To flush the TLB entries derived
> + * from NPT, hypercalls should be used (HvFlushGuestPhysicalAddressSpace
> + * or HvFlushGuestPhysicalAddressList).
> + */
> +#define HV_X64_NESTED_ENLIGHTENED_TLB			BIT(22)
> +

This is not yet documented in TLFS, right? I can't find this bit in the
latest edition (6.0b).

My first thought is the comment says this is AMD specific but the name
is rather generic. That looks a bit odd to begin with.

Wei.

>  /* HYPERV_CPUID_ISOLATION_CONFIG.EAX bits. */
>  #define HV_PARAVISOR_PRESENT				BIT(0)
>  
> -- 
> 2.25.1
> 

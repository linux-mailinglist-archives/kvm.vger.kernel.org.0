Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9C51DF72F
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 14:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387820AbgEWMWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 08:22:04 -0400
Received: from mail.skyhub.de ([5.9.137.197]:32878 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387795AbgEWMWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 08:22:03 -0400
Received: from zn.tnic (p200300ec2f1b96000903d0e8ce6c3fc4.dip0.t-ipconnect.de [IPv6:2003:ec:2f1b:9600:903:d0e8:ce6c:3fc4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 34F781EC0322;
        Sat, 23 May 2020 14:22:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590236522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LDpR9wqJSbrif4ZbcLoGQ7gTT2in9pNC/j6i9ymqcoU=;
        b=ERV9ZPomgRSs3ujgmNTWDcBEpkhwfNwjqarfp7Ogeh+4yb5Z0ausqgOaileEtW0aHyV4yf
        DZ6jFtf4T+Ilk6LVC2hbcy16b2yBS7neJNTrllRKaKA/wLS5Va/h/odkjlhxztho+DDAnN
        ufu4NwDzYx73NnvlqZdxTzlytChL7tU=
Date:   Sat, 23 May 2020 14:21:49 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, x86@kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com, bigeasy@linutronix.de,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5] arch/x86: Update config and kernel doc for MPK
 feature on AMD
Message-ID: <20200523122149.GF27431@zn.tnic>
References: <158940940570.47998.17107695356894054769.stgit@naples-babu.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <158940940570.47998.17107695356894054769.stgit@naples-babu.amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 05:39:12PM -0500, Babu Moger wrote:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 1197b5596d5a..6b7303ccc1dd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1887,10 +1887,10 @@ config X86_UMIP
>  	  results are dummy.
>  
>  config X86_INTEL_MEMORY_PROTECTION_KEYS
> -	prompt "Intel Memory Protection Keys"
> +	prompt "Memory Protection Keys"
>  	def_bool y
>  	# Note: only available in 64-bit mode
> -	depends on CPU_SUP_INTEL && X86_64
> +	depends on X86_64 && (CPU_SUP_INTEL || CPU_SUP_AMD)
>  	select ARCH_USES_HIGH_VMA_FLAGS
>  	select ARCH_HAS_PKEYS
>  	---help---
> @@ -1902,6 +1902,13 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
>  
>  	  If unsure, say y.
>  
> +config X86_MEMORY_PROTECTION_KEYS
> +	# Set the "INTEL_"-free option whenever the "INTEL_" one is set.
> +	# The "INTEL_" one should be removed and replaced by this option
> +	# after 5.10. This avoids exposing most 'oldconfig' users to this
> +	# churn.
> +	def_bool X86_INTEL_MEMORY_PROTECTION_KEYS

I only picked up the discussion from the sidelines but why do we need
this at all? If we don't want to have churn, then we can leave it be
called X86_INTEL_MEMORY_PROTECTION_KEYS, not change the manpage and
have this depend on CPU_SUP_AMD too so that people can select it on AMD
machines, and get on with our lives.

So what's up?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

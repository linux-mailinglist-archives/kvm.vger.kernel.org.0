Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE56F4FFFA5
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 21:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiDMT6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 15:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiDMT6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 15:58:19 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718AE5D64D
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:55:57 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so7224833pjb.4
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 12:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vUBh+OLUNajJiIokVD1iNf3ZtZSL9ixkF7y86iwj2Ic=;
        b=anWdZBwYhczgXpwP44yXbydEmi8A9eQGD9lvZd0LIe/0ilOLqfChIxwlxeu3/miL8J
         VwKga2tG7/4evI/kSciDgOiND4E6nCLGetPqa22sMl7kVVvCWmMIPORDNjXP92TIF7h5
         ZtJOfWIgSDvbBbpQ0kSss4Ri+y+GkYQuSziiMDxy8OD0r38eGIa9zlosaQtfVb53RjPQ
         qcvceb6YtJf/3sPDKmKuQ7qkWIvjIInP5Z2gLrkyk5fCiUYB3S89pB0dDqWo40aOXGY4
         PdTUpCQnx378AGDHNrmjsNIg0Ya7fNzHc2vkHYYdBk1+WZ0TZaihsbTL5W3uIUqFl6zY
         f8SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vUBh+OLUNajJiIokVD1iNf3ZtZSL9ixkF7y86iwj2Ic=;
        b=droSFEBpIvG75lL/s6osHnCoqX1VuEpOHQIbOcCJrD/pgaozxDRJRSCDFNFDWUizPx
         m4zJLhetEnoY1f8viwZyLgWKUyJuVYsdY66GXhXm/E80/o7gmxzQFAPydHMOz8h/J/DI
         OLQNxE8ri1taBh0JdVAVA/PSjPdeAEyG7mwfnN6DaM84JeKIAo5pGXs93b13+hgoCnsY
         dgAIB2nW5FGLcf3k+1+ERQmR2ESxM4hxn7MvNHMXXOImxiXAgIoq+gzw7nrbGw7+2OhI
         FQaNwTclaG6wMccS+BAEi6AnMo0E8n0AgRy+BeMVJSUI/08hUkjCxeUUku/Qd8Ed/+9r
         RExw==
X-Gm-Message-State: AOAM530YJB1eYC/wB3W3/2D8VxGn/G8Hwz83w2nL9GNkT7Nnaejt5Es+
        TLx9GtXfIs+qzkVpUZ8VLjLWvw==
X-Google-Smtp-Source: ABdhPJwScNfaS4h92V5hPQvUOWvaUn27kSB4TynodJ0YKBaWXDycXTHRX9HbhYx4v8Y63vYO9u33+g==
X-Received: by 2002:a17:90b:1d04:b0:1c7:b10f:e33d with SMTP id on4-20020a17090b1d0400b001c7b10fe33dmr355299pjb.165.1649879756789;
        Wed, 13 Apr 2022 12:55:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o123-20020a634181000000b0039d300c417dsm6746907pga.64.2022.04.13.12.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:55:56 -0700 (PDT)
Date:   Wed, 13 Apr 2022 19:55:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 10/10] x86: Provide a common 64-bit AP
 entrypoint for EFI and non-EFI
Message-ID: <YlcqyGrXbvN/sufj@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-11-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-11-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Varad Gautam wrote:
> ap_start64() currently serves as the 64-bit entrypoint for non-EFI
> tests.
> 
> Having ap_start64() and save_id() written in asm prevents sharing these
> routines between EFI and non-EFI tests.
> 
> Rewrite them in C and use ap_start64 as the 64-bit entrypoint in the EFI
> boot flow.
> 
> With this, EFI tests support -smp > 1. smptest.efi now passes.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/asm/setup.h  |  3 +++
>  lib/x86/setup.c      | 54 +++++++++++++++++++++++++++++++++-----------
>  lib/x86/smp.c        |  1 +
>  x86/cstart64.S       | 24 --------------------
>  x86/efi/efistart64.S |  5 ----
>  5 files changed, 45 insertions(+), 42 deletions(-)
> 
> diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
> index 24d4fa9..8502e7d 100644
> --- a/lib/x86/asm/setup.h
> +++ b/lib/x86/asm/setup.h
> @@ -16,4 +16,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
>  void setup_5level_page_table(void);
>  #endif /* CONFIG_EFI */
>  
> +void save_id(void);
> +void ap_start64(void);
> +
>  #endif /* _X86_ASM_SETUP_H_ */
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index e2f7967..a0e0b0c 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -14,8 +14,12 @@
>  #include "apic.h"
>  #include "apic-defs.h"
>  #include "asm/setup.h"
> +#include "processor.h"
> +#include "atomic.h"
>  
>  extern char edata;
> +extern unsigned char online_cpus[(MAX_TEST_CPUS + 7) / 8];

This is also in lib/x86/apic.c, I think it makes sense to move the declaration
to smp.h.  And opportunistically tweak the open coded size to:

  extern unsigned char online_cpus[DIV_ROUND_UP(MAX_TEST_CPUS), BITS_PER_BYTE)];

> +extern unsigned cpu_online_count;

This should probably go into smp.h too, e.g. svm_tests.c also declares it.

> @@ -328,6 +334,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  	mask_pic_interrupts();
>  	setup_page_table();
>  	enable_apic();
> +	save_id();
>  	ap_init();
>  	enable_x2apic();
>  	smp_init();
> @@ -350,3 +357,24 @@ void setup_libcflat(void)
>  			add_setup_arg("bootloader");
>  	}
>  }
> +
> +void save_id(void)

save_id() is a very odd name for what this is doing.  Maybe mark_cpu_online()?
Or am I overlooking something?

> +{
> +	u32 id = apic_id();
> +
> +	/* atomic_fetch_or() emits `lock or %dl, (%eax)` */
> +	atomic_fetch_or(&online_cpus[id / 8], (1 << (id % 8)));

Heh, this makes my brain go "what!?!".  I strongly prefer we add^Wcopy the kernel's
arch_set_bit() into lib/x86/atomic.h as atomic_set_bit(), then this becomes

	atomic_set_bit(&online_cpus, apic_id());

which is waaay easier to understand.

> +}
> +
> +void ap_start64(void)
> +{
> +	setup_gdt_tss();
> +	reset_apic();
> +	load_idt();
> +	save_id();
> +	enable_apic();
> +	enable_x2apic();
> +	sti();

Hmm, so ap_start64 has a nop after the sti, presumably to consume the STI blocking
shadow.  _Why_ it needed to that, I have no idea, any pending IRQs should be
serviced prior to actually executing HLT.  Purely to be stupidly cautious, can
you drop the "nop" from ap_start64 in a prep patch?  Just so that if there's some
magic we're missing, it shows up in a more obvious bisect.

> +	atomic_fetch_inc(&cpu_online_count);
> +	asm volatile("1: hlt; jmp 1b");

Unless I'm missing something, this should work and makes it more obvious that
the vCPU is being put into a loop:

	for (;;)
		asm volatile("hlt");

or while(1) if that's your preference.

> +}

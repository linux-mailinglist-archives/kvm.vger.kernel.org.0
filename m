Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0254C4FF9D4
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 17:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbiDMPSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 11:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiDMPSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 11:18:33 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5131252AE
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:16:11 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b15so2286849pfm.5
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S81mWUde7ok/ZvydRRuIkKRgizdYvd+HNuP8EPEGAtE=;
        b=VIbc//BFlxRx9m9GIEUTevsa2hUZMwdyzSVBAU1fz2CZAw+OAllVn07QyIqCpqg64e
         6eqBLkz+zB14T/ZHKdHrh/IIx9NtscksJmvcZCebI6LwsWg3xl5ak/8SdgXk4LvANXGB
         3kbKhKKTQviMj9H/PaVe8sJpRsBt0x88nTQXzuRfQOdfZqoQnjUZy82PpIWwINfMJ3ZS
         yukyu6WME5hlT5xMGWKmlC/ObL8zEcoUkKl88tE9QGFumOWYk7oXVaaKxIKYLoWnwxsD
         b07I6avULqfHRUOmflZGNb5KbsPip7JLQI7sXYDh3GVv/bOsMIUxDszo7WZW2SPQiESP
         qUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S81mWUde7ok/ZvydRRuIkKRgizdYvd+HNuP8EPEGAtE=;
        b=DMp1pV4aEXJirzo81jUL3hSoeeGBPX+tYX+g7BVHK6Q3v1xYCGo4wLzVl7BhJxGTTx
         T9RrljojzOCfKt+ngApUAPMCFCbKbWrA+AM/C3LuY1cUzQi2Xrpwyrp/BbYY2X526xBi
         FFI36IWYQ0ocw3P+e2PsbWAdm3V6cNngA2vvJX7KY9eowE184YE5qbN8pieOBOS7+ubW
         jmekrMwxNdFG5JBPGs2VDFHnX1My7h1hYgTBPZIaMMFj5qGxSjT1SyDZoy2/aecB9jR+
         CIEAK8Liy0wkur1i0Z7LO+PQ/hiZaePHCNP4iET4kNeKklHWndMZd3wvOj4Nxf0Evrsn
         z1mA==
X-Gm-Message-State: AOAM533Qu6LcO79C1YzI7ZMn4Ikpmgwh7ZeWkvwub/PwPHL69Lt2SKpc
        Iuw81gVb6GSatIlop8+zw0Rsug==
X-Google-Smtp-Source: ABdhPJxupG61it2jlZAlOBz+oTQwjNn1T9jipRDaYDBz+Z/lVqvC44WrTh2oSFvKwxmjqto8kdcBGg==
X-Received: by 2002:a05:6a00:10cc:b0:4fe:3f1c:2d1 with SMTP id d12-20020a056a0010cc00b004fe3f1c02d1mr44262475pfu.0.1649862971070;
        Wed, 13 Apr 2022 08:16:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a005000b001c7511dc31esm3224092pjb.41.2022.04.13.08.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:16:10 -0700 (PDT)
Date:   Wed, 13 Apr 2022 15:16:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 01/10] x86: Move ap_init() to smp.c
Message-ID: <YlbpNtx66lVaZlAD@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-2-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-2-varad.gautam@suse.com>
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
> ap_init() copies the SIPI vector to lowmem, sends INIT/SIPI to APs
> and waits on the APs to come up.
> 
> Port this routine to C from asm and move it to smp.c to allow sharing
> this functionality between the EFI (-fPIC) and non-EFI builds.
> 
> Call ap_init() from the EFI setup path to reset the APs to a known
> location.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/setup.c      |  1 +
>  lib/x86/smp.c        | 28 ++++++++++++++++++++++++++--
>  lib/x86/smp.h        |  1 +
>  x86/cstart64.S       | 20 ++------------------

x86/cstart.S needs to join the party, without being kept in the loop KUT fails to
build on 32-bit targets.

	x86/vmexit.o x86/cstart.o lib/libcflat.a
lib/libcflat.a(smp.o): In function `ap_init':
/home/sean/go/src/kernel.org/kvm-unit-tests/lib/x86/smp.c:150: undefined reference to `sipi_end'
/home/sean/go/src/kernel.org/kvm-unit-tests/lib/x86/smp.c:150: undefined reference to `sipi_entry'
/home/sean/go/src/kernel.org/kvm-unit-tests/lib/x86/smp.c:155: undefined reference to `sipi_entry'
collect2: error: ld returned 1 exit status
/home/sean/go/src/kernel.org/kvm-unit-tests/x86/Makefile.common:65: recipe for target 'x86/vmexit.elf' failed

>  x86/efi/efistart64.S |  9 +++++++++
>  5 files changed, 39 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/x86/setup.c b/lib/x86/setup.c
> index 2d63a44..86ba6de 100644
> --- a/lib/x86/setup.c
> +++ b/lib/x86/setup.c
> @@ -323,6 +323,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  	load_idt();
>  	mask_pic_interrupts();
>  	enable_apic();
> +	ap_init();
>  	enable_x2apic();
>  	smp_init();
>  	setup_page_table();
> diff --git a/lib/x86/smp.c b/lib/x86/smp.c
> index 683b25d..d7f5aba 100644
> --- a/lib/x86/smp.c
> +++ b/lib/x86/smp.c
> @@ -18,6 +18,9 @@ static volatile int ipi_done;
>  static volatile bool ipi_wait;
>  static int _cpu_count;
>  static atomic_t active_cpus;
> +extern u8 sipi_entry;
> +extern u8 sipi_end;
> +volatile unsigned cpu_online_count = 1;

Please no bare "unsigned".  But that's a moot point because it actually needs to
be a u16, the asm code does incw.  That's also sort of a moot point because there's
zero chance any of this will work with 65536+ vCPUs, but it's still odd to see.

There's also a declaration in x86/svm_tests.c that needs to get deleted.

	extern u16 cpu_online_count;

Ooh, actually, an even better idea.  Make cpu_online_count a proper atomic_t,
same as active_cpus.  Then the volatile goes away.  Ugh, but atomic_t uses a
volatile.  *sigh*  At least that's contained in one spot that we can fix all at
once if someone gets motivated in the future.

And then rather than leave the

	lock incw cpu_online_count

in asm code, move that to C code to, e.g. ap_call_in() or something (there's gotta
be a standard-ish name for this).  The shortlog can be something like "Move AP
wakeup and rendezvous to smp.c.

And as a bonus, add a printf() in the C helper (assuming that doesn't cause
explosions) to state which AP came online.  That would be super helpful for debug
when someone breaks SMP boot.

>  static __attribute__((used)) void ipi(void)
>  {
> @@ -114,8 +117,6 @@ void smp_init(void)
>  	int i;
>  	void ipi_entry(void);
>  
> -	_cpu_count = fwcfg_get_nb_cpus();
> -
>  	setup_idt();
>  	init_apic_map();
>  	set_idt_entry(IPI_VECTOR, ipi_entry, 0);
> @@ -142,3 +143,26 @@ void smp_reset_apic(void)
>  
>  	atomic_inc(&active_cpus);
>  }
> +
> +void ap_init(void)
> +{
> +	u8 *dst_addr = 0;
> +	size_t sipi_sz = (&sipi_end - &sipi_entry) + 1;
> +
> +	asm volatile("cld");
> +
> +	/* Relocate SIPI vector to dst_addr so it can run in 16-bit mode. */
> +	memcpy(dst_addr, &sipi_entry, sipi_sz);
> +
> +	/* INIT */
> +	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
> +
> +	/* SIPI */
> +	apic_icr_write(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP, 0);
> +
> +	_cpu_count = fwcfg_get_nb_cpus();
> +

Similar to above, I would be in favor of opportunitically adding a printf to state
that the BSP is about to wait for N number of APs to come online, 
.
> +	while (_cpu_count != cpu_online_count) {
> +		;
> +	}

Curly braces technically aren't needed.

> +}
> diff --git a/lib/x86/smp.h b/lib/x86/smp.h
> index bd303c2..9c92853 100644

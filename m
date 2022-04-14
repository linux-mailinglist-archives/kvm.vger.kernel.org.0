Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088E1501BFF
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 21:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345678AbiDNTgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 15:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345497AbiDNTgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 15:36:19 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8578ECD81
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 12:33:53 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id i184so5143934pgc.2
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 12:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mP5Aa4ykeeVU9mNG8VJvuNMmCyx3vEV7eSR03zqaS3k=;
        b=GzR4JqRK7UXrefwCbzGPvShKTWz2eVIUpKLZjHfRR5O9h+f7aHy51Vb910lWts0Eaj
         aOl3uPUWhOgG98suuMP0AESfChP7wlEVmJkKFfCJREpWap6PDdNgdsFB8yQ9MECYUx6F
         JTUMcBEeQ4pIBLGinr2tTAI0qj5P5ErV6Y52Z/jE8/iaiT+zWOYjXKKhFTSyQW3MAbbp
         X/a807R1Z1gSsjmn+jfGLYuYszF+BElidCZhh0mwtpvZ/0GsK+ra9PNuhQ7K6L+cEwwh
         KasHojtzDCNhgeW2qJILuEdDkHcbynjyLVpQ7vqA+ylY/BvzoSuZDyVoBdijN274QIkd
         gHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mP5Aa4ykeeVU9mNG8VJvuNMmCyx3vEV7eSR03zqaS3k=;
        b=dxagRL3xwhojpNPttNVADOCmIyn63sTX2X3xUmZi/Z3x+GcRjoUHl2KvDNzziGHII6
         7Ux4SUAf9Uws3m7OE5I+GPkLvddS/9lvVmRKpUBRWHJm10Akw+wK4b5lpeZg9HgmuSAK
         iQzJpqXF9h7H45pYQA0fcBSRrB0mOpHNKBQ7UF2DMQY0lhysrNqbNVtuc/b4j5Fp3NXF
         PAlqsOYt4wa8JUgupF6lFs9WBoBkX6lTf4Gkvbo/R6Eeg45AnVj98OVGzDnSQolNrAkW
         aYnLTuLjNrod02aGKjTeYd3t6RZctwyOpuGdJNJTay7BA3Q/GkZA9jkSVoqAbOABjCUE
         ysjw==
X-Gm-Message-State: AOAM530SG7NDogo37jHmPwArtm4SXLSDYSW+gVtJZXGTFs9zwEIHgS04
        YH58OQsPp4SUH1w9a1ojEYCJ7w==
X-Google-Smtp-Source: ABdhPJxtMNQD7SBVfDF4PQFvP16KBmcXDYKZTTnwtfIZ8IP/TTSeV+RPTKmQguF019UYofBSgvRYvg==
X-Received: by 2002:a05:6a00:2290:b0:4fa:a99e:2e21 with SMTP id f16-20020a056a00229000b004faa99e2e21mr5415796pfe.20.1649964833145;
        Thu, 14 Apr 2022 12:33:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a15-20020a62e20f000000b00508363eee44sm593216pfi.219.2022.04.14.12.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 12:33:52 -0700 (PDT)
Date:   Thu, 14 Apr 2022 19:33:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Anton Romanov <romanton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <Ylh3HNlcJd8+P+em@google.com>
References: <20220414183127.4080873-1-romanton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414183127.4080873-1-romanton@google.com>
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

+Vitaly

On Thu, Apr 14, 2022, Anton Romanov wrote:
> Don't snapshot tsc_khz into per-cpu cpu_tsc_khz if the
> host TSC is constant, in which case the actual TSC frequency will never
> change and thus capturing TSC during initialization is
> unnecessary, KVM can simply use tsc_khz.
> This value is snapshotted from
> kvm_timer_init->kvmclock_cpu_online->tsc_khz_changed(NULL)

Nit, please wrap changelogs at ~75 chars.  It's not a hard rule, e.g. if running
over or cutting early improves readability, then by all means.  But wrapping
somewhat randomly makes reading the changelog unnecessarily difficult.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 547ba00ef64f..4ae9a03f549d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2907,6 +2907,19 @@ static void kvm_update_masterclock(struct kvm *kvm)
>  	kvm_end_pvclock_update(kvm);
>  }
>  
> +/*
> + * If kvm is built into kernel it is possible that tsc_khz saved into
> + * per-cpu cpu_tsc_khz was yet unrefined value. If CPU provides CONSTANT_TSC it
> + * doesn't make sense to snapshot it anyway so just return tsc_khz
> + */
> +static unsigned long get_cpu_tsc_khz(void)
> +{
> +	if (static_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		return tsc_khz;
> +	else
> +		return __this_cpu_read(cpu_tsc_khz);
> +}
> +
>  /* Called within read_seqcount_begin/retry for kvm->pvclock_sc.  */
>  static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  {
> @@ -2917,7 +2930,7 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  	get_cpu();
>  
>  	data->flags = 0;
> -	if (ka->use_master_clock && __this_cpu_read(cpu_tsc_khz)) {
> +	if (ka->use_master_clock && get_cpu_tsc_khz()) {

It might make sense to open code this to make it more obvious why the "else" path
exists.  That'd also eliminate a condition branch on CPUs with a constant TSC,
though I don't know if we care that much about the performance here.

	if (ka->use_master_clock &&
	    (static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz)))

And/or add a comment about cpu_tsc_khz being zero when the CPU is being offlined?

>  #ifdef CONFIG_X86_64
>  		struct timespec64 ts;
>  

...

> @@ -8646,9 +8659,12 @@ static void tsc_khz_changed(void *data)
>  	struct cpufreq_freqs *freq = data;
>  	unsigned long khz = 0;
>  
> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		return;

Vitaly,

The Hyper-V guest code also sets cpu_tsc_khz, should we WARN if that notifier is
invoked and Hyper-V told us there's a constant TSC?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..ca8e20f5ffc0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8701,6 +8701,8 @@ static void kvm_hyperv_tsc_notifier(void)
        struct kvm *kvm;
        int cpu;

+       WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_CONSTANT_TSC));
+
        mutex_lock(&kvm_lock);
        list_for_each_entry(kvm, &vm_list, vm_list)
                kvm_make_mclock_inprogress_request(kvm);

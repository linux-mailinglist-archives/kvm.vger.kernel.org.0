Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6444EE036
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 20:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbiCaSRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 14:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbiCaSRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 14:17:37 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427D9FFFB3
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:15:50 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bc27so432031pgb.4
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=06hKDOCgXqFCyZ353BYB4YZzW90RzyhwrczTGoEeb5k=;
        b=X7hkkbemNW6OzffrTh46zjMmYQZI5lZm0Ub38jqEkGCEE/cpixyjVrrmsoF3FsnXsN
         anaSPa36HB0w2TpJV9+XLL1tMIE/J4Zi1HL/jk74EkeTEqgjPJfyuCfwY64DRYF6tIgX
         d5vOcuA3p5KSB/7lfwJ7KcvmWtY1vgZtqW3YkUwipx/BjtjwtBJX7HTUvSEy0PIoUBap
         E3PY2m/FrvDJih/t20UMR1eubD1keGuWy8n5o4x77mSvVhrg6gIMa+9RzmK5nRWKFavg
         AcrCORsky538H7CrhBQXWZwfyUUs5HorGL2D68LY1PEbAmCvdbzSEXv2DxMSiVqRhoyN
         2K1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=06hKDOCgXqFCyZ353BYB4YZzW90RzyhwrczTGoEeb5k=;
        b=7XOt29KIG1pvbv7IONJRPlx58VjnwnYgfY6mKxd7rUlb8smHt8INkoTTnUDStoKAMr
         kQHQucHT/sCa5OGPzSa7fkzhGcLpveVNxduH695yft7v73rKVU2tCoOtEYSOmt3EzdR8
         jxRwV9s7mkW1Z9S1rIOEilr2shLJomREnTYY1jHqwOKqj17tvydzhQuzPlDx21JiBIxC
         CVDRvz9llUQP6G9SnF6QmfzUit4YIQOnXd/5yFL96++l9vgJB7TtrKwPHDQ/QPDvFQUA
         dULxFRLC4GcfGFdmphb7Xxp+iyWcdKcT9OzUh0DMbEA4pwZ1JnYxgrSiqtPdqTiBUkNy
         xNWg==
X-Gm-Message-State: AOAM532iwyhY2j16qxU2tR+nd/qvESNwCMkJbhuB/aFGP7NLRbtzZZvq
        hVhXEwO0WJH48GikKoZTGkcW23Q5Osef9w==
X-Google-Smtp-Source: ABdhPJxpYpzweixzMbimC/hTnt9mzpF6my3KPDIYHhBu+3h8EzzvnErDnW+dIYybbHm0ctC5iPfDoQ==
X-Received: by 2002:a63:443:0:b0:383:f97d:a16b with SMTP id 64-20020a630443000000b00383f97da16bmr11829665pge.297.1648750549267;
        Thu, 31 Mar 2022 11:15:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j8-20020a17090a060800b001c7936791d1sm56045pjj.7.2022.03.31.11.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 11:15:48 -0700 (PDT)
Date:   Thu, 31 Mar 2022 18:15:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jan Stancek <jstancek@redhat.com>
Cc:     Bruno Goncalves <bgoncalv@redhat.com>, kvm <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Li Wang <liwang@redhat.com>
Subject: Re: RIP: 0010:param_get_bool.cold+0x0/0x2 - LTP read_all_sys - 5.17.0
Message-ID: <YkXv0NoBjLBYBzX8@google.com>
References: <CA+QYu4q7K-pkAbMt3br_7O-Lu2OWyieLfyiju0PNEiy5YdKYzg@mail.gmail.com>
 <CAASaF6yhTpXcWhTyg5VSU6czPPws5+sQ3vR7AWC8xxM7Xm_BGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAASaF6yhTpXcWhTyg5VSU6czPPws5+sQ3vR7AWC8xxM7Xm_BGg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022, Jan Stancek wrote:
> +CC kvm
> 
> Issue seems to be that nx_huge_pages is not initialized (-1) and
> attempted to be used as boolean when reading
> /sys/module/kvm/parameters/nx_huge_pages

Ugh, CONFIG_UBSAN_BOOL=y complains about a bool not being 0 or 1.  What a pain.

> CONFIG_KVM=Y,  CONFIG_UBSAN=y, but kvm_mmu_module_init() doesn't
> appear to run, since kvm detects no HW support:
> # dmesg |grep kvm
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000003] kvm-clock: using sched offset of 1155425753112 cycles
> [    0.000007] clocksource: kvm-clock: mask: 0xffffffffffffffff
> max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
> [    0.045066] kvm-guest: PV spinlocks enabled
> [    0.705370] clocksource: Switched to clocksource kvm-clock
> [    0.913593] kvm: no hardware support for 'kvm_intel'
> [    0.915574] kvm: no hardware support for 'kvm_amd'
> [    2.284925] systemd[1]: Detected virtualization kvm.
> [    4.158909] Stack Depot allocating hash table with kvmalloc
> [    8.120446] systemd[1]: Detected virtualization kvm.
> 
> Initializing 'nx_huge_pages' to 0 (in out branch) or write to
> /sys/module/kvm/parameters/nx_huge_pages before read makes it go away
> too:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 02cf0a7e1d14..b3b8b9a22e20 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8921,6 +8921,7 @@ int kvm_arch_init(void *opaque)
>  out_free_x86_emulator_cache:
>         kmem_cache_destroy(x86_emulator_cache);
>  out:
> +       nx_huge_pages = 0;

This won't help, because nx_huge_pages is deliberately left as -1 if the vendor
module isn't loaded, in which case kvm_arch_init() won't be reached.  This would
also incorrectly disable the mitigation.

We could fix it by adding a proper accessor, but that's rather silly because KVM
doesn't actually need to wait until a vendor module is loaded to finalize its
value (-1 means "auto").  kvm.ko doesn't have its own module_init() hook on x86,
but that's easily solved and I think less gross than having Schrödinger's param.

I'll test and send a patch.

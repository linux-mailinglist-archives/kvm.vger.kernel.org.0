Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129137B36BF
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 17:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbjI2PZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 11:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbjI2PZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 11:25:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC41DE
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 08:25:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c73637061eso19894195ad.3
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 08:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696001132; x=1696605932; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MrDNr8f6Z5qN0vbmrw1mCG8rYx7bvil5wKSNF6/Mq+U=;
        b=levW37T9AsydaHcveGAUA/LXwPN1ncZ3nNYisyHc/5Pu8QwV9PT9qD81FygImZcCwb
         8ZWU3qNtcogow87IElw9HgymqekNMAhJv2bQBiGEw6v3Ci4vY50h+H8N73/ga0KNddfU
         GSPBIJrB42DSar7irErZ2xFwOzseElqTwINNzQnaDTX3ZKqis+7chbwrkPT6WeufvYRA
         SzcP/M3+NjCQxB3IvPdbXIx3GhzsiCb72YM4pcCguqXfnKtrMc7Zo4iue6pLnZPv2ypL
         Zsbnhp7Zsu+p0w3pMy/5lJ6WltF2m3V0czHJFctjFimzd2qYz7WLpeLgtdgH1WPKqC5k
         2P/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696001132; x=1696605932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MrDNr8f6Z5qN0vbmrw1mCG8rYx7bvil5wKSNF6/Mq+U=;
        b=cI1lEV+rhjxX9HHmSFkWXVHH2EnYUGSrp3w0uhaAlX4DHb6wrKh83HfmPtIXaCTCPt
         gK9QCltarGqjPiTGsE5jnNyeEohzM0Tvr6wVemEEXdgzzv9HIlx41QP7TG9ci8mrGFIN
         XXl6MZC88APjHK67w3QW4Ng5uvna+B/5cudZo+9mPbnxV9YhVKuMd+hloNfDoP860Es6
         zlv+UL1Nc8yJm2aLtUa65zxc+llY7ZdGWUgiBzXhETszNh9tecnCosNOalqTY4HkhIjG
         7TzX1zSh9WSha1uKyVe1SSlCaRjgv+2QNu8GkAQfEADaWljsMDdO5PRzb+KKOiTEqzPI
         PPPg==
X-Gm-Message-State: AOJu0YzlGypVy5Flzs184gqyX7K42acPzjkTYpqIEF93hD9b/HskuUon
        COXJpidT5lCd1y6Ey9RlsjNVGPXEv88=
X-Google-Smtp-Source: AGHT+IG5bijpDrzXLDJAxzzz6Eirv4KsCyI+4c5ytX0aUtrma2rXoHoWek6MWO15XAerU42qn4kArQcRC8g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:db06:b0:1b9:e338:a8b7 with SMTP id
 m6-20020a170902db0600b001b9e338a8b7mr70210plx.5.1696001132140; Fri, 29 Sep
 2023 08:25:32 -0700 (PDT)
Date:   Fri, 29 Sep 2023 15:25:30 +0000
In-Reply-To: <2f1a1bf1b359ff6164b91a06a6f9ed03f2d6204d.camel@amazon.co.uk>
Mime-Version: 1.0
References: <2f1a1bf1b359ff6164b91a06a6f9ed03f2d6204d.camel@amazon.co.uk>
Message-ID: <ZRbqyCXSClhkLttk@google.com>
Subject: Re: [RFC PATCH] KVM: x86: Generate guest PV wall clock info from a
 single TSC read
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw@amazon.co.uk>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "paul@xen.org" <paul@xen.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023, Woodhouse, David wrote:
> Poking around at various places which calculate the time "now" in some
> clock domain... then maybe get preempted for a while... and then
> compare that with the time "now" in the same or another clock domain. 
> 
> This one with its "ktime_get_real_ns() - get_kvmclock_ns(kvm);" seemed
> like perfect low-hanging fruit to start with.

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 04b57a336b34..0ec989bb61a1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2317,14 +2317,9 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_o
>  	if (kvm_write_guest(kvm, wall_clock, &version, sizeof(version)))
>  		return;
>  
> -	/*
> -	 * The guest calculates current wall clock time by adding
> -	 * system time (updated by kvm_guest_time_update below) to the
> -	 * wall clock specified here.  We do the reverse here.
> -	 */
> -	wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
> +	wall_nsec = kvm_get_wall_clock_epoch(kvm);

Possibly silly question: why can't preemption simply be disabled for the duration
of the sensitive calculation?

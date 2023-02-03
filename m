Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A020A68A3B9
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 21:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbjBCUok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 15:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjBCUoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 15:44:38 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6876F9DCAB
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 12:44:35 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso6034168pjb.4
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 12:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HFeFQYebQRR24NoxN2+qx/s/fgK8vHRENjBMrcH9q5s=;
        b=GAiWIeK2Gp8KfSOvXOckv3r0i6Y0/dmXOG6pla8vtF4hW2MVKZ3bUxF4g1zjGkDetQ
         gNOct9jcvbA9cEKTAIBrndx2gYtmdMMDI7ZXPrQb7NYTQrc0S3VcaCUhuMZRQQNKZT0s
         AtB+hMcUjRRpIBxStvokQGngGhOshJ9Cg5mc6vp8GueX2ticzQ2DOpncXwqxJyY77U+c
         d9IETBuxftRDekCPrNeTuo4Zj2ehaO+YDE4KAERSRmMaThdAQel2Hqg48SpPxlvvcQs7
         hx1pdI+/1DqLbIbDAmdbCvfw3xtikIo4o84iFDWxmQTUL/tY9uPEm4EBIC9JiE7l4H1l
         M8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HFeFQYebQRR24NoxN2+qx/s/fgK8vHRENjBMrcH9q5s=;
        b=CMJ939pcRpqA5J/fZJTQ8b7gYsRO3M/EKFi3RUweFNDARXZC9zV6pfIHHrv1QZ29DK
         550EWaom4SpfoQuW9kkB58Hc6/R2FFtLTtuJVZ1RKAzKjo6SIW1jwWrpVKjAgG/Zv5gk
         lQxnxsXx1LZ8ERcZUuvyaRX4Dd5bpdtMA6Tbkzzhal97jDql+rJN24O1HtZ877wlCnpW
         06b+zpllgV37+1GvEEG/6NQGEN2Q3AosDI8HGqNwSjZ7NS/z5gcAM23k7lb6m9TtKqlM
         EtoCfkkNkDsyLHhJVsi/yNGIA7rfdhiwI5XSOIG5FxzcD3Va1R7CV1ej4VmabGrUf3lj
         61Tg==
X-Gm-Message-State: AO0yUKUlIfVcwKSDN+IURCMIq2buU8F9ROs1HHraTsnK6Oh7zr+NCHy9
        LSHgXkmoBclAVFZJuGdGQfoqyg==
X-Google-Smtp-Source: AK7set+MOJw9wVTamJM/Vd0hm2/sRRD2GBzhp2YkB5jDMJsCwheeK22/iFuxpSj/GlhuywxWL3tfTA==
X-Received: by 2002:a17:903:2350:b0:198:af50:e4e8 with SMTP id c16-20020a170903235000b00198af50e4e8mr29596plh.14.1675457074755;
        Fri, 03 Feb 2023 12:44:34 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902e90400b0018544ad1e8esm2013212pld.238.2023.02.03.12.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 12:44:34 -0800 (PST)
Date:   Fri, 3 Feb 2023 20:44:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     lirongqing@baidu.com
Cc:     kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] KVM: x86: PIT: fix PIT shutdown
Message-ID: <Y91yLt3EZLA32csp@google.com>
References: <1675396608-24164-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1675396608-24164-1-git-send-email-lirongqing@baidu.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023, lirongqing@baidu.com wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> pit_shutdown() in drivers/clocksource/i8253.c doesn't work because
> setting the counter register to zero causes the PIT to start running
> again, negating the shutdown.

If this goes anywhere, the changelog needs to be rewritten to describe how KVM
is violating the 8253/8254 spec, not how code in Linux-as-a-guest breaks.

> 
> fix it by stopping pit timer and zeroing channel count
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/i8254.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index e0a7a0e..c8a51f5 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -358,13 +358,15 @@ static void create_pit_timer(struct kvm_pit *pit, u32 val, int is_period)
>  		}
>  	}
>  
> -	hrtimer_start(&ps->timer, ktime_add_ns(ktime_get(), interval),
> +	if (interval)
> +		hrtimer_start(&ps->timer, ktime_add_ns(ktime_get(), interval),
>  		      HRTIMER_MODE_ABS);
>  }
>  
>  static void pit_load_count(struct kvm_pit *pit, int channel, u32 val)
>  {
>  	struct kvm_kpit_state *ps = &pit->pit_state;
> +	u32 org = val;
>  
>  	pr_debug("load_count val is %u, channel is %d\n", val, channel);
>  
> @@ -386,6 +388,9 @@ static void pit_load_count(struct kvm_pit *pit, int channel, u32 val)
>  	 * mode 1 is one shot, mode 2 is period, otherwise del timer */
>  	switch (ps->channels[0].mode) {
>  	case 0:
> +		val = org;
> +		ps->channels[channel].count = val;
> +		fallthrough;

The existing behavior is KVM ABI, e.g. KVM_SET_PIT and KVM_SET_PIT2.  I'm also
not convinced that KVM is in the wrong here.  From the 8254 spec:

  The largest possible initial count is 0; this is equivalent to 216 for
  binary counting and 104 for BCD counting.

  The Counter does not stop when it reaches zero. In Modes 0, 1, 4, and 5 the
  Counter ‘‘wraps around’’ to the highest count, either FFFF hex for binary count-
  ing or 9999 for BCD counting, and continues counting. 

  Mode 0 is typically used for event counting. After the Control Word is written,
  OUT is initially low, and will remain low until the Counter reaches zero. OUT
  then goes high and remains high until a new count or a new Mode 0 Control Word
  is written into the Counter.

Maybe some actual hardware has a quirk where writing '0' disables the counter,
but per the spec, I think Hyper-V and KVM have it right.

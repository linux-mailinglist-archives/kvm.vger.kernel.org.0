Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42AD7A1FDA
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbjIONac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 09:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234348AbjIONaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 09:30:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EED18D;
        Fri, 15 Sep 2023 06:30:25 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1694784624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t4a69QAJHoLA0O/kevTly+3PbGRi/ca9qXsnMKQmmz4=;
        b=VvhyY2DjZI2vuivX7kUro9SCFkXJxhGEOzbmZVk78FLfzmED6+pXPF71mKfsEnmzi5ke/Y
        JzUSn+Y4ieqsib0SLhHkNeXeE0eeZdOPsxH9BFFg8IGHpqUHhgLFKbM9jjmOlkBUh0oI7i
        D0CUFWf00DY0DU2tvyKNA9Fy0I7H9gfSlZXnZdrEVs19CYik3pGy+KHhMjC7HIQUOPnBHB
        6rtDDAbD2aLigxZObvxapKneQW+ZtNScPpN+tl85LIxzZiGvpCw/J+HUOEkOuxNEzFQ6WK
        8Z7B7kQsYsXXU4WOrzqKpQOnKVj2jUk9bQFluXtkTHfD/+f37KWohaOdnnT1ZA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1694784624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t4a69QAJHoLA0O/kevTly+3PbGRi/ca9qXsnMKQmmz4=;
        b=MB7u8FElR3aNFJLb/9MfgTw1mqXDhAupHamM3e/Ij4hNRTGnIiKMXsws8Nk249DLQk0XIb
        2cTXmHAYSYrwk0Dg==
To:     Peter Hilber <peter.hilber@opensynergy.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     Peter Hilber <peter.hilber@opensynergy.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <jstultz@google.com>,
        Stephen Boyd <sboyd@kernel.org>, netdev@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH 4/4] treewide: Use clocksource id for struct
 system_counterval_t
In-Reply-To: <20230818011256.211078-5-peter.hilber@opensynergy.com>
References: <20230818011256.211078-1-peter.hilber@opensynergy.com>
 <20230818011256.211078-5-peter.hilber@opensynergy.com>
Date:   Fri, 15 Sep 2023 15:30:23 +0200
Message-ID: <87cyyj1s40.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter!

On Fri, Aug 18 2023 at 03:12, Peter Hilber wrote:
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -1313,7 +1313,7 @@ struct system_counterval_t convert_art_to_tsc(u64 art)
>  	res += tmp + art_to_tsc_offset;
>  
>  	return (struct system_counterval_t) {
> -		.cs = have_art ? &clocksource_tsc : NULL,
> +		.cs_id = have_art ? CSID_TSC : CSID_GENERIC,
>  		.cycles = res

Can you please change all of this so that:

    patch 1:   Adds cs_id to struct system_counterval_t
    patch 2-4: Add the clocksource ID and set the cs_id field
    patch 5:   Switches the core to evaluate cs_id
    patch 6:   Remove the cs field from system_counterval_t


> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -270,12 +270,12 @@ struct system_device_crosststamp {
>   * struct system_counterval_t - system counter value with the pointer to the
>   *				corresponding clocksource
>   * @cycles:	System counter value
> - * @cs:		Clocksource corresponding to system counter value. Used by
> + * @cs_id:	Clocksource corresponding to system counter value. Used by
>   *		timekeeping code to verify comparibility of two cycle values

That comment is inaccurate. It's not longer the clocksource itself. It's
the ID which is used for validation.

Thanks,

        tglx

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8144FBA8F
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 13:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243838AbiDKLNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 07:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345873AbiDKLKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 07:10:47 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789A845535;
        Mon, 11 Apr 2022 04:07:10 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649675228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ID9+1If3O1I5C3aUxVBIdshKrXYHLqFXQhU3D8qfgBk=;
        b=BWe/fVhB+hrDqGIsQVN2b1au9xQUDzrA1BjDP8e7Uro0Dk9kmI8GekP06spt1vgNs+8dhY
        XUjE9bJyradtliMB1dBmu9RHOpfLUGUohKh8bFcX2M3MVB8y3lgz/UhobzYiH3zlSPMUAZ
        9cxKfaqHD6ZGWhcrByB3KaafVa9gsQGORVEtUQpnXS7HbC19d5DYfh58Iu+8goW7K53bJk
        SWE7VH1lcqZPhmIZaMBLqgPEdlCPkV3U3yI0gmg84ICBkeU9RRz6fHBunvqJTYtVx2QLFh
        yaUJO/CYuYEq5OtFmKK779tuHwFkLBm23Effk2gk83Ob20gRVpa3EfcE/9TBqg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649675228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ID9+1If3O1I5C3aUxVBIdshKrXYHLqFXQhU3D8qfgBk=;
        b=41PicdIAirKVLp5CLX6NroganBHe4qSH7VB1GdOqBQR/Evh1Ubz1qNGRskL+zkwDGs2Y7u
        yR54zgYpJXCexJAw==
To:     Pete Swain <swine@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Johan Hovold <johan@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Pete Swain <swine@google.com>
Subject: Re: [PATCH 2/2] timers: retpoline mitigation for time funcs
In-Reply-To: <87r165gmoz.ffs@tglx>
References: <20220218221820.950118-1-swine@google.com>
 <20220218221820.950118-2-swine@google.com> <87r165gmoz.ffs@tglx>
Date:   Mon, 11 Apr 2022 13:07:08 +0200
Message-ID: <87mtgrg9pf.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 10 2022 at 14:14, Thomas Gleixner wrote:
> On Fri, Feb 18 2022 at 14:18, Pete Swain wrote:
>> @@ -245,7 +245,8 @@ static int clockevents_program_min_delta(struct clock_event_device *dev)
>>  
>>  		dev->retries++;
>>  		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
>> -		if (dev->set_next_event((unsigned long) clc, dev) == 0)
>> +		if (INDIRECT_CALL_1(dev->set_next_event, lapic_next_deadline,
>> +				  (unsigned long) clc, dev) == 0)
>
> No. We are not sprinkling x86'isms into generic code.

Even if we would do that, then this is completely useless.

The hotpath function is clockevents_program_event() and not
clockevents_program_min_delta().

The latter is invoked from the former if the to be programmed event is
in the past _and_ the force argument is set, i.e. in 0.1% of the
invocations of clockevents_program_event(), which itself has an indirect
call to dev->set_next_event().

If your profiles show clockevents_program_min_delta() as dominant, then
there is something massively wrong with your kernel.

Thanks,

        tglx






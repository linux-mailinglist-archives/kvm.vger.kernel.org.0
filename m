Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687D06553E3
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 20:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiLWThg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 14:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiLWThe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 14:37:34 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA33BDECE;
        Fri, 23 Dec 2022 11:37:32 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2BNJb9MD3005642
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 23 Dec 2022 11:37:10 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2BNJb9MD3005642
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022120601; t=1671824231;
        bh=Qn4FW1TH0CZmfO3agZG/vXsGinCfPqNTnCZdJgie3jE=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=RRMVBOTEuiEPVdFuXJGm+92ETA5Ple6V/9NBa5lhZZQGmPg4TO5eBwwklbAfpZV7t
         7W64vaeZHo/Vt0v6Tor3sCNSA4tIhNFLub+mieIgzHJooiI/jFsFGo1NL5tC4lcujg
         1KzzZZCmxCVyQFehSp3s8ZeJy1mYrz7vWrUw1EL2VbJqPJQYXOnSOz9YI31KLQvIg2
         C2MqZ17nlqbk7iPZJQ3EgWsknE7EF9w3k6bEw4B2ggYX2Zr0TdTMJkZAibdXO0RJ63
         8dgEHn1tNBsXGG8kPtveeLlr8r9N9iDClaXBWsDbyGyeXf9GQLfv9IuemKCP8LPL7l
         ipKNKDaYPtxaA==
Date:   Fri, 23 Dec 2022 11:37:07 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xin Li <xin3.li@intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ravi.v.shankar@intel.com" <ravi.v.shankar@intel.com>
Subject: Re: [RFC PATCH 22/32] x86/fred: FRED initialization code
User-Agent: K-9 Mail for Android
In-Reply-To: <16972e64-7d7b-ad8c-f8dc-6dcab69e629e@citrix.com>
References: <20221220063658.19271-1-xin3.li@intel.com> <20221220063658.19271-23-xin3.li@intel.com> <Y6GELyEJeKY3dEqJ@hirez.programming.kicks-ass.net> <16972e64-7d7b-ad8c-f8dc-6dcab69e629e@citrix.com>
Message-ID: <9D8B895D-0728-4451-BD22-B8EC78F90BEB@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On December 20, 2022 1:55:31 AM PST, Andrew Cooper <Andrew=2ECooper3@citrix=
=2Ecom> wrote:
>On 20/12/2022 9:45 am, Peter Zijlstra wrote:
>> On Mon, Dec 19, 2022 at 10:36:48PM -0800, Xin Li wrote:
>>
>>> +	wrmsrl(MSR_IA32_FRED_STKLVLS,
>>> +	       FRED_STKLVL(X86_TRAP_DB,  1) |
>>> +	       FRED_STKLVL(X86_TRAP_NMI, 2) |
>>> +	       FRED_STKLVL(X86_TRAP_MC,  2) |
>>> +	       FRED_STKLVL(X86_TRAP_DF,  3));
>>> +
>>> +	/* The FRED equivalents to IST stacks=2E=2E=2E */
>>> +	wrmsrl(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
>>> +	wrmsrl(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
>>> +	wrmsrl(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(DF));
>> Not quite=2E=2E IIRC fred only switches to another stack when the level=
 of
>> the exception is higher=2E Specifically, if we trigger #DB while inside
>> #NMI we will not switch to the #DB stack (since 1 < 2)=2E
>
>There needs to be a new stack for #DF, and just possibly one for #MC=2E=
=C2=A0
>NMI and #DB do not need separate stacks under FRED=2E
>
>> Now, as mentioned elsewhere, it all nests a lot saner, but stack
>> exhaustion is still a thing, given the above, what happens when a #DB
>> hits an #NMI which tickles a #VE or something?
>>
>> I don't think we've increased the exception stack size, but perhaps we
>> should for FRED?
>
>Not sure if it matters too much - it doesn't seem usefully different to
>IDT delivery=2E=C2=A0 #DB shouldn't get too deep, and NMI gets properly
>inhibited now=2E
>
>~Andrew
>

I still don't think you want to take #DB or =E2=80=93 especially =E2=80=93=
 NMI on the task stack while in the kernel=2E In fact, the plan is to get r=
id of the software irqstack handling, too, but at tglx's request that will =
be a later changeset (correctness first, then optimization=2E)


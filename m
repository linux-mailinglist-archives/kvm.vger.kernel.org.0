Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A4D68CB0E
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 01:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBGAXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 19:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBGAXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 19:23:52 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E262630B35;
        Mon,  6 Feb 2023 16:23:50 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675729429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G9ZmF26/BBvXjCM+aGdXeWYOqvithncTyiLz92QXj2w=;
        b=WllT0Ab36upe7bDg4v4dsbqxVTWSO/X44BU3PgsVOFBJjJbtJZaGL9kg0/DPVMc7y5Cbuy
        sfevmripk6VVFwzsSGu4avA2I07WCzoPjnFN63GC8mRCi9GMN8Ka/Y3j48jBOz0DMLjH8W
        Yk5h8lHbLlGcBLh39LH+lu951w8TtNkoQTzOjo7nO8lBDu+Mdu9KJ6hk8pc1vlA++R0VFw
        RoCYHjz5sBCjB10PebWBeob1gt4ifbmD1BMaX6Y7+25w6cRV/4+TToCFORBhHhR2NkQIop
        Gek+4KPVkfJ/Axb2Ji6YbBv7FCvPjB8Ve1DOpzrYIEEUZ6fERDKMs4mTIF+nYg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675729429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G9ZmF26/BBvXjCM+aGdXeWYOqvithncTyiLz92QXj2w=;
        b=SDni8O8mra+aLpXay3hdKHe66t8T5EitEJ1AdLD83KfZRvE4kFrSylwufkth1vArLhlueP
        H4tDQMbWSl4sCNBg==
To:     David Woodhouse <dwmw2@infradead.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Mario Limonciello <Mario.Limonciello@amd.com>
Subject: Re: [PATCH v6 07/11] x86/smpboot: Disable parallel boot for AMD CPUs
In-Reply-To: <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com>
 <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
 <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org>
Date:   Tue, 07 Feb 2023 01:23:48 +0100
Message-ID: <87pmamwcff.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 04 2023 at 15:40, David Woodhouse wrote:
> On Fri, 2023-02-03 at 13:48 -0600, Kim Phillips wrote:
>> Then:
>>=20
>> =C2=A0 - a Ryzen 3000 (Picasso A1/Zen+) notebook I have access to fails =
to boot.
>> =C2=A0 - Zen 2,3,4-based servers boot fine
>> =C2=A0 - a Zen1-based server doesn't boot.
>
> I've changed it to use CPUID 0xb only if we're actually in x2apic mode,
> which Boris tells me won't be the case on Zen1 because that doesn't
> support X2APIC.

Correct.

> When we're not in x2apic mode, we can use CPUID 0x1 because the 8 bits
> of APIC ID we find there are perfectly sufficient.

Is that worth the trouble?

> Even though we *can* support non-X2APIC processors, we *might* want to
> play it safe and not go back that far; only enabling parallel bringup
> on machines with X2APIC which roughly correlates with "lots of CPUs"
> since that's where the benefit is.

The parallel bringup code is complex enough already, so please don't
optimize for the non-interesting case in the first place. When this has
stabilized then the CPUID 0x1 mechanism can be added if anyone thinks
it's interesting. KISS is still the best engineering principle.

Thanks,

        tglx

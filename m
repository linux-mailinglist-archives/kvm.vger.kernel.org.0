Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0754A0329
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 22:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351643AbiA1VtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 16:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiA1VtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 16:49:04 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CE4C061714;
        Fri, 28 Jan 2022 13:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=rdH4gPd9NKdul5JzpYbJ81Fm1LwzMC9aJDXsx9B1P/E=; b=UzM9Dq2q8f37vTT3qITG0V/iZa
        HV5oEL9BVEc7vCvdhPcCEC5vH6DwcXO63voA/1nCJ1EoIoTZuHjvUMWoh9o+J8DFBLIMSEitdVhrb
        eW6h8Tzu/efpnBAEZQdorELqeVQFW9/lQAESxzMAlBYr7hf4wT0DJAOxJTRaPHBzpeuP6r0KpJfeN
        IDRZMU84k4Oy1QY/W6bUF+z7LZVM4zO1zs2S6pCOE2JDroM26UW0rEU1bTUNO4CiICvfH4mGvzayp
        rX7Hn1krX3+5LedqVouqrkVmUJZIAaM+j4lAPLnnOxHcp7zH+eNsvz0FDCviSmk3rfu4trHNcW403
        mrmxpqag==;
Received: from [2001:8b0:10b:1:5540:e506:9c75:1303] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nDZ6Y-004fC9-QD; Fri, 28 Jan 2022 21:48:29 +0000
Date:   Fri, 28 Jan 2022 21:48:26 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
CC:     Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
User-Agent: K-9 Mail for Android
In-Reply-To: <YfRi2sY0hVfri5eR@google.com>
References: <761c1552-0ca0-403b-3461-8426198180d0@amd.com> <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org> <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com> <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org> <1401c5a1-c8a2-cca1-e548-cab143f59d8f@amd.com> <2bfb13ed5d565ab09bd794f69a6ef2b1b75e507a.camel@infradead.org> <b798bcef-d750-ce42-986c-0d11d0bb47b0@amd.com> <41e63d89f1b2debc0280f243d7c8c3212e9499ee.camel@infradead.org> <c3dbd3b9-accf-bc28-f808-1d842d642309@amd.com> <7e92a196e67b1bfa37c1e61a789f2b75a735c06f.camel@infradead.org> <YfRi2sY0hVfri5eR@google.com>
Message-ID: <76B609E5-0203-4F2A-9348-4E88DC72AAF6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28 January 2022 21:40:42 GMT, Sean Christopherson <seanjc@google=2Ecom>=
 wrote:
>On Fri, Jan 28, 2022, David Woodhouse wrote:
>> On Fri, 2021-12-17 at 14:55 -0600, Tom Lendacky wrote:
>> > On 12/17/21 2:13 PM, David Woodhouse wrote:
>> > > On Fri, 2021-12-17 at 13:46 -0600, Tom Lendacky wrote:
>> > > > There's no WARN or PANIC, just a reset=2E I can look to try and c=
apture some
>> > > > KVM trace data if that would help=2E If so, let me know what even=
ts you'd
>> > > > like captured=2E
>> > >=20
>> > >=20
>> > > Could start with just kvm_run_exit?
>> > >=20
>> > > Reason 8 would be KVM_EXIT_SHUTDOWN and would potentially indicate =
a
>> > > triple fault=2E
>> >=20
>> > qemu-system-x86-24093   [005] =2E=2E=2E=2E=2E  1601=2E759486: kvm_exi=
t: vcpu 112 reason shutdown rip 0xffffffff81070574 info1 0x0000000000000000=
 info2 0x0000000000000000 intr_info 0x80000b08 error_code 0x00000000
>> >=20
>> > # addr2line -e woodhouse-build-x86_64/vmlinux 0xffffffff81070574
>> > /root/kernels/woodhouse-build-x86_64/=2E/arch/x86/include/asm/desc=2E=
h:272
>> >=20
>> > Which is: asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
>>=20
>> So, I remain utterly bemused by this, and the Milan *guests* I have
>> access to can't even kexec with a stock kernel; that is also "too fast"
>> and they take a triple fault during the bringup in much the same way =
=E2=80=94
>> even without my parallel patches, and even going back to fairly old
>> kernels=2E
>>=20
>> I wasn't able to follow up with raw serial output during the bringup to
>> pinpoint precisely where it happens, because the VM would tear itself
>> down in response to the triple fault without actually flushing the last
>> virtual serial output :)
>>=20
>> It would be really useful to get access to a suitable host where I can
>> spawn this in qemu and watch it fail=2E I am suspecting a chip-specific
>> quirk or bug at this point=2E
>
>Nope=2E  You missed a spot=2E  This also reproduces on a sufficiently lar=
ge Intel
>system (and Milan)=2E  initial_gs gets overwritten by common_cpu_up(), wh=
ich leads
>to a CPU getting the wrong MSR_GS_BASE and then the wrong raw_smp_process=
or_id(),
>resulting in cpu_init_exception_handling() stuffing the wrong GDT and lea=
ving a
>NULL TR descriptor for itself=2E
>
>You also have a lurking bug in the x2APIC ID handling=2E  Stripping the b=
oot flags
>from the prescribed APICID needs to happen before retrieving the x2APIC I=
D from
>CPUID, otherwise bits 31:16 of the ID will be lost=2E
>
>You owe me two beers ;-)

Oh Sean, I love you=2E

Thanks=2E

Will update and retest and resend=2E

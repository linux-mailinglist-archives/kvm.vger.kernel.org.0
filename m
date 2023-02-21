Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3CC69DB0C
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 08:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbjBUHRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 02:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbjBUHRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 02:17:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F5B4204;
        Mon, 20 Feb 2023 23:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=aUtZhwcFtwgw9BzG8RXhGgVJcrrtGKcENm6Kyn1StVI=; b=BUIB8VBBffBrLar9x9XbJKN0se
        dNCOehBXCghSV5mkOMzNjyOTAyWZ4TK8SfHAyWRa8DjjdYmSy0NvNSwxBWVzwzsqcQfPnkiZdeed7
        QgCD/xNPgY/Z0LvhHpcueiA5fkpGtPiOTpuuC7+Hc3EEduow7wQuRGmm+68ZpnXdfVLcpTfkS66SP
        1rFdCKiHYJLelpvhbIt1nc369V/Gcuk1nsWjq89sjo48sJKLzmq/mWiGQkST0dughHau0dSywvhdY
        Jep0jstP67FeeBkUKAXCXKCvmbiRiwIskJzeKquVIPIGMrxglic8Ya3JzPDZDwrIwfw0CQIV8B5Nw
        dmISnuFw==;
Received: from [2001:8b0:10b:5:f109:264d:11ca:a009] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pUMtN-00C4V4-2U;
        Tue, 21 Feb 2023 07:16:50 +0000
Date:   Tue, 21 Feb 2023 07:16:48 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Kim Phillips <kim.phillips@amd.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
CC:     tglx@linutronix.de, Usama Arif <usama.arif@bytedance.com>,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        Piotr Gorski <lucjan.lucjanov@gmail.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
User-Agent: K-9 Mail for Android
In-Reply-To: <6a25f9a6-c4c4-ddb4-a3c7-c151bd7f2a89@amd.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com> <2668799.mvXUDI8C0e@natalenko.name> <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org> <2668869.mvXUDI8C0e@natalenko.name> <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org> <982e1d6140705414e8fd60b990bd259a@natalenko.name> <715CBABF-4017-4784-8F30-5386F1524830@infradead.org> <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com> <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org> <6a25f9a6-c4c4-ddb4-a3c7-c151bd7f2a89@amd.com>
Message-ID: <DDB94D59-714C-4747-B67F-6C7424D068A1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21 February 2023 04:20:41 GMT, Kim Phillips <kim=2Ephillips@amd=2Ecom> =
wrote:
>On 2/20/23 5:30 PM, David Woodhouse wrote:
>> On Mon, 2023-02-20 at 17:23 -0600, Kim Phillips wrote:
>>> On 2/20/23 3:39 PM, David Woodhouse wrote:
>>>> On 20 February 2023 21:23:38 GMT, Oleksandr Natalenko <oleksandr@nata=
lenko=2Ename> wrote:
>>>>> On 20=2E02=2E2023 21:31, David Woodhouse wrote:
>>>>>> On Mon, 2023-02-20 at 17:40 +0100, Oleksandr Natalenko wrote:
>>>>>>> On pond=C4=9Bl=C3=AD 20=2E =C3=BAnora 2023 17:20:13 CET David Wood=
house wrote:
>>>>>>>> On Mon, 2023-02-20 at 17:08 +0100, Oleksandr Natalenko wrote:
>>>>>>>>>=20
>>>>>>>>> I've applied this to the v6=2E2 kernel, and suspend/resume broke=
 on
>>>>>>>>> my
>>>>>>>>> Ryzen 5950X desktop=2E The machine suspends just fine, but on
>>>>>>>>> resume
>>>>>>>>> the screen stays blank, and there's no visible disk I/O=2E
>>>>>>>>>=20
>>>>>>>>> Reverting the series brings suspend/resume back to working state=
=2E
>>>>>>>>=20
>>>>>>>> Hm, thanks=2E What if you add 'no_parallel_bringup' on the comman=
d
>>>>>>>> line?
>>>>>>>=20
>>>>>>> If the `no_parallel_bringup` param is added, the suspend/resume
>>>>>>> works=2E
>>>>>>=20
>>>>>> Thanks for the testing=2E Can I ask you to do one further test: app=
ly the
>>>>>> series only as far as patch 6/8 'x86/smpboot: Support parallel star=
tup
>>>>>> of secondary CPUs'=2E
>>>>>>=20
>>>>>> That will do the new startup asm sequence where each CPU finds its =
own
>>>>>> per-cpu data so it *could* work in parallel, but doesn't actually d=
o
>>>>>> the bringup in parallel yet=2E
>>>>>=20
>>>>> With patches 1 to 6 (including) applied and no extra cmdline
>>>>> params added the resume doesn't work=2E
>>>>=20
>>>> Hm=2E Kim, is there some weirdness with the way AMD CPUs get their
>>>> APIC ID in CPUID 0x1? Especially after resume?
>>>=20
>>> Not to my knowledge=2E=C2=A0 Mario?
>
>I tested v9-up-to-6/8 on a Ryzen 3000 that passed your between-v6 & v7
>tree commits (ce7e2d1e046a for the parallel-6=2E2-rc6-part1 tag
>and 17bbd12ee03 for parallel-6=2E2-rc6), and it, too, fails to resume
>v9-up-to-6/8 after suspend=2E
>
>> Oleksandr, please could you show the output of 'cpuid' after a
>> successful resume?  I'm particularly looking for this part=2E=2E=2E
>>=20
>>=20
>> $ sudo cpuid | grep -A1 1/ebx
>>     miscellaneous (1/ebx):
>>        process local APIC physical ID =3D 0x0 (0)
>> --
>>     miscellaneous (1/ebx):
>>        process local APIC physical ID =3D 0x2 (2)
>> =2E=2E=2E
>
>The Ryzens have a different pattern it seems:
>
>$ sudo cpuid | grep -A1 \(1/ebx
>   miscellaneous (1/ebx):
>      process local APIC physical ID =3D 0x0 (0)
>--
>   miscellaneous (1/ebx):
>      process local APIC physical ID =3D 0x1 (1)
>--
>   miscellaneous (1/ebx):
>      process local APIC physical ID =3D 0x2 (2)
>--
>   miscellaneous (1/ebx):
>      process local APIC physical ID =3D 0x3 (3)
>--
>   miscellaneous (1/ebx):
>      process local APIC physical ID =3D 0x4 (4)
>--
>   miscellaneous (1/ebx):
>      process local APIC physical ID =3D 0x5 (5)
>--
>   miscellaneous (1/ebx):
>      process local APIC physical ID =3D 0x6 (6)
>--
>   miscellaneous (1/ebx):
>      process local APIC physical ID =3D 0x7 (7)
>
>
>I tested the v7 series on Ryzen, it also fails, so
>Ryzen users were last known good with those two
>aforementioned commits on your tree:
>
>git://git=2Einfradead=2Eorg/users/dwmw2/linux=2Egit

That was when it was only using (and validating) CPUID 0xB and never trust=
ing CPUID 0x1, right?

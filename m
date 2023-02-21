Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129BE69DDDD
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 11:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbjBUK2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 05:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjBUK2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 05:28:32 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45FE93F3;
        Tue, 21 Feb 2023 02:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=+sCcPb6CoQW8fiM+WtJ9OnVrOM9cdW0QiHpN7tuGwAc=; b=K5XYLaRZRy0wFMI6ziCeJrG0rH
        L/95c6x6ZiC/iZeslQqtjbsC/gWpbRqtlR6Azt+Gc9wBIVOT9xUA4Z9lIYCBf7XqsMAe0Gz6gxvK1
        X43o1AYzLNqWjysW4ZrelUFy1LIItuLFZgUQtpwfqzZdv163exENK1kCmcPx7ZZFjYmdSfT7ir4LY
        5PsC3Y7MayUtA8edLCzEgbXDHXe9v1V6+aq6D+OuyhVmD8ci4+gqwvu6gHka//J4t8CPLg85OdHod
        LSi/JMh6m3PN5PKI4mJpMpSIreWmeoEmpX2dP1P3ERPocWncDyPCmSBJRml99tBhnMHeO+MbC1O6X
        krnINRGg==;
Received: from [2a00:23ee:1409:22b9:5717:6ed9:7d1a:8d4f] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pUPs2-00C85k-2f;
        Tue, 21 Feb 2023 10:27:39 +0000
Date:   Tue, 21 Feb 2023 10:27:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
CC:     Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
User-Agent: K-9 Mail for Android
In-Reply-To: <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
References: <20230215145425.420125-1-usama.arif@bytedance.com> <2668799.mvXUDI8C0e@natalenko.name> <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org> <2668869.mvXUDI8C0e@natalenko.name> <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org> <982e1d6140705414e8fd60b990bd259a@natalenko.name> <715CBABF-4017-4784-8F30-5386F1524830@infradead.org> <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com> <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org> <37c18c3aeea2e558633b6da6886111d0@natalenko.name> <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org> <3d8ed6e157df10c5175c636de0e21849@natalenko.name> <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org> <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name> <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org> <ce731b5a4a53680b4840467977b33d9a@natalenko.name> <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org> <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
Message-ID: <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
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



On 21 February 2023 09:49:51 GMT, Oleksandr Natalenko <oleksandr@natalenko=
=2Ename> wrote:
>On 21=2E02=2E2023 10:06, David Woodhouse wrote:
>> Why does arch/x86/kernel/acpi/sleep=2Ec::x86_acpi_suspend_lowlevel() se=
t
>>=20
>>     initial_gs =3D per_cpu_offset(smp_processor_id()) ?
>>=20
>> Would it not be CPU#0 that comes back up, and should it not get
>> per_cpu_offset(0) ?
>
>Wanna me try `initial_gs =3D per_cpu_offset(0);` too?

Hm, yes please=2E There's another one to make zero on the next line up, I =
think?

>> Or maybe we should just set up smpboot_control for the CPU to find its
>> own stuff, *even* on waking=2E Since the structures are already set up,
>> it isn't like a clean boot=2E
>>=20
>> If you let it boot in parallel mode, what if you just *remove* the line
>> that sets smpboot_control=3D0 ?
>
>If the `smpboot_control =3D 0;` line in arch/x86/kernel/acpi/sleep=2Ec::x=
86_acpi_suspend_lowlevel() is commented out, and the system is booted in pa=
rallel mode, then suspend/resume works=2E

Well that's entertaining=2E Now, can we come up with any theory which does=
n't leave us wondering why it ever worked in the first place=2E=2E=2E?

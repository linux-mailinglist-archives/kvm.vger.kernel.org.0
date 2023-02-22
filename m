Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EACF69F247
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 10:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjBVJ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 04:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjBVJzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 04:55:46 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6835759E9;
        Wed, 22 Feb 2023 01:54:26 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677058288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDlMfmqhMdFX7PRz+dvs1mIXbK5q+u+WakKLZ5Y6UeM=;
        b=MmTYkqREjEEVkGUJzQG0PK3n3AgJ/yU1gF+RJ0cEUZgk95syy3ZK1X59ygzmbsgETDzhXH
        ev/b4jQ3MlmenDMU/FmI9nyKDj+1XeZfvKb6gJh8HYMo03pCq8Oez2rGCAKViHzMCpKlAC
        IX5ySirflmqyzY6uBaZ11IgvIECuZy98GDFaSklh9kmC9A2kxwznYm6ZrBMZKxQSrfZ2xG
        e+B3dclHUZHK0ONRdJjC3xcfJcxhUed+nmEts77bw6J9cHdqrCArOPRPuiBZj/kUm6NHfo
        hxfOYP7Dqg4SuX+8LqZx0HxDE0vCBviVwdRY+fz2UvF5kw21P5qV3yAgcO/OSg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677058288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDlMfmqhMdFX7PRz+dvs1mIXbK5q+u+WakKLZ5Y6UeM=;
        b=kv7wrax4zru04yHnluN7jr8QGbNi+jU3yAL/uYV/E2z1GByScJiBknV8pkpN4XZqM6lOaS
        28AW0waTgzK8uLAg==
To:     David Woodhouse <dwmw2@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Kim Phillips <kim.phillips@amd.com>,
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
In-Reply-To: <aac036a17b1bcbabe8ee5a7c69fb2dfbc546d06e.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
 <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
 <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
 <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
 <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org>
 <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
 <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
 <f71275dc809cfb32df513023786c3faa@natalenko.name>
 <10CA27BB-ADC6-4421-86D2-A83BD7FA12E0@infradead.org>
 <9153284c37a79d303aa79dbf07c10329@natalenko.name>
 <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org>
 <87356yofw3.ffs@tglx>
 <aac036a17b1bcbabe8ee5a7c69fb2dfbc546d06e.camel@infradead.org>
Date:   Wed, 22 Feb 2023 10:31:27 +0100
Message-ID: <87fsaym4gg.ffs@tglx>
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

On Tue, Feb 21 2023 at 23:18, David Woodhouse wrote:
> On Tue, 2023-02-21 at 22:41 +0100, Thomas Gleixner wrote:
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (IS_ENABLED(CONFIG_64BIT) =
&& IS_ENABLED(CONFIG_SMP))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0smpboot_control =3D saved_smpboot_ctrl;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
>> =C2=A0}
>> =C2=A0
>
> But wait, why is this giving it a dedicated temp_stack anyway? Why
> can't it use that CPU's idle thread stack like we usually do? I already
> made idle_thread_get() accessible from here. So we could do this...

Because this very CPU is still online and from the kernels POV is does
not go offline. It goes into the firmware blackhole and comes back
magically through the startup code.

That means this very CPUs indle thread stack is in use and the resume
path will scribble over it. Maybe you won't notice because it only
clobbers top of stack which is never used again because the idle thread
does not return. But correct is something different.

Thanks,

        tglx

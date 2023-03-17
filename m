Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4FB6BF439
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 22:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjCQVfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 17:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjCQVfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 17:35:01 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5FD4BE95;
        Fri, 17 Mar 2023 14:34:22 -0700 (PDT)
Received: from [127.0.0.1] ([73.223.221.228])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 32HLWU9P3796329
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 17 Mar 2023 14:32:31 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 32HLWU9P3796329
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023030901; t=1679088752;
        bh=zouPmF5oIF79YFX+c7vh33GjORXIJQkkKwKkjw1JFCY=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=hIyEMEShpq66H/XKzls46Q/C4bEvmhNsuLYgZ0+YZGkdpP0jL8n3QUS/aDPOhrs7b
         7fR/3xj4+p+SibqLTQmyhqjVkBocHoqZMPeCJJ1msDdUq0K0T18DS1mJkYDod54Thq
         g7q/vsO15Bl86//xoAlaZ7xbSkjWhUgvS1VztmXzCYk6ZFtSemjXmR9xhvA3RxFT9O
         AHyEMbfcghTqd4OoMfERXO4l35FnH0lJzrQuz7EHjW+7EvhP0esP/F1gJe9bGaaryo
         r5+dpjBrUYUXVsf4R9L3WmKavQp79q/RVhunKwFUVmVfp0JVs3xHpezk1T3a3qvoab
         KlbvbbMLEPWKg==
Date:   Fri, 17 Mar 2023 14:32:28 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>, Xin Li <xin3.li@intel.com>
CC:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 22/34] x86/fred: FRED initialization code
User-Agent: K-9 Mail for Android
In-Reply-To: <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
References: <20230307023946.14516-1-xin3.li@intel.com> <20230307023946.14516-23-xin3.li@intel.com> <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
Message-ID: <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On March 17, 2023 6:35:57 AM PDT, Lai Jiangshan <jiangshanlai@gmail=2Ecom> =
wrote:
>Hello
>
>
>Comments in cpu_init_fred_exceptions() seem scarce for understanding=2E
>
>On Tue, Mar 7, 2023 at 11:07=E2=80=AFAM Xin Li <xin3=2Eli@intel=2Ecom> wr=
ote:
>
>> +/*
>> + * Initialize FRED on this CPU=2E This cannot be __init as it is calle=
d
>> + * during CPU hotplug=2E
>> + */
>> +void cpu_init_fred_exceptions(void)
>> +{
>> +       wrmsrl(MSR_IA32_FRED_CONFIG,
>> +              FRED_CONFIG_ENTRYPOINT(fred_entrypoint_user) |
>> +              FRED_CONFIG_REDZONE(8) | /* Reserve for CALL emulation *=
/
>> +              FRED_CONFIG_INT_STKLVL(0));
>
>What is it about "Reserve for CALL emulation"?
>
>I guess it relates to X86_TRAP_BP=2E In entry_64=2ES:
>
>        =2Eif \vector =3D=3D X86_TRAP_BP
>                /*
>                 * If coming from kernel space, create a 6-word gap to al=
low the
>                 * int3 handler to emulate a call instruction=2E
>                 */
>
>> +
>> +       wrmsrl(MSR_IA32_FRED_STKLVLS,
>> +              FRED_STKLVL(X86_TRAP_DB,  1) |
>> +              FRED_STKLVL(X86_TRAP_NMI, 2) |
>> +              FRED_STKLVL(X86_TRAP_MC,  2) |
>> +              FRED_STKLVL(X86_TRAP_DF,  3));
>
>Why each exception here needs a stack level > 0?
>Especially for X86_TRAP_DB and X86_TRAP_NMI=2E
>
>Why does or why does not X86_TRAP_VE have a stack level > 0?
>
>X86_TRAP_DF is the highest stack level, is it accidental
>or deliberate?
>
>Thanks
>Lai
>

Yes, the extra redzone space is there to allow for the call emulation with=
out having to adjust the stack frame "manually"=2E

In theory we could enable it only while code patching is in progress, but =
that would probably just result in stack overflows becoming utterly impossi=
ble to debug as we have to consider the worst case=2E

The purpose of separate stacks for NMI, #DB and #MC *in the kernel* (remem=
ber that user space faults are always taken on stack level 0) is to avoid o=
verflowing the kernel stack=2E #DB in the kernel would imply the use of a k=
ernel debugger=2E

#DF is the highest level because a #DF means "something went wrong *while =
delivering an exception*=2E" The number of cases for which that can happen =
with FRED is drastically reduced and basically amount to "the stack you poi=
nted me to is broken=2E"

Thus, you basically always want to change stacks on #DF, which means it sh=
ould be at the highest level=2E

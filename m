Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C876BF3C9
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 22:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCQVZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 17:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQVZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 17:25:02 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759F2193D3;
        Fri, 17 Mar 2023 14:24:03 -0700 (PDT)
Received: from [127.0.0.1] ([73.223.221.228])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 32HLNbaT3792533
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 17 Mar 2023 14:23:38 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 32HLNbaT3792533
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023030901; t=1679088218;
        bh=oAMmjE4TJMzJZO8CTkjR8XIl4V/fQ3mJbXZowitqlb0=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=W1SzppQDiWjH53UF6Xj/2S6hsuz/feCxq/q4OGI2bnZ6hMq/WRlkszEEzWbCRsREY
         Y3fjmYL6v7PlLZku4pFYKTcc3/0mYFyWRfdHwPl7QgPmKSoOJLA8quPrvjXKtX9xey
         IRebH6o6PKcMQ0HaPISdDHLON5vWN4HOaa32mO4Uxpjy30GGUwLzXl90N7w0VaGIeT
         pEl5kouv8Xdx1caYHtLj1X1kCSHJYo31cOtGRMf47zjC+7EZhBZU7ATss9BWUqgvM1
         q0JP6pFclqiUgFp26vpP8IxnWUQKbB24CP09SFxgm+AleYbWDNH6Zn7Qwf79X9Rz9C
         TtDt5znrsC8MA==
Date:   Fri, 17 Mar 2023 14:23:36 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>, andrew.cooper3@citrix.com
CC:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_28/34=5D_x86/fred=3A_fixup_fault_?= =?US-ASCII?Q?on_ERETU_by_jumping_to_fred=5Fentrypoint=5Fuser?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CAJhGHyAdyqWp_W3yHMn0euYG9TMctpSmNnqr_e+=FR3rN5UzpA@mail.gmail.com>
References: <20230307023946.14516-1-xin3.li@intel.com> <20230307023946.14516-29-xin3.li@intel.com> <CAJhGHyC6LgCwdDTkiy2TaQ8wzBQQfrx8ni7fY8vH-bUT2kR8pg@mail.gmail.com> <ed318bd6-25b2-efcf-0cc4-c57699f6654a@citrix.com> <CAJhGHyAdyqWp_W3yHMn0euYG9TMctpSmNnqr_e+=FR3rN5UzpA@mail.gmail.com>
Message-ID: <7F650B5F-7FD5-4DDD-9614-5AF0102CDBF1@zytor.com>
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

On March 17, 2023 6:02:52 AM PDT, Lai Jiangshan <jiangshanlai@gmail=2Ecom> =
wrote:
>On Fri, Mar 17, 2023 at 5:56=E2=80=AFPM <andrew=2Ecooper3@citrix=2Ecom> w=
rote:
>>
>> On 17/03/2023 9:39 am, Lai Jiangshan wrote:
>> >> +#ifdef CONFIG_X86_FRED
>> >> +static bool ex_handler_eretu(const struct exception_table_entry *fi=
xup,
>> >> +                            struct pt_regs *regs, unsigned long err=
or_code)
>> >> +{
>> >> +       struct pt_regs *uregs =3D (struct pt_regs *)(regs->sp - offs=
etof(struct pt_regs, ip));
>> >> +       unsigned short ss =3D uregs->ss;
>> >> +       unsigned short cs =3D uregs->cs;
>> >> +
>> >> +       fred_info(uregs)->edata =3D fred_event_data(regs);
>> >> +       uregs->ssx =3D regs->ssx;
>> >> +       uregs->ss =3D ss;
>> >> +       uregs->csx =3D regs->csx;
>> >> +       uregs->current_stack_level =3D 0;
>> >> +       uregs->cs =3D cs;
>> > Hello
>> >
>> > If the ERETU instruction had tried to return from NMI to ring3 and ju=
st faulted,
>> > is NMI still blocked?
>> >
>> > We know that IRET unconditionally enables NMI, but I can't find any c=
lue in the
>> > FRED's manual=2E
>> >
>> > In the pseudocode of ERETU in the manual, it seems that NMI is only e=
nabled when
>> > ERETU succeeds with bit28 in csx set=2E  If so, this code will fail t=
o reenable
>> > NMI if bit28 is not explicitly re-set in csx=2E
>>
>> IRET clearing NMI blocking is the source of an immense amount of grief,
>> and ultimately the reason why Linux and others can't use supervisor
>> shadow stacks at the moment=2E
>>
>> Changing this property, so NMIs only get unblocked on successful
>> execution of an ERET{S,U}, was a key demand of the FRED spec=2E
>>
>> i=2Ee=2E until you have successfully ERET*'d, you're still logically in=
 the
>> NMI handler and NMIs need to remain blocked even when handling the #GP
>> from a bad ERET=2E
>>
>
>Handling of the #GP for a bad ERETU can be rescheduled=2E It is not
>OK to reschedule with NMI blocked=2E
>
>I think "regs->nmi =3D 1;" (not uregs->nmi) can fix the problem=2E
>

You are quite correct, since what we want here is to emulate having taken =
the fault in user space =E2=80=93 which meant that NMI would have been re-e=
nabled by the never-executed return=2E

I think the "best" solution is:

regs->nmi =3D uregs->nmi;
uregs->nmi =3D 0;

=2E=2E=2E as enabling NMI is expected to have a performance penalty (being=
 the less common case, an implementation which has a performance difference=
 at all would want to optimize the non-NMI case), and I believe the compile=
r should be able to at least mostly fold those operations into ones it is d=
oing anyway=2E



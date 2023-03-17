Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FDC6BF367
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 22:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCQVBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 17:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCQVBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 17:01:13 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF6AB255A;
        Fri, 17 Mar 2023 14:01:10 -0700 (PDT)
Received: from [127.0.0.1] ([73.223.221.228])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 32HL0JoW3783027
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 17 Mar 2023 14:00:19 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 32HL0JoW3783027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023030901; t=1679086823;
        bh=c2Kk0W0ZsOg5b+toH7a7Rx0E39TD9h8rBmehVqukQMs=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=VcSJvQ+UT0GUldWk3BAuoQNtsFeqOQT6A1lhiVOq5cdc7yGLrXwjKT7rUY/ojfhzC
         EAe6yug/ZCDuaFYKlTw2vkKeRRxe/5wOhCNTJiWl6aJWA8ofNbVcXQ7owfnHPMWP2J
         WDXhpAKoNExwpTFoWOQuGqnxgLqTmQs4bvEhSZE21G16P904UIA9xQ+QIWgcjFnZuy
         ZmJ6uLm6tlb1iDCHS8CSZ9gXO8CwmdLs6lsBU6mSEFF8drFZBmb7P+y7pgmOOqg+is
         5tycNTtCTRw6PczmQt4Q/XRyVVnN1KHr+hlJwud0GVAEcnP3fBk85qNY9WGeu7KJmQ
         Gk0h4bbb/j2oA==
Date:   Fri, 17 Mar 2023 14:00:16 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     andrew.cooper3@citrix.com, Lai Jiangshan <jiangshanlai@gmail.com>,
        Xin Li <xin3.li@intel.com>
CC:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v5_28/34=5D_x86/fred=3A_fixup_fault_?= =?US-ASCII?Q?on_ERETU_by_jumping_to_fred=5Fentrypoint=5Fuser?=
User-Agent: K-9 Mail for Android
In-Reply-To: <ed318bd6-25b2-efcf-0cc4-c57699f6654a@citrix.com>
References: <20230307023946.14516-1-xin3.li@intel.com> <20230307023946.14516-29-xin3.li@intel.com> <CAJhGHyC6LgCwdDTkiy2TaQ8wzBQQfrx8ni7fY8vH-bUT2kR8pg@mail.gmail.com> <ed318bd6-25b2-efcf-0cc4-c57699f6654a@citrix.com>
Message-ID: <D3DB8A8F-7293-4715-AAB6-213F00CB521C@zytor.com>
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

On March 17, 2023 2:55:44 AM PDT, andrew=2Ecooper3@citrix=2Ecom wrote:
>On 17/03/2023 9:39 am, Lai Jiangshan wrote:
>>> +#ifdef CONFIG_X86_FRED
>>> +static bool ex_handler_eretu(const struct exception_table_entry *fixu=
p,
>>> +                            struct pt_regs *regs, unsigned long error=
_code)
>>> +{
>>> +       struct pt_regs *uregs =3D (struct pt_regs *)(regs->sp - offset=
of(struct pt_regs, ip));
>>> +       unsigned short ss =3D uregs->ss;
>>> +       unsigned short cs =3D uregs->cs;
>>> +
>>> +       fred_info(uregs)->edata =3D fred_event_data(regs);
>>> +       uregs->ssx =3D regs->ssx;
>>> +       uregs->ss =3D ss;
>>> +       uregs->csx =3D regs->csx;
>>> +       uregs->current_stack_level =3D 0;
>>> +       uregs->cs =3D cs;
>> Hello
>>
>> If the ERETU instruction had tried to return from NMI to ring3 and just=
 faulted,
>> is NMI still blocked?
>>
>> We know that IRET unconditionally enables NMI, but I can't find any clu=
e in the
>> FRED's manual=2E
>>
>> In the pseudocode of ERETU in the manual, it seems that NMI is only ena=
bled when
>> ERETU succeeds with bit28 in csx set=2E  If so, this code will fail to =
reenable
>> NMI if bit28 is not explicitly re-set in csx=2E
>
>IRET clearing NMI blocking is the source of an immense amount of grief,
>and ultimately the reason why Linux and others can't use supervisor
>shadow stacks at the moment=2E
>
>Changing this property, so NMIs only get unblocked on successful
>execution of an ERET{S,U}, was a key demand of the FRED spec=2E
>
>i=2Ee=2E until you have successfully ERET*'d, you're still logically in t=
he
>NMI handler and NMIs need to remain blocked even when handling the #GP
>from a bad ERET=2E
>
>~Andrew

This is correct=2E

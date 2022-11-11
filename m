Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D327F6256E1
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 10:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbiKKJa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 04:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiKKJa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 04:30:27 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695232BC1
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 01:30:25 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2AB9TcS21056258
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 11 Nov 2022 01:29:39 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2AB9TcS21056258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022110601; t=1668158979;
        bh=R0fe+AlnvAFw5TZnVBEA/ox25VFVoJ0d4AP+6Gt7TM4=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=05UPhLZXTWNGis4Ka61ZJSv1UBR1+wYpGfuz51prVuRV+/Kqxr43I2JiuWPmcxNgN
         +eozCh8ON1BvOgu9K/1WYxogId8NWZVK+LRjE1mb4IR21ugxB2Xh6Dbo2I3QHtawpz
         eoRbHk43X9XkjQGqSniEozncvZW2L5TnBUGEw3izidRmFeTFo562bf2C66yM99RYfG
         YDifyDF5iXlrWmmRbpgU9OshKhQfM1aO0LArNUbY/rj7i0iAS2teczh2uWX9mKOGzJ
         WBeqV7SeRvRZI1Cp67RiiiA09y5ccf/FY/YxkkBlobC3NR2DzkZEAbq/DkHSQdICEf
         lxv3atv2JDMhw==
Date:   Fri, 11 Nov 2022 01:29:35 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
CC:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernnel.org" <linux-kernel@vger.kernnel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_5/6=5D_KVM=3A_x86/VMX=3A_add_kvm=5Fvmx=5F?= =?US-ASCII?Q?reinject=5Fnmi=5Firq=28=29_for_NMI/IRQ_reinjection?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Y24Tm2P34jI3+E1R@hirez.programming.kicks-ass.net>
References: <20221110055347.7463-1-xin3.li@intel.com> <20221110055347.7463-6-xin3.li@intel.com> <Y20f8v9ObO+IPwU+@google.com> <BN6PR1101MB2161C2C3910C2912079122D2A8019@BN6PR1101MB2161.namprd11.prod.outlook.com> <Y21ktSq1QlWZxs6n@google.com> <Y24Tm2P34jI3+E1R@hirez.programming.kicks-ass.net>
Message-ID: <3A1B7743-9448-405A-8BE4-E1BDAB4D62F8@zytor.com>
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

On November 11, 2022 1:19:23 AM PST, Peter Zijlstra <peterz@infradead=2Eorg=
> wrote:
>On Thu, Nov 10, 2022 at 08:53:09PM +0000, Sean Christopherson wrote:
>> On Thu, Nov 10, 2022, Li, Xin3 wrote:
>
>> > > > + * call thus the values in the pt_regs structure are not used in
>> > > > + * executing NMI/IRQ handlers,
>> > >=20
>> > > Won't this break stack traces to some extent?
>> > >=20
>> >=20
>> > The pt_regs structure, and its IP/CS, is NOT part of the call stack, =
thus
>> > I don't see a problem=2E No?
>
>I'm not sure what Xin3 is trying to say, but NMI/IRQ handers use pt_regs
>a *LOT*=2E pt_regs *MUST* be correct=2E

What is "correct" in this context? Could you describe what aspects of the =
register image you rely on, and what you expect them to be? Currently KVM b=
asically stuff random data into pt_regs; this at least makes it explicitly =
zero=2E

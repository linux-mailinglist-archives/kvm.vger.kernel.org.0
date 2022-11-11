Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1890A626440
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 23:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiKKWPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 17:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbiKKWPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 17:15:53 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70274B997;
        Fri, 11 Nov 2022 14:15:52 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2ABMFVHF1233540
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 11 Nov 2022 14:15:31 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2ABMFVHF1233540
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022110601; t=1668204932;
        bh=O1ECDzgrNJ2QPuDyfHd9HOoEhnN8133IN4kF3vA+6+s=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=T0ygx/O3H50+9+1+AHzvNkwaqnjRalu4WVESpKwHH5p2IE1nM5m9SDNTICIyydXDs
         5XKctgVCQmZu2cS+1iqqUtNkuc1EiX+x9BsknQ++8yv8+NCh+jUjOBTI2kUq5sA04o
         bUO6nuhu/IcuR2/wywWSykPZHnNF2FMX4jLnX6IRJ9lw7iRnZiu3E1dtlkYAcEvO0F
         H758iwRWlxaH9s8KHbg+IRXR1yMXL7HhrLbIY6D1dCHApobnheBaJRYdoNint3gl8q
         7RHVGojMt2KlCPkIMJS+2wlJcW9tF19WyogJp3OXNPF0jT7GHYCx1tt0z1tWqaARf+
         B5Cb6cMJWnSrA==
Date:   Fri, 11 Nov 2022 14:15:28 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: =?US-ASCII?Q?Re=3A_=5BRESEND_PATCH_5/6=5D_KVM=3A_x86/VMX=3A_add_kvm=5F?= =?US-ASCII?Q?vmx=5Freinject=5Fnmi=5Firq=28=29_for_NMI/IRQ_reinjection?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com> <20221110061545.1531-6-xin3.li@intel.com> <Y2y+YgBUYuUHbPtd@hirez.programming.kicks-ass.net> <BN6PR1101MB2161976800EB14B74A24D9F3A8019@BN6PR1101MB2161.namprd11.prod.outlook.com> <Y24SoNKZtj/NPSGy@hirez.programming.kicks-ass.net> <6097036e-063f-5175-72b2-8935b12af853@redhat.com> <Y24908NWCdzUNqI0@hirez.programming.kicks-ass.net> <6fd26a70-3774-6ae7-73ea-4653aee106f0@redhat.com> <Y25a0Z2tOMWYZs4j@hirez.programming.kicks-ass.net>
Message-ID: <B2E59F6B-5C1F-4C6A-9DFB-43982059EA29@zytor.com>
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

On November 11, 2022 6:23:13 AM PST, Peter Zijlstra <peterz@infradead=2Eorg=
> wrote:
>On Fri, Nov 11, 2022 at 01:48:26PM +0100, Paolo Bonzini wrote:
>> On 11/11/22 13:19, Peter Zijlstra wrote:
>> > On Fri, Nov 11, 2022 at 01:04:27PM +0100, Paolo Bonzini wrote:
>> > > On Intel you can optionally make it hold onto IRQs, but NMIs are al=
ways
>> > > eaten by the VMEXIT and have to be reinjected manually=2E
>> >=20
>> > That 'optionally' thing worries me -- as in, KVM is currently
>> > opting-out?
>>=20
>> Yes, because "If the =E2=80=9Cprocess posted interrupts=E2=80=9D VM-exe=
cution control is 1,
>> the =E2=80=9Cacknowledge interrupt on exit=E2=80=9D VM-exit control is =
1" (SDM 26=2E2=2E1=2E1,
>> checks on VM-Execution Control Fields)=2E  Ipse dixit=2E  Posted interr=
upts are
>> available and used on all processors since I think Ivy Bridge=2E
>
>(imagine the non-coc compliant reaction here)
>
>So instead of fixing it, they made it worse :-(
>
>And now FRED is arguably making it worse again, and people wonder why I
>hate virt=2E=2E=2E

I object to saying that FRED is making it worse=2E Xin's patchset gets rid=
 of low-level assembly magic across the board and at least makes it obvious=
 what the code actually *does*, right now, as opposed to being buried in hi=
ghly questionable assembly=2E

It would also, regardless, be good to narrow down the set of possible even=
ts that may have to be reinjected to the absolute minimum, *and* document t=
hat in the code=2E

That being said, if there are better ways of doing it, we should, and you =
are certainly right that we may not have properly dug into if this code is =
even exercised on platforms which will have FRED=2E

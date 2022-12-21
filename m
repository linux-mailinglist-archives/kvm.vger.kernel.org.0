Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5902F652CBF
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 07:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbiLUGNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 01:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbiLUGNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 01:13:07 -0500
X-Greylist: delayed 1668 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 20 Dec 2022 22:13:05 PST
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DCBDEC7
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 22:13:04 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2BL5ia291992328
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 20 Dec 2022 21:44:37 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2BL5ia291992328
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022120601; t=1671601477;
        bh=g06yUmf4XATZkyNVgR70pXJdHh3OyYrnD4+iUtekOP0=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=AfI10PAjpzs+n5LqVD+Qa05VvlDwgACeb46Vt17Ao+doIuHBRWyNqkFvGJEBqmlN8
         5mIS91MSiHP/qhd9ll7DsigxcFKtDdEcqjzURjcJk+P6lWVW5fuVyft+wz93J8VYkz
         CmwJrZskvMG5CdzmO+vlYDnoaHJLGJmn0LT42OMe0+qhH2NLV77fah03noQ5l3t211
         Xj19RzruWD/fFavgQdDDUZAOCWmJOwWLGrXB/3KpyZ65QkZUzaG7UW/RtUOI39Lam+
         iJvIoPqy7f1nVrF/akj1UK3uWR1X/xa/X2iBztRW8z9iVSJaIlaMUst+MH/Ak222At
         qA8hL5CSwKbGA==
Date:   Tue, 20 Dec 2022 21:44:33 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [RFC PATCH 22/32] x86/fred: FRED initialization code
User-Agent: K-9 Mail for Android
In-Reply-To: <BN6PR1101MB2161C51C6068026D9C442460A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
References: <20221220063658.19271-1-xin3.li@intel.com> <20221220063658.19271-23-xin3.li@intel.com> <Y6GELyEJeKY3dEqJ@hirez.programming.kicks-ass.net> <16972e64-7d7b-ad8c-f8dc-6dcab69e629e@citrix.com> <Y6GIN5Uf7Qd43A9U@hirez.programming.kicks-ass.net> <BN6PR1101MB2161C51C6068026D9C442460A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com>
Message-ID: <0D72CCA1-A0B6-487B-A6B9-7341020D28A2@zytor.com>
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

On December 20, 2022 9:28:52 PM PST, "Li, Xin3" <xin3=2Eli@intel=2Ecom> wro=
te:
>> > >> +	wrmsrl(MSR_IA32_FRED_STKLVLS,
>> > >> +	       FRED_STKLVL(X86_TRAP_DB,  1) |
>> > >> +	       FRED_STKLVL(X86_TRAP_NMI, 2) |
>> > >> +	       FRED_STKLVL(X86_TRAP_MC,  2) |
>> > >> +	       FRED_STKLVL(X86_TRAP_DF,  3));
>> > >> +
>> > >> +	/* The FRED equivalents to IST stacks=2E=2E=2E */
>> > >> +	wrmsrl(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
>> > >> +	wrmsrl(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
>> > >> +	wrmsrl(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(DF));
>> > > Not quite=2E=2E IIRC fred only switches to another stack when the l=
evel
>> > > of the exception is higher=2E Specifically, if we trigger #DB while
>> > > inside #NMI we will not switch to the #DB stack (since 1 < 2)=2E
>
>Yes, current stack level can only grow higher=2E
>
>> >
>> > There needs to be a new stack for #DF, and just possibly one for #MC=
=2E
>> > NMI and #DB do not need separate stacks under FRED=2E
>>=20
>> True, there is very little need to use additional stacks with FRED=2E
>
>Pretty much=2E
>
>#DB/NMI from a ring 3 context uses CSL 0, and their CSLs increase only
>when happening from a ring 0 context=2E
>
>>=20
>> > > Now, as mentioned elsewhere, it all nests a lot saner, but stack
>> > > exhaustion is still a thing, given the above, what happens when a
>> > > #DB hits an #NMI which tickles a #VE or something?
>> > >
>> > > I don't think we've increased the exception stack size, but perhaps
>> > > we should for FRED?
>> >
>> > Not sure if it matters too much - it doesn't seem usefully different
>> > to IDT delivery=2E=C2=A0 #DB shouldn't get too deep, and NMI gets pro=
perly
>> > inhibited now=2E
>>=20
>> Both #DB and #NMI can end up in perf, and all that goes quite deep :/
>
>Can you please elaborate it a bit?
>

Right, this is one major reason for putting #DB/NMI in a separate stack le=
vel=2E

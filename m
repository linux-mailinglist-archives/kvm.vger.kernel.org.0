Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B494735DD0
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 21:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbjFSTR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 15:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjFSTRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 15:17:25 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6809BE43;
        Mon, 19 Jun 2023 12:17:24 -0700 (PDT)
Received: from [127.0.0.1] ([73.231.166.163])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 35JJGkjI1628956
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 19 Jun 2023 12:16:46 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 35JJGkjI1628956
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023061001; t=1687202207;
        bh=kJfhXsVPi+pfJA0Lp9P6VTxnR4ZmuO47neN0UGhoYOo=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=JL4bBGHQzvG/3uFHKIHRZ5eXf2HE0nUz3BUOo+x6QzrCzI3gTEC5F1t0j+84ozyE5
         gfpAhuJxZ9i9W9tKqYYtd+yBoHkBUswk1S3NEQdYeTpBu6Me3fZqZQFeURBteEOJN8
         48MDKN/wAGYSUH1Wx/dq/cQw2mWvmRpAI3rFabrh35tLQnT9NMJESpgn2w//finKEP
         j9HEuTMBGaggvpR5FsDUKb3PrRfSQj+jXPx6JcDwynkdb6BhalI4V8bnshv4VZzp4r
         mBLa4NUgOidtF56nmM2+U8a4wfo+7p+26giKW/acEhLAy8yySm4di/28lAi6dZYYPt
         xDoOL7+mEtYfQ==
Date:   Mon, 19 Jun 2023 12:16:44 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v8_01/33=5D_x86/traps=3A_let_common?= =?US-ASCII?Q?=5Finterrupt=28=29_handle_IRQ=5FMOVE=5FCLEANUP=5FVECTOR?=
User-Agent: K-9 Mail for Android
In-Reply-To: <SA1PR11MB673465675DA199C2C7EB1ADFA85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com> <20230410081438.1750-2-xin3.li@intel.com> <87leh08e1h.ffs@tglx> <87edmp6doh.ffs@tglx> <70ef07f1-e3b7-7c4e-01ac-11f159a87a6b@zytor.com> <877csgl5eo.ffs@tglx> <SA1PR11MB67344FE6C8A83810D0CAF175A85FA@SA1PR11MB6734.namprd11.prod.outlook.com> <877crzr0pq.ffs@tglx> <SA1PR11MB673465675DA199C2C7EB1ADFA85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <68D62BB9-8F8A-4269-AF7C-F568AE093A6D@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On June 19, 2023 11:47:08 AM PDT, "Li, Xin3" <xin3=2Eli@intel=2Ecom> wrote:
>> > To me it's better to keep the changes in one patch, thus the
>> > differences are more obvious=2E
>>=20
>> The rename to vector_schedule_cleanup() can be obviously done first=2E
>
>Okay, it's a bit wired to me to rename before any actual code logic chang=
e=2E
>

Weird or not, that's the established practice=2E

However, if you think about it, it makes sense: that way your code logic p=
atch doesn't contain a bunch of names which will almost immediately be outd=
ated=2E That is *really* confusing when you are going back through the git =
history, for example=2E

>>=20
>> > We need a second patch to do vector cleanup in lapic_offline() in cas=
e
>> > the vector cleanup timer has not expired=2E
>>=20
>> Right=2E I was lazy and just put a WARN_ON() there under the assumption=
 that you
>> will figure it out=2E
>
>I see that, as your changes to lapic_offline() are completely new=2E
>
>> But a second patch?
>>=20
>> We don't switch things over into a broken state first and then fix it u=
p afterwards=2E
>
>Make sense!
>


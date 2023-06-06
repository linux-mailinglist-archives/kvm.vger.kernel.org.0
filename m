Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD58725082
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240183AbjFFXJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240177AbjFFXJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:09:17 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B91E40;
        Tue,  6 Jun 2023 16:09:16 -0700 (PDT)
Received: from [127.0.0.1] ([73.231.166.163])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 356N8bGP252105
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 6 Jun 2023 16:08:38 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 356N8bGP252105
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023051001; t=1686092919;
        bh=3b9xHSYvK1ODTV6BLAv0xVWIguRKDFcGaSug0CbiWIs=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=lp8OgYN8Nx23gG0GBdp2+NF5VIeuZfk3Mo5Ojzsj+Y44jqyrVWIXOicehW2aKzVJp
         JqFVYxvpJSaQFciKtVPgROBTG6n5uMKrQ6XoszEuB3DWKLw+1FGssXStL/WYAbnSjM
         xR9oSt3qQchjTQTOHfpRuqCsHOlLmuaOY2ak401nGV7DVp1YPEoS2MNQWNvlvTvlfe
         Rt2E4Aw/ApX/GWC6zg+8n8f19g4//QqSuOvoc6idSr0BNyxoWM3XhyXGMqzAQs4jG6
         fFhB4o7T7ttvr6C2S/EufWurDsgxwhVNLkJhqTWJeFA2AZaQpwTJC0tnaNCs3RR/vS
         WhCwJC/MmG/Pw==
Date:   Tue, 06 Jun 2023 16:08:34 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Li, Xin3" <xin3.li@intel.com>,
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
Subject: RE: [PATCH v8 30/33] x86/fred: allow dynamic stack frame size
User-Agent: K-9 Mail for Android
In-Reply-To: <87fs74lo02.ffs@tglx>
References: <20230410081438.1750-1-xin3.li@intel.com> <20230410081438.1750-31-xin3.li@intel.com> <87wn0i578t.ffs@tglx> <SA1PR11MB673430AC2D6F20C5F77FC83AA852A@SA1PR11MB6734.namprd11.prod.outlook.com> <87fs74lo02.ffs@tglx>
Message-ID: <0CE0EA20-DCD8-43D0-8C66-562207CE0F97@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On June 6, 2023 6:27:25 AM PDT, Thomas Gleixner <tglx@linutronix=2Ede> wrot=
e:
>On Tue, Jun 06 2023 at 06:18, Xin3 Li wrote:
>>> > A FRED stack frame could contain different amount of information for
>>> > This approach also works for IDT, thus we unify the code=2E
>>>=20
>>> And thereby remove the useful comment and replace it with an undocumen=
ted
>>> macro mess=2E
>>>=20
>>> I'm simply refusing to review this=2E It's not my job to understand th=
is
>>> undocumented hackery=2E
>>>=20
>>
>> I believe it's a nice idea to allow dynamic stack frame size, at least =
for
>> FRED=2E
>
>Believe belongs in the realm of religion=2E What we need here are proper
>facts, explanations and justifications=2E Nice ideas are not helpful when
>they are not having a value=2E
>
>> It's totally my bad that I didn't make it meet the minimum standards,
>> I will rewrite the commit message and add better comments=2E
>>
>> After a second thought, I probably should only apply the change to FRED=
 for
>> 2 reasons, the change seems problematic with ESPFIX (which FRED
>> doesn't need),
>
>Indeed=2E Making this FRED only is going to need even more justification=
=2E
>
>> and such corner cases are hard to test (self-tests needed?)
>
>There is a test=2E It's not that hard to find:
>
># git grep -li ESPFIX tools/testing/selftests/
>tools/testing/selftests/x86/sigreturn=2Ec
>
>Thanks,
>
>        tglx

For what it is worth, I am working on a FRED forward compatibly document a=
t the moment=2E

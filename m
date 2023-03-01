Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0886C6A6561
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 03:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCACSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 21:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCACSX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 21:18:23 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE603303CC;
        Tue, 28 Feb 2023 18:18:13 -0800 (PST)
Received: from [127.0.0.1] ([73.223.221.228])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 3212Ha9f851151
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 28 Feb 2023 18:17:37 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 3212Ha9f851151
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023020601; t=1677637058;
        bh=6IbQZJhnFOlhC3qqva1am5R2ecLau7SASYNqCxQJVAw=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=crSHP7riXI6tzCCiCcc/yG9YtJv+zGuXN0PNfY0Aw5CEELjEIWPKma3NrG+z/9NM6
         QwkRlhUQ6H8hkIDMd34C7T4eeRXub4ERuz5VympWYb0rvBM1lEHYcveyoSSfrjHuRZ
         zXQuv7RHe1wPiHFy8c6WiVDM8Id2PgKUfhLLTH6HLME86jWzWKdWgxQsc8C5iEYHbZ
         wA4Hv1vsnuZzaFJJEsN7U+w9hrDzw+BU5VAZwU0BmML1p0XBijbiH8a+SqpY2nTvxS
         9+/fAKBuh1Wm3G9oSaGlAHolONAjGJXrEgUBXjj4USLVNNqg5vmKSwuuPPLTBOVNMD
         6ymRt6QJ2cGqw==
Date:   Tue, 28 Feb 2023 18:17:33 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: =?US-ASCII?Q?RE=3A_=5BRFC_PATCH_v3_15/32=5D_x86/fred=3A_make_unio?= =?US-ASCII?Q?ns_for_the_cs_and_ss_fields_in_struct_pt=5Fregs?=
User-Agent: K-9 Mail for Android
In-Reply-To: <SA1PR11MB673406B8B43E18F0BD11C8DBA8A89@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230224070145.3572-1-xin3.li@intel.com> <20230224070145.3572-16-xin3.li@intel.com> <bf1ad4c3-73eb-0f8f-e627-a7e0785fe903@citrix.com> <SA1PR11MB673406B8B43E18F0BD11C8DBA8A89@SA1PR11MB6734.namprd11.prod.outlook.com>
Message-ID: <89026D19-3E98-4D88-820B-36A29488D46D@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On February 24, 2023 8:34:36 AM PST, "Li, Xin3" <xin3=2Eli@intel=2Ecom> wro=
te:
>> > +	union {
>> > +		unsigned long  csl; /* CS + any fields above it */
>>=20
>> I guess that CSL here is supposed to mean cs long, but CSL (Current Sta=
ck Level) is a
>> new term in the FRED spec which isn't this=2E
>
>Good catch!
>
>>=20
>> This causes changes such as the final hunk in patch 27 to read incorrec=
tly, despite
>> being technically correct=2E
>>=20
>> cs_slot would be much clearer in code, but tbh, even cs_l would be bett=
er than the
>> version without an underscore=2E
>
>cs_slot sounds a good term unless someone comes up with a better one=2E
>
>>=20
>> And obviously, whatever is done here should be mirrored for ss=2E
>
>Probably ss_slot then=2E
>  Xin
>

I called it csx, for "cs extended"=2E "csq" would work, too=2E

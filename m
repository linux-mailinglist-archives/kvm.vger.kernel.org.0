Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC2A6168C6
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiKBQ3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiKBQ2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:28:38 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DFD13F;
        Wed,  2 Nov 2022 09:24:16 -0700 (PDT)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2A2GN1Vs193304
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 2 Nov 2022 09:23:02 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2A2GN1Vs193304
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022100601; t=1667406185;
        bh=2qhL9paa9Bl7NcpRAYoQBHnYYys+tFYJuc63a/wNIYo=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=KhcjIUs4JOQM6QdM8BkvkEYHy5B5naetJ5p05f4nXNwi7dHQsUlNXGHq9sSP+kGLB
         w2D9rEwDL+UAMJpOa3ENcn+m28FA3FjKPH3C5UlwNkOjoPbY5xpuk0mRfLsaQaa6v2
         CKW6UyQTl9lHGXaPWnv92pbKoRDNFr3vTo6ykHLkJtHG4pE8vCblV0HBXu0GQx2Ozk
         sq1IZBPhFyr1NWLC+iQBEsiYH7oaPuFNwk9Gwyz4HoJtPoA7JleF+w8f9p8zSa46+i
         VkstF+w7FahRyvNMT7YpOiWemAqf7ReKeNBGDhVbspPLUdPzlvFF6ymSsPK0bZI1y2
         aKlLPae2S9gnQ==
Date:   Wed, 02 Nov 2022 09:23:00 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v2_1/5=5D_perf/x86/intel/lbr=3A_use_?= =?US-ASCII?Q?setup=5Fclear=5Fcpu=5Fcap_instead_of_clear=5Fcpu=5Fcap?=
User-Agent: K-9 Mail for Android
In-Reply-To: <MW5PR84MB18428331677C881764E615D2AB399@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
References: <20220718141123.136106-1-mlevitsk@redhat.com> <20220718141123.136106-2-mlevitsk@redhat.com> <Yyh9RDbaRqUR1XSW@zn.tnic> <c105971a72dfe6d46ad75fb7e71f79ba716e081c.camel@redhat.com> <YzGlQBkCSJxY+8Jf@zn.tnic> <c1168e8bd9077a2cc9ef61ee06db7a4e8c0f1600.camel@redhat.com> <Y1EOBAaLbv2CXBDL@zn.tnic> <fd2cf028-bd83-57ff-7e6d-ef3ee11852a1@redhat.com> <MW5PR84MB18428331677C881764E615D2AB399@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Message-ID: <EFDA4E40-4133-4CED-97FA-DC75AEA24556@zytor.com>
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

On November 2, 2022 7:27:52 AM PDT, "Elliott, Robert (Servers)" <elliott@hp=
e=2Ecom> wrote:
>
>> From: Paolo Bonzini <pbonzini@redhat=2Ecom>
>=2E=2E=2E
>> (2) in particular holds even on bare metal=2E  The kernel bug here is t=
hat
>> X86_FEATURE_AVX only tells you if the instructions are _present_, not i=
f
>> they are _usable_=2E   Indeed, the XCR0 check is present for all other
>> files in arch/x86/crypto, either instead or in addition to
>> boot_cpu_has(X86_FEATURE_AVX)=2E
>>=20
>> Maxim had sent a patch about a year ago to do it in aesni-intel-glue=2E=
c
>> but Dave told him to fix the dependencies instead
>> (https://lore=2Ekernel=2Eorg/all/20211103124614=2E499580-1-
>> mlevitsk@redhat=2Ecom/)=2E
>>   What do you think of applying that patch instead?
>
>Most of the x86 crypto modules using X86_FEATURE_AVX do check
>	cpu_has_xfeatures(XFEATURE_MASK_YMM, =2E=2E=2E
>
>so it's probably prudent to add it to the rest (or remove it everywhere
>if it is not needed)=2E
>
>1=2E Currently checking XSAVE YMM:
>  aria_aesni_avx_glue
>  blake2s-glue
>  camellia_aesni_avx2_glue	camellia_aesni_avx_glue
>  cast5_avx_glue		cast6_avx_glue
>  chacha_glue
>  poly1305_glue
>  serpent_avx2_glue		serpent_avx_glue
>  sha1_ssse3_glue		sha256_ssse3_glue	sha512_ssse3_glue
>  sm3_avx_glue
>  sm4_aesni_avx2_glue	sm4_aesni_avx_glue
>  twofish_avx_glue
>
>Currently not checking XSAVE YMM:
>  aesni-intel_glue
>  curve25519-x86_64
>  nhpoly1305-avx2-glue
>  polyval-clmulni_glue
>
>2=2E Similarly, modules using X86_FEATURE_AVX512F, X86_FEATURE_AVXX512VL
>and/or X86_FEATURE_AVX512BW probably need to check XFEATURE_MASK_AVX512:
>
>Currently checking XSAVE AVX512:
>  blake2s-glue
>  poly1305_glue
>
>Currently not checking XSAVE AVX512:
>  chacha_glue
>
>3=2E Similarly, modules using X86_FEATURE_XMM2 probably need to
>check XFEATURE_MASK_SSE:
>
>Currently checking XSAVE SSE:
>  aegis128-aesni-glue=20
>
>Current not checking XSAVE SSE:
>  nhpoly1305-sse2_glue
>  serpent_sse2_glue
>
>
>

We have a dependency system for CPUID features=2E If you are going to do t=
his (as opposed to "fixing" this in Qemu or just saying "don't do that, it =
isn't a valid hardware configuration=2E"

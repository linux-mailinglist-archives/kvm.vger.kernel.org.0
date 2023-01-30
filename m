Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CDB68179F
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 18:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbjA3Rbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 12:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237494AbjA3Rbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 12:31:34 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C7AEB50;
        Mon, 30 Jan 2023 09:31:34 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 30UHUfiQ875323
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 30 Jan 2023 09:30:41 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 30UHUfiQ875323
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023010601; t=1675099842;
        bh=1OMV7D3alLF/hTc+OjG9AAs7EV4q+1GxI7A/kYjQhlo=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=ZjajhWdOhOPo+thk+Fq1fpTFJyy7NEVOS+/sGfSXf/3fpFvbsmL4zRP8vlNJLq1/B
         7WwDIfn6oHtfi+O9E4h5t3ZEbCLXCo/LpJA0e3VPRYb526jPSdQHS0wfxIm1Dmrizy
         dEwn/wryLV3iXWEYuf0Yrz7o972wQtCrYuwo66FtbgXYvJSDSGyp/cIsd7HAcMaiGi
         qP8EmlSZf4v5YaJjIztmy3/S+SpZruhRxPVba2gT97taTHE7bFd4mGyNKicu52Us79
         au1e9CqpyjWyCH3oCoDS9sqZZeh6h2faW1qmnvgxnG7NHfMcqobFXWUYbu/f3d/lfu
         dmxyqg8x1G5kQ==
Date:   Mon, 30 Jan 2023 09:30:38 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Alexey Kardashevskiy <aik@amd.com>, Joerg Roedel <joro@8bytes.org>
CC:     Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: =?US-ASCII?Q?Re=3A_=5BQuestion_PATCH_kernel=5D_x86/amd/sev/nmi+v?= =?US-ASCII?Q?c=3A_Fix_stack_handling_=28why_is_this_happening=3F=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
References: <20230127035616.508966-1-aik@amd.com> <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net> <Y9OpcoSacyOkPkvl@8bytes.org> <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com> <Y9QI9JwCVvRmtbr+@8bytes.org> <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
Message-ID: <38C572D7-E637-48C2-A57A-E62D44FF19BB@zytor.com>
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

On January 28, 2023 3:24:56 AM PST, Alexey Kardashevskiy <aik@amd=2Ecom> wr=
ote:
>
>
>On 28/1/23 04:25, Joerg Roedel wrote:
>> On Fri, Jan 27, 2023 at 10:56:26PM +1100, Alexey Kardashevskiy wrote:
>>> https://github=2Ecom/aik/linux/commit/d0d6bbb58fcd927ddd1f8e9d42ab1219=
20c7eafc
>>=20
>> Okay, I reproduced the problem here and the root cause turned out to be
>> that the compiler moved the DR7 read instruction before the 5-byte NOP
>> which becomes the call to sev_es_ist_enter() in SEV-ES guests=2E This i=
s
>> guaranteed to cause #VC exception stack recursion if the NMI was
>> triggered on the #VC stack, and that leads to all kinds of undefined
>> behavior=2E
>
>Cool!
>
>(out of curiosity) where do you see these NOPs? "objdump -D vmlinux" does=
 not show any, is this after lifepatching?
>
>Meanwhile, this seems to be doing the right thing:
>
>
>diff --git a/arch/x86/include/asm/debugreg=2Eh b/arch/x86/include/asm/deb=
ugreg=2Eh
>index b049d950612f=2E=2E687b15297057 100644
>--- a/arch/x86/include/asm/debugreg=2Eh
>+++ b/arch/x86/include/asm/debugreg=2Eh
>@@ -39,7 +39,7 @@ static __always_inline unsigned long native_get_debugre=
g(int regno)
>                asm("mov %%db6, %0" :"=3Dr" (val));
>                break;
>        case 7:
>-               asm("mov %%db7, %0" :"=3Dr" (val));
>+               asm volatile ("mov %%db7, %0" :"=3Dr" (val));
>
>
>

It's somewhat odd to me that reading %dr7 is volatile, but %dr6 is not=2E=
=2E=2E %dr6 is the status register!

I believe they should all be volatile (the compiler semantics is that vola=
tile operations are always executed exactly once, in strict program order w=
ith respect to any other volatile operations); the real question is if ther=
e should also be memory clobbers on %dr6 reads and any %dr write=2E

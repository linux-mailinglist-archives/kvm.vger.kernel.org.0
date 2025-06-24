Return-Path: <kvm+bounces-50440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19300AE5944
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 03:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F51F1B64736
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 01:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811981DED69;
	Tue, 24 Jun 2025 01:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="HfjP+2ui"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3D77B3E1;
	Tue, 24 Jun 2025 01:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750728804; cv=none; b=WylEsrcHwHZA5751krRLXkIho89mGZ+4bcgpdw2Jfzodmc6I0dq6xn3vnuwGSD8G2bZld6BTWoGV5He5OBHKvOAcvd1zkwNMATifZ2KSCgMMTbf8/uxcrNrZRwW4cbDoG0SI7ab+l7lDahW/kz+disb59Zo9NB6EV7rvOuBf6rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750728804; c=relaxed/simple;
	bh=DDXXpzThdkTMxz6jA6EtBoRknNT8Nxayy1Q97Mwhtg4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=ucJfcVTp9fWudtbW3Vy9yAwdoQRloKRXMCPWhGXe7Nz6CwPp0RXe0jIpysKxiEDTN8MRpOVM7mfcISIBf+JE9zMIK+wIKDEkIM151GD49524fr2ju7Hv6O57f+NGgsLUKhlVvP5dqg5M/57GDahdpL9ba3ClK561lavcIpNus1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=HfjP+2ui; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55O1WmW21156343
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 23 Jun 2025 18:32:48 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55O1WmW21156343
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750728769;
	bh=DDXXpzThdkTMxz6jA6EtBoRknNT8Nxayy1Q97Mwhtg4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=HfjP+2uigBiq+o5awIxrlOyCWB9f+/u3r3kV+CtD24rRnn0Z4BH4BmXh2bnE2aUZk
	 ilwwOHqnkZLf95xLiR2iyChzWTf+9KH0krNhQohFxt0Nnuey/jf4W5AJNi83TyhSg7
	 ZZQ5CWu4+qTcQ+cR+M2fydaOg6TiAxNflB4x3aJbLpcKVCGmErVimsn1/n5G7YUp4s
	 0lHgw1k+u6q8SzSpLd24SpO3cA9OVzjeDde1PwfV8S/S/Ru4P2EM2mMWdW7rvXlP00
	 aqZCDyY57h15l1Pe+mh4+vJqMtA4yalcyZ6xpumvnNnt+hoqS4T6TvsOIdwb+fyzl4
	 qGLU/CDzjwiHA==
Date: Mon, 23 Jun 2025 18:32:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Ethan Zhao <haifeng.zhao@linux.intel.com>, Xin Li <xin@zytor.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, sohil.mehta@intel.com,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_1/2=5D_x86/traps=3A_Initialize_D?=
 =?US-ASCII?Q?R6_by_writing_its_architectural_reset_value?=
User-Agent: K-9 Mail for Android
In-Reply-To: <8437bad1-bdae-4922-bf4c-9303872fab57@linux.intel.com>
References: <20250620231504.2676902-1-xin@zytor.com> <20250620231504.2676902-2-xin@zytor.com> <4018038c-8c96-49e0-b6b7-f54e0f52a65f@linux.intel.com> <b170c705-c2a8-44ac-a77d-0c3c73ebed0a@zytor.com> <8437bad1-bdae-4922-bf4c-9303872fab57@linux.intel.com>
Message-ID: <61C84739-1089-46B7-B99E-7AEBF79E5582@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 23, 2025 6:19:31 PM PDT, Ethan Zhao <haifeng=2Ezhao@linux=2Eintel=
=2Ecom> wrote:
>
>=E5=9C=A8 2025/6/24 0:34, Xin Li =E5=86=99=E9=81=93:
>> On 6/22/2025 11:49 PM, Ethan Zhao wrote:
>>>=20
>>> =E5=9C=A8 2025/6/21 7:15, Xin Li (Intel) =E5=86=99=E9=81=93:
>>>> Initialize DR6 by writing its architectural reset value to avoid
>>>> incorrectly zeroing DR6 to clear DR6=2EBLD at boot time, which leads
>>>> to a false bus lock detected warning=2E
>>>>=20
>>>> The Intel SDM says:
>>>>=20
>>>> =C2=A0=C2=A0 1) Certain debug exceptions may clear bits 0-3 of DR6=2E
>>>>=20
>>>> =C2=A0=C2=A0 2) BLD induced #DB clears DR6=2EBLD and any other debug =
exception
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 doesn't modify DR6=2EBLD=2E
>>>>=20
>>>> =C2=A0=C2=A0 3) RTM induced #DB clears DR6=2ERTM and any other debug =
exception
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sets DR6=2ERTM=2E
>>>>=20
>>>> =C2=A0=C2=A0 To avoid confusion in identifying debug exceptions, debu=
g handlers
>>>> =C2=A0=C2=A0 should set DR6=2EBLD and DR6=2ERTM, and clear other DR6 =
bits before
>>>> =C2=A0=C2=A0 returning=2E
>>>>=20
>>>> The DR6 architectural reset value 0xFFFF0FF0, already defined as
>>>> macro DR6_RESERVED, satisfies these requirements, so just use it to
>>>> reinitialize DR6 whenever needed=2E
>>>>=20
>>>> Since clear_all_debug_regs() no longer zeros all debug registers,
>>>> rename it to initialize_debug_regs() to better reflect its current
>>>> behavior=2E
>>>>=20
>>>> Since debug_read_clear_dr6() no longer clears DR6, rename it to
>>>> debug_read_reset_dr6() to better reflect its current behavior=2E
>>>>=20
>>>> Reported-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>>>> Link: https://lore=2Ekernel=2Eorg/lkml/06e68373-a92b-472e-8fd9- ba548=
119770c@intel=2Ecom/
>>>> Fixes: ebb1064e7c2e9 ("x86/traps: Handle #DB for bus lock")
>>>> Suggested-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>>>> Tested-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>>>> Reviewed-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>>>> Reviewed-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>>>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead=2Eorg>
>>>> Signed-off-by: Xin Li (Intel) <xin@zytor=2Ecom>
>>>> Cc: stable@vger=2Ekernel=2Eorg
>>>> ---
>>>>=20
>>>> Changes in v3:
>>>> *) Polish initialize_debug_regs() (PeterZ)=2E
>>>> *) Rewrite the comment for DR6_RESERVED definition (Sohil and Sean)=
=2E
>>>> *) Collect TB, RB, AB (PeterZ and Sohil)=2E
>>>>=20
>>>> Changes in v2:
>>>> *) Use debug register index 6 rather than DR_STATUS (PeterZ and Sean)=
=2E
>>>> *) Move this patch the first of the patch set to ease backporting=2E
>>>> ---
>>>> =C2=A0 arch/x86/include/uapi/asm/debugreg=2Eh | 21 ++++++++++++++++-
>>>> =C2=A0 arch/x86/kernel/cpu/common=2Ec=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 24 ++++++++------------
>>>> =C2=A0 arch/x86/kernel/traps=2Ec=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 34 +++++++++++++++++----------=
-
>>>> =C2=A0 3 files changed, 51 insertions(+), 28 deletions(-)
>>>>=20
>>>> diff --git a/arch/x86/include/uapi/asm/debugreg=2Eh b/arch/x86/includ=
e/ uapi/asm/debugreg=2Eh
>>>> index 0007ba077c0c=2E=2E41da492dfb01 100644
>>>> --- a/arch/x86/include/uapi/asm/debugreg=2Eh
>>>> +++ b/arch/x86/include/uapi/asm/debugreg=2Eh
>>>> @@ -15,7 +15,26 @@
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 which debugging register was responsible for=
 the trap=2E The other bits
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 are either reserved or not of interest to us=
=2E */
>>>> -/* Define reserved bits in DR6 which are always set to 1 */
>>>> +/*
>>>> + * Define bits in DR6 which are set to 1 by default=2E
>>>> + *
>>>> + * This is also the DR6 architectural value following Power-up, Rese=
t or INIT=2E
>>>> + *
>>>> + * Note, with the introduction of Bus Lock Detection (BLD) and Restr=
icted
>>>> + * Transactional Memory (RTM), the DR6 register has been modified:
>>>> + *
>>>> + * 1) BLD flag (bit 11) is no longer reserved to 1 if the CPU suppor=
ts
>>>> + *=C2=A0=C2=A0=C2=A0 Bus Lock Detection=2E=C2=A0 The assertion of a =
bus lock could clear it=2E
>>>> + *
>>>> + * 2) RTM flag (bit 16) is no longer reserved to 1 if the CPU suppor=
ts
>>>> + *=C2=A0=C2=A0=C2=A0 restricted transactional memory=2E=C2=A0 #DB oc=
curred inside an RTM region
>>>> + *=C2=A0=C2=A0=C2=A0 could clear it=2E
>>>> + *
>>>> + * Apparently, DR6=2EBLD and DR6=2ERTM are active low bits=2E
>>>> + *
>>>> + * As a result, DR6_RESERVED is an incorrect name now, but it is kep=
t for
>>>> + * compatibility=2E
>>>> + */
>>>> =C2=A0 #define DR6_RESERVED=C2=A0=C2=A0=C2=A0 (0xFFFF0FF0)
>>>> =C2=A0 #define DR_TRAP0=C2=A0=C2=A0=C2=A0 (0x1)=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 /* db0 */
>>>> diff --git a/arch/x86/kernel/cpu/common=2Ec b/arch/x86/kernel/cpu/com=
mon=2Ec
>>>> index 8feb8fd2957a=2E=2E0f6c280a94f0 100644
>>>> --- a/arch/x86/kernel/cpu/common=2Ec
>>>> +++ b/arch/x86/kernel/cpu/common=2Ec
>>>> @@ -2243,20 +2243,16 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>>>> =C2=A0 #endif
>>>> =C2=A0 #endif
>>>> -/*
>>>> - * Clear all 6 debug registers:
>>>> - */
>>>> -static void clear_all_debug_regs(void)
>>>> +static void initialize_debug_regs(void)
>>>> =C2=A0 {
>>>> -=C2=A0=C2=A0=C2=A0 int i;
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < 8; i++) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Ignore db4, db5 */
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((i =3D=3D 4) || (i =
=3D=3D 5))
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c=
ontinue;
>>>> -
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_debugreg(0, i);
>>>> -=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0 /* Control register first -- to make sure everyth=
ing is disabled=2E */
>>>=20
>>> In the Figure 19-1=2E Debug Registers of SDM section 19=2E2 DEBUG REGI=
STERS,
>>>=20
>>> bit 10, 12, 14, 15 of DR7 are marked as gray (Reversed) and their valu=
e are filled as
>>>=20
>>> 1, 0, 0,0 ; should we clear them all here ?=C2=A0 I didn't find any ot=
her description in the
>>>=20
>>> SDM about the result if they are cleaned=2E of course, this patch does=
n't change
>>>=20
>>> the behaviour of original DR7 initialization code, no justification ne=
eded,
>>>=20
>>> just out of curiosity=2E
>>=20
>> This patch is NOT intended to make any actual change to DR7
>> initialization=2E
>>=20
>So far it is okay,=C2=A0 I am just curious why these registers were clear=
ed to zero
>
>but the git log history and SDM doesn't give too much consistent clue=2E
>
>That is 16 years old code=2E
>
>> Please take a look at the second patch of this patch set=2E
>
>Looking=2E
>
>
>Thanks,
>
>Ethan
>
>>=20
>> Thanks!
>> =C2=A0=C2=A0=C2=A0 Xin
>>=20
>>>=20
>>>> +=C2=A0=C2=A0=C2=A0 set_debugreg(0, 7);
>>>> +=C2=A0=C2=A0=C2=A0 set_debugreg(DR6_RESERVED, 6);
>>>> +=C2=A0=C2=A0=C2=A0 /* dr5 and dr4 don't exist */
>>>> +=C2=A0=C2=A0=C2=A0 set_debugreg(0, 3);
>>>> +=C2=A0=C2=A0=C2=A0 set_debugreg(0, 2);
>>>> +=C2=A0=C2=A0=C2=A0 set_debugreg(0, 1);
>>>> +=C2=A0=C2=A0=C2=A0 set_debugreg(0, 0);
>

Older than that=2E

I believe it dates back from when Linux first got DRx support=2E


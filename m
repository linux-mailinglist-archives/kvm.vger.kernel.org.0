Return-Path: <kvm+bounces-50283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C1A2AE3824
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:16:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E5A27A1C17
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 08:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C8121CA02;
	Mon, 23 Jun 2025 08:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="SVKr2+ZJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6B721765E;
	Mon, 23 Jun 2025 08:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750666546; cv=none; b=SxJLtz+QMd5p2FYbeXWoq8gTJiuuMaXPkidwSlEHCEjxTcFaOnMnpBel3TtedMOXnX2oXIPwOejAKIaCe5K05/DrjFH6qDzUqyEmH9PL8JjN5qGE+J74UwqZd0Kqymita179yBgbhueEBa2yZ37yje95xefhR4AQz6VhoXnp08w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750666546; c=relaxed/simple;
	bh=oWaLno2jghHGxOOM1bpwiZyNygJib3Fz8auzEnje6PA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=aB8IioWxWID3nhLrLgOGpxYH3zkx71r/xlQJgZQvRuzExHDrk3ZPeStrCwly/FXVraUL9SVzAX0XqCT0GQKreQ9mixxih8KJPByL6sx/IDfNXjaQDC4jV/PJ4v2GijBJN7yL+V+fKzpLk+aWnPL4ysYI9bf4rksyFKuqcb5DHoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=SVKr2+ZJ; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55N8EZ2k849578
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 23 Jun 2025 01:14:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55N8EZ2k849578
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750666477;
	bh=AoKIdPnx8xVTIRqp1qpXyfALh7/bYlMAwvrF4K2eNhU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=SVKr2+ZJQMI9qgqsVaJ5r/kYrXDtr6uUTxeYHwZwRdfmPlF7BGXQWyO7Y5EY62FOh
	 IjZe3OI4dr4KpIPPK5AoSGh9MUqNxkWkHsT1qF8P7HsOfYpArv6ZbzEiJddJLSe7hI
	 crGeeQCz4kq/2ODxsEoP1TWN4tP+PJowi+oSnFozGybGhzJEROFRTppdCsc1lItJ3P
	 TAfQUK2Kznl8lUBglCwgkcQzzYEnxETkpX+Nv4HKkrhIZWNVLiQPB7NUO9xYMa98Ey
	 tflngl5O0zdpviLjb9oWi9UpGPXp7R8DcwxJzarLzvQBywmytdwf/uQjWGUsEqVZUr
	 xD4MybPFCkJBQ==
Date: Mon, 23 Jun 2025 01:14:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Ethan Zhao <haifeng.zhao@linux.intel.com>,
        "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, sohil.mehta@intel.com,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_1/2=5D_x86/traps=3A_Initialize_D?=
 =?US-ASCII?Q?R6_by_writing_its_architectural_reset_value?=
User-Agent: K-9 Mail for Android
In-Reply-To: <4018038c-8c96-49e0-b6b7-f54e0f52a65f@linux.intel.com>
References: <20250620231504.2676902-1-xin@zytor.com> <20250620231504.2676902-2-xin@zytor.com> <4018038c-8c96-49e0-b6b7-f54e0f52a65f@linux.intel.com>
Message-ID: <7C732492-F1F9-403B-A722-9EA563795B1B@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 22, 2025 11:49:11 PM PDT, Ethan Zhao <haifeng=2Ezhao@linux=2Eintel=
=2Ecom> wrote:
>
>=E5=9C=A8 2025/6/21 7:15, Xin Li (Intel) =E5=86=99=E9=81=93:
>> Initialize DR6 by writing its architectural reset value to avoid
>> incorrectly zeroing DR6 to clear DR6=2EBLD at boot time, which leads
>> to a false bus lock detected warning=2E
>>=20
>> The Intel SDM says:
>>=20
>>    1) Certain debug exceptions may clear bits 0-3 of DR6=2E
>>=20
>>    2) BLD induced #DB clears DR6=2EBLD and any other debug exception
>>       doesn't modify DR6=2EBLD=2E
>>=20
>>    3) RTM induced #DB clears DR6=2ERTM and any other debug exception
>>       sets DR6=2ERTM=2E
>>=20
>>    To avoid confusion in identifying debug exceptions, debug handlers
>>    should set DR6=2EBLD and DR6=2ERTM, and clear other DR6 bits before
>>    returning=2E
>>=20
>> The DR6 architectural reset value 0xFFFF0FF0, already defined as
>> macro DR6_RESERVED, satisfies these requirements, so just use it to
>> reinitialize DR6 whenever needed=2E
>>=20
>> Since clear_all_debug_regs() no longer zeros all debug registers,
>> rename it to initialize_debug_regs() to better reflect its current
>> behavior=2E
>>=20
>> Since debug_read_clear_dr6() no longer clears DR6, rename it to
>> debug_read_reset_dr6() to better reflect its current behavior=2E
>>=20
>> Reported-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>> Link: https://lore=2Ekernel=2Eorg/lkml/06e68373-a92b-472e-8fd9-ba548119=
770c@intel=2Ecom/
>> Fixes: ebb1064e7c2e9 ("x86/traps: Handle #DB for bus lock")
>> Suggested-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>> Tested-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>> Reviewed-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>> Reviewed-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead=2Eorg>
>> Signed-off-by: Xin Li (Intel) <xin@zytor=2Ecom>
>> Cc: stable@vger=2Ekernel=2Eorg
>> ---
>>=20
>> Changes in v3:
>> *) Polish initialize_debug_regs() (PeterZ)=2E
>> *) Rewrite the comment for DR6_RESERVED definition (Sohil and Sean)=2E
>> *) Collect TB, RB, AB (PeterZ and Sohil)=2E
>>=20
>> Changes in v2:
>> *) Use debug register index 6 rather than DR_STATUS (PeterZ and Sean)=
=2E
>> *) Move this patch the first of the patch set to ease backporting=2E
>> ---
>>   arch/x86/include/uapi/asm/debugreg=2Eh | 21 ++++++++++++++++-
>>   arch/x86/kernel/cpu/common=2Ec         | 24 ++++++++------------
>>   arch/x86/kernel/traps=2Ec              | 34 +++++++++++++++++--------=
---
>>   3 files changed, 51 insertions(+), 28 deletions(-)
>>=20
>> diff --git a/arch/x86/include/uapi/asm/debugreg=2Eh b/arch/x86/include/=
uapi/asm/debugreg=2Eh
>> index 0007ba077c0c=2E=2E41da492dfb01 100644
>> --- a/arch/x86/include/uapi/asm/debugreg=2Eh
>> +++ b/arch/x86/include/uapi/asm/debugreg=2Eh
>> @@ -15,7 +15,26 @@
>>      which debugging register was responsible for the trap=2E  The othe=
r bits
>>      are either reserved or not of interest to us=2E */
>>   -/* Define reserved bits in DR6 which are always set to 1 */
>> +/*
>> + * Define bits in DR6 which are set to 1 by default=2E
>> + *
>> + * This is also the DR6 architectural value following Power-up, Reset =
or INIT=2E
>> + *
>> + * Note, with the introduction of Bus Lock Detection (BLD) and Restric=
ted
>> + * Transactional Memory (RTM), the DR6 register has been modified:
>> + *
>> + * 1) BLD flag (bit 11) is no longer reserved to 1 if the CPU supports
>> + *    Bus Lock Detection=2E  The assertion of a bus lock could clear i=
t=2E
>> + *
>> + * 2) RTM flag (bit 16) is no longer reserved to 1 if the CPU supports
>> + *    restricted transactional memory=2E  #DB occurred inside an RTM r=
egion
>> + *    could clear it=2E
>> + *
>> + * Apparently, DR6=2EBLD and DR6=2ERTM are active low bits=2E
>> + *
>> + * As a result, DR6_RESERVED is an incorrect name now, but it is kept =
for
>> + * compatibility=2E
>> + */
>>   #define DR6_RESERVED	(0xFFFF0FF0)
>>     #define DR_TRAP0	(0x1)		/* db0 */
>> diff --git a/arch/x86/kernel/cpu/common=2Ec b/arch/x86/kernel/cpu/commo=
n=2Ec
>> index 8feb8fd2957a=2E=2E0f6c280a94f0 100644
>> --- a/arch/x86/kernel/cpu/common=2Ec
>> +++ b/arch/x86/kernel/cpu/common=2Ec
>> @@ -2243,20 +2243,16 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>>   #endif
>>   #endif
>>   -/*
>> - * Clear all 6 debug registers:
>> - */
>> -static void clear_all_debug_regs(void)
>> +static void initialize_debug_regs(void)
>>   {
>> -	int i;
>> -
>> -	for (i =3D 0; i < 8; i++) {
>> -		/* Ignore db4, db5 */
>> -		if ((i =3D=3D 4) || (i =3D=3D 5))
>> -			continue;
>> -
>> -		set_debugreg(0, i);
>> -	}
>> +	/* Control register first -- to make sure everything is disabled=2E *=
/
>
>In the Figure 19-1=2E Debug Registers of SDM section 19=2E2 DEBUG REGISTE=
RS,
>
>bit 10, 12, 14, 15 of DR7 are marked as gray (Reversed) and their value a=
re filled as
>
>1, 0, 0,0 ; should we clear them all here ?=C2=A0 I didn't find any other=
 description in the
>
>SDM about the result if they are cleaned=2E of course, this patch doesn't=
 change
>
>the behaviour of original DR7 initialization code, no justification neede=
d,
>
>just out of curiosity=2E
>
>
>Thanks,
>
>Ethan
>
>> +	set_debugreg(0, 7);
>> +	set_debugreg(DR6_RESERVED, 6);
>> +	/* dr5 and dr4 don't exist */
>> +	set_debugreg(0, 3);
>> +	set_debugreg(0, 2);
>> +	set_debugreg(0, 1);
>> +	set_debugreg(0, 0);
>>   }
>>     #ifdef CONFIG_KGDB
>> @@ -2417,7 +2413,7 @@ void cpu_init(void)
>>     	load_mm_ldt(&init_mm);
>>   -	clear_all_debug_regs();
>> +	initialize_debug_regs();
>>   	dbg_restore_debug_regs();
>>     	doublefault_init_cpu_tss();
>> diff --git a/arch/x86/kernel/traps=2Ec b/arch/x86/kernel/traps=2Ec
>> index c5c897a86418=2E=2E36354b470590 100644
>> --- a/arch/x86/kernel/traps=2Ec
>> +++ b/arch/x86/kernel/traps=2Ec
>> @@ -1022,24 +1022,32 @@ static bool is_sysenter_singlestep(struct pt_re=
gs *regs)
>>   #endif
>>   }
>>   -static __always_inline unsigned long debug_read_clear_dr6(void)
>> +static __always_inline unsigned long debug_read_reset_dr6(void)
>>   {
>>   	unsigned long dr6;
>>   +	get_debugreg(dr6, 6);
>> +	dr6 ^=3D DR6_RESERVED; /* Flip to positive polarity */
>> +
>>   	/*
>>   	 * The Intel SDM says:
>>   	 *
>> -	 *   Certain debug exceptions may clear bits 0-3=2E The remaining
>> -	 *   contents of the DR6 register are never cleared by the
>> -	 *   processor=2E To avoid confusion in identifying debug
>> -	 *   exceptions, debug handlers should clear the register before
>> -	 *   returning to the interrupted task=2E
>> +	 *   Certain debug exceptions may clear bits 0-3 of DR6=2E
>> +	 *
>> +	 *   BLD induced #DB clears DR6=2EBLD and any other debug
>> +	 *   exception doesn't modify DR6=2EBLD=2E
>>   	 *
>> -	 * Keep it simple: clear DR6 immediately=2E
>> +	 *   RTM induced #DB clears DR6=2ERTM and any other debug
>> +	 *   exception sets DR6=2ERTM=2E
>> +	 *
>> +	 *   To avoid confusion in identifying debug exceptions,
>> +	 *   debug handlers should set DR6=2EBLD and DR6=2ERTM, and
>> +	 *   clear other DR6 bits before returning=2E
>> +	 *
>> +	 * Keep it simple: write DR6 with its architectural reset
>> +	 * value 0xFFFF0FF0, defined as DR6_RESERVED, immediately=2E
>>   	 */
>> -	get_debugreg(dr6, 6);
>>   	set_debugreg(DR6_RESERVED, 6);
>> -	dr6 ^=3D DR6_RESERVED; /* Flip to positive polarity */
>>     	return dr6;
>>   }
>> @@ -1239,13 +1247,13 @@ static noinstr void exc_debug_user(struct pt_re=
gs *regs, unsigned long dr6)
>>   /* IST stack entry */
>>   DEFINE_IDTENTRY_DEBUG(exc_debug)
>>   {
>> -	exc_debug_kernel(regs, debug_read_clear_dr6());
>> +	exc_debug_kernel(regs, debug_read_reset_dr6());
>>   }
>>     /* User entry, runs on regular task stack */
>>   DEFINE_IDTENTRY_DEBUG_USER(exc_debug)
>>   {
>> -	exc_debug_user(regs, debug_read_clear_dr6());
>> +	exc_debug_user(regs, debug_read_reset_dr6());
>>   }
>>     #ifdef CONFIG_X86_FRED
>> @@ -1264,7 +1272,7 @@ DEFINE_FREDENTRY_DEBUG(exc_debug)
>>   {
>>   	/*
>>   	 * FRED #DB stores DR6 on the stack in the format which
>> -	 * debug_read_clear_dr6() returns for the IDT entry points=2E
>> +	 * debug_read_reset_dr6() returns for the IDT entry points=2E
>>   	 */
>>   	unsigned long dr6 =3D fred_event_data(regs);
>>   @@ -1279,7 +1287,7 @@ DEFINE_FREDENTRY_DEBUG(exc_debug)
>>   /* 32 bit does not have separate entry points=2E */
>>   DEFINE_IDTENTRY_RAW(exc_debug)
>>   {
>> -	unsigned long dr6 =3D debug_read_clear_dr6();
>> +	unsigned long dr6 =3D debug_read_reset_dr6();
>>     	if (user_mode(regs))
>>   		exc_debug_user(regs, dr6);
>

We should, but it isn't a manifest bug so is slightly less urgent=2E


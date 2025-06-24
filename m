Return-Path: <kvm+bounces-50443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 127F4AE596C
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 03:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5F071B659F9
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 01:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9471E104E;
	Tue, 24 Jun 2025 01:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WWsbrK1X"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DA223741;
	Tue, 24 Jun 2025 01:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750730021; cv=none; b=l2YbN7qW6vXmCVH5soP5LLOaohqXL9wXSWVYVsabmP5oveZ7+HQgBNM7q2NL3ePCE0UP/heOy9AEQFmA/DglJa/Lh1y9g/2Vz7M8KTmAdCa0CFpyWTixZcKPtE2/77JvTGs4jPQt0MwqQKaejfsTIxhg9KyPVY33qkf2tVBzDS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750730021; c=relaxed/simple;
	bh=ZYzUNYhT+z6vZ7EpghmitrGp4C07p1vjYdTYuHyQeiA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=kq9QBk6L/XnJTPtv87wVma/xnuhjzoo0iiKNrVlYb8CXNc0pen7Td4o+HYSXAOcrA71dsOYMAR3btc6orOotqUzV4moChAap1pNBKZLC38kCzekhH0gmkFrXk66Zay60jdtFVeIuYufVDMgWNZEHfVQnTG98JmWKSBQ483kWSk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WWsbrK1X; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55O1r3oM1161540
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 23 Jun 2025 18:53:03 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55O1r3oM1161540
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025062101; t=1750729984;
	bh=SX1J5EuoPjXO4Ns+7NqkhVEoJrwoYRwoW4MM6oVfDJY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=WWsbrK1Xfy7uXKu8XCnJsCHjpkxeI5yG+//BOMOYrYq2j80luE4nk9e2i45ltlXfX
	 rKodMNKjkepPYxR5pnCSAAGxEpUn3hSzGopjNVnnLwxotqhXjxlN6L13OBcpBkHUKn
	 UWRQzsIn2Xws8cFWWRKbzO22BYM/vkhK1TR1b4dXSiQ2lAvtCf963o/76+MpoP/hS3
	 PMSeK0IFsqUo5sLzoSX12Q9ZihOqo+KeONitNhp78m3Q6AZWpUDrtEEenJAVzJVw7h
	 fUowb65numOmRFFylaHEAY9gtzMK4b4q8zehjDnlZYN87gldG4Y5Zj+HU4ZUJEfJAi
	 /C/3LigXrndzw==
Date: Mon, 23 Jun 2025 18:53:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Ethan Zhao <haifeng.zhao@linux.intel.com>,
        "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, sohil.mehta@intel.com,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_2/2=5D_x86/traps=3A_Initialize_D?=
 =?US-ASCII?Q?R7_by_writing_its_architectural_reset_value?=
User-Agent: K-9 Mail for Android
In-Reply-To: <c526eb25-571e-427a-93e9-3afdaa6ca413@linux.intel.com>
References: <20250620231504.2676902-1-xin@zytor.com> <20250620231504.2676902-3-xin@zytor.com> <c526eb25-571e-427a-93e9-3afdaa6ca413@linux.intel.com>
Message-ID: <EBD6D476-3014-475A-9467-77CA51755D41@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 23, 2025 6:41:07 PM PDT, Ethan Zhao <haifeng=2Ezhao@linux=2Eintel=
=2Ecom> wrote:
>
>=E5=9C=A8 2025/6/21 7:15, Xin Li (Intel) =E5=86=99=E9=81=93:
>> Initialize DR7 by writing its architectural reset value to always set
>> bit 10, which is reserved to '1', when "clearing" DR7 so as not to
>> trigger unanticipated behavior if said bit is ever unreserved, e=2Eg=2E=
 as
>> a feature enabling flag with inverted polarity=2E
>>=20
>> Tested-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>> Reviewed-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>> Reviewed-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead=2Eorg>
>> Acked-by: Sean Christopherson <seanjc@google=2Ecom>
>> Signed-off-by: Xin Li (Intel) <xin@zytor=2Ecom>
>> Cc: stable@vger=2Ekernel=2Eorg
>> ---
>>=20
>> Change in v4:
>> *) Cc stable for backporting, just in case bit 10 of DR7 has become
>>     unreserved on new hardware, even though clearing it doesn't
>>     currently cause any real issues (Dave Hansen)=2E
>>=20
>> Changes in v3:
>> *) Reword the changelog using Sean's description=2E
>> *) Explain the definition of DR7_FIXED_1 (Sohil)=2E
>> *) Collect TB, RB, AB (PeterZ, Sohil and Sean)=2E
>>=20
>> Changes in v2:
>> *) Use debug register index 7 rather than DR_CONTROL (PeterZ and Sean)=
=2E
>> *) Use DR7_FIXED_1 as the architectural reset value of DR7 (Sean)=2E
>> ---
>>   arch/x86/include/asm/debugreg=2Eh | 19 +++++++++++++++----
>>   arch/x86/include/asm/kvm_host=2Eh |  2 +-
>>   arch/x86/kernel/cpu/common=2Ec    |  2 +-
>>   arch/x86/kernel/kgdb=2Ec          |  2 +-
>>   arch/x86/kernel/process_32=2Ec    |  2 +-
>>   arch/x86/kernel/process_64=2Ec    |  2 +-
>>   arch/x86/kvm/x86=2Ec              |  4 ++--
>>   7 files changed, 22 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/debugreg=2Eh b/arch/x86/include/asm/d=
ebugreg=2Eh
>> index 363110e6b2e3=2E=2Ea2c1f2d24b64 100644
>> --- a/arch/x86/include/asm/debugreg=2Eh
>> +++ b/arch/x86/include/asm/debugreg=2Eh
>> @@ -9,6 +9,14 @@
>>   #include <asm/cpufeature=2Eh>
>>   #include <asm/msr=2Eh>
>>   +/*
>> + * Define bits that are always set to 1 in DR7, only bit 10 is
>> + * architecturally reserved to '1'=2E
>> + *
>> + * This is also the init/reset value for DR7=2E
>> + */
>> +#define DR7_FIXED_1	0x00000400
>> +
>>   DECLARE_PER_CPU(unsigned long, cpu_dr7);
>>     #ifndef CONFIG_PARAVIRT_XXL
>> @@ -100,8 +108,8 @@ static __always_inline void native_set_debugreg(int=
 regno, unsigned long value)
>>     static inline void hw_breakpoint_disable(void)
>>   {
>> -	/* Zero the control register for HW Breakpoint */
>> -	set_debugreg(0UL, 7);
>> +	/* Reset the control register for HW Breakpoint */
>> +	set_debugreg(DR7_FIXED_1, 7);
>
>Given you have it be adhere to SDM about the DR7 reversed bits setting,
>
>then no reason to leave patch[1/2] to=C2=A0set_debugreg(0, 7) alone=2E
>
>did I miss something here ?
>
>
>Thanks,
>
>Ethan
>
>
>>     	/* Zero-out the individual HW breakpoint address registers */
>>   	set_debugreg(0UL, 0);
>> @@ -125,9 +133,12 @@ static __always_inline unsigned long local_db_save=
(void)
>>   		return 0;
>>     	get_debugreg(dr7, 7);
>> -	dr7 &=3D ~0x400; /* architecturally set bit */
>> +
>> +	/* Architecturally set bit */
>> +	dr7 &=3D ~DR7_FIXED_1;
>>   	if (dr7)
>> -		set_debugreg(0, 7);
>> +		set_debugreg(DR7_FIXED_1, 7);
>> +
>>   	/*
>>   	 * Ensure the compiler doesn't lower the above statements into
>>   	 * the critical section; disabling breakpoints late would not
>> diff --git a/arch/x86/include/asm/kvm_host=2Eh b/arch/x86/include/asm/k=
vm_host=2Eh
>> index b4a391929cdb=2E=2E639d9bcee842 100644
>> --- a/arch/x86/include/asm/kvm_host=2Eh
>> +++ b/arch/x86/include/asm/kvm_host=2Eh
>> @@ -31,6 +31,7 @@
>>     #include <asm/apic=2Eh>
>>   #include <asm/pvclock-abi=2Eh>
>> +#include <asm/debugreg=2Eh>
>>   #include <asm/desc=2Eh>
>>   #include <asm/mtrr=2Eh>
>>   #include <asm/msr-index=2Eh>
>> @@ -249,7 +250,6 @@ enum x86_intercept_stage;
>>   #define DR7_BP_EN_MASK	0x000000ff
>>   #define DR7_GE		(1 << 9)
>>   #define DR7_GD		(1 << 13)
>> -#define DR7_FIXED_1	0x00000400
>>   #define DR7_VOLATILE	0xffff2bff
>>     #define KVM_GUESTDBG_VALID_MASK \
>> diff --git a/arch/x86/kernel/cpu/common=2Ec b/arch/x86/kernel/cpu/commo=
n=2Ec
>> index 0f6c280a94f0=2E=2E27125e009847 100644
>> --- a/arch/x86/kernel/cpu/common=2Ec
>> +++ b/arch/x86/kernel/cpu/common=2Ec
>> @@ -2246,7 +2246,7 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>>   static void initialize_debug_regs(void)
>>   {
>>   	/* Control register first -- to make sure everything is disabled=2E =
*/
>> -	set_debugreg(0, 7);
>> +	set_debugreg(DR7_FIXED_1, 7);
>>   	set_debugreg(DR6_RESERVED, 6);
>>   	/* dr5 and dr4 don't exist */
>>   	set_debugreg(0, 3);
>> diff --git a/arch/x86/kernel/kgdb=2Ec b/arch/x86/kernel/kgdb=2Ec
>> index 102641fd2172=2E=2E8b1a9733d13e 100644
>> --- a/arch/x86/kernel/kgdb=2Ec
>> +++ b/arch/x86/kernel/kgdb=2Ec
>> @@ -385,7 +385,7 @@ static void kgdb_disable_hw_debug(struct pt_regs *r=
egs)
>>   	struct perf_event *bp;
>>     	/* Disable hardware debugging while we are in kgdb: */
>> -	set_debugreg(0UL, 7);
>> +	set_debugreg(DR7_FIXED_1, 7);
>>   	for (i =3D 0; i < HBP_NUM; i++) {
>>   		if (!breakinfo[i]=2Eenabled)
>>   			continue;
>> diff --git a/arch/x86/kernel/process_32=2Ec b/arch/x86/kernel/process_3=
2=2Ec
>> index a10e180cbf23=2E=2E3ef15c2f152f 100644
>> --- a/arch/x86/kernel/process_32=2Ec
>> +++ b/arch/x86/kernel/process_32=2Ec
>> @@ -93,7 +93,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs=
_mode mode,
>>     	/* Only print out debug registers if they are in their non-default=
 state=2E */
>>   	if ((d0 =3D=3D 0) && (d1 =3D=3D 0) && (d2 =3D=3D 0) && (d3 =3D=3D 0)=
 &&
>> -	    (d6 =3D=3D DR6_RESERVED) && (d7 =3D=3D 0x400))
>> +	    (d6 =3D=3D DR6_RESERVED) && (d7 =3D=3D DR7_FIXED_1))
>>   		return;
>>     	printk("%sDR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
>> diff --git a/arch/x86/kernel/process_64=2Ec b/arch/x86/kernel/process_6=
4=2Ec
>> index 8d6cf25127aa=2E=2Eb972bf72fb8b 100644
>> --- a/arch/x86/kernel/process_64=2Ec
>> +++ b/arch/x86/kernel/process_64=2Ec
>> @@ -133,7 +133,7 @@ void __show_regs(struct pt_regs *regs, enum show_re=
gs_mode mode,
>>     	/* Only print out debug registers if they are in their non-default=
 state=2E */
>>   	if (!((d0 =3D=3D 0) && (d1 =3D=3D 0) && (d2 =3D=3D 0) && (d3 =3D=3D =
0) &&
>> -	    (d6 =3D=3D DR6_RESERVED) && (d7 =3D=3D 0x400))) {
>> +	    (d6 =3D=3D DR6_RESERVED) && (d7 =3D=3D DR7_FIXED_1))) {
>>   		printk("%sDR0: %016lx DR1: %016lx DR2: %016lx\n",
>>   		       log_lvl, d0, d1, d2);
>>   		printk("%sDR3: %016lx DR6: %016lx DR7: %016lx\n",
>> diff --git a/arch/x86/kvm/x86=2Ec b/arch/x86/kvm/x86=2Ec
>> index b58a74c1722d=2E=2Ea9d992d5652f 100644
>> --- a/arch/x86/kvm/x86=2Ec
>> +++ b/arch/x86/kvm/x86=2Ec
>> @@ -11035,7 +11035,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu)
>>     	if (unlikely(vcpu->arch=2Eswitch_db_regs &&
>>   		     !(vcpu->arch=2Eswitch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))) {
>> -		set_debugreg(0, 7);
>> +		set_debugreg(DR7_FIXED_1, 7);
>>   		set_debugreg(vcpu->arch=2Eeff_db[0], 0);
>>   		set_debugreg(vcpu->arch=2Eeff_db[1], 1);
>>   		set_debugreg(vcpu->arch=2Eeff_db[2], 2);
>> @@ -11044,7 +11044,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu)
>>   		if (unlikely(vcpu->arch=2Eswitch_db_regs & KVM_DEBUGREG_WONT_EXIT))
>>   			kvm_x86_call(set_dr6)(vcpu, vcpu->arch=2Edr6);
>>   	} else if (unlikely(hw_breakpoint_active())) {
>> -		set_debugreg(0, 7);
>> +		set_debugreg(DR7_FIXED_1, 7);
>>   	}
>>     	vcpu->arch=2Ehost_debugctl =3D get_debugctlmsr();
>

It's split up for the benefit of the stable maintainers=2E


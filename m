Return-Path: <kvm+bounces-47120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A5FABD882
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:51:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C65887A4038
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349071C07D9;
	Tue, 20 May 2025 12:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hd1zctH6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8C022094;
	Tue, 20 May 2025 12:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747745405; cv=none; b=VEROtrGg0YSTCj3wgClvc9Lf+/hct/dDAUe6cY5T6WWozErRE7fjj0CjVwVh8VA0r8wiI+prkqu/2nKvd7TEQ+SgXelKezQPwjD+WWyEF9S6JYgRNA3dEdzwv0lpDhzUixlp5ROSdjAbiiLTXiOOl0DOj6OOuOnjrysxu02vGCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747745405; c=relaxed/simple;
	bh=tx5Fhlyi0WT43GMsBYiY6GKYtSism583/NOqcXx/bTk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HAzezphnW/RXlk/5Rei3EZpiC5xDoUbh16ukKbux7IFCN68FHL8g2rai2UDQKgMuDpThgGPvdDuaKomFclVBlk/M9C3mFlZXWEqER0KOsPcOP7pDcU5/UzTROTLI/j1ADHzjyeDD3x5dTp1HN9JFWpJFJ7GCtBViNtmHQ2T9FLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hd1zctH6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K7DxFd012193;
	Tue, 20 May 2025 12:50:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Y5hAs2
	Vu2uJiHwYvCJKlCJ1rlCh3gofMaf9x7KOpJH4=; b=Hd1zctH69zNAq9wTIisW40
	Qc6KFNBpn9wbU8uCNjhNJAAHCbIMAcxel2TkfkU+G6kP19i6hl4LLCulzPWnouJ6
	MQ4QPtGvD+W+c6C+CeBYrWmSg7zSU8Zrt19k/l0aCtKJkIJSgHngG2voU2uHyL6K
	HYksWAchF5+BD/cmIHAnVkgI8GzRhSZtUAScIkhgQ5YccYTMXtDNsy5pGCSFKaVK
	GrgzVo0CpP8w9pZFDEa1nbMWVZ4+L96nvfWINm/ewjn7iap+1mG4x6klbFidhn++
	pxG5R72+o0FsXrZELRvM+hwpykAoouX4tP0RScXpMp68lPaB+pD2vXIcrPV13iYg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rab744ms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 12:50:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KBf2Ux015851;
	Tue, 20 May 2025 12:49:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q7g2bm7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 12:49:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KCnurB53150000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 12:49:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2373020040;
	Tue, 20 May 2025 12:49:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6EB612004D;
	Tue, 20 May 2025 12:49:55 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.111.32.248])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 12:49:55 +0000 (GMT)
Message-ID: <9fdc24a2288201b966864e11dd39fc3b009a1b93.camel@linux.ibm.com>
Subject: Re: [PATCH v1 3/5] KVM: s390: refactor some functions in priv.c
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Date: Tue, 20 May 2025 14:49:55 +0200
In-Reply-To: <20250514163855.124471-4-imbrenda@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
		 <20250514163855.124471-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 (3.56.1-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ELgG00ZC c=1 sm=1 tr=0 ts=682c7a78 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=ABTJbWSwloqCcYxGV6IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Ej0ovqtqoIRJnftlClfT5bA9rxNF7tkd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEwMSBTYWx0ZWRfX9c7bYuU2PaH0 HTg1lYJ2BdLcOASdFrDtdHjgPuSxoER9xJ7qF0n4SALEUPf8n7+7dRtOHt7OizeJjrpepgVJeYS 3YjB4QI4HCnPoEIfBL/LY/tV6aJFm4U6zIWfkmSJxbKH2UWMjARAun7QN/9JAQxop+kLV92UUwm
 GuNql5urZB4f2nJSjy3dIRBaoXGz1atcj1A0LVUZYC4ZsgrLbSVApv0zGphJzWWcaHzc7QP1KX1 BUVxAiadnsXTWG3EbJ5uYtavxPlZ+WTUYt78zSbKWcEom8EcZN5l5k1SBxncjsoGRlAB0+gWXR5 DHlXlo5ya52Kt3Ev2JkPQWXyDE/2sr0Q3bDI+6FpUpPpb5cJ5fQN3a/+UF6sG0WGSyM0S88mucV
 HCIHsx/5fGUzRcpE58ecFNz7PSjdo00zR+Xf6tBYCcYbvzqAsd38ifUrQdQU5ceiAqlijdbe
X-Proofpoint-GUID: Ej0ovqtqoIRJnftlClfT5bA9rxNF7tkd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 malwarescore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505200101

On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:
> Refactor some functions in priv.c to make them more readable.
>=20
> handle_{iske,rrbe,sske}: move duplicated checks into a single function.
> handle{pfmf,epsw}: improve readability.
> handle_lpswe{,y}: merge implementations since they are almost the same.
>=20
> Use u64_replace_bits() where it makes sense.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.h |  15 ++
>  arch/s390/kvm/priv.c     | 288 ++++++++++++++++++---------------------
>  2 files changed, 148 insertions(+), 155 deletions(-)
>=20
[...]

> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 758cefb5bac7..1a26aa591c2e 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -14,6 +14,7 @@
>  #include <linux/mm_types.h>
>  #include <linux/pgtable.h>
>  #include <linux/io.h>
> +#include <linux/bitfield.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/facility.h>
>  #include <asm/current.h>
> @@ -253,29 +254,50 @@ static int try_handle_skey(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
> =20
> +struct skeys_ops_state {
> +	int reg1;
> +	int reg2;
> +	int rc;
> +	unsigned long gaddr;
> +};
> +
> +static bool skeys_common_checks(struct kvm_vcpu *vcpu, struct skeys_ops_=
state *state, bool abs)
> +{
> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE) {
> +		state->rc =3D kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> +		return true;
> +	}
> +
> +	state->rc =3D try_handle_skey(vcpu);
> +	if (state->rc)
> +		return true;
> +
> +	kvm_s390_get_regs_rre(vcpu, &state->reg1, &state->reg2);
> +
> +	state->gaddr =3D vcpu->run->s.regs.gprs[state->reg2] & PAGE_MASK;
> +	state->gaddr =3D kvm_s390_logical_to_effective(vcpu, state->gaddr);
> +	if (!abs)
> +		state->gaddr =3D kvm_s390_real_to_abs(vcpu, state->gaddr);
> +
> +	return false;
> +}

I don't really like this function, IMO it makes the calling functions harde=
r to read.
If it was just a chain of checks it be fine, but with the differing control=
 flow
base on the abs parameter and the complex return value it becomes too compl=
icated.

> +
>  static int handle_iske(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long gaddr, vmaddr;
> +	struct skeys_ops_state state;
> +	unsigned long vmaddr;
>  	unsigned char key;
> -	int reg1, reg2;
>  	bool unlocked;
> +	u64 *r1;
>  	int rc;
> =20
>  	vcpu->stat.instruction_iske++;
> =20
> -	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> -		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);

How about a macro INJECT_PGM_ON: INJECT_PGM_ON(kvm_s390_problem_state(vcpu)=
, PGM_PRIVILEGED_OP)


> -
> -	rc =3D try_handle_skey(vcpu);
> -	if (rc)
> -		return rc !=3D -EAGAIN ? rc : 0;

You are not replicating this behavior, are you?
> -
> -	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);

You could introduce a helper

void _kvm_s390_get_gpr_ptrs_rre(vcpu, u64 **reg1, u64 **reg2)
{
	int r1, r2;

	kvm_s390_get_regs_rre(vcpu, &r1, &r2);
	*reg1 =3D &vcpu->run->s.regs.gprs[r1];
	*reg2 =3D &vcpu->run->s.regs.gprs[r2];
}

which would remove some clutter from the original function implementations.

> +	if (skeys_common_checks(vcpu, &state, false))
> +		return state.rc;
> +	r1 =3D vcpu->run->s.regs.gprs + state.reg1;
> =20
> -	gaddr =3D vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
> -	gaddr =3D kvm_s390_logical_to_effective(vcpu, gaddr);
> -	gaddr =3D kvm_s390_real_to_abs(vcpu, gaddr);
> -	vmaddr =3D gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
> +	vmaddr =3D gfn_to_hva(vcpu->kvm, gpa_to_gfn(state.gaddr));
>  	if (kvm_is_error_hva(vmaddr))
>  		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
>  retry:
> @@ -296,33 +318,23 @@ static int handle_iske(struct kvm_vcpu *vcpu)
>  		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
>  	if (rc < 0)
>  		return rc;
> -	vcpu->run->s.regs.gprs[reg1] &=3D ~0xff;
> -	vcpu->run->s.regs.gprs[reg1] |=3D key;
> +	*r1 =3D u64_replace_bits(*r1, key, 0xff);
>  	return 0;
>  }
> =C2=A0
>=20
[...]

>  retry:
> @@ -353,40 +365,30 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
>  static int handle_sske(struct kvm_vcpu *vcpu)
>  {
>  	unsigned char m3 =3D vcpu->arch.sie_block->ipb >> 28;
> +	struct skeys_ops_state state;
>  	unsigned long start, end;
>  	unsigned char key, oldkey;
> -	int reg1, reg2;
> +	bool nq, mr, mc, mb;
>  	bool unlocked;
> +	u64 *r1, *r2;
>  	int rc;
> =20
>  	vcpu->stat.instruction_sske++;
> =20
> -	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> -		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> -
> -	rc =3D try_handle_skey(vcpu);
> -	if (rc)
> -		return rc !=3D -EAGAIN ? rc : 0;
> -
> -	if (!test_kvm_facility(vcpu->kvm, 8))
> -		m3 &=3D ~SSKE_MB;
> -	if (!test_kvm_facility(vcpu->kvm, 10))
> -		m3 &=3D ~(SSKE_MC | SSKE_MR);
> -	if (!test_kvm_facility(vcpu->kvm, 14))
> -		m3 &=3D ~SSKE_NQ;
> +	mb =3D test_kvm_facility(vcpu->kvm, 8) && (m3 & SSKE_MB);
> +	mr =3D test_kvm_facility(vcpu->kvm, 10) && (m3 & SSKE_MR);
> +	mc =3D test_kvm_facility(vcpu->kvm, 10) && (m3 & SSKE_MC);
> +	nq =3D test_kvm_facility(vcpu->kvm, 14) && (m3 & SSKE_NQ);

That is indeed much nicer.

> =20
> -	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
> +	/* start already designates an absolute address if MB is set */
> +	if (skeys_common_checks(vcpu, &state, mb))
> +		return state.rc;
> =20
> -	key =3D vcpu->run->s.regs.gprs[reg1] & 0xfe;
> -	start =3D vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
> -	start =3D kvm_s390_logical_to_effective(vcpu, start);
> -	if (m3 & SSKE_MB) {
> -		/* start already designates an absolute address */
> -		end =3D (start + _SEGMENT_SIZE) & ~(_SEGMENT_SIZE - 1);
> -	} else {
> -		start =3D kvm_s390_real_to_abs(vcpu, start);
> -		end =3D start + PAGE_SIZE;
> -	}
> +	start =3D state.gaddr;
> +	end =3D mb ? ALIGN(start + 1, _SEGMENT_SIZE) : start + PAGE_SIZE;

Alternatively you could do ALIGN_DOWN(start, _SEGMENT_SIZE) + _SEGMENT_SIZE=
,
which seems a bit easier to read, but it's really minor.

> +	r1 =3D vcpu->run->s.regs.gprs + state.reg1;
> +	r2 =3D vcpu->run->s.regs.gprs + state.reg2;
> +	key =3D *r1 & 0xfe;
> =20
>  	while (start !=3D end) {
>  		unsigned long vmaddr =3D gfn_to_hva(vcpu->kvm, gpa_to_gfn(start));
> @@ -396,9 +398,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
>  			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
> =20
>  		mmap_read_lock(current->mm);
> -		rc =3D cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey,
> -						m3 & SSKE_NQ, m3 & SSKE_MR,
> -						m3 & SSKE_MC);
> +		rc =3D cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey, n=
q, mr, mc);
> =20
>  		if (rc < 0) {
>  			rc =3D fixup_user_fault(current->mm, vmaddr,
> @@ -415,23 +415,21 @@ static int handle_sske(struct kvm_vcpu *vcpu)
>  		start +=3D PAGE_SIZE;
>  	}
> =20
> -	if (m3 & (SSKE_MC | SSKE_MR)) {
> -		if (m3 & SSKE_MB) {
> +	if (mc || mr) {
> +		if (mb) {
>  			/* skey in reg1 is unpredictable */
>  			kvm_s390_set_psw_cc(vcpu, 3);
>  		} else {
>  			kvm_s390_set_psw_cc(vcpu, rc);
> -			vcpu->run->s.regs.gprs[reg1] &=3D ~0xff00UL;
> -			vcpu->run->s.regs.gprs[reg1] |=3D (u64) oldkey << 8;
> +			*r1 =3D u64_replace_bits(*r1, oldkey << 8, 0xff00);

Uh, u64_replace_bits does the shift for you, no?
So it should be u64_replace_bits(*r1, oldkey, 0xff00)

You could also do u64p_replace_bits(r1, oldkey, 0xff00) but I'd actually pr=
efer the assignment
as you do it.

>  		}
>  	}
> -	if (m3 & SSKE_MB) {
> -		if (psw_bits(vcpu->arch.sie_block->gpsw).eaba =3D=3D PSW_BITS_AMODE_64=
BIT)
> -			vcpu->run->s.regs.gprs[reg2] &=3D ~PAGE_MASK;
> -		else
> -			vcpu->run->s.regs.gprs[reg2] &=3D ~0xfffff000UL;
> +	if (mb) {
>  		end =3D kvm_s390_logical_to_effective(vcpu, end);
> -		vcpu->run->s.regs.gprs[reg2] |=3D end;
> +		if (kvm_s390_is_amode_64(vcpu))
> +			*r2 =3D u64_replace_bits(*r2, end, PAGE_MASK);
> +		else
> +			*r2 =3D u64_replace_bits(*r2, end, 0xfffff000);

This does not work because of the implicit shift.
So you need to use gpa_to_gfn(end) instead.
(I think I would prefer using start instead of end, since it better shows
the interruptible nature of the instruction, but start =3D=3D end if
we get here so ...)

>  	}
>  	return 0;
>  }
> @@ -773,46 +771,28 @@ int kvm_s390_handle_lpsw(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
> =20
> -static int handle_lpswe(struct kvm_vcpu *vcpu)
> +static int handle_lpswe_y(struct kvm_vcpu *vcpu, bool lpswey)
>  {
>  	psw_t new_psw;
>  	u64 addr;
>  	int rc;
>  	u8 ar;
> =20
> -	vcpu->stat.instruction_lpswe++;
> -
> -	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> -		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> -
> -	addr =3D kvm_s390_get_base_disp_s(vcpu, &ar);
> -	if (addr & 7)
> -		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> -	rc =3D read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
> -	if (rc)
> -		return kvm_s390_inject_prog_cond(vcpu, rc);
> -	vcpu->arch.sie_block->gpsw =3D new_psw;
> -	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
> -		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> -	return 0;
> -}
> -
> -static int handle_lpswey(struct kvm_vcpu *vcpu)
> -{
> -	psw_t new_psw;
> -	u64 addr;
> -	int rc;
> -	u8 ar;
> -
> -	vcpu->stat.instruction_lpswey++;
> +	if (lpswey)
> +		vcpu->stat.instruction_lpswey++;
> +	else
> +		vcpu->stat.instruction_lpswe++;
> =20
> -	if (!test_kvm_facility(vcpu->kvm, 193))
> +	if (lpswey && !test_kvm_facility(vcpu->kvm, 193))
>  		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
> =20
>  	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> =20
> -	addr =3D kvm_s390_get_base_disp_siy(vcpu, &ar);
> +	if (!lpswey)
> +		addr =3D kvm_s390_get_base_disp_s(vcpu, &ar);
> +	else
> +		addr =3D kvm_s390_get_base_disp_siy(vcpu, &ar);
>  	if (addr & 7)
>  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);

I'd prefer a helper function _do_lpswe_y_swap(struct kvm_vcpu *vcpu, gpa_t =
addr)

and then just

static int handle_lpswey(struct kvm_vcpu *vcpu)
{
        u64 addr;
        u8 ar;

        vcpu->stat.instruction_lpswey++;

        if (!test_kvm_facility(vcpu->kvm, 193))
                return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);

        addr =3D kvm_s390_get_base_disp_siy(vcpu, &ar);
	return _do_lpswe_y_swap(vcpu, addr);
}

Makes it easier to read IMO because of the simpler control flow.
> =20
> @@ -1034,7 +1014,7 @@ int kvm_s390_handle_b2(struct kvm_vcpu *vcpu)
>  	case 0xb1:
>  		return handle_stfl(vcpu);
>  	case 0xb2:
> -		return handle_lpswe(vcpu);
> +		return handle_lpswe_y(vcpu, false);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> @@ -1043,42 +1023,50 @@ int kvm_s390_handle_b2(struct kvm_vcpu *vcpu)
>  static int handle_epsw(struct kvm_vcpu *vcpu)
>  {
>  	int reg1, reg2;
> +	u64 *r1, *r2;
> =20
>  	vcpu->stat.instruction_epsw++;
> =20
>  	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
> +	r1 =3D vcpu->run->s.regs.gprs + reg1;
> +	r2 =3D vcpu->run->s.regs.gprs + reg2;
> =20
>  	/* This basically extracts the mask half of the psw. */
> -	vcpu->run->s.regs.gprs[reg1] &=3D 0xffffffff00000000UL;
> -	vcpu->run->s.regs.gprs[reg1] |=3D vcpu->arch.sie_block->gpsw.mask >> 32=
;
> -	if (reg2) {
> -		vcpu->run->s.regs.gprs[reg2] &=3D 0xffffffff00000000UL;
> -		vcpu->run->s.regs.gprs[reg2] |=3D
> -			vcpu->arch.sie_block->gpsw.mask & 0x00000000ffffffffUL;
> -	}
> +	*r1 =3D u64_replace_bits(*r1, vcpu->arch.sie_block->gpsw.mask >> 32, 0x=
ffffffff);
> +	if (reg2)
> +		*r2 =3D u64_replace_bits(*r2, vcpu->arch.sie_block->gpsw.mask, 0xfffff=
fff);

LGTM although I don't hate the original implementation, which is very easy =
to understand
compared to u64_replace_bits whose implementation is anything but.
It would be nice to make gprs a union, which I think should be fine from a =
backwards
compatibility point of view. So:

struct kvm_sync_regs {
	__u64 prefix;	/* prefix register */
	union {
		__u64 gprs[16];	/* general purpose registers */
		struct { __u32 h; __u32 l} gprs32[16];
		struct { __u16 hh; __u16 hl; ...} gprs16[16];
		...=20
...

But I don't expect you to do the refactor.
You could of course also contribute documentation to bitfield.h :)

>  	return 0;
>  }

[...]

>  static int handle_pfmf(struct kvm_vcpu *vcpu)
>  {

[...]

> -	if (vcpu->run->s.regs.gprs[reg1] & PFMF_FSC) {
> -		if (psw_bits(vcpu->arch.sie_block->gpsw).eaba =3D=3D PSW_BITS_AMODE_64=
BIT) {
> -			vcpu->run->s.regs.gprs[reg2] =3D end;
> -		} else {
> -			vcpu->run->s.regs.gprs[reg2] &=3D ~0xffffffffUL;
> -			end =3D kvm_s390_logical_to_effective(vcpu, end);
> -			vcpu->run->s.regs.gprs[reg2] |=3D end;
> -		}
> +	if (r1.fsc) {
> +		u64 *r2 =3D vcpu->run->s.regs.gprs + reg2;
> +
> +		end =3D kvm_s390_logical_to_effective(vcpu, end);
> +		if (kvm_s390_is_amode_64(vcpu))
> +			*r2 =3D u64_replace_bits(*r2, end, PAGE_MASK);
> +		else
> +			*r2 =3D u64_replace_bits(*r2, end, 0xfffff000);

Same issue as above regarding the shift.

>  	}
>  	return 0;
>  }
> @@ -1361,8 +1338,9 @@ int kvm_s390_handle_lctl(struct kvm_vcpu *vcpu)
>  	reg =3D reg1;
>  	nr_regs =3D 0;
>  	do {
> -		vcpu->arch.sie_block->gcr[reg] &=3D 0xffffffff00000000ul;
> -		vcpu->arch.sie_block->gcr[reg] |=3D ctl_array[nr_regs++];
> +		u64 *cr =3D vcpu->arch.sie_block->gcr + reg;
> +
> +		*cr =3D u64_replace_bits(*cr, ctl_array[nr_regs++], 0xffffffff);
>  		if (reg =3D=3D reg3)
>  			break;
>  		reg =3D (reg + 1) % 16;
> @@ -1489,7 +1467,7 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
>  	case 0x62:
>  		return handle_ri(vcpu);
>  	case 0x71:
> -		return handle_lpswey(vcpu);
> +		return handle_lpswe_y(vcpu, true);
>  	default:
>  		return -EOPNOTSUPP;
>  	}

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen / Registergericht: Amtsgericht Stuttg=
art, HRB 243294


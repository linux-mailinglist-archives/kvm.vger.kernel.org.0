Return-Path: <kvm+bounces-47139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05969ABDDED
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4CB24C7EBF
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596AD248F40;
	Tue, 20 May 2025 14:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EWDwpcfg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9871A1519AC;
	Tue, 20 May 2025 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747752004; cv=none; b=qhYV+gs/ZqFpP7BF4FzG5bXvXg7y5TnfiWx1hUkKwQtFqhY1lV9fXF0dOQq93bafjKSg96+k0KJYLEsQQqmGtaw1dum08w9jLdf0gUigvhd7kKolOnP46F64nozWjCg1wWaJzeZg/jkdm0Y9RacbGVtdw1AkvmMgy+sSTJaOLTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747752004; c=relaxed/simple;
	bh=qbo9y1yjG9/6H/kQ1Ef+P/wNQEMPMfAyw82d+bkcMTw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gjbkYrdQXbDPr3YkhsC0Zuynuar+oj43GyTMaS9i8F5tpmxsdPCZw/ieNgPrgbCtzp6cVLTs7DZ3UuDjn1DScZB6G+qEyUQER2GlDfnPfGbbzMyeoEyyL+gC2cn7g8GIt9UTX1COV+tuxR+PpBTLrzaC4XolPVojTET7Sz0rbn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EWDwpcfg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K7Lv7U014124;
	Tue, 20 May 2025 14:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FnY1g4
	EGgiDaouSNOY04GLLRPwklAkE+ZBRYBGSyk0U=; b=EWDwpcfgcIU1L0swQS11ih
	kkWe1AjtG6tIFQ6RBrI/xLzHBLRjLi4RQQ7mfo/uLpd4crjiqnpwZKbLwokWdtmH
	ZHuyTr8toH4f7Z0VOQ1Wy4/njkjUBBSQghKsIVAdPCe+7MZbyqn+B7ZaVj2Do2/7
	6/jCQkLIspoSfBPDZAT4i4V2XAJOLLmrwxa4Ke9A7REIyXUxPmkT/jUeAn7GuUQt
	1fd+sJI6PvFjGscERUWTkWfGcyc6AjB4ldcNn+GTBAUectnNqoqYcefUOwt7gFHS
	UNVvxy0fhsiQHX8l09gXD+iXJPfQGWiKFITMwqlhlG+GVGh7njbIgPyWei4gk7gw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ra99mv9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 14:39:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KEaIrg005332;
	Tue, 20 May 2025 14:39:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46q69mcaeq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 14:39:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KEds1b55836962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 14:39:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89AE820040;
	Tue, 20 May 2025 14:39:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23B7420043;
	Tue, 20 May 2025 14:39:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 14:39:54 +0000 (GMT)
Date: Tue, 20 May 2025 16:39:52 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v1 3/5] KVM: s390: refactor some functions in priv.c
Message-ID: <20250520163952.596fedba@p-imbrenda>
In-Reply-To: <9fdc24a2288201b966864e11dd39fc3b009a1b93.camel@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
	<20250514163855.124471-4-imbrenda@linux.ibm.com>
	<9fdc24a2288201b966864e11dd39fc3b009a1b93.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=J/mq7BnS c=1 sm=1 tr=0 ts=682c943f cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=dCV7v41bBbUkAkYtX9QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDExOCBTYWx0ZWRfX6Sl7QbvDbtpa zfm/ShikrcbvvocROJvyOOZ8YWQa1bpIG+X9oBZJz23QkuMuQRYyJc/h7h2seTc8dgHCfFGMmRn /MY8I9a89XGlIsRpoMfKa7hs9sqouu9H/oj9SbdSHE1wDJEKF6mLxL+siEsSBUZc8RczKWKIQG1
 rRsr0NTzj/Jj5p1A2V+T4lICaj23UEiJwibwxIXxuLPsnURjEvEYP/SdpYStnQCu3lpGUTJ/cDB iMWlHEfOtmGF9NYH3cE9Is0iaH+uIsvyjNxljbqZhCiTsBfwXLyizdODnY60yR2yjqlPygpikMP yKnWwQb8SwmF6E/slFdKEPYi/anODfSGtQn3l2t14Q90mdm5SgCChHULCg1cHR1kPtqBrkg+91a
 xe1isjYprws0tKYRYNu2B4SN0lPzCTtQovQQkg2VTI0b7vJibV4LflpbbC8HHl0298wlkiis
X-Proofpoint-ORIG-GUID: Ak5EPmIL3-aAbIe3IVDScG522UyYoLze
X-Proofpoint-GUID: Ak5EPmIL3-aAbIe3IVDScG522UyYoLze
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_06,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505200118

On Tue, 20 May 2025 14:49:55 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:
> > Refactor some functions in priv.c to make them more readable.
> >=20
> > handle_{iske,rrbe,sske}: move duplicated checks into a single function.
> > handle{pfmf,epsw}: improve readability.
> > handle_lpswe{,y}: merge implementations since they are almost the same.
> >=20
> > Use u64_replace_bits() where it makes sense.
> >=20
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/kvm/kvm-s390.h |  15 ++
> >  arch/s390/kvm/priv.c     | 288 ++++++++++++++++++---------------------
> >  2 files changed, 148 insertions(+), 155 deletions(-)
> >  =20
> [...]
>=20
> > diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> > index 758cefb5bac7..1a26aa591c2e 100644
> > --- a/arch/s390/kvm/priv.c
> > +++ b/arch/s390/kvm/priv.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/mm_types.h>
> >  #include <linux/pgtable.h>
> >  #include <linux/io.h>
> > +#include <linux/bitfield.h>
> >  #include <asm/asm-offsets.h>
> >  #include <asm/facility.h>
> >  #include <asm/current.h>
> > @@ -253,29 +254,50 @@ static int try_handle_skey(struct kvm_vcpu *vcpu)
> >  	return 0;
> >  }
> > =20
> > +struct skeys_ops_state {
> > +	int reg1;
> > +	int reg2;
> > +	int rc;
> > +	unsigned long gaddr;
> > +};
> > +
> > +static bool skeys_common_checks(struct kvm_vcpu *vcpu, struct skeys_op=
s_state *state, bool abs)
> > +{
> > +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE) {
> > +		state->rc =3D kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> > +		return true;
> > +	}
> > +
> > +	state->rc =3D try_handle_skey(vcpu);
> > +	if (state->rc)
> > +		return true;
> > +
> > +	kvm_s390_get_regs_rre(vcpu, &state->reg1, &state->reg2);
> > +
> > +	state->gaddr =3D vcpu->run->s.regs.gprs[state->reg2] & PAGE_MASK;
> > +	state->gaddr =3D kvm_s390_logical_to_effective(vcpu, state->gaddr);
> > +	if (!abs)
> > +		state->gaddr =3D kvm_s390_real_to_abs(vcpu, state->gaddr);
> > +
> > +	return false;
> > +} =20
>=20
> I don't really like this function, IMO it makes the calling functions har=
der to read.
> If it was just a chain of checks it be fine, but with the differing contr=
ol flow
> base on the abs parameter and the complex return value it becomes too com=
plicated.

I'll try to improve it

>=20
> > +
> >  static int handle_iske(struct kvm_vcpu *vcpu)
> >  {
> > -	unsigned long gaddr, vmaddr;
> > +	struct skeys_ops_state state;
> > +	unsigned long vmaddr;
> >  	unsigned char key;
> > -	int reg1, reg2;
> >  	bool unlocked;
> > +	u64 *r1;
> >  	int rc;
> > =20
> >  	vcpu->stat.instruction_iske++;
> > =20
> > -	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> > -		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP); =20
>=20
> How about a macro INJECT_PGM_ON: INJECT_PGM_ON(kvm_s390_problem_state(vcp=
u), PGM_PRIVILEGED_OP)

no, I would like to avoid hiding control flow in a macro

>=20
>=20
> > -
> > -	rc =3D try_handle_skey(vcpu);
> > -	if (rc)
> > -		return rc !=3D -EAGAIN ? rc : 0; =20
>=20
> You are not replicating this behavior, are you?

no, but it's fine, we can afford a useless trip to userspace literally
once in the lifetime of the guest

> > -
> > -	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2); =20
>=20
> You could introduce a helper
>=20
> void _kvm_s390_get_gpr_ptrs_rre(vcpu, u64 **reg1, u64 **reg2)
> {
> 	int r1, r2;
>=20
> 	kvm_s390_get_regs_rre(vcpu, &r1, &r2);
> 	*reg1 =3D &vcpu->run->s.regs.gprs[r1];
> 	*reg2 =3D &vcpu->run->s.regs.gprs[r2];
> }
>=20
> which would remove some clutter from the original function implementation=
s.
>=20
> > +	if (skeys_common_checks(vcpu, &state, false))
> > +		return state.rc;
> > +	r1 =3D vcpu->run->s.regs.gprs + state.reg1;
> > =20
> > -	gaddr =3D vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
> > -	gaddr =3D kvm_s390_logical_to_effective(vcpu, gaddr);
> > -	gaddr =3D kvm_s390_real_to_abs(vcpu, gaddr);
> > -	vmaddr =3D gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
> > +	vmaddr =3D gfn_to_hva(vcpu->kvm, gpa_to_gfn(state.gaddr));
> >  	if (kvm_is_error_hva(vmaddr))
> >  		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
> >  retry:
> > @@ -296,33 +318,23 @@ static int handle_iske(struct kvm_vcpu *vcpu)
> >  		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
> >  	if (rc < 0)
> >  		return rc;
> > -	vcpu->run->s.regs.gprs[reg1] &=3D ~0xff;
> > -	vcpu->run->s.regs.gprs[reg1] |=3D key;
> > +	*r1 =3D u64_replace_bits(*r1, key, 0xff);
> >  	return 0;
> >  }
> > =C2=A0
> >  =20
> [...]
>=20
> >  retry:
> > @@ -353,40 +365,30 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
> >  static int handle_sske(struct kvm_vcpu *vcpu)
> >  {
> >  	unsigned char m3 =3D vcpu->arch.sie_block->ipb >> 28;
> > +	struct skeys_ops_state state;
> >  	unsigned long start, end;
> >  	unsigned char key, oldkey;
> > -	int reg1, reg2;
> > +	bool nq, mr, mc, mb;
> >  	bool unlocked;
> > +	u64 *r1, *r2;
> >  	int rc;
> > =20
> >  	vcpu->stat.instruction_sske++;
> > =20
> > -	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> > -		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> > -
> > -	rc =3D try_handle_skey(vcpu);
> > -	if (rc)
> > -		return rc !=3D -EAGAIN ? rc : 0;
> > -
> > -	if (!test_kvm_facility(vcpu->kvm, 8))
> > -		m3 &=3D ~SSKE_MB;
> > -	if (!test_kvm_facility(vcpu->kvm, 10))
> > -		m3 &=3D ~(SSKE_MC | SSKE_MR);
> > -	if (!test_kvm_facility(vcpu->kvm, 14))
> > -		m3 &=3D ~SSKE_NQ;
> > +	mb =3D test_kvm_facility(vcpu->kvm, 8) && (m3 & SSKE_MB);
> > +	mr =3D test_kvm_facility(vcpu->kvm, 10) && (m3 & SSKE_MR);
> > +	mc =3D test_kvm_facility(vcpu->kvm, 10) && (m3 & SSKE_MC);
> > +	nq =3D test_kvm_facility(vcpu->kvm, 14) && (m3 & SSKE_NQ); =20
>=20
> That is indeed much nicer.
>=20
> > =20
> > -	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
> > +	/* start already designates an absolute address if MB is set */
> > +	if (skeys_common_checks(vcpu, &state, mb))
> > +		return state.rc;
> > =20
> > -	key =3D vcpu->run->s.regs.gprs[reg1] & 0xfe;
> > -	start =3D vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
> > -	start =3D kvm_s390_logical_to_effective(vcpu, start);
> > -	if (m3 & SSKE_MB) {
> > -		/* start already designates an absolute address */
> > -		end =3D (start + _SEGMENT_SIZE) & ~(_SEGMENT_SIZE - 1);
> > -	} else {
> > -		start =3D kvm_s390_real_to_abs(vcpu, start);
> > -		end =3D start + PAGE_SIZE;
> > -	}
> > +	start =3D state.gaddr;
> > +	end =3D mb ? ALIGN(start + 1, _SEGMENT_SIZE) : start + PAGE_SIZE; =20
>=20
> Alternatively you could do ALIGN_DOWN(start, _SEGMENT_SIZE) + _SEGMENT_SI=
ZE,
> which seems a bit easier to read, but it's really minor.
>=20
> > +	r1 =3D vcpu->run->s.regs.gprs + state.reg1;
> > +	r2 =3D vcpu->run->s.regs.gprs + state.reg2;
> > +	key =3D *r1 & 0xfe;
> > =20
> >  	while (start !=3D end) {
> >  		unsigned long vmaddr =3D gfn_to_hva(vcpu->kvm, gpa_to_gfn(start));
> > @@ -396,9 +398,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
> >  			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
> > =20
> >  		mmap_read_lock(current->mm);
> > -		rc =3D cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey,
> > -						m3 & SSKE_NQ, m3 & SSKE_MR,
> > -						m3 & SSKE_MC);
> > +		rc =3D cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey,=
 nq, mr, mc);
> > =20
> >  		if (rc < 0) {
> >  			rc =3D fixup_user_fault(current->mm, vmaddr,
> > @@ -415,23 +415,21 @@ static int handle_sske(struct kvm_vcpu *vcpu)
> >  		start +=3D PAGE_SIZE;
> >  	}
> > =20
> > -	if (m3 & (SSKE_MC | SSKE_MR)) {
> > -		if (m3 & SSKE_MB) {
> > +	if (mc || mr) {
> > +		if (mb) {
> >  			/* skey in reg1 is unpredictable */
> >  			kvm_s390_set_psw_cc(vcpu, 3);
> >  		} else {
> >  			kvm_s390_set_psw_cc(vcpu, rc);
> > -			vcpu->run->s.regs.gprs[reg1] &=3D ~0xff00UL;
> > -			vcpu->run->s.regs.gprs[reg1] |=3D (u64) oldkey << 8;
> > +			*r1 =3D u64_replace_bits(*r1, oldkey << 8, 0xff00); =20
>=20
> Uh, u64_replace_bits does the shift for you, no?
> So it should be u64_replace_bits(*r1, oldkey, 0xff00)
>=20
> You could also do u64p_replace_bits(r1, oldkey, 0xff00) but I'd actually =
prefer the assignment
> as you do it.

yeahhhhhh I think I'll completely rewrite those parts using bitfields
and structs / unions

>=20
> >  		}
> >  	}
> > -	if (m3 & SSKE_MB) {
> > -		if (psw_bits(vcpu->arch.sie_block->gpsw).eaba =3D=3D PSW_BITS_AMODE_=
64BIT)
> > -			vcpu->run->s.regs.gprs[reg2] &=3D ~PAGE_MASK;
> > -		else
> > -			vcpu->run->s.regs.gprs[reg2] &=3D ~0xfffff000UL;
> > +	if (mb) {
> >  		end =3D kvm_s390_logical_to_effective(vcpu, end);
> > -		vcpu->run->s.regs.gprs[reg2] |=3D end;
> > +		if (kvm_s390_is_amode_64(vcpu))
> > +			*r2 =3D u64_replace_bits(*r2, end, PAGE_MASK);
> > +		else
> > +			*r2 =3D u64_replace_bits(*r2, end, 0xfffff000); =20
>=20
> This does not work because of the implicit shift.
> So you need to use gpa_to_gfn(end) instead.
> (I think I would prefer using start instead of end, since it better shows
> the interruptible nature of the instruction, but start =3D=3D end if
> we get here so ...)
>=20
> >  	}
> >  	return 0;
> >  }
> > @@ -773,46 +771,28 @@ int kvm_s390_handle_lpsw(struct kvm_vcpu *vcpu)
> >  	return 0;
> >  }
> > =20
> > -static int handle_lpswe(struct kvm_vcpu *vcpu)
> > +static int handle_lpswe_y(struct kvm_vcpu *vcpu, bool lpswey)
> >  {
> >  	psw_t new_psw;
> >  	u64 addr;
> >  	int rc;
> >  	u8 ar;
> > =20
> > -	vcpu->stat.instruction_lpswe++;
> > -
> > -	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> > -		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> > -
> > -	addr =3D kvm_s390_get_base_disp_s(vcpu, &ar);
> > -	if (addr & 7)
> > -		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> > -	rc =3D read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
> > -	if (rc)
> > -		return kvm_s390_inject_prog_cond(vcpu, rc);
> > -	vcpu->arch.sie_block->gpsw =3D new_psw;
> > -	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
> > -		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> > -	return 0;
> > -}
> > -
> > -static int handle_lpswey(struct kvm_vcpu *vcpu)
> > -{
> > -	psw_t new_psw;
> > -	u64 addr;
> > -	int rc;
> > -	u8 ar;
> > -
> > -	vcpu->stat.instruction_lpswey++;
> > +	if (lpswey)
> > +		vcpu->stat.instruction_lpswey++;
> > +	else
> > +		vcpu->stat.instruction_lpswe++;
> > =20
> > -	if (!test_kvm_facility(vcpu->kvm, 193))
> > +	if (lpswey && !test_kvm_facility(vcpu->kvm, 193))
> >  		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
> > =20
> >  	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> >  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> > =20
> > -	addr =3D kvm_s390_get_base_disp_siy(vcpu, &ar);
> > +	if (!lpswey)
> > +		addr =3D kvm_s390_get_base_disp_s(vcpu, &ar);
> > +	else
> > +		addr =3D kvm_s390_get_base_disp_siy(vcpu, &ar);
> >  	if (addr & 7)
> >  		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION); =20
>=20
> I'd prefer a helper function _do_lpswe_y_swap(struct kvm_vcpu *vcpu, gpa_=
t addr)
>=20
> and then just
>=20
> static int handle_lpswey(struct kvm_vcpu *vcpu)
> {
>         u64 addr;
>         u8 ar;
>=20
>         vcpu->stat.instruction_lpswey++;
>=20
>         if (!test_kvm_facility(vcpu->kvm, 193))
>                 return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>=20
>         addr =3D kvm_s390_get_base_disp_siy(vcpu, &ar);
> 	return _do_lpswe_y_swap(vcpu, addr);
> }
>=20
> Makes it easier to read IMO because of the simpler control flow.

hmmm you have a point

> > =20
> > @@ -1034,7 +1014,7 @@ int kvm_s390_handle_b2(struct kvm_vcpu *vcpu)
> >  	case 0xb1:
> >  		return handle_stfl(vcpu);
> >  	case 0xb2:
> > -		return handle_lpswe(vcpu);
> > +		return handle_lpswe_y(vcpu, false);
> >  	default:
> >  		return -EOPNOTSUPP;
> >  	}
> > @@ -1043,42 +1023,50 @@ int kvm_s390_handle_b2(struct kvm_vcpu *vcpu)
> >  static int handle_epsw(struct kvm_vcpu *vcpu)
> >  {
> >  	int reg1, reg2;
> > +	u64 *r1, *r2;
> > =20
> >  	vcpu->stat.instruction_epsw++;
> > =20
> >  	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
> > +	r1 =3D vcpu->run->s.regs.gprs + reg1;
> > +	r2 =3D vcpu->run->s.regs.gprs + reg2;
> > =20
> >  	/* This basically extracts the mask half of the psw. */
> > -	vcpu->run->s.regs.gprs[reg1] &=3D 0xffffffff00000000UL;
> > -	vcpu->run->s.regs.gprs[reg1] |=3D vcpu->arch.sie_block->gpsw.mask >> =
32;
> > -	if (reg2) {
> > -		vcpu->run->s.regs.gprs[reg2] &=3D 0xffffffff00000000UL;
> > -		vcpu->run->s.regs.gprs[reg2] |=3D
> > -			vcpu->arch.sie_block->gpsw.mask & 0x00000000ffffffffUL;
> > -	}
> > +	*r1 =3D u64_replace_bits(*r1, vcpu->arch.sie_block->gpsw.mask >> 32, =
0xffffffff);
> > +	if (reg2)
> > +		*r2 =3D u64_replace_bits(*r2, vcpu->arch.sie_block->gpsw.mask, 0xfff=
fffff); =20
>=20
> LGTM although I don't hate the original implementation, which is very eas=
y to understand
> compared to u64_replace_bits whose implementation is anything but.

yeah I agree

> It would be nice to make gprs a union, which I think should be fine from =
a backwards
> compatibility point of view. So:
>=20
> struct kvm_sync_regs {
> 	__u64 prefix;	/* prefix register */
> 	union {
> 		__u64 gprs[16];	/* general purpose registers */
> 		struct { __u32 h; __u32 l} gprs32[16];
> 		struct { __u16 hh; __u16 hl; ...} gprs16[16];
> 		...=20
> ...
>=20
> But I don't expect you to do the refactor.
> You could of course also contribute documentation to bitfield.h :)

ehhhhhhh

>=20
> >  	return 0;
> >  } =20
>=20
> [...]
>=20
> >  static int handle_pfmf(struct kvm_vcpu *vcpu)
> >  { =20
>=20
> [...]
>=20
> > -	if (vcpu->run->s.regs.gprs[reg1] & PFMF_FSC) {
> > -		if (psw_bits(vcpu->arch.sie_block->gpsw).eaba =3D=3D PSW_BITS_AMODE_=
64BIT) {
> > -			vcpu->run->s.regs.gprs[reg2] =3D end;
> > -		} else {
> > -			vcpu->run->s.regs.gprs[reg2] &=3D ~0xffffffffUL;
> > -			end =3D kvm_s390_logical_to_effective(vcpu, end);
> > -			vcpu->run->s.regs.gprs[reg2] |=3D end;
> > -		}
> > +	if (r1.fsc) {
> > +		u64 *r2 =3D vcpu->run->s.regs.gprs + reg2;
> > +
> > +		end =3D kvm_s390_logical_to_effective(vcpu, end);
> > +		if (kvm_s390_is_amode_64(vcpu))
> > +			*r2 =3D u64_replace_bits(*r2, end, PAGE_MASK);
> > +		else
> > +			*r2 =3D u64_replace_bits(*r2, end, 0xfffff000); =20
>=20
> Same issue as above regarding the shift.
>=20
> >  	}
> >  	return 0;
> >  }
> > @@ -1361,8 +1338,9 @@ int kvm_s390_handle_lctl(struct kvm_vcpu *vcpu)
> >  	reg =3D reg1;
> >  	nr_regs =3D 0;
> >  	do {
> > -		vcpu->arch.sie_block->gcr[reg] &=3D 0xffffffff00000000ul;
> > -		vcpu->arch.sie_block->gcr[reg] |=3D ctl_array[nr_regs++];
> > +		u64 *cr =3D vcpu->arch.sie_block->gcr + reg;
> > +
> > +		*cr =3D u64_replace_bits(*cr, ctl_array[nr_regs++], 0xffffffff);
> >  		if (reg =3D=3D reg3)
> >  			break;
> >  		reg =3D (reg + 1) % 16;
> > @@ -1489,7 +1467,7 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
> >  	case 0x62:
> >  		return handle_ri(vcpu);
> >  	case 0x71:
> > -		return handle_lpswey(vcpu);
> > +		return handle_lpswe_y(vcpu, true);
> >  	default:
> >  		return -EOPNOTSUPP;
> >  	} =20
>=20



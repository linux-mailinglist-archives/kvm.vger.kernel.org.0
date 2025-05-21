Return-Path: <kvm+bounces-47294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57052ABFACA
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 18:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A4108C27C9
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 16:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6FD722155D;
	Wed, 21 May 2025 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IA294N4V"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCFE202F7C;
	Wed, 21 May 2025 15:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842744; cv=none; b=MQ201BBVE9KZH4rFOZAeWJXGnVGznCWHCy1yVtD/XVCH4fOs9g3fJwwoYIzq0XPTqYgzrhBS9UX1EXjRoFNUh5F3mu33w/89HvJA9rEJt4IL8MnaRv1vuLcpH89KIoA6r/B+yvj/+BgygysMAESo7bOE7hs8WEnd1qBvjfjW4xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842744; c=relaxed/simple;
	bh=G3q19HiN669ttmrnizWZ+QjhZHbzZgAeZ5tO1aNwb8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjUr+C/epiqXT6jV09mQ2Gfc05OG/DDt5IhBaB/FmOnua3iYW4Z9GcyKkV+E8FW0eA7biN9BQzBXNH9htNLXAX6qPTzUYxOKUyE9DbZ26wZt3/6yRj1dS6OqlzmL/QLDSA5H0mE+F8mOCuyHAmuZew/Jcvb+BVLcu7Q4afu44V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IA294N4V; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LAmYob030456;
	Wed, 21 May 2025 15:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=gDHHhtfQbx1ibmUx3WjgdrsAL3LQpt
	CHzJzATlXUBLk=; b=IA294N4VIYz7Xl9khOmSndHrrcCfrEEriWXkB4zsnxTCsz
	e7fUQm8MrpzHcCH3xwZvbvFHKLjrUWBl3oJX6Uay3oO/igoOPCE597YI6IogQcu7
	fpffqH44RXhag6eHpqJLb8KttVugdQzBJmf+sonKyUMfZBu3d5HLMAYKGCayaJna
	5TQ3/tKs0UbCPYP6PZo5YhZzPH7tlmLucg5jDI5EVzIP7LHSsNsM31gPK1NZT0iZ
	SqCl/p93HKtxXSRFG3MGvoo03bZnQZlI0WgUO9C9FULibcAaD0nm7EGKUkpfArqo
	ln8cvbnxkE2Jq1pyAgwjmfbpLypc3WVgcEdK8LpQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46s3d5m54n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:52:20 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54LDfsI8010640;
	Wed, 21 May 2025 15:52:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwnmcvv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 15:52:19 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54LFqFfn42009004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 15:52:15 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED7F220043;
	Wed, 21 May 2025 15:52:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A57A20040;
	Wed, 21 May 2025 15:52:14 +0000 (GMT)
Received: from osiris (unknown [9.87.128.135])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 21 May 2025 15:52:14 +0000 (GMT)
Date: Wed, 21 May 2025 17:52:12 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
Subject: Re: [PATCH v2 3/5] KVM: s390: refactor some functions in priv.c
Message-ID: <20250521155212.11483Da8-hca@linux.ibm.com>
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
 <20250520182639.80013-4-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520182639.80013-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: S7fu4XbAOMOOqfUWSoTbebCrKoHHOhPb
X-Proofpoint-ORIG-GUID: S7fu4XbAOMOOqfUWSoTbebCrKoHHOhPb
X-Authority-Analysis: v=2.4 cv=cM/gskeN c=1 sm=1 tr=0 ts=682df6b4 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=5jWV00l8V3tV8VPG5IkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDE1MyBTYWx0ZWRfXww4dJDpaXsUr Nv2v0WaTNoS9cvU+oe7AewTWCw9nQWwXBZEC1Xeuw6dOSvfcpcHPpLBO8XGuXzVgTAuOZ/kJTfW EqsfgDYx+o/xkmPLblFaFPm7mk7FeknU3ynulPoCY5Q6ZyEmP22H89lp8FHbsxy7QH0uWDtgeAr
 6e+fhCH0fSnimr3L4Dd1E2qi2CbSzXCX1dVwtw4y0EGJopG5kAcLb8A6O8M2nc/WTSyJvVnxt3A 05NU0/Xlh+mUW9XzCgARJKq6QylW8hD9YJq92xQ01Mfl4SRLk1EsRJfEZV2J1Ot7l/MnvtxdzTm xgWp8es4ERV32cVDvHXligaY7NrcQF9F/FZIzpuFQ/ElGB0WELZa9+wbpTqPLpRqQYi2yd3o+Fq
 aHt7EmuLOOsXKKm7Zu7TRvwLU44bV/sf9WaZ5fFheX1WGU6ofcynL2ijcLkRN6HgmNLjXRnA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_05,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=647 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505210153

On Tue, May 20, 2025 at 08:26:37PM +0200, Claudio Imbrenda wrote:
> Refactor some functions in priv.c to make them more readable.
> 
> handle_{iske,rrbe,sske}: move duplicated checks into a single function.
> handle{pfmf,epsw}: improve readability.
> handle_lpswe{,y}: merge implementations since they are almost the same.
> 
> Use a helper function to replace open-coded bit twiddling operations.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

...since you asked me to look into this... :)

For the sake of reviewability: I guess this really should be split
into separate patches which address one function each.

> +static inline void replace_selected_bits(u64 *w, unsigned long mask, unsigned long val)
> +{
> +	*w = (*w & ~mask) | (val & mask);
> +}
> +
> +struct skeys_ops_state {
> +	int reg1;
> +	int reg2;
> +	u64 *r1;
> +	u64 *r2;
> +	unsigned long effective;
> +	unsigned long absolute;
> +};
> +
> +static void get_regs_rre_ptr(struct kvm_vcpu *vcpu, int *reg1, int *reg2, u64 **r1, u64 **r2)
> +{
> +	kvm_s390_get_regs_rre(vcpu, reg1, reg2);
> +	*r1 = vcpu->run->s.regs.gprs + *reg1;
> +	*r2 = vcpu->run->s.regs.gprs + *reg2;
> +}

Ewww...

> +static int skeys_common_checks(struct kvm_vcpu *vcpu, struct skeys_ops_state *state)
> +{
> +	int rc;
> +
> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE) {
> +		rc = kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> +		return rc ? rc : -EAGAIN;
> +	}

Hm.. first you introduce helper functions which use psw_bits() and now
this is open-coded again?

> +	rc = try_handle_skey(vcpu);
> +	if (rc)
> +		return rc;
> +
> +	get_regs_rre_ptr(vcpu, &state->reg1, &state->reg2, &state->r1, &state->r2);
> +
> +	state->effective = vcpu->run->s.regs.gprs[state->reg2] & PAGE_MASK;
> +	state->effective = kvm_s390_logical_to_effective(vcpu, state->effective);
> +	state->absolute = kvm_s390_real_to_abs(vcpu, state->effective);
> +
> +	return 0;
> +}

So a function which is called "*common_checks" actually may or may not
set up a state which is later used. This is anything but obvious.

>  static int handle_iske(struct kvm_vcpu *vcpu)
>  {

...

> -	vcpu->run->s.regs.gprs[reg1] &= ~0xff;
> -	vcpu->run->s.regs.gprs[reg1] |= key;
> +	replace_selected_bits(state.r1, 0xff, key);

Who is supposed to understand that this replace_selected_bits() call
actually changes vcpu->run->s.regs.gprs[reg1]? To me this obfuscates
the code and makes it much less understandable.

From my point of view this state structure and passing it back and
forth is a mistake, since it hides way too much what is actually going
on.

Anyway, just my 0.02. :)


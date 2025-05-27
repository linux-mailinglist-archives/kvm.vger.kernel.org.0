Return-Path: <kvm+bounces-47760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B597AC492D
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 09:18:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60A791727BC
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 07:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E68220F46;
	Tue, 27 May 2025 07:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ViYhpYcx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E750721D5A4;
	Tue, 27 May 2025 07:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748330294; cv=none; b=jyUYJZo5sZn5i4w/izoKW2FJ++xb8CuchlD1MIazgP33/dm9kfqH88izPbhvq3bQ8RTueumNmfXb1TUhpN+XosoXFMX2R3ibIbmlpYSWXaT1YbPMr9ppIMGhnDHZS/sgv4GiZ/SurubGce2a2DgjsZ9yh1L1gBi9Wdqe7McCJdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748330294; c=relaxed/simple;
	bh=f4Hx8Tpui0PKRNM7Z+70KH3fALemtKbbPYlfhdi1ilc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=URYX1Js542lN1XumDQtD74NVJ0p6Nx1gWZ0cuMvSg4F2N8mJ6QLjb/zOkxa1qHtTuRaF/ThQbBw++bS/DCME+y0H+UtFpwDZAvi6KUORuUPIoMxjJZ8fdyEtpf/SOTP6KEkBCMK5+t2R71jnRzzWLs/S0G4E9anZciFLNOamgek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ViYhpYcx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54R2U6UE032558;
	Tue, 27 May 2025 07:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=opYd4H
	OG5d2/EA2ZMhabVToKW7wW7XkK5OwqUHeJdEA=; b=ViYhpYcxsrDnpC2Al8UVDK
	PetRGcNbaDNVJjig7a1NPcWA4zg4/8dyDmdB1IacZqC8dppI7eg3CCn29kiWq+zJ
	Fm7/bmN+WqZqkmNv8sIpV38wIX+4KhOzW3BaKZqQGqBVDKzWHta9wk4ayhY7jLHx
	DS7g4nsehaV+Z+2nVq5dXOuduqrefdYHREQ/HZRuz9OsRRKjkkjVBsk33iAv+FBD
	uJPQyJ1iDkE9prH8tOPfjVE1JkApSVSeq8AYeXNCCFkJJd+rHpQMvLSqlQwjJ15U
	yC62AfdLMBlt66iTffO4asIELz+n5RNmMTHWV4r0b1EBI6721IUJ1BRzBJ2XQLHA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46u3hrw75h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 May 2025 07:18:10 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54R74F3H010750;
	Tue, 27 May 2025 07:18:06 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46uru0hq5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 May 2025 07:18:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54R7I2LK35520932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 May 2025 07:18:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A5142004E;
	Tue, 27 May 2025 07:18:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5076B20040;
	Tue, 27 May 2025 07:18:01 +0000 (GMT)
Received: from t14-nrb (unknown [9.87.142.254])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 May 2025 07:18:01 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 May 2025 09:18:01 +0200
Message-Id: <DA6RCZ7FOBOS.1U1CX5REWAGTN@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <seiden@linux.ibm.com>, <nsg@linux.ibm.com>, <david@redhat.com>,
        <hca@linux.ibm.com>, <agordeev@linux.ibm.com>, <svens@linux.ibm.com>,
        <gor@linux.ibm.com>, <schlameuss@linux.ibm.com>
Subject: Re: [PATCH v2 3/5] KVM: s390: refactor some functions in priv.c
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
 <20250520182639.80013-4-imbrenda@linux.ibm.com>
In-Reply-To: <20250520182639.80013-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AOOMbaiN c=1 sm=1 tr=0 ts=68356732 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=R0-nb_ruKWFPPYddgEsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _bFAT-T7cIq5VrWfdSN6tW9kmVHCpUgr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI3MDA1NSBTYWx0ZWRfX2sIR4aWwn1/l kzPWbutHOie+M9vJQzJHePAaTgXdzA8NVbGRU2mgNhGCk5Pfcn7nMsGK3LBV/IYuJI7RfXoyavq nYvEUc/kiNfESZBeR8QTZrnbiwDwMlkB9XnUMs06U3VTU2tUSSdQorCMj0wJTr/ltqHKhSoqqXT
 EGIjfffO/bakDsAXIV3c8TBmczNPzq3KvgwWkRHhJlubeEJmfepu3BkqDonn0h4e17if88YR6Je ggaE6VN7bQTIxYMeCi5QRuJ+VvS4wq5mpWJ8myctN/EYDjNi3LHtUnsP++HA9CGoC5iT/E/uPUJ acCE1QfLdKXf7FYYumE3X21B4s7TelhFaKPtE49fjCBehpivoa03oHIi7WUQa+sTXNyQNow6ZTt
 TKrZijIYFqN2DxjRehDVOSibIfnL/N/0enkZvG0Ckud2lBf64/feYInDELH5O9tWrsvyJNea
X-Proofpoint-GUID: _bFAT-T7cIq5VrWfdSN6tW9kmVHCpUgr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-27_03,2025-05-26_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 mlxlogscore=605 malwarescore=0 lowpriorityscore=0
 phishscore=0 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505270055

On Tue May 20, 2025 at 8:26 PM CEST, Claudio Imbrenda wrote:
[...]
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 9253c70897a8..15843e7e57e6 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
[...]
> +static int skeys_common_checks(struct kvm_vcpu *vcpu, struct skeys_ops_s=
tate *state)
> +{
> +	int rc;
> +
> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE) {
> +		rc =3D kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> +		return rc ? rc : -EAGAIN;

What has changed that

return kvm_s390_inject_program_int()

is not sufficient any more?

[...]
> +	get_regs_rre_ptr(vcpu, &state->reg1, &state->reg2, &state->r1, &state->=
r2);
> +
> +	state->effective =3D vcpu->run->s.regs.gprs[state->reg2] & PAGE_MASK;

*state->r2?

[...]
>  static int handle_pfmf(struct kvm_vcpu *vcpu)
>  {
[...]
> +	if (r1.fsc) {
> +		end =3D kvm_s390_logical_to_effective(vcpu, end);
> +		if (kvm_s390_is_amode_64(vcpu))
> +			replace_selected_bits(r2, PAGE_MASK, end);
> +		else
> +			replace_selected_bits(r2, 0xfffff000, end);

Maybe I'm missing something, but I don't get why you need replace_selected_=
bits
here.  kvm_s390_logical_to_effective() already does the neccesary masking, =
no?


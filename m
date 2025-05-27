Return-Path: <kvm+bounces-47776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA710AC4B52
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8728317D37B
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 09:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F5124DD13;
	Tue, 27 May 2025 09:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="basDyrob"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0D11EF09D;
	Tue, 27 May 2025 09:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748337296; cv=none; b=G19ElQfchkBBjNsCPCiSiZbvAjOrjlgpl14P8sjVB9sQEMHVpplzYYRa1eCRXYtlaAAwL10RXkXYf/WLA9qadLAhCo08c+CLjr6QxWgLb4hYnbbCqIBTuGP8WJh9ASrjtxpy5LAEyPwNtvFCDqtPizqo5waktjcnNMYT8KLQvg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748337296; c=relaxed/simple;
	bh=XIEtSh50r/yonznh6hQZQjUoc0cYgrP2M9XnPN63A+I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EGEoWtD4v0bPkOfwFko0X8d5gD6VdUGf6xL02/+vhcQrtfdiR0TeB+cpFNcknadvXBf17ZEx69+CMpfAlNzjLkJWwf+9YC/onUmqoYiidXImBzdjmQeZ/zhVtqDGtdvrFtMEsf/R8sIw/Gw+ipqgEfXTjWC2RyXV7IVCPV8o1jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=basDyrob; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54R4Ui5h008681;
	Tue, 27 May 2025 09:14:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9gpYX/
	nada+1wpGrmo2oDu+X0GfW6oxLrIxjCbh6GjQ=; b=basDyrobYgnSynLAVnkRdo
	bPRFTDabXIcm6IxvWThuSRaV7fnZhlY74v/O2YZTNrg1Iw3R1E7PSKf3ojMVWpl5
	GqBD43J5MyDuOAJTisNbafZBGTWRv7ALmo6/cJVkNm2jjU6ntAHFGor5WZajBXBZ
	jbtzp5wHZJwcQpBW4tks2+id2LXcT0hf2D+LlvvonShOyx3C1LcIf7GfsGscIYh3
	0EylMhv3NxCHGnbwySL6w+6OqRsrmHp+hSaFToPJRXBqjTbSgybJ5tMgsNBLcYBO
	DI5QGyPPeQQtJH6c5C4qPeaUQkM2CG95oofz1HurC1LDkwu6QaQqu14LAkkiISFQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46u5ucnb34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 May 2025 09:14:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54R6Rxkc016626;
	Tue, 27 May 2025 09:14:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46ureua5nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 May 2025 09:14:50 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54R9ElvM17760706
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 May 2025 09:14:47 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4187920040;
	Tue, 27 May 2025 09:14:47 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82D092004B;
	Tue, 27 May 2025 09:14:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.27.210])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 27 May 2025 09:14:46 +0000 (GMT)
Date: Tue, 27 May 2025 11:14:44 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Nico Boehr" <nrb@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <seiden@linux.ibm.com>, <nsg@linux.ibm.com>,
        <david@redhat.com>, <hca@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <svens@linux.ibm.com>, <gor@linux.ibm.com>, <schlameuss@linux.ibm.com>
Subject: Re: [PATCH v2 3/5] KVM: s390: refactor some functions in priv.c
Message-ID: <20250527111444.701ea84c@p-imbrenda>
In-Reply-To: <DA6RCZ7FOBOS.1U1CX5REWAGTN@linux.ibm.com>
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
	<20250520182639.80013-4-imbrenda@linux.ibm.com>
	<DA6RCZ7FOBOS.1U1CX5REWAGTN@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FfZPVOl8HXlzxZz5pngC2xl9sPcJvcSQ
X-Proofpoint-GUID: FfZPVOl8HXlzxZz5pngC2xl9sPcJvcSQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI3MDA3MyBTYWx0ZWRfX/vBP+iUGGugC qqpOpwqUXaZmt1C5hX/Ts5Zu9lCzDwHd0ZKSRprD8bZPqWtMQ4Wvc2CewoTU2OMtuM2nNdRYxEy RToHugxWncqvNKWrhmuZUVN6sgr5CJh+R95ozc+LncwYdUT+LBX04ONW9fUG1iPUdBx04EAe50V
 4Qn/5y0xjbXRyz5f8DFK5bNtSYj55Yf5TW0vxhTzU1k6Sf63kVYimq1wfHZ/pgz6WZwraJDlMeC wFgYdDZMSol9zbY8PQdpDCaVcpa6/JOLsrAFp94ZSE/EnSE2YYoq6nhhaH5IGnmXsVjknvGdkQs osMC5vt2SkYy3KKLs7kkJd7c77K92N1oyLTrDOzfZQS5oX3veUXnk0CjBKSDD8nqhhllb15d8R0
 bTCDRXsSm60ef84wYOb9Jxu/yDEJPpgyLDv7WahbD0d7geJjNwSceBPX5mHpXXlm/645lIo/
X-Authority-Analysis: v=2.4 cv=fJM53Yae c=1 sm=1 tr=0 ts=6835828b cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=GRx3_awI1bdFvCwNOlsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-27_04,2025-05-26_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=722 suspectscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505270073

On Tue, 27 May 2025 09:18:01 +0200
"Nico Boehr" <nrb@linux.ibm.com> wrote:

this patch had so many issues, and brought no real advantages, so I
dropped it from v3 onwards

> On Tue May 20, 2025 at 8:26 PM CEST, Claudio Imbrenda wrote:
> [...]
> > diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> > index 9253c70897a8..15843e7e57e6 100644
> > --- a/arch/s390/kvm/priv.c
> > +++ b/arch/s390/kvm/priv.c  
> [...]
> > +static int skeys_common_checks(struct kvm_vcpu *vcpu, struct skeys_ops_state *state)
> > +{
> > +	int rc;
> > +
> > +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE) {
> > +		rc = kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> > +		return rc ? rc : -EAGAIN;  
> 
> What has changed that
> 
> return kvm_s390_inject_program_int()
> 
> is not sufficient any more?
> 
> [...]
> > +	get_regs_rre_ptr(vcpu, &state->reg1, &state->reg2, &state->r1, &state->r2);
> > +
> > +	state->effective = vcpu->run->s.regs.gprs[state->reg2] & PAGE_MASK;  
> 
> *state->r2?
> 
> [...]
> >  static int handle_pfmf(struct kvm_vcpu *vcpu)
> >  {  
> [...]
> > +	if (r1.fsc) {
> > +		end = kvm_s390_logical_to_effective(vcpu, end);
> > +		if (kvm_s390_is_amode_64(vcpu))
> > +			replace_selected_bits(r2, PAGE_MASK, end);
> > +		else
> > +			replace_selected_bits(r2, 0xfffff000, end);  
> 
> Maybe I'm missing something, but I don't get why you need replace_selected_bits
> here.  kvm_s390_logical_to_effective() already does the neccesary masking, no?



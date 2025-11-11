Return-Path: <kvm+bounces-62779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 204CCC4EABE
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 16:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CCE414FF5E4
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 14:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E210833F36B;
	Tue, 11 Nov 2025 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AEMbLfwF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7E32F8BEE;
	Tue, 11 Nov 2025 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762872966; cv=none; b=IEs5si17ckDJMAy/W+79bokvQPtQAN7WfT5U0yixrlFe6JjPeteD/lAXdeOcPAWs8m/5z8mj/76tUGvabOitvVX+UoEqNUOEPq+H4CDQB7C/uACqxiBQIVLqntUyo4gTJfOsyFWccYWfZPaH9DK+xa0j9XEvpRnfexblM9YJcOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762872966; c=relaxed/simple;
	bh=LTT/0NPqS0sd4jdmmJOjs5sWGJbex4ok7eM/QnEBPm8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QZmRTtv5fbHO5VOOQXhL5q5ituwrl43K7LIUh4d72OmsO8SI5Zr+Ch8JSdBjoGkyA0LtM8JKePF1RuKL7hHZBKnmBwjRpuL26yrx3xBgLXaAaaSTppnNO0jf2j2MSbXsSINgcluNvHNHn+FZG06YEAvoQq8QrhlfBrGjYRSaWlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AEMbLfwF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB0jdDR007844;
	Tue, 11 Nov 2025 14:55:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ZOUBzZ
	/zue2HpO0jbUI2PCUQ/xL3dJFVxLSxHcsxPE0=; b=AEMbLfwFjn7JO4aczDym0W
	OWt1eiS6ahC7YpMtNB3Em1DoQsquMWCebT1OtAxEpl+HWCen9qf1q/R7FKHwzj5o
	+moSn+igvDEED0o9Dp3gvCe3UZ/fthViC7fOvJSVxE7+Zd4BTf7GedLsqP6XvDS2
	X1ktx+9pVun/+Koqmn95hAQ4Hto46aLue1YVoEU0nsjQwQFq2eDE2wVAb4C01Ca7
	P/orNTR8DRT+Xrazsipu+wnNraAFtp9rrT/7eTdqaDPem7Nq6ZeemsN889GEYULD
	Rnwtb7hec/Mk0BPoKUqy9j6T7O0djrjFO7Ka5PRoSQfkJLY92fuSBoi+I/bkqVNg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjudnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 14:55:47 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABDwcjY028978;
	Tue, 11 Nov 2025 14:55:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aag6sbedk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 14:55:46 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ABEthH627132666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 14:55:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47B8020043;
	Tue, 11 Nov 2025 14:55:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA3AE20040;
	Tue, 11 Nov 2025 14:55:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.155.209.42])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 14:55:42 +0000 (GMT)
Date: Tue, 11 Nov 2025 15:55:40 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        "Heiko Carstens"
 <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander
 Gordeev" <agordeev@linux.ibm.com>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Nico
 Boehr" <nrb@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Sven
 Schnelle" <svens@linux.ibm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>, "Shuah Khan" <shuah@kernel.org>
Subject: Re: [PATCH RFC v2 01/11] KVM: s390: Add SCAO read and write helpers
Message-ID: <20251111155540.1627fd3b@p-imbrenda>
In-Reply-To: <DE5XX691NDPL.23EQ56H2AP7CK@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
	<20251110-vsieie-v2-1-9e53a3618c8c@linux.ibm.com>
	<20251111144511.64450b0e@p-imbrenda>
	<DE5XX691NDPL.23EQ56H2AP7CK@linux.ibm.com>
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
X-Proofpoint-GUID: LK7ly1b2Pi04HnbOivibfpC4h65SxMQ2
X-Proofpoint-ORIG-GUID: LK7ly1b2Pi04HnbOivibfpC4h65SxMQ2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5OSBTYWx0ZWRfX28DFpqzqdDzl
 Y34w6vtAWVwHidag442czxFbDPm4RNpapTuMHIiCSLtrCvETlUNuAlQMy97od42kVAasY65XaND
 fsvdiu/qJ2ivWhAU3J0c338mGOWPwzS+kLXXGpeY4ViDQnFirvVjMdrDiTs3surDFFtn3FgedcV
 kZdjowssDc7em04xnd0dXPPLnOpH1l+chsMGkLUQFQjZqO2kQogZiohkIrK2ibiwiCB06MiC2tp
 3QvqBozJOF+nN4WHpFeJLObpIE0eQMtdyt7M1WDMdrB7tR0wpWMgO4s01IttG1rJvNnyOEoXSBm
 LNNGVb12+4LhQvyVmOvVwKzDH/rxzoM1YCCH+WaRm1tWQQPmOvv8kD2rRujE1U0zbRpRXDL9nlk
 f/2oLT9dCd5EgZ6Z8ULvaw6RFpY1RA==
X-Authority-Analysis: v=2.4 cv=V6xwEOni c=1 sm=1 tr=0 ts=69134e73 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=rKy7gxD54zyUxROypZIA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_02,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080099

On Tue, 11 Nov 2025 15:37:44 +0100
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> On Tue Nov 11, 2025 at 2:45 PM CET, Claudio Imbrenda wrote:
> > On Mon, 10 Nov 2025 18:16:41 +0100
> > Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:
> >  
> >> Introduce some small helper functions to get and set the system control
> >> area origin address from the SIE control block.
> >> 
> >> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> >> ---
> >>  arch/s390/kvm/vsie.c | 29 +++++++++++++++++++++--------
> >>  1 file changed, 21 insertions(+), 8 deletions(-)
> >> 
> >> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> >> index 347268f89f2f186bea623a3adff7376cabc305b2..ced2ca4ce5b584403d900ed11cb064919feda8e9 100644
> >> --- a/arch/s390/kvm/vsie.c
> >> +++ b/arch/s390/kvm/vsie.c
> >> @@ -123,6 +123,23 @@ static int prefix_is_mapped(struct vsie_page *vsie_page)
> >>  	return !(atomic_read(&vsie_page->scb_s.prog20) & PROG_REQUEST);
> >>  }
> >>  
> >> +static gpa_t read_scao(struct kvm *kvm, struct kvm_s390_sie_block *scb)
> >> +{
> >> +	gpa_t sca;  
> >
> > is it, though?
> >  
> >> +
> >> +	sca = READ_ONCE(scb->scaol) & ~0xfUL;
> >> +	if (test_kvm_cpu_feat(kvm, KVM_S390_VM_CPU_FEAT_64BSCAO))
> >> +		sca |= (u64)READ_ONCE(scb->scaoh) << 32;  
> >
> > this feels more like an hpa_t, which is what you also use in the
> > function below
> >  
> 
> It actually can be either. Without vsie sigp this is a gpa for reading and
> writing. With vsie sigp this is a gpa when reading and a hpa when writing

this is a little confusing, maybe add an explanation

> it. It might be best to not imply anything here but just use "unsigned long"
> for these functions.

yes

> 
> >> +
> >> +	return sca;
> >> +}
> >> +
> >> +static void write_scao(struct kvm_s390_sie_block *scb, hpa_t hpa)
> >> +{
> >> +	scb->scaoh = (u32)((u64)hpa >> 32);
> >> +	scb->scaol = (u32)(u64)hpa;
> >> +}
> >> +
> >>  /* copy the updated intervention request bits into the shadow scb */
> >>  static void update_intervention_requests(struct vsie_page *vsie_page)
> >>  {
> >> @@ -714,12 +731,11 @@ static void unpin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
> >>  	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> >>  	hpa_t hpa;
> >>  
> >> -	hpa = (u64) scb_s->scaoh << 32 | scb_s->scaol;
> >> +	hpa = read_scao(vcpu->kvm, scb_s);
> >>  	if (hpa) {
> >>  		unpin_guest_page(vcpu->kvm, vsie_page->sca_gpa, hpa);
> >>  		vsie_page->sca_gpa = 0;
> >> -		scb_s->scaol = 0;
> >> -		scb_s->scaoh = 0;
> >> +		write_scao(scb_s, 0);
> >>  	}
> >>  
> >>  	hpa = scb_s->itdba;
> >> @@ -773,9 +789,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
> >>  	gpa_t gpa;
> >>  	int rc = 0;
> >>  
> >> -	gpa = READ_ONCE(scb_o->scaol) & ~0xfUL;
> >> -	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_64BSCAO))
> >> -		gpa |= (u64) READ_ONCE(scb_o->scaoh) << 32;
> >> +	gpa = read_scao(vcpu->kvm, scb_o);
> >>  	if (gpa) {
> >>  		if (gpa < 2 * PAGE_SIZE)
> >>  			rc = set_validity_icpt(scb_s, 0x0038U);
> >> @@ -792,8 +806,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
> >>  		if (rc)
> >>  			goto unpin;
> >>  		vsie_page->sca_gpa = gpa;
> >> -		scb_s->scaoh = (u32)((u64)hpa >> 32);
> >> -		scb_s->scaol = (u32)(u64)hpa;
> >> +		write_scao(scb_s, hpa);
> >>  	}
> >>  
> >>  	gpa = READ_ONCE(scb_o->itdba) & ~0xffUL;
> >>   
> 



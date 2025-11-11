Return-Path: <kvm+bounces-62769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7498BC4E3AF
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 14:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5CF01899127
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 13:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A32342518;
	Tue, 11 Nov 2025 13:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DpAznAyJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF5833ADB3;
	Tue, 11 Nov 2025 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762868726; cv=none; b=E9dnEnZEmyfCLJ8hrMVliFjp0L/NlHMfu82dEKJlZmVGI9nQFBGZ1bB6SrUX3U+eyl4QQ8C9fDZtcGYM4AjuTCBaICblkLxZcvYkfdfw8ibKEpLhoF0jS2+NU0oqEOQu1SbQ0dG1KCFBLm89B5Zf5lzP+gGB9sF964IxmIjdXPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762868726; c=relaxed/simple;
	bh=C08hWFigwqknDbciKqoz7hMHLiQiOVVVeFpPtFF0760=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UEM9XRLRvSAyqOatEr+jOqaQBNTNrBMnH9I8zkmrY77gTNV491+TWBFL+IFvgUuw6pZPXHFQrzqAcQ7V9Umc9PlrVbuH4y1+lG87KSlRdP/H5jqsS42NtaoCxwub0RR2zQDrCr3AzB82qMkpLhD/CR2+eqb2P4sS/ohbIFpqEss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DpAznAyJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB4jPXX016114;
	Tue, 11 Nov 2025 13:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RrBhdE
	OOggXqGtQvDP41SSWLMACQ3fZpy2dkyKCbeIk=; b=DpAznAyJ08SAZpB7U12Cfr
	vEac+GfHZ6n0ehX8cV6nZH2ad1jLrcrfZD0aJ29yP1HMDnJH3sh+ZiPszYL+7UTQ
	gdJQ5ZH/BR8A4FFPo0Em49/lkmDm7nucxjACea833kpDR70176a6V7A/T/BzORO/
	Fa2leeGie99ZyLgnsQm0gnP87F7t0L2fbaeyJtCjjezSGAuICobUuva7304yzjCt
	tqjkgGhHmtNScKr2hFu1WmtH/UbamiCS8s5ktnxjIA1iJ2TRUFbrRr4puxajrBep
	nkgub3X8wJvTyshyNiE2/jRX4mYiDijg5hseNtH6Uww8Bx+rN9Lfw+12iB+6hrZA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wc75dvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 13:45:18 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABDaW1U008197;
	Tue, 11 Nov 2025 13:45:17 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aah6mtyj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 13:45:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ABDjDla51708280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 13:45:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 655EA20043;
	Tue, 11 Nov 2025 13:45:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06B4A2004B;
	Tue, 11 Nov 2025 13:45:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.155.209.42])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 13:45:12 +0000 (GMT)
Date: Tue, 11 Nov 2025 14:45:11 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, Nico
 Boehr <nrb@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven
 Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah
 Khan <shuah@kernel.org>
Subject: Re: [PATCH RFC v2 01/11] KVM: s390: Add SCAO read and write helpers
Message-ID: <20251111144511.64450b0e@p-imbrenda>
In-Reply-To: <20251110-vsieie-v2-1-9e53a3618c8c@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
	<20251110-vsieie-v2-1-9e53a3618c8c@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAxOCBTYWx0ZWRfX/a/vi2i2DEsr
 i4X8kbHIzqHwIk9wvsy3pKJpVhBwqI6UwssCge2pZFW3GRKNFqU0ZevBRmIuYwuvhyhIZG2WS60
 aXZLpqzW5K3kp+PtmXfk2z43M5v2+CtZq8D35IXzQUiBtSxX0OFfB4GQDrTpbWnZ4/J8fm4GM7p
 4mLR1h8ZqmRJVdGQ5o1nEGxNJnIaY78AnuiUZF3eoYLH6hBweogiLbixWlHYuBJKCq0F4ke8Tjh
 VzcSkNkQY4ku9WAta+Xbh38g/tmsscJtwJD/I7P1GYvMEU14opF6BLQZXCzs/meuTRkEMEHXGpo
 hnJ2l2PgvmSXYSiiiQgqN6PsbmBH6AWtE6po6GLhbtRt1VO5c/w9/4V3KjrWlaZP5UhJejwfY60
 S8OHasVYec8OJVgGJ7bvC7iMSv0Drw==
X-Authority-Analysis: v=2.4 cv=GcEaXAXL c=1 sm=1 tr=0 ts=69133dee cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=goJE61OIXzkwVcQuzR8A:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 7_ZRHRyHQthdZ8NMxX4IvtPGK6GQn9D2
X-Proofpoint-ORIG-GUID: 7_ZRHRyHQthdZ8NMxX4IvtPGK6GQn9D2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_02,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080018

On Mon, 10 Nov 2025 18:16:41 +0100
Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:

> Introduce some small helper functions to get and set the system control
> area origin address from the SIE control block.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>  arch/s390/kvm/vsie.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 347268f89f2f186bea623a3adff7376cabc305b2..ced2ca4ce5b584403d900ed11cb064919feda8e9 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -123,6 +123,23 @@ static int prefix_is_mapped(struct vsie_page *vsie_page)
>  	return !(atomic_read(&vsie_page->scb_s.prog20) & PROG_REQUEST);
>  }
>  
> +static gpa_t read_scao(struct kvm *kvm, struct kvm_s390_sie_block *scb)
> +{
> +	gpa_t sca;

is it, though?

> +
> +	sca = READ_ONCE(scb->scaol) & ~0xfUL;
> +	if (test_kvm_cpu_feat(kvm, KVM_S390_VM_CPU_FEAT_64BSCAO))
> +		sca |= (u64)READ_ONCE(scb->scaoh) << 32;

this feels more like an hpa_t, which is what you also use in the
function below

> +
> +	return sca;
> +}
> +
> +static void write_scao(struct kvm_s390_sie_block *scb, hpa_t hpa)
> +{
> +	scb->scaoh = (u32)((u64)hpa >> 32);
> +	scb->scaol = (u32)(u64)hpa;
> +}
> +
>  /* copy the updated intervention request bits into the shadow scb */
>  static void update_intervention_requests(struct vsie_page *vsie_page)
>  {
> @@ -714,12 +731,11 @@ static void unpin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
>  	hpa_t hpa;
>  
> -	hpa = (u64) scb_s->scaoh << 32 | scb_s->scaol;
> +	hpa = read_scao(vcpu->kvm, scb_s);
>  	if (hpa) {
>  		unpin_guest_page(vcpu->kvm, vsie_page->sca_gpa, hpa);
>  		vsie_page->sca_gpa = 0;
> -		scb_s->scaol = 0;
> -		scb_s->scaoh = 0;
> +		write_scao(scb_s, 0);
>  	}
>  
>  	hpa = scb_s->itdba;
> @@ -773,9 +789,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  	gpa_t gpa;
>  	int rc = 0;
>  
> -	gpa = READ_ONCE(scb_o->scaol) & ~0xfUL;
> -	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_64BSCAO))
> -		gpa |= (u64) READ_ONCE(scb_o->scaoh) << 32;
> +	gpa = read_scao(vcpu->kvm, scb_o);
>  	if (gpa) {
>  		if (gpa < 2 * PAGE_SIZE)
>  			rc = set_validity_icpt(scb_s, 0x0038U);
> @@ -792,8 +806,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  		if (rc)
>  			goto unpin;
>  		vsie_page->sca_gpa = gpa;
> -		scb_s->scaoh = (u32)((u64)hpa >> 32);
> -		scb_s->scaol = (u32)(u64)hpa;
> +		write_scao(scb_s, hpa);
>  	}
>  
>  	gpa = READ_ONCE(scb_o->itdba) & ~0xffUL;
> 



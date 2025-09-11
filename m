Return-Path: <kvm+bounces-57289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0135B52C04
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 10:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6604B169B30
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 08:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBAC82E54D3;
	Thu, 11 Sep 2025 08:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W3lbLW4I"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EE723372C;
	Thu, 11 Sep 2025 08:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757580219; cv=none; b=aY3O1O9X9w19ieTFvjVsc597RxKO2pAIvTkc4F3iMYeuzfrKvJPBNiymxCDWmC/MdRAIQ+PZc4/C9FISy0ZXGX5M391Egs0AQWPd/JBWYAVUkFO0CUHR7SQp38VWkbhUVZvIohvsYoTw/chOAJR1MS6jcZCBxLmSuUQkM0kqoaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757580219; c=relaxed/simple;
	bh=3GRc9jvP+3LaBrQmCCeebghxOwlIrqeZzJhwQ4kNXKg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DIj35NKYDkbh15iAZfZgqnx13rt8ogLlaQEgVO5Wos0I6VwnE+zIAbSiwBqMHmA3R/Tf85zJFNXOZ95494bZtY1IEws0C0go03ZxYdMJ5GR7eBKfWGmrawQ2r4P9k2jC8CF95PaQI71GQb8xB/gbiAevZ/1LsAapneEYGSK1rEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W3lbLW4I; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B1QpxW031181;
	Thu, 11 Sep 2025 08:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8s/k3L
	Iw171dZJ0pKzBMwOuFf/07xtQVwY2dYIDjyiY=; b=W3lbLW4IqbdU/YBzWhqiOB
	xY4Is8meAbAVBfhUmcAbexZMSk6gIW0PdptjpO/11ZewDw6ZbQSUdznmykO6aw5G
	LRG8RlU5f3MUIrtMpgMaltZnx6U7sqP+KQ1R+4scsz71z0RJxyECE8PkQifRXfri
	8aauBlsnqhb14fEsHVpyhv+TiRuf2uvKAx+FZUXdd+a08jwL7Wi4P4J90VLCXM7d
	q5O3Ghgzcsu22IB9dDZ837m5kcRzi7u0QIs0omligX0EI/M/YxF+01yVhzGmNhes
	1LzVaCAYB6n1ZoL4QID+7Aq5ziAXjTizEepb+utAC+jtHk1XQ7sP1cr28d4iTc6g
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acrax64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 08:43:35 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58B5DUqv020700;
	Thu, 11 Sep 2025 08:43:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp151sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 08:43:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58B8hUfd28508422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:43:30 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9694F2004B;
	Thu, 11 Sep 2025 08:43:30 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 56EC920043;
	Thu, 11 Sep 2025 08:43:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 08:43:30 +0000 (GMT)
Date: Thu, 11 Sep 2025 10:43:28 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20250911104328.4e55bb6c@p-imbrenda>
In-Reply-To: <6ad36edb-0403-4700-ae8e-98395c47316e@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-9-imbrenda@linux.ibm.com>
	<6ad36edb-0403-4700-ae8e-98395c47316e@linux.ibm.com>
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
X-Proofpoint-GUID: MFy-GPq1UktEVOlswAFRgXN5guNOt7Vl
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68c28bb7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=-i2r7IgIFX5naYWykLYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: MFy-GPq1UktEVOlswAFRgXN5guNOt7Vl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfX/7Qnr+F2GWJU
 DfG77lvmZxDDCGEIPB6FHeTtu3ry5aDUsBHZqQ9RD32dcTxNIoljpbrwkNcgXE3i4Mh6jJztbwQ
 5GALv/IQ1R8TT/LQzE/brTP0ZRg9ZqmUWxMPX/fAXjPCe9K5PO3sGAgm49DDU22xriVov7MmDmU
 mSc3eEc6GWcRU9S4YOQn8CTzIMNMzkR4ll8dzj/MWY8i0ioMy2WKxuyWC5c1mYCxNI3gl4hkesI
 thOqfVMhGeNdEG9D/ToOfFo0+XdjuO47GuxhHrJDBNcmvlf2/Zt/0KPb7XLWjv6tu2KqmI5x4dm
 qKu3DruEoQYyrzQ9hnX/ypcprrne94t70PaIvZWdFBXkisEZ9AHeyF6905rCcZUrEUJy/QvHYOg
 OwDV9lvX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000

On Thu, 11 Sep 2025 10:22:56 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 9/10/25 8:07 PM, Claudio Imbrenda wrote:
> > Add page table management functions to be used for KVM guest (gmap)
> > page tables.
> > 
> > This patch adds the boilerplate and functions for the allocation and
> > deallocation of DAT tables.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> > +void dat_free_level(struct crst_table *table, bool owns_ptes);
> > +struct page_table *dat_alloc_pt(unsigned long pte_bits, unsigned long pgste_bits);
> > +struct crst_table *dat_alloc_crst(unsigned long init);
> > +
> >   static inline struct crst_table *crste_table_start(union crste *crstep)
> >   {
> >   	return (struct crst_table *)ALIGN_DOWN((unsigned long)crstep, _CRST_TABLE_SIZE);
> > diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
> > index 01f9b39e65f5..5bee173db72e 100644
> > --- a/arch/s390/mm/page-states.c
> > +++ b/arch/s390/mm/page-states.c
> > @@ -13,6 +13,7 @@
> >   #include <asm/page.h>
> >   
> >   int __bootdata_preserved(cmma_flag);
> > +EXPORT_SYMBOL(cmma_flag);  
> 
> Why does this need to be exported?
> 

because page-states.h uses it, and we include page-states.h in dat.c



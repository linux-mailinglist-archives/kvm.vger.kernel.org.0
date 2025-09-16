Return-Path: <kvm+bounces-57767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73083B59F35
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 267954639C4
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF0525B1DC;
	Tue, 16 Sep 2025 17:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gV3dk6fS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40E61397;
	Tue, 16 Sep 2025 17:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758043484; cv=none; b=buUm+I263ZaJNdB6MonYJHRaijY4vVEvNckxq8bbLt3lkaS2uSo2ggjSnZL8YDEpSWuWXBWbhQlI/yX9RRcXg6gEKRkXtSpk8oEtgATFDO3mueUR1pLmk+PvijKEXDzyldRJjmHwB/M5P2Auxzl4uttJQQGWNO5/3Yhu7K0DbI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758043484; c=relaxed/simple;
	bh=DXlF19yqPWwmnQABpW2o1sge72Up8kx9RXyRxADmBX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzITJYcVftHx56OrhhwfCO4EBDX4cj7fP7K+fo3oM6wAe/s+B02M5jgwYPpsxb8MmhEMhhBNsvLqz5O3eHGQavVYBWG2c06OE4xg+UiHgIdkf9zMzqepEsO5TL7Z7K0RTwb5Q8ZueexWHCHfmWKAyPAeoitfs8rfZUS05qPGSq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gV3dk6fS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GEW7f3008844;
	Tue, 16 Sep 2025 17:24:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=UG1DbXxcb6iywxOZqXOB5Rl+3KVQ5d
	8FTSyctdehMzc=; b=gV3dk6fSjItKbZ3tVj14rQPTYXsQvZnyGMJfoQEu2yRKwM
	E2dzqXbNNlnxmO1smBN9cpypE+KIu4BMPmcRGSG5dKuLfpSpa4K6F4mYbnj6APd0
	FzHS2xQ6MSp5ILoyFbKCyl+oh5ujA6GQZwiZJSDlWuboa3jwLEmdDbD3+BacZYTS
	sM4o7YF/BO8wpK2RwRwYljyCYeEsiH8rDWPfCzFKLdVN9dVBY5WJB0iSlUn3Vwas
	j6nx8ovzFcebIDIhzYrCMHWBPtn149NcelLGZdcs2rOT2ve4Ay/jbEkIGRCt6mX0
	0iczOMi2Z86R26Pe1EfTWj2VXUd0GAUVdW4KurRQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49509yaxt8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:24:39 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GFaiPf008987;
	Tue, 16 Sep 2025 17:24:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn3csvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:24:38 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GHOZ6Z30606052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 17:24:35 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A14120043;
	Tue, 16 Sep 2025 17:24:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6EC820040;
	Tue, 16 Sep 2025 17:24:34 +0000 (GMT)
Received: from osiris (unknown [9.111.88.139])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Sep 2025 17:24:34 +0000 (GMT)
Date: Tue, 16 Sep 2025 19:24:33 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management functions:
 walks
Message-ID: <20250916172433.27229I76-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-11-imbrenda@linux.ibm.com>
 <20250916162203.27229F62-hca@linux.ibm.com>
 <20250916184852.50ab6a67@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916184852.50ab6a67@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyMCBTYWx0ZWRfX8BiWKVe5lF+F
 wWa4tt9GiH8wc4Qmqq2ANyJcyDmnZkr7qI2Pye90NTc+n28zsXGMLICvYRX6N5MJtFsRiakn950
 8OIskK2t36hIN9XEAvnu7tPUNzhlCwZvlBMvzsIXTEuEsaUUvM3niEEvbUkSMhy6OPU18YYtaz9
 U0zniOIKPwkDCJ7Bh2y+2Lmz3BirIdOlWmopHh7eu0xL/Jys70/sAvNoCX3PXVdPojQtkw3SCsn
 5gclZPXaIdveb0yEmqNxxDCru5grX8pDnegNraAnWqh5JwmxCh1t/phZHbxkA24yCoj8bBzOly2
 CHmyzWfWGWrXUcJVCugM4N9eu6NYQ6WH6xqQuhTai1MxmDOIhOLihZkepygc1jp/8xCNWxDWwAg
 gaqCDvT3
X-Authority-Analysis: v=2.4 cv=OPYn3TaB c=1 sm=1 tr=0 ts=68c99d58 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=seNOHT6dRTjOP93ObqAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: XVE4Aq4VyErvfJcwLH7YDGfhLKXA2pXe
X-Proofpoint-ORIG-GUID: XVE4Aq4VyErvfJcwLH7YDGfhLKXA2pXe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130020

On Tue, Sep 16, 2025 at 06:48:52PM +0200, Claudio Imbrenda wrote:
> On Tue, 16 Sep 2025 18:22:03 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> > > +	table = dereference_asce(asce);
> > > +	if (asce.dt >= ASCE_TYPE_REGION1) {
> > > +		*last = table->crstes + pgd_index(gfn_to_gpa(gfn));
> > > +		entry = READ_ONCE(**last);
> > > +		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_PGD)))
> > > +			return -EINVAL;  
> > 
> > Since I've seen this all over the place: this looks just wrong to me.
> > 
> > This is mixing some random software definition "LEVEL_PGD" with hardware
> > bits. A "correct" table type compare would compare with TABLE_TYPE_REGION1
> 
> they are defined to be the same for this reason, but I understand what
> you mean, and I can use the TABLE_TYPE_* macros instead

Yes, please.

> 
> > instead. Also using pgd_index() & friends here is semantically wrong.
> 
> how so? in the end all the various p?d_index() macros are just a
> shift-and-mask. I think it's more readable than open coding
> ((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1)) each time?

I'm not saying that this code is incorrect. What I'm complaining about
is that this is mixing hardware and software definitions all over the
place, which at least to me is very confusing. But ok, maybe I'm the
only one.

So e.g. for the above, which operates with a region 1 table entry, I
would expect to see similar code like in gaccess.c. E.g. _something_
like (and most likely incorrect):

	table = dereference_asce(asce);
	if (asce.dt >= ASCE_TYPE_REGION1) {
		union vaddress vaddr = {.addr = gfn_to_gpa(gfn)};

		*last = table->crstes + vaddr.rfx;
		entry = READ_ONCE(**last);
		if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_REGION1))
			return -EINVAL;  

Or in other words, this doesn't mix hw vs sw functions. Anyway, just
my 0.02 cents. If you disagree feel free to keep it.
You have to maintain this :)

Btw.: WARN_ON_ONCE() has a builtin unlikely(), please don't add
unlikely again like above:

		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_PGD)))


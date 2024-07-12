Return-Path: <kvm+bounces-21501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8AA92F887
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 11:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A47D1C21B67
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6317114E2FB;
	Fri, 12 Jul 2024 09:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nd4jBBVo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9C514A4C8;
	Fri, 12 Jul 2024 09:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720778230; cv=none; b=V5liQVJgxmGSqd6DmHa7PyDRNL5NP+UgzaDD0ODK7bKALlB7JSqCN5Gy3w4Z/N5+qFntGsbFnxwlytwJvicMI9t9cZIgQEl61wWiC/tbYTDlG20caon1zt1+uY5TTmw3pgHBZdSPRO5ZfBPyigqH9Pv7Gdd/MVIt++vDW9eXM3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720778230; c=relaxed/simple;
	bh=rH7XTWNBVx9uT0v2ToJ9aKL+KvZySt6Z7DRcAQJD3q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M2rQACnRlLNByPqOcMxpPuC1M+RxeUZOZ9NZmO06r7aSwzTA7kOEjEXsQTON5rhPrOdYsZ3K0IzLuD86BijpdvETVLTib7f08zIYuLVsJ1wasgXGR4xmM5LiCLGy/s89tqALeFbxpz1AcbET1uT5UfH1ETlFETYdS/S+balVoTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nd4jBBVo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46C9uPUF015454;
	Fri, 12 Jul 2024 09:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=8Ub+xdwRVm2EAFCB3TnQHqPjfgR
	F16MhXQozA0EmiWk=; b=nd4jBBVo1C4cpWcH5HDAgiJw/tH7qq68astWI2i88RL
	/LIODhbfZXePRZMtKf37ZUHnG5H25+VpHYq3iGYmZ8TrDnel6Wn7UNB5G/wJIVJd
	KzBjMAkXaLrfgJuVGNES3qHPGS3MS6x6mqwzv97K501OZIPameK8PT8e9vqi6/QH
	2HJs7vpCBQT2V5g1Hilx4/r3oN6QWGeYYoJbFjMqfJzd9k6WGQ+dEs5vj9pYDD8u
	dnFHLHkXVtnUv6eGaQ+xNQWt2r8h+pJlHqeV6nvNUSGumT4KTudQOzS5qYJORYmj
	57B6Txwro4fKTshZJahXa7rzm3e/18PL8PM2TRnR7TQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40b0jhr8hd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jul 2024 09:57:05 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46C9v57o016250;
	Fri, 12 Jul 2024 09:57:05 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40b0jhr8ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jul 2024 09:57:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46C7unPa006913;
	Fri, 12 Jul 2024 09:57:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 407jfmwkj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jul 2024 09:57:04 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46C9uwVr30147144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jul 2024 09:57:00 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A6502004E;
	Fri, 12 Jul 2024 09:56:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D33C82004B;
	Fri, 12 Jul 2024 09:56:57 +0000 (GMT)
Received: from osiris (unknown [9.179.9.128])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 12 Jul 2024 09:56:57 +0000 (GMT)
Date: Fri, 12 Jul 2024 11:56:56 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, svens@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com
Subject: Re: [PATCH v1 2/2] s390/kvm: Move bitfields for dat tables
Message-ID: <20240712095656.9604-A-hca@linux.ibm.com>
References: <20240703155900.103783-1-imbrenda@linux.ibm.com>
 <20240703155900.103783-3-imbrenda@linux.ibm.com>
 <Zo/3RzpS2WNssMIi@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20240711182348.21ca02b2@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711182348.21ca02b2@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: z1H-ebnaPuBZccDmSX2GZOrEMYbnB-DH
X-Proofpoint-GUID: 3v-E6h2FLfE0QQXJaElrCjnTwU43Qrkm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-12_07,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 adultscore=0 impostorscore=0 mlxlogscore=675 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407120070

On Thu, Jul 11, 2024 at 06:23:48PM +0200, Claudio Imbrenda wrote:
> On Thu, 11 Jul 2024 17:16:23 +0200
> Alexander Gordeev <agordeev@linux.ibm.com> wrote:
> > Hi Claudio,
> > 
> > > Once in a separate header, the structs become available everywhere. One
> > > possible usecase is to merge them in the s390 
> > > definitions, which is left as an exercise for the reader.  
> > 
> > Is my understanding correct that you potentially see page_table_entry::val /
> > region?_table_entry.*::val / segment_table_entry.* merged with pte_t::pte /
> > p?d_t::p?d?
> 
> that depends on how you want to do the merge
> 
> you could do:
> 
> typedef union {
> 	unsigned long pte;
> 	union page_table_entry hw;
> 	union page_table_entry_softbits sw;
> } pte_t;
> 
> then you would have pte_t::pte and pte_t::hw::val; unfortunately it's
> not possible to anonymously merge a named type.. 
> 
> this would be great but can't be done*:
> 
> typedef union {
> 	unsigned long pte;
> 	union page_table_entry;
> } pte_t;
> 
> [*] gcc actually supports it with an additional feature switch, but
> it's not standard C and I seriously doubt we should even think about
> doing it
> 
> another possibility is a plain
> 
> typedef union page_table_entry pte_t;
> 
> and then fix pte_val() and similar, but then you won't have the
> softbits.
> 
> 
> in the end, it's up to you how you want to merge them. I will
> have my own unions that I will use only inside KVM, that's enough for
> me.

We discussed this, and I really don't think we want this for the software
defined bits. In general I do like the idea of having bit fields and let
gcc do the decoding. But we have so many masks we use every for ptes and
friends that a single assignment won't work in most cases. So we eiter have
to do several assignments (which sometimes is a no-go when block concurrent
updates are required), or we have to stay with using both the existing
defines plus the new unions - which makes things even more complicated.

There might be uses cases where the hardware structures are also useful for
s390 core code, but I don't think we should go the route outlined above.


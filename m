Return-Path: <kvm+bounces-21429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 720FF92ECB3
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 18:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93DBE1C21B51
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 16:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3586316D4D4;
	Thu, 11 Jul 2024 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VXTvs2Fe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5666F16CD12;
	Thu, 11 Jul 2024 16:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720715292; cv=none; b=VUoTCLSSfcEFMHkyObhmjr2JxQ1qmFgfZZiQwUIFSzWX7VAnKbamSqk+KNiS3aFSVAqM0diNXbOFB8Zm9l3n9NdEA++yn1Y+CeqBZkxBxrrts+ymHG9BA0hdxBa29U06zOMVak7kx8Odk6KFkuanDIQAaXdDsrkqfkYJD2llMCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720715292; c=relaxed/simple;
	bh=yU45aZilw8uuoyyBEqzLvjn+ubl8VV3DgDQLNw3YG28=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zs2r+6GOWKNCM3KEGItf9e1P2jmYTcUxZCpE4Cfm30kdGCYacVgBWKPlLXMgi8wbFq1xJV1M6MU6M23FoZo5/Gss54+HOS78e+8ZKG+udY51zBV9Xfz/+aQK+BNVg4puhwRvVaZGvoYWNFnz9cLJJFzPM9whUWTameZgUb5Qbf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VXTvs2Fe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BEwJEf020574;
	Thu, 11 Jul 2024 16:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	ufQoE7Ty/3mWJ+0Zwk5edHESJga+H590Q3CcBxzoQ2Q=; b=VXTvs2FeKrP8/zPj
	CCyb+hYFA5e4n9zJcqE829cYrdOBRGo3JOIuEGIyskkBXB8RW90rpvLK4B+ToSKs
	Th5YlLShCPDVA3T8NyyU1/SzyRDBLqw8xQ6eTo+T3fZPlB8BQvsYOdPWqBCWdIMZ
	FT9DYMYDW3VruHqBYwqgre40jTlqPpf8s6VkHdO0Z0yMl1IfExXk8v0A5C9F7WJi
	hlHx78J3Muz1Caq9n0oPTRAIJCBsaPyUVke+FYOowizoU31+075Siy2Lw42uTWaU
	gXy9FXaduOtMmrBH/8H5ZZaB+5PEC5S/VPWaC/y/U0iZkQfp2WJOFNIhkpCNYV+T
	sqBZdA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ahmg090h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 16:28:08 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46BGS81Q000348;
	Thu, 11 Jul 2024 16:28:08 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ahmg08ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 16:28:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46BG1LV5014101;
	Thu, 11 Jul 2024 16:23:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 407h8q1s30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 16:23:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46BGNotf58655138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 16:23:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 979332004D;
	Thu, 11 Jul 2024 16:23:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55BD620040;
	Thu, 11 Jul 2024 16:23:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jul 2024 16:23:50 +0000 (GMT)
Date: Thu, 11 Jul 2024 18:23:48 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, svens@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com
Subject: Re: [PATCH v1 2/2] s390/kvm: Move bitfields for dat tables
Message-ID: <20240711182348.21ca02b2@p-imbrenda>
In-Reply-To: <Zo/3RzpS2WNssMIi@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240703155900.103783-1-imbrenda@linux.ibm.com>
	<20240703155900.103783-3-imbrenda@linux.ibm.com>
	<Zo/3RzpS2WNssMIi@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bJ05gT0dL5CUBYGVd-UwsmMf1XGmGaM1
X-Proofpoint-ORIG-GUID: ydhzCz_K1SRAxstt5eY2sc-YxVkf_ovY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_12,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 mlxlogscore=875 priorityscore=1501
 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407110114

On Thu, 11 Jul 2024 17:16:23 +0200
Alexander Gordeev <agordeev@linux.ibm.com> wrote:

> On Wed, Jul 03, 2024 at 05:59:00PM +0200, Claudio Imbrenda wrote:
> 
> Hi Claudio,
> 
> > Once in a separate header, the structs become available everywhere. One
> > possible usecase is to merge them in the s390 
> > definitions, which is left as an exercise for the reader.  
> 
> Is my understanding correct that you potentially see page_table_entry::val /
> region?_table_entry.*::val / segment_table_entry.* merged with pte_t::pte /
> p?d_t::p?d?
> 
> Thanks!

that depends on how you want to do the merge

you could do:

typedef union {
	unsigned long pte;
	union page_table_entry hw;
	union page_table_entry_softbits sw;
} pte_t;

then you would have pte_t::pte and pte_t::hw::val; unfortunately it's
not possible to anonymously merge a named type.. 

this would be great but can't be done*:

typedef union {
	unsigned long pte;
	union page_table_entry;
} pte_t;

[*] gcc actually supports it with an additional feature switch, but
it's not standard C and I seriously doubt we should even think about
doing it

another possibility is a plain

typedef union page_table_entry pte_t;

and then fix pte_val() and similar, but then you won't have the
softbits.


in the end, it's up to you how you want to merge them. I will
have my own unions that I will use only inside KVM, that's enough for
me.


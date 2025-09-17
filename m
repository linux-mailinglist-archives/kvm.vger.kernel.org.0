Return-Path: <kvm+bounces-57892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9073FB7F694
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDCDD3AEA13
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78563195FD;
	Wed, 17 Sep 2025 13:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TXRwLXpp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7216A233140;
	Wed, 17 Sep 2025 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115913; cv=none; b=uEsm+gIrRixIq7eDLGKj/kmV9AvliDaip9roqCndCqdCpA7TGdT2stzbcKbP6bnHwbZSunHJKoo0CVR6lS44czU2wtJ/r/bKVpaXv9RiLPBYjg8QHA3jAWtwWEW1G04EUUuQQrOmwj/rT31Nf+9i0JwvkCxh4+fIjuGUzCc+Rcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115913; c=relaxed/simple;
	bh=x3gyBBY/qsJIRib19GJ7BHYjDJuLpWk1XVSd/Oi8A7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+lHCRDv/dOXeG/7Am6O3vDc1B79oA+uYk1BjhoWsXp6YozeG6XNAgHU8K84hzwPT+0wQPy8feX9oivvz7YhKJZPnAQKV1qsSfMux1zFsK1x8SZujhd5IXDViYeR2T1YzFhfXiITyMKLsLkvKv+xjzu/CnqhEkKMbxw460KAAZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TXRwLXpp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9gl7B023594;
	Wed, 17 Sep 2025 13:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Sbu7NnZUSKm5yjv89nNUmQ9BtNRTXk
	mT6+ZPxq++Bi8=; b=TXRwLXppIvtqYAy4+VCEcHxo3n1sU5yd9tc7aKaOM+XXxK
	/jAZpCcCRbcVHc53UxV/CPzLkWqztajInnHh3aXlI2j6AaROAsOZS/nzYNiqiwTC
	1jhxUCR0JFa8JtFLH+2ODGasMb34XFmFhTtTwncE8YU0PayUtznMbO8e1MvioM9x
	wVFDzPyDWjVuzoLosb+6MrG5gHNNsuSyG2BUgOJ0KxA67Cf/DYsGzVYCW28xE7Pd
	/Mac7lll4l4A8e166GcQ0Zi0WH0ggq2J2HMBJsrJMUfaPKJ4m/T84xLpAzgvWAsE
	zzyfvt5NUCVyNTvoKNIofMWBRX9TaPhmkxfnxVYA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4qkre7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:31:48 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAZbgK027268;
	Wed, 17 Sep 2025 13:31:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men9c77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:31:48 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HDViku54329670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:31:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CCB620043;
	Wed, 17 Sep 2025 13:31:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B5F620040;
	Wed, 17 Sep 2025 13:31:44 +0000 (GMT)
Received: from osiris (unknown [9.152.212.133])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 13:31:44 +0000 (GMT)
Date: Wed, 17 Sep 2025 15:31:42 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management functions:
 allocation
Message-ID: <20250917133142.29680A26-hca@linux.ibm.com>
References: <20250916162653.27229G04-hca@linux.ibm.com>
 <20250916184737.47224f56@p-imbrenda>
 <63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
 <20250916190514.1a3082bd@p-imbrenda>
 <15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
 <20250916173644.27229Kcc-hca@linux.ibm.com>
 <20250917072733.7515Af5-hca@linux.ibm.com>
 <20250917132556.4814fe98@p-imbrenda>
 <20250917123006.7515C59-hca@linux.ibm.com>
 <20250917151124.1a53b0a6@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917151124.1a53b0a6@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PVpF-bI6Uqmqcx65PZaFU38GY8eoKwlT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX3J7QqzpKio8C
 KRHj9crAxgfXruNye09QIXWODrZNvd74QmSiU+FYsPSTiErAM4NqcICGoKZjHhCvwAr9Z1IAeCd
 4al3UkTe7pzw7QHURAhp85snfj3GHjULqtr7u884xMWLyvzEHBoUguPXR6L4k4aqYwebtVTzRYC
 Zt9WRdFJ0L+88Vmg4ay4KeZS6/chkhtZDwssk1TGA5V+LNoTvwD3AcO2vAeMkrmmPnq2P3jLmoo
 41FjVFE1HIdMlmhJXx0VuJif471HtRIivytpCTyTSLSFHoqhuEYny9/b1A021ey01NbjTINu34z
 CaKZ3cZVo1otsK7g6vAgTD5VCJ3eM+Roaw6ggB4YTzaToGHn+4yJKOtP7TV2Xrh1AgNSbJ6hsOw
 yQMGHrYY
X-Authority-Analysis: v=2.4 cv=R8oDGcRX c=1 sm=1 tr=0 ts=68cab844 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7plvffdV2fzIC-KNDC0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: PVpF-bI6Uqmqcx65PZaFU38GY8eoKwlT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, Sep 17, 2025 at 03:11:24PM +0200, Claudio Imbrenda wrote:
> On Wed, 17 Sep 2025 14:30:06 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> > > > > > No. ATOMIC always means: can fail.   
> > > 
> > > my issue is that GFP_KERNEL can sleep, and this allocation is sometimes
> > > called from atomic contexts (e.g. while holding spinlocks)
> > > 
> > > the right way to do this would be with mempools, to allocate memory
> > > (and potentially sleep) when we are not in atomic context, and use it
> > > whenever needed. this is on my to-do list for the future, but right now
> > > I'd like to avoid having to refactor a ton of code.  
> > 
> > I doubt this is accetable even for an intermediate solution. As soon
> > as the host is under memory pressure and starts doing I/O to free up
> > memory, you will end up in -ENOMEM situations for simple guest page
> > allocations.
> > 
> > What happens with a guest in such a situation? Is this gracefully
> > handled without that the guest is terminated?
> 
> well, we return -ENOMEM to userspace (and qemu will probably kill the
> guest)
> 
> but if we can't even allocate 16kB, probably we're already in a pretty
> bad situation

Not necessarily...

> if you think this is not acceptable, I guess I'll have to implement
> mempools

...since the kernel _might_ be easily capable of freeing memory, e.g. by
writing to swap or writing file contents to disk. But this wouldn't happen
with GFP_ATOMIC allocations.

I'm just stating that with GFP_ATOMIC for guest page table allocations it is
much more likely that guests might be killed compared to what we have now.

Also I'm wondering why such code paths where page tables in atomic context
need to be allocated even exist. Is that s390 specific (aka the new code), or
is this due to common code requirements?


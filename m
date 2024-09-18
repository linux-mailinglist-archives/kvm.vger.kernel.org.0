Return-Path: <kvm+bounces-27069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A6B97BB2C
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 12:58:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 808D0B21BA0
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 10:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A782A183CDE;
	Wed, 18 Sep 2024 10:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XBM4siWa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C797381D5;
	Wed, 18 Sep 2024 10:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726657097; cv=none; b=p2eNEPGFFNZj7k2yl0QSMcwVnn4w5tCqwVTtHaAOQNvFSXMvTiS/ZWXewFtouF+VNQS4VKHmSGRrObnwoSQAG0/5EYI3JZrB//pv8iatJVHNhePjwLPp7K8uKw5BuGOQf7CT2skd+10lEPqeVS2Udw+rlRQsgXuCHdyU5jvkJ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726657097; c=relaxed/simple;
	bh=31Yqfc96Kwmb4Zv3GI1bzHl73m80mXFJXQu6DDhpvys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLFvgZkdrha6P4xUWsSl7T89CB0ErT2h7n0qw2j4yqC58hXEsXO37j3OBW4pOrNOAYbrp8O3+AlfbgRBDRQvgKHrBKJLAme92KKjdlyM4nuP+5Es6rTbbCff/m9E34ZWA8/fWK+qw/QBTVEKo2ZHXdy7WX7NXReUCFMo5IOQHrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XBM4siWa; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48I9O08D031821;
	Wed, 18 Sep 2024 10:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=UKpjdqTlzkAJNuludSllQjJTRen
	ZBzB1GmHuh4gwGRA=; b=XBM4siWayRAiE82E5+BdUemTuvaqUA21mxIm9rQNyKg
	7YY7a5aExicDPi923D5p54b/ZX3a2IAnFkOBoOfxomyYeMVDmyhkf5mOeYtQbUzz
	rLI9/d7kmJ1bvvRl9DlDfkibhofPwTQUW7vYakz6cNsUaSH81kOUIqdC+hyjrEeH
	ATr1gw+vVRwjZ4c23pnm78cmb8Tzqwu1sRUtR+5go8TmyCCwVyeeIdOGwnIkNMXN
	LpgXIpo9YLfE51D3k9EqpjK1WwHl9Ko3GuiHsFYmOx7aNpAMMsUDsKp+/nFPq57r
	AEKrawPrUyoyK+z0AdCjVB/zrYumb3wLQ0DOSWmDNhg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3ujdcuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 10:58:14 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48IAwDC5023047;
	Wed, 18 Sep 2024 10:58:13 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3ujdcug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 10:58:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48I98tRE001960;
	Wed, 18 Sep 2024 10:58:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nmtutt69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Sep 2024 10:58:12 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48IAw9BY44106204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Sep 2024 10:58:09 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7252020043;
	Wed, 18 Sep 2024 10:58:09 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51ED520040;
	Wed, 18 Sep 2024 10:58:09 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Sep 2024 10:58:09 +0000 (GMT)
Date: Wed, 18 Sep 2024 12:58:07 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 2/2] KVM: s390: Change virtual to physical address
 access in diag 0x258 handler
Message-ID: <20240918105807.6794-C-hca@linux.ibm.com>
References: <20240917151904.74314-1-nrb@linux.ibm.com>
 <20240917151904.74314-3-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917151904.74314-3-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3qXRF2aNPcfRFuRlz04f7Ew8e2rQxMQD
X-Proofpoint-GUID: pM4tG90lCkmlGvqYWAoNg5NnHvJoPmHF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-18_09,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=627 adultscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409180069

On Tue, Sep 17, 2024 at 05:18:34PM +0200, Nico Boehr wrote:
> From: Michael Mueller <mimu@linux.ibm.com>
> 
> The parameters for the diag 0x258 are real addresses, not virtual, but
> KVM was using them as virtual addresses. This only happened to work, since
> the Linux kernel as a guest used to have a 1:1 mapping for physical vs
> virtual addresses.
> 
> Fix KVM so that it correctly uses the addresses as real addresses.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8ae04b8f500b ("KVM: s390: Guest's memory access functions get access registers")
> Suggested-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> [ nrb: drop tested-by tags ]
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This shouldn't be part of the commit message.

> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  arch/s390/kvm/diag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>


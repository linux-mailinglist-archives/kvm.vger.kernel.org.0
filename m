Return-Path: <kvm+bounces-28800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D493C99D65C
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 20:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99ECC283666
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0D61C3054;
	Mon, 14 Oct 2024 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eaNHFEKw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438391FAA;
	Mon, 14 Oct 2024 18:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728930070; cv=none; b=g5o5/HfxSX3jvuxcCePUIlXutEvamSzawKf922OTmI03SFdmiIUyCY65kfqMpc+oydrn40mTkfSQPZ0xI4U1ZGLFMcQEBUF+ArMGX/uUGqdF2205pTKSvRB0ltRNhsEdWEErs2kvRJkWiyRcbV6V8ukaccizIqa912DIsHn4QBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728930070; c=relaxed/simple;
	bh=Mbpp6GolQUp8+qvADWh7Iwb0btCr36EF3neqagVgQTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NaRMqS1Kc3AFUNcfwSPfc0Ztgj6XpVJuWA0+DjAkFaVGZKwtpSGC8sMBHCFSkDUMkPVAtEP7cualgC3LVu8zzHxTCP87DSeaq07X4BLfqXEeZv40bQLjECaEoSmDVfKDPWs2Ujr64AJGgjWZXogKVCaSSMhR57D9hteoHpJ6Sj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eaNHFEKw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EHLkwT026660;
	Mon, 14 Oct 2024 18:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=+15fU+vlFJXlfWNo5SAb6q/LxbD
	R71Q4LmaLqoFoAZY=; b=eaNHFEKwAne8T5Hw2RuPNhr4IuZPqpuAd6PDLZfd4W2
	2ua4t2Ns/mhAzdVfGH1rRTanXrr0dHqRIuF0H9ZxSHZOqN1Xfde3r3RZ7en+j556
	bxhS46+2O1W1jb7yuqKmrCOeiVLZqE/C67SoUeO5ljNQN1QvBuCvLr2NrJg2PDiZ
	GBZZI7k6w3VtsDNQWHd9fjaOTVR5bN6Vrnw/S0XnP3IjpKEgCGXFHXUGhibZ65//
	8TuT+jehc8jqB3j+eLVnGmZLr5gxblfETosLAxM6HUAx3irF9x+xv3ODQ4tLz2YT
	xYOpZjaLAgQtQIbJN+RBvkyh4FOfMHPDIcVlqSbmUzg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4297mh07ww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:21:02 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49EIL1KV023177;
	Mon, 14 Oct 2024 18:21:01 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4297mh07ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:21:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49EICqoP006757;
	Mon, 14 Oct 2024 18:21:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284xjyumy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:21:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EIKul654788570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 18:20:56 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B54FD20043;
	Mon, 14 Oct 2024 18:20:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B980620040;
	Mon, 14 Oct 2024 18:20:55 +0000 (GMT)
Received: from osiris (unknown [9.171.66.174])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 18:20:55 +0000 (GMT)
Date: Mon, 14 Oct 2024 20:20:54 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 1/7] s390/kdump: implement is_kdump_kernel()
Message-ID: <20241014182054.10447-D-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-2-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014144622.876731-2-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZNrF-vliafvsXTZlHD8cU1V8rNPhMb3U
X-Proofpoint-GUID: bsGZDluyQp-DsQa9Pp8zZysEnv_dnaq2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_12,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 mlxlogscore=388 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410140128

On Mon, Oct 14, 2024 at 04:46:13PM +0200, David Hildenbrand wrote:
> s390 currently always results in is_kdump_kernel() == false, because
> it sets "elfcorehdr_addr = ELFCORE_ADDR_MAX;" early during setup_arch to
> deactivate the elfcorehdr= kernel parameter.
> 
> Let's follow the powerpc example and implement our own logic.
> 
> This is required for virtio-mem to reliably identify a kdump
> environment to not try hotplugging memory.
> 
> Tested-by: Mario Casquero <mcasquer@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/include/asm/kexec.h | 4 ++++
>  arch/s390/kernel/crash_dump.c | 6 ++++++
>  2 files changed, 10 insertions(+)

Looks like this could work. But the comment in smp.c above
dump_available() needs to be updated.

Are you willing to do that, or should I provide an addon patch?


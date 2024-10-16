Return-Path: <kvm+bounces-28998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 614149A0B95
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 15:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92D6D1C244A0
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 13:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3CE20B1EA;
	Wed, 16 Oct 2024 13:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="maObSdMq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CE0209F3C;
	Wed, 16 Oct 2024 13:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729085770; cv=none; b=r1qxuPZD49wJ8zLcZLC2Vr7C5XhgfLEOPehyq9wKteKlIQnunJ4hgHzm6u0CDkfgrnuQcmwFXWME+62TlOT/gK+ecvMH4wc1EyhEXkvz3oVFf3pk1AHTjihaPfy2h0TTjOURl4Js13q4metHtJzD7HNgHVFhtGCesZT+ce74xyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729085770; c=relaxed/simple;
	bh=pZNXk/x0fFwUjZqS/zBnAfyZnmbaXf4MIWAifLb2V1Q=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:MIME-Version:
	 Content-Type; b=CLXrO7AAsnXOqkgUve6gRR+eAV83ZExLVV4596POyASH13RxfHk3YMl3FRUv4RdnqRteGM8nmPipeyUb0X5ywrHsE/jXutMLqINy3yyJAtYcDkWEhQgn9XJfOqtDfbAldOLTdj8iIJdjUVbVCgbSfTZFUKvGTv58efZQGiFreDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=maObSdMq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GCs3FM021241;
	Wed, 16 Oct 2024 13:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:subject:to; s=pp1; bh=YSX7Qf3np3wpVslux96pU8DtgICF+GNcykXf3D0a9
	jM=; b=maObSdMq9gobBKJPWmzX31K7KNNbmheIkGTgvgDPVg6Hldi4Kj9c9a8Ck
	Hv+TCuBwoQi84r8BWa+oOQRIm+SOGDHcuxhvl7ZJdETh7MqAelw3MZUJAA2et6oI
	Sqsfukr1bnKSHzy6JQi7710rS9hTY50qmVVDley0TPMa4tfPuYhN4x5H+6FXFU7e
	bOeWAZsWWMoUoap8B56ZHGfmhxvJyz96EoGfMHRQekpFngiT836iEsVOpglaehD3
	TEDVDHN4xnpsHci62XNv3YqlzJ5I284nLbV77OXA1stbp43/n6ovRX9ZtU40PGgy
	5htOptCwrb7MI0dUtJTp0is777d+Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42adw8r7m6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 13:36:00 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49GDa0x0027595;
	Wed, 16 Oct 2024 13:36:00 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42adw8r7kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 13:36:00 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GCg5eV006690;
	Wed, 16 Oct 2024 13:35:59 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4283es1ur1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 13:35:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GDZtmt28508670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 13:35:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A4F220043;
	Wed, 16 Oct 2024 13:35:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E81320040;
	Wed, 16 Oct 2024 13:35:55 +0000 (GMT)
Received: from localhost (unknown [9.155.200.179])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 13:35:55 +0000 (GMT)
From: Alexander Egorenkov <egorenar@linux.ibm.com>
To: david@redhat.com
Cc: agordeev@linux.ibm.com, akpm@linux-foundation.org,
        borntraeger@linux.ibm.com, cohuck@redhat.com, corbet@lwn.net,
        egorenar@linux.ibm.com, eperezma@redhat.com, frankja@linux.ibm.com,
        gor@linux.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, mcasquer@redhat.com, mst@redhat.com,
        svens@linux.ibm.com, thuth@redhat.com, virtualization@lists.linux.dev,
        xuanzhuo@linux.alibaba.com, zaslonko@linux.ibm.com
Subject: Re: [PATCH v2 1/7] s390/kdump: implement is_kdump_kernel()
In-Reply-To: <a3f310d0-b878-44c4-9454-f7faf8be04ad@redhat.com>
Date: Wed, 16 Oct 2024 15:35:55 +0200
Message-ID: <87ed4g5fwk.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MZec_mqCiGFqFGIM06wGZZ-9NJht6plF
X-Proofpoint-ORIG-GUID: NI9xYGJknyFiVOPGQDiENcgtrcbdq7fD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 impostorscore=0 adultscore=0
 mlxlogscore=400 mlxscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410160084


Hi David,

> My concern is that we'll now have
>
> bool is_kdump_kernel(void)
> {
>         return oldmem_data.start && !is_ipl_type_dump();
> }
>
> Which matches 3), but if 2) is also called "kdump", then should it actually
> be
>
> bool is_kdump_kernel(void)
> {
>         return oldmem_data.start;
> }
>
> ?
>
> When I wrote that code I was rather convinced that the variant in this patch
> is the right thing to do.

A short explanation about what a stand-alone kdump is.

* First, it's not really a _regular_ kdump activated with kexec-tools and
  executed by Linux itself but a regular stand-alone dump (SCSI) from the
  FW's perspective (one has to use HMC or dumpconf to execute it and not
  with kexec-tools like for the _regular_ kdump).
* One has to reserve crashkernel memory region in the old crashed kernel
  even if it remains unused until the dump starts.
* zipl uses regular kdump kernel and initramfs to create stand-alone
  dumper images and to write them to a dump disk which is used for
  IPLIng the stand-alone dumper.
* The zipl bootloader takes care of transferring the old kernel memory
  saved in HSA by the FW to the crashkernel memory region reserved by the old
  crashed kernel before it enters the dumper. The HSA memory is released
  by the zipl bootloader _before_ the dumper image is entered,
  therefore, we cannot use HSA to read old kernel memory, and instead
  use memory from crashkernel region, just like the regular kdump.
* is_ipl_type_dump() will be true for a stand-alone kdump because we IPL
  the dumper like a regular stand-alone dump (e.g. zfcpdump).
* Summarized, zipl bootloader prepares an environment which is expected by
  the regular kdump for a stand-alone kdump dumper before it is entered.

In my opinion, the correct version of is_kdump_kernel() would be

bool is_kdump_kernel(void)
{
        return oldmem_data.start;
}

because Linux kernel doesn't differentiate between both the regular
and the stand-alone kdump where it matters while performing dumper
operations (e.g. reading saved old kernel memory from crashkernel memory region).

Furthermore, if i'm not mistaken then the purpose of is_kdump_kernel()
is to tell us whether Linux kernel runs in a kdump like environment and not
whether the current mode is identical to the proper and true kdump,
right ? And if stand-alone kdump swims like a duck, quacks like one, then it
is one, regardless how it was started, by kexecing or IPLing
from a disk.

The stand-alone kdump has a very special use case which most users will
never encounter. And usually, one just takes zfcpdump instead which is
more robust and much smaller considering how big kdump initrd can get.
stand-alone kdump dumper images cannot exceed HSA memory limit on a Z machine.

Regards
Alex


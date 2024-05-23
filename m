Return-Path: <kvm+bounces-18055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E304D8CD67C
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66B491F229CF
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 15:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393F5F9E8;
	Thu, 23 May 2024 15:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rrqSkdAU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F020AE546;
	Thu, 23 May 2024 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716476496; cv=none; b=ccW8Gxfm+ujW+OItSr/F9NM/Kh//lJZ+CspskGMfbf5k7yjwyK5n38ydmte35AkOvai6yRmw51XPiXkggxDgn5s/yVPfIRzHiCNn+XjuN+QOzf7ZLO2ZiMq2/aqKE4Rd76khDmYxeEZ42FThMmqHIeHMV2sxX7PyzTH6c1OnfQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716476496; c=relaxed/simple;
	bh=wkED6AAI1mTUx9wt4S4nIAvj2tU4r8qpUh/JuS2SKxw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SGLZjmVq88rUCAKz+utj5TkuKqLICUrF2LeE1eiNvauwhymLP29t72ruekN2WSW2+RteJ+GTlmuFDrA6xqpndBe/MvKbPFX3bto4VJMg5tRRxvpknXqWx5k10CntQD1Cm6qOS9QvmlpB393+uXo98cab2Wbn5b/7gPIg5GMUoww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rrqSkdAU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NEl8gB032763;
	Thu, 23 May 2024 15:01:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=gLIRjj9sWLVN2jhhPk6Y/MSCYmfiF/wDv5ySXL/lN7k=;
 b=rrqSkdAUAfsdmb5ob5M0OzE4xx1bU42KF814BNZopT3cNeUi6FHUB4PCQJ5sPiqTC6mj
 oHfuUbVbljcrzjRTjaSG156Y0+IOw73WFx8dcQQjKRIE6GEGNq7Ljs+5yylV9hGGhjx/
 zu6fa6Emve1+7VvcJTptRSkH78a3il7q+DNTFc4RGRNi/e88J3Et69YsNDXFVy0bopGI
 EqzctvBA8FNCDxX4IijeSWQP8Zi/wbbwTco/6VdPJJ5B8ENycRXyD/XGFZeV6QEdhcpD
 gMKRiHEiMydN9VGETEHidewQxVmJBFyK7FzWHECvktJo31FX3DgIDQYF6bvX3MfWTy3I 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya7v201sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 15:01:30 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44NF1TW4030099;
	Thu, 23 May 2024 15:01:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya7v201sq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 15:01:29 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44NC6G3B008188;
	Thu, 23 May 2024 15:01:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y78vma820-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 15:01:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44NF1NkT57540922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 15:01:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C14E2004D;
	Thu, 23 May 2024 15:01:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D66B420040;
	Thu, 23 May 2024 15:01:22 +0000 (GMT)
Received: from [9.152.224.39] (unknown [9.152.224.39])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 May 2024 15:01:22 +0000 (GMT)
Message-ID: <b1ee705ee3309405273ed1914a4326b9b024edf8.camel@linux.ibm.com>
Subject: Re: [PATCH v4 2/3] vfio/pci: Support 8-byte PCI loads and stores
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Ramesh Thomas <ramesh.thomas@intel.com>,
        Alex Williamson
 <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas
 Schnelle <schnelle@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal
	 <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic
	 <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>, Ben Segal
	 <bpsegal@us.ibm.com>
Date: Thu, 23 May 2024 17:01:18 +0200
In-Reply-To: <2b6e91c2-a799-402f-9354-759fb6a5a271@intel.com>
References: <20240522150651.1999584-1-gbayer@linux.ibm.com>
	 <20240522150651.1999584-3-gbayer@linux.ibm.com>
	 <2b6e91c2-a799-402f-9354-759fb6a5a271@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (3.52.1-1.fc40app1) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -vUdl5qh_tj0nL5hZYlcxM12gdAVknC5
X-Proofpoint-GUID: UMyj4Gb5dJSO92cilkZZYBOLGOBsikKg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_09,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=328 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230103

Hi Ramesh,

On Wed, 2024-05-22 at 16:38 -0700, Ramesh Thomas wrote:
> The removal of the check for iowrite64 and ioread64 causes build
> error because those macros don't get defined anywhere if
> CONFIG_GENERIC_IOMAP is not defined. However, I do think the removal
> of the checks is correct.

Wait, I believe it is the other way around. If your config *is*
specifying CONFIG_GENERIC_IOMAP, lib/iomap.c will provide
implementations for back-to-back 32bit operations to emulate 64bit
accesses - and you have to "select" which of the two types of emulation
(hi/lo or lo/hi order) get mapped onto ioread64(be) or iowrite64(be) by
including linux/io-64-nonatomic-lo-hi.h (or -hi-lo.h).

> It is better to include linux/io-64-nonatomic-lo-hi.h which define
> those macros mapping to generic implementations in lib/iomap.c. If
> the architecture does not implement 64 bit rw functions
> (readq/writeq), then  it does 32 bit back to back. I have sent a
> patch with the change that includes the above header file. Please
> review and include in this patch series if ok.

I did find your patch, thank you. I had a very hard time to find a
kernel config that actually showed the unresolved symbols situation:
Some 64bit MIPS config, that relied on GENERIC_IOMAP. And with your
patch applied, I could compile successfully.
Do you have an easier way steer a kernel config into this dead-end?

> Thanks,
> Ramesh

Frankly, I'd rather not make any assumptions in this rather generic
vfio/pci layer about whether hi-lo or lo-hi is the right order to
emulate a 64bit access when the base architecture does not support
64bit accesses naturally. So, if CONFIG_64BIT is no guarantee that
there's a definitive implementation of ioread64/iowrite64, I'd rather
revert to make the conditional compiles depend on those definitions.

But maybe Alex has an opinion on this, too?

Thanks,
Gerd




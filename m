Return-Path: <kvm+bounces-46673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D29CAB827A
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 11:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9CB37AA472
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 09:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC54297B60;
	Thu, 15 May 2025 09:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xj41abCA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA1D221296;
	Thu, 15 May 2025 09:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747301104; cv=none; b=S7JalAyoTHhr4FeJVeccJah2LexCF6kN44xpnEATMlh6zTNb8DXCNF4gsfrelg8vPLL+48VFjKGNzO89RSzAeOT1+yneggxSxlY6APZ91+6IhRZaQpUFrDKCMlwxtgHYlcxNMulFvHPbe+pbmgOtwOTKyYX5cICjUDCUmfv8zFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747301104; c=relaxed/simple;
	bh=FOB3K3pY+F4jlai+86UarnLpNHKWWIcm3T9iHIOsqi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P1E5fxUgrXTqkSQ60fYKbWkhctE2PCh0Gdag4FD6sIysA6oY/4Ik0p0KsquXsw00FPxqvh2UhmSAg3PTKf+bsRmOPmOk30KGCz66esdazbVairRlSxwkoAD3UmvWbSr+iXQbHZFYroa+/cXI46h9pW7azxdu/vEMLCNcvbi3l6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xj41abCA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54F6OCW7014537;
	Thu, 15 May 2025 09:24:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8h69w0
	8A9QwkYhNAcKreTXG+qKfy8roG1DkTKo/70aI=; b=Xj41abCAvpx3NzcjYZxMR2
	YFtsxFY+S0mBSGzTScOiXZArfp1+WQOXSyL2f9UVAC9FOSJtLGVu6RnTX9/wjaWj
	foXGsaYnb8HYPonZ779p0muRhd8+S24mym0IpmyzXSzENWEJZ6oXzMl/xln8HtN4
	+fpx/TGn1F3wqlX0PyqKCARWW0Lytz/BgCL3bnbMSwSCD3u+putGcfFSDiWBkwGt
	IDwHs9Hq6NwbpRyYEC1fm/ClHw4HdWsks75TZd661KO/y8EuXj2ifnWFF0ytZ4aL
	IIl6atmgXo05o9N7oa6U6cllP7WFxtFIxR6d7E0Jg4W57CblO38lstMSmrMXtjhg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46n0v6kdj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 09:24:46 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54F7F2u5021396;
	Thu, 15 May 2025 09:24:46 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfrscer-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 09:24:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54F9Og7P55771644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 09:24:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F127D2007B;
	Thu, 15 May 2025 09:24:41 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 796392007A;
	Thu, 15 May 2025 09:24:41 +0000 (GMT)
Received: from [9.152.224.40] (unknown [9.152.224.40])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 09:24:41 +0000 (GMT)
Message-ID: <acfad3e9-f4df-481a-8322-141c3579602b@linux.ibm.com>
Date: Thu, 15 May 2025 11:24:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        linux-mm@kvack.org, Yang Shi <yang@os.amperecomputing.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
References: <20250514163530.119582-1-lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20250514163530.119582-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=IqAecK/g c=1 sm=1 tr=0 ts=6825b2df cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=VnNF1IyMAAAA:8
 a=6puILLhiXrOUVKTfem0A:9 a=QEXdDO2ut3YA:10 a=f1lSKsbWiCfrRWj5-Iac:22
X-Proofpoint-ORIG-GUID: yZcsqEheSgMmMrQugs9qS4KVCkbgPcbu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDA4OCBTYWx0ZWRfX9n/zFJb8L9f5 DKjXxvWP7VtulRdOLoorNI1YLivkoVzk0E+QGp5E/ONJ4Irj6yaVyQKsSnpyRwyDcY8BEa5o/IM 6SpGZvKvY/MgEao81ze72+Hwny/ODqBDcy2zzwaqNoIY2MrxYjKG9V2Tj0o7tU1CnaHwpW+u0D9
 1URwvRTeIqxd3UdKEynSKOsB/GFdceDPq0xTaMYAnF/3d31ZcEgbEuMNwERSjnUhWSYPJCCmG/G a01F/feD71JTquMhQbUSNmulT5LPz6AfQMwHPePO4ZveIC7DtRUcx7i1qYhXvFWGspP9tgKTBIB c+vPyIsS0gAr/Ibp70+/ykIbLQyrdRnA6rYUDmCRiO0YawgHOoi0JD+gBV/2BWriX3Y+oTRSOjW
 84IA61t/j5YsxaD/bt11UpeYNgGeRu2RG+mKbI7z5dTcKhOOvos+aBgux5Rqrxmk0GP8TMxP
X-Proofpoint-GUID: yZcsqEheSgMmMrQugs9qS4KVCkbgPcbu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_04,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 mlxlogscore=661 bulkscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150088



Am 14.05.25 um 18:35 schrieb Lorenzo Stoakes:
> The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> unfortunate identifier within it - PROT_NONE.
> 
> This clashes with the protection bit define from the uapi for mmap()
> declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> those casually reading this code would assume this to refer to.
> 
> This means that any changes which subsequently alter headers in any way
> which results in the uapi header being imported here will cause build
> errors.
> 
> Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
I think its fine to go via mm tree.




Return-Path: <kvm+bounces-57840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6582DB7C6D8
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72686325B67
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 11:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E748B30B526;
	Wed, 17 Sep 2025 11:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pq09f4FE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9058303A39;
	Wed, 17 Sep 2025 11:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758108372; cv=none; b=gHP0iEURWJAFxhlkPnGAWI7tUHpMU5lZRB1mj0waWhqbhq5mp62TXrSN/Qd086cgRUDOSvtvU1uru0qD02CDw99jDvLT+qxhSoGcvkXGuRMU/RTHri5eaXkHh69kQTcfJ+2/JIUFghNSPdIKR0IbUh45PABfmzIPqJQyFecyeQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758108372; c=relaxed/simple;
	bh=WCvD0OsGkWaumiIdlpQK41MIMOIVOv9fPTvJusyjnzs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LkS3iLFHIDiSEJtw5+5oFstksrgHS3PTen91RlwbhycrjP+eO+iO+SxNqi5P0zFy1IXRIUqp8nDuqF+BC/1FWKWut/pwTapIFs6U9Muoc9JB39pbqNmK9YkoJWVFN2cChFEhee067HnuBwRv4JIInkk+g2dBRSyhhVICqic1jb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pq09f4FE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAXiFE013993;
	Wed, 17 Sep 2025 11:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=uPc3pa
	8vCCXrWzSinilX7iSQ2YPUIiaAPtk8FLVkFoE=; b=pq09f4FECg3rMlzz24B6oU
	CvXFzhuc2LsBwiFK3yYXysfGvj5cSC/fk/TrioZZkBualxQaUnBOGPRaYjNhGomx
	NvaiZdVRvLM/jhZeNPEO8A2M5w5lYuKaKm0ydpJMl4lku+u4gnS7g1/HWrFSKQcM
	4bRdviM++dMnCRhX26iFcff5qipRZFjUh0wMWxA8DsWjc1H2cgpwVquxwF7Jrny8
	m9Tc2CmntKHEGXIaxJ2MBfDvipfDzAcUyJdvq+/LVPjWUPh0hCKnDvtutalmEyKY
	LJaoleNUF+cSt0R/CqsnKonABnvpOAOLfhXf3d0RPaUTFUoS2jioAs2izkdAbKjg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nb4cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 11:26:07 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9Ph0Z029508;
	Wed, 17 Sep 2025 11:26:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb1148p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 11:26:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HBQ29718743704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 11:26:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FA672004B;
	Wed, 17 Sep 2025 11:26:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5742A20043;
	Wed, 17 Sep 2025 11:26:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 11:26:02 +0000 (GMT)
Date: Wed, 17 Sep 2025 13:25:56 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20250917132556.4814fe98@p-imbrenda>
In-Reply-To: <20250917072733.7515Af5-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-9-imbrenda@linux.ibm.com>
	<20250916162653.27229G04-hca@linux.ibm.com>
	<20250916184737.47224f56@p-imbrenda>
	<63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
	<20250916190514.1a3082bd@p-imbrenda>
	<15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
	<20250916173644.27229Kcc-hca@linux.ibm.com>
	<20250917072733.7515Af5-hca@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68ca9acf cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=KR53WKYN7qGtw4uJpnsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: vhL6doCdWRvU0RwIeodD5ZuN9sLuZr72
X-Proofpoint-ORIG-GUID: vhL6doCdWRvU0RwIeodD5ZuN9sLuZr72
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfXwj0JvIHv67+H
 YYhqPi00IRjGTEg38NaWPlqnVu2cPNfBX6uB9xG4PZ6hbeEcCHzY2G4UzDx+x5hQZritgd4ur/4
 fFB5Hst/6bhewjLxCOsLqvhXA3+KnJSDMgGGpiFPQX4cg42l69B1jlZetD+rWi6MTyo9YRjpYQX
 qXxoK8cXl+yt3z4HQIRF8RLfbkk4o1AHl7tHDlVX8fu9FPs/It7PjiZToKsNV/NLZ76QVqgChao
 6L2LgXRI9rqjmTcU3iT2gcE+MMGbc1zlb6XZLatZ/Z0vI4F8h3heKDv7hhQ9a+BM7zVwBCwHq5a
 AzdLl9Z87abwGnklWP+k/EssGeob2z7bCQ9RhCgrM4Ne3SNLrxGA4ZJZ74dVuw1iO6atj1PQE86
 Ku5OwAG4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, 17 Sep 2025 09:27:33 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Tue, Sep 16, 2025 at 07:36:44PM +0200, Heiko Carstens wrote:
> > On Tue, Sep 16, 2025 at 07:06:06PM +0200, Christian Borntraeger wrote:  
> > > 
> > > Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:
> > >   
> > > > > > I think GFP_ATOMIC actually gives more guarantees?  
> > > > > 
> > > > > In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
> > > > > are usually the atomic ones.  
> > > > 
> > > > interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?  
> > > 
> > > No. ATOMIC always means: can fail. 

my issue is that GFP_KERNEL can sleep, and this allocation is sometimes
called from atomic contexts (e.g. while holding spinlocks)

the right way to do this would be with mempools, to allocate memory
(and potentially sleep) when we are not in atomic context, and use it
whenever needed. this is on my to-do list for the future, but right now
I'd like to avoid having to refactor a ton of code.
 
> > 
> > So GFP_KERNEL alone is what is needed here. It is undocumented that
> > small GFP_KERNEL allocations will never fail (retried for ever):  

define "small" ?

> 
> Another correction: it should be GFP_KERNEL_ACCOUNT instead, like it
> used to be before in gmap_alloc_crst() since those page tables should
> be accounted to the process which is allocating them.

gfp_types.h says:

 * %GFP_KERNEL_ACCOUNT is the same as GFP_KERNEL, except the allocation is
 * accounted to kmemcg.

I thought that without GFP_KERNEL_ACCOUNT, it would be accounted toward
the process?
The documentation is a little confusing here



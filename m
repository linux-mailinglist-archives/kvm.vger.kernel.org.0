Return-Path: <kvm+bounces-62224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 15098C3C81B
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B61933526A0
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC9C34F48D;
	Thu,  6 Nov 2025 16:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ij4X2dpM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F5234D919;
	Thu,  6 Nov 2025 16:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447023; cv=none; b=Gdl7tDuTlzoglXmOFyscXdtoryFJuCRK7m9PPRv4TDjetkGR2nvjee+2miTFifVoExcNCEVJXnXevkLPIQtfqFLH3SNqzC5/aFyezWvCONORkdKsgR8ZxY5AEpvSmhsj4aoiia7NV2vBzcK7AutOiLgoU51wVdyYtzT+Mh6NnHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447023; c=relaxed/simple;
	bh=jKvGY2o3ZqFAf3yPe+ZDefckpQ2RNPLFY32rU0oGtx8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bvdRtDrX718BxDHmVk1pWjWJOeDUwKGt1tQjYTVOJn4wDyUv3hA/Hztv7MiAeLm5JtSOjbbtKR2MOfK3drCRpjkJmhlnS/ONfhPiEIRMc18yV5/nMri5VK3B16XeSXtgkOOdFeyhxcDwD05Jpnfjwz0sbnvBUq3iHGegZcmKaCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ij4X2dpM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A652Fes023094;
	Thu, 6 Nov 2025 16:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HHrRKk
	BbLdY6ORM2fAIldjadhFQ2gBLJwb6jSqr32us=; b=ij4X2dpMDlabvPDfvCRbWi
	JEwBoost42YZi3LzKQuLp+91JniAJXC2vThBvtfFcDOf2tocsxlYb+vRZt/iv17w
	Ydq7t30GFmPkPQr5xlmQXIP++8lOlnIKyYtsXJ9ZAdUT3oZFqbu/jyvRxl92Y161
	b9p4YP2pvAFNti/EMqD8/KxvR3d2t1uKb2f7wH/zbflz5DnCnGPmpO3/sKwlgDbK
	R8ebY32NEuCHjK3X3I4SXKiRgsv47Zf4rGSuRv/Js3EEKhcblMS/j+X97dttywtm
	xJ/q99Ao2Ippfg03CVF4Sa77uKma2CLlf0RDFPjXqxhcj+v1kg6Ci8/Ac7EY4C5g
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59xc890g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:36:58 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6G2omq012861;
	Thu, 6 Nov 2025 16:36:57 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5y8266gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:36:57 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GarSM30146984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:36:53 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B99432004B;
	Thu,  6 Nov 2025 16:36:53 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C4B420040;
	Thu,  6 Nov 2025 16:36:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.155.209.42])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:36:53 +0000 (GMT)
Date: Thu, 6 Nov 2025 17:36:50 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 21/23] KVM: s390: Enable 1M pages for gmap
Message-ID: <20251106173650.31907261@p-imbrenda>
In-Reply-To: <5dd6e694-8cf9-4b1c-ae83-088b6bd22a17@de.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
	<20251106161117.350395-22-imbrenda@linux.ibm.com>
	<5dd6e694-8cf9-4b1c-ae83-088b6bd22a17@de.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfXwtK8bXvHSc6X
 B6cmlup6vR1csQ864iUpkv5IVnWoCNP6ZjPzjc57zw8rpNprWKwl3FAQz5812pYX0MClJXQ7mzx
 uj8qpcH9qG0RDT1tO2jpoEpB+vPrgvNhN26QaxkCLvsFl9wjZAWZyrtbU9uvRKaK092EIbkjJaH
 0DH320T27MzEtMm/nET+kDgQtzqIrFMQm+uiAClYdmjTjsQ82jz6Vj4b2wFV4c5BD0ueEeCTtHf
 c4K9p47JuJUrhxC0ma54M3RpXNRd8OQX05bfdukC4PI4dLPHxmSiMkELj4hKfX2fJ4nk8ZFMK1z
 y0ODJO69bSgYFvyE18iBXE3bvetjv2hlIfEz6PymwOs2Y6pB2bE/m6+LTuZk7yfPCQ1oJfNdDQ5
 Sm0mZ36zGPQurIir8+Mb8oSsRH+/aQ==
X-Proofpoint-GUID: GTdQQs1ZhJEsZo4w_vJm5JFeqGJ6aFCn
X-Authority-Analysis: v=2.4 cv=OdCVzxTY c=1 sm=1 tr=0 ts=690cceaa cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=V77HFTMLeaZSbkRks0wA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: GTdQQs1ZhJEsZo4w_vJm5JFeqGJ6aFCn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

On Thu, 6 Nov 2025 17:22:33 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 06.11.25 um 17:11 schrieb Claudio Imbrenda:
> > While userspace is allowed to have pages of any size, the new gmap
> > would always use 4k pages to back the guest.
> > 
> > Enable 1M pages for gmap.
> > 
> > This allows 1M pages to be used to back a guest when userspace is using
> > 1M pages for the corresponding addresses (e.g. THP or hugetlbfs).
> > 
> > Remove the limitation that disallowed having nested guests and
> > hugepages at the same time.  
> 
> Nice. This might allow us to enable hpage=1 as new default as soon as
> things stabilize.
> 
> We would also be able to use 2GB huge pages for the qemu mapping?

yes, but I don't think that userspace can have 2G THPs right now

> With this patch we then have 1MB pages for the guest mapping.
> 
> As a future improvement, maybe also allow guest mapping 2GB pages.

the core of the new gmap code introduced in this series supports 2G
pages already; to enable 2G pages, a simple patch similar to this one
is all that's needed.

I refrained from enabling 2G pages in this series because this series
is already too big, and also I would not be able to test it easily.


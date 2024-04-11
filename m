Return-Path: <kvm+bounces-14245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 631DD8A149A
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:27:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2F52B2556C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 12:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0B714D6FA;
	Thu, 11 Apr 2024 12:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aI70pwew"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F4F14C587;
	Thu, 11 Apr 2024 12:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712838410; cv=none; b=FovsbY+Hyl55YW3pvYi3xIhRCrHfuQOaZzato64wEeacHGijG7ep34lSlLZvjD8xVnBaXSCzz+FylcNMZCYW2OScjjBVP8kIxCR3GQ0tkkgS9u0ZW+53aJ2xjG/IL0GccxCeRjNZThuvrf6HtBrirpNZz8kX5Pa+954w4Ee7W84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712838410; c=relaxed/simple;
	bh=j9QEZErwSiPeHI7etNSggt8jQ1vfzV580Nrz8drvUL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGE9DGtOr54k1FlbXjn7WK/b9TIL3KzT82Xmpkw1iFSgiOmp43oHtOgMXSn6jU/n8hvqvrXb6TYjPaIayzRxxwJCeW2YVIJ1mYeTT1Q7oU+NzrEcD+d/QuptGDzRji4g/eP5zHFo5t8w1wjozzavea2nXAiVHocAmf817KET3Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aI70pwew; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BCBE53020993;
	Thu, 11 Apr 2024 12:26:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=S5QeKmmUoyX5xyyZhHh7vdWOWq+vB95HSexOwbAxSU4=;
 b=aI70pwew3Ptt4D9mUA/jBzfD6xITb3lu4gnGWLvmE2taiQVMsU2hMOOEHAnoqNJhNpkW
 p6wjw+uy1/NR9pGFXNu6F+RnxwyRzgOV5W4+hfHqXAmFTttcFLmtMmxvZzq0VRhEVVrs
 0rtAxk4IQCtGoFDQf0qdYc2I6Y1iMaG0XYNA//NB7PXUrsEEOqO6yPUVjhU5sth/+jGP
 4iZIVTS0zd9+PwXjXApCoOZTe9IXO8d+3Hb0cUByIifqtdo0vTfWekNWdj2lKU0UKRxj
 A9m/lKrlnRevjhmiy87BysbIpnDct3SLQThxcJfPeOppBdmK5UB7WhlRUcj7kD7IaG0R Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xefh8019q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 12:26:30 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43BCQTt8009899;
	Thu, 11 Apr 2024 12:26:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xefh8019m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 12:26:29 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43BAluX6021511;
	Thu, 11 Apr 2024 12:26:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xbjxm2t8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 12:26:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43BCQN4W50069998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 12:26:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9435C2004B;
	Thu, 11 Apr 2024 12:26:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 413FC20040;
	Thu, 11 Apr 2024 12:26:23 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 11 Apr 2024 12:26:23 +0000 (GMT)
Date: Thu, 11 Apr 2024 14:26:22 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/userfaultfd: don't place zeropages when
 zeropages are disallowed
Message-ID: <ZhfW7qzAGPQo3mJN@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240327171737.919590-1-david@redhat.com>
 <20240327171737.919590-2-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327171737.919590-2-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 19erZIHPx_Nmi6mLSyQwNP8VzM7VBOk0
X-Proofpoint-ORIG-GUID: zulkTfLbj6WQeASqUSZ-sbV7sEDYxcvu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_05,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 clxscore=1011 impostorscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=569
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110088

On Wed, Mar 27, 2024 at 06:17:36PM +0100, David Hildenbrand wrote:

Hi David,
...
>  static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
>  				     struct vm_area_struct *dst_vma,
>  				     unsigned long dst_addr)
> @@ -324,6 +355,9 @@ static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
>  	spinlock_t *ptl;
>  	int ret;
>  
> +	if (mm_forbids_zeropage(dst_vma->mm))

I assume, you were going to pass dst_vma->vm_mm here?
This patch does not compile otherwise.
...

Thanks!


Return-Path: <kvm+bounces-16189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 767BA8B6267
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 21:36:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3195F2851A8
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 19:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D4313BAFB;
	Mon, 29 Apr 2024 19:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BUlM5pvj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB56313AD22;
	Mon, 29 Apr 2024 19:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714419318; cv=none; b=Yn11oR4BCoBdrGcAqdR9cZi6eIr8Ipg44y/48EgX6yUkH3RneM2jAjKZH9F8K18v+hhxK47uvz/WM33ySM9nziMv/SBA1sJV7qkedq/4e1zOpIk/3z22zUSsHmrHOg9LLzaiOuKRvTYYhO9M1ucOeeYUyd4LYnl3vCvmNGEEHYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714419318; c=relaxed/simple;
	bh=UyGvQria8CPcwqnOwNSwK6RHeI6dLGVcMlqTvFJPOcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UziMZ7WS6Zr6b59gTDSw/YVsBI7YGIpkHUdfgEM0bEm2JkfK/zW+mrv8FMOpYKjYduU3oQKdP8DR/Z61W87ZSNCZWytOWdoQV0tvg+cgRb1TaTpJyVF8NA0C4Z/zLfbRnl/+5RdMvwS/y7fTSBkCeMnF1w+EbyqAM0zrcmun1Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BUlM5pvj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43TJNoJ4017723;
	Mon, 29 Apr 2024 19:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=UyGvQria8CPcwqnOwNSwK6RHeI6dLGVcMlqTvFJPOcQ=;
 b=BUlM5pvj+mXVCs9Ksf6ejrUYQO9hae9Snw/9pW7Ou18iD2Xc/K5Ta2Wf8tO0pxB69Juk
 kHEjojq2gVG8LXzp7+5Vsqs5DBqFWKMVqAagTXbSOiXvIVEFCcYb1qCcyTqr5E4dlv7S
 1U/vPHmvQaIFXNKHjsGTa9CPGWhFW6m22xE83EaOqr0SYxqW1jMQWZ0etRuldiZ5Sl43
 uDo6Nh8p2BhKOwv5GPV+FfwTI2y+76AYuQc9V0dbTJix8J526U3PfG/2xA+r+zvoTVyK
 N7ecqZJ/48jM0Tcar6SZkmr6OZh/V9MqhFPIJJzIwQ08y/ftPMzsyLYCAtEl2LbXl/ml OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xthn5r0ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 19:35:15 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43TJZFAb001957;
	Mon, 29 Apr 2024 19:35:15 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xthn5r0nw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 19:35:15 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43THZrTJ027546;
	Mon, 29 Apr 2024 19:35:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xsc309awm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Apr 2024 19:35:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43TJZ7Rs16449920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Apr 2024 19:35:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6FBA2005A;
	Mon, 29 Apr 2024 19:35:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EA682004B;
	Mon, 29 Apr 2024 19:35:06 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.179.5.151])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 29 Apr 2024 19:35:06 +0000 (GMT)
Date: Mon, 29 Apr 2024 21:35:04 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH] s390/kvm/vsie: Use virt_to_phys for crypto control block
Message-ID: <Zi/2aDGGEhyZfko9@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240429171512.879215-1-nsg@linux.ibm.com>
 <2f046603-ae89-4ad2-95df-8e187501e06d@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f046603-ae89-4ad2-95df-8e187501e06d@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SBt9g2mizOO7VNsPxatMwiqZ2tfYm5cV
X-Proofpoint-ORIG-GUID: HcrhO01mfB2yosRCPFAQq4rMswxJ20Sa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-29_17,2024-04-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=535 suspectscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 lowpriorityscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404290128

On Mon, Apr 29, 2024 at 08:32:43PM +0200, Christian Borntraeger wrote:
> I guess this should go via the s390 with the other virt/phys changes.

Yes, I will pick it.

Thanks!


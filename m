Return-Path: <kvm+bounces-14277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8B108A1D6B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C85FB35F83
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 17:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB13E12C47A;
	Thu, 11 Apr 2024 16:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UFTf6XSV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D224B12C474;
	Thu, 11 Apr 2024 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712853462; cv=none; b=Y63AmlJYun4VTPwv/EP7TQ+RaIBH9tIV9uSfolrqzvS5rNK8BQR58nQIiM9hsdiafvG09tI9YBNbnb9pD+NCwXUlkfJSnjjaXPUwhviKiJZI3KutXuzVcipwUSvw/mRwe6NpFu3eYH5itGuAsnzUBZfV6IVy8zvOoguGgO+LkNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712853462; c=relaxed/simple;
	bh=iYl4wottcY2P/34Js4BhYYLPFGKYFybkTAZ0VUXHjhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZSG9YT+mSsaX8SeR5Sf/jWA3GBx9LdnkkW0XLIGgMoE0XElTxt3Y82qa3FGVKCQ7i90pDLv6h1mXyBvkg+RqsllY69QquD1Cvq7ulTlnMdsWEHVwpFPUcHPjxR9UKmjFT+l1tVNf39Ts6tlVnIGUoW6soidR2h2HbY88ey50VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UFTf6XSV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BFupBG003035;
	Thu, 11 Apr 2024 16:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=iYl4wottcY2P/34Js4BhYYLPFGKYFybkTAZ0VUXHjhM=;
 b=UFTf6XSVhNkZ3jB8HDG+2rX4EWDaJd8vFai6YuaEjrFVqg+GZyvMashcedbK7WGgw+rq
 ontNLKizLv8PqEk9VNSDig6WoP+b3jcRt+bgZPNWV/RuILgrk0JORKvbY1I4o+3a1l/q
 TM/QttCsg3SZDCLGiLTdPe2eWmdpASmB6RIm8fbvr95mR+437nxuKcbx2PLej6smm67Y
 bUpAOZsnCfP5csN/cytr89KAQ1Htl7XvE+fvzZ5kqFTQhKjpMMFEuJhFW1H1aMww+A8O
 jXbvElbAGZyIDRqr+yq1MC32sGiCmx6XQzqLlWoMkU43GB0uBBqruHaAsNqEoXDITjVc /g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xejxyg3bp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 16:37:33 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43BGbXb0001806;
	Thu, 11 Apr 2024 16:37:33 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xejxyg3bj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 16:37:32 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43BFRXQ5019110;
	Thu, 11 Apr 2024 16:37:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xbh40mgq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Apr 2024 16:37:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43BGbQHd16515492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 16:37:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0622D20043;
	Thu, 11 Apr 2024 16:37:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8202020040;
	Thu, 11 Apr 2024 16:37:25 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 11 Apr 2024 16:37:25 +0000 (GMT)
Date: Thu, 11 Apr 2024 18:37:24 +0200
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
Subject: Re: [PATCH v3 2/2] s390/mm: re-enable the shared zeropage for !PV
 and !skeys KVM guests
Message-ID: <ZhgRxB9qxz90tAwy@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240411161441.910170-1-david@redhat.com>
 <20240411161441.910170-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411161441.910170-3-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uG46q4YoF6gv8wVKDnhszm3RjoXyf1rZ
X-Proofpoint-ORIG-GUID: 7OIhNDifwD4OKsbR0SESL4_Qa6a6zJrC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_09,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=548 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404110122

On Thu, Apr 11, 2024 at 06:14:41PM +0200, David Hildenbrand wrote:

David, Christian,

> Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Please, correct me if I am wrong, but (to my understanding) the
Tested-by for v2 does not apply for this version of the patch?

Thanks!


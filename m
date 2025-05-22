Return-Path: <kvm+bounces-47374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CA7AC0D41
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E13B4E6645
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8C028C2D8;
	Thu, 22 May 2025 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fp1lEu1i"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0047328B3F7;
	Thu, 22 May 2025 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747921820; cv=none; b=pZ6UOp7GBf4ZH8hl0KQT+7b86CBAEWY2R3tclG+XzAbwOAKHkpvda6bxt86kv6C5qsGezHgT+SUmRasqa8USyDidKgM+kdNAv71FFvGj12DzTLPINvCZ1f3krjWOKwqqsOIIU5AxaoBd4/37lK5P0kyhguhPJfulanks/tzsA8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747921820; c=relaxed/simple;
	bh=+a4fxQEl/saEVYwjfkKLdt5/RkAmk92/cXvyspnGKZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g8XNzfZDeoJ+n4JybwzMkI9DPwbEY0kXFwj0aLJhtfSWmaY+MGAGLS7+qMuAk+rYrO0cXILhRUsZBGbdASKLG+YlPoudaSZ253z9GxBkXpCTRJJmJoKBsX+0RrrIjvlqcxT1HUe4QJMRb4ElhV0J2YN3GsRdwSvvNTAiXjGXLpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fp1lEu1i; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6T2dR002688;
	Thu, 22 May 2025 13:50:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=dcuQfR9Uy5Aani65xyzCcnnbfN69hL
	RLoGfMQrXYhSI=; b=fp1lEu1ii/OywXSCBROqj9UqIL0KAHJXsa0UpaIhsJQ0R1
	aJhRcpMz7ExHBKBTiCB/oxkQ4tGc7dZ8MyTgG9GvViM5YCwLnbbU60FbykOaWOjF
	EEpnjBJLMqaucZiTk9dMvAmTsTlLjZpCaCh9yuhX5enr98MXohy9XzoP+9HroeLj
	Xwnu/uuQ8Mah+/b/Rz2WdcYm1ajQy390LlPeaLVb0DcHgJTDrKdEV3EmeLdKlFi3
	X8ovxx5TXbO49t0zlstimy+l8NYueJ1GKVZDqpudJ/jKSoJ7nJQqOSG2mjgah7ds
	EmRLyAmaMYsO+NxxURA2VlIK1wGlZmgzUyaA4zqQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh74exv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:50:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54MDlRG7031996;
	Thu, 22 May 2025 13:50:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwmq9pky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:50:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MDoAET54788602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 13:50:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AD1820040;
	Thu, 22 May 2025 13:50:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04F5820043;
	Thu, 22 May 2025 13:50:10 +0000 (GMT)
Received: from osiris (unknown [9.155.199.163])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 13:50:09 +0000 (GMT)
Date: Thu, 22 May 2025 15:50:08 +0200
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
Subject: Re: [PATCH v3 1/4] s390: remove unneeded includes
Message-ID: <20250522135008.311722-A-seiden@linux.ibm.com>
References: <20250522132259.167708-1-imbrenda@linux.ibm.com>
 <20250522132259.167708-2-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522132259.167708-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEzOCBTYWx0ZWRfX5qW71bNF3udP 6TKoyW8YKXoHLPL8/Dne7wb7l8yDh7PXahYxmb/KEqOMS76N/2KWObfvWx5VLTTFVwLd4OHfHLv 3w6GmfN/51hAl6e0CgjysJg6XxpLm09craLT8nPU43LdZBiUTHmFkIhBki8pzTIvlW+HAUPanOp
 5FWVhI+icipz/cdWnhfv7yq8g7ocYmffHRlgw8MVsN7VfkgNR+g9rt3HjWHM1KZDKBd4uQPz9/h NoIm1pC+yITlNVFs6JSW0LZgRpo7dOAELyG5PAwIs7fhPdCL23rEKmblEDMr3rrTcusr0DjPfWc qsW0ejWSOuOejdwrm1rztHI0piXBAYRUuTBiXMYD2MzV+OnBBn8i6vv8OJ4rNS6tgpxDPlHkdhV
 cTwyLAN267/NyY1CS4BsW8sw8/0jNgYX4mU7Ei8sHjb+fHmkKXgX2FXxHzcAn4gSEpzp1rio
X-Proofpoint-GUID: EckM3ZJQZm_BIU5OuX8Q90FU58FWzSex
X-Proofpoint-ORIG-GUID: EckM3ZJQZm_BIU5OuX8Q90FU58FWzSex
X-Authority-Analysis: v=2.4 cv=EdfIQOmC c=1 sm=1 tr=0 ts=682f2b97 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=xj4nWsXm331Kr4OhJoIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_06,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_spam_definite policy=outbound score=100 impostorscore=0
 suspectscore=0 adultscore=0 mlxscore=100 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1011 mlxlogscore=-999
 spamscore=100 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220138

On Thu, May 22, 2025 at 03:22:56PM +0200, Claudio Imbrenda wrote:
> Many files don't need to include asm/tlb.h or asm/gmap.h.
> On the other hand, asm/tlb.h does need to include asm/gmap.h.
> 
> Remove all unneeded includes so that asm/tlb.h is not directly used by
> s390 arch code anymore. Remove asm/gmap.h from a few other files as
> well, so that now only KVM code, mm/gmap.c, and asm/tlb.h include it.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>



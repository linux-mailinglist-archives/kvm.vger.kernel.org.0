Return-Path: <kvm+bounces-36235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94422A18E95
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 10:44:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37D237A2375
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 09:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285C6211269;
	Wed, 22 Jan 2025 09:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DpuUHyB8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17D3210F44;
	Wed, 22 Jan 2025 09:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737539070; cv=none; b=tMM8A+4rJsXVU0gjXIv98nw+RGH+b1Ok+iphV9NOAndE3TWdZYGY7AnpS1H3saFCnNg0eeqLfzTtCcJ7CDadL0gvmaVfehLivsnpa4zHw7iu0Ryl96QDuJCCb7/hZ/HrHkZYJj+XAWPZgtm4Towks8nBlT1ucqbWIj170akPl1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737539070; c=relaxed/simple;
	bh=+dUaWMqXpBIUEQHnjBCJzpThPDB4EKpaaWCixI2/FfA=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=bkcRM+hA/2A5bU8Rkhof3AfV/j8OaxAOo51tzAn5Uowr1wliueQ1qJMOdUlo1fKgMyFL5xhDz4MjDNFnbQh+7tobwnsSRmmlaEuGe6okujP0u1rH5yK2VI+WaYJ97x5hL4saUdoXOsUi4+i24pjHRTHW+qNaSs1PuPOVktUM8aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DpuUHyB8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50M7Wk5Z012600;
	Wed, 22 Jan 2025 09:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9iA/PE
	Q3V1dR/HBfhTnuwseCjzEp3o9a6xnM25GuV1E=; b=DpuUHyB8Te7E/am17OEpnC
	vx3qW0ApDGf91SZGWR7Yqp+wRDNmrHPku1HI0Us69hzOh+ZVn4LZvVT92VxDP87B
	LsjU9YWpZtXkkvONfXMa8LBog4tNUxsQ/7ohNUSUpzYSOVklJ4UYpcq8y+Z5/rGm
	edVMmIR15D2xaUQ77ELlVRR8H+Md47K245kAAIp/l3WEaftDm93x+3IeA/5D75SY
	zGrVlxxRwiOmh6Vvzl7/9TkkOYdDw+fSAj07i/If91SXz8z1qYOg6nFGSAWKPwu1
	0bKvDF/tGsoHnFqWUlUmJpE9RNf0f3cmgTpS97/3VNWVpeMFzJqzN1dnF8CrbH3A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44avcp0jjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 09:44:22 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50M9iLSR018865;
	Wed, 22 Jan 2025 09:44:21 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44avcp0jj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 09:44:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50M6kDrZ022381;
	Wed, 22 Jan 2025 09:44:21 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448r4k7q3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 09:44:20 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50M9iH5r33555090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 09:44:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 119CB2004B;
	Wed, 22 Jan 2025 09:44:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB37120049;
	Wed, 22 Jan 2025 09:44:16 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jan 2025 09:44:16 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jan 2025 10:44:11 +0100
Message-Id: <D78I6SWB8NT5.1BU4P2TG2RA1R@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 07/15] KVM: s390: get rid of gmap_fault()
X-Mailer: aerc 0.18.2
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-8-imbrenda@linux.ibm.com>
In-Reply-To: <20250117190938.93793-8-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JnE9MdDiaGZRaKmD5xZkko2OP7pbAPUL
X-Proofpoint-GUID: XkcZHA7Il-ddybVETLg6rNjzkjCYms1r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_04,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 mlxlogscore=443 spamscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501220068

On Fri Jan 17, 2025 at 8:09 PM CET, Claudio Imbrenda wrote:
> All gmap page faults are already handled in kvm by the function
> kvm_s390_handle_dat_fault(); only few users of gmap_fault remained, all
> within kvm.
>
> Convert those calls to use kvm_s390_handle_dat_fault() instead.
>
> Remove gmap_fault() entirely since it has no more users.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h |   1 -
>  arch/s390/kvm/intercept.c    |   4 +-
>  arch/s390/mm/gmap.c          | 124 -----------------------------------
>  3 files changed, 2 insertions(+), 127 deletions(-)

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>



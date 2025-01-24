Return-Path: <kvm+bounces-36540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1992A1B7F0
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 15:35:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 419B53AD0C1
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18B6713AD11;
	Fri, 24 Jan 2025 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QrtaGQw1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27058134B0;
	Fri, 24 Jan 2025 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737729316; cv=none; b=hm0yBXjNsWmBZhLoqGV4P0VtzSgMK4AHRUgI3nhuIdZkltEHjtJe/3yl+le9omD2lh9QczE03DjcxLDwDiG5zGZZ6X6BuG6WB8OvMzcgP7evtJON8B3iHbxAlrPbm5xo6vt4GB0R6kKvJYuxFJ+a5Lwpj6XFk9S97Bm9v5JiNa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737729316; c=relaxed/simple;
	bh=+8CKwnUVbS7XkfWyxuLaBZGiyucZXTj/neXw8nmsDU8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:Subject:From:
	 References:In-Reply-To; b=Sw6Oh11SJEQsxfbeWqPZkJJJMAIGwkH/+QqgWMUudlSPuSCuWrB8s0SJEGUYx9chWovpWNjWg2gfSOALUPsLV4OpMG++1B3hKD7SQaDaGWIAQl+7NKctCWg1HJcFb02X0Uh78k44xiRfm2bWFpD4vV2GDVV7E0W2n6ri+Sfa3+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QrtaGQw1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50OAifQE001889;
	Fri, 24 Jan 2025 14:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lkDhra
	KudUnMkAnyYCzkAF8aHClwQohAo/LQn/fNFCI=; b=QrtaGQw1yBHAPZdLHBsGgR
	4CATnrPmGPr6RWfVGngQgzvnwzjid7eg8mwUDxoaaxTSuMhZtvJ+r11KJcf2Q0jd
	DTeMKDgaMAmENt9fbXYAHZDY8FPZu0ANhxNTWdcqe+6/2r1u2IIUMb0jxwbBEybY
	ccVo/xttWQ04F93Joec+cGklYWx/7Jfme1JKwHcj0xMXoTqgwJkL2Sl2aWjBAtQm
	Qb3+pRZjeNMvfRI7mZWa6VkSeZCfs7FIAZlXC3YzbKauQ5GBUQZ2RIfqly5r8sEq
	sts1ykyfQGQuUL5hRR1jZF3iMuQ+D1A1eejjxJDnTgVyYOR9aPw4C1JGLV/Ou0zA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44brku6gah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jan 2025 14:35:07 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50ODvLkO005426;
	Fri, 24 Jan 2025 14:35:07 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44brku6gae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jan 2025 14:35:07 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50OCEEBP029587;
	Fri, 24 Jan 2025 14:35:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448qmnuudq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jan 2025 14:35:06 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50OEZ2xt21365046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jan 2025 14:35:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2483200B1;
	Fri, 24 Jan 2025 14:35:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCD9D200B0;
	Fri, 24 Jan 2025 14:35:01 +0000 (GMT)
Received: from darkmoore (unknown [9.171.73.11])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 Jan 2025 14:35:01 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 24 Jan 2025 15:34:55 +0100
Message-Id: <D7ADMHNRNKUU.T0DSREGYMGDH@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>, <pbonzini@redhat.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 04/15] KVM: s390: selftests: fix ucontrol memory
 region test
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
 <20250123144627.312456-5-imbrenda@linux.ibm.com>
In-Reply-To: <20250123144627.312456-5-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8WS2d-lhgBDHm6qB8AtYTwDAZ_9FdV4G
X-Proofpoint-GUID: x7trECZ4-VS4WNFZboqnYBBfVLTCDyix
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-24_06,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=676 clxscore=1015 lowpriorityscore=0
 spamscore=0 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501240104

LGTM

On Thu Jan 23, 2025 at 3:46 PM CET, Claudio Imbrenda wrote:
> With the latest patch, attempting to create a memslot from userspace
> will result in an EEXIST error for UCONTROL VMs, instead of EINVAL,
> since the new memslot will collide with the internal memslot. There is
> no simple way to bring back the previous behaviour.
>
> This is not a problem, but the test needs to be fixed accordingly.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  tools/testing/selftests/kvm/s390x/ucontrol_test.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)


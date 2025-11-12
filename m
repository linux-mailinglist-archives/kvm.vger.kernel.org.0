Return-Path: <kvm+bounces-62841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C520C50B28
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:26:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9CE1F4E914B
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE712E06EA;
	Wed, 12 Nov 2025 06:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GNvc0dFn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F682DF6F8;
	Wed, 12 Nov 2025 06:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762928751; cv=none; b=TxB+P6Vd41R1LT680GjYKU0GTjut7/y1bW2I30MGoRCTrRmGtyxg0vDqutRqzRML0lfxPmhligxZ2Aw64ckWu+KBurA1zh87MXqJFQh3NMglk1ZBnKWNjhi7A0lB21Zd2LjZB3USd4Q8ToV7Gc9WfqwXNxi7WqL2VHKzR55eWr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762928751; c=relaxed/simple;
	bh=V8lpm8QJ4lXgG02nCO8rtalnqI+BYwQEyPvZ0LBvYuM=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=jMqhKsCVyyD9RyEBrG05ka2tim4oa9k6A70yYnjvkbDOh7ZLn2wKumlt02nPhudx9sg8P1CGByff44z6LAOy9rEMJtFHfpxFkpmQyIlrKOX0h7zCTDXtgIt1CA7/HQ46GG3nO2wzGXujETBYPE1zw0Eizgd7Bv2S93AtTGndv1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GNvc0dFn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABKlmTe005808;
	Wed, 12 Nov 2025 06:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NkE3Qk
	sqEBdmdL/XrDKZg7mI0tsvtwuVamNTFbTzG6c=; b=GNvc0dFndzaY0fzg1ETsQS
	HeBLiDxYL2qiYQiqOcF1/A4ilj3H2Bq+VWCu5C9MD5X8NZIQojmzhRmoK4snVx9L
	3mv9z1UzX+gvBiWm9h6qdfmGvOkX3WKIFSjneoz4d2VM+y0VifsZ76qasrLh62vE
	AoDpOw2qaWa4z6FqkHsUM51rfehiq5W1HX3j/Xc5BG1xpScA6RvZReYGf218tNJ0
	6IxNPMUsFE12FVytYKFFhLQtwHSrXp8prq8sPWT+CU1NUjuxaGiVj48m5aoBDaNs
	kCNDjivo8HK2Np9m5SIpI+7jfPOyW/ANHcUKoQ5LyeYKdM4S4DFHLc2cwhZDnsIw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wgwyk19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 06:25:47 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC5mKAV007375;
	Wed, 12 Nov 2025 06:25:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdjef6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 06:25:46 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AC6PhIB27001462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 06:25:43 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C4752004D;
	Wed, 12 Nov 2025 06:25:43 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E58892004B;
	Wed, 12 Nov 2025 06:25:42 +0000 (GMT)
Received: from darkmoore (unknown [9.111.61.55])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Nov 2025 06:25:42 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Nov 2025 07:25:08 +0100
Message-Id: <DE6I2KA0FPCX.IKTZXU74CPDX@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>, <hca@linux.ibm.com>,
        <svens@linux.ibm.com>, <agordeev@linux.ibm.com>, <gor@linux.ibm.com>,
        <david@redhat.com>, <gerald.schaefer@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 04/23] KVM: s390: Add gmap_helper_set_unused()
X-Mailer: aerc 0.20.1
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-5-imbrenda@linux.ibm.com>
In-Reply-To: <20251106161117.350395-5-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4gwAgylh-BBYJQdN823d49WrTVNulepN
X-Proofpoint-ORIG-GUID: 4gwAgylh-BBYJQdN823d49WrTVNulepN
X-Authority-Analysis: v=2.4 cv=VMPQXtPX c=1 sm=1 tr=0 ts=6914286b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=Y6CA1nhfU0GbWGwoTcwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfXzqbXUMdn6okH
 fxFdN8VDJtVWeEwunpovR7oCjr45qPYsoz2nND6W5wOmmEpxsyGGYz+I2GXMGDNwbVk4m8A/z8r
 TIXKV3jbkbakv1btqmLfUGl9ungPllHQHK/+w/MPmwhwIc1D3uS2PT331OczaT5UJv7CXAf4rlu
 oxRbABnc3PQ7MxONpbEnmQf8N7bvz7V0hKpgWc05QB4yRm2Qu0nJNEuFEbg5l9MEFKiU8eMjKpR
 y8fGB8vtlX/zq97LZ4BJ0yhQK6KpHQM93MycniTj8/RDDRXL1CaqTWj3ODjiH/Kk77UddhgzFtR
 MwT9JKtE1bXAARd+gWPReowPpN+YEgGRgNdUDlbD1JEkCLL07m0PC9BZ350rRWt608m+aEK2c9O
 ht9XLqVHDa7b0zb8B06SmpoCfWSWGw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_01,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

On Thu Nov 6, 2025 at 5:10 PM CET, Claudio Imbrenda wrote:
> Add gmap_helper_set_unused() to mark userspace ptes as unused.
>
> Core mm code will use that information to discard unused pages instead
> of attempting to swap them.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> Tested-by: Nico Boehr <nrb@linux.ibm.com>

Acked-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/include/asm/gmap_helpers.h |  1 +
>  arch/s390/mm/gmap_helpers.c          | 79 ++++++++++++++++++++++++++++
>  2 files changed, 80 insertions(+)


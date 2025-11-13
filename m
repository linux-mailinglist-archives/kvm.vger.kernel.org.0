Return-Path: <kvm+bounces-62997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99913C56B9A
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 10:59:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 041563BC2C3
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 09:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C50D2D7384;
	Thu, 13 Nov 2025 09:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iUsMD6E3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B302D7386;
	Thu, 13 Nov 2025 09:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763027564; cv=none; b=VYV+Cq0+eX1ZvVuB7I9RWsiXAor1LDCNpqBt2fVduhAkx9OT52rJTu/EbVgbxDO4MVnEEzEGiAfWaGnGPXcM7HUwCxw0U9Sl57HT30nqtT/0Cp8fXuaSeZE2y+55qykAYUJXvlow1i8quNqsZuxx4g+1qo5M0KHF87r6aiXB7ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763027564; c=relaxed/simple;
	bh=HawrWamy5gC7MeG4MPXBaeV9ev4dwlaRokgxvbQhRYk=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=XQbChfa1zKGU/RJfyXID6HGgb4YUjMb0zNcSUPJosRlUh9EZS8VQlsfOJlXWNvGD1+oWVqxa6M6wstJd3JEDXEs9nMOZ52S2zqbkR62O31CJlzPkr3SxGTX/+e2FPr6KVO6EbbM8Hwr4ZbpPDXdLiFixVRFucHZhgL34jUxwhFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iUsMD6E3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD09kSm016918;
	Thu, 13 Nov 2025 09:52:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2EDy8i
	Q9NPrvyh1QM0UAJKoiRuih8C1644g+NmGDrqc=; b=iUsMD6E3UbTAhi4m7kMYt7
	xc5dw3oGE94ualt2IwlWwjehumx6qyKfUP3KSOhUm8q0bcq/f15n5KlYjk3ezQ6F
	fdm6lxSxM51X8bZlYGPq9f9aViwkXwAyLInuwia/U4kFLyVA2yF29XTbEDHF3lCr
	QQHojLSBPACfDnsxDf2qokE7cXqbx18Qv/6ITviELWjDfhfb3/uZUVemyqYgVjn8
	TWpqihlMpfIPc3WdPi9tuxQH/Di5vuw6lZT5IQBlzVTFl6//cVbLZ5ev6bjx5loT
	jJztGAxiJ8LrwuhOGQAhJW/Jeff1vf0hAXhTu95pL4UlHF48fOxyApPT/yQ3CfeA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk8f7ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Nov 2025 09:52:40 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD8kbaq014779;
	Thu, 13 Nov 2025 09:52:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aahpkd3h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Nov 2025 09:52:39 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AD9qZKZ9109926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 09:52:35 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 928EA2004D;
	Thu, 13 Nov 2025 09:52:35 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D4B120043;
	Thu, 13 Nov 2025 09:52:35 +0000 (GMT)
Received: from darkmoore (unknown [9.111.1.139])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Nov 2025 09:52:35 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Nov 2025 10:52:30 +0100
Message-Id: <DE7H3VEYBLXH.2XVJA91Q16GFB@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>,
        <schlameuss@linux.ibm.com>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <david@redhat.com>,
        <gerald.schaefer@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 06/23] KVM: s390: Rename some functions in gaccess.c
X-Mailer: aerc 0.21.0
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-7-imbrenda@linux.ibm.com>
In-Reply-To: <20251106161117.350395-7-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX7SddIxEH0tTB
 vqDb8kNeIRkXrXm6DM9rGQv8unoEOKqu0WbVGNunp4sLP/XfIo3dMyyPY3NtrCNMMbEZs9/QOWh
 zTJDA4sUw01DSTQhNjM4V5QSi3lI/oB6PU9ykdyTRD7EN4HJ3pqYvPLMcxXGoR0Ip6072KGBu2P
 EKz5kQZYdJ9jLfJsDDpaMdBMVy7UZnxcM+tJoFHZZpAd5PaPTxnQydL9ZqcnOH7+gB2huy9lV1Z
 ovngXRuh5tYDZYkEbjWb82NygxusRBZU2HgoJPQfFBOf/so7OB3RfEbSc16/VZ+6dSHZdW193jx
 EyzVcsUOzouyRDcHxCA64MOHnM2tahzE9CQED9PfMVvCNZayTkiPdwy5mL8IcsXAFWqjlrfJXCd
 vSvkWfElW6yDNQVeUNhRWjt15chSVg==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=6915aa68 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=bQmgN-JATwzZSvIza_4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: x1Q1VPTmynAChpd1pBLaE4JICxDiwr8o
X-Proofpoint-GUID: x1Q1VPTmynAChpd1pBLaE4JICxDiwr8o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_01,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

On Thu Nov 6, 2025 at 5:11 PM CET, Claudio Imbrenda wrote:
> Rename some functions in gaccess.c to add a _gva or _gpa suffix to
> indicate whether the function accepts a virtual or a guest-absolute
> address.
>
> This makes it easier to understand the code.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/kvm/gaccess.c | 51 +++++++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 27 deletions(-)


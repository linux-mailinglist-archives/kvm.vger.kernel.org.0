Return-Path: <kvm+bounces-36649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C917A1D3EB
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 10:55:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79E963A6B25
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 09:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1361FCF55;
	Mon, 27 Jan 2025 09:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BUVWgZ4r"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869F025A63B;
	Mon, 27 Jan 2025 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737971748; cv=none; b=FD1IBmKLzlyUE+ltwkpB59Bsq8kDOxO2gvLFnEswEtJOwEVaz9eX4hkxwTY3VIb+CGzpUQtgM+/+XQFUVwFFo0Nd0M2UznkmaCVBGYrzxjhYC22NDZhQWwnwe1cZtXa8j5oWEev0m6Ib4uksft6J1/vd1gaABHtWSYNdHNOUZQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737971748; c=relaxed/simple;
	bh=MWGskW95ybe6Vmdke4/I+LdQ7Y/l5cFP35FMzCzhuUg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:Subject:From:
	 References:In-Reply-To; b=lfO8KGqbn3Stl7nCyneSfGM+hukM3AOzSz0cXTcbku8M589114MLmf0OITsoJ2ZhhfI0rETM+kjRxZY2zLycbzZU/WCsks/h2EgS/4QaAFmvD01uOUgsUc94qkZeoPYZLp0x49FoDH+mhJOZQ4MJU2ioSGFyN4kQbp2hPgRjPBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BUVWgZ4r; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R7X0Tp029773;
	Mon, 27 Jan 2025 09:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WWpXnP
	DrXx/ydJmaEbGiVtfEifP4e+iGYNoQntzCgro=; b=BUVWgZ4rXEitInSSIWs1aa
	opVisA8yRv8yg4oybueeyOQMPA5aByT2MIB2t7f3vtScBrfizWxWGGFlUT8Ktj2f
	WMKZdNmEQqRsstUUvdVgBE4qnfns96ksgVFQ42lLPjnubML0MFSd7LbeFQFA05g9
	uPVMgLuCRmluc5KzSCoNRzC2hY27m9HRvlL9LO3UWfuIEiLQFttJyH09tn+NY4SF
	K4HwxUtUqQKhPmAIlBBebGknaDUAMPZJRBgJJ+2nhg4hCuvo/P1YtMrFlyBQLD9v
	hryz3bA/EPVeqjdHD5MxOJi0uXbtRw7JZoSmw9ub4PVJhK891+UaaYEMVU8a11VA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e5un8kbm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:55:41 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50R9fmNK010680;
	Mon, 27 Jan 2025 09:55:41 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e5un8kbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:55:41 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50R7wlGq019262;
	Mon, 27 Jan 2025 09:55:40 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44db9mnnhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 09:55:40 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50R9ta8U55837090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 09:55:36 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19A7820101;
	Mon, 27 Jan 2025 09:33:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFC0A20100;
	Mon, 27 Jan 2025 09:33:36 +0000 (GMT)
Received: from darkmoore (unknown [9.171.61.145])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jan 2025 09:33:36 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jan 2025 10:33:31 +0100
Message-Id: <D7CR3CSVQRTW.3INXTFFGPLUU0@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>, <pbonzini@redhat.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 12/15] KVM: s390: move gmap_shadow_pgt_lookup() into
 kvm
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20250123144627.312456-1-imbrenda@linux.ibm.com>
 <20250123144627.312456-13-imbrenda@linux.ibm.com>
In-Reply-To: <20250123144627.312456-13-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A_1fGOk1zW95ntxyXCvumrUY7FEZ9zhs
X-Proofpoint-ORIG-GUID: 9I0hsWvePcWilM3uf7yXHPZxen05yCJI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=564 bulkscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501270076

On Thu Jan 23, 2025 at 3:46 PM CET, Claudio Imbrenda wrote:
> Move gmap_shadow_pgt_lookup() from mm/gmap.c into kvm/gaccess.c .
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

LGTM

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/include/asm/gmap.h |  3 +--
>  arch/s390/kvm/gaccess.c      | 42 +++++++++++++++++++++++++++++++-
>  arch/s390/kvm/gmap.h         |  2 ++
>  arch/s390/mm/gmap.c          | 46 ++----------------------------------
>  4 files changed, 46 insertions(+), 47 deletions(-)

[...]



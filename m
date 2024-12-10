Return-Path: <kvm+bounces-33411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E549EB0F7
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 13:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26BA828674B
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 12:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAB71A7046;
	Tue, 10 Dec 2024 12:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UcZmr4en"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8920A1A0BE3;
	Tue, 10 Dec 2024 12:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733834295; cv=none; b=uCvOGJR+4wGsDTqM18MPUIt79iuVN8M2HVf+VC96LaE/c4cg3af6b/2Kub0z5RsP774s340jYj6MqoilL/r2P/PAJFB6ql/TUuCmaCvXp2SXDouYk+2Dkf4laK9emBOF2ps9s8cQnoSeNxS4d5G2DDoV3AfWCJxiNPe6CNsE/es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733834295; c=relaxed/simple;
	bh=eZFdmnmgdiF7EMQGHOe4fW6FOym0ygc8NV9/ehA39F8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=GOck0NWqiR4Mhe070XuzVq0nXupvNNDb2vIMdoOd6mqgke/pS97coEuHlKmf7aXTACPD72mXyHguVysVQZ8Z3vkYZFec8k27mWm4uQYJBulxgQ7F7vLVJUCFK2aW5Puaz0lEAL0Su7wxfdM1aQFD5K8pYf6QVW9nEs3l9p/KwEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UcZmr4en; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA62dI7030022;
	Tue, 10 Dec 2024 12:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eZFdmn
	mgdiF7EMQGHOe4fW6FOym0ygc8NV9/ehA39F8=; b=UcZmr4en7BYLCUkenctsvm
	v35UFma2Rem8ZIilxlYYJY8j+YWj8YASl65E5upp7KoPOM7GdmUXmhOBT+3I/CGX
	2NzEMtiZYO3KaaJxpCBf4vavvhamhLwy/GiPCvzfdzRZ692qm/XXn15/VqB26YoK
	SoqclVA6T3ypkEqFwML8KDL6sI+ksLNG9ogMR75DpIEvjYchbIeUvtYia4MgvjoX
	qWycbttHDHT+6YVSvJvNyNdUioSSJnoYh0Bb8OcHTRrsoyVzAzCGDcyxL52udhVm
	79idHYuKy9ONkGc/qMkDs3nLeL8UfgpS/e17OK/qZV+9v90r7ldxD7OpNCEiMN5Q
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce0xdwtt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 12:38:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BAApBZh016944;
	Tue, 10 Dec 2024 12:38:11 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d12y3sbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 12:38:11 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BACc5hn16056748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 12:38:05 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8ACAC2004B;
	Tue, 10 Dec 2024 12:38:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F23920040;
	Tue, 10 Dec 2024 12:38:04 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.202.61])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Dec 2024 12:38:04 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Dec 2024 13:38:04 +0100
Message-Id: <D680YIBTB8K9.3JYA0MCKDK0H9@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: VSIE: fix virtual/physical address in
 unpin_scb()
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.18.2
References: <20241210083948.23963-1-imbrenda@linux.ibm.com>
In-Reply-To: <20241210083948.23963-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3Z9eZ0TgUfsBHZ3CImIz7KClI7UI-Jbw
X-Proofpoint-ORIG-GUID: 3Z9eZ0TgUfsBHZ3CImIz7KClI7UI-Jbw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1011 impostorscore=0 mlxscore=0 mlxlogscore=674
 priorityscore=1501 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412100093

On Tue Dec 10, 2024 at 9:39 AM CET, Claudio Imbrenda wrote:
> In commit 77b533411595 ("KVM: s390: VSIE: sort out virtual/physical
> address in pin_guest_page"), only pin_scb() has been updated. This
> means that in unpin_scb() a virtual address was still used directly as
> physical address without conversion. The resulting physical address is
> obviously wrong and most of the time also invalid.
>
> Since commit d0ef8d9fbebe ("KVM: s390: Use kvm_release_page_dirty() to
> unpin "struct page" memory"), unpin_guest_page() will directly use
> kvm_release_page_dirty(), instead of kvm_release_pfn_dirty(), which has
> since been removed.
>
> One of the checks that were performed by kvm_release_pfn_dirty() was to
> verify whether the page was valid at all, and silently return
> successfully without doing anything if the page was invalid.
>
> When kvm_release_pfn_dirty() was still used, the invalid page was thus
> silently ignored. Now the check is gone and the result is an Oops.
> This also means that when running with a V!=3DR kernel, the page was not
> released, causing a leak.
>
> The solution is simply to add the missing virt_to_phys().
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 77b533411595 ("KVM: s390: VSIE: sort out virtual/physical address =
in pin_guest_page")

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>


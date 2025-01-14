Return-Path: <kvm+bounces-35362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C71B8A102DF
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 10:19:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEB55168368
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6601924022C;
	Tue, 14 Jan 2025 09:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Sk/HbDXq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE0035959;
	Tue, 14 Jan 2025 09:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736846331; cv=none; b=mFxH19HyZsC+voA1auNk9BRaihFN2ZqDpl4JtzV9vO4cPzUAZpe6JmQ3bA9Xy4KoB+8ind26Ku4eJtZFJLpvcRByWz1RnaxSiXB75Wwn1ivc0QJhpt0JHvqeede85CWOYoSNus6QNYdJT4A96JZmI293MneCVdRVzm2KM5NmBDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736846331; c=relaxed/simple;
	bh=B3zWW+T6RurekpP2ufuUi+M0oc7krA0Uxh8fAcOKR0E=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=tJSzSjSLAaJlFvIO9T86XJtYFWNpH0gWQ92lfRpcf+FAoiFwo3NUgPtC47GKd1OFOj6Qv4tE7H7t2QIzOPS0se28e+DHUTd5dU2G3X6lSiyNowAWMlYvkNVkYaaEX79EL/Uq/9bi0fFneSdRyF7NFu5LONS75UvEqa/xIYKLiVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Sk/HbDXq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DNx3uB005522;
	Tue, 14 Jan 2025 09:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=j89X/B
	np6s6+PRUTNqctNldmfdMouleevwkz58caS+M=; b=Sk/HbDXq6Im7hkdP8MVA5K
	anqZpCd6Bsb9j0pxDsYgF0M5QzsKHFZ+tBvuy9V5+A7UblW6ERN818t89+KhcEpp
	BXd/lJLCibuHt6h4JjeIPvoRY62hWGA2qIiDpvF1Q5WBR14qBch2SHlRsANNWil5
	9RvxYS0r1hGt2KKU6SslKBPiSgv6aWU7n7hzEuKDAoTpvc9rNLuniQAvUIDQvon3
	IpckG64H+m5Ids7ih5D6Rnz1AYSe98ht92g4lo3+ibOXXg/z/1OUDY2nbGYfROY8
	AvKyhQpMzzK/Z0BWtRaKbBC50JIBZfzDMvEMXXWsc6H3b00ZqacVhZpPXu0lTYng
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445cyhsuww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jan 2025 09:18:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50E4x8qE007519;
	Tue, 14 Jan 2025 09:18:41 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443yn2gkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jan 2025 09:18:41 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50E9IbGE33882712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 09:18:37 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4ABFA2004B;
	Tue, 14 Jan 2025 09:18:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 205A620040;
	Tue, 14 Jan 2025 09:18:37 +0000 (GMT)
Received: from darkmoore (unknown [9.171.73.13])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Jan 2025 09:18:37 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jan 2025 10:18:31 +0100
Message-Id: <D71OMSL3ICG0.2AXYO3UR6MS50@linux.ibm.com>
To: "David Hildenbrand" <david@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/4] KVM: s390: vsie: vsie page handling fixes +
 rework
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        "Christian
 Borntraeger" <borntraeger@linux.ibm.com>,
        "Janosch Frank"
 <frankja@linux.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        "Sven Schnelle"
 <svens@linux.ibm.com>,
        "Thomas Huth" <thuth@redhat.com>,
        "Matthew Wilcox
 (Oracle)" <willy@infradead.org>
X-Mailer: aerc 0.18.2
References: <20250107154344.1003072-1-david@redhat.com>
In-Reply-To: <20250107154344.1003072-1-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OjTMgTLvVbSPXJMZpHsUgsAXvdCYxk2d
X-Proofpoint-GUID: OjTMgTLvVbSPXJMZpHsUgsAXvdCYxk2d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=656
 malwarescore=0 clxscore=1015 impostorscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501140074

On Tue Jan 7, 2025 at 4:43 PM CET, David Hildenbrand wrote:
> We want to get rid of page->index, so let's make vsie code stop using it
> for the vsie page.
>
> While at it, also remove the usage of page refcount, so we can stop messi=
ng
> with "struct page" completely.
>
> ... of course, looking at this code after quite some years, I found some
> corner cases that should be fixed.
>
> Briefly sanity tested with kvm-unit-tests running inside a KVM VM, and
> nothing blew up.

Reviewed and tested the whole series.

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>
> David Hildenbrand (4):
>   KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
>   KVM: s390: vsie: stop using page->index
>   KVM: s390: vsie: stop messing with page refcount
>   KVM: s390: vsie: stop using "struct page" for vsie page
>
>  arch/s390/include/asm/kvm_host.h |   4 +-
>  arch/s390/kvm/vsie.c             | 104 ++++++++++++++++++++-----------
>  2 files changed, 69 insertions(+), 39 deletions(-)
>
>
> base-commit: fbfd64d25c7af3b8695201ebc85efe90be28c5a3



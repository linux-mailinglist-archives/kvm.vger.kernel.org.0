Return-Path: <kvm+bounces-47396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E75AC1306
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BF3A503FB4
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 18:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED7219FA8D;
	Thu, 22 May 2025 18:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qyXKv5K9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0B133F3;
	Thu, 22 May 2025 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747937349; cv=none; b=Lc9VVrzdOGCxNpiXvbG2tuHusPMsKCVJ+4icidUMeduCsoDIqRR7aL/1/QCbTVgBhLwtFeI9mExTJTGI9VamqtqDjDQ9dxb7e9uSTrhxCHi0HbfHm7fmzXsHqj5w4WzKfUCZ6HrFu4Yg6ojGluNd6AgVV76hBFRimA74ddggFTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747937349; c=relaxed/simple;
	bh=yx8wirbv3GmgI2hwWldT11GYkYT7cmgzIiTZzNPfXaQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=Q3ueacnVBx1oWvKNsYTYf0PXOKsUO+JmG3BP6zXJ+/etIapZaf5Ndk0dQ7Vw6rE9OvtCkfBGIRDrwIVKfkNuhETuHgNAecMQSZWRw7tvelLY5EvuAnIlARRR2kR6cQXfoKmVkG24uoTbIWPIyNoIrvtwAtFZ2yIahdhvPkLtWQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qyXKv5K9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54MGP7ob002078;
	Thu, 22 May 2025 18:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QMm4Lz
	PhZaEwABNl/ln9PbBfJIcFMIQwImJ2MjSmi3E=; b=qyXKv5K9CwBV1pPrXPLOBD
	8RUAtJVFvK7mjD+es8SVm1gZLy3bgJtOMEeMc/0+MI3CTODGEXL7XS+iEhORd1yc
	eqlNVId4cKPnfQA0b3QSSp6r9XiXC4MEvNd3zp+YNjYAhnHDm6o+DhhpgSswkac/
	EK9fmSjnH2jAzRTA5Ypi7qzSfIYBxTPM2pdtcyPt6M1xERx9efE428bir4y9rJPW
	NwwKvIh2ipd8GZsPUFnHf1kb5yID6cOKVhvsg/cPjYAD8peX24K/rOx0p3SaybZz
	i90ZLwLD8Iix4e81loUbQraDJDiJd/0asGwvYwFEn0NQOkqBh/FeYl3XTTwcCAag
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh75qww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 18:09:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54MI3jZk015431;
	Thu, 22 May 2025 18:09:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnnjmp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 18:09:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MI91mQ34144990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 18:09:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A17020049;
	Thu, 22 May 2025 18:09:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 01F8720040;
	Thu, 22 May 2025 18:09:01 +0000 (GMT)
Received: from darkmoore (unknown [9.111.55.188])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 18:09:00 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 May 2025 20:04:20 +0200
Message-Id: <DA2VZ43MN9WS.I6PHR04W4WKV@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <seiden@linux.ibm.com>, <nsg@linux.ibm.com>, <nrb@linux.ibm.com>,
        <david@redhat.com>, <hca@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <svens@linux.ibm.com>, <gor@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] KVM: s390: refactor and split some gmap helpers
X-Mailer: aerc 0.20.1
References: <20250522132259.167708-1-imbrenda@linux.ibm.com>
 <20250522132259.167708-4-imbrenda@linux.ibm.com>
In-Reply-To: <20250522132259.167708-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDE4MiBTYWx0ZWRfXxV4QAwtMj3t2 WzZkdQQSPGxOv40kbORXLgd8Tcxv6NG8MHzo9DPwxppF5C2w0f042QwC9TeC82q3OD3sv97QDIv dPUNDCzlNnZRJLI6Hbt0ZDycBwxiMXEBtiyZtrhmz6Ny2rMKqh1uywbk58Ql674PnuycRE9bahX
 QZEBfluw14C8Mtq1QabJbJi0QPlfj95HtmZyUaR160Ov2yS9tzr4L1RZhhKYLz+VawmeHUxhMHw OM0YRP5CFdqB/494XHzjr2enp6hrhXAV2fLnFJr3Fo6f42ApWHZFkDa5to38Zj7XGmWG5N/dnQ5 zan2NeQPvaVqEa9GklvlxtWBBomYVxtgqzV85bJV/oMpCRxFjR41r6Kfu8IgxsqXrfcpERqwd78
 r0ffZG5PqIMGrMix1Lcinv+npVGjau+VBCXU8OFbCg8PIhCnHyjO37EwP3yKwoZQf8NbVzzx
X-Proofpoint-GUID: yezTXriS3D2-VcHpTiOr0eHA7hdw9ktY
X-Proofpoint-ORIG-GUID: yezTXriS3D2-VcHpTiOr0eHA7hdw9ktY
X-Authority-Analysis: v=2.4 cv=EdfIQOmC c=1 sm=1 tr=0 ts=682f6841 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=fDxGR4FE8qlWS1JHXvMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_08,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=781
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220182

On Thu May 22, 2025 at 3:22 PM CEST, Claudio Imbrenda wrote:
> Refactor some gmap functions; move the implementation into a separate
> file with only helper functions. The new helper functions work on vm
> addresses, leaving all gmap logic in the gmap functions, which mostly
> become just wrappers.
>
> The whole gmap handling is going to be moved inside KVM soon, but the
> helper functions need to touch core mm functions, and thus need to
> stay in the core of kernel.
>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  MAINTAINERS                          |   2 +
>  arch/s390/include/asm/gmap.h         |   2 -
>  arch/s390/include/asm/gmap_helpers.h |  15 ++
>  arch/s390/kvm/diag.c                 |  13 +-
>  arch/s390/kvm/kvm-s390.c             |   5 +-
>  arch/s390/mm/Makefile                |   2 +
>  arch/s390/mm/gmap.c                  | 157 +------------------
>  arch/s390/mm/gmap_helpers.c          | 223 +++++++++++++++++++++++++++
>  8 files changed, 259 insertions(+), 160 deletions(-)
>  create mode 100644 arch/s390/include/asm/gmap_helpers.h
>  create mode 100644 arch/s390/mm/gmap_helpers.c

[...]



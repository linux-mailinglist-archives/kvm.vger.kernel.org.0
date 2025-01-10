Return-Path: <kvm+bounces-35043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAF5A09188
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E15883A5563
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 13:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938B120DD68;
	Fri, 10 Jan 2025 13:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qm1O03nt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EAE20DD45;
	Fri, 10 Jan 2025 13:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736514843; cv=none; b=kXUgcL48rGhUL6130cQ7M1xpMKVSBdm5pbhMlvSbn8Z7yMavM/sBVUWlYIREIObTs4fWTRE3PKbdw2U0NxNbtMp4RRa90GsTq8eFE0+zd8X8O7zl+fkRke7y8eHxPTobjNrChaIVNllA1G8HCTL9D3USytZ58LiwmJ9kicj8NpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736514843; c=relaxed/simple;
	bh=1LzsD5o3InaPHLfUMbf2fPyOd9x0aDjJdVcyfxyyKIw=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=seAgw97DQ+d8WW0lx5g3Hk18q3tNvL/hFqS1Y0PtB+L1t9OxW8gLdTJvruwIm0aWlsJk845fvKhGGXs9V3pS4PHBgHw+r1ORyTZf2WcCgiVWnxiPy/0hNNFeC6kYshBGxJWaRZOJCG3d6xJWuOlppxcpSUDqWcd5EtW8MtkpTT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qm1O03nt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50A3qRm9013147;
	Fri, 10 Jan 2025 13:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=htv8t+
	tddy+6CuKkPnRsfu1/zhNW7zA0aOIc88KWb7c=; b=qm1O03nt7aRZBXNfWccGnV
	qNpBCMncRjCXNzwIPiPRqFaeJrm2bLWO4NTX0zLNIVh42Fs0CXhR1uSYZOQxPbYv
	8cTUV2MV46fYkAaTmuWLWDKF9i9nywEi4oZ5+kbwpIZoAEGlTcVbetlPWyNfezpR
	N254WbTXohwhVbFl5SWmSpL982coiL/Ld0tnHfp/EiOSUCC8UvZiL2wdnCCnfXbL
	zB+iEGMIRwDSYkFfT5X0ScIAe50zrzy4I0Nz2wrx4lp647rBtz4+e/e0F+vny4GL
	HXsgI4FJCXZv6qcNJ82QG54vLeIajqMyHO37+5wgxyn8ir8Lk033/HBgX8lo9lew
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 442v1bt41e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 13:13:54 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50AAw3AB026195;
	Fri, 10 Jan 2025 13:13:53 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yj12j228-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 13:13:53 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50ADDnYm50266382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 13:13:49 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9576A20043;
	Fri, 10 Jan 2025 13:13:49 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D68220040;
	Fri, 10 Jan 2025 13:13:49 +0000 (GMT)
Received: from darkmoore (unknown [9.171.73.124])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Jan 2025 13:13:49 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jan 2025 14:13:43 +0100
Message-Id: <D6YF4OUQZV0R.NI011IZA5C1N@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 01/13] KVM: s390: wrapper for KVM_BUG
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
 <20250108181451.74383-2-imbrenda@linux.ibm.com>
In-Reply-To: <20250108181451.74383-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XshA3OlG4EUPWgk2sCvzfLsTOiht2SpK
X-Proofpoint-GUID: XshA3OlG4EUPWgk2sCvzfLsTOiht2SpK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=511
 malwarescore=0 spamscore=0 clxscore=1011 impostorscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501100102

On Wed Jan 8, 2025 at 7:14 PM CET, Claudio Imbrenda wrote:
> Wrap the call to KVM_BUG; this reduces code duplication and improves
> readability.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

LGTM

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>


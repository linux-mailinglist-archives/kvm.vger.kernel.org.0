Return-Path: <kvm+bounces-47883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F079AC6C40
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 16:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 358221886606
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 14:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BE228B4E0;
	Wed, 28 May 2025 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qGXWbgjY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CE42836AF;
	Wed, 28 May 2025 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748443812; cv=none; b=bcZFxUNrYvNMMbK89KIED4Ouo+3hIf6o8XYCWVCCTeepRUObi+LxMU8OGXxcTwt4pNK4L3E93wBC5xPJihV9yqqhJ24Y65Z8IoWIDu5ahR+iDf2FhJTTJfPX0hLAiLVO165ZIHlgX3XHKXVkBvYIRI+6hDDQ9lkhkfvHaeIQTtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748443812; c=relaxed/simple;
	bh=tRgqoMa2o8jxjSsYlU/+gQdzsrtdUeNnvraDI0tGGXs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=I/d+mt6shgpvnsyTi2mHa+bjGPMjtq7W2hnJunnhihbNeeBaSm6+SoYbHIfQzEbr6+a3bEdqZNcFNsGIiFd0J4cZBj/dwpBEv+9di1hsmsu81NmuxpOoJtoI81C9earah0aGk28+L4CLfXI/xdRibSJAQ1izLWR+tsu4twefrC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qGXWbgjY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SE9QDD022123;
	Wed, 28 May 2025 14:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tRgqoM
	a2o8jxjSsYlU/+gQdzsrtdUeNnvraDI0tGGXs=; b=qGXWbgjYSo7EwMIbCa1D8W
	lmt2tRG/C5ZADsw/9U+Wti+rzBt3GmVC0jgZOfMYDq7S+rs3aJT9sZ/WjTXbuJXu
	i3powHBxRPrK35+buyjBiUMTdNZpRa+Q5pQCNLkePiJPXrtjqCjtbqiqf7qMst/o
	iYjmp6xhSsKJcFCPKpanoPnzaWnL9USCC2mXtO3Ilgv3Xz9ofcWVxB/zefMu4g37
	kIyxvAzBIHw7vZjGzKnvXR2q9SfNjokRzAC1j20KyT+dTKxb4QhT02T+3LF3aTgu
	fQjbek2ezxi7v1bF2GAqg1UGs6gzDQ0R64Q8W7ep6SgNVahFjVQQPKs596sTL0YQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46x40k87wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 14:50:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SEle8v016130;
	Wed, 28 May 2025 14:50:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46ureug5mx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 14:50:07 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SEo3N155640322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 14:50:03 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D569320043;
	Wed, 28 May 2025 14:50:03 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 836D520040;
	Wed, 28 May 2025 14:50:03 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.43])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 14:50:03 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 May 2025 16:50:03 +0200
Message-Id: <DA7VLMMJG2EV.98H3YW6IV260@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <imbrenda@linux.ibm.com>, <thuth@redhat.com>,
        <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: diag10: Fence tcg and pv
 environments
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250528091412.19483-1-frankja@linux.ibm.com>
 <20250528091412.19483-2-frankja@linux.ibm.com>
In-Reply-To: <20250528091412.19483-2-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RwfEFUPaLpibL0R-gk5Q5m4U1xDb-JKA
X-Authority-Analysis: v=2.4 cv=fuPcZE4f c=1 sm=1 tr=0 ts=683722a0 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=UjHN_1uCSV4EKeS2Re8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: RwfEFUPaLpibL0R-gk5Q5m4U1xDb-JKA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEyNyBTYWx0ZWRfX9QwDi4xMj+hu 72JlY7V6WNURsffxmgX/qDbgh3XU7QNzFp0wZtPF7kaPAt0uQIHepaRLweSzN1rTaNPPNoX6XEJ Wf1dG/kGruN+6APjooxzQ/qhjnTMy0ymR0s6Ep7XrqsmOnext7VwpRWZQTP/wjWt80cUaZDE3Lj
 /WuNOluVhfilqPbGfYFz0KzJ53/TSdqIEENEe3Zi6SmjuVCOQ6VXvRC1rO1hDs/2nL9pezDdD4G XhXw9eux8CPmTBs6WkCeI2KKA5YkVuMIb2DMH0yYsytJbQGSj8eGyDpBtg6S+WH2fyEyT/RFESl 4o4ZfAdy+iufn0j9gUXZHY2iE2rWaQRDTpSi8NH216IPErKtaMKlEnpThRyjUDPBxCBjdOiBb/8
 gHAuFgcbkj42D/r4c7ceHighIc9Kp4n1HvzFKwxPtkQ+vxcK3zamT0fAjO8tU1hMYbwF4OyH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_07,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=905 priorityscore=1501 malwarescore=0 mlxscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280127

On Wed May 28, 2025 at 11:13 AM CEST, Janosch Frank wrote:
> Diag10 isn't supported under either of these environments so let's
> make sure that the test bails out accordingly.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>


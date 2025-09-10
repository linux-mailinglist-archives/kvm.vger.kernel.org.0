Return-Path: <kvm+bounces-57196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32596B515E3
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 13:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D8841C841D3
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7512C280A52;
	Wed, 10 Sep 2025 11:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DVaCQnF7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E970A283C87
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 11:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757504201; cv=none; b=LdhPI7rLL4V8bE2a99YiZuibq55KKHnZuk7s6BBxQwK6Zto1qDIKhXspVM/JZpOv7dCDTzOm8+z+VT0H+IyUmHnqX8b6JoL2qV6IdhOl/2v3WdSsJOrqR8hoxd+J844vToKI73q2/l0uR66zHGaFVGCloJO+XOD6uPqZqcP0Qk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757504201; c=relaxed/simple;
	bh=/EBAEzJrIUjcis1QIAn52OcOMR/icANe1JMqxQaGx/o=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=m1S9v9JcnXTSz4htYPj040OxnCOgYM8oZxy2GRMahdyH8cOOH5QLe9msMol4dzq6yqbIAjVaj8IO3fXRw/h81OJxGia7Qn+mSqWgbIC5IwcIJRVZco9QHGRzgcA7AfsAx/OMYo/6mqqan66ulz8CKfkZrE+zzPH4CUAzXp11CiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DVaCQnF7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A3e2hZ023376;
	Wed, 10 Sep 2025 11:36:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/EBAEz
	JrIUjcis1QIAn52OcOMR/icANe1JMqxQaGx/o=; b=DVaCQnF7VTnhdAF4iArYvt
	+lneaFSkdj5ba+KNP9l3rTzSBRNJnzRrZC5XBLp6XxjiKvBHhq4zbBqENMhkIux1
	2bm/q/31GLwtDiASQMkQdPwvYjJAayE3chsUVvMFY7t3u8g7giA/Wl8KSKhkfOT9
	W3PiBmXHfGpRt6K683jCfYRnDoz61d+P+QNwCUAp0wPag8MWMqxEJU7egwNbwrvo
	gRoeSzjBal84HhgHpZc0IESBJb/wjma3p6CbpbmsKmhdpg3P8IfpZKfIwB1qFCZ5
	KzZJdLcMrI79vwAjc4BE5QHROVVsTkko03V3lv3vqISYB6ZWc+PRE0KxaZvIgYPA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmwwrj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 11:36:34 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AAHLOn010613;
	Wed, 10 Sep 2025 11:36:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910sn04p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 11:36:32 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58ABaSDs19530060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 11:36:28 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5F5F2004B;
	Wed, 10 Sep 2025 11:36:28 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80E2820043;
	Wed, 10 Sep 2025 11:36:28 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.202.117])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 11:36:28 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Sep 2025 13:36:28 +0200
Message-Id: <DCP38M1VQ9IY.32HM6G6NY3ASZ@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, "Andrew Jones" <andrew.jones@linux.dev>,
        "Janosch
 Frank" <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2] scripts/arch-run.bash: Drop the
 dependency on "jq"
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Thomas Huth" <thuth@redhat.com>,
        "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>
X-Mailer: aerc 0.20.1
References: <20250909045855.71512-1-thuth@redhat.com>
 <DCOYKSEY6V79.3HE423J6WWXTT@linux.ibm.com>
 <20250910110007.26fa1643@p-imbrenda>
 <5b8240d7-d3e9-4b8b-bc77-731fb2fb0001@redhat.com>
In-Reply-To: <5b8240d7-d3e9-4b8b-bc77-731fb2fb0001@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 07aDisHAxPK0nVcqImSezV9H7-qqpX-9
X-Proofpoint-ORIG-GUID: 07aDisHAxPK0nVcqImSezV9H7-qqpX-9
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c162c2 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=P09Wm3z3z8vu-dnEbn4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfX7tIHWTfTdN6h
 pR7rIG/tUiW+f+WfcqH0BxCu/3hFLzadrGsKxcUEYKs1+nxtE1xA4ho174Ogu0KIGgCqfR5fIyg
 caKm+NgI1vL6h2LgKOjItNSDHCFJkl3fkConhnIcqpwyeaao2gP+d7vgLYnskHMI8dZ+MJVwya6
 NetK9HZwLdQzVADEn0tDXQhjTrk5erTbFH0WJbJtuwr2YHPM5ajh06ROiedVQA85E0ZuyTGqJ8j
 azdNkqXUagXBoLScoUdlTVaJTNdW9/xLZNB8gU554+cA2+5WYjqWUssSJLWBNa8PIGZrwn+tk9L
 9M0HpYW21yOcpulpeGIjq6eOekOeMwCRfXpcuLumoZBeMQK1T5O6u6pII47rOVvVrI2DU1llgji
 LCcHQrge
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_01,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

On Wed Sep 10, 2025 at 11:06 AM CEST, Thomas Huth wrote:
> On 10/09/2025 11.00, Claudio Imbrenda wrote:
>> On Wed, 10 Sep 2025 09:57:17 +0200
>> "Nico Boehr" <nrb@linux.ibm.com> wrote:
>>=20
>>> On Tue Sep 9, 2025 at 6:58 AM CEST, Thomas Huth wrote:
>>>> For checking whether a panic event occurred, a simple "grep"
>>>> for the related text in the output is enough - it's very unlikely
>>>> that the output of QEMU will change. This way we can drop the
>>>> dependency on the program "jq" which might not be installed on
>>>> some systems.
>>>
>>> Trying to understand which problem you're trying to solve here.
>>>
>>> Is there any major distribution which doesn't have jq in its repos? Or =
any
>>> reason why you wouldn't install it?
>>=20
>> I think it's just a matter of trying to avoid too many dependencies,
>> especially for something this trivial
>
> Yes ... actually, a while ago, I noticed that I was never running this te=
st=20
> on fresh installations since "jq" is not there by default. I guess it's t=
he=20
> same for many other people, too, since we don't really tell them to insta=
ll=20
> "jq" first.
>
> So let's give this patch a try for a while, and if we run into problems, =
we=20
> can still revert it.

Acked-by: Nico Boehr <nrb@linux.ibm.com>


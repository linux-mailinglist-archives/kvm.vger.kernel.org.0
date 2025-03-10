Return-Path: <kvm+bounces-40646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CE9A594A8
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8FD23AA4C4
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF76322579E;
	Mon, 10 Mar 2025 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZduK12QS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D81721ABBF;
	Mon, 10 Mar 2025 12:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741610298; cv=none; b=R8CiB6qPF6nNFRahGQbdEOa5IePdE5GUEGooqb/DyymiG/M59YBb2lBKHB7g4BeORSsQgxu4ZurV9iDV78UL9Npt1LubAJ8MxKF1i1ENgrl9XdfT7GES296YCyANh7OLSOR2uXlfv3e16/sVF4giSW29z51MfIiOp5NFSNo9XgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741610298; c=relaxed/simple;
	bh=JXR4+10SNV0hKThI0ToqylAIm5f+vi3OmJs1mvD5UQA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=XeVQ/2EDcD08rlG+BpCbyZhvWr1SQbQmJysWJjjAr5wv+fObQqfmJd5xsNyG1ielo9nKh1GqVN4V6wU5+rlz4/XV7EU9myM2S4oDzO/IQqwCxdIe4NDoG7pVIfwwfqULMSCotW3+QLm1dMLXljIiRwE81Mkp0XQvxFgotHlDQfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZduK12QS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52A9Aagb005563;
	Mon, 10 Mar 2025 12:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Wih/Xz
	fRmD19ygp1y6a3M1Sqr8MDTw2pPgGQRDO0Rus=; b=ZduK12QSu1IMwJQ6WAdK2G
	H2aVMJL2oI3IIaODIYX+EkXIZPnk6cW1DJ2VJImVIwvhby/8s+lKvf2mmbOHxPJz
	Vubh3+WNmPMMB+c2hxHBB50clPoQy01kKE/fz8uKF2EN42j9vTNoEFMF3nJbBPnI
	VK5Tb4X8o/zAjGeuAwdsNHgwBGT5Z76jAlb0upq3mSaG8UXyCgl+vLSoOIsb9dLt
	GSFM/ci/EUi3XKSk2VKQo9FsDJzg7fd6CbzwQGA16/TM5kg5kXKn2MYi4ri8gI1h
	+Sl1yAgrkcGz7/rfKwbFxwsN1AmRpiBitbUn/9lqqYU9tu1nvTYoJDcQAQrsbt1Q
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 459jd4u852-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Mar 2025 12:38:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52A9drWU006982;
	Mon, 10 Mar 2025 12:38:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45907sxt3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Mar 2025 12:38:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52ACcAdb36045168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 12:38:10 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A8C220043;
	Mon, 10 Mar 2025 12:38:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 822AA20040;
	Mon, 10 Mar 2025 12:38:09 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.78.164])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 10 Mar 2025 12:38:09 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: pv: fix arguments for
 out-of-tree-builds
In-Reply-To: <aa9bd929-e2b9-4772-9802-171c30036dff@linux.ibm.com>
References: <20250227131031.3811206-1-nrb@linux.ibm.com>
 <aa9bd929-e2b9-4772-9802-171c30036dff@linux.ibm.com>
Date: Mon, 10 Mar 2025 13:38:07 +0100
Message-ID: <87zfht12og.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5LF8WJoLj8DaJ5lDdbAmLriJKPKX5EgS
X-Proofpoint-GUID: 5LF8WJoLj8DaJ5lDdbAmLriJKPKX5EgS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-10_05,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2503100099

On Mon, Mar 10, 2025 at 01:20 PM +0100, Janosch Frank <frankja@linux.ibm.co=
m> wrote:
> On 2/27/25 2:10 PM, Nico Boehr wrote:
>> When building out-of-tree, the parmfile was not passed to genprotimg,
>> causing the selftest-setup_PV test to fail.
>>=20
>> Fix the Makefile rule s.t. parmfile is correctly passed.
>>=20
>> Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> ---
>>   s390x/Makefile | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 47dda6d26a6f..97ed0b473af5 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -213,7 +213,7 @@ else
>>   	GENPROTIMG_PCF :=3D 0x000000e0
>>   endif
>>=20=20=20
>> -$(patsubst %.parmfile,%.pv.bin,$(wildcard s390x/*.parmfile)): %.pv.bin:=
 %.parmfile
>> +$(TEST_DIR)/selftest.pv.bin: $(SRCDIR)/s390x/selftest.parmfile
>>   %.pv.bin: %.bin $(HOST_KEY_DOCUMENT) $(comm-key)
>>   	$(eval parmfile_args =3D $(if $(filter %.parmfile,$^),--parmfile $(fi=
lter %.parmfile,$^),))
>>   	$(GENPROTIMG) $(GENPROTIMG_DEFAULT_ARGS) --host-key-document $(HOST_K=
EY_DOCUMENT) $(GENPROTIMG_COMM_OPTION) $(comm-key) --x-pcf $(GENPROTIMG_PCF=
) $(parmfile_args) --image $(filter %.bin,$^) -o $@
>
>
> We had this hardcoded, then changed to this rule and now move back to=20
> hardcoding, no?

We probably have never tried to build KUT out-of-tree.

[=E2=80=A6snip=E2=80=A6]



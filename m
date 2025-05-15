Return-Path: <kvm+bounces-46685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64E64AB8750
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 15:07:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03BCF1652C7
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 13:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62ACA298C12;
	Thu, 15 May 2025 13:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hT/iDWPz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E782253B2;
	Thu, 15 May 2025 13:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747314453; cv=none; b=dqgRFW5bP6AzGzveHF6lOk/l9vmHO3Bv1VMT7Vuokjz/3oJkgeldeaO70FWr1hsE1qhUGVBb8VS8+ppQ+rmG9npFFAG/CIDiXsR3811J8mMMaK5mlIctz0mYbk0fAPl8GcBTqJ+d2UNIeqp4x/CWVhC0PnAYUt5C1O1SFeEfvY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747314453; c=relaxed/simple;
	bh=dti+lgJn1Syc0W6MbBJ99R1VIIaW6s5R2SxzAJIFo1o=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=dIF1Z2QN0qxkmsxMtJG+7YvQ/o5KFhyO0sbOjEi/DnsFFfccCkCtFDpSp6mggwqSL/oeR7upYwcSYy0wggFea8ObcBBYintzzKsP4UpB8faz+vBtZwwihJb883nBCPXqdydBQ9hKxMUfUAp0ly4+WcJmwruM/ZRtgdcBFvF815Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hT/iDWPz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FCg42Q030411;
	Thu, 15 May 2025 13:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dti+lg
	Jn1Syc0W6MbBJ99R1VIIaW6s5R2SxzAJIFo1o=; b=hT/iDWPzm4EkjyCx1m8N3v
	fjQXGUlTCCpooRxz9ZY73GkflvXqaaTsk9140f5rJ5vx5J4EVetc8W3m9ZqMwlMS
	1ONRYoxOAJtekz/jFQIqVp+s3pvea4leR+7hONaMe9+PM/c5RNGx0cCgQVwvn+04
	re0DSJhTZXS2N271ZKK636bJR7gmbPeuPH8S3u9VUGimLTdbmBnyJg7Pt4AS6ymF
	D37Pu1CI+42c3wqWJvlRW6ZVTj+c9rK9CIlUxeOG3x7onQCQcJOjtzH8geawysrK
	74uNCX/+/Mj1CBgDTbxpgQeazNrvqg03pGkkViL1wOsXPUcTV3CqDfomYX5eHqHQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mvd3e5uu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 13:07:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54FATp6M024273;
	Thu, 15 May 2025 13:07:27 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfsaa76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 13:07:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54FD7Nxn57934098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 13:07:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE3A120125;
	Thu, 15 May 2025 13:07:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9BB320123;
	Thu, 15 May 2025 13:07:23 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 13:07:23 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 May 2025 15:07:18 +0200
Message-Id: <D9WR9VL90Z44.34FLLVUM55PGQ@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>,
        "Christian Borntraeger"
 <borntraeger@linux.ibm.com>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Heiko Carstens"
 <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander
 Gordeev" <agordeev@linux.ibm.com>,
        "Sven Schnelle" <svens@linux.ibm.com>, <linux-s390@vger.kernel.org>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH 2/3] KVM: s390: Always allocate esca_block
X-Mailer: aerc 0.20.1
References: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
 <20250514-rm-bsca-v1-2-6c2b065a8680@linux.ibm.com>
 <20250515132448.5c03956d@p-imbrenda>
In-Reply-To: <20250515132448.5c03956d@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 40r_P_Wx79Jxtm5oxdv0qAkIpjbwYgYp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDEyOSBTYWx0ZWRfXxE+sxI+d8gGx p4vpEKejSkQJGkwdJb4xuSNZutsaGQxVu8SGNLLtV2xATVWloJmqiJgaMOCFw2nckh+xQ2SpT9c 3YoSSVLzS3Jr+7r0yC04BsuCi2LrgDtOSEo0MgptwzSbesXWzxnWqFRiFvlYvVgzvBXLfmAmVNu
 XSTgqKkuDe2LrQWgN/C88qUFVUe+LdeU1S/W+AU7zUvjciqPDekXJZyDe9gch9RmvfB/T8PG/1Q 9VlWHQbyE549T/kPwR/5QDtS8cogGvy7CDhSOdDEj864pd3mnXZ9FNZooK2bqVKTpGyFvPK6ANv cgYhm/hQ3+fyYrme1YLV0fsvluNKxdw7S72GdATa1uGxgNN0tRVozx1l+5u5MZdcPj5UY2FGAHx
 10X9TXfjIA57PmOeRGAk/LpQ5jVwO7TVaJ4G9atS7a4U+SmwP+CCw6wUIjCgMlV/Xwo+hg2c
X-Proofpoint-ORIG-GUID: 40r_P_Wx79Jxtm5oxdv0qAkIpjbwYgYp
X-Authority-Analysis: v=2.4 cv=GbEXnRXL c=1 sm=1 tr=0 ts=6825e710 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=dQrG6oB7o3M4uFuVAdwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_05,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxlogscore=697 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150129

On Thu May 15, 2025 at 1:24 PM CEST, Claudio Imbrenda wrote:
> On Wed, 14 May 2025 18:34:50 +0200
> Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:
>
>> Instead of allocating a BSCA and upgrading it for PV or when adding the
>> 65th cpu we can always use the ESCA.
>>=20
>> The only downside of the change is that we will always allocate 4 pages
>> for a 248 cpu ESCA instead of a single page for the BSCA per VM.
>> In return we can delete a bunch of checks and special handling depending
>> on the SCA type as well as the whole BSCA to ESCA conversion.
>>=20
>> As a fallback we can still run without SCA entries when the SIGP
>> interpretation facility is not available.
>
> s/is/or BSCA are/
>

With this merged we do no longer care for the BSCA. So I will change this t=
o
s/is/or ESCA are/

I will also apply the other changes for the next version. But I will wait f=
or
more feedback before sending that. And I will run checkpatch with the stric=
t
option, which I clearly did not do.

[...]


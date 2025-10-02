Return-Path: <kvm+bounces-59426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F83BB4271
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 16:19:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6B1319E24E3
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 14:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26CA73115B9;
	Thu,  2 Oct 2025 14:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YZ3T7oYS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A6223E35F
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759414774; cv=none; b=otl1YYh80YIa71AHh01jMCIMyMYJirghawhYfCL6OMWk3rDBU32Vv5gZKMJbxG6eSXDk0ym2i+GvXQroQbj+Itsv161YfyE27qpYapwMovxrCUYGGfG87KT8a7hx8A/IGDb3R1y2NyRrXAxutplIJjGDPLQ9ghnw3qSKSVtJL98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759414774; c=relaxed/simple;
	bh=65zFVlSSmosjvvMD0Oewsnbw/B7V/B+dLTz/nwk4sAo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fcTsfLrMgG61TWJO6SxcnYXFto4KZvurjE2g/7HXe8ry7dg64uBBvjU4kuIM+7eXIqlREMRxZ1ecAWllA57FwMcJi9d0nWl1i2SemZbuhWrxLjGol84cZr3sah5+uux59sZMsLdMZWdQMEu2Vr/wa7Y05bzEwcf06UdXxjorobk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YZ3T7oYS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 592Dli3i023759;
	Thu, 2 Oct 2025 14:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=y8rgWF
	TA/jAky+4tOgWs/IrypMG5lRe1CSzzdhuztDk=; b=YZ3T7oYSQUiQPLYeOqi8XU
	jHKBK2p4GTYFgGA+THHlRd/uq+PJq+7nBmU3ymozDCJA41LgOXm4Oh/NJWSi1o5E
	xQ+hqQGCE3Qh1Zv3ZMt+f7jjgbixaHr5hKfkqXDzyc2VnE0d4roZRuDQHwHCg0ml
	id2awJkHeO6/FEm7Qf8++9BCW7q2+diSkN1pjZhFM+QCksfSlZ2xZ0W31zfMNwJT
	Oh1HyGHkYxlgBQllLv2rVF1+ECo/NLymMmx8kqOdkQB/eulGGeloIXaWZaXcjiIi
	ZkS7wyEASo1mgh8VJ4rEShj/xMOwZ2G+iOI1TL67+UwLKdqmei6prwWEbHwiXa8A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7n85vek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 14:18:56 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 592EFbxk031251;
	Thu, 2 Oct 2025 14:18:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7n85ved-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 14:18:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 592Amljb024198;
	Thu, 2 Oct 2025 14:18:55 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49evy1dyta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 14:18:55 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 592EIrsC27394492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Oct 2025 14:18:53 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40B1B5805E;
	Thu,  2 Oct 2025 14:18:53 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 835EF58052;
	Thu,  2 Oct 2025 14:18:51 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.134.141])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Oct 2025 14:18:51 +0000 (GMT)
Message-ID: <a096882c56c9928018f99cb1554aa826a8c71bb6.camel@linux.ibm.com>
Subject: Re: [PATCH v2 03/18] hw/s390x/s390-stattrib: Include missing
 'exec/target_page.h' header
From: Eric Farman <farman@linux.ibm.com>
To: Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
        Jagannathan Raman	
 <jag.raman@oracle.com>, qemu-ppc@nongnu.org,
        Ilya Leoshkevich
 <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Jason Herne
 <jjherne@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        =?ISO-8859-1?Q?C=E9dric?= Le Goater	 <clg@redhat.com>,
        kvm@vger.kernel.org,
        Christian Borntraeger	 <borntraeger@linux.ibm.com>,
        Halil Pasic
 <pasic@linux.ibm.com>,
        Matthew Rosato	 <mjrosato@linux.ibm.com>,
        Paolo
 Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Elena
 Ufimtseva <elena.ufimtseva@oracle.com>,
        Richard Henderson	
 <richard.henderson@linaro.org>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Fabiano Rosas <farosas@suse.de>, qemu-arm@nongnu.org,
        qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>,
        Alex
 Williamson <alex.williamson@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Date: Thu, 02 Oct 2025 10:18:51 -0400
In-Reply-To: <20251001175448.18933-4-philmd@linaro.org>
References: <20251001175448.18933-1-philmd@linaro.org>
	 <20251001175448.18933-4-philmd@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XXfexHqzAaPaFMY6qWzpc1504AUjM6aG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX+HlAZbbI0R7R
 cLkuSwoba3iGQPS9oC0VhXAGye0ktHFb3f4yam2FrgjzbARCuyaVUs1tqzvdWMXkoKwXHGiRYA5
 OCngFfBfLtYlUrljVirZaUeitzDovISKciIexR+D+fBTd4VI67mMBiDEGzq2rsn4fTsUT9zwIE7
 SXSFVSGkHMJkc2WemR/y2oRZxNt9xxlBRFxMq1BI8gPdL7jv2Vx6VxwBTngy0YrwVEHJPoUFsbl
 x4lTly8vRoxP8RABG69UBEtX+U2OLqPtYOd5nexrciqOEaRmfEcTvmux7h6cZhtAiwoKo3EQFy0
 +91233/IPmZvaXJopKb9k/InSUIpIDMx+oOpISOSpCJzSXbQxF+qOoYc9pPhr9uDiqlGSWyfKj+
 qmeeeG8NW40mUiUWt2IdbXWuyvBttw==
X-Proofpoint-GUID: d3NTocKVIFExyZOpJ9sneHc9YgSsjIEH
X-Authority-Analysis: v=2.4 cv=T7qBjvKQ c=1 sm=1 tr=0 ts=68de89d0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8
 a=oNFF6uGEv09ksA5f1voA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_05,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 clxscore=1011 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

On Wed, 2025-10-01 at 19:54 +0200, Philippe Mathieu-Daud=C3=A9 wrote:
> The "exec/target_page.h" header is indirectly pulled from
> "system/ram_addr.h". Include it explicitly, in order to
> avoid unrelated issues when refactoring "system/ram_addr.h":
>=20
>   hw/s390x/s390-stattrib-kvm.c: In function =E2=80=98kvm_s390_stattrib_se=
t_stattr=E2=80=99:
>   hw/s390x/s390-stattrib-kvm.c:89:57: error: =E2=80=98TARGET_PAGE_SIZE=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98TARGE=
T_PAGE_BITS=E2=80=99?
>      89 |     unsigned long max =3D s390_get_memory_limit(s390ms) / TARGE=
T_PAGE_SIZE;
>         |                                                         ^~~~~~~=
~~~~~~~~~
>         |                                                         TARGET_=
PAGE_BITS
>=20
> Since "system/ram_addr.h" is actually not needed, remove it.
>=20
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Reviewed-by: Eric Farman <farman@linux.ibm.com>


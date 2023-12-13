Return-Path: <kvm+bounces-4379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5747B811B79
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88C3D1C211B4
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B799856B90;
	Wed, 13 Dec 2023 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ehI2Rx5T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75095114;
	Wed, 13 Dec 2023 09:43:59 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDHM3sY027119;
	Wed, 13 Dec 2023 17:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=rOalKLqyZGkUdDuZYx68gob0a7WfqQ72TBaSzb8TJyc=;
 b=ehI2Rx5TlP0w0nBjq+BxbrR85j1ELe17grCBpEX/tv1iiuuAVAxFebW4moUO+UxIPbFE
 fP48e2vKtVGvu9HFxbmrS3T4ES6MYYatmcWPopzAvZJZujlpO4H3YqPwee6PlB5yd3jm
 cUVXv87fr9mWpmKvCkY9+5pYz8dbt6kQChb3nBniRgs5YM9FuLTf/Yv4BthtjNvWgPny
 AVbC+j5nwM5F/fb923juIKZiFEcwwbO70GTOgPrVnDCm77V6NU7NHSRosTofLH9uWGKg
 mbOGp+hM0mC44OH7hXgDvZR5PEfTYy9gwX/syQs7jSfkTtiAAwTUfOjIhYrBeHcsBzvI MA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyf72cme3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:43:56 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDFQ9ZY004664;
	Wed, 13 Dec 2023 17:43:56 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyf72cmdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:43:56 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDH1OB1012616;
	Wed, 13 Dec 2023 17:43:55 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw3jp2kdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:43:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDHhqxx46006720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 17:43:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A6DF20043;
	Wed, 13 Dec 2023 17:43:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F36A20040;
	Wed, 13 Dec 2023 17:43:52 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.91.103])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 17:43:52 +0000 (GMT)
Message-ID: <ed6b4a7188389617ffc85453e9270ffadd863a01.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: Add pseudo random functions
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Wed, 13 Dec 2023 18:43:51 +0100
In-Reply-To: <20231213-8407f7ddc3a972de2715db9c@orel>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	 <20231213124942.604109-2-nsg@linux.ibm.com>
	 <20231213-8407f7ddc3a972de2715db9c@orel>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rItIW_XQv8SGgsojTgvHnGsCsNzywwNa
X-Proofpoint-GUID: xx0Po4CakrUAijbKWiUno9wsHuJFrNOk
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_11,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=488 lowpriorityscore=0 impostorscore=0 spamscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130126

On Wed, 2023-12-13 at 14:38 +0100, Andrew Jones wrote:
> On Wed, Dec 13, 2023 at 01:49:38PM +0100, Nina Schoetterl-Glausch wrote:
> > Add functions for generating pseudo random 32 and 64 bit values.
> > The implementation is very simple and the randomness likely not
> > of high quality.

[...]

> Alex Benn=C3=A9e posted a prng patch a long time ago that never got merge=
d.
>=20
> https://www.spinics.net/lists/kvm-arm/msg50921.html
>=20
> would it be better to merge that?

Well, it's hard to say what metric to apply here.
How good does the randomness need to be?
I chose a minimal interface that should be amendable to evolution.
That's why the state is hidden behind a typedef.
I think this would be good for Alex' patch, too, and there is nothing gained
by exposing the implementation by prefixing everything with isaac.
My patch is also simpler to review.
But I'm certainly not opposed to better algorithms.
>=20
> Thanks,
> drew



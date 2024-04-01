Return-Path: <kvm+bounces-13293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CFAB8945CF
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 21:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E86372825FF
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 19:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3369453E14;
	Mon,  1 Apr 2024 19:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MtHMONJu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7404E20304;
	Mon,  1 Apr 2024 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712001503; cv=none; b=Jt0uFy1YJuVOC0WMAO3WSC4h6BqB+p4K/Gb6oUeM+hOR1rFqdbP5DXiQap9MmH4Hc0QnRoNTrDNXq64KUSmQK+HY0nvMRYbqHotW/oKgiG1GmpsnORHI39ZC10/REMP+kdWJscCggNfYOqxbxG2jdwnFHZAQxe4u8o7InvJBYIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712001503; c=relaxed/simple;
	bh=aZXSfjaMBc291x0r5s10KrZuyuUQ5nACgOTXqz/o1xA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z7Z9cuDMKJCDV5yUgNV+Y012eg6zM0P0gniJSfqpJ3BTzH651zFPdRVNrfcIyzQAG+hgj9HAa+v4wPBe6Obq1QSyGVgSM2pBb/yUYiTMSCvodrMaRiZvmMf0ar6lBYGgn2g7tsnddqryg4EsKMMKT51jKcz+8cWOLKCuFNfhvq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MtHMONJu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 431JvMSh031777;
	Mon, 1 Apr 2024 19:58:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=aZXSfjaMBc291x0r5s10KrZuyuUQ5nACgOTXqz/o1xA=;
 b=MtHMONJuWI4BS/OncPb0G7UrCd5a1+upLwg++2BRNDWxwG8OTvS/RePABsXe2if5KM4C
 dDkuazOhECPw8qR+s4101+Zft/cEIzyqHsY2YIa3hX88Q4l4oF1oTV8QcQXF6cFvOIZj
 zDCxyI5AksU/IVWVVJWYJE3daa6gbNXDjDjlm6ThtFbOc8GsVoB4cM3v040OVga5p6G1
 AuBAWS0Kz/yOzSBGzC10SPzScenKFWuo+7fKvyVdiJLyo/JpI5j+onOnzcxnq+0Z6mfL
 PpUIV1+gheVFXjFIE3250QLz8q6OL2F+0ET4DDid0vH0rgpTPAtaImyepWK6lc0tYfGj Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x83hhg036-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:58:01 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 431Jw1S8032297;
	Mon, 1 Apr 2024 19:58:01 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x83hhg030-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:58:01 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 431Ixw7p002194;
	Mon, 1 Apr 2024 19:57:59 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3x6xjma0by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Apr 2024 19:57:59 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 431Jvu8Q27067096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Apr 2024 19:57:58 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7F5B58054;
	Mon,  1 Apr 2024 19:57:56 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AAFE65805A;
	Mon,  1 Apr 2024 19:57:53 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.184.184])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Apr 2024 19:57:53 +0000 (GMT)
Message-ID: <cbdce01bbf2843062f4afd7e5c9af767e69cc70b.camel@linux.ibm.com>
Subject: Re: [PATCH vhost v7 0/6] refactor the params of find_vqs()
From: Eric Farman <farman@linux.ibm.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
        Anton Ivanov
 <anton.ivanov@cambridgegreys.com>,
        Johannes Berg
 <johannes@sipsolutions.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Ilpo
 =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Vadim
 Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck
 <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Michael
 S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason
 Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
        platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 01 Apr 2024 15:57:53 -0400
In-Reply-To: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
References: <20240328080348.3620-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CVJdQ_e6TRRp_yDfdRwGfh273GvCB2h1
X-Proofpoint-ORIG-GUID: Ruk7klDLWbFbZ4w-u3ObzCq-1Zf9Ly1V
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-01_14,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=924
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404010139

On Thu, 2024-03-28 at 16:03 +0800, Xuan Zhuo wrote:
> This pathset is splited from the
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0
> http://lore.kernel.org/all/20240229072044.77388-1-xuanzhuo@linux.alibaba.=
com
>=20
> That may needs some cycles to discuss. But that notifies too many
> people.

This will need to be rebased to 6.9; there were some conflicts when I
tried to apply this locally which I didn't chase down, but it works
fine on 6.8.

Thanks,
Eric


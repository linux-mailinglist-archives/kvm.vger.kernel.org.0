Return-Path: <kvm+bounces-30190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 057729B7D74
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:59:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE929280E8C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 14:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51ABB1A4AA1;
	Thu, 31 Oct 2024 14:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LmMBR/uT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3A119D899;
	Thu, 31 Oct 2024 14:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730386756; cv=none; b=LP17KpLQUqrcfN6Txlso/cWAdeWz/Hu96Sj7C5ENAJt2bfpbtzjzjnmPF6qN0/S5MFRk/L3yax5UReFMZ9VbeQWeq7ku0mnmd1OwWSgfE0FBf5lWjGoPoxyH0IPdZUwC45qqTniYhj5unMFT1WHbW3xM11hrlQlRnWVEHx4kiDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730386756; c=relaxed/simple;
	bh=w08rSYQLpMv4/w9G1kNlicSmxpZKdDP9rwu7geEi2A0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dejAa9VqTuxlwp0V4o0Gr0D3hJaSWFaakPyjbF7P3NPzDifW/TqQXuWNSswaYh1ZqnVvGBPrDdxQ/1OeN9zTH4CtmaRqleRPdCkZgYP6OWBRr9z5/qrNvjDRR+T+8AaHZkB+GINvJ7mc0jm11qW+3bcqrI9EagfPftBMJp4w9lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LmMBR/uT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V6ugLM011777;
	Thu, 31 Oct 2024 14:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=u2NVl/
	Oa2KdvVlgSYT5v0F71qHOJA76FTq1g7ZvxJfg=; b=LmMBR/uTs23YX83UdzHxtN
	fdehUJm4XSBJcKDInlyM1OE25JCkVX7HQL/X7ESeb2LdRCtipWBeOtd2MTH4F6yw
	d9koRAOpjOxKSFwsGMdLCAyFx/srfaJ5P9T8GlC5AOmL7Ksql5ldrT/VP0aEXoaK
	+5EVAsXGOg/xiW5rzMcWdhhUHLG5Ome4EtJR3bLU6dY94U4Dn2tQNvAzamXj2ovk
	fashobikz1meYPKNmiOgllFo6IwlV08D08jZCdwwhn5GWWJUQNSQy680omtz8h2p
	XHS07tO/tzxH13th59kurpP7l/ZmAZes4OimQa1iDeeBX8qH2kjRT2YGzMfQAdWg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42m52ca13k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:59:04 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49VEv7G6032735;
	Thu, 31 Oct 2024 14:59:04 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42m52ca137-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:59:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VDUEhC028181;
	Thu, 31 Oct 2024 14:59:02 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hb4y5dt0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 14:59:02 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VEx1Cl52429088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 14:59:01 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15EC958052;
	Thu, 31 Oct 2024 14:59:01 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FEE658045;
	Thu, 31 Oct 2024 14:58:58 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.67.19.177])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 31 Oct 2024 14:58:58 +0000 (GMT)
Message-ID: <8dd6c82b5edab68d8c53fe0a7dd588cd2e93036c.camel@linux.ibm.com>
Subject: Re: [PATCH v3 2/7] Documentation: s390-diag.rst: document
 diag500(STORAGE LIMIT) subfunction
From: Eric Farman <farman@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck
 <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Date: Thu, 31 Oct 2024 10:58:57 -0400
In-Reply-To: <20241025141453.1210600-3-david@redhat.com>
References: <20241025141453.1210600-1-david@redhat.com>
	 <20241025141453.1210600-3-david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UMvKYKUyiDpa41PiwYQX0lg6bZooazFj
X-Proofpoint-ORIG-GUID: _qHllUguooBsxg76tcbqCJ_tQXBigEhp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=802 mlxscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410310113

On Fri, 2024-10-25 at 16:14 +0200, David Hildenbrand wrote:
> Let's document our new diag500 subfunction that can be implemented by
> userspace.
>=20
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  Documentation/virt/kvm/s390/s390-diag.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Reviewed-by: Eric Farman <farman@linux.ibm.com>


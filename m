Return-Path: <kvm+bounces-30004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A0D9B5ECF
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 10:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32DC11F227EA
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 09:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A2D1E22F3;
	Wed, 30 Oct 2024 09:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EyZLJpl9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4353C192D79;
	Wed, 30 Oct 2024 09:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730280299; cv=none; b=gyKUaMtpDmocPKMDmDyXvFnMyp7/ztsx1qtLAPH3LwkvJ3GwrV0i7BYyw7/CK+zghxLdX4x50Fd3zqHp5I8jWYO1FPah2qBWsGVt6MJSSuQjhFZ/N38ax79544Fsd10DgSSPgOyEXUChV4Su43w06kJOcZC+OZGtkFkHmH3gbRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730280299; c=relaxed/simple;
	bh=PsMyFeg6/U0b2+gD623nmXACdY70+h3lkmnj3WrdUUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CsvAgDt+UK29r/GEsIbVkohJ+UTXESWhB8cTwhd9bKrLljniybSxDq0fBO0NGqEPuDubacn2XShEL+jr35h8dg+UxQnfhbnsosiVKg+Ybi1aLL0XBfkjh4IPt96O5q8kWo80LFrgH7vT3TV2k6Mci3UY059CXQZQXzquZOs8IkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EyZLJpl9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U2d2SO003165;
	Wed, 30 Oct 2024 09:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ohlJFpPJgUYvXIuurbOsvgXkgiWtRk
	SjKlQbI1R20O0=; b=EyZLJpl9QwWL/QRyQeIwpXbX2xfFA5lFkfq3AZWz9zZ0zg
	RTvKkCpCggMM3DSgSM5ziAY5de2EASoS5DQcs0U+D5ciEKLJ9teaXIVq+xwYnnsW
	m6bnWAptp8r3OI0+eBM4nDTeS2V71FMOJeO6LTZXXgdoZRkUs6728DOMKloMlX+w
	xmjv/uR/6OMNq+PahBoHGFrpsUcR5hSBN5a/DR4wTrvdlgWmMv8ZCDiOpfFvlB/x
	xd/QmFC/sgiKfznA/ano8te606UHTtUXv3iIVttmond4C9xOz5TGdkRjLmOIf4/e
	O169NfvE/HewhXIjVxhkya0+l/ccvtM6pdq1KUBw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nsx97f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:24:47 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49U9OlDM017220;
	Wed, 30 Oct 2024 09:24:47 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nsx979-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:24:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49U7kAo5013506;
	Wed, 30 Oct 2024 09:24:45 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hbrmybsg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:24:45 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49U9Og0w55902590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:24:42 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DDD82004B;
	Wed, 30 Oct 2024 09:24:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25E2420040;
	Wed, 30 Oct 2024 09:24:39 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 09:24:39 +0000 (GMT)
Date: Wed, 30 Oct 2024 10:24:36 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v3 4/7] virtio-mem: s390 support
Message-ID: <20241030092436.6264-F-hca@linux.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
 <20241025141453.1210600-5-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025141453.1210600-5-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WS_zGOBJrHz8SogXKaAacCCgWcwYITJ_
X-Proofpoint-GUID: p4PFsiyfxJufSPBaNiEv4h9-crDaOym7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 mlxlogscore=642 clxscore=1015 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300072

On Fri, Oct 25, 2024 at 04:14:49PM +0200, David Hildenbrand wrote:
> Now that s390 code is prepared for memory devices that reside above the
> maximum storage increment exposed through SCLP, everything is in place
> to unlock virtio-mem support.
...
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Tested-by: Mario Casquero <mcasquer@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/virtio/Kconfig | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>


Return-Path: <kvm+bounces-42581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90213A7A377
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 15:13:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39D82172346
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D5AE24E4B4;
	Thu,  3 Apr 2025 13:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VMOxqC5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD4F24E004;
	Thu,  3 Apr 2025 13:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743685986; cv=none; b=BHptxGcIi8w7R0ndmRTHGDT3ExdLJcZu+QWpAyJ9Cobqc+MKWCL1pXpY5vz1K3fqSUnFdIJ9D1Ds29YCzWDQ2K5DI7uQqkHuHeRw+Jm0fJD4szzd3mdbFfhMN6HL7CvCGkLxx2t6ss2KvfK1pTi5PvpRAHWJ/sfwvIKdqQ1s1DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743685986; c=relaxed/simple;
	bh=5PQtbwEoH1ime2NIIHH/Tl3NtKI6Qa7OnDQh1ZfSalM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kRWM0oS52pS/T6VHgxG2WBbi28sbVBZam3aSt/TE9CmUXVSzIIX47YwDPFsScff2sblJOuCQ5fBJKIBb8JY8uCOaCvuuYOBhem8lMZ9LetGwDXUd9DsW5jEMUGIZKhz8hE/fydBhh6Kk1zC5XUEGUYJig29XXjNcVQULw+Fxdfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VMOxqC5Y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533A9Fhs024797;
	Thu, 3 Apr 2025 13:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5PQtbw
	EoH1ime2NIIHH/Tl3NtKI6Qa7OnDQh1ZfSalM=; b=VMOxqC5YnuW2Hj7Cb7CVYb
	g31xUYj4c/zUEYA9w40rGsdUWmpXq+xNgeIOoRBPILaIKfzK6KPXcoKuC/QHJm8p
	r3fpH/cWOzrR6vyihIc8q+eVkPpTT4cAcB/qIiJtktIT25aLA7CObemupkc5+Fik
	ITv6W7abukMgg6fLVrTMJve/8DpS1qzU5arYXq+2qLp/ji5PN83kwmEWmOOHv2CC
	KIh4yhFjVUvF8qRTHtai2plpC5XWQcBkZVJZmC1K4td2Fem9nmMBcZkKDgRF1FYw
	ZsFvTUCNWTKgIQY+v4jqCXYNc0R2dWuoNeHt78MgB39NXJutogPIqi0U8vPkMeeQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45scdr3r38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Apr 2025 13:12:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 533A1jvB009923;
	Thu, 3 Apr 2025 13:12:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45pv6p4wsj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 03 Apr 2025 13:12:57 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 533DCr8v54198736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 3 Apr 2025 13:12:53 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A10A20043;
	Thu,  3 Apr 2025 13:12:53 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83B2F2004B;
	Thu,  3 Apr 2025 13:12:52 +0000 (GMT)
Received: from [9.179.17.170] (unknown [9.179.17.170])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  3 Apr 2025 13:12:52 +0000 (GMT)
Message-ID: <e73b185d-2a33-400d-b351-3e353d78cb4a@linux.ibm.com>
Date: Thu, 3 Apr 2025 15:12:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
        Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Wei Wang <wei.w.wang@intel.com>
References: <20250402203621.940090-1-david@redhat.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20250402203621.940090-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: q6wVE3KcHk-luemwwcUmDRRd8C2FoJv9
X-Proofpoint-GUID: q6wVE3KcHk-luemwwcUmDRRd8C2FoJv9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_05,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=449
 lowpriorityscore=0 mlxscore=0 impostorscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504030057

Am 02.04.25 um 22:36 schrieb David Hildenbrand:
[...]>
> Fixes: a229989d975e ("virtio: don't allocate vqs when names[i] = NULL")
> Reported-by: Chandra Merla <cmerla@redhat.com>
> Cc: <Stable@vger.kernel.org>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Eric Farman <farman@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Wei Wang <wei.w.wang@intel.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

I will apply this to our internal s390 tree and let it sit for a
day to get CI coverage.

Alexander, Vasily, Heiko,
please then schedule for the s390/fixes branch if there is no CI fallout.




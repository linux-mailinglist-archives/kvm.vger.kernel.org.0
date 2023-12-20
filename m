Return-Path: <kvm+bounces-4909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8300C81999D
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 08:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E0D5283EF5
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 07:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D9416425;
	Wed, 20 Dec 2023 07:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="raHb1KUo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCED125AC;
	Wed, 20 Dec 2023 07:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BK7WIF7031560;
	Wed, 20 Dec 2023 07:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oYPBkCBjlmpHSuNqoC0zp/hfOAioMcs5rJex2qOXC9I=;
 b=raHb1KUo2GfGgsirIBAhhTcUQ140tN2MyqUciakGCQiWV+QoEaJ9vmRA0RAogi3A7rpj
 f3i2omIs/Dcxuu2RSljc3In5UUhgof550Qnj24iY/By44BrTPqiTkIkRyX3tJBdh0RgY
 hz3pXG5C3khJjt6uSobYUNT2sJKZfqVNiLQ9JWK9SPCJINYc4NwKU2AdTcdNqS/FBFZy
 ZSSJgvgkCj9ktE7dAM/EeZpr+mFeJ4UrCnnQOGo2TiXljdDawkzS8RDulEeWKK4UwCAF
 zsbhKKCn+OV0vzxYHvNf0nOkU3bTHzy99f+iAhyOt3mY3WRx5mvobjhKb+HUf1aaAEE+ Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3uya01yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 07:35:34 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BK7X4G8000581;
	Wed, 20 Dec 2023 07:35:33 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3uya01xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 07:35:33 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BK5AHRh013898;
	Wed, 20 Dec 2023 07:35:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3v1qqkcwt6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Dec 2023 07:35:32 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BK7ZPOP15270566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Dec 2023 07:35:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A18D92004B;
	Wed, 20 Dec 2023 07:35:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D64020043;
	Wed, 20 Dec 2023 07:35:25 +0000 (GMT)
Received: from [9.171.71.20] (unknown [9.171.71.20])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 Dec 2023 07:35:24 +0000 (GMT)
Message-ID: <ee6d43e3-5b3a-4256-82be-a5b1a6761ba5@linux.ibm.com>
Date: Wed, 20 Dec 2023 08:35:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: vsie: fix race during shadow creation
To: KVM <kvm@vger.kernel.org>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20231220073400.257813-1-borntraeger@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20231220073400.257813-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HHt36ecWzbGGbXcH1BFkoPyqpO3MI94p
X-Proofpoint-ORIG-GUID: JdSqhi_s6e9HcBbnf4_QpToPe6wJxYji
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-20_02,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxlogscore=701 suspectscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312200050

Am 20.12.23 um 08:34 schrieb Christian Borntraeger:
> Right now it is possible to see gmap->private being zero in
> kvm_s390_vsie_gmap_notifier resulting in a crash.  This is due to the
> fact that we add gmap->private == kvm after creation:
> 
> static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>                                 struct vsie_page *vsie_page)
> {
> [...]
>          gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
>          if (IS_ERR(gmap))
>                  return PTR_ERR(gmap);
>          gmap->private = vcpu->kvm;
> 
> Instead of tracking kvm in the shadow gmap, simply use the parent one.
> 
> Cc: David Hildenbrand <david@redhat.com>

I forgot to add
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>


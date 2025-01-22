Return-Path: <kvm+bounces-36236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0319A18F0D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 11:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 406E7161010
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 10:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E811D210F56;
	Wed, 22 Jan 2025 09:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NIVOiG6h"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BA420F093;
	Wed, 22 Jan 2025 09:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737539999; cv=none; b=oshH6QAApbCX8XixJgAnM0DzKpXKYiqvew0InBbua9FogOrCkGHXfXOQXLInFaFU3A4oFxAK840fmzdGdeO0LUUjmUX6vXmC4347/UYr0B6aKxqVc3u978PZpGdtYDVq3jfc4l2dyMfIkBeVLksdA7RFlNmgE2+CQ3jrOFYoaEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737539999; c=relaxed/simple;
	bh=tlxSrBef2DB7EkwANzu+BGceLfu96lP8eM/aVGXkU2w=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=tDzwTfPIpVDAWpRG5JDqYvLuRjk5kVzAzE6OH309cNOj8znGClIiTkJ3SGcOH0fdzMLUwnxicKVPJbEQxcvZvB/TiNAHFMhhJxIdUGLX8VjprSyma6cc/sONmPs/1s8sOxC+2FBnLBFRibtnwN1/PCGLWS65KhmRlxUEn7GPta8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NIVOiG6h; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50M17w4g012625;
	Wed, 22 Jan 2025 09:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6zVdmj
	Mmq0dT5iymICpYpo0lKBOse4fFLf/xMrcoSoE=; b=NIVOiG6hKR2Moy5KLYt8sr
	nk6Ljwcow0A3QarXFNWKHlT1fyRz4XqhX/nBHHKaySMD7NayyciSRn8vhpqpQsGQ
	uTURsKW4VD8z90Gm0U+FXXQodb5MI7J3yhtl9/mduSA3b/Jf3ypemu0sESrSOr2A
	jhH3PNxbdsHXGCBixg0tz9BfSssSQ+crUoveJBEaBygh7tmH8fis5bSoXKkYfMqs
	9+FfPq6KfgwByrNnwrfJyFFic8tI21m255DA+nwnD0BzKYUZKz765kWIg5D0Eqym
	HOMcjvvvu5uC/ULyB1N021VCV+/lh9scKUVxESVf0Hs8meKYY9W6xnaBTGWrL9vw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44apr9a143-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 09:59:53 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50M9gCTC004201;
	Wed, 22 Jan 2025 09:59:52 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44apr9a141-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 09:59:52 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50M7IN12032274;
	Wed, 22 Jan 2025 09:59:51 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 448rujqhr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 09:59:51 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50M9xmh861079876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 09:59:48 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B00620043;
	Wed, 22 Jan 2025 09:59:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 972B920040;
	Wed, 22 Jan 2025 09:59:47 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jan 2025 09:59:47 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jan 2025 10:59:41 +0100
Message-Id: <D78IIO0KIOR1.90R444HZMV1U@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 08/15] KVM: s390: get rid of gmap_translate()
X-Mailer: aerc 0.18.2
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-9-imbrenda@linux.ibm.com>
In-Reply-To: <20250117190938.93793-9-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BZFExxUh8ZMVTdhSsEZjInExnNM5cZL9
X-Proofpoint-ORIG-GUID: 6VEsBmvvMRMc4a97KGo1DPm7CO4-_NNR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_04,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0
 mlxlogscore=454 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501220073

LGTM

On Fri Jan 17, 2025 at 8:09 PM CET, Claudio Imbrenda wrote:
> Add gpa_to_hva(), which uses memslots, and use it to replace all uses
> of gmap_translate().
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/include/asm/gmap.h |  1 -
>  arch/s390/kvm/interrupt.c    | 19 +++++++++++--------
>  arch/s390/kvm/kvm-s390.h     |  9 +++++++++
>  arch/s390/mm/gmap.c          | 20 --------------------
>  4 files changed, 20 insertions(+), 29 deletions(-)


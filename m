Return-Path: <kvm+bounces-29472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE059AC1E4
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 10:39:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 852C91F223AC
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 08:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496EF15B119;
	Wed, 23 Oct 2024 08:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kS0pMbq8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8B7155A4E;
	Wed, 23 Oct 2024 08:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729672775; cv=none; b=anK3iTbZxFZ7sdNP7MsekYOvY+lTkvOfoHSboPagPk0HVAWEHHDencwxmAqx3y964GABpSv//2SZ72P/MXh/kB/hVTwsNd1NgCQTSgIGg+CuBqaclFmxVGF/ztl0+i5jqC6IEq5D1Gyh+aOnGvkOZBTnKNFrj4kU1cpZCBVeKws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729672775; c=relaxed/simple;
	bh=6yZe5On9N9ES5WK+PcoGH9hQE8jwLxmL+buOlTdDEJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P+aZxTubsiPMUe2Pz8FdBy49RuHbNtexbtAU7fwgm5O7ch4f6lQxhkDSjxOjv+orMZ/DHt39EwkudwScSh4X7mXAtTVmD6UUDw7tmwSiWM9bEiAZzLSJLkQd9gfJTiF8NKhLBvF9af7JilYmKa1H4OSM/8nyEs9KHmMEL7TNYTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kS0pMbq8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49N6QseC023289;
	Wed, 23 Oct 2024 08:39:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=bbXgH1
	luo5HBCa44WRLwZpoQCjCDIgPirpopAVwuCWw=; b=kS0pMbq8YWunCV6JqRi2nm
	VsXK+U1X1fo0R1AGDWQbws+APnA8UbNpz8gfxhvqC1TWFp8eXFNzpSHwF50BAFAi
	gyZL4mg0iCyfwmyJWAjPWOuMEh+CaJhuyPImdZ60bGwjbBUCkaRGKs0YBzMhh8up
	+sUJU+4BX3Nh3DROkgxXXxyUIh42B32hU216eFvJXd8G/IBnWNGmhUDk/89n4HHh
	5QjlZkvcHrNxvE4v0CpHuM5Ol/Pmi7f4FX+yF9N9UAzgjuvdyXAW4NE1LuWyjUZE
	1JSGx1jXDQtXK3GRa3qDkx1XrrrAbFJqFBrU0kJ1vWGB9lfMltnfijMFufGfENrg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emaft276-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 08:39:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49N7aNrT001530;
	Wed, 23 Oct 2024 08:39:30 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42emk9a0kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 08:39:30 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49N8dTU246990066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 08:39:29 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11BB458043;
	Wed, 23 Oct 2024 08:39:29 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E02758059;
	Wed, 23 Oct 2024 08:39:26 +0000 (GMT)
Received: from [9.155.199.163] (unknown [9.155.199.163])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 23 Oct 2024 08:39:26 +0000 (GMT)
Message-ID: <dc112ac5-17bc-4b43-adf8-d7d2ca21082e@linux.ibm.com>
Date: Wed, 23 Oct 2024 10:39:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/11] s390/mm/gmap: Remove gmap_{en,dis}able()
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
 <20241022120601.167009-8-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20241022120601.167009-8-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vZoZXv4KINX2AFsFd4R0OS5M3kJd4kfJ
X-Proofpoint-ORIG-GUID: vZoZXv4KINX2AFsFd4R0OS5M3kJd4kfJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=711 phishscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410230052



On 10/22/24 2:05 PM, Claudio Imbrenda wrote:
> Remove gmap_enable(), gmap_disable(), and gmap_get_enabled() since they do
> not have any users anymore.
> 
> Suggested-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   arch/s390/include/asm/gmap.h |  3 ---
>   arch/s390/mm/gmap.c          | 31 -------------------------------
>   2 files changed, 34 deletions(-)

...


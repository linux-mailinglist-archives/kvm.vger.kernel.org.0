Return-Path: <kvm+bounces-59436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA00BB4867
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 18:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D4D516C11E
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 16:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6548625A2D8;
	Thu,  2 Oct 2025 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lwT0ThyQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6393B2580F2;
	Thu,  2 Oct 2025 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759422309; cv=none; b=Ag3ylDzffF9M6ZlM54TbI6buAMyPpe3vc9rYViAjbefvsSkt2vhqzFL8bvMU2o5b+BISOMG4fvv2bMDjcFVySaraPOsMEhuSpPT32u65KVRUD+D9UP410e30rArefIVrBT8g+Rvn+NwDiRzp6tZfrRFA9wH8H0T0fImwDKkLxL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759422309; c=relaxed/simple;
	bh=9nwGKuyNtHubpdbOJNjuRGLZdiDBAvEzAaHiSSBbL98=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u/OlMuuz7KtqBk0SZa6vS2OxOrlDjqlacMiN8gbIBAfkGUB8MkjmHQQE/or+spDCtpH7Or9RxJSkDBe8yS8AxRLbvxo9elSiXG29M8NheXfSvoABtTwWw8d54LjNuy4sW1vCOR8TojAUT2KkqSXWc7zwY+esqfhX6RCiOsngHbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lwT0ThyQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 592DH7iY000711;
	Thu, 2 Oct 2025 16:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Bo/dND
	lTJhGwVL7sPqtlWS6mqbDbIA35vEa1y8XEvUU=; b=lwT0ThyQDfkXLTTvnkPMQe
	N9ocbfa59EfUfOGf/WSR0ZtxmXiofOGFwucpQPrgB3bmaBgFJsrIZmIebir+hQzL
	EuojpYNNfYl8uMuon74Hr5LXA40WrST2MzZqx5Rnw7UrO6yoZRPyiPIliXbiIfEV
	yJ0rnlb6+gjUjBuVXoBA8aNjSStpvvMtnDodlD0WYqsLR3j6AbpaBtDInuY+HSVy
	pTfFBgZMW+qJ0xzFH2Ym6BT5KXFWwnvwo0YX+7j3QXRBA/kPm5gTGpqDNAqwUdC+
	AmnCips92sXCfkwjirTzCqweQP776WheXZ2aEjWP08CShUtHuf6p5jww+nF71GVA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7jww8vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 16:25:05 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 592F00KD024198;
	Thu, 2 Oct 2025 16:25:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49evy1efm6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 16:25:04 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 592GP0Hr57409802
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Oct 2025 16:25:00 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A75E520043;
	Thu,  2 Oct 2025 16:25:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7190020040;
	Thu,  2 Oct 2025 16:24:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.143.163])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu,  2 Oct 2025 16:24:59 +0000 (GMT)
Date: Thu, 2 Oct 2025 18:24:56 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: freude@linux.ibm.com, Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/uv: Fix the comment of the uv_find_secret()
 function
Message-ID: <20251002182456.273e7205@p-imbrenda>
In-Reply-To: <20251002155423.466142-1-thuth@redhat.com>
References: <20251002155423.466142-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX95qDt8n9sHRM
 hYX/pJpQ0HtZskshN06KciEQ0Njx6qM18rkyHTR1YCiE8HHTiVC0BkGQNAuw9P5HuHr0PyzmTMN
 nIaTnesDvK8Gz9baWuE/ati1hu/T6I/Xkuh/7iMoX97T43StPoqlw9GR7oFfCKaFSddJXQDU6kv
 x5bo0JUqynzqxojYvKPwyWnTdETMOhHBrKHEOMR61k5QrUBTV91Ip6JI/+ZX3vs2xyNmM+D/vvp
 Q1mJNhwhMqcrigm4fEaUF4Z8/qVFMDmGn8sq3ej8cV0mOVgsgmBmB6Y0wzWeO5RJMTvZQuQUwTZ
 nvsp4Fk80WNcsy54Krf1JkxOBpDLjQFqhVsAUIdxqj05qOeGyaVrgUCochnXfRYauU2MH/0t8Pv
 DJYJURbmZAQDWFhHhG54Rl9Hd/2rDw==
X-Proofpoint-ORIG-GUID: ao7fTf_wYv-gZxhxOovAh12vkug2TpYJ
X-Proofpoint-GUID: ao7fTf_wYv-gZxhxOovAh12vkug2TpYJ
X-Authority-Analysis: v=2.4 cv=GdUaXAXL c=1 sm=1 tr=0 ts=68dea761 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=IxN_qdxVzOrQSJR8OegA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_06,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

On Thu,  2 Oct 2025 17:54:23 +0200
Thomas Huth <thuth@redhat.com> wrote:

> From: Thomas Huth <thuth@redhat.com>
> 
> The uv_get_secret_metadata() function has been removed some
> months ago, so we should not mention it in the comment anymore.
> 
> Fixes: a42831f0b74dc ("s390/uv: Remove uv_get_secret_metadata function")
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kernel/uv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 47f574cd1728a..324cd549807a5 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -866,8 +866,8 @@ static int find_secret_in_page(const u8 secret_id[UV_SECRET_ID_LEN],
>  	return -ENOENT;
>  }
>  
> -/*
> - * Do the actual search for `uv_get_secret_metadata`.
> +/**
> + * uv_find_secret() - search secret metadata for a given secret id.
>   * @secret_id: search pattern.
>   * @list: ephemeral buffer space
>   * @secret: output data, containing the secret's metadata.



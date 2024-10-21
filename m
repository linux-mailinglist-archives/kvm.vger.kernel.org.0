Return-Path: <kvm+bounces-29269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A51719A60A6
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D00CE1C21EF2
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29751E3DDE;
	Mon, 21 Oct 2024 09:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T5ytV/te"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C92D1E3DC8;
	Mon, 21 Oct 2024 09:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729504233; cv=none; b=FWlSxEKytRLGN3bSCVSl5vyNz1QeLKtIdJetblygkjGzNP9Fjc57xFcStvLtOnzHIjIHSHT7aKwamz4DLUw3D5S2FJMPjOdqEjRDUzOexkfOQyIprG5GrlRpUs6qdsB0Bb/LGJ1LIIGhv9Pshh9iRZLt/uQXXVF0lad0FKzRqE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729504233; c=relaxed/simple;
	bh=8Bgev/amh2Hew3YYUpDgVzhwebYSN/anlcDRy6yy+oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EJxu3okY5IKdKt+UWcCyj4+O7TqNrvW4HU2pyFT9YtAtHNHr2b76ub/qCA3Zv8rDd3BBu+IfoLm0aC7mbPrOFcwJnHvhgz8sMeDp/3qTJUj1Exofp0M0ksc9/UtItpkPu+4jwrfxa2NAU6eb+xu3Ti+r9aGlvC1B6suLGdLCh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T5ytV/te; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L2KQPP032617;
	Mon, 21 Oct 2024 09:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=4Dw+/OkTYqhN3mW6WMjVha4zlULCPu
	0wcUtYedMk1cA=; b=T5ytV/tePR0ZvnxZje8Btx4B0JL67uiOO5x7fD/yXegtvg
	xiaIowlhNDKJVkeXLScA7XKB0W/bdHCdF1HVSRdXsrwnVVXxYAYUGX7JD+L8EKwF
	LcfTuYNYw594Ws+2Dm4GOIOOhnxtfxL4VFa0vDp2kNonPbGqlgXCKhPo4+GihLQw
	qD1ta462bZOKk/kITPkJUIKtlBq5MKkZG6DpJF/4P4Gw6Vu9FjtSClwTgdlOpXCF
	xbvbvd0gQ34R/2k7e8nKPrIHr7hN0Sy+qK0nTJhq9YI1d7JnHlh09bXIh82nYaB4
	3YFCszQP1Zzydk00FBNlIgqMjQ9guFC5iYfzymSw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5hm8d97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 09:50:30 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49L7Wt8V026464;
	Mon, 21 Oct 2024 09:50:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42cq3s5ttf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 09:50:29 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49L9oPwc19005874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Oct 2024 09:50:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AECE620049;
	Mon, 21 Oct 2024 09:50:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00D9E20040;
	Mon, 21 Oct 2024 09:50:25 +0000 (GMT)
Received: from osiris (unknown [9.171.37.192])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 21 Oct 2024 09:50:24 +0000 (GMT)
Date: Mon, 21 Oct 2024 11:50:23 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 07/11] s390/mm/gmap: Remove gmap_{en,dis}able()
Message-ID: <20241021095023.6950-C-hca@linux.ibm.com>
References: <20241015164326.124987-1-imbrenda@linux.ibm.com>
 <20241015164326.124987-8-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015164326.124987-8-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JcDXnHe0fMSvVLeY3ijFwQO2oowZ3TUB
X-Proofpoint-GUID: JcDXnHe0fMSvVLeY3ijFwQO2oowZ3TUB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=485 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410210068

On Tue, Oct 15, 2024 at 06:43:22PM +0200, Claudio Imbrenda wrote:
> Remove gmap_enable(), gmap_disable(), and gmap_get_enabled() since they do
> not have any users anymore.
> 
> Suggested-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h |  3 ---
>  arch/s390/mm/gmap.c          | 31 -------------------------------
>  2 files changed, 34 deletions(-)

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>


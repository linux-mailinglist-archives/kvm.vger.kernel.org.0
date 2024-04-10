Return-Path: <kvm+bounces-14145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BED0789FED4
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 19:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EFC01F23F10
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 17:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED9717F390;
	Wed, 10 Apr 2024 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GjhU9grd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE2317BB07;
	Wed, 10 Apr 2024 17:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712771098; cv=none; b=VsZPBdV08SaPKD3Ec7cRfINkljkeCszuGCzU2CbO8RSLo0/rtFPU+8kVQy81UMY6LrQp8L0cbE+zMClQs6n5A6coLoZcF5OK66UyNVY4ahpLjmDTTemIb2g69jvcFp+k5p7jLXiNAuCkcRM3uRW9z1C31uVt4ikjq8SlTph4Nso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712771098; c=relaxed/simple;
	bh=qiV6Frnr0PCST5zH3Vln5Q4KvB929eMdI7v34EcMuOM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aCmMe7ZUmecvfummk6+lKMn9su8fmvmVu7YxBvQM/4+dSyznmOwDzGX3mDpaxDEgpMZqMb+5hhok0ynxjeSvuZUYGfu/xh76V/oxEWO47ADpZi6rMHmIIOPE02vb1VGcSB52AyDhk2yoOBTFpw2CAcRc5zAEmJtt5q+zcFy8scw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GjhU9grd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43AHWA3o027252;
	Wed, 10 Apr 2024 17:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hnZXVJfZAGwBsrkzwM2xdVFKDTfnQrp2RglJ2YFkNR0=;
 b=GjhU9grdNrWmZ6/6MG/XB8Slz/gvTkdJT4so7iW2UO6/VK94Rd8ff8aNEt9bkY7t1PpM
 lZNQxcssjZSU8P2QFPYHFpdCXy/VrMsvQMgBHk8Y1okpI78Hc8TSIlkvLzwjmlsavIJW
 j0/1NxuFhOXtBAC/D0WWF+1XjrMSP1tYkmBYaN7KDe4RRQAlUD8RUbaTK4+ouh6DnZ7d
 EAksI/W7LQKC40yERBsbESkekWWpYUmK7/c2v1oJaOkD8DkXcnFUf+1zCpewtbEi1KsI
 DzrE0Dik0c6ykHl01sXwYt60U7X3ViI/h8zJI2d4XvWjowuZVyyunBvouxicaRBtn+q3 +g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdy8j00rx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:46 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43AHikO6012015;
	Wed, 10 Apr 2024 17:44:46 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdy8j00rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:46 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43AGqclR029940;
	Wed, 10 Apr 2024 17:44:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xbj7me5hc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43AHidQM28181168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 17:44:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 537ED2004B;
	Wed, 10 Apr 2024 17:44:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 265F920040;
	Wed, 10 Apr 2024 17:44:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Apr 2024 17:44:39 +0000 (GMT)
Date: Wed, 10 Apr 2024 19:21:28 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Matthew Wilcox
 <willy@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v1 1/5] s390/uv: don't call wait_on_page_writeback()
 without a reference
Message-ID: <20240410192128.2ad60f9b@p-imbrenda>
In-Reply-To: <20240404163642.1125529-2-david@redhat.com>
References: <20240404163642.1125529-1-david@redhat.com>
	<20240404163642.1125529-2-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: quQYV4TfkaiiQczU3ccpk_wYZvvsE-_7
X-Proofpoint-GUID: epvxi2EtwwiBH1sO2ThDb1y5i3tsUcrR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-10_04,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404100130

On Thu,  4 Apr 2024 18:36:38 +0200
David Hildenbrand <david@redhat.com> wrote:

> wait_on_page_writeback() requires that no spinlocks are held and that
> a page reference is held, as documented for folio_wait_writeback(). After

oops

> we dropped the PTL, the page could get freed concurrently. So grab a
> temporary reference.
> 
> Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kernel/uv.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index fc07bc39e698..7401838b960b 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -314,6 +314,13 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  			rc = make_page_secure(page, uvcb);
>  			unlock_page(page);
>  		}
> +
> +		/*
> +		 * Once we drop the PTL, the page may get unmapped and
> +		 * freed immediately. We need a temporary reference.
> +		 */
> +		if (rc == -EAGAIN)
> +			get_page(page);
>  	}
>  	pte_unmap_unlock(ptep, ptelock);
>  out:
> @@ -325,6 +332,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  		 * completion, this is just a useless check, but it is safe.
>  		 */
>  		wait_on_page_writeback(page);
> +		put_page(page);
>  	} else if (rc == -EBUSY) {
>  		/*
>  		 * If we have tried a local drain and the page refcount



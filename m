Return-Path: <kvm+bounces-16885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 902148BE953
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DC14291C8B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CA416D9C5;
	Tue,  7 May 2024 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o1PUuU18"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F3516D322;
	Tue,  7 May 2024 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715099707; cv=none; b=YOXMvCpNSqZKr+pyr2qZaQ8COuHwdv3+avbQet06oAR1Ia2YBUfZv0XofeYsaaLs1uQ0Smat4lSUJmZIR6+8KJz3iZC0TqNkJPbHdM5ATvbCWVEeZccIgeQ5iHp4Kx/rq5bcHPK9qZ+qcNCXIx0WpMB+RHRzkKJYxxE6YO6kOco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715099707; c=relaxed/simple;
	bh=57uYbuim9Hu4C7H4vfg5kDTB6ZjQdpi42ugRCkVfuqI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEVVNipzhZoVcOWtolORjYxD/Ay1RQxU+Cay8XhVFZ+fILTjJXk1RQp1mpEGqOzFbGvC3vtiy+Ow0kGShS8rCY7CRUmDz+J8hb40062Dkc1+b2uGjZgAzGGYw8qmgZ9J68PsGJlw+rPCz2ZKbfLWy8f25mFSI89QSccb1gnhOx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o1PUuU18; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447FtEpQ015151;
	Tue, 7 May 2024 16:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=VJ012Q9//RmwPNni97kdU0owqsPV9uahC3XCnkLIBe8=;
 b=o1PUuU18fJj1aNuSb2C+shGqUUMHfreMcnwUXgkdl92PSAOnndbQxrpFmJkLaZVg94fc
 XBpbl5sEzaIWK1i8MwulMfNLbM/wX/8b3H7xmgYj7Pyiokb0RdfpUqP+xR9RHKGDByw7
 bQcSEUaq6hh6g177jQ8Xa88xIXt4RfWvLnpLZr+QamU4ifrM4aCVV+k0kwIcneoKgbuj
 m+tspAO9VAu21ycM/U383/yhzo2jGIAk0gTyBWWa+PEZERqH1lfYWbJbGqOzpzeGh3oT
 87pgg8YaadsctMsPenHK4iZYGcai5zLIZnSQCN0DIic3KsZI4nh6WLDQoxTj6DXhc8BR 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqc503fe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:57 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447GYv7Q013548;
	Tue, 7 May 2024 16:34:57 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyqc503fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:56 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447EbJxL031316;
	Tue, 7 May 2024 16:34:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xwybtyj2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 16:34:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447GYoTZ15597932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 16:34:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3A8220043;
	Tue,  7 May 2024 16:34:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 747CC20040;
	Tue,  7 May 2024 16:34:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 16:34:50 +0000 (GMT)
Date: Tue, 7 May 2024 17:53:36 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>,
        Matthew Wilcox
 <willy@infradead.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 06/10] s390/uv: make uv_convert_from_secure() a
 static function
Message-ID: <20240507175336.4d7b14ec@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240412142120.220087-7-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
	<20240412142120.220087-7-david@redhat.com>
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
X-Proofpoint-GUID: U_btB3z65KuGcB1VV8av_CPOkxk3SM2l
X-Proofpoint-ORIG-GUID: E2fRKeg_CT-pqOiw-QThF8VNeX97y-ll
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0 mlxlogscore=942
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070112

On Fri, 12 Apr 2024 16:21:16 +0200
David Hildenbrand <david@redhat.com> wrote:

> It's not used outside of uv.c, so let's make it a static function.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/uv.h | 6 ------
>  arch/s390/kernel/uv.c      | 2 +-
>  2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 0e7bd3873907..d2205ff97007 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -484,7 +484,6 @@ int uv_pin_shared(unsigned long paddr);
>  int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
>  int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
>  int uv_destroy_owned_page(unsigned long paddr);
> -int uv_convert_from_secure(unsigned long paddr);
>  int uv_convert_owned_from_secure(unsigned long paddr);
>  int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
>  
> @@ -503,11 +502,6 @@ static inline int uv_destroy_owned_page(unsigned long paddr)
>  	return 0;
>  }
>  
> -static inline int uv_convert_from_secure(unsigned long paddr)
> -{
> -	return 0;
> -}
> -
>  static inline int uv_convert_owned_from_secure(unsigned long paddr)
>  {
>  	return 0;
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index ecfc08902215..3d3250b406a6 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -156,7 +156,7 @@ int uv_destroy_owned_page(unsigned long paddr)
>   *
>   * @paddr: Absolute host address of page to be exported
>   */
> -int uv_convert_from_secure(unsigned long paddr)
> +static int uv_convert_from_secure(unsigned long paddr)
>  {
>  	struct uv_cb_cfs uvcb = {
>  		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,



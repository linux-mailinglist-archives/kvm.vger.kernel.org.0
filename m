Return-Path: <kvm+bounces-36273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9606CA19640
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10AC93A9CE7
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFD8214A99;
	Wed, 22 Jan 2025 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ULalPNQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C2D2135B9;
	Wed, 22 Jan 2025 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737562445; cv=none; b=L3crnmHNYndqwcuCTMhSUiKp8EuhVQRYhU+siWJ3JGqNA+yL275Zd+OfpdPyKP2gcGY5TS4lA30GNJvoeYe+0jDHbkJyIx7+8heCa0DR+ebNO+3DuWmf2g44FKaqzMArApaCjweRtHAhi4d3XSTqfVHCb8m1ojgI/8NLM4K9DR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737562445; c=relaxed/simple;
	bh=NkwaTxP8IA6CmS+YykzZg2T095iGHWlpqqTwcvnulco=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:Subject:From:
	 References:In-Reply-To; b=KRqALu4He+dOKKmnGHNyBkve2le8mnwEQk2VKPXx2gnPvkvYErvWRxAAEiAlIHkYGqBR3Mfblb98WoDmBVXkzSIp0+qLac65A+p6B7/ScP8sVgDM6FrG4Q3Ct/dnRCmwDtd+/DGLkqxlv0FoWorxk82Y7CkX3pYm0d4PG8KNa8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ULalPNQ4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50M7WhWd012550;
	Wed, 22 Jan 2025 16:13:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6DANvi
	+7gXKGveupMBUuxZKlQYZ1T2zB8HoODupJwCI=; b=ULalPNQ44LQzC0qOwcJnSi
	AItQspz8ox2eH/9JdGDsfQEOhNyfKdmYRBPka5Skpq7ZbZbmM2zrQsI0Puqt+/uv
	lsIoilAMxh9v32vQ12tCbuu/seueuqeUSfIw1/PgqWgz1c8q1nnYJTvFmy+j9Zx/
	wKIzcx4GXyeZO+zrwHwhhGOxWy0VUT42mkrHsywZpMJiB/DGVKGMJhppv4X/6Ct4
	8umJGH09xjGHuRat9pFY6yjVqxNMaRGb5XLrZmWxpSTob7P+0J+OdJJPWZ/wa8It
	gapPghZPdyLjbaRxS4uOo6KEYTo/yTjeGAbXvAdel/k+MwwqBpe//7Ph3GPdQf2w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44avcp2bww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 16:13:59 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50MG5bZ2025385;
	Wed, 22 Jan 2025 16:13:59 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44avcp2bwt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 16:13:59 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50MFrUYh020997;
	Wed, 22 Jan 2025 16:13:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb1gu3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 16:13:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50MGDsPh42991916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 16:13:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3EF220043;
	Wed, 22 Jan 2025 16:13:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCE0620040;
	Wed, 22 Jan 2025 16:13:54 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jan 2025 16:13:54 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jan 2025 17:13:49 +0100
Message-Id: <D78QH4KP3LD3.ERGCXUJU0TT5@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/15] KVM: s390: stop using lists to keep track of
 used dat tables
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-12-imbrenda@linux.ibm.com>
In-Reply-To: <20250117190938.93793-12-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AtgpRgliOq3P8PKqJpypFrRqru_x1zie
X-Proofpoint-GUID: X6SQHu5ZgNr7CwmVZTBLxaK23Aw7vSBI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_07,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 bulkscore=0 mlxlogscore=909 spamscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501220118

On Fri Jan 17, 2025 at 8:09 PM CET, Claudio Imbrenda wrote:
> Until now, every dat table allocated to map a guest was put in a
> linked list. The page->lru field of struct page was used to keep track
> of which pages were being used, and when the gmap is torn down, the
> list was walked and all pages freed.
>
> This patch gets rid of the usage of page->lru. Page tables are now
> freed by recursively walking the dat table tree.
>
> Since s390_unlist_old_asce() becomes useless now, remove it.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

With comment fixes done:

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/include/asm/gmap.h |   3 --
>  arch/s390/mm/gmap.c          | 102 ++++++++---------------------------
>  2 files changed, 23 insertions(+), 82 deletions(-)
>
> diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> index dbf2329281d2..904d97f0bc5e 100644
> --- a/arch/s390/include/asm/gmap.h
> +++ b/arch/s390/include/asm/gmap.h
> @@ -45,7 +45,6 @@
>   */
>  struct gmap {
>  	struct list_head list;
> -	struct list_head crst_list;

nit: Please also remove @crst_list and @pt_list from the struct gmap commen=
t.

>  	struct mm_struct *mm;
>  	struct radix_tree_root guest_to_host;
>  	struct radix_tree_root host_to_guest;
> @@ -61,7 +60,6 @@ struct gmap {
>  	/* Additional data for shadow guest address spaces */
>  	struct radix_tree_root host_to_rmap;
>  	struct list_head children;
> -	struct list_head pt_list;
>  	spinlock_t shadow_lock;
>  	struct gmap *parent;
>  	unsigned long orig_asce;
> @@ -141,7 +139,6 @@ int gmap_protect_one(struct gmap *gmap, unsigned long=
 gaddr, int prot, unsigned
>  void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitm=
ap[4],
>  			     unsigned long gaddr, unsigned long vmaddr);
>  int s390_disable_cow_sharing(void);
> -void s390_unlist_old_asce(struct gmap *gmap);
>  int s390_replace_asce(struct gmap *gmap);
>  void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
>  int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,

[...]



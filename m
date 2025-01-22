Return-Path: <kvm+bounces-36275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E02A1965E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EA3116CA29
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B9F215060;
	Wed, 22 Jan 2025 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WGgi1Tjf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BFA215040;
	Wed, 22 Jan 2025 16:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737562810; cv=none; b=LQ93WT5UKB0EDDlKgvxW3HB/sg6D9zWfvMhZKbjkZyoRolNU1klkHt85oUK1ffrgU/FKL/4h+uObznwB4HLK7yParSzGe2HtIWnSMdmLk1TbbQOoV6EKMnd1gBK23mdUXifzAWxw0MfSDKotW6m76zevRleVYUZqdN+sdueYAcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737562810; c=relaxed/simple;
	bh=TQHbyOcD5fSyW38bWGF/BCwn5TeJFqRlnVQhRjFRHbA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pm80XX5XtSuALYGoqzQv7u1OX3rl4YDotSrGlMcjh17HZpfgLndKNT5jfhd1YN7fL416YwsgaSgYQ+57qo374NvFtxQTsZGNDEKEqDemCfvTZnI9AfLnxew4j4dAUu/p7RWQ1YDdNmx6f25d4owo2A4/D5ylK7PV+vAbrMITmUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WGgi1Tjf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50MF1cwQ027707;
	Wed, 22 Jan 2025 16:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ymGaUt
	Tv4Ya9uGyEtR/jfthql/EML/u6oQgOsLsI01Y=; b=WGgi1Tjfuqj4Iz3+q4cg6y
	iJt/7wg//RU3aK6np9Q4/VJ+NG3nXChSnfND+T0X1hI+sLbtOD7OvVE8q/WWCJ84
	CvtOVaM5LyUO95+OfHMUQDiUONrJuHkBnCB7L8bMmit6Cv2cEU//eGWcAwHhBMBP
	BemSjkYsuXjTSy4giMQRSR2tt+dEh2TP6TsdEwqez62uEoS5Sczw4L10Cw853dS/
	PBl8VQ4+t3avHB0Q5QzLN5Zyb2tw4eTi1tjPmu3z31Lhh6BXPcwP1VfPqOxFmDgB
	tKeRxDbolSX0z3UAdb8/IMlwW2PCeuDK/4VJcgZG+65x7VHqbPLrmRVlEKjGi52A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b2xygdp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 16:20:02 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50MGC2F1023904;
	Wed, 22 Jan 2025 16:20:02 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44b2xygdnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 16:20:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50MFgYgF032290;
	Wed, 22 Jan 2025 16:20:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 448rujrw6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 16:20:01 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50MGJwWF13697314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jan 2025 16:19:58 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E8B3A2005A;
	Wed, 22 Jan 2025 16:19:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B34892004E;
	Wed, 22 Jan 2025 16:19:57 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jan 2025 16:19:57 +0000 (GMT)
Date: Wed, 22 Jan 2025 17:19:55 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>, <david@redhat.com>,
        <willy@infradead.org>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <nrb@linux.ibm.com>,
        <nsg@linux.ibm.com>, <seanjc@google.com>, <seiden@linux.ibm.com>
Subject: Re: [PATCH v3 11/15] KVM: s390: stop using lists to keep track of
 used dat tables
Message-ID: <20250122171955.0e415287@p-imbrenda>
In-Reply-To: <D78QH4KP3LD3.ERGCXUJU0TT5@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
	<20250117190938.93793-12-imbrenda@linux.ibm.com>
	<D78QH4KP3LD3.ERGCXUJU0TT5@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rRDRQGsK93JZWsxoFmq55E5IjF57Whh8
X-Proofpoint-ORIG-GUID: PI84ob8Ps9luoK1Wbq4RVU8Yai4ydJD0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_07,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501220118

On Wed, 22 Jan 2025 17:13:49 +0100
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> On Fri Jan 17, 2025 at 8:09 PM CET, Claudio Imbrenda wrote:
> > Until now, every dat table allocated to map a guest was put in a
> > linked list. The page->lru field of struct page was used to keep track
> > of which pages were being used, and when the gmap is torn down, the
> > list was walked and all pages freed.
> >
> > This patch gets rid of the usage of page->lru. Page tables are now
> > freed by recursively walking the dat table tree.
> >
> > Since s390_unlist_old_asce() becomes useless now, remove it.
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> With comment fixes done:
> 
> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> 
> > ---
> >  arch/s390/include/asm/gmap.h |   3 --
> >  arch/s390/mm/gmap.c          | 102 ++++++++---------------------------
> >  2 files changed, 23 insertions(+), 82 deletions(-)
> >
> > diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
> > index dbf2329281d2..904d97f0bc5e 100644
> > --- a/arch/s390/include/asm/gmap.h
> > +++ b/arch/s390/include/asm/gmap.h
> > @@ -45,7 +45,6 @@
> >   */
> >  struct gmap {
> >  	struct list_head list;
> > -	struct list_head crst_list;  
> 
> nit: Please also remove @crst_list and @pt_list from the struct gmap comment.

ouch yes, definitely

> 
> >  	struct mm_struct *mm;
> >  	struct radix_tree_root guest_to_host;
> >  	struct radix_tree_root host_to_guest;
> > @@ -61,7 +60,6 @@ struct gmap {
> >  	/* Additional data for shadow guest address spaces */
> >  	struct radix_tree_root host_to_rmap;
> >  	struct list_head children;
> > -	struct list_head pt_list;
> >  	spinlock_t shadow_lock;
> >  	struct gmap *parent;
> >  	unsigned long orig_asce;
> > @@ -141,7 +139,6 @@ int gmap_protect_one(struct gmap *gmap, unsigned long gaddr, int prot, unsigned
> >  void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
> >  			     unsigned long gaddr, unsigned long vmaddr);
> >  int s390_disable_cow_sharing(void);
> > -void s390_unlist_old_asce(struct gmap *gmap);
> >  int s390_replace_asce(struct gmap *gmap);
> >  void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
> >  int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,  
> 
> [...]
> 



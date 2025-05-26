Return-Path: <kvm+bounces-47719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F5A0AC4036
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 15:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 219A0171F39
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 13:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3C41FC0EA;
	Mon, 26 May 2025 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sxNZXlnN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46F64409;
	Mon, 26 May 2025 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748265730; cv=none; b=PUyzBBloMiTeGZGVHStHkepDKeHC5ao61F/wHiknfQKHi0gG1VxwB4sXoGiPktXFyjRMsonbAVkp237rhybeG6nozuGeuu2jVY90al7LanjEE3ca6QjdX0SHaEkbUJwQ1pvazvPpW/SKihLrFsoFaAelTOrlpFtRBTMWpcVxFEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748265730; c=relaxed/simple;
	bh=QEwxMziYfSsvPUSHqi9KFZOix51JVvyBUAscp5W1A1E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z3neYDFN54yHrUVZADXYax/cpUpZGRuWwVjjpuqqvrxJnUeooPT80l6oKp6nsDjnZ8aoUajWC/IK4bY7rWNEgToe1EFmsGSlrhqmZr86b8KskUVqDrcE1eBs7BtqQcFzld67uYe1OceTSw9qrKQ6G2O67vuX338Pctu5uW8iDPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sxNZXlnN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54Q64cWW025403;
	Mon, 26 May 2025 13:22:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kkl4DN
	P3JEJBsSyH+8pkIGF5rvzwqPBwP/ZvDHmWFZ8=; b=sxNZXlnN5ykOmPo9E9FRaJ
	eYd+aqexLEFEQkE+iB4gPVr7BNBUqG1mZP2DPZe8JWL+n+oPSRhKVw7oYQ7Wqh7X
	ZLKxm+iGsv1wTa+gd55NsEUuAVm0CSsy0nuJzVqLcG5gtqj3s75Hx8DhxeEX1BPv
	6wbyrjg+QGnMTWgSIuFQi+F+B1tSK7Wdzj+UUZAJU5MJQmlkMMPwqJUeKJ6dfcEa
	x39iA6BCLNnDe539JrIeUn51dZ0nTWVnTern7kIWeEnGbVH8zdIAiMl7rJhrVDDP
	E21uAx1chQ7psbnN9e8vT8FWYIeRJCNCgCoUV4aQyVc+ses4CixgMHQ7VSApk8lw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46v0p2d4ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 13:22:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54QBhHMH016674;
	Mon, 26 May 2025 13:22:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46ureu6fnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 13:22:05 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54QDM1T539846220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 May 2025 13:22:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E5F020040;
	Mon, 26 May 2025 13:22:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6DD22004D;
	Mon, 26 May 2025 13:22:00 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.57.35])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 26 May 2025 13:22:00 +0000 (GMT)
Date: Mon, 26 May 2025 15:21:57 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
Subject: Re: [PATCH v2 4/5] KVM: s390: refactor and split some gmap helpers
Message-ID: <20250526152157.23743974@p-imbrenda>
In-Reply-To: <5e058fd1-ccee-43c3-92eb-ad72d2dbc1f3@linux.ibm.com>
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
	<20250520182639.80013-5-imbrenda@linux.ibm.com>
	<5e058fd1-ccee-43c3-92eb-ad72d2dbc1f3@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: jpUVLp4_ROZXgsfvS9Wg_FMBwZpDBDtq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI2MDExMSBTYWx0ZWRfX0bMSC/zCelth YwvHq5RHxCe4AAzzPwP0U1RrTYIpqWpFbMUrY+yHd+8vpgWBHAm5chhtvQmqapeN288wtxDqEQP K59pzp32c2hwk7+NNlpHfFy1SyXUwH6U30Ibm++Q55ULnu03jF1qKDK1yxX0jR+bw0au5jgEyNa
 hwBoyuA2I3yqOGyp+6/sXt/39KFPO99cUDiFXg1ShEpe4wLl3F+SpcOFc1zhhXWpSkoV+EnJx7p /Y0VKxDFRemrgGem2XHKjjmIZrO17I0057GWZ86GcfUArf1X00x6Ppok6m8qaaFwj87a+yq9GOV 2jFYJaDGUr1uTMg9pdOz8cHByTFyYTOW7mapA3CJGkXc36eInS/vmUcI5d1HmWRr4iWgI75qiIh
 egD4Le5OEZg9I9xPTpD7WrhaxKGBkCGPCNFFChQ0l2DSbI6yf5/5jLEw+5CT9YF4PcHyI+HE
X-Authority-Analysis: v=2.4 cv=Q7TS452a c=1 sm=1 tr=0 ts=68346afe cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=yrhbBQRmuIknczaptVAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: jpUVLp4_ROZXgsfvS9Wg_FMBwZpDBDtq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-26_06,2025-05-26_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 clxscore=1015
 malwarescore=0 adultscore=0 mlxscore=0 impostorscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505260111

On Mon, 26 May 2025 13:17:35 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 5/20/25 8:26 PM, Claudio Imbrenda wrote:
> > Refactor some gmap functions; move the implementation into a separate
> > file with only helper functions. The new helper functions work on vm
> > addresses, leaving all gmap logic in the gmap functions, which mostly
> > become just wrappers.
> > 
> > The whole gmap handling is going to be moved inside KVM soon, but the
> > helper functions need to touch core mm functions, and thus need to
> > stay in the core of kernel.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   MAINTAINERS                          |   2 +
> >   arch/s390/include/asm/gmap_helpers.h |  18 ++
> >   arch/s390/kvm/diag.c                 |  11 +-
> >   arch/s390/kvm/kvm-s390.c             |   5 +-
> >   arch/s390/mm/Makefile                |   2 +
> >   arch/s390/mm/gmap.c                  |  46 ++---
> >   arch/s390/mm/gmap_helpers.c          | 259 +++++++++++++++++++++++++++
> >   7 files changed, 302 insertions(+), 41 deletions(-)
> >   create mode 100644 arch/s390/include/asm/gmap_helpers.h
> >   create mode 100644 arch/s390/mm/gmap_helpers.c  
> 
> [...]
> 
> > diff --git a/arch/s390/mm/Makefile b/arch/s390/mm/Makefile
> > index 9726b91fe7e4..bd0401cc7ca5 100644
> > --- a/arch/s390/mm/Makefile
> > +++ b/arch/s390/mm/Makefile
> > @@ -12,3 +12,5 @@ obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
> >   obj-$(CONFIG_PTDUMP)		+= dump_pagetables.o
> >   obj-$(CONFIG_PGSTE)		+= gmap.o
> >   obj-$(CONFIG_PFAULT)		+= pfault.o
> > +
> > +obj-$(subst m,y,$(CONFIG_KVM))	+= gmap_helpers.o  
> 
> So gmap.o depends on PGSTE but gmap_helpers.o depends on KVM.
> Yes, PGSTE is Y if KVM is set, but this looks really strange.

yes, CONFIG_PGSTE will go away in the final series

No point in using CONFIG_PGSTE here knowing it will go away soon anyway

> 
> 
> @Heiko:
> Can we move away from CONFIG_PGSTE and start using CONFIG_KVM instead?
> Well, maybe this goes away with Claudio's rework anyway.



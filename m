Return-Path: <kvm+bounces-64387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3592C8084A
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D62FF3A88A7
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6CD30101A;
	Mon, 24 Nov 2025 12:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BGyQAZ3Z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A862DF709;
	Mon, 24 Nov 2025 12:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763988093; cv=none; b=YtiNrAWoOV5b9RyhqibKpD+wEmScLoQ7+NsK0kTAo244240IM4I6Z0YSLu3zhFuM4F2FrIP2WBdN58VVA7fYAIMwi6ORbCYvAKpKMYrgHfL3kyy46Y1Oq84UTTRWwekfOFUtk/BWJ3AgJK5CIooNWERZfCLW0N8ZFaBZ6l8gZ4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763988093; c=relaxed/simple;
	bh=g9nKGGGxinVz2GNfRGSQeb7C8DUUJ79IjopUOnm6/0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q2V0fMJ4LZqi/T1yiTPQdSc0Y0ve9rW8KlZb0xhL5Lx/20TzdqJY7SCq+8e7qGXXSTwDfpMyRYnXZv/tFW2gEiqQCaoWzcC7//8+T0OxnXBnxrrsXgrajkfju+1+DqKdhXKATP6yFWgm9zGSiI5nDiQBxXY5cQbfe2M5qkZmqcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BGyQAZ3Z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOACINs021895;
	Mon, 24 Nov 2025 12:41:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0R1PIS
	R/EXTKKPxwmaSGEGYMDPbZG4sbGHKe70do/Vg=; b=BGyQAZ3Z0UQzA4vphIK8ft
	L2aeCKsdzoXUPALh5SWSEBl4uvD1ZPGxK+eyfsr/s46m0MInEwIKbgnZI5BkoW/D
	UH1BV1+kjdmwFNneauCx97nCy5BJxWykEu0sKTwZPtSlJBjWXwOC8VkTExrsmfbQ
	58lx0bTMN11dxsg4MwgPZDXwn4LLfNOmJPtZ6Hs/2CAXOlwh1GJh0wDhyBlnPuzz
	kdiDZPqRRJBMW2n1zpiYB34A3AXYZdeEYaDq493kgpKtgnllOpX5B4Ro1nh7X7Uk
	EobeAiaCq8O6XQ79YpLw9S+VzddaImqOH163gX56iHXVw69iANEot7qO9cRgPs5w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak3kjqpyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 12:41:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOBoNT2019002;
	Mon, 24 Nov 2025 12:41:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aksqjdpkr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 12:41:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOCfP8Z41812238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 12:41:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1237220040;
	Mon, 24 Nov 2025 12:41:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86E522004B;
	Mon, 24 Nov 2025 12:41:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.31.86])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 24 Nov 2025 12:41:23 +0000 (GMT)
Date: Mon, 24 Nov 2025 13:41:20 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v5 08/23] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20251124134120.3803aede@p-imbrenda>
In-Reply-To: <9faab602-fd78-4896-bf4e-2d812d2ba5de@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
	<20251124115554.27049-9-imbrenda@linux.ibm.com>
	<9faab602-fd78-4896-bf4e-2d812d2ba5de@linux.ibm.com>
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
X-Proofpoint-GUID: GA6gFhshod7HC_1zV3A1fZI4JzO-x-Vn
X-Authority-Analysis: v=2.4 cv=frbRpV4f c=1 sm=1 tr=0 ts=69245279 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=6eJpwBt-6sF4AXm21UwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: GA6gFhshod7HC_1zV3A1fZI4JzO-x-Vn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwOCBTYWx0ZWRfX82ARo0ECZVGW
 /8P9K5gMRK3aKYagLrNkqmYp4zE6cnleZdiwAD71gr231otWQOwaDSbQPIZiBV5WG/HPcReETdn
 +1/bBRNlJbmufBm+IOq/4V7QJBiVPo3SRwxkEt1rITcbKq9rIVXltd2bVO0PWGRDne8J2lz1dB+
 D0GWUJrGevLIk9ZEPOmB2ejiaRE01q9RSmWNIdkQvhpJNjsr4083uisojZrxzm260BgrrB1ym8r
 YzhzK/yVa2yceUNIi9cndssdjgfDEm5Y0fOuWDDiPdw9DjT+uMyDhTPS3l6zpmkr39XBkXNNRKm
 gFuOBDlfSiomjO3ZQFj8FoicjKtOjznnXLgBU6y7Cf56TWpBhCgrKHoEkzD5V0l1HH6cLNRJVjF
 nVnlfFBnlklBvvHqlRC9VEErTewR6w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_05,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220008

On Mon, 24 Nov 2025 13:27:24 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/24/25 12:55, Claudio Imbrenda wrote:
> > Add page table management functions to be used for KVM guest (gmap)
> > page tables.
> > 
> > This patch adds the boilerplate and functions for the allocation and
> > deallocation of DAT tables.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> What's the cache for, why did you add it?

the cache is needed to allocate memory when we can sleep (to avoid
atomic allocations), and use it when holding spinlocks (when we can't
sleep).

this is similar to what other architectures do, except that in their
case they only have one type of page table to worry about, we need at
least 3 types of objects.

unlike other architectures, allocations from the cache can fail, and
the calling code needs to handle failures (e.g. by replenishing the
cache and trying again)

> 
> > ---
> >   arch/s390/kvm/Makefile     |   1 +
> >   arch/s390/kvm/dat.c        | 103 +++++++++++++++++++++++++++++++++++++
> >   arch/s390/kvm/dat.h        |  77 +++++++++++++++++++++++++++
> >   arch/s390/mm/page-states.c |   1 +
> >   4 files changed, 182 insertions(+)
> >   create mode 100644 arch/s390/kvm/dat.c
> > 
> > diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> > index 9a723c48b05a..84315d2f75fb 100644
> > --- a/arch/s390/kvm/Makefile
> > +++ b/arch/s390/kvm/Makefile
> > @@ -9,6 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
> >   
> >   kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
> >   kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
> > +kvm-y += dat.o
> >   
> >   kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
> >   obj-$(CONFIG_KVM) += kvm.o
> > diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
> > new file mode 100644
> > index 000000000000..c324a27f379f
> > --- /dev/null
> > +++ b/arch/s390/kvm/dat.c
> > @@ -0,0 +1,103 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + *  KVM guest address space mapping code
> > + *
> > + *    Copyright IBM Corp. 2007, 2020, 2024  
> 
> Should definitely add 2025

yes

> 
> > + *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
> > + *		 Martin Schwidefsky <schwidefsky@de.ibm.com>
> > + *		 David Hildenbrand <david@redhat.com>
> > + *		 Janosch Frank <frankja@linux.ibm.com>  
> 
> Did you retain the authors here because you bring in code from other 
> files with these authors in the future?

in the beginning I had copied stuff from other files, but things have
changed a lot. do you think I should drop the other names?


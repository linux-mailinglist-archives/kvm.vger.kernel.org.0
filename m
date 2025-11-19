Return-Path: <kvm+bounces-63699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 932E7C6E235
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 12:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 4B2442DC5C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 11:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD1F352952;
	Wed, 19 Nov 2025 11:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tHc52Usx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC7D2F5A3C;
	Wed, 19 Nov 2025 11:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763550384; cv=none; b=IQchq4VO+Wjp2H+0TAgmhggms5sgJcSwoVCMU832YNUB/sDwx55kZzUBoykt4W2cDpkoS88MqhPy5lrw+21aepiB8UQ9gXui0/p5igtyaSo5IdfD0zx7OVodTWgmAj7LGj5+HwFATThmdVy1NeqvF/dvDHhHEnKunYB4i19Aoek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763550384; c=relaxed/simple;
	bh=1uV1vmMeM6tA/4abIrzulGX4cdatfChnd623tezCQwY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpnZ1sHOSoDKjWMeymaoO/pwJsW6bm75j79vJtHbTxbdldA7EYpmYahT3dGVqpA8TbKsc/Vg6gHga4vVF7p63d5sOkQz0WsjAwgKNGGyowEITOVWKK+L3I1nnzqVhe0rGRW776E1fhQhgAMaXtPLzVLKB0ASt9QLDjre+SvrHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tHc52Usx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ4SPoa017684;
	Wed, 19 Nov 2025 11:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WObmAZ
	cEfsNWs6IKlnP++yHGWelEOCF2wjJBKwoNZmA=; b=tHc52UsxZJX3XK9m4oFhoL
	sEFRGYhw4gOn5gAU0ZiogLNpigGnQVkNah30ovAHpIPgJqtUm8Cza4zDrigbkXrO
	fwfpaZp/VNkmCjN/ZUPev9zA97KEWEOo20jX4XH7+wG5PzEgk6L5QPNScHH7Glvc
	+uMB/HOFyg8A2DD31fy7n25PbIszpc1LQjmvCbL0eK7WnAnJzJPBjRKmYr/k/rQD
	zapiutB8fox0VxamJU4mdXhnwsM7q2H0V3EMlX0oAvZn1WMBXALiFzVrqDRX7Uqe
	nsijsm2RBhZbiDCU/V7yNF1Oye/tPeLb9v3Ns2ufypPPEab7aUq3GUezH/9r+qiw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk9yy1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 11:06:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ7Pp0O005244;
	Wed, 19 Nov 2025 11:06:19 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af5bk867h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 11:06:18 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJB6EVU42336752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 11:06:15 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1FEE2004B;
	Wed, 19 Nov 2025 11:06:14 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B00F20040;
	Wed, 19 Nov 2025 11:06:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.156.96])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 19 Nov 2025 11:06:12 +0000 (GMT)
Date: Wed, 19 Nov 2025 12:06:09 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 15/23] KVM: s390: Add helper functions for fault
 handling
Message-ID: <20251119120609.4a4bf008@p-imbrenda>
In-Reply-To: <20251118151005.9674Af1-hca@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
	<20251106161117.350395-16-imbrenda@linux.ibm.com>
	<20251118151005.9674Af1-hca@linux.ibm.com>
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
X-Proofpoint-GUID: PCZXa7uLXtCC8Dgv-qApYf4PvvbyofZT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXxmj9TFKMiS4F
 ktazYnXCQlNcjDjmGRyGjqAi5+DrXiuD7Zf0BUvheAaa1vLfh9WLWPD9LIx3HyNxw5cLtsybWcC
 AmvBRQ+nyEs+Pt+OHnwUVMVubf6onF/vipNpIyhEJ9JQQrqsmQiD7rToCMUK99HONfYmyuyUFU6
 B5ASyXfRlM0p772z5WvfQn+y00gIW7yKsEbeTSjJVSLoIDj7wjCtukKBZlg/qmA0hBjqdtOReEa
 sP2KZhCyiMAnJRXSrbF6tN19Uv0Kae1sgB0Gk6+JCF3QcQx0FaKqCxQl2rzIRBQ8kYh3LEtTPtJ
 Qwsy1A8rRG4MWlxYwtHYSJ67uWK00SIraxrJVmoAXSh3tznMbHs1CeQDoWn9RuW/3SFGFLU75xr
 uZpu45xAM5cxfyr9zfB2hO9/rMoHyQ==
X-Proofpoint-ORIG-GUID: PCZXa7uLXtCC8Dgv-qApYf4PvvbyofZT
X-Authority-Analysis: v=2.4 cv=XtL3+FF9 c=1 sm=1 tr=0 ts=691da4ac cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=W69JXFrg6a1OFCXWetkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Tue, 18 Nov 2025 16:10:05 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Thu, Nov 06, 2025 at 05:11:09PM +0100, Claudio Imbrenda wrote:
> > Add some helper functions for handling multiple guest faults at the
> > same time.
> > 
> > This will be needed for VSIE, where a nested guest access also needs to
> > access all the page tables that map it.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/include/asm/kvm_host.h |   1 +
> >  arch/s390/kvm/Makefile           |   2 +-
> >  arch/s390/kvm/faultin.c          | 148 +++++++++++++++++++++++++++++++
> >  arch/s390/kvm/faultin.h          |  92 +++++++++++++++++++
> >  arch/s390/kvm/kvm-s390.c         |   2 +-
> >  arch/s390/kvm/kvm-s390.h         |   2 +
> >  6 files changed, 245 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/s390/kvm/faultin.c
> >  create mode 100644 arch/s390/kvm/faultin.h  
> 
> ...
> 
> > +int kvm_s390_faultin_gfn(struct kvm_vcpu *vcpu, struct kvm *kvm, struct guest_fault *f)
> > +{  
> 
> ...
> 
> > +		scoped_guard(read_lock, &kvm->mmu_lock) {
> > +			if (!mmu_invalidate_retry_gfn(kvm, inv_seq, f->gfn)) {
> > +				f->valid = true;
> > +				rc = gmap_link(mc, kvm->arch.gmap, f);
> > +				kvm_release_faultin_page(kvm, f->page, !!rc, f->write_attempt);
> > +				f->page = NULL;
> > +			}
> > +		}
> > +		kvm_release_faultin_page(kvm, f->page, true, false);
> > +
> > +		if (rc == -ENOMEM) {
> > +			rc = kvm_s390_mmu_cache_topup(mc);  
> 
> If I'm not mistaken then gmap_link() -> dat_link() maps the possible -ENOMEM
> return value of dat_entry() to -EAGAIN. So the case where -ENOMEM leads to a
> kvm_s390_mmu_cache_topup() call will never happen.

oops, you're right

I'll fix dat_link() accordingly


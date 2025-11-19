Return-Path: <kvm+bounces-63700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 573B8C6E30B
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 12:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D7FCC4E1451
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 11:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C6F34AAF7;
	Wed, 19 Nov 2025 11:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n2ogTN/S"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9BE239E81;
	Wed, 19 Nov 2025 11:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763550792; cv=none; b=hV6bgapRW1Rk8VhVQ+j6gJTQXS1zGns8kLT8is30QJVuFRK0/7+H36vl1RNqqDedS9f/mR5gG7d2Odm8Er93yL5NKkkb8n2aRa7EM92PNdP7/Mk1eNHcqu5rjBHIDj30ojkRun7gysNZN31vQfhdhtg5BJNpXa56yPpujhPZqvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763550792; c=relaxed/simple;
	bh=6+wHwbQbdTwDSehrC6Zb8Bo/gHpPVFE3lKKtVNubf3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGp5Z7E4OTXu+ozdrM1f9WmYmR++94PB+uaCH3EQaKOL8enToCF5zY93lx/fxlN2KoiFmrkT3ChfIds86XvTMt1Qo3YFPnqKenlKeN+8I0HVW1zGZoAXbp1G8q8p0xGv3WsbH3t5R8gJPAXm7mJUHtYzcQ556ygg1AL2kkjfRpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n2ogTN/S; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ6LmcR007805;
	Wed, 19 Nov 2025 11:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rRFFej
	4/+YYnkcd99P0JnU16kYhMs9ndKs4YVXeFNfA=; b=n2ogTN/Ssia5iCdwTa1pL9
	EspHh3rMPUqYC/jomTl76o0pBzIfDj2SSjK8sGJGshibRslafg4/fi9luIloQf2X
	VIMUYZNaJoKYlgXHAzEE2JXINWBwjFpI9HHAnkkLgsHwTwBnu3KYiliFE1JSpmx8
	hG7paZRQSwY++OkkDLsx6HOwp8/hCNVJssp+D47xv8hblAY2eMldbRN3ogcIgsz3
	FnXUk2PQN/VJfHbms3rTZFXBxDbsJ9ZPoYubIiyflbKoSmmaUZbnP4hgv5THkPbc
	vxrbZDx1oKBLQ3WqtKPLs3tMCR0NY5KRl0KTnJB0U/RISkQjiwSJxWEUN9x+FE2g
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjw82x9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 11:13:07 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ9GgIo017317;
	Wed, 19 Nov 2025 11:13:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af6j1qy69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 11:13:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJBD3Oc25100666
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 11:13:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18D1120043;
	Wed, 19 Nov 2025 11:13:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF42320040;
	Wed, 19 Nov 2025 11:13:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.156.96])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 19 Nov 2025 11:13:01 +0000 (GMT)
Date: Wed, 19 Nov 2025 12:12:58 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 18/23] KVM: s390: Switch to new gmap
Message-ID: <20251119121258.04fb1dc2@p-imbrenda>
In-Reply-To: <20251118151438.9674B91-hca@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
	<20251106161117.350395-19-imbrenda@linux.ibm.com>
	<20251118151438.9674B91-hca@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=BanVE7t2 c=1 sm=1 tr=0 ts=691da643 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=yTzIwsH_hqlntiTJneoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX7FEuKRVWi0pF
 5rg7kh4C1H4jbKESdRYd95kv4bfy98O9P14f3RBgMVbwmSTBlgtDiH+cXzm1Y0k0bmA4owTv784
 JgDO6ZkOIFPAL/G4EQRn39P0JR3qxU9GOLUhDpYjQ60WgyEQcNOSn1Fomgvi2436ZRPCtQsq44Y
 MU3LoVYFcD9JPvgNtWXPHIuri4CAHfMKIicR1bc9VfTYT3jkr55aFHgjFHndzhU36iX2aFXf76i
 ljMVnaqPeRny5y1ysXQArFeArPD7L8smyVkpdGhJBqvvw+iU0C3+v7dB7Z0KJZCylPXQhmta/BL
 RYmJ8ojE0gNKl0u/l9ekLeL+fgMjsfgtH10eRlcGGkyjgTIv39QAKmzGEIgTo+NAQFHr/aUdBuC
 xNh8BJXnlwrUA48yRXG18JeHtwgjRg==
X-Proofpoint-GUID: o7zxTRX0z8NO4BZailqVaRELub4gF6_S
X-Proofpoint-ORIG-GUID: o7zxTRX0z8NO4BZailqVaRELub4gF6_S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

On Tue, 18 Nov 2025 16:14:38 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Thu, Nov 06, 2025 at 05:11:12PM +0100, Claudio Imbrenda wrote:
> > Switch KVM/s390 to use the new gmap code.
> > 
> > Remove includes to <gmap.h> and include "gmap.h" instead; fix all the
> > existing users of the old gmap functions to use the new ones instead.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/Kconfig                   |   2 +-
> >  arch/s390/include/asm/kvm_host.h    |   5 +-
> >  arch/s390/include/asm/mmu_context.h |   4 -
> >  arch/s390/include/asm/tlb.h         |   3 -
> >  arch/s390/kvm/Makefile              |   2 +-
> >  arch/s390/kvm/diag.c                |   2 +-
> >  arch/s390/kvm/gaccess.c             | 552 +++++++++++----------
> >  arch/s390/kvm/gaccess.h             |  16 +-
> >  arch/s390/kvm/gmap-vsie.c           | 141 ------
> >  arch/s390/kvm/gmap.c                |   6 +-
> >  arch/s390/kvm/intercept.c           |  15 +-
> >  arch/s390/kvm/interrupt.c           |   2 +-
> >  arch/s390/kvm/kvm-s390.c            | 727 ++++++++--------------------
> >  arch/s390/kvm/kvm-s390.h            |  20 +-
> >  arch/s390/kvm/priv.c                | 207 +++-----
> >  arch/s390/kvm/pv.c                  |  64 +--
> >  arch/s390/kvm/vsie.c                | 117 +++--
> >  arch/s390/mm/gmap_helpers.c         |  29 --
> >  18 files changed, 710 insertions(+), 1204 deletions(-)
> >  delete mode 100644 arch/s390/kvm/gmap-vsie.c  
> 
> ...
> 
> > @@ -389,27 +358,13 @@ static int handle_sske(struct kvm_vcpu *vcpu)
> > +		scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
> > +			rc = dat_cond_set_storage_key(vcpu->arch.mc, vcpu->arch.gmap->asce,
> > +						      gpa_to_gfn(start), key, &oldkey,
> > +						      m3 & SSKE_NQ, m3 & SSKE_MR, m3 & SSKE_MC);  
> 
> ...
> 
> > @@ -1159,19 +1106,13 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
> > +			scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
> > +				rc = dat_cond_set_storage_key(vcpu->arch.mc, vcpu->arch.gmap->asce,
> > +							      gpa_to_gfn(start), key,
> > +							      NULL, nq, mr, mc);  
> 
> For the above two users I don't see any code which fills the arch.mc
> cache reliably. But chances are that I just missed it, since this
> patch is huge.

that's not necessarily a problem; if the cache is empty an atomic
allocation is attempted, which is allowed to fail. I have to check
whether we do handle the -ENOMEM case properly, though! otherwise it is
indeed a problem 



Return-Path: <kvm+bounces-63706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6CBC6EC6E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:16:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0E7124F8505
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF046189906;
	Wed, 19 Nov 2025 13:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mMOahsl3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EBD336EF5;
	Wed, 19 Nov 2025 13:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763557266; cv=none; b=AksDtgUTHE2zKMpimgd4E0LSPuxpsqvT+tPx+N9gZmcnuzS4ciwgvNKEmPPZ+KsA1iU0YJ5w6Ss++C6NBuRy+xHFSrRN6J60X4NMVEF0Oes0fuE02CXkXTfBn2gUwt3/rkc7CPZXujK8lXoIomwPMi1I5TZSRN4C3ncNX8+1TGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763557266; c=relaxed/simple;
	bh=f94cHHc1QSU5IPkPTSxxk0Uyw/LEqU/mx2dzVxlyhqE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fhQaU9Rnt+w2YgqbgsmLLAuzMp4UGSzXf5xD5fD0Uu5kP2zpDFqGyqVoMKmqWVoTDVwtA9GY7AGUijDSyynEMhfLH1VpltUJT76P+QJY+H2JphXufq6EDINErA1lZOqpfDQV5GOpyxyqFtgvkd4zHupsXybR+F1ZGS75v2vrP5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mMOahsl3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ7xAjs015515;
	Wed, 19 Nov 2025 13:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JNtvV7
	4RwliG5Nlw4zuH4ZRCQx2oqtXeTFXxda4DjuY=; b=mMOahsl3CizXSSb4RBupjo
	B4E6iNO639iJfLbFtmhpvGi+ySsJIu4A752SThzpTvuEJDXEP1iqmz9tTT8up2mj
	Y9fTlHkKcwviONhXeX1V73FmfexTDyKjt+hJhkd7V5nSmnXc2HvAxIEjhgjZ+YC5
	te9MwMI6bDxvfU8sYlsnp1YPVOcli09LHsF0Y4osZFn/1lCXnHC7o9Xwsf1/mXzF
	bPFNGFlzoQN4IeHHUxUQj0qFs93bHmgxZ5gtmMroINeHAZqQSWeYeQkGmMNXUeoE
	FL4GnyzV9Jk+f0Twl9+JqRWEYr1Wu2it1puLdlb44DH9u/Rb/spQHQ26Hz+cFIbg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejgwyp7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:00:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJAmxdd010406;
	Wed, 19 Nov 2025 13:00:58 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af3us8uwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:00:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJD0t1v42205504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:00:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08C8A2006C;
	Wed, 19 Nov 2025 13:00:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B81D2004B;
	Wed, 19 Nov 2025 13:00:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.87.156.96])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 19 Nov 2025 13:00:53 +0000 (GMT)
Date: Wed, 19 Nov 2025 14:00:51 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v3 18/23] KVM: s390: Switch to new gmap
Message-ID: <20251119140051.6d1fade2@p-imbrenda>
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
X-Proofpoint-GUID: iRwVv0as4pC3GoOvvfNb3WE8sCG9x-qt
X-Authority-Analysis: v=2.4 cv=YqwChoYX c=1 sm=1 tr=0 ts=691dbf8b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=yTzIwsH_hqlntiTJneoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: iRwVv0as4pC3GoOvvfNb3WE8sCG9x-qt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX2T71bI6XVccS
 qyRjpA1dm7IsAakxBCeUltlcT4BghXUEfRTSB/KLT7Ku7P2RZyWls5ANzy7jhq5lXmL06PmtWJt
 xhmQVLbxcuxq81xByrPlceLgWHvdxfLRNiRJpCt8e/4LqgP5lkCj3806Ieg/7/QDMpIrDBnwEuz
 /7n/EUSA2m6EL4hxy19K6NvK9tkNizWBIglqJ1tl/2xeTBeJPO7AoyrLeBiQ7RRSXo+ArnKd8QE
 87Wo36sGuBaKq3umkmjICN7kz9WXF412vkJvxniL+rz0XhcOld5lVuWFmyqDswzzTJIgIIoENfQ
 UIY5M+ltszu82r2pCfopqKnwryQIVS48AD2VEx8Wxk/2X4Dudd6OkB26/wngJ6T4/vThfQ3O9r1
 yyTUa2hec6lu2xpvFZlE6SfbwijQpw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032

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

I checked, I was indeed not doing it anywhere, oops!


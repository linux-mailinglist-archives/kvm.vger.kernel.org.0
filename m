Return-Path: <kvm+bounces-68013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B8BD1DBB1
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 10:54:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1977430096AC
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 09:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54F338757B;
	Wed, 14 Jan 2026 09:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eaTrg3gh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6A830E0D2;
	Wed, 14 Jan 2026 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768384441; cv=none; b=HiQWZlLy1uj8ana26bMpcldrhIqB75RsXt6DcBm39/Gn/r/Ax3bU11zT/5W6pTmTMvIJplsIwhbor6IvjmhLptl+vpSKXhrc36MwodYaAi3Kwdxf4RpzglGHdMcT0RZB2euJ5Os7mJvJ4UyL6yJtP07IIKQrXJ6AHD5x/gxccTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768384441; c=relaxed/simple;
	bh=kVEHx2+Ge+rtGYjTAJLRHj62Kt9E1pbheNzuU9l4yMM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HoleUkHUBt9DnBB/FntkxbHksu6B33PHeFZWwiF6JfqOXbz6V6QHHgM14wcPwxsWj65CweKw1LtQrLqts5vx3QkI/dYg45O51a8jDUOFdwcNU9wqv3Za2R32vlli744aWcHIv5b3+jOR8m5CSi3bIgYXgBHe8LVYgIgydQFZMTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eaTrg3gh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60E7X74Y010955;
	Wed, 14 Jan 2026 09:53:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=aeE+Ru
	ciR36YBexJDcUegWDbTDMlurG0mpHa6t8+zAo=; b=eaTrg3gh+rrifF931Xk7av
	Ey0mi14B/OhHrODujXCBAF78wgXb9yOgfWS/P9m7PfbVssTLQqj5L7SNTJPyqqJa
	B56Zm+La1Px7MHekk+wY0nEkGoqgJ3Jd9Aesb41JEE7sZjUp1H4ebYb9J/u+J8YF
	xY56H+OO97UDqmVQjDoW3gtfxU8q5ijy6If3y8xVce4heLm6WkZBD7SDzxnQ13Zl
	tK7AyqIxTcunSsSD8cuetEJPWkuaCI9RwgD9sMIiQQGpPPsTgyBcuebC6RdlvgNp
	7TyU1QKJyTl1kU4DFlojw1694i6fxQ7E47NwjW1lM84eLCrfmPdBJigixsqfx9Tg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkeg4gpe9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 09:53:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60E83lQl030134;
	Wed, 14 Jan 2026 09:53:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bm3ajs5se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 09:53:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60E9rqwi61800892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 09:53:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C13220043;
	Wed, 14 Jan 2026 09:53:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45F5820040;
	Wed, 14 Jan 2026 09:53:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Jan 2026 09:53:52 +0000 (GMT)
Date: Wed, 14 Jan 2026 10:53:50 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <borntraeger@de.ibm.com>,
        <frankja@linux.ibm.com>, <nsg@linux.ibm.com>, <nrb@linux.ibm.com>,
        <seiden@linux.ibm.com>, <gra@linux.ibm.com>, <hca@linux.ibm.com>,
        <svens@linux.ibm.com>, <agordeev@linux.ibm.com>, <gor@linux.ibm.com>,
        <david@redhat.com>, <gerald.schaefer@linux.ibm.com>
Subject: Re: [PATCH v6 28/28] KVM: s390: Storage key manipulation IOCTL
Message-ID: <20260114105350.6a95fa53@p-imbrenda>
In-Reply-To: <DFO7J08IZ4HZ.3O6LSE6J09CD3@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
	<20251222165033.162329-29-imbrenda@linux.ibm.com>
	<DFO7J08IZ4HZ.3O6LSE6J09CD3@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA3OSBTYWx0ZWRfX+McUwYJuxYXe
 oDWFkkClTJqZUxcahnnXN/gkpoBmY11zUTwkZZ6+v12FTnhjOSuOvzjaPdXQHtlvUY0lhEuSjWt
 cUlDR3L5HYlCabSHOprGAikBDyrTkytDDU7sd9qU6toYdC5SXI6Af0oXn8plsPSw7oUK6u7Masa
 RP47LuG2Y5RsLFiYkS8/jkV7+XCtIui3fXNPIX+YQ5DozJNndG9bgq9S92dmcIxax2xuzGeMHqb
 T9YBG6GflkpFpIi+Z3HAoB/csxk4k0xWNz7gafjXZsTI5tZTW8ep0kYv1n8QQqk/mzNlUWj13Y0
 UcGEoMFlqBhxo15DGiiRdqI5WSinb6CbxTqRCnWhkDyexNcx/oTx4c5um2COfrm+EvrKJ7zatAl
 okjQZ5PvioVwgxxrz/cXHKmr6dyURNfUxeKhlLQpoatG09YcXci0oz2UMTCJKMbpCLlCgTrg2UM
 vub4zd9UZr/e3qbYsbg==
X-Proofpoint-ORIG-GUID: 0qtyupwZigY2QrfRcn99XXyDPQs4hEYj
X-Authority-Analysis: v=2.4 cv=B/60EetM c=1 sm=1 tr=0 ts=696767b5 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=-AY-3KQBEn9c_OmloDAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 0qtyupwZigY2QrfRcn99XXyDPQs4hEYj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601140079

On Wed, 14 Jan 2026 10:33:22 +0100
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> On Mon Dec 22, 2025 at 5:50 PM CET, Claudio Imbrenda wrote:
> > Add a new IOCTL to allow userspace to manipulate storage keys directly.
> >
> > This will make it easier to write selftests related to storage keys.
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> Please add some user documentation for the new IOCTL.

already done, it will be in the next iteration.
and also a capability for the new ioctl

> 
> [...]
> 
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index dddb781b0507..845417e56778 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1219,6 +1219,15 @@ struct kvm_vfio_spapr_tce {
> >  	__s32	tablefd;
> >  };
> >  
> > +#define KVM_S390_KEYOP_SSKE 0x01
> > +#define KVM_S390_KEYOP_ISKE 0x02
> > +#define KVM_S390_KEYOP_RRBE 0x03  
> 
> Just a nitpik, but why this order? In the arch the order is ISKE, SSKE, RRBE.
> Would it not be more logical to keep that order?

I don't know why I chose that order, I guess I can reorder it. It
doesn't really make a difference, but I guess consistency is good

> 
> > +struct kvm_s390_keyop {
> > +	__u64 user_addr;
> > +	__u8  key;
> > +	__u8  operation;
> > +};
> > +
> >  /*
> >   * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
> >   * a vcpu fd.
> > @@ -1238,6 +1247,7 @@ struct kvm_vfio_spapr_tce {
> >  #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
> >  #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
> >  #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
> > +#define KVM_S390_KEYOP           _IOWR(KVMIO, 0x53, struct kvm_s390_keyop)
> >  
> >  /* Device model IOC */
> >  #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)  
> 



Return-Path: <kvm+bounces-42620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E33A7B6E9
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 06:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 148F5176C18
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 04:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F321553A3;
	Fri,  4 Apr 2025 04:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XJY0Jxm/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD852F42;
	Fri,  4 Apr 2025 04:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743741394; cv=none; b=dw0/Iet2iVXwzq7kcriRR9FJK9RtrgR/RXUjXFwnoBXnAZV9hzTRbyW6+Lci+YCKpa+nSx9x6Cg13jqARXc5DMappcVvgJFFuxKPh9+91isxQAVwA8FOZrG7lma47tO4fcBJ1y8RFTyy2jZhSy3T7rH9CuyGtoKxrk0mVwnT6MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743741394; c=relaxed/simple;
	bh=0vjqbI54XhzhHUQdiVGUjW5y+D0bq8M2T6mXQZfmY/4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LLU3MonkchMdxXw5ZjeYNKYA+uSjLplfNkhBKT7FaOdj9aMNpxy3sxpTSk/8V7q4GItQ21NmD+a6Y4t+pbTbpwsPu2/rNHEXtaUacFlyPEXzatAiVZH9C0ZQ6ISUPINpSNCm5EAHU8fKCmiVUeN1w64kMz3dK/VKOJuO49wV3uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XJY0Jxm/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5341hWjO018160;
	Fri, 4 Apr 2025 04:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=a6sLxc
	S3TcvfwEy5jkDxKLI0Y3bZtHPLoHbD+dRqtSo=; b=XJY0Jxm/QcEKYMU8zN41p/
	ZPVkowhUC4M4aGR4kz3iVtnSo/wFpSG2Qim1TmqGM1RG0Kk5lOqFiR/CyEkxkYKH
	Ptt4qeiM4Ba1UX5dRLg2WPoNX5WCl9IJfQEpPFiuF0XTG4ssYifdJRW38WcNRYqR
	xtFEoRJB1oyAn2R3/M1rDd9PeP/7AnF16kgUSWpnYqcL6uhzRfWXL2DAgsnmCPwq
	hcs+Rdw1tHjYKAsG7rtXmcQIgbEMepMJMKWtxEJlGW89hB8YrYDRC/Y8h1qjJoFs
	GKCogugY/zCk5k6PHBq3CMyKULLlHLwt406bOsAdU8stPiWcl7ri9twUHxP+8cig
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45t2qb18am-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 04:36:26 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5341xOJk031088;
	Fri, 4 Apr 2025 04:36:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45t2e4sbr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 04:36:25 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5344aLlq44171660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Apr 2025 04:36:21 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1CA12004B;
	Fri,  4 Apr 2025 04:36:21 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F36F820043;
	Fri,  4 Apr 2025 04:36:20 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.55.30])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  4 Apr 2025 04:36:20 +0000 (GMT)
Date: Fri, 4 Apr 2025 06:36:19 +0200
From: Halil Pasic <pasic@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        Chandra Merla
 <cmerla@redhat.com>, Stable@vger.kernel.org,
        Cornelia Huck
 <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Eric Farman
 <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wei Wang
 <wei.w.wang@intel.com>, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250404063619.0fa60a41.pasic@linux.ibm.com>
In-Reply-To: <e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
References: <20250402203621.940090-1-david@redhat.com>
	<20250403161836.7fe9fea5.pasic@linux.ibm.com>
	<e2936e2f-022c-44ee-bb04-f07045ee2114@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _z-VbjkG-r5cBAIZ-IvKSRNxA8KWz6XU
X-Proofpoint-GUID: _z-VbjkG-r5cBAIZ-IvKSRNxA8KWz6XU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_01,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502280000 definitions=main-2504040025

On Thu, 3 Apr 2025 16:28:31 +0200
David Hildenbrand <david@redhat.com> wrote:

> > Sorry I have to have a look at that discussion. Maybe it will answer
> > some my questions.  
> 
> Yes, I think so.
> 
> >   
> >> Let's fix it without affecting existing setups for now by properly
> >> ignoring the non-existing queues, so the indicator bits will match
> >> the queue indexes.  
> > 
> > Just one question. My understanding is that the crux is that Linux
> > and QEMU (or the driver and the device) disagree at which index
> > reporting_vq is actually sitting. Is that right?  
> 
> I thought I made it clear: this is only about the airq indicator bit. 
> That's where both disagree.
> 
> Not the actual queue index (see above).

I did some more research including having a look at that discussion. Let
me try to sum up how did we end up here.

Before commit a229989d975e ("virtio: don't allocate vqs when names[i] =
NULL") the kernel behavior used to be in spec, but QEMU and possibly
other hypervisor were out of spec and things did not work.

Possibly because of the complexity of fixing the hypervisor(s) commit
a229989d975e ("virtio: don't allocate vqs when names[i] = NULL") opted
for changing the guest side so that it does not fit the spec but fits
the hypervisor(s). It unfortunately also broke notifiers (for the with
holes) scenario for virtio-ccw only.

Now we had another look at this, and have concluded that fixing the
hypervisor(s) and fixing the kernel, and making sure that the fixed
kernel can tolerate the old broken hypervisor(s) is way to complicated
if possible at all. So we decided to give the spec a reality check and
fix the notifier bit assignment for virtio-ccw which is broken beyond
doubt if we accept that the correct virtqueue index is the one that the
hypervisor(s) use and not the one that the spec says they should use.

With the spec fixed, the whole notion of "holes" will be something that
does not make sense any more. With that the merit of the kernel interface
virtio_find_vqs() supporting "holes" is quite questionable. Now we need
it because the drivers within the Linux kernel still think of the queues
in terms of the current spec, i.e. they try to have the "holes" as
mandated by the spec, and the duty of making it work with the broken
device implementations falls to the transports.

Under the assumption that the spec is indeed going to be fixed:

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

Regards,
Halil


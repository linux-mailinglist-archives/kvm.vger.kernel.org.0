Return-Path: <kvm+bounces-40079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E5F6A4EEF5
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:00:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E13718932A6
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 21:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C13276D3C;
	Tue,  4 Mar 2025 21:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jg7hpmhW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5611F7076;
	Tue,  4 Mar 2025 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122028; cv=none; b=CAIzqXfXBAEYAzhLA+u13cs4omUSalSsCuDB8ns0EKXdcluF/ouZaPOPQJ2dBk+ZQuWNB/6pgVle6nwONj6FHpiiDvDXr7kCQXWVBmdpSrX7ef6KqYookGah0c+dLDTuuXqcK5FYDwtebG+JkvmZ+JJFgL08L6S54/ciuVEEDnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122028; c=relaxed/simple;
	bh=0Z+9kiKDFnIcXDbnRazK7aF//miZ0UNiijEm8N+3uoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgZQoKf5HRXfGBLG7uoFRucxpu70ZBU2YivWryHUtkEOcvymflrALXw5JqzKU2gDW0n5ZhDvkhcMeI0UmAs/SoSUQoqIqH/d5rshJZnXtmNDxDjiMOxPG0p8dQXrvf0X/2V8n7kKCA47aKdPZ9MBf5g+MWNOrTBsTrIwJD4Xgxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jg7hpmhW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524Kci5k014511;
	Tue, 4 Mar 2025 21:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7xGcW4sgPBDzi5F3yytDSrPK1EIb9h
	kVolhk9uQtGJg=; b=jg7hpmhWdNxpOX1nXZLn/4Uso9wQuzVEmzCHPtFqJo9tL7
	E0KVv1eqA0csutba8M5TD0pRU+jZVj1vN4vi+x7sJOs5stZ7icv8Ag49GJY4ay7L
	T9esr9DGa2EWlfw2Rl2D4VSWDzEVBBQ6J+/pg2b0lGviHi4ZO+8QkWod+uyMMDR5
	cKa7UjTDZRsGMPwQFstr33MfkraaoDpvxHXQ5KXDJQNVIrT7Yw04V8XpEHmOVOQQ
	Kc1BZ8CCXPbSxC2f8RQkkT1uP6u+tFfV3w3LuqJHNPY7294eAtQbevw1t4odoKlK
	Yso85sZ+iP+ouPjPIqleFzFs1j168gME2tyOt2gg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4568r0g21c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 21:00:23 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 524I9bpY031827;
	Tue, 4 Mar 2025 21:00:23 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 454cjsym47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 21:00:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 524L0Jhf35914166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 21:00:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC6AF20049;
	Tue,  4 Mar 2025 21:00:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2138C20040;
	Tue,  4 Mar 2025 21:00:19 +0000 (GMT)
Received: from localhost (unknown [9.171.29.134])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  4 Mar 2025 21:00:19 +0000 (GMT)
Date: Tue, 4 Mar 2025 22:00:17 +0100
From: Vasily Gorbik <gor@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: Rorie Reyes <rreyes@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hca@linux.ibm.com,
        borntraeger@de.ibm.com, agordeev@linux.ibm.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com, alex.williamson@redhat.com
Subject: Re: [RFC PATCH v2] s390/vfio-ap: Notify userspace that guest's AP
 config changed when mdev removed
Message-ID: <your-ad-here.call-01741122017-ext-6684@work.hours>
References: <20250304200812.54556-1-rreyes@linux.ibm.com>
 <a3e051e0-b2c3-4e2e-961e-ee36956a5666@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a3e051e0-b2c3-4e2e-961e-ee36956a5666@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CCrlg6u0lCcKuuLz5-j3vf6tp7cd-_fF
X-Proofpoint-ORIG-GUID: CCrlg6u0lCcKuuLz5-j3vf6tp7cd-_fF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_09,2025-03-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503040168

On Tue, Mar 04, 2025 at 03:11:12PM -0500, Anthony Krowiak wrote:
> On 3/4/25 3:08 PM, Rorie Reyes wrote:
> > The guest's AP configuration is cleared when the mdev is removed, so
> > userspace must be notified that the AP configuration has changed. To this
> > end, this patch:
> > 
> > * Removes call to 'signal_guest_ap_cfg_changed()' function from the
> >    'vfio_ap_mdev_unset_kvm()' function because it has no affect given it is
> >    called after the mdev fd is closed.
> > 
> > * Adds call to 'signal_guest_ap_cfg_changed()' function to the
> >    'vfio_ap_mdev_request()' function to notify userspace that the guest's
> >    AP configuration has changed before signaling the request to remove the
> >    mdev.
> > 
> > Minor change - Fixed an indentation issue in function
> > 'signal_guest_ap_cfg_changed()'
> > 
> > Fixes: 07d89045bffe ("s390/vfio-ap: Signal eventfd when guest AP configuration is changed")
> > Signed-off-by: Rorie Reyes <rreyes@linux.ibm.com>
> > ---
> > This patch is based on the s390/features branch
> > 
> > V1 -> V2:
> > - replaced get_update_locks_for_kvm() with get_update_locks_for_mdev
> > - removed else statements that were unnecessary
> > - Addressed review comments for commit messages/details
> > ---
> >   drivers/s390/crypto/vfio_ap_ops.c | 15 ++++++++++++---
> >   1 file changed, 12 insertions(+), 3 deletions(-)

> > @@ -2068,6 +2074,9 @@ static void vfio_ap_mdev_request(struct vfio_device *vdev, unsigned int count)
> >   		dev_notice(dev,
> >   			   "No device request registered, blocked until released by user\n");
> >   	}
> > +
> > +	release_update_locks_for_mdev(matrix_mdev);
> > +
> 
> Get rid of empty line; other than that, LGTM
> Reviewed-by: Anthony Krowiak <akrowiak@linux.ibm.com>

Removed the empty line and applied, thank you!


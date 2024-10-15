Return-Path: <kvm+bounces-28847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D4F99E117
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E1181F22ADC
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 08:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250FD1CACCE;
	Tue, 15 Oct 2024 08:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C5Pr17Sh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EF620EB;
	Tue, 15 Oct 2024 08:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728981057; cv=none; b=dhNdAe44rwUSykxhcjClw0Lkr8KOEe6toUJ9qAqwFx823d2k9DqYx1WbmhB+Dmcsj3uowXH7XkLrifO5CgVv5rNQoaODMzP2Bjwd9oFEh2CA2j532DUbRSuTkQu3dVyQJh/SygNjHQ0Osy/cnMfq1xEuhWhUuo6TVLoOLpLacI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728981057; c=relaxed/simple;
	bh=NZogJTqwE3+iAzauO0rol1tMx6AnCvQkjO6kq9LSwbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YgiCIMcJTryzWehFnfsgvj2rodupcrQytlGBoXEHi0yOkwO39kgCqCAu8bJxpc5enDHSfo3gkpOg37TKS9jPpXo8AElh3iHNjouZzEnLL+s8YeYV2UMtv9qeiT0+qfFbGP0/zFW8swXps01K41UB/hkn9n65bfwqOvBY4ZT2ltw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C5Pr17Sh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F8PZcA024028;
	Tue, 15 Oct 2024 08:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=IE4Ofqj1wFLXj4ZSqKW5+xLXr/77Os
	ziB9/RuCpA9XA=; b=C5Pr17Shb56/6mLJ3iERofYB//d0rtG9UucRGlloqJiyr8
	fLy0oxFKu/4YNhPtUGWIvvUngrKaWT+yd/cUZW1A1Kjp/oH20AE+GQxXD0OHhh9Y
	M0pO2oIT8mJ8A0nrjCv+WygqZzFZF2CMvU1VApc3qWOIMYxiIf5SRogljPZdWFFC
	UAelL3AqHo+CtkTiuVH3hy1OCXAU32iU4AmN1WqRwxqbE5QWX/0Fc2TSmfqiW/jb
	aHbCEIbYnEW9kWgdDuFJNiUfOSCsMSbBDsJJAqqxPia1Ut8gaMKWn3ELJ9mz6nxV
	sj5nyB1QKlapcILSEDO6YgjCCYzTZ22Ol8lKlfbQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429mv4r0wj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:30:48 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F8Ul8m003486;
	Tue, 15 Oct 2024 08:30:47 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429mv4r0we-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:30:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F7bpIT027464;
	Tue, 15 Oct 2024 08:30:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283txjtyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:30:46 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F8UgQ754133178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 08:30:42 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4DFE720043;
	Tue, 15 Oct 2024 08:30:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C69A20040;
	Tue, 15 Oct 2024 08:30:42 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 08:30:41 +0000 (GMT)
Date: Tue, 15 Oct 2024 10:30:40 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 1/7] s390/kdump: implement is_kdump_kernel()
Message-ID: <20241015083040.7641-C-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-2-david@redhat.com>
 <20241014182054.10447-D-hca@linux.ibm.com>
 <f93b2c89-821a-4da1-8953-73ccd129a074@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f93b2c89-821a-4da1-8953-73ccd129a074@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -AyqpN-uN4c-bHJlXc5K2WqcxF25sGU_
X-Proofpoint-ORIG-GUID: FOpmIxPaiaZwA4qPJKRUNqvsir83gI5C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 mlxlogscore=515
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150056

On Mon, Oct 14, 2024 at 09:26:03PM +0200, David Hildenbrand wrote:
> On 14.10.24 20:20, Heiko Carstens wrote:
> > Looks like this could work. But the comment in smp.c above
> > dump_available() needs to be updated.
> 
> A right, I remember that there was some outdated documentation.
> 
> > 
> > Are you willing to do that, or should I provide an addon patch?
> > 
> 
> I can squash the following:
> 
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index 4df56fdb2488..a4f538876462 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -587,16 +587,16 @@ int smp_store_status(int cpu)
>   *    with sigp stop-and-store-status. The firmware or the boot-loader
>   *    stored the registers of the boot CPU in the absolute lowcore in the
>   *    memory of the old system.
> - * 3) kdump and the old kernel did not store the CPU state,
> - *    or stand-alone kdump for DASD
> - *    condition: OLDMEM_BASE != NULL && !is_kdump_kernel()
> + * 3) kdump or stand-alone kdump for DASD
> + *    condition: OLDMEM_BASE != NULL && !is_ipl_type_dump() == false
>   *    The state for all CPUs except the boot CPU needs to be collected
>   *    with sigp stop-and-store-status. The kexec code or the boot-loader
>   *    stored the registers of the boot CPU in the memory of the old system.
> - * 4) kdump and the old kernel stored the CPU state
> - *    condition: OLDMEM_BASE != NULL && is_kdump_kernel()
> - *    This case does not exist for s390 anymore, setup_arch explicitly
> - *    deactivates the elfcorehdr= kernel parameter
> + *
> + * Note that the old Kdump mode where the old kernel stored the CPU state

To be consistent with the rest of the comment, please write kdump in
all lower case characters, please.

> + * does no longer exist: setup_arch explicitly deactivates the elfcorehdr=
> + * kernel parameter. The is_kudmp_kernel() implementation on s390 is independent

Typo: kudmp.

> Does that sound reasonable? I'm not so sure about the "2) stand-alone kdump for
> SCSI/NVMe (zfcp/nvme dump with swapped memory)": is that really "kdump" ?

Yes, it is some sort of kdump, even though a bit odd. But the comment
as it is doesn't need to be changed. Only at the very top, please also
change: "There are four cases" into "There are three cases".

Then it all looks good. Thanks a lot!


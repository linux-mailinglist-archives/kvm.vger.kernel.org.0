Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E3823C30
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 17:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbfETPbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 11:31:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731262AbfETPbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 11:31:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KFIvpF144705;
        Mon, 20 May 2019 15:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=SXUGhLzqu7OWeZA9OhKeGyoXs0a41JQJFMDBXBRPnVs=;
 b=LDlo2JtnsgqOL7mMI0IvGprzfGCy4to4pDQltq8uHsDWRMZ5fLF/GBmkz/DPJG16d8+E
 AphQu0yTg9IX/1qILAVa03FMrn/a0QMIcIuzCfG1x9RXcoTeKLnRbqhxI/u2l3T5i+FO
 sRlFZbwrPkqowmNwuDTdSihMC/nz2onnFmvR1s6zTFTGeAGe8PUto+cDd13QJ16HajNT
 QbD1ITdOCo1utBuP6VExYHrORa14RnduNx9MSIKtrhSnSUFWInHvA7sGpIa4C3sHrOG/
 WMBhF9YM8ifc8XjdVeMUyguDzXTtV5vjfUAJ6BjL40xkPh1CGr3Uvt8OkhE+dqxwuqE3 /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sj9ft7sn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 15:30:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KFTuDs046722;
        Mon, 20 May 2019 15:30:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2sks18nr8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 15:30:34 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KFUL5K012431;
        Mon, 20 May 2019 15:30:21 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 15:30:21 +0000
Date:   Mon, 20 May 2019 11:30:20 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        akpm@linux-foundation.org, Alan Tull <atull@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Lameter <cl@linux.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Moritz Fischer <mdf@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Steve Sistare <steven.sistare@oracle.com>,
        Wu Hao <hao.wu@intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add account_locked_vm utility function
Message-ID: <20190520153020.mzvjsjwefwxz6cau@ca-dmjordan1.us.oracle.com>
References: <20190503201629.20512-1-daniel.m.jordan@oracle.com>
 <4b42057f-b998-f87c-4e0f-a91abcb366f9@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b42057f-b998-f87c-4e0f-a91abcb366f9@ozlabs.ru>
User-Agent: NeoMutt/20180323-268-5a959c
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9262 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=18 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200100
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9262 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=18 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 04:19:34PM +1000, Alexey Kardashevskiy wrote:
> On 04/05/2019 06:16, Daniel Jordan wrote:
> > locked_vm accounting is done roughly the same way in five places, so
> > unify them in a helper.  Standardize the debug prints, which vary
> > slightly.
> 
> And I rather liked that prints were different and tell precisely which
> one of three each printk is.

I'm not following.  One of three...callsites?  But there were five callsites.

Anyway, I added a _RET_IP_ to the debug print so you can differentiate.

> I commented below but in general this seems working.
> 
> Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks!  And for the review as well.

> > diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> > index 6b64e45a5269..d39a1b830d82 100644
> > --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> > +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> > @@ -34,49 +35,13 @@
> >  static void tce_iommu_detach_group(void *iommu_data,
> >  		struct iommu_group *iommu_group);
> >  
> > -static long try_increment_locked_vm(struct mm_struct *mm, long npages)
> > +static int tce_account_locked_vm(struct mm_struct *mm, unsigned long npages,
> > +				 bool inc)
> >  {
> > -	long ret = 0, locked, lock_limit;
> > -
> >  	if (WARN_ON_ONCE(!mm))
> >  		return -EPERM;
> 
> 
> If this WARN_ON is the only reason for having tce_account_locked_vm()
> instead of calling account_locked_vm() directly, you can then ditch the
> check as I have never ever seen this triggered.

Great, will do.

> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index d0f731c9920a..15ac76171ccd 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -273,25 +273,14 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
> >  		return -ESRCH; /* process exited */
> >  
> >  	ret = down_write_killable(&mm->mmap_sem);
> > -	if (!ret) {
> > -		if (npage > 0) {
> > -			if (!dma->lock_cap) {
> > -				unsigned long limit;
> > -
> > -				limit = task_rlimit(dma->task,
> > -						RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > -
> > -				if (mm->locked_vm + npage > limit)
> > -					ret = -ENOMEM;
> > -			}
> > -		}
> > +	if (ret)
> > +		goto out;
> 
> 
> A single "goto" to jump just 3 lines below seems unnecessary.

No strong preference here, I'll take out the goto.

> > +int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
> > +			struct task_struct *task, bool bypass_rlim)
> > +{
> > +	unsigned long locked_vm, limit;
> > +	int ret = 0;
> > +
> > +	locked_vm = mm->locked_vm;
> > +	if (inc) {
> > +		if (!bypass_rlim) {
> > +			limit = task_rlimit(task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > +			if (locked_vm + pages > limit) {
> > +				ret = -ENOMEM;
> > +				goto out;
> > +			}
> > +		}
> 
> Nit:
> 
> if (!ret)
> 
> and then you don't need "goto out".

Ok, sure.

> > +		mm->locked_vm = locked_vm + pages;
> > +	} else {
> > +		WARN_ON_ONCE(pages > locked_vm);
> > +		mm->locked_vm = locked_vm - pages;
> 
> 
> Can go negative here. Not a huge deal but inaccurate imo.

I hear you, but setting a negative value to zero, as we had done previously,
doesn't make much sense to me.

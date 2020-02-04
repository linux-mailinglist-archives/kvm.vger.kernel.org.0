Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FF8151A17
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 12:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgBDLsK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 4 Feb 2020 06:48:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727004AbgBDLsK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 06:48:10 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 014Bkung128051
        for <kvm@vger.kernel.org>; Tue, 4 Feb 2020 06:48:09 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxy9j1v0h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 06:48:08 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 4 Feb 2020 11:48:06 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Feb 2020 11:48:04 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 014Bm2Jb59900096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Feb 2020 11:48:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A24A042042;
        Tue,  4 Feb 2020 11:48:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A3714203F;
        Tue,  4 Feb 2020 11:48:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.108])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Feb 2020 11:48:02 +0000 (GMT)
Date:   Tue, 4 Feb 2020 12:48:01 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 05/37] s390/mm: provide memory management functions for
 protected KVM guests
In-Reply-To: <20200204115738.3336787a.cohuck@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-6-borntraeger@de.ibm.com>
        <20200204115738.3336787a.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 20020411-0016-0000-0000-000002E38D42
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020411-0017-0000-0000-0000334668B7
Message-Id: <20200204124801.154548a7@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-04_02:2020-02-04,2020-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002040083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Feb 2020 11:57:38 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Mon,  3 Feb 2020 08:19:25 -0500
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> 
> > From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > 
> > This provides the basic ultravisor calls and page table handling to
> > cope with secure guests.  
> 
> I'll leave reviewing the mm stuff to somebody actually familiar with
> mm; only some other comments from me.
> 
> > 
> > Co-authored-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  arch/s390/include/asm/gmap.h        |   2 +
> >  arch/s390/include/asm/mmu.h         |   2 +
> >  arch/s390/include/asm/mmu_context.h |   1 +
> >  arch/s390/include/asm/page.h        |   5 +
> >  arch/s390/include/asm/pgtable.h     |  34 +++++-
> >  arch/s390/include/asm/uv.h          |  59 ++++++++++
> >  arch/s390/kernel/uv.c               | 170
> > ++++++++++++++++++++++++++++ 7 files changed, 268 insertions(+), 5
> > deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/gmap.h
> > b/arch/s390/include/asm/gmap.h index 37f96b6f0e61..f2ab8b6d4b57
> > 100644 --- a/arch/s390/include/asm/gmap.h
> > +++ b/arch/s390/include/asm/gmap.h
> > @@ -9,6 +9,7 @@
> >  #ifndef _ASM_S390_GMAP_H
> >  #define _ASM_S390_GMAP_H
> >  
> > +#include <linux/radix-tree.h>
> >  #include <linux/refcount.h>
> >  
> >  /* Generic bits for GMAP notification on DAT table entry changes.
> > */ @@ -61,6 +62,7 @@ struct gmap {
> >  	spinlock_t shadow_lock;
> >  	struct gmap *parent;
> >  	unsigned long orig_asce;
> > +	unsigned long se_handle;  
> 
> This is a deviation from the "protected virtualization" naming scheme
> used in the previous patches, but I understand that the naming of this
> whole feature is still in flux :) (Would still be nice to have it
> consistent, though.)
> 
> However, I think I'd prefer something named based on protected
> virtualization: the se_* stuff here just tends to make me think of
> SELinux...
> 
> >  	int edat_level;
> >  	bool removed;
> >  	bool initialized;
> > diff --git a/arch/s390/include/asm/mmu.h
> > b/arch/s390/include/asm/mmu.h index bcfb6371086f..984026cb3608
> > 100644 --- a/arch/s390/include/asm/mmu.h
> > +++ b/arch/s390/include/asm/mmu.h
> > @@ -16,6 +16,8 @@ typedef struct {
> >  	unsigned long asce;
> >  	unsigned long asce_limit;
> >  	unsigned long vdso_base;
> > +	/* The mmu context belongs to a secure guest. */
> > +	atomic_t is_se;  
> 
> Here as well.
> 
> >  	/*
> >  	 * The following bitfields need a down_write on the mm
> >  	 * semaphore when they are written to. As they are only  
> 
> (...)
> 
> > @@ -520,6 +521,15 @@ static inline int mm_has_pgste(struct
> > mm_struct *mm) return 0;
> >  }
> >  
> > +static inline int mm_is_se(struct mm_struct *mm)
> > +{
> > +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> > +	if (unlikely(atomic_read(&mm->context.is_se)))
> > +		return 1;
> > +#endif
> > +	return 0;
> > +}  
> 
> I'm wondering how big of an overhead we actually have because we need
> to check the flag here if the feature is enabled. We have an extra
> check in a few functions anyway, even if protected virt is not
> configured in. Given that distributions would likely want to enable
> the feature in their kernels, I'm currently tending towards dropping
> the extra config option.
> 
> > +
> >  static inline int mm_alloc_pgste(struct mm_struct *mm)
> >  {
> >  #ifdef CONFIG_PGSTE  
> 
> (...)
> 
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index f7778493e829..136c60a8e3ca 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -9,6 +9,8 @@
> >  #include <linux/sizes.h>
> >  #include <linux/bitmap.h>
> >  #include <linux/memblock.h>
> > +#include <linux/pagemap.h>
> > +#include <linux/swap.h>
> >  #include <asm/facility.h>
> >  #include <asm/sections.h>
> >  #include <asm/uv.h>
> > @@ -98,4 +100,172 @@ void adjust_to_uv_max(unsigned long *vmax)
> >  	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
> >  		*vmax = uv_info.max_sec_stor_addr;
> >  }
> > +
> > +static int __uv_pin_shared(unsigned long paddr)
> > +{
> > +	struct uv_cb_cfs uvcb = {
> > +		.header.cmd	= UVC_CMD_PIN_PAGE_SHARED,
> > +		.header.len	= sizeof(uvcb),
> > +		.paddr		= paddr,
> > +	};
> > +
> > +	if (uv_call(0, (u64)&uvcb))
> > +		return -EINVAL;
> > +	return 0;  
> 
> I guess this call won't set an error rc in the control block, if it
> does not set a condition code != 0?

correct.
(cc == 0) ⇔ (rc == 1) which is success.
any rc other than 1 sets cc = 1



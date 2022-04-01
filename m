Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E84B4EEF4C
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 16:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346820AbiDAO1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 10:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235713AbiDAO1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 10:27:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEF613DB4D;
        Fri,  1 Apr 2022 07:25:21 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231DjFGM012995;
        Fri, 1 Apr 2022 14:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Trnly/bmHwEiMuh5ezmXYQ4lhEA0oOaqXu0QeyR00/k=;
 b=BvoWF7CS4nwQbPpGerfxa6g5qG3rtWQCyJtPeYZ5pf3zl4ofu5WX9Q3b704sTbJBVGgj
 1BcscUrIA6OfClclDnOoBAXMebHSY2GVUqQ/X4WNYyYis9XI/BYXhK+Ue0+kVf/ArH3x
 hc2TsaTLey9PfYMjEFi5ty7gxApjLANkvKkIKTDPN/OBZr6PZB/r6V6TmAg/NTJCaNDT
 rcGD9Vwv0fuzn/PKuKiZBqe5EU9C1J3+kHVnRXRyI8bNmwF07Z88JEPMg6PqHscTmDlG
 im+4w6r89ROPPK3uuF80rkitOjK68KXT2+InIdhYa4K/JOm8MVocAFwmvxWARqDAaL1i Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f62j58vr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 14:25:20 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231DtoYk025695;
        Fri, 1 Apr 2022 14:25:20 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f62j58vqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 14:25:20 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231EF4Oh012635;
        Fri, 1 Apr 2022 14:25:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3f1tf8u64j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 14:25:18 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231EPFNn48955682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 14:25:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4526AE05D;
        Fri,  1 Apr 2022 14:25:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61BF9AE051;
        Fri,  1 Apr 2022 14:25:14 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.73])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 14:25:14 +0000 (GMT)
Date:   Fri, 1 Apr 2022 16:25:12 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v9 04/18] KVM: s390: pv: refactor s390_reset_acc
Message-ID: <20220401162512.0fd528cf@p-imbrenda>
In-Reply-To: <1fe44cd4-4ea9-ad68-2690-54c78dd4f5ad@linux.ibm.com>
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
        <20220330122605.247613-5-imbrenda@linux.ibm.com>
        <1fe44cd4-4ea9-ad68-2690-54c78dd4f5ad@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XW4ko057VnKPJuRtt_yM7OvHbaxERUDj
X-Proofpoint-ORIG-GUID: bHenevKFalBNDPNkgtUBHoKwLA2AC9i9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 31 Mar 2022 15:25:31 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 3/30/22 14:25, Claudio Imbrenda wrote:
> > Refactor s390_reset_acc so that it can be reused in upcoming patches.
> > 
> > We don't want to hold all the locks used in a walk_page_range for too
> > long, and the destroy page UVC does take some time to complete.
> > Therefore we quickly gather the pages to destroy, and then destroy them
> > without holding all the locks.
> > 
> > The new refactored function optionally allows to return early without
> > completing if a fatal signal is pending (and return and appropriate
> > error code). Two wrappers are provided to call the new function.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > (dropping Janosch's Ack because of major changes to the patch)  
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> [...]
> > +#define DESTROY_LOOP_THRESHOLD 32  
> 
> A question out of curiosity:
> Is there any particular reason for the number?
> Have you tested other numbers and experienced a speedup/slowdown?

to be honest no, it just seemed a good tradeoff between size and
callback overhead

> 
> > +
> > +struct reset_walk_state {
> > +	unsigned long next;
> > +	unsigned long count;
> > +	unsigned long pfns[DESTROY_LOOP_THRESHOLD];
> > +};
> > +
> > +static int s390_gather_pages(pte_t *ptep, unsigned long addr,
> > +			     unsigned long next, struct mm_walk *walk)
> >   {
> > +	struct reset_walk_state *p = walk->private;
> >   	pte_t pte = READ_ONCE(*ptep);
> >   
> > -	/* There is a reference through the mapping */
> > -	if (pte_present(pte))
> > -		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
> > -
> > -	return 0;
> > +	if (pte_present(pte)) {
> > +		/* we have a reference from the mapping, take an extra one */
> > +		get_page(phys_to_page(pte_val(pte)));
> > +		p->pfns[p->count] = phys_to_pfn(pte_val(pte));
> > +		p->next = next;
> > +		p->count++;
> > +	}
> > +	return p->count >= DESTROY_LOOP_THRESHOLD;
> >   }
> >   
> > -static const struct mm_walk_ops reset_acc_walk_ops = {
> > -	.pte_entry		= __s390_reset_acc,
> > +static const struct mm_walk_ops gather_pages_ops = {
> > +	.pte_entry = s390_gather_pages,
> >   };
> >   
> > -#include <linux/sched/mm.h>
> > -void s390_reset_acc(struct mm_struct *mm)
> > +/*
> > + * Call the Destroy secure page UVC on each page in the given array of PFNs.
> > + * Each page needs to have an extra reference, which will be released here.
> > + */
> > +void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns)
> >   {
> > -	if (!mm_is_protected(mm))
> > -		return;
> > -	/*
> > -	 * we might be called during
> > -	 * reset:                             we walk the pages and clear
> > -	 * close of all kvm file descriptors: we walk the pages and clear
> > -	 * exit of process on fd closure:     vma already gone, do nothing
> > -	 */
> > -	if (!mmget_not_zero(mm))
> > -		return;
> > -	mmap_read_lock(mm);
> > -	walk_page_range(mm, 0, TASK_SIZE, &reset_acc_walk_ops, NULL);
> > -	mmap_read_unlock(mm);
> > -	mmput(mm);
> > +	unsigned long i;
> > +
> > +	for (i = 0; i < count; i++) {
> > +		/* we always have an extra reference */
> > +		uv_destroy_owned_page(pfn_to_phys(pfns[i]));
> > +		/* get rid of the extra reference */
> > +		put_page(pfn_to_page(pfns[i]));
> > +		cond_resched();
> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(s390_uv_destroy_pfns);
> > +
> > +/**
> > + * __s390_uv_destroy_range - Walk the given range of the given address
> > + * space, and call the destroy secure page UVC on each page.
> > + * Optionally exit early if a fatal signal is pending.
> > + * @mm the mm to operate on
> > + * @start the start of the range
> > + * @end the end of the range
> > + * @interruptible if not 0, stop when a fatal signal is received
> > + * Return: 0 on success, -EINTR if the function stopped before completing
> > + */
> > +int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
> > +			    unsigned long end, bool interruptible)
> > +{
> > +	struct reset_walk_state state = { .next = start };
> > +	int r = 1;
> > +
> > +	while (r > 0) {
> > +		state.count = 0;
> > +		mmap_read_lock(mm);
> > +		r = walk_page_range(mm, state.next, end, &gather_pages_ops, &state);
> > +		mmap_read_unlock(mm);
> > +		cond_resched();
> > +		s390_uv_destroy_pfns(state.count, state.pfns);
> > +		if (interruptible && fatal_signal_pending(current))
> > +			return -EINTR;
> > +	}
> > +	return 0;
> >   }
> > -EXPORT_SYMBOL_GPL(s390_reset_acc);
> > +EXPORT_SYMBOL_GPL(__s390_uv_destroy_range);
> >   
> >   /**
> >    * s390_remove_old_asce - Remove the topmost level of page tables from the  
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A4D67B652
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 16:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbjAYPxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 10:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbjAYPxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 10:53:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FD3274AF;
        Wed, 25 Jan 2023 07:53:08 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PFfebF014353;
        Wed, 25 Jan 2023 15:53:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6jUMnABkI5FmUtZ9zdfEQMrbbrZ4yQaSL+Azu+3zxz8=;
 b=l9XDJfrFeKcaPSvc4l7AYuupWY3Q7lb6TVSEFStSAuhKV/NFfUlJqhXdjGPqV/fg8rOD
 YUeNH18XLkFg8ibUy2CBjcxohSXLdqJWUS9y96hDySMbpOTX7rFonF6YAaDfLnLh1Jq3
 o05vYp+rAVx3ceM+m1SlStaXqJ3S9lc0AVv6TSVQKSAuA1wwLICwAFZojNA2iP5WchYG
 S7JSyCZNhuoLrcSHPjUiugE/knjcmvp3vF4lKaIXourOvHlaiUclcpC4gkYl0CmGM/7I
 dK57QbAjLtWMHefvuxxKyLejzGVFcsWLJLFmoWO6XbuMVk0p9OWzxgu4qx60awe7iTFA qg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3naagutadu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Jan 2023 15:53:08 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30P14ZLa029222;
        Wed, 25 Jan 2023 15:53:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n87afbvcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Jan 2023 15:53:06 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30PFr2le51511578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 15:53:02 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AA1120043;
        Wed, 25 Jan 2023 15:53:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 253CB20040;
        Wed, 25 Jan 2023 15:53:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 25 Jan 2023 15:53:02 +0000 (GMT)
Date:   Wed, 25 Jan 2023 16:53:00 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1] KVM: s390: disable migration mode when dirty
 tracking is disabled
Message-ID: <20230125165300.555cd21d@p-imbrenda>
In-Reply-To: <2ef9a5df-cd05-8f27-f8ee-4c03f4c43d0d@linux.ibm.com>
References: <20230120075406.101436-1-nrb@linux.ibm.com>
        <2ef9a5df-cd05-8f27-f8ee-4c03f4c43d0d@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: z8mojCURGy0lTgghuMGXRrZcIph0nYWt
X-Proofpoint-GUID: z8mojCURGy0lTgghuMGXRrZcIph0nYWt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_10,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301250139
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Jan 2023 14:55:59 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/20/23 08:54, Nico Boehr wrote:
> > Migration mode is a VM attribute which enables tracking of changes in
> > storage attributes (PGSTE). It assumes dirty tracking is enabled on all
> > memslots to keep a dirty bitmap of pages with changed storage attributes.
> > 
> > When enabling migration mode, we currently check that dirty tracking is
> > enabled for all memslots. However, userspace can disable dirty tracking
> > without disabling migration mode.
> > 
> > Since migration mode is pointless with dirty tracking disabled, disable
> > migration mode whenever userspace disables dirty tracking on any slot.  
> 
> Will userspace be able to handle the sudden -EINVAL rcs on 
> KVM_S390_GET_CMMA_BITS and KVM_S390_SET_CMMA_BITS?
> 
> I.e. what allows us to simply turn it off without the userspace knowing 
> about it?

if we are here, userspace is disabling dirty tracking without having
disabled migration mode. it should have disabled migration mode before
disabling dirty tracking. also, migration mode does not actually impact
userspace (at least at this point). it's just an indication from
userspace to the kernel that userspace is trying to migrate. disabling
dirty tracking is a rather explicit way for userspace to tell the
kernel that the migration is over (one way or the other)

> 
> > 
> > Also update the documentation to clarify that dirty tracking must be
> > enabled when enabling migration mode, which is already enforced by the
> > code in kvm_s390_vm_start_migration().
> > 
> > To disable migration mode, slots_lock should be held, which is taken
> > in kvm_set_memory_region() and thus held in
> > kvm_arch_prepare_memory_region().
> > 
> > Restructure the prepare code a bit so all the sanity checking is done
> > before disabling migration mode. This ensures migration mode isn't
> > disabled when some sanity check fails.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 190df4a212a7 ("KVM: s390: CMMA tracking, ESSA emulation, migration mode")
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   Documentation/virt/kvm/devices/vm.rst |  4 +++
> >   arch/s390/kvm/kvm-s390.c              | 41 ++++++++++++++++++---------
> >   2 files changed, 32 insertions(+), 13 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
> > index 60acc39e0e93..147efec626e5 100644
> > --- a/Documentation/virt/kvm/devices/vm.rst
> > +++ b/Documentation/virt/kvm/devices/vm.rst
> > @@ -302,6 +302,10 @@ Allows userspace to start migration mode, needed for PGSTE migration.
> >   Setting this attribute when migration mode is already active will have
> >   no effects.
> >   
> > +Dirty tracking must be enabled on all memslots, else -EINVAL is returned. When
> > +dirty tracking is disabled on any memslot, migration mode is automatically
> > +stopped.  
> 
> Do we also need to add a warning to the CMMA IOCTLs?
> 
> > +
> >   :Parameters: none
> >   :Returns:   -ENOMEM if there is not enough free memory to start migration mode;
> >   	    -EINVAL if the state of the VM is invalid (e.g. no memory defined);
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index e4890e04b210..4785f002cd93 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -5628,28 +5628,43 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >   				   enum kvm_mr_change change)
> >   {
> >   	gpa_t size;
> > +	int rc;  
> 
> Not sure why you added rc even though it doesn't need to be used.
> 
> >   
> >   	/* When we are protected, we should not change the memory slots */
> >   	if (kvm_s390_pv_get_handle(kvm))
> >   		return -EINVAL;
> >   
> > -	if (change == KVM_MR_DELETE || change == KVM_MR_FLAGS_ONLY)
> > -		return 0;
> > +	if (change != KVM_MR_DELETE && change != KVM_MR_FLAGS_ONLY) {
> > +		/* A few sanity checks. We can have memory slots which have to be
> > +		 * located/ended at a segment boundary (1MB). The memory in userland is
> > +		 * ok to be fragmented into various different vmas. It is okay to mmap()
> > +		 * and munmap() stuff in this slot after doing this call at any time
> > +		 */  
> 
> This isn't net code, we usually start our comments on a "*" line.

like this:

/*
 * blah
 */

I missed this when I reviewed the patch

> 
> >   
> > -	/* A few sanity checks. We can have memory slots which have to be
> > -	   located/ended at a segment boundary (1MB). The memory in userland is
> > -	   ok to be fragmented into various different vmas. It is okay to mmap()
> > -	   and munmap() stuff in this slot after doing this call at any time */
> > +		if (new->userspace_addr & 0xffffful)
> > +			return -EINVAL;
> >   
> > -	if (new->userspace_addr & 0xffffful)
> > -		return -EINVAL;
> > +		size = new->npages * PAGE_SIZE;
> > +		if (size & 0xffffful)
> > +			return -EINVAL;
> >   
> > -	size = new->npages * PAGE_SIZE;
> > -	if (size & 0xffffful)
> > -		return -EINVAL;
> > +		if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
> > +			return -EINVAL;
> > +	}
> >   
> > -	if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
> > -		return -EINVAL;
> > +	/* Turn off migration mode when userspace disables dirty page logging.
> > +	 * Migration mode expects dirty page logging being enabled to store
> > +	 * its dirty bitmap.
> > +	 */
> > +	if (kvm->arch.migration_mode) {
> > +		if ((old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
> > +		    !(new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
> > +			rc = kvm_s390_vm_stop_migration(kvm);
> > +
> > +			if (rc)
> > +				pr_warn("Failed to stop migration mode\n");  
> 
> As the results were rather catastrophic it might make more sense to use 
> WARN_ONCE() and condense these 3 lines into one.

(in which case rc is not needed)

is WARN_ONCE even enough? the results are indeed potentially
catastrophic, would it not make sense to WARN (without _ONCE) ?

> 
> > +		}
> > +	}
> >   
> >   	return 0;
> >   }  
> 


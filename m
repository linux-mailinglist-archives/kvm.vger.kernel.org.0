Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23FE6EA5A9
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjDUIR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDUIR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:17:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D722106;
        Fri, 21 Apr 2023 01:17:25 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L8DqIa024492;
        Fri, 21 Apr 2023 08:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OZXAIeyDLmrCCJXE6C9KQABpNjN0W8VXtVabrdAZjOo=;
 b=S0M22vcIF5GkD4MkWxcmKAq7Dyis0ha72+QSn/gjdMbrUi2uSaSOn9KGNRc8KvRTtdHv
 ufbTf+av77N0p3KcA5WbT6PY6LKS8Ns5SP/PGpjgiYkbNfJdbMSD/XI5fQZwaU/2odVp
 CcFgs6hPL0KacJFpaTTwyft1JWdoF73DwxQ69EYEPL6IgKuSykNQfKBmEL2zU+Eqna/t
 emY/OWfSSfYuhD8BOgIq5lP2ZukxlXDULZcSOqZFoxf8XuCmR/abmkW2M4uRIujIyAaM
 jaXik+oiqSsta7rwtLLbzh/5a4P8Y4dGiquGvCZzQXZRX/fdmGN2lsJp/V2/PPITUOcM Uw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3pst8481-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:17:24 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33L1o4s7015437;
        Fri, 21 Apr 2023 08:17:22 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pykj6b87x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:17:22 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33L8HGFw29491780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 08:17:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4D3420049;
        Fri, 21 Apr 2023 08:17:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E64420043;
        Fri, 21 Apr 2023 08:17:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.7.117])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 21 Apr 2023 08:17:16 +0000 (GMT)
Date:   Fri, 21 Apr 2023 10:17:13 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, mhartmay@linux.ibm.com,
        kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] KVM: s390: pv: fix asynchronous teardown for
 small VMs
Message-ID: <20230421101713.34cf8c50@p-imbrenda>
In-Reply-To: <a1ab46b3-da2b-f815-be15-1294f95d598f@linux.ibm.com>
References: <20230420160149.51728-1-imbrenda@linux.ibm.com>
        <a1ab46b3-da2b-f815-be15-1294f95d598f@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iD9xpcNqAvXp6697G_yiS-iI2RZCYH0s
X-Proofpoint-ORIG-GUID: iD9xpcNqAvXp6697G_yiS-iI2RZCYH0s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_02,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Apr 2023 10:04:50 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 4/20/23 18:01, Claudio Imbrenda wrote:
> > On machines without the Destroy Secure Configuration Fast UVC, the
> > topmost level of page tables is set aside and freed asynchronously
> > as last step of the asynchronous teardown.
> > 
> > Each gmap has a host_to_guest radix tree mapping host (userspace)
> > addresses (with 1M granularity) to gmap segment table entries (pmds).
> > 
> > If a guest is smaller than 2GB, the topmost level of page tables is the
> > segment table (i.e. there are only 2 levels). Replacing it means that
> > the pointers in the host_to_guest mapping would become stale and cause
> > all kinds of nasty issues.  
> 
> Ouff
> 
> > 
> > This patch fixes the issue by synchronously destroying all guests with
> > only 2 levels of page tables in kvm_s390_pv_set_aside. This will
> > speed up the process and avoid the issue altogether.
> > 
> > Update s390_replace_asce so it refuses to replace segment type ASCEs.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
> > ---
> >   arch/s390/kvm/pv.c  | 35 ++++++++++++++++++++---------------
> >   arch/s390/mm/gmap.c |  7 +++++++
> >   2 files changed, 27 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index e032ebbf51b9..ceb8cb628d62 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c
> > @@ -39,6 +39,7 @@ struct pv_vm_to_be_destroyed {
> >   	u64 handle;
> >   	void *stor_var;
> >   	unsigned long stor_base;
> > +	bool small;  
> 
> I second Marc's complaints :)
> 
> There's no way that the gmap can be manipulated to cause the 
> use-after-free problems by adding/removing memory? I.e. changing to >2GB 
> memory before your checks and then to < 2GB after the checks?

no, the gmap __limit__ cannot be changed after CPUs are created.

if the gmap is smaller than 2GB but has a limit >2GB then it will have
3 levels.

this is moot, though, I have found a much smaller and simpler solution
after talking with Marc

> 
> >   };
> >   
> >   static void kvm_s390_clear_pv_state(struct kvm *kvm)
> > @@ -318,7 +319,11 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   	if (!priv)
> >   		return -ENOMEM;
> >   
> > -	if (is_destroy_fast_available()) {
> > +	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT) {  
> 
> How about adding this to gmap.h?
> 
> bool gmap_asce_non_replaceable(struct gmap *gmap)
> {
> 	return (gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT;
> }

do you really want a function / macro for that?

> 
> > +		/* No need to do things asynchronously for VMs under 2GB */
> > +		res = kvm_s390_pv_deinit_vm(kvm, rc, rrc);
> > +		priv->small = true;
> > +	} else if (is_destroy_fast_available()) {
> >   		res = kvm_s390_pv_deinit_vm_fast(kvm, rc, rrc);
> >   	} else {
> >   		priv->stor_var = kvm->arch.pv.stor_var;
> > @@ -335,7 +340,8 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   		return res;
> >   	}
> >   
> > -	kvm_s390_destroy_lower_2g(kvm);
> > +	if (!priv->small)
> > +		kvm_s390_destroy_lower_2g(kvm);
> >   	kvm_s390_clear_pv_state(kvm);
> >   	kvm->arch.pv.set_aside = priv;
> >   
> > @@ -418,7 +424,10 @@ int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   
> >   	/* If a previous protected VM was set aside, put it in the need_cleanup list */
> >   	if (kvm->arch.pv.set_aside) {
> > -		list_add(kvm->arch.pv.set_aside, &kvm->arch.pv.need_cleanup);
> > +		if (((struct pv_vm_to_be_destroyed *)kvm->arch.pv.set_aside)->small)  
> 
> cur = (struct pv_vm_to_be_destroyed *)kvm->arch.pv.set_aside;
> 
> if (cur->small)
> [...]

this will go

> 
> 
> > +			kfree(kvm->arch.pv.set_aside);
> > +		else
> > +			list_add(kvm->arch.pv.set_aside, &kvm->arch.pv.need_cleanup);
> >   		kvm->arch.pv.set_aside = NULL;
> >   	}
> >   
> > @@ -485,26 +494,22 @@ int kvm_s390_pv_deinit_aside_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   	if (!p)
> >   		return -EINVAL;
> >   
> > -	/* When a fatal signal is received, stop immediately */
> > -	if (s390_uv_destroy_range_interruptible(kvm->mm, 0, TASK_SIZE_MAX))
> > +	if (p->small)
> >   		goto done;
> > -	if (kvm_s390_pv_dispose_one_leftover(kvm, p, rc, rrc))
> > -		ret = -EIO;
> > -	kfree(p);
> > -	p = NULL;
> > -done:
> > -	/*
> > -	 * p is not NULL if we aborted because of a fatal signal, in which
> > -	 * case queue the leftover for later cleanup.
> > -	 */
> > -	if (p) {
> > +	/* When a fatal signal is received, stop immediately */
> > +	if (s390_uv_destroy_range_interruptible(kvm->mm, 0, TASK_SIZE_MAX)) {
> >   		mutex_lock(&kvm->lock);
> >   		list_add(&p->list, &kvm->arch.pv.need_cleanup);
> >   		mutex_unlock(&kvm->lock);
> >   		/* Did not finish, but pretend things went well */
> >   		*rc = UVC_RC_EXECUTED;
> >   		*rrc = 42;
> > +		return 0;
> >   	}
> > +	if (kvm_s390_pv_dispose_one_leftover(kvm, p, rc, rrc))
> > +		ret = -EIO;
> > +done:
> > +	kfree(p);
> >   	return ret;
> >   }
> >   
> > diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> > index 5a716bdcba05..2267cf9819b2 100644
> > --- a/arch/s390/mm/gmap.c
> > +++ b/arch/s390/mm/gmap.c
> > @@ -2833,6 +2833,9 @@ EXPORT_SYMBOL_GPL(s390_unlist_old_asce);
> >    * s390_replace_asce - Try to replace the current ASCE of a gmap with a copy
> >    * @gmap: the gmap whose ASCE needs to be replaced
> >    *
> > + * If the ASCE is a SEGMENT type then this function will return -EINVAL,
> > + * otherwise the pointers in the host_to_guest radix tree will keep pointing
> > + * to the wrong pages, causing use-after-free and memory corruption.
> >    * If the allocation of the new top level page table fails, the ASCE is not
> >    * replaced.
> >    * In any case, the old ASCE is always removed from the gmap CRST list.
> > @@ -2847,6 +2850,10 @@ int s390_replace_asce(struct gmap *gmap)
> >   
> >   	s390_unlist_old_asce(gmap);
> >   
> > +	/* Replacing segment type ASCEs would cause serious issues */
> > +	if ((gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
> > +		return -EINVAL;
> > +
> >   	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
> >   	if (!page)
> >   		return -ENOMEM;  
> 


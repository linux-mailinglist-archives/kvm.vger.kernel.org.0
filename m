Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FF86EA5AC
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjDUISL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjDUISJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:18:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4852106;
        Fri, 21 Apr 2023 01:18:07 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L8HPaM005887;
        Fri, 21 Apr 2023 08:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iI84cZJ4zjaiBvrOiXHkliXpBN6qLCIBhAIAuM5PJzk=;
 b=YoQedcBD0DCaKWxVGFG3yQztLXjUhnpxS0Yha2MhITDX0PfPO5Mx6LCN6rVAvI5hljJx
 3E4oXE2Kvuiv3saJ8qOj3DLXPoEQIy7ZYrZ/uaejJqy/aAo668uHwwsqKWZQvSbYW2vt
 bASaOkc9V7TpECB+xpC9a62pAx5F7CiyRmOh7CnzWBfzdOvVAcMqiyv31rZ6bmkq/zUd
 QUPGyV0n+2fLRK5VtFy/aspqJLiwAyBDGJuBMYcOUmU/E5kfLVcPrckYaZhA+pB193y2
 /ntltlEu9xLWW3A8VB5v8/tHq3KZaAioidGw410F+UZpj9magIy/Jw1kVHQRFX9xMbhu 5Q== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3pge8wqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:18:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33L2ZkvU012194;
        Fri, 21 Apr 2023 08:18:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6bw7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:18:03 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33L8Hw8E66126334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 08:17:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22E2A20043;
        Fri, 21 Apr 2023 08:17:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E00620040;
        Fri, 21 Apr 2023 08:17:57 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.7.117])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 21 Apr 2023 08:17:57 +0000 (GMT)
Date:   Fri, 21 Apr 2023 10:17:54 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kvm@vger.kernel.org, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, mhartmay@linux.ibm.com,
        kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] KVM: s390: pv: fix asynchronous teardown for
 small VMs
Message-ID: <20230421101754.00955356@p-imbrenda>
In-Reply-To: <4e7db9f6-a199-4a95-ea14-13d7803884be@de.ibm.com>
References: <20230420160149.51728-1-imbrenda@linux.ibm.com>
        <4e7db9f6-a199-4a95-ea14-13d7803884be@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3WN9cISWKzeuD03Kxb1IEw7nuF6VeyYB
X-Proofpoint-ORIG-GUID: 3WN9cISWKzeuD03Kxb1IEw7nuF6VeyYB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_02,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304210069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Apr 2023 10:07:22 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 20.04.23 um 18:01 schrieb Claudio Imbrenda:
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
> >   };
> >   
> >   static void kvm_s390_clear_pv_state(struct kvm *kvm)
> > @@ -318,7 +319,11 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
> >   	if (!priv)
> >   		return -ENOMEM;
> >   
> > -	if (is_destroy_fast_available()) {
> > +	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT) {
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
> why do we need a cast here?

it's a void *

but it's not important, after talking with Marc I have found a much
simpler solution (will post soon)

> 
> > +			kfree(kvm->arch.pv.set_aside);
> > +		else
> > +			list_add(kvm->arch.pv.set_aside, &kvm->arch.pv.need_cleanup);
> >   		kvm->arch.pv.set_aside = NULL;
> >   	}
> >     
> 
> With the comment added that Marc asked for
> 
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 


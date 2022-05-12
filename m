Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42578524974
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352064AbiELJxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiELJxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:53:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F403041F8E;
        Thu, 12 May 2022 02:52:59 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24C9COXn026635;
        Thu, 12 May 2022 09:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Rh4X3NiY7TjXJZ1aQlkXjBVSgETVovKAr810YzdjNLs=;
 b=c+HT6T1rqK7YmZm+pv3SAQCMnO6C7voxRP+kWIujkKJYNDOWc6Q7rRSakIFt01M0mdVb
 qHw0Kin+BPSJ+31MzhvmeLBFv7zZz7uN8eiR08h6BxzO7moyPg5uLyHeV5QGX+Y83z4l
 lFkxZ3xl5sufC+hDIt76kZW7ftY0pFJ5O19zMfvZ6jcgZ3cx5AL3SoaAnZQbznRbEXbb
 d9SOQdbvhuxO7e/Jqat49q8ZiyCq/zggm2mifuA3AudsDSZJ8LZM6TVkl5ux3TEK4ORw
 L3WDO0UA8DaLY92J6NsLl7VcprX5USmK04wgA0cbMdype2FIW2xenYbPFQIjKlYo5guH ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd50ruy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:52:59 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24C9dI5a013467;
        Thu, 12 May 2022 09:52:59 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g0yd50ru2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:52:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24C9iVuv004467;
        Thu, 12 May 2022 09:52:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3g0kn78ny8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:52:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24C9qrUm49742186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 09:52:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B22FAE04D;
        Thu, 12 May 2022 09:52:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CA2DAE045;
        Thu, 12 May 2022 09:52:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.145])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 09:52:52 +0000 (GMT)
Date:   Thu, 12 May 2022 11:52:50 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v9 3/3] s390x: KVM: resetting the Topology-Change-Report
Message-ID: <20220512115250.2e20bfdf@p-imbrenda>
In-Reply-To: <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
        <20220506092403.47406-4-pmorel@linux.ibm.com>
        <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bd2hnMZHZ75ZzlKZPdY27co-4clii1x3
X-Proofpoint-ORIG-GUID: YSsDv-q-V0U9jIh7WTqn0g6e_xDG3SmX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_02,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 May 2022 11:31:18 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 06.05.22 11:24, Pierre Morel wrote:
> > During a subsystem reset the Topology-Change-Report is cleared.
> > Let's give userland the possibility to clear the MTCR in the case
> > of a subsystem reset.
> > 
> > To migrate the MTCR, let's give userland the possibility to
> > query the MTCR state.
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  arch/s390/include/uapi/asm/kvm.h |  5 ++
> >  arch/s390/kvm/kvm-s390.c         | 79 ++++++++++++++++++++++++++++++++
> >  2 files changed, 84 insertions(+)
> > 
> > diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> > index 7a6b14874d65..abdcf4069343 100644
> > --- a/arch/s390/include/uapi/asm/kvm.h
> > +++ b/arch/s390/include/uapi/asm/kvm.h
> > @@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
> >  #define KVM_S390_VM_CRYPTO		2
> >  #define KVM_S390_VM_CPU_MODEL		3
> >  #define KVM_S390_VM_MIGRATION		4
> > +#define KVM_S390_VM_CPU_TOPOLOGY	5
> >  
> >  /* kvm attributes for mem_ctrl */
> >  #define KVM_S390_VM_MEM_ENABLE_CMMA	0
> > @@ -171,6 +172,10 @@ struct kvm_s390_vm_cpu_subfunc {
> >  #define KVM_S390_VM_MIGRATION_START	1
> >  #define KVM_S390_VM_MIGRATION_STATUS	2
> >  
> > +/* kvm attributes for cpu topology */
> > +#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR	0
> > +#define KVM_S390_VM_CPU_TOPO_MTR_SET	1
> > +
> >  /* for KVM_GET_REGS and KVM_SET_REGS */
> >  struct kvm_regs {
> >  	/* general purpose regs for s390 */
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index c8bdce31464f..80a1244f0ead 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -1731,6 +1731,76 @@ static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
> >  	ipte_unlock(kvm);
> >  }
> >  
> > +/**
> > + * kvm_s390_sca_clear_mtcr
> > + * @kvm: guest KVM description
> > + *
> > + * Is only relevant if the topology facility is present,
> > + * the caller should check KVM facility 11
> > + *
> > + * Updates the Multiprocessor Topology-Change-Report to signal
> > + * the guest with a topology change.
> > + */
> > +static void kvm_s390_sca_clear_mtcr(struct kvm *kvm)
> > +{
> > +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> > +
> > +	ipte_lock(kvm);
> > +	sca->utility  &= ~SCA_UTILITY_MTCR;  
> 
> 
> One space too much.
> 
> sca->utility &= ~SCA_UTILITY_MTCR;
> 
> > +	ipte_unlock(kvm);
> > +}
> > +
> > +static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
> > +{
> > +	if (!test_kvm_facility(kvm, 11))
> > +		return -ENXIO;
> > +
> > +	switch (attr->attr) {
> > +	case KVM_S390_VM_CPU_TOPO_MTR_SET:
> > +		kvm_s390_sca_set_mtcr(kvm);
> > +		break;
> > +	case KVM_S390_VM_CPU_TOPO_MTR_CLEAR:
> > +		kvm_s390_sca_clear_mtcr(kvm);
> > +		break;
> > +	}
> > +	return 0;
> > +}
> > +
> > +/**
> > + * kvm_s390_sca_get_mtcr
> > + * @kvm: guest KVM description
> > + *
> > + * Is only relevant if the topology facility is present,
> > + * the caller should check KVM facility 11
> > + *
> > + * reports to QEMU the Multiprocessor Topology-Change-Report.
> > + */
> > +static int kvm_s390_sca_get_mtcr(struct kvm *kvm)
> > +{
> > +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
> > +	int val;
> > +
> > +	ipte_lock(kvm);
> > +	val = !!(sca->utility & SCA_UTILITY_MTCR);
> > +	ipte_unlock(kvm);
> > +
> > +	return val;
> > +}
> > +
> > +static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
> > +{
> > +	int mtcr;  
> 
> I think we prefer something like u16 when copying to user space.

but then userspace also has to expect a u16, right?

> 
> > +
> > +	if (!test_kvm_facility(kvm, 11))
> > +		return -ENXIO;
> > +
> > +	mtcr = kvm_s390_sca_get_mtcr(kvm);
> > +	if (copy_to_user((void __user *)attr->addr, &mtcr, sizeof(mtcr)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}  
> 
> You should probably add documentation, and document that only the last
> bit (0x1) has a meaning.
> 
> Apart from that LGTM.
> 


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08ED617DC9
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 14:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiKCNWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 09:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiKCNWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 09:22:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DABC13EA3;
        Thu,  3 Nov 2022 06:22:14 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3CJrRq005056;
        Thu, 3 Nov 2022 13:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=aFkGVTo1XJsI6iGGvAkxQhjQYKM9aG4FMgppl4Mi3V4=;
 b=oJ1AASijW3z94yCNGRZiFICP24fGSesVBCEC8Xqh2VdcOSvNxBynHuTHaQTYP/QuJhIZ
 NxmeS6rFalfFqEImPhHnqx7l9m0DRnvCkPUBJEJD82t6dDaoo74fFkT92fc23c1D2lHW
 z3uDhJrunZQbC1UjLKk4TC5rJ1OSHSJJw8YRacyK/Fc/6hpMYwSVOCBV4liDhrkRX+s3
 4vcis021UkJZus/SW5ZDm+zV40sIbdWd/kkCVxmMhKqN9jOyylEeC6toF69LcrW9uRf0
 uYVKNSAlaqCYvq0CZRK55lKcF6VETT9NWK/9cu1NIH0e/BdZ3BvQqVhZ5qiRT66SJqWa IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmcabmsme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 13:21:27 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A3AtXV6006838;
        Thu, 3 Nov 2022 13:21:26 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmcabmsjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 13:21:25 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A3D5ZwC024560;
        Thu, 3 Nov 2022 13:21:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3kgut8pkgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 13:21:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A3DLJlt63635926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Nov 2022 13:21:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB3664C04A;
        Thu,  3 Nov 2022 13:21:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C63864C044;
        Thu,  3 Nov 2022 13:21:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Nov 2022 13:21:18 +0000 (GMT)
Date:   Thu, 3 Nov 2022 14:21:17 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 25/44] KVM: s390: Do s390 specific init without bouncing
 through kvm_init()
Message-ID: <20221103142117.4e27c80c@p-imbrenda>
In-Reply-To: <20221103134415.5b277ce9@p-imbrenda>
References: <20221102231911.3107438-1-seanjc@google.com>
        <20221102231911.3107438-26-seanjc@google.com>
        <20221103134415.5b277ce9@p-imbrenda>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qBPHBsV6cFHEd8MUfp3luW546x7XEBtX
X-Proofpoint-GUID: PZHd2NjudsBQn9w2kOd6Znv6byrMRJIu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=826
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211030090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Nov 2022 13:44:15 +0100
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> On Wed,  2 Nov 2022 23:18:52 +0000
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > Move the guts of kvm_arch_init() into a new helper, __kvm_s390_init(),
> > and invoke the new helper directly from kvm_s390_init() instead of
> > bouncing through kvm_init().  Invoking kvm_arch_init() is the very
> > first action performed by kvm_init(), i.e. this is a glorified nop.
> > 
> > Moving setup to __kvm_s390_init() will allow tagging more functions as
> > __init, and emptying kvm_arch_init() will allow dropping the hook
> > entirely once all architecture implementations are nops.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c | 29 +++++++++++++++++++++++++----
> >  1 file changed, 25 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 7fcd2d3b3558..e1c9980aae78 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -461,7 +461,7 @@ static void kvm_s390_cpu_feat_init(void)
> >  	 */
> >  }
> >  
> > -int kvm_arch_init(void *opaque)
> > +static int __kvm_s390_init(void)
> >  {
> >  	int rc = -ENOMEM;
> >  
> > @@ -519,7 +519,7 @@ int kvm_arch_init(void *opaque)
> >  	return rc;
> >  }
> >  
> > -void kvm_arch_exit(void)
> > +static void __kvm_s390_exit(void)
> >  {
> >  	gmap_unregister_pte_notifier(&gmap_notifier);
> >  	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
> > @@ -533,6 +533,16 @@ void kvm_arch_exit(void)
> >  	debug_unregister(kvm_s390_dbf_uv);
> >  }
> >  
> > +int kvm_arch_init(void *opaque)
> > +{
> > +	return 0;
> > +}
> > +
> > +void kvm_arch_exit(void)
> > +{
> > +
> > +}
> > +  
> 
> I wonder at this point if it's possible to define kvm_arch_init and
> kvm_arch_exit directly in kvm_main.c with __weak

ah, nevermind, you get rid of them completely in the next patch

> 
> >  /* Section: device related */
> >  long kvm_arch_dev_ioctl(struct file *filp,
> >  			unsigned int ioctl, unsigned long arg)
> > @@ -5634,7 +5644,7 @@ static inline unsigned long nonhyp_mask(int i)
> >  
> >  static int __init kvm_s390_init(void)
> >  {
> > -	int i;
> > +	int i, r;
> >  
> >  	if (!sclp.has_sief2) {
> >  		pr_info("SIE is not available\n");
> > @@ -5650,12 +5660,23 @@ static int __init kvm_s390_init(void)
> >  		kvm_s390_fac_base[i] |=
> >  			stfle_fac_list[i] & nonhyp_mask(i);
> >  
> > -	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> > +	r = __kvm_s390_init();
> > +	if (r)
> > +		return r;
> > +
> > +	r = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> > +	if (r) {
> > +		__kvm_s390_exit();
> > +		return r;
> > +	}
> > +	return 0;
> >  }
> >  
> >  static void __exit kvm_s390_exit(void)
> >  {
> >  	kvm_exit();
> > +
> > +	__kvm_s390_exit();
> >  }
> >  
> >  module_init(kvm_s390_init);  
> 


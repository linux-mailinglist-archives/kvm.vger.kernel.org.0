Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31625911D8
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 16:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbiHLODC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 10:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238740AbiHLOC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 10:02:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04708A8CDD;
        Fri, 12 Aug 2022 07:02:58 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27CDgXEf031256;
        Fri, 12 Aug 2022 14:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=KMU3L79OXaPaxSQZJmmv4Wo3m1CAnO0IoB1kVCGxomQ=;
 b=nJ36dGyjfJNgE2uXonQn1G0fAk7b449iHdcCD1QUnJflLGQqDHjvzezXtQyRkZb/n9QT
 pIcdHY0lUn0EFURu7oqBYP+ybT3o7RoP4rzs0byBWwWnBZdOjrx86kpuZV4H7IuA9aCx
 UPETN1YZ0UcNKA10nmDQ7RRfF4NY/uqHTzD23qyn1INywd6z/Ekk1DfmB7yP+F/w5IMh
 xcbU5uFdbADJycHC4oepNYI1cAyuZVR/fi4D06szsDctXik17uCQj3qas5+NrAZXgyFr
 +Wq3E2DwQ87/1Kgr33HdXn+gEnx/7zl5QAapIGWxZvFiEQtgp58YfVJL+4QNQGQscyq5 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwqyngqar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 14:02:57 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27CDgZh8031320;
        Fri, 12 Aug 2022 14:02:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwqyngq9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 14:02:56 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27CDs6mQ007562;
        Fri, 12 Aug 2022 14:02:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3hw4nxrsrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 14:02:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27CE2pAO33751366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 14:02:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41A394C0B7;
        Fri, 12 Aug 2022 14:02:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9597F4C0B4;
        Fri, 12 Aug 2022 14:02:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Aug 2022 14:02:50 +0000 (GMT)
Date:   Fri, 12 Aug 2022 16:02:47 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v13 1/6] KVM: s390: pv: asynchronous destroy for reboot
Message-ID: <20220812160247.57527886@p-imbrenda>
In-Reply-To: <b726199f-6c07-fd9a-fd1e-016e6d98971e@linux.ibm.com>
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
        <20220810125625.45295-2-imbrenda@linux.ibm.com>
        <b726199f-6c07-fd9a-fd1e-016e6d98971e@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b8JE0hAUAZfoejg5xw4Tfg_N0-UtLCyE
X-Proofpoint-ORIG-GUID: wjIVfC2gERQFu4WWlUGub0UU4Al6cggd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_08,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Aug 2022 18:26:13 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:


[...]

> > +	case KVM_PV_ASYNC_CLEANUP_PREPARE:
> > +		r = -EINVAL;
> > +		if (!kvm_s390_pv_is_protected(kvm) || !async_destroy)
> > +			break;
> > +
> > +		r = kvm_s390_cpus_from_pv(kvm, &cmd->rc, &cmd->rrc);
> > +		/*
> > +		 * If a CPU could not be destroyed, destroy VM will also fail.
> > +		 * There is no point in trying to destroy it. Instead return
> > +		 * the rc and rrc from the first CPU that failed destroying.
> > +		 */
> > +		if (r)
> > +			break;
> > +		r = kvm_s390_pv_set_aside(kvm, &cmd->rc, &cmd->rrc);
> > +
> > +		/* no need to block service interrupts any more */
> > +		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
> > +		break;
> > +	case KVM_PV_ASYNC_CLEANUP_PERFORM:
> > +		/* This must not be called while holding kvm->lock */  
> 
> Two things:
> I know that we don't need to check async_destroy since it will find 
> nothing to cleanup because the command above is fenced. But I'd still 
> appreciate the same check here.

will add

> 
> Consider adding this to the comment:
> ", this is asserted inside the function."

will add

> 
> > +		r = kvm_s390_pv_deinit_aside_vm(kvm, &cmd->rc, &cmd->rrc);
> > +		break;
> >   	case KVM_PV_DISABLE: {
> >   		r = -EINVAL;
> >   		if (!kvm_s390_pv_is_protected(kvm))
> > @@ -2553,7 +2581,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> >   		 */
> >   		if (r)
> >   			break;
> > -		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
> > +		r = kvm_s390_pv_deinit_cleanup_all(kvm, &cmd->rc, &cmd->rrc);
> >   
> >   		/* no need to block service interrupts any more */
> >   		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
> > @@ -2703,6 +2731,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> >   	default:
> >   		r = -ENOTTY;
> >   	}
> > +	if (needslock)
> > +		mutex_unlock(&kvm->lock);
> > +
> >   	return r;
> >   }
> >   
> > @@ -2907,9 +2938,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >   			r = -EINVAL;
> >   			break;
> >   		}
> > -		mutex_lock(&kvm->lock);
> > +		/* must be called without kvm->lock */  
> 
> ...as it will acquire and release it by itself.

none of the other switch cases acquire kvm->lock, I actually think the
comment is redundant as it is, I don't think we need to expand it
further.

> 
> >   		r = kvm_s390_handle_pv(kvm, &args);
> > -		mutex_unlock(&kvm->lock);
> >   		if (copy_to_user(argp, &args, sizeof(args))) {
> >   			r = -EFAULT;
> >   			break;
> > @@ -3228,6 +3258,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >   	kvm_s390_vsie_init(kvm);
> >   	if (use_gisa)
> >   		kvm_s390_gisa_init(kvm);
> > +	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
> > +	kvm->arch.pv.set_aside = NULL;
> >   	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
> >   
> >   	return 0;
> > @@ -3272,11 +3304,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >   	/*
> >   	 * We are already at the end of life and kvm->lock is not taken.
> >   	 * This is ok as the file descriptor is closed by now and nobody
> > -	 * can mess with the pv state. To avoid lockdep_assert_held from
> > -	 * complaining we do not use kvm_s390_pv_is_protected.
> > +	 * can mess with the pv state.
> >   	 */
> > -	if (kvm_s390_pv_get_handle(kvm))
> > -		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
> > +	kvm_s390_pv_deinit_cleanup_all(kvm, &rc, &rrc);
> >   	/*
> >   	 * Remove the mmu notifier only when the whole KVM VM is torn down,
> >   	 * and only if one was registered to begin with. If the VM is  
> [...]
> > +
> > +/**
> > + * kvm_s390_pv_set_aside - Set aside a protected VM for later teardown.
> > + * @kvm: the VM
> > + * @rc: return value for the RC field of the UVCB
> > + * @rrc: return value for the RRC field of the UVCB
> > + *
> > + * Set aside the protected VM for a subsequent teardown. The VM will be able
> > + * to continue immediately as a non-secure VM, and the information needed to
> > + * properly tear down the protected VM is set aside. If another protected VM
> > + * was already set aside without starting its teardown, this function will
> > + * fail.
> > + * The CPUs of the protected VM need to be destroyed beforehand.
> > + *
> > + * Context: kvm->lock needs to be held
> > + *
> > + * Return: 0 in case of success, -EINVAL if another protected VM was already set
> > + * aside, -ENOMEM if the system ran out of memory.
> > + */
> > +int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
> > +{
> > +	struct pv_vm_to_be_destroyed *priv;
> > +
> > +	/*
> > +	 * If another protected VM was already prepared, refuse.  
> 
> s/prepared/set aside/
> or
> prepared for teardown

prepared for teardown; will fix

> 
> > +	 * A normal deinitialization has to be performed instead.
> > +	 */
> > +	if (kvm->arch.pv.set_aside)
> > +		return -EINVAL;
> > +	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);  
> 
> kzalloc()?

oops, yes

> 
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	priv->stor_var = kvm->arch.pv.stor_var;
> > +	priv->stor_base = kvm->arch.pv.stor_base;
> > +	priv->handle = kvm_s390_pv_get_handle(kvm);
> > +	priv->old_gmap_table = (unsigned long)kvm->arch.gmap->table;
> > +	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
> > +	if (s390_replace_asce(kvm->arch.gmap)) {
> > +		kfree(priv);
> > +		return -ENOMEM;
> >   	}
> >   
> > +	kvm_s390_destroy_lower_2g(kvm);
> > +	kvm_s390_clear_pv_state(kvm);
> > +	kvm->arch.pv.set_aside = priv;
> > +
> > +	*rc = 1;  
> 
> UVC_RC_EXECUTED	

will fix

> 
> > +	*rrc = 42;  
> 
> I'd prefer setting the rrc to 0.

I'd like to convey the information that the "successful" execution was
actually faked

> 
> > +	return 0;
> > +}  


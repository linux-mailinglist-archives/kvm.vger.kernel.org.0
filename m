Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72376559E90
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 18:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiFXQbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 12:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiFXQbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 12:31:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF7A50B2F;
        Fri, 24 Jun 2022 09:31:40 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OFuijM003055;
        Fri, 24 Jun 2022 16:31:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=plVmPcZ8RIzBqU0vAdLm4Uw9w/cX+dY9NoyIX8kAOyo=;
 b=MItSIcusj2PLCI545/3PLJ9ImAXlPMPAb+z4HQ9VLFGodZEzSicNiWTumyRlmKrKZC8G
 O26DN+5MqM6+7219n9Mq4V12UHvpNnJoBv9DFBQls9Lbo4kNlhkB8lGchCLnS5bOP18a
 +qAptxGNM9Otq/Jk6H2J6VsCMhOeB8F+4RphVDL/IkXS2hIlog2Qxwa5v8/pyFWlVz61
 D7SksIGPXKtcksP5izc4n93qnN0li3f64+fEXbalZoXuSjWv6Ho3pXSByLROJmSh9rBX
 LwkG2pgLeouGJUL+DO+65855unHOU3bXjsA6o6/UbC1tBBp6IyLmHOW0Y+lxKM9iswj8 uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwgbx91pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 16:31:39 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25OGDp56005070;
        Fri, 24 Jun 2022 16:31:39 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gwgbx91nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 16:31:39 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25OGLkk3017706;
        Fri, 24 Jun 2022 16:31:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3gs6b8y8rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 16:31:36 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25OGVXN717301790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 16:31:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F3514C044;
        Fri, 24 Jun 2022 16:31:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C8494C04A;
        Fri, 24 Jun 2022 16:31:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jun 2022 16:31:33 +0000 (GMT)
Date:   Fri, 24 Jun 2022 11:22:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v10 1/3] KVM: s390: ipte lock for SCA access should be
 contained in KVM
Message-ID: <20220624112225.23ee9ddb@p-imbrenda>
In-Reply-To: <20220620125437.37122-2-pmorel@linux.ibm.com>
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
        <20220620125437.37122-2-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YJCYX070N4x74wagsts1reWO0N8BhLKA
X-Proofpoint-GUID: GTiuJgIHOmnzmr2becK9L_QQ7w2wuYmW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_08,2022-06-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206240064
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Jun 2022 14:54:35 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We can check if SIIF is enabled by testing the sclp_info struct
> instead of testing the sie control block eca variable.
> sclp.has_ssif is the only requirement to set ECA_SII anyway
> so we can go straight to the source for that.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/gaccess.c | 96 ++++++++++++++++++++---------------------
>  arch/s390/kvm/gaccess.h |  6 +--
>  arch/s390/kvm/priv.c    |  6 +--
>  3 files changed, 54 insertions(+), 54 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 227ed0009354..082ec5f2c3a5 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -262,77 +262,77 @@ struct aste {
>  	/* .. more fields there */
>  };
>  
> -int ipte_lock_held(struct kvm_vcpu *vcpu)
> +int ipte_lock_held(struct kvm *kvm)
>  {
> -	if (vcpu->arch.sie_block->eca & ECA_SII) {
> +	if (sclp.has_siif) {
>  		int rc;
>  
> -		read_lock(&vcpu->kvm->arch.sca_lock);
> -		rc = kvm_s390_get_ipte_control(vcpu->kvm)->kh != 0;
> -		read_unlock(&vcpu->kvm->arch.sca_lock);
> +		read_lock(&kvm->arch.sca_lock);
> +		rc = kvm_s390_get_ipte_control(kvm)->kh != 0;
> +		read_unlock(&kvm->arch.sca_lock);
>  		return rc;
>  	}
> -	return vcpu->kvm->arch.ipte_lock_count != 0;
> +	return kvm->arch.ipte_lock_count != 0;
>  }
>  
> -static void ipte_lock_simple(struct kvm_vcpu *vcpu)
> +static void ipte_lock_simple(struct kvm *kvm)
>  {
>  	union ipte_control old, new, *ic;
>  
> -	mutex_lock(&vcpu->kvm->arch.ipte_mutex);
> -	vcpu->kvm->arch.ipte_lock_count++;
> -	if (vcpu->kvm->arch.ipte_lock_count > 1)
> +	mutex_lock(&kvm->arch.ipte_mutex);
> +	kvm->arch.ipte_lock_count++;
> +	if (kvm->arch.ipte_lock_count > 1)
>  		goto out;
>  retry:
> -	read_lock(&vcpu->kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(vcpu->kvm);
> +	read_lock(&kvm->arch.sca_lock);
> +	ic = kvm_s390_get_ipte_control(kvm);
>  	do {
>  		old = READ_ONCE(*ic);
>  		if (old.k) {
> -			read_unlock(&vcpu->kvm->arch.sca_lock);
> +			read_unlock(&kvm->arch.sca_lock);
>  			cond_resched();
>  			goto retry;
>  		}
>  		new = old;
>  		new.k = 1;
>  	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
> -	read_unlock(&vcpu->kvm->arch.sca_lock);
> +	read_unlock(&kvm->arch.sca_lock);
>  out:
> -	mutex_unlock(&vcpu->kvm->arch.ipte_mutex);
> +	mutex_unlock(&kvm->arch.ipte_mutex);
>  }
>  
> -static void ipte_unlock_simple(struct kvm_vcpu *vcpu)
> +static void ipte_unlock_simple(struct kvm *kvm)
>  {
>  	union ipte_control old, new, *ic;
>  
> -	mutex_lock(&vcpu->kvm->arch.ipte_mutex);
> -	vcpu->kvm->arch.ipte_lock_count--;
> -	if (vcpu->kvm->arch.ipte_lock_count)
> +	mutex_lock(&kvm->arch.ipte_mutex);
> +	kvm->arch.ipte_lock_count--;
> +	if (kvm->arch.ipte_lock_count)
>  		goto out;
> -	read_lock(&vcpu->kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(vcpu->kvm);
> +	read_lock(&kvm->arch.sca_lock);
> +	ic = kvm_s390_get_ipte_control(kvm);
>  	do {
>  		old = READ_ONCE(*ic);
>  		new = old;
>  		new.k = 0;
>  	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
> -	read_unlock(&vcpu->kvm->arch.sca_lock);
> -	wake_up(&vcpu->kvm->arch.ipte_wq);
> +	read_unlock(&kvm->arch.sca_lock);
> +	wake_up(&kvm->arch.ipte_wq);
>  out:
> -	mutex_unlock(&vcpu->kvm->arch.ipte_mutex);
> +	mutex_unlock(&kvm->arch.ipte_mutex);
>  }
>  
> -static void ipte_lock_siif(struct kvm_vcpu *vcpu)
> +static void ipte_lock_siif(struct kvm *kvm)
>  {
>  	union ipte_control old, new, *ic;
>  
>  retry:
> -	read_lock(&vcpu->kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(vcpu->kvm);
> +	read_lock(&kvm->arch.sca_lock);
> +	ic = kvm_s390_get_ipte_control(kvm);
>  	do {
>  		old = READ_ONCE(*ic);
>  		if (old.kg) {
> -			read_unlock(&vcpu->kvm->arch.sca_lock);
> +			read_unlock(&kvm->arch.sca_lock);
>  			cond_resched();
>  			goto retry;
>  		}
> @@ -340,15 +340,15 @@ static void ipte_lock_siif(struct kvm_vcpu *vcpu)
>  		new.k = 1;
>  		new.kh++;
>  	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
> -	read_unlock(&vcpu->kvm->arch.sca_lock);
> +	read_unlock(&kvm->arch.sca_lock);
>  }
>  
> -static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
> +static void ipte_unlock_siif(struct kvm *kvm)
>  {
>  	union ipte_control old, new, *ic;
>  
> -	read_lock(&vcpu->kvm->arch.sca_lock);
> -	ic = kvm_s390_get_ipte_control(vcpu->kvm);
> +	read_lock(&kvm->arch.sca_lock);
> +	ic = kvm_s390_get_ipte_control(kvm);
>  	do {
>  		old = READ_ONCE(*ic);
>  		new = old;
> @@ -356,25 +356,25 @@ static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
>  		if (!new.kh)
>  			new.k = 0;
>  	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
> -	read_unlock(&vcpu->kvm->arch.sca_lock);
> +	read_unlock(&kvm->arch.sca_lock);
>  	if (!new.kh)
> -		wake_up(&vcpu->kvm->arch.ipte_wq);
> +		wake_up(&kvm->arch.ipte_wq);
>  }
>  
> -void ipte_lock(struct kvm_vcpu *vcpu)
> +void ipte_lock(struct kvm *kvm)
>  {
> -	if (vcpu->arch.sie_block->eca & ECA_SII)
> -		ipte_lock_siif(vcpu);
> +	if (sclp.has_siif)
> +		ipte_lock_siif(kvm);
>  	else
> -		ipte_lock_simple(vcpu);
> +		ipte_lock_simple(kvm);
>  }
>  
> -void ipte_unlock(struct kvm_vcpu *vcpu)
> +void ipte_unlock(struct kvm *kvm)
>  {
> -	if (vcpu->arch.sie_block->eca & ECA_SII)
> -		ipte_unlock_siif(vcpu);
> +	if (sclp.has_siif)
> +		ipte_unlock_siif(kvm);
>  	else
> -		ipte_unlock_simple(vcpu);
> +		ipte_unlock_simple(kvm);
>  }
>  
>  static int ar_translation(struct kvm_vcpu *vcpu, union asce *asce, u8 ar,
> @@ -1086,7 +1086,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  	try_storage_prot_override = storage_prot_override_applicable(vcpu);
>  	need_ipte_lock = psw_bits(*psw).dat && !asce.r;
>  	if (need_ipte_lock)
> -		ipte_lock(vcpu);
> +		ipte_lock(vcpu->kvm);
>  	/*
>  	 * Since we do the access further down ultimately via a move instruction
>  	 * that does key checking and returns an error in case of a protection
> @@ -1127,7 +1127,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  	}
>  out_unlock:
>  	if (need_ipte_lock)
> -		ipte_unlock(vcpu);
> +		ipte_unlock(vcpu->kvm);
>  	if (nr_pages > ARRAY_SIZE(gpa_array))
>  		vfree(gpas);
>  	return rc;
> @@ -1199,10 +1199,10 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
>  	if (rc)
>  		return rc;
> -	ipte_lock(vcpu);
> +	ipte_lock(vcpu->kvm);
>  	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode,
>  				 access_key);
> -	ipte_unlock(vcpu);
> +	ipte_unlock(vcpu->kvm);
>  
>  	return rc;
>  }
> @@ -1465,7 +1465,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
>  	 * tables/pointers we read stay valid - unshadowing is however
>  	 * always possible - only guest_table_lock protects us.
>  	 */
> -	ipte_lock(vcpu);
> +	ipte_lock(vcpu->kvm);
>  
>  	rc = gmap_shadow_pgt_lookup(sg, saddr, &pgt, &dat_protection, &fake);
>  	if (rc)
> @@ -1499,7 +1499,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
>  	pte.p |= dat_protection;
>  	if (!rc)
>  		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
> -	ipte_unlock(vcpu);
> +	ipte_unlock(vcpu->kvm);
>  	mmap_read_unlock(sg->mm);
>  	return rc;
>  }
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index 1124ff282012..9408d6cc8e2c 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -440,9 +440,9 @@ int read_guest_real(struct kvm_vcpu *vcpu, unsigned long gra, void *data,
>  	return access_guest_real(vcpu, gra, data, len, 0);
>  }
>  
> -void ipte_lock(struct kvm_vcpu *vcpu);
> -void ipte_unlock(struct kvm_vcpu *vcpu);
> -int ipte_lock_held(struct kvm_vcpu *vcpu);
> +void ipte_lock(struct kvm *kvm);
> +void ipte_unlock(struct kvm *kvm);
> +int ipte_lock_held(struct kvm *kvm);
>  int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
>  
>  /* MVPG PEI indication bits */
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 83bb5cf97282..12c464c7cddf 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -442,7 +442,7 @@ static int handle_ipte_interlock(struct kvm_vcpu *vcpu)
>  	vcpu->stat.instruction_ipte_interlock++;
>  	if (psw_bits(vcpu->arch.sie_block->gpsw).pstate)
>  		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> -	wait_event(vcpu->kvm->arch.ipte_wq, !ipte_lock_held(vcpu));
> +	wait_event(vcpu->kvm->arch.ipte_wq, !ipte_lock_held(vcpu->kvm));
>  	kvm_s390_retry_instr(vcpu);
>  	VCPU_EVENT(vcpu, 4, "%s", "retrying ipte interlock operation");
>  	return 0;
> @@ -1471,7 +1471,7 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
>  	access_key = (operand2 & 0xf0) >> 4;
>  
>  	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_DAT)
> -		ipte_lock(vcpu);
> +		ipte_lock(vcpu->kvm);
>  
>  	ret = guest_translate_address_with_key(vcpu, address, ar, &gpa,
>  					       GACC_STORE, access_key);
> @@ -1508,7 +1508,7 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_DAT)
> -		ipte_unlock(vcpu);
> +		ipte_unlock(vcpu->kvm);
>  	return ret;
>  }
>  


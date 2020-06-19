Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2862016DB
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 18:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388701AbgFSOp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 10:45:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4064 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388693AbgFSOpX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 10:45:23 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05JEXHNO181563;
        Fri, 19 Jun 2020 10:45:19 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31rtha9f38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 10:45:19 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05JEWdaU178935;
        Fri, 19 Jun 2020 10:45:19 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31rtha9f2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 10:45:19 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05JEfJUt031330;
        Fri, 19 Jun 2020 14:45:18 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 31rdtr7wh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 14:45:18 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05JEjF6j47513892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 14:45:15 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD2CC2805E;
        Fri, 19 Jun 2020 14:45:15 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16DC528058;
        Fri, 19 Jun 2020 14:45:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.172.102])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 19 Jun 2020 14:45:13 +0000 (GMT)
Subject: Re: [PATCH v8 2/2] s390/kvm: diagnose 0x318 sync and reset
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200618222222.23175-1-walling@linux.ibm.com>
 <20200618222222.23175-3-walling@linux.ibm.com>
 <f4b49098-e417-eafe-ff9f-df9ba2004fd9@linux.ibm.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <edd90e6c-e10f-924b-158a-f403788faf10@linux.ibm.com>
Date:   Fri, 19 Jun 2020 10:45:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <f4b49098-e417-eafe-ff9f-df9ba2004fd9@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_14:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 adultscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006190105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/20 7:02 AM, Janosch Frank wrote:
> On 6/19/20 12:22 AM, Collin Walling wrote:
>> DIAGNOSE 0x318 (diag318) sets information regarding the environment
>> the VM is running in (Linux, z/VM, etc) and is observed via
>> firmware/service events.
>>
>> This is a privileged s390x instruction that must be intercepted by
>> SIE. Userspace handles the instruction as well as migration. Data
>> is communicated via VCPU register synchronization.
>>
>> The Control Program Name Code (CPNC) is stored in the SIE block. The
>> CPNC along with the Control Program Version Code (CPVC) are stored
>> in the kvm_vcpu_arch struct.
>>
>> The CPNC is shadowed/unshadowed in VSIE.
>>
>> This data is reset on load normal and clear resets.
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Could you extend the s390 kvm selftests sync_regs test with diag318 please?
> 

Can do!

> I'd also like to have it added to the kvm unit tests. You can either do
> that yourself or I'll add it when I go over my pending patches. Since we
> can't retrieve these values from the VM, a simple check for the sclp
> feature bit and an execution of the instruction would be enough.
> 
>> ---
>>  arch/s390/include/asm/kvm_host.h |  4 +++-
>>  arch/s390/include/uapi/asm/kvm.h |  5 ++++-
>>  arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
>>  arch/s390/kvm/vsie.c             |  3 +++
>>  include/uapi/linux/kvm.h         |  1 +
>>  5 files changed, 21 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 3d554887794e..8bdf6f1607ca 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -260,7 +260,8 @@ struct kvm_s390_sie_block {
>>  	__u32	scaol;			/* 0x0064 */
>>  	__u8	sdf;			/* 0x0068 */
>>  	__u8    epdx;			/* 0x0069 */
>> -	__u8    reserved6a[2];		/* 0x006a */
>> +	__u8	cpnc;			/* 0x006a */
>> +	__u8	reserved6b;		/* 0x006b */
>>  	__u32	todpr;			/* 0x006c */
>>  #define GISA_FORMAT1 0x00000001
>>  	__u32	gd;			/* 0x0070 */
>> @@ -745,6 +746,7 @@ struct kvm_vcpu_arch {
>>  	bool gs_enabled;
>>  	bool skey_enabled;
>>  	struct kvm_s390_pv_vcpu pv;
>> +	union diag318_info diag318_info;
>>  };
>>  
>>  struct kvm_vm_stat {
>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>> index 436ec7636927..2ae1b660086c 100644
>> --- a/arch/s390/include/uapi/asm/kvm.h
>> +++ b/arch/s390/include/uapi/asm/kvm.h
>> @@ -231,11 +231,13 @@ struct kvm_guest_debug_arch {
>>  #define KVM_SYNC_GSCB   (1UL << 9)
>>  #define KVM_SYNC_BPBC   (1UL << 10)
>>  #define KVM_SYNC_ETOKEN (1UL << 11)
>> +#define KVM_SYNC_DIAG318 (1UL << 12)
>>  
>>  #define KVM_SYNC_S390_VALID_FIELDS \
>>  	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
>>  	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \
>> -	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
>> +	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN | \
>> +	 KVM_SYNC_DIAG318)
>>  
>>  /* length and alignment of the sdnx as a power of two */
>>  #define SDNXC 8
>> @@ -254,6 +256,7 @@ struct kvm_sync_regs {
>>  	__u64 pft;	/* pfault token [PFAULT] */
>>  	__u64 pfs;	/* pfault select [PFAULT] */
>>  	__u64 pfc;	/* pfault compare [PFAULT] */
>> +	__u64 diag318;	/* diagnose 0x318 info */
>>  	union {
>>  		__u64 vrs[32][2];	/* vector registers (KVM_SYNC_VRS) */
>>  		__u64 fprs[16];		/* fp registers (KVM_SYNC_FPRS) */
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index d0ff26d157bc..b05ad718b64b 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -545,6 +545,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_S390_AIS_MIGRATION:
>>  	case KVM_CAP_S390_VCPU_RESETS:
>>  	case KVM_CAP_SET_GUEST_DEBUG:
>> +	case KVM_CAP_S390_DIAG318:
>>  		r = 1;
>>  		break;
>>  	case KVM_CAP_S390_HPAGE_1M:
>> @@ -3267,7 +3268,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>  				    KVM_SYNC_ACRS |
>>  				    KVM_SYNC_CRS |
>>  				    KVM_SYNC_ARCH0 |
>> -				    KVM_SYNC_PFAULT;
>> +				    KVM_SYNC_PFAULT |
>> +				    KVM_SYNC_DIAG318;
>>  	kvm_s390_set_prefix(vcpu, 0);
>>  	if (test_kvm_facility(vcpu->kvm, 64))
>>  		vcpu->run->kvm_valid_regs |= KVM_SYNC_RICCB;
>> @@ -3562,6 +3564,7 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>>  		vcpu->arch.sie_block->pp = 0;
>>  		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>>  		vcpu->arch.sie_block->todpr = 0;
>> +		vcpu->arch.sie_block->cpnc = 0;
>>  	}
>>  }
>>  
>> @@ -3579,6 +3582,7 @@ static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
>>  
>>  	regs->etoken = 0;
>>  	regs->etoken_extension = 0;
>> +	regs->diag318 = 0;
>>  }
>>  
>>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>> @@ -4194,6 +4198,10 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>  		if (vcpu->arch.pfault_token == KVM_S390_PFAULT_TOKEN_INVALID)
>>  			kvm_clear_async_pf_completion_queue(vcpu);
>>  	}
>> +	if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
>> +		vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
>> +		vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
>> +	}
>>  	/*
>>  	 * If userspace sets the riccb (e.g. after migration) to a valid state,
>>  	 * we should enable RI here instead of doing the lazy enablement.
>> @@ -4295,6 +4303,7 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>  	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
>>  	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
>>  	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
>> +	kvm_run->s.regs.diag318 = vcpu->arch.diag318_info.val;
>>  	if (MACHINE_HAS_GS) {
>>  		__ctl_set_bit(2, 4);
>>  		if (vcpu->arch.gs_enabled)
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index 9e9056cebfcf..ba83d0568bc7 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -423,6 +423,8 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>  		break;
>>  	}
>>  
>> +	scb_o->cpnc = scb_s->cpnc;
>> +
>>  	if (scb_s->ihcpu != 0xffffU)
>>  		scb_o->ihcpu = scb_s->ihcpu;
>>  }
>> @@ -548,6 +550,7 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>  		scb_s->ecd |= scb_o->ecd & ECD_ETOKENF;
>>  
>>  	scb_s->hpid = HPID_VSIE;
>> +	scb_s->cpnc = scb_o->cpnc;
>>  
>>  	prepare_ibc(vcpu, vsie_page);
>>  	rc = shadow_crycb(vcpu, vsie_page);
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 4fdf30316582..35cdb4307904 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_PPC_SECURE_GUEST 181
>>  #define KVM_CAP_HALT_POLL 182
>>  #define KVM_CAP_ASYNC_PF_INT 183
>> +#define KVM_CAP_S390_DIAG318 184
>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
>>
> 
> 


-- 
Regards,
Collin

Stay safe and stay healthy

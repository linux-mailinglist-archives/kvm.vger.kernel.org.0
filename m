Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F842011FF
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405319AbgFSPrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:47:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405313AbgFSPru (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:47:50 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05JFWnNc062376;
        Fri, 19 Jun 2020 11:47:50 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rs7knuhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 11:47:50 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05JFWnY0062452;
        Fri, 19 Jun 2020 11:47:49 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31rs7knuha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 11:47:49 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05JFjRoH026513;
        Fri, 19 Jun 2020 15:47:49 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 31q6c8v3u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 15:47:49 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05JFlkwY51183982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 15:47:46 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1C3428059;
        Fri, 19 Jun 2020 15:47:46 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 755BE28058;
        Fri, 19 Jun 2020 15:47:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.172.102])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 19 Jun 2020 15:47:46 +0000 (GMT)
Subject: Re: [PATCH v8 2/2] s390/kvm: diagnose 0x318 sync and reset
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200618222222.23175-1-walling@linux.ibm.com>
 <20200618222222.23175-3-walling@linux.ibm.com>
 <eb41cdd1-9bdf-eb0c-1296-254ade66397a@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <e080cf6d-c8cb-a363-1fd1-cbbc4cbda7fe@linux.ibm.com>
Date:   Fri, 19 Jun 2020 11:47:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <eb41cdd1-9bdf-eb0c-1296-254ade66397a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_16:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015
 cotscore=-2147483648 mlxlogscore=999 suspectscore=0 phishscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006190114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/19/20 10:52 AM, David Hildenbrand wrote:
> On 19.06.20 00:22, Collin Walling wrote:
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
> 
> [...]
> 
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
> 
> "This is a privileged s390x instruction that must be intercepted", how
> can the cpnc change, then, while in SIE?
> 
> Apart from that LGTM.
> 

I thought shadow/unshadow was a load/store (respectively) when executing
in SIE for a level 3+ guest (where LPAR is level 1)?

* Shadow SCB (load shadow VSIE page; originally CPNC is 0)

* Execute diag318 (under SIE)

* Unshadow SCB (store in original VSIE page; CPNC is whatever code the
guest decided to set)

Don't we need to preserve the CPNC for the level 3+ guest somehow?

-- 
Regards,
Collin

Stay safe and stay healthy

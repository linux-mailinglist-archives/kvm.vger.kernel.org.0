Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F239152B82D
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 12:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbiERKr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 06:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiERKrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 06:47:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D477E90CCC;
        Wed, 18 May 2022 03:47:51 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IAKZxj013497;
        Wed, 18 May 2022 10:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=a6QBUi0AHQA+C2I98hT+CKa0i+amRKFGVmLjhD5CvTY=;
 b=S46wlk35wfN8YRtmjz8DIYMBPr+TXFlJTxn0TzLAaUV2IHvi1yM5z8QmlyQxP0WJU3ZC
 h/mPBrV7Ws5NpOk0KbWkXyAsSOZeU5HUaYqM6O5+AZT596cesGN2eFa6hc/2sfmYjYjB
 r8vIXhX0sOAK+EggUpfGgYcnhfv84YqPSiSv2nQC9hb1VeKwRGEZJdM1iv7IY4ap/IEn
 UWAH5ZecGDUSSN1+o4HONOGlTInWYdR82QPqnjqsQKSOJyyd1DtqNnuvG4ss15C3kntt
 Wu7eRyWhU6s4/L7ZePtEron+3ytFh0iqY+md5qStAXMIF+3GSCw5DkRscMypgusqHWKV VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4xybruem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 10:47:51 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24IALWAW019839;
        Wed, 18 May 2022 10:47:50 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4xybrue5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 10:47:50 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24IAlabt017562;
        Wed, 18 May 2022 10:47:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3g2429djxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 10:47:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24IAlj3P46793088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 10:47:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47DC8A405B;
        Wed, 18 May 2022 10:47:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 862C7A4054;
        Wed, 18 May 2022 10:47:44 +0000 (GMT)
Received: from [9.171.22.150] (unknown [9.171.22.150])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 May 2022 10:47:44 +0000 (GMT)
Message-ID: <93c07dce-a64a-fa1a-f70c-9db22ca53f68@linux.ibm.com>
Date:   Wed, 18 May 2022 12:51:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 3/3] s390x: KVM: resetting the Topology-Change-Report
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-4-pmorel@linux.ibm.com>
 <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gWM6D2RUNeri6TMwnWSmYV-0XgbZd999
X-Proofpoint-ORIG-GUID: pR25ogm1zAWtbYYs3loDU5iJEGD5d6Nv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 impostorscore=0 spamscore=0
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180059
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/22 11:31, David Hildenbrand wrote:
> On 06.05.22 11:24, Pierre Morel wrote:
>> During a subsystem reset the Topology-Change-Report is cleared.
>> Let's give userland the possibility to clear the MTCR in the case
>> of a subsystem reset.
>>
>> To migrate the MTCR, let's give userland the possibility to
>> query the MTCR state.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/include/uapi/asm/kvm.h |  5 ++
>>   arch/s390/kvm/kvm-s390.c         | 79 ++++++++++++++++++++++++++++++++
>>   2 files changed, 84 insertions(+)
>>
>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>> index 7a6b14874d65..abdcf4069343 100644
>> --- a/arch/s390/include/uapi/asm/kvm.h
>> +++ b/arch/s390/include/uapi/asm/kvm.h
>> @@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
>>   #define KVM_S390_VM_CRYPTO		2
>>   #define KVM_S390_VM_CPU_MODEL		3
>>   #define KVM_S390_VM_MIGRATION		4
>> +#define KVM_S390_VM_CPU_TOPOLOGY	5
>>   
>>   /* kvm attributes for mem_ctrl */
>>   #define KVM_S390_VM_MEM_ENABLE_CMMA	0
>> @@ -171,6 +172,10 @@ struct kvm_s390_vm_cpu_subfunc {
>>   #define KVM_S390_VM_MIGRATION_START	1
>>   #define KVM_S390_VM_MIGRATION_STATUS	2
>>   
>> +/* kvm attributes for cpu topology */
>> +#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR	0
>> +#define KVM_S390_VM_CPU_TOPO_MTR_SET	1
>> +
>>   /* for KVM_GET_REGS and KVM_SET_REGS */
>>   struct kvm_regs {
>>   	/* general purpose regs for s390 */
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index c8bdce31464f..80a1244f0ead 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1731,6 +1731,76 @@ static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
>>   	ipte_unlock(kvm);
>>   }
>>   
>> +/**
>> + * kvm_s390_sca_clear_mtcr
>> + * @kvm: guest KVM description
>> + *
>> + * Is only relevant if the topology facility is present,
>> + * the caller should check KVM facility 11
>> + *
>> + * Updates the Multiprocessor Topology-Change-Report to signal
>> + * the guest with a topology change.
>> + */
>> +static void kvm_s390_sca_clear_mtcr(struct kvm *kvm)
>> +{
>> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>> +
>> +	ipte_lock(kvm);
>> +	sca->utility  &= ~SCA_UTILITY_MTCR;
> 
> 
> One space too much.
> 
> sca->utility &= ~SCA_UTILITY_MTCR;
> 
>> +	ipte_unlock(kvm);
>> +}
>> +
>> +static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	if (!test_kvm_facility(kvm, 11))
>> +		return -ENXIO;
>> +
>> +	switch (attr->attr) {
>> +	case KVM_S390_VM_CPU_TOPO_MTR_SET:
>> +		kvm_s390_sca_set_mtcr(kvm);
>> +		break;
>> +	case KVM_S390_VM_CPU_TOPO_MTR_CLEAR:
>> +		kvm_s390_sca_clear_mtcr(kvm);
>> +		break;
>> +	}
>> +	return 0;
>> +}
>> +
>> +/**
>> + * kvm_s390_sca_get_mtcr
>> + * @kvm: guest KVM description
>> + *
>> + * Is only relevant if the topology facility is present,
>> + * the caller should check KVM facility 11
>> + *
>> + * reports to QEMU the Multiprocessor Topology-Change-Report.
>> + */
>> +static int kvm_s390_sca_get_mtcr(struct kvm *kvm)
>> +{
>> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>> +	int val;
>> +
>> +	ipte_lock(kvm);
>> +	val = !!(sca->utility & SCA_UTILITY_MTCR);
>> +	ipte_unlock(kvm);
>> +
>> +	return val;
>> +}
>> +
>> +static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
>> +{
>> +	int mtcr;
> 
> I think we prefer something like u16 when copying to user space.

I come back here.
I think I prefer to keep the int.

the u16 is more than the MTCR but the entire utility field, so what 
should I do:

rename the function to kvm_s390_get_sca_utility() ?
and then should I modify the KVM_S390_VM_CPU_TOPOLOGY
to KVM_S390_VM_SCA_UTILITY ?

I do not like that, I do not think we should report/handle more 
information than expected/needed.

I can mask the MTCR bit and return a u16 with bit 0 (0x8000) set
but I find this a little weird

I admit an int is may be not optimal.
logically I should report a bool but I do not like to report a bool 
through the UAPI.

The more I think about it the more I think an int is OK.
Or in the case we want to spare memory space I can create a flag in a 
u16 but it should theoretically be different than the firmware MTCR bit. 
Could be 0x0001.
But still, it is only to leave during the copy_to_user where the copy of 
an int may be as good or better than the copy of a u16.

So any more opinion on this?

Regards,
Pierre

> 
>> +
>> +	if (!test_kvm_facility(kvm, 11))
>> +		return -ENXIO;
>> +
>> +	mtcr = kvm_s390_sca_get_mtcr(kvm);
>> +	if (copy_to_user((void __user *)attr->addr, &mtcr, sizeof(mtcr)))
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
> 
> You should probably add documentation, and document that only the last
> bit (0x1) has a meaning.
> 
> Apart from that LGTM.
> 

-- 
Pierre Morel
IBM Lab Boeblingen

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE6555EAF6
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 19:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiF1RXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 13:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiF1RXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 13:23:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5500C2DA8C;
        Tue, 28 Jun 2022 10:23:36 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SHGokm023387;
        Tue, 28 Jun 2022 17:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=USbFFO10uk2ZizlRZ9dGQG8VXNHtbAJ18ezn20c7b5Y=;
 b=FKW4yluAfI3wGxcGgjG+HAiSDKhtHjVaRhpeCzcImfr1Y+Wvrk8gEPd575zq1UgOUZzk
 GAbnOJXuO0igo60XvyWiuDnAS0pbX1FRCPveyxOF93AJHWPjynDfNugoecOYBEtfrl3G
 eHW187gLEz+b1T5m0CvSPhnDVouMngodyYKBxFkXP0P0oHBY67DFwEAN59m7HCaLq66b
 9e89S6iRorLN4LF25RyULCcyU8SYzDuKI9ttK/fn3CRAcPyHSC8500WxLZ84ZBFK8oyp
 I2q7KTtpIBWNIj7bCORbGLau+HvB/SnWWmT8Mc82OszVCwdM5ljNalzUfQI0R4sL5dlt +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h05rv0bd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 17:23:35 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SHMNY1026177;
        Tue, 28 Jun 2022 17:23:34 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h05rv0bcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 17:23:34 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SHKbI2019188;
        Tue, 28 Jun 2022 17:23:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3gwt08uvu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 17:23:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SHNaRB32309512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 17:23:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A4E9AE053;
        Tue, 28 Jun 2022 17:23:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C6F0AE045;
        Tue, 28 Jun 2022 17:23:28 +0000 (GMT)
Received: from [9.171.41.104] (unknown [9.171.41.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 17:23:28 +0000 (GMT)
Message-ID: <13c7d30e-e5e1-2b73-2305-8e82465df9ed@linux.ibm.com>
Date:   Tue, 28 Jun 2022 19:27:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 3/3] KVM: s390: resetting the Topology-Change-Report
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-4-pmorel@linux.ibm.com>
 <03c79e51-7a0b-f406-d4d2-b10f43b6a7a1@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <03c79e51-7a0b-f406-d4d2-b10f43b6a7a1@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8GrcA_fKmoyP24pui1Gwfcbb63SFzkwM
X-Proofpoint-ORIG-GUID: fTVj-4qGhpVQrIwYjw4QYUWWjAKrORO4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_10,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 bulkscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/28/22 18:41, Janis Schoetterl-Glausch wrote:
> On 6/20/22 14:54, Pierre Morel wrote:
>> During a subsystem reset the Topology-Change-Report is cleared.
>> Let's give userland the possibility to clear the MTCR in the case
>> of a subsystem reset.
>>
>> To migrate the MTCR, we give userland the possibility to
>> query the MTCR state.
>>
>> We indicate KVM support for the CPU topology facility with a new
>> KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   Documentation/virt/kvm/api.rst   | 31 +++++++++++
>>   arch/s390/include/uapi/asm/kvm.h | 10 ++++
>>   arch/s390/kvm/kvm-s390.c         | 96 ++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h         |  1 +
>>   4 files changed, 138 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 11e00a46c610..326f8b7e7671 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -7956,6 +7956,37 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>>   When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
>>   type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
>>
>> +8.37 KVM_CAP_S390_CPU_TOPOLOGY
>> +------------------------------
>> +
>> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
>> +:Architectures: s390
>> +:Type: vm
>> +
>> +This capability indicates that KVM will provide the S390 CPU Topology
>> +facility which consist of the interpretation of the PTF instruction for
>> +the Function Code 2 along with interception and forwarding of both the
>> +PTF instruction with Function Codes 0 or 1 and the STSI(15,1,x)
>> +instruction to the userland hypervisor.
> 
> The way the code is written, STSI 15.x.x is forwarded to user space,
> might actually make sense to future proof the code by restricting that
> to 15.1.2-6 in priv.c.
>> +
>> +The stfle facility 11, CPU Topology facility, should not be provided
>> +to the guest without this capability.
>> +
>> +When this capability is present, KVM provides a new attribute group
>> +on vm fd, KVM_S390_VM_CPU_TOPOLOGY.
>> +This new attribute allows to get, set or clear the Modified Change
>> +Topology Report (MTCR) bit of the SCA through the kvm_device_attr
>> +structure.
>> +
>> +Getting the MTCR bit is realized by using a kvm_device_attr attr
>> +entry value of KVM_GET_DEVICE_ATTR and with kvm_device_attr addr
>> +entry pointing to the address of a struct kvm_cpu_topology.
>> +The value of the MTCR is return by the bit mtcr of the structure.
>> +
>> +When using KVM_SET_DEVICE_ATTR the MTCR is set by using the
>> +attr->attr value KVM_S390_VM_CPU_TOPO_MTCR_SET and cleared by
>> +using KVM_S390_VM_CPU_TOPO_MTCR_CLEAR.
>> +
>>   9. Known KVM API problems
>>   =========================
>>
>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>> index 7a6b14874d65..df5e8279ffd0 100644
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
>> @@ -171,6 +172,15 @@ struct kvm_s390_vm_cpu_subfunc {
>>   #define KVM_S390_VM_MIGRATION_START	1
>>   #define KVM_S390_VM_MIGRATION_STATUS	2
>>
>> +/* kvm attributes for cpu topology */
>> +#define KVM_S390_VM_CPU_TOPO_MTCR_CLEAR	0
>> +#define KVM_S390_VM_CPU_TOPO_MTCR_SET	1
> 
> Are you going to transition to a set-value-provided-by-user API with the next series?
> I don't particularly like that MTCR is user visible, it's kind of an implementation detail.

It is not the same structure as the hardware structure.
Even it looks like it.

I am OK to use something else, like a u8
in that case I need to say userland that the size of the data returned 
by get KVM_S390_VM_CPU_TOPOLOGY is u8.

I find this is a lack in the definition of the kvm_device_attr, it 
should have a size entry.

All other user of kvm_device_attr have structures and it is easy to the 
userland to get the size using the sizeof(struct...) one can say that 
userland knows that the parameter for topology is a u8 but that hurt me 
somehow.
May be it is stupid, for the other calls the user has to know the name 
of the structure anyway.

Then we can say the value of u8 bit 1 is the value of the mtcr.
OK for me.

What do you think?

> 
>> +
>> +struct kvm_cpu_topology {
>> +	__u16 mtcr : 1;
> 
> So I'd give this a more descriptive name, report_topology_change/topo_change_report_pending ?
> 
>> +	__u16 reserved : 15;
> 
> Are these bits for future proofing? If so a few more would do no harm IMO.
>> +};
> 
> The use of a bit field in uapi surprised my, but I guess it's fine and kvm_sync_regs has them too.
>> +
>>   /* for KVM_GET_REGS and KVM_SET_REGS */
>>   struct kvm_regs {
>>   	/* general purpose regs for s390 */
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 95b96019ca8e..ae39041bb149 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -606,6 +606,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   	case KVM_CAP_S390_PROTECTED:
>>   		r = is_prot_virt_host();
>>   		break;
>> +	case KVM_CAP_S390_CPU_TOPOLOGY:
>> +		r = test_facility(11);
>> +		break;
>>   	default:
>>   		r = 0;
>>   	}
>> @@ -817,6 +820,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>>   		icpt_operexc_on_all_vcpus(kvm);
>>   		r = 0;
>>   		break;
>> +	case KVM_CAP_S390_CPU_TOPOLOGY:
>> +		r = -EINVAL;
>> +		mutex_lock(&kvm->lock);
>> +		if (kvm->created_vcpus) {
>> +			r = -EBUSY;
>> +		} else if (test_facility(11)) {
>> +			set_kvm_facility(kvm->arch.model.fac_mask, 11);
>> +			set_kvm_facility(kvm->arch.model.fac_list, 11);
>> +			r = 0;
>> +		}
>> +		mutex_unlock(&kvm->lock);
>> +		VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
> 
> Most of the other cases spell out the cap, so it'd be "ENABLE: CAP_S390_CPU_TOPOLOGY %s".

OK

> 
>> +			 r ? "(not available)" : "(success)");
>> +		break;
>>   	default:
>>   		r = -EINVAL;
>>   		break;
>> @@ -1710,6 +1727,76 @@ static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
>>   	ipte_unlock(kvm);
>>   }
>>
> 
> Some brainstorming function names:
> 
> kvm_s390_get_topo_change_report
> kvm_s390_(un|re)set_topo_change_report
> kvm_s390_(publish|revoke|unpublish)_topo_change_report
> kvm_s390_(report|signal|revoke)_topology_change

kvm_s390_update_topology_change_report ?

> 
> [...]
> 

-- 
Pierre Morel
IBM Lab Boeblingen

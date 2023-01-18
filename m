Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28146719AF
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 11:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjARKxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 05:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjARKvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 05:51:16 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249D746722
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 02:01:24 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I9bIgt008962;
        Wed, 18 Jan 2023 10:01:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=E2wWvjJ2ShsUE4OipIfkPjOLCWAgOeAWZc/emk8Dud8=;
 b=VhTUWCpYJCUjAZG3H772BMobO6ve2mpc9qxSoD7qMHiIPh1yctqCKIzAmanDckIuAJKq
 z0vYvfPtSlJfY2gw/ycrL66SwKL6HSGWyM6AYHo2eMjQgIY6M7uYa7LUcgLwGUN7OgJ9
 y2be8WrA/VpOcO7e18sXaLPHpmmvvW94qjROPAxQCCrUP7F8eVUzBbARpaDRnLZHuARF
 LrUuVwEVyd6Los3KX83uMheB3lxbuJXtjIhWn+raTqHIAoq33DY55KTohZG5NvIlz3+N
 lVIpaTfZ3xQzGDvmaSI5YYnOyZk4xwuO18yz+LLSI+UGjVp6MeF6SgKbZcsdcHWuXQ0C JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6bu0c4c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 10:01:11 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30I9pmcB017241;
        Wed, 18 Jan 2023 10:01:11 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6bu0c4b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 10:01:10 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30I90XMf008380;
        Wed, 18 Jan 2023 10:01:09 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n3knfbqa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 10:01:08 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IA15Xh25363126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 10:01:05 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ACA620049;
        Wed, 18 Jan 2023 10:01:05 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37CE320043;
        Wed, 18 Jan 2023 10:01:04 +0000 (GMT)
Received: from [9.171.39.117] (unknown [9.171.39.117])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 10:01:04 +0000 (GMT)
Message-ID: <28187537-6d30-b4f0-7cea-ffe1cb3f7017@linux.ibm.com>
Date:   Wed, 18 Jan 2023 11:01:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 07/11] target/s390x/cpu topology: activating CPU
 topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-8-pmorel@linux.ibm.com>
 <69555196-ffde-8176-24d9-b8935fe6f365@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <69555196-ffde-8176-24d9-b8935fe6f365@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vc1KO1sLRAIMiGHi3NL9m7xyYdhqcCzp
X-Proofpoint-ORIG-GUID: VoTb2j_PQcPQt_hst6XoEDLAg0kgQ7Zn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_04,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/23 11:04, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> The KVM capability, KVM_CAP_S390_CPU_TOPOLOGY is used to
> 
> Remove the "," in above line?

OK

> 
>> activate the S390_FEAT_CONFIGURATION_TOPOLOGY feature and
>> the topology facility for the guest in the case the topology
> 
> I'd like to suggest to add "in the host CPU model" after "facility".

Yes, thanks.

> 
>> is available in QEMU and in KVM.
>>
>> The feature is disabled by default and fenced for SE
>> (secure execution).
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   hw/s390x/cpu-topology.c   |  2 +-
>>   target/s390x/cpu_models.c |  1 +
>>   target/s390x/kvm/kvm.c    | 13 +++++++++++++
>>   3 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index e6b4692581..b69955a1cd 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -52,7 +52,7 @@ static int s390_socket_nb(s390_topology_id id)
>>    */
>>   bool s390_has_topology(void)
>>   {
>> -    return false;
>> +    return s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY);
>>   }
>>   /**
>> diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
>> index c3a4f80633..3f05e05fd3 100644
>> --- a/target/s390x/cpu_models.c
>> +++ b/target/s390x/cpu_models.c
>> @@ -253,6 +253,7 @@ bool s390_has_feat(S390Feat feat)
>>           case S390_FEAT_SIE_CMMA:
>>           case S390_FEAT_SIE_PFMFI:
>>           case S390_FEAT_SIE_IBS:
>> +        case S390_FEAT_CONFIGURATION_TOPOLOGY:
>>               return false;
>>               break;
>>           default:
>> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
>> index fb63be41b7..4e2a2ff516 100644
>> --- a/target/s390x/kvm/kvm.c
>> +++ b/target/s390x/kvm/kvm.c
>> @@ -2470,6 +2470,19 @@ void kvm_s390_get_host_cpu_model(S390CPUModel 
>> *model, Error **errp)
>>           set_bit(S390_FEAT_UNPACK, model->features);
>>       }
>> +    /*
>> +     * If we have support for CPU Topology prevent overrule
>> +     * S390_FEAT_CONFIGURATION_TOPOLOGY with 
>> S390_FEAT_DISABLE_CPU_TOPOLOGY
> 
> That S390_FEAT_DISABLE_CPU_TOPOLOGY looks like a leftover from v12 ?

Right, sorry, I remove it and change the comment for:

     /*
      * If we have kernel support for CPU Topology indicate the
      * configuration-topology facility.
      */


> 
> Apart from that, patch looks fine to me now.
> 
>   Thomas
> 
> 
>> +     * implemented in KVM, activate the CPU TOPOLOGY feature.
>> +     */
>> +    if (kvm_check_extension(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY)) {
>> +        if (kvm_vm_enable_cap(kvm_state, KVM_CAP_S390_CPU_TOPOLOGY, 
>> 0) < 0) {
>> +            error_setg(errp, "KVM: Error enabling 
>> KVM_CAP_S390_CPU_TOPOLOGY");
>> +            return;
>> +        }
>> +        set_bit(S390_FEAT_CONFIGURATION_TOPOLOGY, model->features);
>> +    }
>> +
>>       /* We emulate a zPCI bus and AEN, therefore we don't need HW 
>> support */
>>       set_bit(S390_FEAT_ZPCI, model->features);
>>       set_bit(S390_FEAT_ADAPTER_EVENT_NOTIFICATION, model->features);
> 

-- 
Pierre Morel
IBM Lab Boeblingen

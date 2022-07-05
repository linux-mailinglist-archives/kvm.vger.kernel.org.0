Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77DF5664E3
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 10:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiGEIJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 04:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGEIJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 04:09:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2FC62D1;
        Tue,  5 Jul 2022 01:09:55 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2656pevZ020740;
        Tue, 5 Jul 2022 08:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9yp6yIu3Jg7BwHyGGaiyQ7aILo2+i66i6hqxXEfyXiI=;
 b=OIbFPO7/ZSY8KdrPrjlHCT8WbpMYqoOegA8ZW8S8fT1d0L4O++K6SVV73xw2MFKv9EVC
 jicQcLBSH3w9fk7stjN0heyxwqi5ZaO3dwZw6BWGvrPQqNbtbTMFulgUYROwV5CEN61H
 K7Pa/IAqhYIaEpA3bXjHdhcWkuQlkl9vJkC9eE8vIKvyPi7GzhyEmF54jLhnaY5mzQC4
 XEx+cNvicZX1Rgx74mgm3+v5YfKWkM13xBlByH1QIspnvr5EGZuljp1G1kXAnULu3Z7m
 SQLEvFinBP1+DMGJIzcVk8Z/YdCyI+H5QXro9yMaGaffp7F5ORblwejPl5KU7XcBmJke Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4gde9td4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 08:09:54 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2657esud007637;
        Tue, 5 Jul 2022 08:09:54 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4gde9tch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 08:09:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26585coa004294;
        Tue, 5 Jul 2022 08:09:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3h2d9jbq6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 08:09:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26589mlp24052186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 08:09:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E15AF4C046;
        Tue,  5 Jul 2022 08:09:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 509D14C040;
        Tue,  5 Jul 2022 08:09:48 +0000 (GMT)
Received: from [9.171.43.27] (unknown [9.171.43.27])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 08:09:48 +0000 (GMT)
Message-ID: <d8033b41-ca12-8d28-3482-c716838f05d7@linux.ibm.com>
Date:   Tue, 5 Jul 2022 10:09:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v11 3/3] KVM: s390: resetting the Topology-Change-Report
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220701162559.158313-1-pmorel@linux.ibm.com>
 <20220701162559.158313-4-pmorel@linux.ibm.com>
 <d90e2aaa-05ad-6f3a-83f8-428677256673@linux.ibm.com>
 <1f3b404f-0bd6-31cb-57de-591d2e03dd76@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <1f3b404f-0bd6-31cb-57de-591d2e03dd76@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nA8pY9QgHFAx5jDNAE6Tb7j9u_ZJesEm
X-Proofpoint-ORIG-GUID: wT2B8dKym_E1AQIVPP_WLGAXjwYULwNl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2207050033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/22 15:56, Pierre Morel wrote:
> 
> 
> On 7/4/22 11:35, Janis Schoetterl-Glausch wrote:
>> On 7/1/22 18:25, Pierre Morel wrote:
>>> During a subsystem reset the Topology-Change-Report is cleared.
>>>
>>> Let's give userland the possibility to clear the MTCR in the case
>>> of a subsystem reset.
>>>
>>> To migrate the MTCR, we give userland the possibility to
>>> query the MTCR state.
>>>
>>> We indicate KVM support for the CPU topology facility with a new
>>> KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   Documentation/virt/kvm/api.rst   | 25 +++++++++++++++
>>>   arch/s390/include/uapi/asm/kvm.h | 10 ++++++
>>>   arch/s390/kvm/kvm-s390.c         | 53 ++++++++++++++++++++++++++++++++
>>>   include/uapi/linux/kvm.h         |  1 +
>>>   4 files changed, 89 insertions(+)
>>>
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index 11e00a46c610..5e086125d8ad 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -7956,6 +7956,31 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
>>>   When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
>>>   type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
>>>   +8.37 KVM_CAP_S390_CPU_TOPOLOGY
>>> +------------------------------
>>> +
>>> +:Capability: KVM_CAP_S390_CPU_TOPOLOGY
>>> +:Architectures: s390
>>> +:Type: vm
>>> +
>>> +This capability indicates that KVM will provide the S390 CPU Topology
>>> +facility which consist of the interpretation of the PTF instruction for
>>> +the function code 2 along with interception and forwarding of both the
>>> +PTF instruction with function codes 0 or 1 and the STSI(15,1,x)
>>> +instruction to the userland hypervisor.
>> The latter only if the user STSI capability is also enabled.
> 
> Hum, not sure about this.
> we can not set facility 11 and return 3 to STSI(15) for valid selectors.

I think the PoP allows for this:

When the specified function-code, selector-1, and
selector-2 combination is invalid (is other than as
shown in Figure 10-84), or if it is valid but the
requested information is not available because the
specified level does not implement or does not fully
implement the instruction or because a necessary
part of the level is uninstalled or not initialized, and
provided that an exception is not recognized (see
“Special Conditions”), the condition code is set to 3.
When the function code is nonzero, the combination
is valid, the requested information is available, and
there is no exception, the requested information is
stored in a system-information block (SYSIB) at the
second-operand address.

So if user_stsi is off the information is not available because the level does not fully implement the instruction.
But I'm fine with KVM_CAP_S390_CPU_TOPOLOGY implying KVM_CAP_S390_USER_STSI, too.

> 
> I think that it was right before, KVM_CAP_S390_CPU_TOPOLOGY and KVM_CAP_S390_USER_STSI are independent in KVM, userland can turn on one and not the other.
> But KVM proposes both.
> 
> Of course it is stupid to turn on only KVM_CAP_S390_CPU_TOPOLOGY but KVM is not responsible for this userland is.
> 
> Otherwise, we need to check on KVM_CAP_S390_USER_STSI before authorizing  KVM_CAP_S390_CPU_TOPOLOGY and that looks even more complicated for me,
> or we suppress the KVM_CAP_S390_CPU_TOPOLOGY and implement the all stsi(15) in the kernel what I really do not think is good because of the complexity of the userland API

[...]

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F9B55E20E
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345018AbiF1Kxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 06:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245010AbiF1Kxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 06:53:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769A425590;
        Tue, 28 Jun 2022 03:53:45 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S9hrox005781;
        Tue, 28 Jun 2022 10:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Aeh6l4YqBLGFO2ASix/BXdnIcbkH5O76sYCmb9XaEF8=;
 b=c6KzwzdBHwOHWiv3DnChkO3j4YOOPuLsgUjLm/dd/+6Lr4ql27wWSkrwNlA4stqfPArT
 VRetT4h0HmHx/A2BCOq0+3KlaNjRrqo2kNM+hR7EGc/kMQ8i6537acLc1u5VvwusqteV
 QCKyWgPUJMzrq0uBa2UNeAjSw/aUwNCXPsECYYiTdwc/1XJRdRCl9uDuFMDRLe3JupyP
 FIN+bwWf9hMWx3OFDLNH7nvFba9d6ePCt6LWWanssE8K1MgXQz3cH19ZJSGU570EWq48
 qpz8mmYMUt43ScAWb8qNu2nyRC9JFIB5q6h2rdMsY3Si6tkehIUvAxvsOb4s+/+TkQgC dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyy909w3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:53:44 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25S9rWs6012874;
        Tue, 28 Jun 2022 10:53:44 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyy909w3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:53:43 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SAqnhb031514;
        Tue, 28 Jun 2022 10:53:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3gwt093g5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 10:53:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SArcmP14680460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 10:53:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DB22AE045;
        Tue, 28 Jun 2022 10:53:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED4EDAE04D;
        Tue, 28 Jun 2022 10:53:37 +0000 (GMT)
Received: from [9.171.41.104] (unknown [9.171.41.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 10:53:37 +0000 (GMT)
Message-ID: <28c52d15-aa80-09a8-297c-f5ae2b798998@linux.ibm.com>
Date:   Tue, 28 Jun 2022 12:58:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v10 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
 <20220620125437.37122-3-pmorel@linux.ibm.com>
 <207a01aa-d92c-4a17-7b2f-aed59da4ce09@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <207a01aa-d92c-4a17-7b2f-aed59da4ce09@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4oicraf6BxcnkywgBa7jo-qgBB94X-kd
X-Proofpoint-ORIG-GUID: 4frg73M86r-rr_xlpvsEnw8EX7f4TdJb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_05,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 malwarescore=0 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/28/22 10:59, Janis Schoetterl-Glausch wrote:
> On 6/20/22 14:54, Pierre Morel wrote:
>> We report a topology change to the guest for any CPU hotplug.
>>
>> The reporting to the guest is done using the Multiprocessor
>> Topology-Change-Report (MTCR) bit of the utility entry in the guest's
>> SCA which will be cleared during the interpretation of PTF.
>>
>> On every vCPU creation we set the MCTR bit to let the guest know the
>> next time he uses the PTF with command 2 instruction that the
>> topology changed and that he should use the STSI(15.1.x) instruction
>> to get the topology details.
>>
>> STSI(15.1.x) gives information on the CPU configuration topology.
>> Let's accept the interception of STSI with the function code 15 and
>> let the userland part of the hypervisor handle it when userland
>> support the CPU Topology facility.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 11 ++++++++---
>>   arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
>>   arch/s390/kvm/priv.c             | 15 +++++++++++----
>>   arch/s390/kvm/vsie.c             |  3 +++
>>   4 files changed, 48 insertions(+), 8 deletions(-)
>>
> [...]
> 
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 8fcb56141689..95b96019ca8e 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -1691,6 +1691,25 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>>   	return ret;
>>   }
>>
>> +/**
>> + * kvm_s390_sca_set_mtcr
> 
> I wonder if there is a better name, kvm_s390_report_topology_change maybe?
> 
>> + * @kvm: guest KVM description
>> + *
>> + * Is only relevant if the topology facility is present,
>> + * the caller should check KVM facility 11
>> + *
>> + * Updates the Multiprocessor Topology-Change-Report to signal
>> + * the guest with a topology change.
>> + */
>> +static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
>> +{
> 
> Do we need a sca_lock read_section here? If we don't why not?
> Did not see one up the stack, but I might have overlooked something.

Yes we do.
As I said about your well justified comment in a previous mail, 
ipte_lock is not the right thing to use here and I will replace with an 
inter locked update.

> 
>> +	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>> +
>> +	ipte_lock(kvm);
>> +	sca->utility |= SCA_UTILITY_MTCR;
>> +	ipte_unlock(kvm);
>> +}
>> +
> 
> [...]
> 

-- 
Pierre Morel
IBM Lab Boeblingen

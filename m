Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C3E573147
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 10:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbiGMIiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 04:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiGMIiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 04:38:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EE9BEB6E;
        Wed, 13 Jul 2022 01:38:18 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26D8aqMf007190;
        Wed, 13 Jul 2022 08:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZFvoD4hClcJWgrzecwcZftTd+IVYPCoJUlK1DihJvE4=;
 b=ejGZlpFsRTaPIhN/HUQhxAhSbZ7vhV9AnlSxfo4A/G4nuBY5rFIMuuwiCu/VBtKuVAFK
 si9JyFR7Xgw23eyf1NdVpQxCLSToizl3dcZt2Q7FtNkfj/O0t2WONutV5T6gyzYQlX7Z
 gAmZk6RResVCp0e6+hHs+GkbldZr9uRt3Rn1s+HaPD2MR/GdTV78hhSfEqPM4atag6qy
 c3APNPW9WsQzPocPMJcZ9KAI5ZNkvmuF0tqz1x996feE1AIpGsP10JdHVHcTvKOmQqJI
 Le4jJK5X8xdmw9ugAKqHYutdamXBRoP4ZdkdY5ZScwb/cipfYYbK2J+fma3WTAsDP6yw Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9t2qgweh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 08:38:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26D8aqq1007051;
        Wed, 13 Jul 2022 08:38:17 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9t2qgwd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 08:38:17 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26D8M5oK026070;
        Wed, 13 Jul 2022 08:38:15 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3h8ncngskf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 08:38:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26D8cB5F11862438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 08:38:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAB73AE045;
        Wed, 13 Jul 2022 08:38:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EF1CAE04D;
        Wed, 13 Jul 2022 08:38:11 +0000 (GMT)
Received: from [9.171.80.107] (unknown [9.171.80.107])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 08:38:11 +0000 (GMT)
Message-ID: <85d3e0ca-186d-197b-308c-d7629488bb8a@linux.ibm.com>
Date:   Wed, 13 Jul 2022 10:42:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v12 2/3] KVM: s390: guest support for topology function
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
References: <20220711084148.25017-1-pmorel@linux.ibm.com>
 <20220711084148.25017-3-pmorel@linux.ibm.com>
 <92c6d13c-4494-de56-83f4-9d7384444008@linux.ibm.com>
 <1884bc26-b91b-83a7-7f8b-96b6090a0bac@linux.ibm.com>
 <6124248a-24be-b43a-f827-b6bebf9e7f3d@linux.ibm.com>
 <5c3d9637-7739-1323-8630-433ff8cb4dc4@linux.ibm.com>
 <899e5148-8e65-8260-6f3c-546b4f5a650f@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <899e5148-8e65-8260-6f3c-546b4f5a650f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9WLw3WvJstg0n8Z9IhcZp0jIJzoSL6Y9
X-Proofpoint-ORIG-GUID: ZVuzvlEivkPLKnEZGtl3NjLYMW8cPfF2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/13/22 10:34, Janosch Frank wrote:
> [...]
>>>>>>     +/**
>>>>>> + * kvm_s390_update_topology_change_report - update CPU topology 
>>>>>> change report
>>>>>> + * @kvm: guest KVM description
>>>>>> + * @val: set or clear the MTCR bit
>>>>>> + *
>>>>>> + * Updates the Multiprocessor Topology-Change-Report bit to signal
>>>>>> + * the guest with a topology change.
>>>>>> + * This is only relevant if the topology facility is present.
>>>>>> + *
>>>>>> + * The SCA version, bsca or esca, doesn't matter as offset is the 
>>>>>> same.
>>>>>> + */
>>>>>> +static void kvm_s390_update_topology_change_report(struct kvm 
>>>>>> *kvm, bool val)
>>>>>> +{
>>>>>> +    union sca_utility new, old;
>>>>>> +    struct bsca_block *sca;
>>>>>> +
>>>>>> +    read_lock(&kvm->arch.sca_lock);
>>>>>> +    do {
>>>>>> +        sca = kvm->arch.sca;
>>>>>
>>>>> I find this assignment being in the loop unintuitive, but it should 
>>>>> not make a difference.
>>>>
>>>> The price would be an ugly cast.
>>>
>>> I don't get what you mean. Nothing about the types changes if you 
>>> move it before the loop.
>>
>> Yes right, did wrong understand.
>> It is better before.
> With the assignment moved one line up:
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thanks

> 
>>
>>>>
>>>>
>>>>>
>>>>>> +        old = READ_ONCE(sca->utility);
>>>>>> +        new = old;
>>>>>> +        new.mtcr = val;
>>>>>> +    } while (cmpxchg(&sca->utility.val, old.val, new.val) != 
>>>>>> old.val);
>>>>>> +    read_unlock(&kvm->arch.sca_lock);
>>>>>> +}
>>>>>> +
>>>>> [...]
>>>>>
>>>>
>>>>
>>>
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen

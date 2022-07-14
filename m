Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7045746C5
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 10:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbiGNIcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 04:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbiGNIcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 04:32:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4735D286FC;
        Thu, 14 Jul 2022 01:32:46 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E8KdgM009136;
        Thu, 14 Jul 2022 08:32:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cFaZ3Vr+W+qoOMpxojUcyA/iKf9/1eOSRbI4B3P7F/c=;
 b=nt1TayDtGYqdMLhuAYZpBAFy69vVbx7FqKiJ4gVCEW+edIeDfeQE99uofv+mHtkYpJPx
 LI/yiBzLyT0hfEl6ntQc+E/ycXGUJ4XlmAbv0aOznKAbhvaGnXtBYFbniFzrOJ0n3kic
 1LO5JDH5GlCkPuoEg9awmt+3fGdTjikQzlwmnLS5S4Suq/wqWiUhqgnEyQO7nWHt4msE
 WJanPbSHkwlxogfeH8ZDh3tEKTbY5EU/wWD87d2HDjh4qBeeDEUdM8aJCoLPbagaq/4F
 DlMyMuTfTRNgvHxFHbYdI0Zt1LkxRjUlxyGxf1Ve8UKigjpfIzURpn0U0ERJUWINH6XB 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hafj5886v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 08:32:45 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26E8VbWi024298;
        Thu, 14 Jul 2022 08:32:45 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hafj5886c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 08:32:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26E8KEAu022880;
        Thu, 14 Jul 2022 08:32:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3h71a8xsxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 08:32:43 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26E8Wep421234126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 08:32:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE11AAE04D;
        Thu, 14 Jul 2022 08:32:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 380F5AE045;
        Thu, 14 Jul 2022 08:32:39 +0000 (GMT)
Received: from [9.171.80.107] (unknown [9.171.80.107])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 08:32:39 +0000 (GMT)
Message-ID: <d62d2844-1d3b-4a0a-73dc-8ed961d9e22e@linux.ibm.com>
Date:   Thu, 14 Jul 2022 10:37:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v12 3/3] KVM: s390: resetting the Topology-Change-Report
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
 <20220711084148.25017-4-pmorel@linux.ibm.com>
 <58016efc-9053-b743-05d6-4ace4dcdc2a8@linux.ibm.com>
 <a268d8b7-bbd8-089d-896c-e4e3e4167e46@linux.ibm.com>
 <87c5514b-4971-b283-912c-573ab1b4d636@linux.ibm.com>
 <0c73fc23-2cfe-86c6-b91d-77a73bc435b4@linux.ibm.com>
 <7cd9cf5b-d91e-f676-48e9-abbea94d62e0@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7cd9cf5b-d91e-f676-48e9-abbea94d62e0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3wf5Hd9fRwDZNOqeZQWPDcGxUZaUvdtq
X-Proofpoint-ORIG-GUID: Is-kOT_28PLR2_9gy_lvOfAUFGYpUObM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_06,2022-07-13_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 bulkscore=0 phishscore=0 malwarescore=0
 spamscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/13/22 11:01, Janosch Frank wrote:
> On 7/12/22 13:17, Pierre Morel wrote:
>>
>>
>> On 7/12/22 10:47, Janis Schoetterl-Glausch wrote:
>>> On 7/12/22 09:24, Pierre Morel wrote:
>>>>
>>>>

...

>> kernel.
>>
>> In userland we check any wrong selector before the instruction goes back
>> to the guest.
> 
> I opt for passing the lower selectors down for QEMU to handle.

OK

> 
>>
>>> But that's only relevant if STSI can be extended without a 
>>> capability, which is why I asked about that.
>>
>> Logicaly any change, extension, in the architecture should be signaled
>> by a facility bit or something.
>>
>>>
>>>> Even testing the facility or PV in the kernel is for my opinion 
>>>> arguable in the case we do not do any treatment in the kernel.
> 
> That's actually a good point.
> 
> New instruction interceptions for PV will need to be enabled by KVM via 
> a switch somewhere since the UV can't rely on the fact that KVM will 
> correctly handle it without an enablement.
> 
> 
> So please remove the pv check

OK

> 

...

>>>>>>     +static int kvm_s390_set_topology(struct kvm *kvm, struct 
>>>>>> kvm_device_attr *attr)
>>>>>
>>>>> kvm_s390_set_topology_changed maybe?
>>>>> kvm_s390_get_topology_changed below then.
> 
> kvm_s390_set_topology_change_indication
> 
> It's long but it's rarely used.
> Maybe shorten topology to "topo"

OK
I use
kvm_s390_get_topo_change_indication()


Thanks.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D085B9D4B
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 16:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiIOOfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 10:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiIOOeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 10:34:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B77AC12
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 07:34:31 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FEUiXu032090;
        Thu, 15 Sep 2022 14:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SE2RqYex9gNtgdv47oPjhN7yiQ+BHCUr98X/0llR0B0=;
 b=QXYiIV4YuiJkzsEKHOQ+feEr6NI2NJZ7X4KiEnU2LjPK7tV4cwNucpdMMHphca9BlfH5
 N9o+FZpsN6f3/jtpBx5dpKqtxOD+NANW4r9d1lpEvIepjp7KFm3Ia7L4HIq1Q0BuYCTt
 wXmBlZMoUnoGLqhw3GEUd7r0bwk+Tr6N6ibsMeaS7cvmUX7SPJwp6wQNk0P+nbrFIpyu
 65N4aW6JM7g14flmTqc3Br7cWyTUnqGEu/hlDUmL4asteulYF58s2VYGAeKtPrtyBkKw
 1mqDUq8jRwxXLYkxhKPSjJspsFJp2BkkWrZEAqH+H2ZfvpZz476OOB9ktxxBv8/PT4Aw Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm4rhk3x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 14:34:19 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FDFsuh008765;
        Thu, 15 Sep 2022 14:34:19 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm4rhk3w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 14:34:18 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FEL87U019582;
        Thu, 15 Sep 2022 14:34:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3jjy9a1w1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 14:34:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FEUQpH33292756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 14:30:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08632A4051;
        Thu, 15 Sep 2022 14:34:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 575D2A4040;
        Thu, 15 Sep 2022 14:34:13 +0000 (GMT)
Received: from [9.171.87.36] (unknown [9.171.87.36])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 14:34:13 +0000 (GMT)
Message-ID: <52ad1240-1201-259a-80d0-6e05da561a7f@linux.ibm.com>
Date:   Thu, 15 Sep 2022 16:34:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>, pbonzini@redhat.com,
        seanjc@google.com, maz@kernel.org, james.morse@arm.com,
        david@redhat.com, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <a63becdf-18d7-25f1-9070-209dbc008add@linux.ibm.com>
In-Reply-To: <a63becdf-18d7-25f1-9070-209dbc008add@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bONXm89ApjwsQQv9RIZTHMDoEHcOYSPJ
X-Proofpoint-ORIG-GUID: JFjnXhLHsUNoQQHK7PK_or_VeRxVl6_F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_08,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=814 impostorscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150085
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 15.09.22 um 15:21 schrieb Christian Borntraeger:
> 
> 
> Am 15.09.22 um 12:10 schrieb Shivam Kumar:
>> Define variables to track and throttle memory dirtying for every vcpu.
>>
>> dirty_count:    Number of pages the vcpu has dirtied since its creation,
>>                  while dirty logging is enabled.
>> dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
>>                  more, it needs to request more quota by exiting to
>>                  userspace.
>>
>> Implement the flow for throttling based on dirty quota.
>>
>> i) Increment dirty_count for the vcpu whenever it dirties a page.
>> ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
>> count equals/exceeds dirty quota) to request more dirty quota.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> [...]
> 
> I am wondering if this will work on s390. On s390  we only call
> mark_page_dirty_in_slot for the kvm_read/write functions but not
> for those done by the guest on fault. We do account those lazily in
> kvm_arch_sync_dirty_log (like x96 in the past).
> 

I think we need to rework the page fault handling on s390 to actually make
use of this. This has to happen anyway somewhen (as indicated by the guest
enter/exit rework from Mark). Right now we handle KVM page faults directly
in the normal system fault handler. It seems we need to make a side turn
into KVM for page faults on guests in the long run.

Until this is done the dirty logging is really not per CPU on s390 so we
need to defer this feature for now. CC other s390 maintainers.
The other use case for a page fault handler rework was Mark Rutlands
"kvm: fix latent guest entry/exit bugs" series which did not work on s390.

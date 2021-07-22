Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DF73D1F18
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 09:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhGVG4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 02:56:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhGVG4C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 02:56:02 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16M7XU5s087187;
        Thu, 22 Jul 2021 03:36:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zi6INeEFAvvgQooM3qV0R2TsSkLmOjDUY7B73ZJhLyk=;
 b=hVEmkrm/4tujKP7MG+KYCq9UTDwiqarniCyWUQEW1IJtEuvbPJuepXaaJc4YiSfmQkK0
 sQq//15b8kA8CIp2dirkNAAos1CMkOGeC9Wso3oQKESu3Hf0pCDUVH4IbUuRQdx0hByE
 LRh7m5SL10iTzT1RtufWPUo5IEpJpUDevxqRLj4oC/XwzF7PcH8kriYet5D76nlkAW1q
 8XMuzW6DMg4gH4fds3rdoOQ/NI7pI6C7qz4WkUXGuhAp594mM/6FhKIO/oyGXvTju59W
 iemcMrgqhUHRlvyk0T61EGaU3vVc2bT32d1gzcImoE6u+1nVUEIzEVX33R4rk66A/YqD Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39y476raa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 03:36:15 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16M7XmEP088235;
        Thu, 22 Jul 2021 03:36:15 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39y476ra8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 03:36:14 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16M7Qrv9003356;
        Thu, 22 Jul 2021 07:36:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 39xhx48fsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 07:36:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16M7XeeC31654384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 07:33:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC374C046;
        Thu, 22 Jul 2021 07:36:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3026C4C050;
        Thu, 22 Jul 2021 07:36:08 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.166.24])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jul 2021 07:36:08 +0000 (GMT)
Subject: Re: [PATCH] mm,do_huge_pmd_numa_page: remove unnecessary TLB flushing
 code
To:     "Huang, Ying" <ying.huang@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mel Gorman <mgorman@suse.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>
References: <20210720065529.716031-1-ying.huang@intel.com>
 <eadff602-3824-f69d-e110-466b37535c99@de.ibm.com>
 <CAHbLzkp6LDLUK9TLM+geQM6+X6+toxAGi53UBd49Zm5xgc5aWQ@mail.gmail.com>
 <0D75A92F-E2AA-480C-9E9A-0B6EE7897757@nvidia.com>
 <CAHbLzkqZZEic7+H0ky9u+aKO5o_cF0N5xQ=JO2tMpc8jg8RcnQ@mail.gmail.com>
 <YPhAEcHOCZ5yII/T@google.com>
 <87lf5z9osl.fsf@yhuang6-desk2.ccr.corp.intel.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <572f1ddd-9ac6-fb09-9a24-1c667dbd1d03@de.ibm.com>
Date:   Thu, 22 Jul 2021 09:36:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87lf5z9osl.fsf@yhuang6-desk2.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Xv4Wmc0pneGfLw8xA7K63x6qiUNwssAP
X-Proofpoint-ORIG-GUID: 8JO7E1POw03q6scXVxGporOCAuzLvBhi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-22_03:2021-07-22,2021-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107220047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.07.21 02:26, Huang, Ying wrote:
> Sean Christopherson <seanjc@google.com> writes:
>>>
>>> Thanks, I think you are correct. By looking into commit 7066f0f933a1
>>> ("mm: thp: fix mmu_notifier in migrate_misplaced_transhuge_page()"),
>>> the tlb flush and mmu notifier invalidate were needed since the old
>>> numa fault implementation didn't change PTE to migration entry so it
>>> may cause data corruption due to the writes from GPU secondary MMU.
>>>
>>> The refactor does use the generic migration code which converts PTE to
>>> migration entry before copying data to the new page.
>>
>> That's my understanding as well, based on this blurb from commit 7066f0f933a1.
>>
>>      The standard PAGE_SIZEd migrate_misplaced_page is less accelerated and
>>      uses the generic migrate_pages which transitions the pte from
>>      numa/protnone to a migration entry in try_to_unmap_one() and flushes TLBs
>>      and all mmu notifiers there before copying the page.
>>
>> That analysis/justification for removing the invalidate_range() call should be
>> captured in the changelog.  Confirmation from Andrea would be a nice bonus.
> 
> When we flush CPU TLB for a page that may be shared with device/VM TLB,
> we will call MMU notifiers for the page to flush the device/VM TLB.
> Right?  So when we replaced CPU TLB flushing in do_huge_pmd_numa_page()
> with that in try_to_migrate_one(), we will replace the MMU notifiers
> calling too.  Do you agree?

Can someone write an updated commit messages that contains this information?

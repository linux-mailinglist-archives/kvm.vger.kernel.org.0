Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23BA39F321
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 12:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhFHKF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 06:05:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13446 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229937AbhFHKF5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 06:05:57 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158A3H0B075304;
        Tue, 8 Jun 2021 06:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZcheQlGHmkMQQUl4QvweBPhrFsKWNti3rI/Z/2DkKqc=;
 b=GWnuXNLX6Z4Zk4QuualH616xgwJ85i5qcjl2cW5TKFcue7l1cJLkpPQ0oVuOCHwepZol
 euwPROWufIKCrKqkBj4cwPLLGBc7tV0pjIvkjz+O6vnIL80d403zU1xnwHNwsK1SlIWn
 f2KuOBqhRvr2YvL+ebHuOp7muRkbrltSei2ZlHfgKrVva8dEfnA/rpeoNQRKgXJu9mVo
 4bWZMmCxG0VKEWEz9hHjrWf65fKIdI7AnhjMXaNhjVAYGNBXyRJQQyiHFA+SsotVpagR
 kkpn2qCOlZFsFBLSpEC7ws3VHeTtkgIsjyVepIT+012hvyP/G+U3vwnJgkjR+0/QKU5h BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3926dm0305-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 06:04:03 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158A3IYC075378;
        Tue, 8 Jun 2021 06:04:03 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3926dm02xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 06:04:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158A40XI030451;
        Tue, 8 Jun 2021 10:04:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8he1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 10:04:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158A3xBa35389792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 10:03:59 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B85FA4067;
        Tue,  8 Jun 2021 10:03:59 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDB9DA405B;
        Tue,  8 Jun 2021 10:03:58 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.36.114])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Jun 2021 10:03:58 +0000 (GMT)
Subject: Re: [PATCH v2] KVM: selftests: Fix 32-bit truncation of
 vm_get_max_gfn()
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20210521173828.1180619-1-dmatlack@google.com>
 <8cae6330-f88a-ec24-4e7d-bc999f49288d@de.ibm.com>
Message-ID: <4d6513f3-d921-dff0-d883-51c6dbdcbe39@de.ibm.com>
Date:   Tue, 8 Jun 2021 12:03:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <8cae6330-f88a-ec24-4e7d-bc999f49288d@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dcf7iN5FfBpuvWmPllwQQbcpJ3gtXhbR
X-Proofpoint-ORIG-GUID: DMoC9UMRNqX2qFx6MQomsiZqgpAOi8e5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_08:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=938 lowpriorityscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.06.21 10:39, Christian Borntraeger wrote:
> 
> 
> On 21.05.21 19:38, David Matlack wrote:
>> vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
>> which causes the upper 32-bits of the max_gfn to get truncated.
>>
>> Nobody noticed until now likely because vm_get_max_gfn() is only used
>> as a mechanism to create a memslot in an unused region of the guest
>> physical address space (the top), and the top of the 32-bit physical
>> address space was always good enough.
>>
>> This fix reveals a bug in memslot_modification_stress_test which was
>> trying to create a dummy memslot past the end of guest physical memory.
>> Fix that by moving the dummy memslot lower.
>>
>> Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
>> Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
>> Signed-off-by: David Matlack <dmatlack@google.com>
> 
> As a heads up:
> I have not yet looked into this, but this broke demand_paging_test and kvm_page_table_test
> on s390:
> 
> not ok 4 selftests: kvm: demand_paging_test # exit=254
> # selftests: kvm: dirty_log_test
> # ==== Test Assertion Failure ====
> #   lib/kvm_util.c:900: ret == 0
> #   pid=245410 tid=245410 errno=22 - Invalid argument
> #      1    0x0000000001005457: vm_userspace_mem_region_add at kvm_util.c:900
> #      2    0x0000000001002cbf: run_test at dirty_log_test.c:757
> #      3     (inlined by) run_test at dirty_log_test.c:702
> #      4    0x000000000100c055: for_each_guest_mode at guest_modes.c:37
> #      5    0x00000000010022b5: main at dirty_log_test.c:929 (discriminator 3)
> #      6    0x000003ff96fabdb3: ?? ??:0
> #      7    0x000000000100241d: .annobin_lto.hot at crt1.o:?
> #   KVM_SET_USER_MEMORY_REGION IOCTL failed,
> #   rc: -1 errno: 22
> #   slot: 1 flags: 0x1
> #   guest_phys_addr: 0xfffffbfe00000 size: 0x40100000

Ah. We do have a limit of 128TB for guest physical memory. The patch now made this
apparent as we no longer cut the upper bits off.

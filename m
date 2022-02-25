Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D134C465B
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 14:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241234AbiBYNaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 08:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiBYNaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 08:30:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880B22028AB;
        Fri, 25 Feb 2022 05:29:39 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PBMjBr012240;
        Fri, 25 Feb 2022 13:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Vn90irpMkq00xDd5Ps246VaLOSORd2MB7UfmWYtLgDY=;
 b=shJRun8UpwV0xolVsawwfTahqO4L9+yQMO8GLTv9XS0PXoAJnD5OIQakTzg4bfro1uYa
 lHQO8A/eEfAcUAdZFcrbfY0LO6pHszXOFVD+Gv2y6/ZQ6Pg4UnPlS+JDG9/My96PQao0
 Lm6NC9yjZaoFHoC602oIXiTpz4ipwWCLVyTYFrDwGHMzsUPPwkKzel8D8BxImGk0Czdv
 M02BFpZ7+Ifnq0g5wA2+x+Cq8LmQzju4Hl1NAt0pOiW7zNxex+REkcSfkt3cohHmIoFD
 x/f2/T2WzylKkDJ/D/QaCTFRx99hSEiTc5zLYkAIdPtdLmHba2+xTGiruEs2hydZsSmW 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edtv98rt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 13:29:38 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21PDTbPF015924;
        Fri, 25 Feb 2022 13:29:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edtv98rsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 13:29:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PDOpIL012123;
        Fri, 25 Feb 2022 13:29:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqtjrwmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 13:29:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PDImsF44433800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 13:18:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9952811C05C;
        Fri, 25 Feb 2022 13:29:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEC3811C04A;
        Fri, 25 Feb 2022 13:29:31 +0000 (GMT)
Received: from [9.171.85.161] (unknown [9.171.85.161])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 13:29:31 +0000 (GMT)
Message-ID: <9869257e-d257-da83-edd6-0c167f915829@de.ibm.com>
Date:   Fri, 25 Feb 2022 14:29:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/1] KVM: s390: pv: make use of ultravisor AIV support
Content-Language: en-US
To:     Michael Mueller <mimu@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220209152217.1793281-1-mimu@linux.ibm.com>
 <20220209152217.1793281-2-mimu@linux.ibm.com>
 <803275d5-58f4-21d9-8020-e56f05737450@de.ibm.com>
 <d58a6a64-a6b6-3238-00d7-573e4177f38c@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <d58a6a64-a6b6-3238-00d7-573e4177f38c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DPAlZUnDsQXp0G3lMS7BeJ8GZ0UyHu0k
X-Proofpoint-GUID: LNeVDkjWMcUVakMx_AjGSCG8Wmrywwhe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_07,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202250074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 24.02.22 um 16:47 schrieb Michael Mueller:
> 
> 
> On 22.02.22 09:13, Christian Borntraeger wrote:
>> Am 09.02.22 um 16:22 schrieb Michael Mueller:
>>> This patch enables the ultravisor adapter interruption vitualization
>>> support indicated by UV feature BIT_UV_FEAT_AIV. This allows ISC
>>> interruption injection directly into the GISA IPM for PV kvm guests.
>>>
>>> Hardware that does not support this feature will continue to use the
>>> UV interruption interception method to deliver ISC interruptions to
>>> PV kvm guests. For this purpose, the ECA_AIV bit for all guest cpus
>>> will be cleared and the GISA will be disabled during PV CPU setup.
>>>
>>> In addition a check in __inject_io() has been removed. That reduces the
>>> required instructions for interruption handling for PV and traditional
>>> kvm guests.
>>>
>>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>>
>> The CI said the following with gisa_disable in the calltrace.
>> Will drop from next for now.
> 
> It turns out this is related to kvm_s390_set_tod_clock() which
> is triggered by a kvm-unit-test (sac_PV) and not related directly
> to this patch. Please re-apply.

Done. We need to fix the sck handler instead.

> 
>>
>>     LOCKDEP_CIRCULAR (suite: kvm-unit-tests-kvm, case: -)
>>                  WARNING: possible circular locking dependency detected
>> 5.17.0-20220221.rc5.git1.b8f0356a093a.300.fc35.s390x+debug #1 Not tainted
>>                  ------------------------------------------------------
>>                  qemu-system-s39/161139 is trying to acquire lock:
>>                  0000000280dc0b98 (&kvm->lock){+.+.}-{3:3}, at: kvm_s390_set_tod_clock+0x36/0x220 [kvm]
>>                  but task is already holding lock:
>>                  0000000280f4e4b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x9a/0xa40 [kvm]
>>                  which lock already depends on the new lock.
>>                  the existing dependency chain (in reverse order) is:
>>                  -> #1 (&vcpu->mutex){+.+.}-{3:3}:
>>                         __lock_acquire+0x604/0xbd8
>>                         lock_acquire.part.0+0xe2/0x250
>>                         lock_acquire+0xb0/0x200
>>                         __mutex_lock+0x9e/0x8a0
>>                         mutex_lock_nested+0x32/0x40
>>                         kvm_s390_gisa_disable+0xa4/0x130 [kvm]
>>                         kvm_s390_handle_pv+0x718/0x778 [kvm]
>>                         kvm_arch_vm_ioctl+0x4ac/0x5f8 [kvm]
>>                         kvm_vm_ioctl+0x336/0x530 [kvm]
>>                         __s390x_sys_ioctl+0xbe/0x100
>>                         __do_syscall+0x1da/0x208
>>                         system_call+0x82/0xb0
>>                  -> #0 (&kvm->lock){+.+.}-{3:3}:
>>                         check_prev_add+0xe0/0xed8
>>                         validate_chain+0x736/0xb20
>>                         __lock_acquire+0x604/0xbd8
>>                         lock_acquire.part.0+0xe2/0x250
>>                         lock_acquire+0xb0/0x200
>>                         __mutex_lock+0x9e/0x8a0
>>                         mutex_lock_nested+0x32/0x40
>>                         kvm_s390_set_tod_clock+0x36/0x220 [kvm]
>>                         kvm_s390_handle_b2+0x378/0x728 [kvm]
>>                         kvm_handle_sie_intercept+0x13a/0x448 [kvm]
>>                         vcpu_post_run+0x28e/0x560 [kvm]
>>                         __vcpu_run+0x266/0x388 [kvm]
>>                         kvm_arch_vcpu_ioctl_run+0x10a/0x270 [kvm]
>>                         kvm_vcpu_ioctl+0x27c/0xa40 [kvm]
>>                         __s390x_sys_ioctl+0xbe/0x100
>>                         __do_syscall+0x1da/0x208
>>                         system_call+0x82/0xb0
>>                  other info that might help us debug this:
>>                   Possible unsafe locking scenario:
>>                         CPU0                    CPU1
>>                         ----                    ----
>>                    lock(&vcpu->mutex);
>>                                                 lock(&kvm->lock);
>>                                                 lock(&vcpu->mutex);
>>                    lock(&kvm->lock);
>>                   *** DEADLOCK ***
>>                  2 locks held by qemu-system-s39/161139:
>>                   #0: 0000000280f4e4b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x9a/0xa40 [kvm]
>>                   #1: 0000000280dc47c8 (&kvm->srcu){....}-{0:0}, at: __vcpu_run+0x1d4/0x388 [kvm]
>>                  stack backtrace:
>>                  CPU: 10 PID: 161139 Comm: qemu-system-s39 Not tainted 5.17.0-20220221.rc5.git1.b8f0356a093a.300.fc35.s390x+debug #1
>>                  Hardware name: IBM 8561 T01 701 (LPAR)
>>                  Call Trace:
>>                   [<00000001da4e89de>] dump_stack_lvl+0x8e/0xc8
>>                   [<00000001d9876c56>] check_noncircular+0x136/0x158
>>                   [<00000001d9877c70>] check_prev_add+0xe0/0xed8
>>                   [<00000001d987919e>] validate_chain+0x736/0xb20
>>                   [<00000001d987b23c>] __lock_acquire+0x604/0xbd8
>>                   [<00000001d987c432>] lock_acquire.part.0+0xe2/0x250
>>                   [<00000001d987c650>] lock_acquire+0xb0/0x200
>>                   [<00000001da4f72ae>] __mutex_lock+0x9e/0x8a0
>>                   [<00000001da4f7ae2>] mutex_lock_nested+0x32/0x40
>>                   [<000003ff8070cd6e>] kvm_s390_set_tod_clock+0x36/0x220 [kvm]
>>                   [<000003ff8071dd68>] kvm_s390_handle_b2+0x378/0x728 [kvm]
>>                   [<000003ff8071146a>] kvm_handle_sie_intercept+0x13a/0x448 [kvm]
>>                   [<000003ff8070dd46>] vcpu_post_run+0x28e/0x560 [kvm]
>>                   [<000003ff8070e27e>] __vcpu_run+0x266/0x388 [kvm]
>>                   [<000003ff8070eba2>] kvm_arch_vcpu_ioctl_run+0x10a/0x270 [kvm]
>>                   [<000003ff806f4044>] kvm_vcpu_ioctl+0x27c/0xa40 [kvm]
>>                   [<00000001d9b47ac6>] __s390x_sys_ioctl+0xbe/0x100
>>                   [<00000001da4ec152>] __do_syscall+0x1da/0x208
>>                   [<00000001da4fec42>] system_call+0x82/0xb0
>>                  INFO: lockdep is turned off.

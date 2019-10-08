Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1653CF0C5
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 04:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfJHCUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 22:20:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51272 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbfJHCUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 22:20:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x982IkdU048775;
        Tue, 8 Oct 2019 02:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=I/1ZOG0KQJ1XeouCR4SXL2HIi2M9pjNcEOAgDRDriec=;
 b=ieozgDXdAP/HFecEbs0rlI3ui4NXJVl3C1Oo0S3R7rKggz/O0GKuzVaLrzWN4MTmIIAC
 9/ktb9euli0iXh0BkHGfbQzo4YPqjI1VBmFd4GtNyhpfS57XfGmMTSYYPdcBh7NCYuTL
 5YPQioPLpPwuVGggRWeXLtAaNF/0rbltyQgnzbBUt4lv5u/u4V9NaoFEFxd5orNxLAZR
 +XL3zjwS6Qc6JIoHykCn7/W9glDF4faVnO9nqJocaTUjUToU6AnNsJWF2WtHfDIvmx5b
 JjCjTgdwiFZ3TxCAyikAvc99U/UHEV25bty3jOBCbA0PYwv+rTRd3N2XZ3zol16ezMCx Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vek4qaajj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 02:18:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x982Icdi038981;
        Tue, 8 Oct 2019 02:18:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vg2055rtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 02:18:45 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x982Hcmr015945;
        Tue, 8 Oct 2019 02:17:38 GMT
Received: from [10.191.3.27] (/10.191.3.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Oct 2019 19:17:38 -0700
Subject: Re: [PATCH v4 1/4] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        jgross@suse.com, sstabellini@kernel.org, peterz@infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>
References: <1570111335-12731-1-git-send-email-zhenzhong.duan@oracle.com>
 <1570111335-12731-2-git-send-email-zhenzhong.duan@oracle.com>
 <26ef7beb-dad0-13c9-fc2f-217a5e046e4d@oracle.com>
 <b0d6df7b-00ff-cdd8-f9f2-26af73256f5b@oracle.com>
 <ee3feb72-e587-9ac8-d5ba-e5c00b2a89c7@oracle.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <cf42de29-3460-b9ee-538f-2b1366db6ce3@oracle.com>
Date:   Tue, 8 Oct 2019 10:17:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <ee3feb72-e587-9ac8-d5ba-e5c00b2a89c7@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080023
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/7 22:46, Boris Ostrovsky wrote:
> On 10/6/19 3:49 AM, Zhenzhong Duan wrote:
>> On 2019/10/4 22:52, Boris Ostrovsky wrote:
>>
>>> On 10/3/19 10:02 AM, Zhenzhong Duan wrote:
>>>>    void __init kvm_spinlock_init(void)
>>>>    {
>>>> -    /* Does host kernel support KVM_FEATURE_PV_UNHALT? */
>>>> -    if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>>>> -        return;
>>>> -
>>>> -    if (kvm_para_has_hint(KVM_HINTS_REALTIME))
>>>> +    /*
>>>> +     * Don't use the pvqspinlock code if no KVM_FEATURE_PV_UNHALT
>>>> feature
>>>> +     * support, or there is REALTIME hints or only 1 vCPU.
>>>> +     */
>>>> +    if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
>>>> +        kvm_para_has_hint(KVM_HINTS_REALTIME) ||
>>>> +        num_possible_cpus() == 1) {
>>>> +        pr_info("PV spinlocks disabled\n");
>>>>            return;
>>>> +    }
>>>>    -    /* Don't use the pvqspinlock code if there is only 1 vCPU. */
>>>> -    if (num_possible_cpus() == 1)
>>>> +    if (nopvspin) {
>>>> +        pr_info("PV spinlocks disabled forced by \"nopvspin\"
>>>> parameter.\n");
>>>> +        static_branch_disable(&virt_spin_lock_key);
>>> Would it make sense to bring here the other site where the key is
>>> disabled (in kvm_smp_prepare_cpus())?
>> Thanks for point out, I'll do it. Just not clear if I should do that
>> in a separate patch,
>> there is a history about that code:
>>
>> Its original place was here and then moved to kvm_smp_prepare_cpus()
>> by below commit:
>> 34226b6b ("KVM: X86: Fix setup the virt_spin_lock_key before static
>> key get initialized")
>> which fixed jump_label_init() calling late issue.
>>
>> Then 8990cac6 ("x86/jump_label: Initialize static branching early")
>> move jump_label_init()
>> early, so commit 34226b6b could be reverted.
> Which is similar to what you did earlier for Xen.

You remember that, ok, I'll do the same for KVM.

Thanks

Zhenzhong


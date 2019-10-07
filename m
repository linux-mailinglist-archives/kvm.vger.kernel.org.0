Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B044CE5A3
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 16:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfJGOsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 10:48:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50714 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGOsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 10:48:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x97EiEY1125543;
        Mon, 7 Oct 2019 14:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4N9yoYf9MRwUqpnd56wp98SUWYHADiH5FtpOOJuf0gk=;
 b=hrnkujhqdN3DqHnzuVtsRmqrQ0R7uDmpTRgE/e9INNY9Nf+88ILdGWOZBBr2Dz/j1D+H
 0jhX0ewC4939ghw+fFmBaWmoGz4Zdt+KtdmB7IZtyMMLWAR19wX567LSITKc7LGF04uf
 G3NLFUEpj7CnPN0AhHaK8dRiCbl0WKYEIRYt+ZxP/jVo8mhtQ6SBe+QGQZPIzBE5ph2z
 /TOoXLoRI50fZhMSqof6MOJk+xR3N5FLCkG/ldCr7uHtOnXixbCAcA2atzoe3fFDNhp6
 7YZjgP26XmT4LrC/mssrMXOU0xObtzMiXfr7T0H25OTgDs4xG9idsOC/LQpDSUzKcTPM 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vejku784w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Oct 2019 14:46:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x97Ejixh071811;
        Mon, 7 Oct 2019 14:46:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vf4phnq3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Oct 2019 14:46:35 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x97EkNxG019145;
        Mon, 7 Oct 2019 14:46:24 GMT
Received: from bostrovs-us.us.oracle.com (/10.152.32.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Oct 2019 07:46:23 -0700
Subject: Re: [PATCH v4 1/4] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>,
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
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Openpgp: preference=signencrypt
Autocrypt: addr=boris.ostrovsky@oracle.com; prefer-encrypt=mutual; keydata=
 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
 Jg6OxFYd01z+a+oL
Message-ID: <ee3feb72-e587-9ac8-d5ba-e5c00b2a89c7@oracle.com>
Date:   Mon, 7 Oct 2019 10:46:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <b0d6df7b-00ff-cdd8-f9f2-26af73256f5b@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910070147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910070147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/19 3:49 AM, Zhenzhong Duan wrote:
> On 2019/10/4 22:52, Boris Ostrovsky wrote:
>
>> On 10/3/19 10:02 AM, Zhenzhong Duan wrote:
>>>   void __init kvm_spinlock_init(void)
>>>   {
>>> -    /* Does host kernel support KVM_FEATURE_PV_UNHALT? */
>>> -    if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>>> -        return;
>>> -
>>> -    if (kvm_para_has_hint(KVM_HINTS_REALTIME))
>>> +    /*
>>> +     * Don't use the pvqspinlock code if no KVM_FEATURE_PV_UNHALT
>>> feature
>>> +     * support, or there is REALTIME hints or only 1 vCPU.
>>> +     */
>>> +    if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
>>> +        kvm_para_has_hint(KVM_HINTS_REALTIME) ||
>>> +        num_possible_cpus() == 1) {
>>> +        pr_info("PV spinlocks disabled\n");
>>>           return;
>>> +    }
>>>   -    /* Don't use the pvqspinlock code if there is only 1 vCPU. */
>>> -    if (num_possible_cpus() == 1)
>>> +    if (nopvspin) {
>>> +        pr_info("PV spinlocks disabled forced by \"nopvspin\"
>>> parameter.\n");
>>> +        static_branch_disable(&virt_spin_lock_key);
>> Would it make sense to bring here the other site where the key is
>> disabled (in kvm_smp_prepare_cpus())?
>
> Thanks for point out, I'll do it. Just not clear if I should do that
> in a separate patch,
> there is a history about that code:
>
> Its original place was here and then moved to kvm_smp_prepare_cpus()
> by below commit:
> 34226b6b ("KVM: X86: Fix setup the virt_spin_lock_key before static
> key get initialized")
> which fixed jump_label_init() calling late issue.
>
> Then 8990cac6 ("x86/jump_label: Initialize static branching early")
> move jump_label_init()
> early, so commit 34226b6b could be reverted.


Which is similar to what you did earlier for Xen.


>
>>
>> (and, in fact, shouldn't all of the checks that result in early return
>> above disable the key?)
>
> I think we should enable he key for
> !kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) case,
> there is lock holder preemption issue as qspinlock is fair lock,
> virt_spin_lock()
> is an optimization to that, imaging one pcpu running 10 vcpus of same
> guest
> contending a same lock.

Right. I conflated pv lock and virt_spin_lock_key, and that is wrong.

-boris


>
> For kvm_para_has_hint(KVM_HINTS_REALTIME) case, hypervisor hints there is
> no preemption and we should disable virt_spin_lock_key to use native
> qspinlock.
>
> For the UP case, we don't care virt_spin_lock_key value.
>
> For nopvspin case, we intentionally check native qspinlock code
> performance,
> compare it with PV qspinlock, etc. So virt_spin_lock() optimization
> should be disabled.
>
> Let me know if anything wrong with above understanding. Thanks
>
> Zhenzhong
>


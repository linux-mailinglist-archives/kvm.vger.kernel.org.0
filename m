Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339C3C9C5E
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 12:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfJCKcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 06:32:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59128 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbfJCKcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 06:32:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93ATQT0037217;
        Thu, 3 Oct 2019 10:30:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ir++mkQJfcEAASN1DoMDHnUr4GmG7owUrxYcR27Bluw=;
 b=fV1omv2Zf9uP6tzCN12xv2NX/kzW1yZ26H6Hw6vk0QJb9n1badh/rofP7TKda5gR9me3
 BJR9IYKq2Ip7nKL6StCFBSotta5ljLQb1csBQ+GzN6vgYOE9ZO1Tl0dYB/Y3Johe0vSm
 hY12O0lkuIh2VtIwbgQlpHvDCUtwyq8VaATGwFME5W2bMmxpCYEr/nKLmNl7cLsQhF82
 NNWkYsvCLJo6P2H3WVXvqEnixiVZfjpREpHymSt9WKV6tosP6RDHbG0c1qxNRJ9I6nbH
 cScAJ/O71byeqN61hvq0qhXOkIMKHxvmOKhOHFHXniGgeRYKtCns2kaZHOprLZt/kyh+ kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v9yfqjw50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 10:30:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93ASnou057692;
        Thu, 3 Oct 2019 10:30:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vcg63bx65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 10:30:53 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x93AUlmi013736;
        Thu, 3 Oct 2019 10:30:47 GMT
Received: from [10.191.0.240] (/10.191.0.240)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 03:30:47 -0700
Subject: Re: [PATCH v3 1/4] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
 <1569847479-13201-2-git-send-email-zhenzhong.duan@oracle.com>
 <20191002171006.GB9615@linux.intel.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <a789fb32-3830-e36b-f648-d070c742384f@oracle.com>
Date:   Thu, 3 Oct 2019 18:30:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002171006.GB9615@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910030096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910030096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/10/3 1:10, Sean Christopherson wrote:

> On Mon, Sep 30, 2019 at 08:44:36PM +0800, Zhenzhong Duan wrote:
>> There are cases where a guest tries to switch spinlocks to bare metal
>> behavior (e.g. by setting "xen_nopvspin" on XEN platform and
>> "hv_nopvspin" on HYPER_V).
>>
>> That feature is missed on KVM, add a new parameter "nopvspin" to disable
>> PV spinlocks for KVM guest.
>>
>> This new parameter is also used to replace "xen_nopvspin" and
>> "hv_nopvspin".
> This is confusing as there are no Xen or Hyper-V changes in this patch.
> Please make it clear that you're talking about future patches, e.g.:
>
>    The new 'nopvspin' parameter will also replace Xen and Hyper-V specific
>    parameters in future patches.

Will fix

>
>> The global variable pvspin isn't defined as __initdata as it's used at
>> runtime by XEN guest.
> Same comment as above regarding what this patch is doing versus what will
> be done in the future.  Arguably you should even mark it __initdata in
> this patch and deal with conflict in the Xen patch, e.g. use it only to
> set the existing xen_pvspin variable.

Will fix

>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>

......snip

>>   /**
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index e820568..a4f108d 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -842,6 +842,13 @@ void __init kvm_spinlock_init(void)
>>   	if (num_possible_cpus() == 1)
>>   		return;
>>   
>> +	if (!pvspin) {
>> +		pr_info("PV spinlocks disabled\n");
>> +		static_branch_disable(&virt_spin_lock_key);
>> +		return;
>> +	}
>> +	pr_info("PV spinlocks enabled\n");
> These prints could be confusing as KVM also disables PV spinlocks when it
> sees KVM_HINTS_REALTIME.

What about below:

pr_info("PV spinlocks disabled forced by \"nopvspin\" parameter.\n");

Or you prefer separate print for each disabling like below?

         /* Does host kernel support KVM_FEATURE_PV_UNHALT? */
         if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
                 pr_info("PV spinlocks disabled, KVM_FEATURE_PV_UNHALT feature needed.\n");
                 return;
         }

         if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
                 pr_info("PV spinlocks disabled, having non-preemption hints.\n");
                 return;
         }

         /* Don't use the pvqspinlock code if there is only 1 vCPU. */
         if (num_possible_cpus() == 1) {
                 pr_info("PV spinlocks disabled on UP.\n");
                 return;
         }
	if (!pvspin) {
		pr_info("PV spinlocks disabled forced by \"nopvspin\" parameter.\n");
		static_branch_disable(&virt_spin_lock_key);
		return;
	}
	pr_info("PV spinlocks enabled\n");

>
>> +
>>   	__pv_init_lock_hash();
>>   	pv_ops.lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
>>   	pv_ops.lock.queued_spin_unlock =
>> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
>> index 2473f10..945b510 100644
>> --- a/kernel/locking/qspinlock.c
>> +++ b/kernel/locking/qspinlock.c
>> @@ -580,4 +580,11 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>>   #include "qspinlock_paravirt.h"
>>   #include "qspinlock.c"
>>   
>> +bool pvspin = true;
> This can be __ro_after_init, or probably better __initdata and have Xen
> snapshot the value for its use case.

I will use __initdata

>
> Personal preference: I'd invert the bool and name it nopvspin to make it
> easier to connect the variable to the kernel param.

OK, will do that.  Thanks for review for all the patches.

Zhenzhong


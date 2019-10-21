Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B85DE233
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 04:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfJUCje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Oct 2019 22:39:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59066 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfJUCjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Oct 2019 22:39:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9L2Yvpa039960;
        Mon, 21 Oct 2019 02:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Psg74oKh/arjOIYb1403ZcR5N16uF/73JldehYNO1Ms=;
 b=j50en5NZUnoYy9OpeFR5V2Lp1bRrGYNkADIrQJ6jVCPLV1M0YGtsVwLbbItPVDcDAS2A
 T1XIDk8WAzNo+4rVkNSBnOtS3u3MS5KJKUyKHIl8dfUxqgyCqvHWvkmnsOwOsJs9T1rY
 3EfiCeyrSE+OcM7t9V40znAR3OB2K5uk8XT2kfiAYvZfFTE/wJjP8RTRbKxOG4PVjDfm
 LkFgvNEm/cjHSJx/Xbh67IZRrZd0UsBLjzg24Eq0inrNmfcpX20YNJzX5Wsx+IlhgWff
 Dy0Su4UOfqcBGD5+SH8AKPP7B1vHP37wEUXe3QeRKou+0loWVdYtKy/nZIfq0a6uW3oB cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqtepcg64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 02:37:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9L2XowL058690;
        Mon, 21 Oct 2019 02:37:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vrcmkxtrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 02:37:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9L2aqmf020461;
        Mon, 21 Oct 2019 02:36:58 GMT
Received: from [192.168.0.247] (/1.180.238.73)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 02:36:52 +0000
Subject: Re: [PATCH v6 3/5] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, peterz@infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>
References: <1571102367-31595-1-git-send-email-zhenzhong.duan@oracle.com>
 <1571102367-31595-4-git-send-email-zhenzhong.duan@oracle.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <4531b43b-0240-50af-36cc-547ede4363fb@oracle.com>
Date:   Mon, 21 Oct 2019 10:36:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571102367-31595-4-git-send-email-zhenzhong.duan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9416 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9416 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210021
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi vitaly

This patch is based on your suggestion on v5, appreciate your further

review:) Thanks

Zhenzhong

On 2019/10/15 9:19, Zhenzhong Duan wrote:
> There are cases where a guest tries to switch spinlocks to bare metal
> behavior (e.g. by setting "xen_nopvspin" on XEN platform and
> "hv_nopvspin" on HYPER_V).
>
> That feature is missed on KVM, add a new parameter "nopvspin" to disable
> PV spinlocks for KVM guest.
>
> The new 'nopvspin' parameter will also replace Xen and Hyper-V specific
> parameters in future patches.
>
> Define variable nopvsin as global because it will be used in future
> patches as above.
>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Will Deacon <will@kernel.org>
> ---
>   Documentation/admin-guide/kernel-parameters.txt |  5 ++++
>   arch/x86/include/asm/qspinlock.h                |  1 +
>   arch/x86/kernel/kvm.c                           | 34 ++++++++++++++++++++++---
>   kernel/locking/qspinlock.c                      |  7 +++++
>   4 files changed, 43 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index a84a83f..bd49ed2 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5334,6 +5334,11 @@
>   			as generic guest with no PV drivers. Currently support
>   			XEN HVM, KVM, HYPER_V and VMWARE guest.
>   
> +	nopvspin	[X86,KVM]
> +			Disables the qspinlock slow path using PV optimizations
> +			which allow the hypervisor to 'idle' the guest on lock
> +			contention.
> +
>   	xirc2ps_cs=	[NET,PCMCIA]
>   			Format:
>   			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
> diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
> index 444d6fd..d86ab94 100644
> --- a/arch/x86/include/asm/qspinlock.h
> +++ b/arch/x86/include/asm/qspinlock.h
> @@ -32,6 +32,7 @@ static __always_inline u32 queued_fetch_set_pending_acquire(struct qspinlock *lo
>   extern void __pv_init_lock_hash(void);
>   extern void __pv_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
>   extern void __raw_callee_save___pv_queued_spin_unlock(struct qspinlock *lock);
> +extern bool nopvspin;
>   
>   #define	queued_spin_unlock queued_spin_unlock
>   /**
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 249f14a..e9c76d8 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -825,18 +825,44 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
>    */
>   void __init kvm_spinlock_init(void)
>   {
> -	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
> -	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
> +	/*
> +	 * PV spinlocks is disabled if no host side support, then native
> +	 * qspinlock will be used. As native qspinlock is a fair lock, there is
> +	 * lock holder preemption issue using it in a guest, imaging one pCPU
> +	 * running 10 vCPUs of same guest contending same lock.
> +	 *
> +	 * virt_spin_lock() is introduced as an optimization for that scenario
> +	 * which is enabled by virt_spin_lock_key key. To use that optimization,
> +	 * virt_spin_lock_key isn't disabled here.
> +	 */
> +	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
> +		pr_info("PV spinlocks disabled, no host support.\n");
>   		return;
> +	}
>   
> +	/*
> +	 * Disable PV qspinlock and use native qspinlock when dedicated pCPUs
> +	 * are available.
> +	 */
>   	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
> +		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints.\n");
> +		static_branch_disable(&virt_spin_lock_key);
> +		return;
> +	}
> +
> +	if (num_possible_cpus() == 1) {
> +		pr_info("PV spinlocks disabled, single CPU.\n");
>   		static_branch_disable(&virt_spin_lock_key);
>   		return;
>   	}
>   
> -	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
> -	if (num_possible_cpus() == 1)
> +	if (nopvspin) {
> +		pr_info("PV spinlocks disabled, forced by \"nopvspin\" parameter.\n");
> +		static_branch_disable(&virt_spin_lock_key);
>   		return;
> +	}
> +
> +	pr_info("PV spinlocks enabled\n");
>   
>   	__pv_init_lock_hash();
>   	pv_ops.lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index 2473f10..75193d6 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -580,4 +580,11 @@ void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>   #include "qspinlock_paravirt.h"
>   #include "qspinlock.c"
>   
> +bool nopvspin __initdata;
> +static __init int parse_nopvspin(char *arg)
> +{
> +	nopvspin = true;
> +	return 0;
> +}
> +early_param("nopvspin", parse_nopvspin);
>   #endif

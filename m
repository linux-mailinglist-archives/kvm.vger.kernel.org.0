Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1746D596E
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 03:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbfJNBy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 21:54:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38246 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbfJNBy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 21:54:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9E1ndFm173147;
        Mon, 14 Oct 2019 01:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=j5D+EfTCH3XEexfVGOeGGMESi7OPI6/NGgwOQMZ9O/0=;
 b=HOG78u7pcBus9hSBE6n90TV7D0yGvrjDG8kc8ySemUiMqgW0JzFTMTFB6Fvp9uMbp3uL
 ZMI4lQoJh1mbewqOlC9X0sr/8o63mrFTmqx+VLj0j8vsJGI5IY8T3Lx/wuWFL1VBySLi
 hLIkpT7emwb1+aYtlhbt3wbuwcZSFug+qxqdsdquqTqoqzINnqQz3vPFytlx1FjNZlKl
 bYOlXJpfqSgVVem3xxS/96536l562aGZ5wO3Igr23i+RfwYH4l2rtslv1ihJ8+Oe5+IN
 kXIQrVkkUkuHVwaHB3Z/r4b/0wYTNgLZQbmLHgANytdLgWyaGZoSRt1U7CO6Rq4MBT3s pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vk6sq5h0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 01:53:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9E1j6Vi017104;
        Mon, 14 Oct 2019 01:53:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vkry5187c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 01:53:11 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9E1r5Jt015486;
        Mon, 14 Oct 2019 01:53:06 GMT
Received: from [10.191.5.73] (/10.191.5.73)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 01:53:05 +0000
Subject: Re: [PATCH v5 3/5] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, peterz@infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>
References: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
 <1570439071-9814-4-git-send-email-zhenzhong.duan@oracle.com>
 <87o8yl587f.fsf@vitty.brq.redhat.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <4e1ef1d3-527b-bb70-5536-d9daeb50b7c7@oracle.com>
Date:   Mon, 14 Oct 2019 09:52:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87o8yl587f.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9409 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9409 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140016
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/13 17:02, Vitaly Kuznetsov wrote:
> Zhenzhong Duan <zhenzhong.duan@oracle.com> writes:
...snip
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index ef836d6..6e14bd4 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -825,18 +825,31 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
>    */
>   void __init kvm_spinlock_init(void)
>   {
> -	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
> -	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
> +	/*
> +	 * Disable PV qspinlocks if host kernel doesn't support
> +	 * KVM_FEATURE_PV_UNHALT feature or there is only 1 vCPU.
> +	 * virt_spin_lock_key is enabled to avoid lock holder
> +	 * preemption issue.
> +	 */
> +	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
> +	    num_possible_cpus() == 1) {
> +		pr_info("PV spinlocks disabled\n");
> Why don't we need static_branch_disable(&virt_spin_lock_key) here?

Thanks for review.

I have a brief explanation in above comment area.

Boris also raised the same question in v4 and see my detailed explanation

in https://lkml.org/lkml/2019/10/6/39

>
> Also, as you're printing the exact reason for PV spinlocks disablement
> in other cases, I'd suggest separating "no host support" and "single
> CPU" cases.

Will do after reaching a consensus on your first question.

>
>>   		return;
>> +	}
>>   
>>   	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>> +		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints.\n");
>>   		static_branch_disable(&virt_spin_lock_key);
>>   		return;
>>   	}
>>   
>> -	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
>> -	if (num_possible_cpus() == 1)
>> +	if (nopvspin) {
>> +		pr_info("PV spinlocks disabled forced by \"nopvspin\" parameter.\n");
> Nit: to make it sound better a comma is missing between 'disabled' and
> 'forced', or
>
> "PV spinlocks forcefully disabled by ..." if you prefer.

Will do.

Zhenzhong



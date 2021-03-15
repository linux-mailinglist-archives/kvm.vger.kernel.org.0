Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E6833AA89
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 05:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCOEks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 00:40:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13952 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhCOEkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 00:40:41 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DzNwR0YzyzrWX6;
        Mon, 15 Mar 2021 12:38:47 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 12:40:34 +0800
Subject: Re: [PATCH] KVM: clean up the unused argument
To:     <lihaiwei.kernel@gmail.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
References: <20210313051032.4171-1-lihaiwei.kernel@gmail.com>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <4b51bbfd-66f6-1593-3718-9789f9179a2f@huawei.com>
Date:   Mon, 15 Mar 2021 12:40:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210313051032.4171-1-lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


This looks OK. The use of vcpu argument is removed in commit d383b3146d80 (KVM: x86: Fix NULL dereference at kvm_msr_ignored_check())

Reviewed-by: Keqian Zhu <zhukeqian1@huawei.com>

On 2021/3/13 13:10, lihaiwei.kernel@gmail.com wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> kvm_msr_ignored_check function never uses vcpu argument. Clean up the
> function and invokers.
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 012d5df..27e9ee8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -271,8 +271,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>   * When called, it means the previous get/set msr reached an invalid msr.
>   * Return true if we want to ignore/silent this failed msr access.
>   */
> -static bool kvm_msr_ignored_check(struct kvm_vcpu *vcpu, u32 msr,
> -				  u64 data, bool write)
> +static bool kvm_msr_ignored_check(u32 msr, u64 data, bool write)
>  {
>  	const char *op = write ? "wrmsr" : "rdmsr";
>  
> @@ -1447,7 +1446,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>  	if (r == KVM_MSR_RET_INVALID) {
>  		/* Unconditionally clear the output for simplicity */
>  		*data = 0;
> -		if (kvm_msr_ignored_check(vcpu, index, 0, false))
> +		if (kvm_msr_ignored_check(index, 0, false))
>  			r = 0;
>  	}
>  
> @@ -1613,7 +1612,7 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
>  	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
>  
>  	if (ret == KVM_MSR_RET_INVALID)
> -		if (kvm_msr_ignored_check(vcpu, index, data, true))
> +		if (kvm_msr_ignored_check(index, data, true))
>  			ret = 0;
>  
>  	return ret;
> @@ -1651,7 +1650,7 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
>  	if (ret == KVM_MSR_RET_INVALID) {
>  		/* Unconditionally clear *data for simplicity */
>  		*data = 0;
> -		if (kvm_msr_ignored_check(vcpu, index, 0, false))
> +		if (kvm_msr_ignored_check(index, 0, false))
>  			ret = 0;
>  	}
>  
> 

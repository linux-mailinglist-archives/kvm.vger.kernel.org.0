Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A953B2463CF
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 11:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgHQJxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 05:53:12 -0400
Received: from foss.arm.com ([217.140.110.172]:52352 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgHQJxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 05:53:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7054031B;
        Mon, 17 Aug 2020 02:53:11 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EC453F66B;
        Mon, 17 Aug 2020 02:53:09 -0700 (PDT)
Subject: Re: [PATCH 3/3] KVM: arm64: Use kvm_write_guest_lock when init stolen
 time
To:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com
References: <20200817033729.10848-1-zhukeqian1@huawei.com>
 <20200817033729.10848-4-zhukeqian1@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <41523036-7492-d554-e256-32f42959684d@arm.com>
Date:   Mon, 17 Aug 2020 10:53:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817033729.10848-4-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/2020 04:37, Keqian Zhu wrote:
> There is a lock version kvm_write_guest. Use it to simplify code.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>   arch/arm64/kvm/pvtime.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index f7b52ce..2b24e7f 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -55,7 +55,6 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>   	struct pvclock_vcpu_stolen_time init_values = {};
>   	struct kvm *kvm = vcpu->kvm;
>   	u64 base = vcpu->arch.steal.base;
> -	int idx;
>   
>   	if (base == GPA_INVALID)
>   		return base;
> @@ -66,10 +65,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>   	 */
>   	vcpu->arch.steal.steal = 0;
>   	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> -
> -	idx = srcu_read_lock(&kvm->srcu);
> -	kvm_write_guest(kvm, base, &init_values, sizeof(init_values));
> -	srcu_read_unlock(&kvm->srcu, idx);
> +	kvm_write_guest_lock(kvm, base, &init_values, sizeof(init_values));
>   
>   	return base;
>   }
> 


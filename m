Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C59E421A5E
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhJDW63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230380AbhJDW63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 18:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 757C1611F0;
        Mon,  4 Oct 2021 22:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633388199;
        bh=tzBIyPVlSHAw2IkvnM7EOjKGqqimECd3eyuTeYOjdss=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=N7VqJtQOmthEo2Cg8WvR8w/xTRDwrhgNcjzMk+Xa3U13MqAmBQDHZNs+/nhXeD1hC
         MmBeH/GhNdOpaGRWkUZuE6ghkcpvLBDHEH2aWAUgRB+p2faVlUY93Ny7h+Wgq0+iUG
         Svjv1jKjIB0PnCiDfzHLziHvuK6LjfoskOr4LTQZE6SqElpZGgZhE54fTIbo7DPbFw
         hKUly5ZOybf8+yjmJN8BHK4oZVWEmdmD1TStYSVx2vn63sxz701c2f71QxTeFyItvA
         1vJ8xgTm+DLEBI4QjO0OwaaVNSjKqGuGhQ+iPtVM57DR3qM7gzzkkVbRx8Gw1t3WMl
         7R8HCwvEypZ6A==
Message-ID: <fe38bc2e-64a5-e770-a86a-b2b70eef4fb4@kernel.org>
Date:   Mon, 4 Oct 2021 15:56:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: directly call wbinvd for local cpu when emulate
 wbinvd
Content-Language: en-US
To:     Li RongQing <lirongqing@baidu.com>, kvm@vger.kernel.org,
        wanpengli@tencent.com, jan.kiszka@siemens.com, x86@kernel.org
References: <1632821269-52969-1-git-send-email-lirongqing@baidu.com>
From:   Andy Lutomirski <luto@kernel.org>
In-Reply-To: <1632821269-52969-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/28/21 02:27, Li RongQing wrote:
> directly call wbinvd for local pCPU, which can avoid ipi for
> itself and calling of get_cpu/on_each_cpu_mask/etc.
> 

Why is this an improvement?  Trading get_cpu() vs preempt_disable() 
seems like a negligible difference, and it makes the code more complicated.

> In fact, This change reverts commit 2eec73437487 ("KVM: x86: Avoid
> issuing wbinvd twice"), since smp_call_function_many is skiping the
> local cpu (as description of c2162e13d6e2f), wbinvd is not issued
> twice
> 
> and reverts commit c2162e13d6e2f ("KVM: X86: Fix missing local pCPU
> when executing wbinvd on all dirty pCPUs") too, which fixed the
> previous patch, when revert previous patch, it is not needed.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>   arch/x86/kvm/x86.c |   13 ++++++-------
>   1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 28ef141..ee65941 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6984,15 +6984,14 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
>   		return X86EMUL_CONTINUE;
>   
>   	if (static_call(kvm_x86_has_wbinvd_exit)()) {
> -		int cpu = get_cpu();
> -
> -		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
> -		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
> +		preempt_disable();
> +		smp_call_function_many(vcpu->arch.wbinvd_dirty_mask,
>   				wbinvd_ipi, NULL, 1);
> -		put_cpu();
> +		preempt_enable();
>   		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
> -	} else
> -		wbinvd();
> +	}
> +
> +	wbinvd();
>   	return X86EMUL_CONTINUE;
>   }
>   
> 


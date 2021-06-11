Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A153A4615
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 18:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhFKQFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 12:05:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231945AbhFKQEH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 12:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623427328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a2KwIPddisFVYHeXNt8ygyLHQvYMBK3BgWyY84hKVAk=;
        b=OV/5hF0S8wEkSoZgNp7DWqbrcusBWY07pyx4TEQACjey8T6la+vNYF3hALALRsg2vuKoU2
        BBeIDXDPQoujA5L5fRlPcMvoplE26NpqjCaG0DdIfFkyChi1l89W7niofNuOfeBRLQEBwC
        SvWTrqOOCkGyNZM8AhBnCRjxdsezTms=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-x8A36TYxMU-EGDW6UQUpJg-1; Fri, 11 Jun 2021 12:02:07 -0400
X-MC-Unique: x8A36TYxMU-EGDW6UQUpJg-1
Received: by mail-wr1-f71.google.com with SMTP id k11-20020adfe3cb0000b0290115c29d165cso2829747wrm.14
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 09:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a2KwIPddisFVYHeXNt8ygyLHQvYMBK3BgWyY84hKVAk=;
        b=Zl5/T8gvG23z6e0uMlzUGgJmJS6W1rMrAz4V4mNvDvNcO8X0PVeL9x4hBRlytzwMry
         lvd8leOzkI/i4uao+VadQOnb2359A80IRnrgHiDBBuRXRqhS239cKP8stwZ30gNrT4oz
         SuzQTZZOc1beytnlC5fwX+C9+Pkr1YS4AniLpkKp7gtVs0g/DAYUBnyjKZwj7Ph31Ug7
         2mLhw+rYqOq6O9Dlf4Zu0zSYxozb8UBbnCYMgVHo5GnWfpC8eJkeVgP3XISYiDD+iAX1
         IE0aemtM+qIdSW/4jB9OywGD7R0uRT7P/+rk+XEvo2C3OBNS6zDK/we6yL4Kk6k623qu
         0TLA==
X-Gm-Message-State: AOAM530wXIirGi6bA244pOmeiFhws75f927ySLPvZCidcP9O6FqxuHf+
        qn7LPAJo1yMCwAlYsGN0/wcRE9cDh11wKuCSz0268DHxG9jlaGUjabeJWX5/vV6mvUTgCN3H1L1
        aBHqkgmPnuXR5
X-Received: by 2002:a5d:538c:: with SMTP id d12mr4810105wrv.116.1623427326443;
        Fri, 11 Jun 2021 09:02:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFemOdNpsRwLklC2J+14zxbVs+DThyFO0yN6oO6EfDArppp5b7ocf2oKGjuXx8mr3JFXgSwQ==
X-Received: by 2002:a5d:538c:: with SMTP id d12mr4810075wrv.116.1623427326193;
        Fri, 11 Jun 2021 09:02:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m21sm12321154wms.42.2021.06.11.09.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 09:02:05 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Calculate and check "full" mmu_role for
 nested MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210610220026.1364486-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <415e5332-f453-503c-7475-85328efe6de4@redhat.com>
Date:   Fri, 11 Jun 2021 18:02:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210610220026.1364486-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/21 00:00, Sean Christopherson wrote:
> Calculate and check the full mmu_role when initializing the MMU context
> for the nested MMU, where "full" means the bits and pieces of the role
> that aren't handled by kvm_calc_mmu_role_common().  While the nested MMU
> isn't used for shadow paging, things like the number of levels in the
> guest's page tables are surprisingly important when walking the guest
> page tables.  Failure to reinitialize the nested MMU context if L2's
> paging mode changes can result in unexpected and/or missed page faults,
> and likely other explosions.
> 
> E.g. if an L1 vCPU is running both a 32-bit PAE L2 and a 64-bit L2, the
> "common" role calculation will yield the same role for both L2s.  If the
> 64-bit L2 is run after the 32-bit PAE L2, L0 will fail to reinitialize
> the nested MMU context, ultimately resulting in a bad walk of L2's page
> tables as the MMU will still have a guest root_level of PT32E_ROOT_LEVEL.
> 
>    WARNING: CPU: 4 PID: 167334 at arch/x86/kvm/vmx/vmx.c:3075 ept_save_pdptrs+0x15/0xe0 [kvm_intel]
>    Modules linked in: kvm_intel]
>    CPU: 4 PID: 167334 Comm: CPU 3/KVM Not tainted 5.13.0-rc1-d849817d5673-reqs #185
>    Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
>    RIP: 0010:ept_save_pdptrs+0x15/0xe0 [kvm_intel]
>    Code: <0f> 0b c3 f6 87 d8 02 00f
>    RSP: 0018:ffffbba702dbba00 EFLAGS: 00010202
>    RAX: 0000000000000011 RBX: 0000000000000002 RCX: ffffffff810a2c08
>    RDX: ffff91d7bc30acc0 RSI: 0000000000000011 RDI: ffff91d7bc30a600
>    RBP: ffff91d7bc30a600 R08: 0000000000000010 R09: 0000000000000007
>    R10: 0000000000000000 R11: 0000000000000000 R12: ffff91d7bc30a600
>    R13: ffff91d7bc30acc0 R14: ffff91d67c123460 R15: 0000000115d7e005
>    FS:  00007fe8e9ffb700(0000) GS:ffff91d90fb00000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 0000000000000000 CR3: 000000029f15a001 CR4: 00000000001726e0
>    Call Trace:
>     kvm_pdptr_read+0x3a/0x40 [kvm]
>     paging64_walk_addr_generic+0x327/0x6a0 [kvm]
>     paging64_gva_to_gpa_nested+0x3f/0xb0 [kvm]
>     kvm_fetch_guest_virt+0x4c/0xb0 [kvm]
>     __do_insn_fetch_bytes+0x11a/0x1f0 [kvm]
>     x86_decode_insn+0x787/0x1490 [kvm]
>     x86_decode_emulated_instruction+0x58/0x1e0 [kvm]
>     x86_emulate_instruction+0x122/0x4f0 [kvm]
>     vmx_handle_exit+0x120/0x660 [kvm_intel]
>     kvm_arch_vcpu_ioctl_run+0xe25/0x1cb0 [kvm]
>     kvm_vcpu_ioctl+0x211/0x5a0 [kvm]
>     __x64_sys_ioctl+0x83/0xb0
>     do_syscall_64+0x40/0xb0
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: bf627a928837 ("x86/kvm/mmu: check if MMU reconfiguration is needed in init_kvm_nested_mmu()")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++++++++-
>   1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0144c40d09c7..8d5876dfc6b7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4739,9 +4739,33 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
>   	context->inject_page_fault = kvm_inject_page_fault;
>   }
>   
> +static union kvm_mmu_role kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu)
> +{
> +	union kvm_mmu_role role = kvm_calc_shadow_root_page_role_common(vcpu, false);
> +
> +	/*
> +	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
> +	 * shadow pages of their own and so "direct" has no meaning.   Set it
> +	 * to "true" to try to detect bogus usage of the nested MMU.
> +	 */
> +	role.base.direct = true;
> +
> +	if (!is_paging(vcpu))
> +		role.base.level = 0;
> +	else if (is_long_mode(vcpu))
> +		role.base.level = is_la57_mode(vcpu) ? PT64_ROOT_5LEVEL :
> +						       PT64_ROOT_4LEVEL;
> +	else if (is_pae(vcpu))
> +		role.base.level = PT32E_ROOT_LEVEL;
> +	else
> +		role.base.level = PT32_ROOT_LEVEL;
> +
> +	return role;
> +}
> +
>   static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
>   {
> -	union kvm_mmu_role new_role = kvm_calc_mmu_role_common(vcpu, false);
> +	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu);
>   	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
>   
>   	if (new_role.as_u64 == g_context->mmu_role.as_u64)
> 

Queued, thanks.

Paolo


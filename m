Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2178721860B
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 13:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgGHLZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 07:25:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728592AbgGHLZM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 07:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594207510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ouHANG20USBE2PCP33rRejZoUHD5MZlrUjWu6D42Tb4=;
        b=XBALaUavm5Fdb9fJDdMbLE3Zbm30CGmwTDAqJ6Qpe9lGOLn0OwQReKZvtSO9pe9cqQzVg4
        ko9rF06hwrVFufoJ11gPpa9H4yIAHjHZDGZ5Pme56Jyl+nlFGunVGTLZnLBsFGDPevB4qp
        OLkX+drWFSvkc7nIrtiBXxFl6rYYEbk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-dgvZUbwwMjiP_oWYUw6o8Q-1; Wed, 08 Jul 2020 07:25:09 -0400
X-MC-Unique: dgvZUbwwMjiP_oWYUw6o8Q-1
Received: by mail-wm1-f71.google.com with SMTP id s134so2564223wme.6
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 04:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ouHANG20USBE2PCP33rRejZoUHD5MZlrUjWu6D42Tb4=;
        b=PDV2EP3lX9XOFIJ2w45AVrdUrdKkB0GUbYeGiGtYIXf4HNv0vJDSAgQSN8tdZecIOp
         tiXp1Ijfk6wLybj6bppIIEat4mLCxtghHm8rbKSDGWU26kx3bDTzl+71SIt7ZthH4oUB
         Yqgqad2J6L2bSCzV992cX0N3ocqNVU0JOoundEbUS7i4SoLxgxGooLBW7NwSN2jZNKVN
         dVypaiuspoTDXkTw8sfYyIxsmMDC1kr3Wyt6apt2LeBUMgUwDLmrtjd2Q5xW8x0RWibs
         P3WGffQ+M6hbMTKdEjXjCro0e6NrIsr3PDnKlqdhE76+AdXCqEcjabVs13yLWUqDRfaz
         MUZQ==
X-Gm-Message-State: AOAM533lC/ID/nsMBd+Y4/RDm5+1FhJ/xliEsr5Q7U3lSKo1kMV5JyY1
        p6iDzbgJb5lM2eYGI8jsnhAhhj8ZiLWUa8OnJCoPNCL5m22B/H995+oGELyOk0PprMeJ42W9f+U
        rdIsEHMmaRygM
X-Received: by 2002:adf:91e1:: with SMTP id 88mr51187466wri.89.1594207508242;
        Wed, 08 Jul 2020 04:25:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXgz9j1sndzaJgOQXlSN4IivMaE3Sx1qi84w6Se+wj028onpholiatocyX5gSUkoL/o3ht2w==
X-Received: by 2002:adf:91e1:: with SMTP id 88mr51187436wri.89.1594207507992;
        Wed, 08 Jul 2020 04:25:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id m9sm5433915wml.45.2020.07.08.04.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:25:07 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] KVM: nSVM: split kvm_init_shadow_npt_mmu() from
 kvm_init_shadow_mmu()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
References: <20200708093611.1453618-1-vkuznets@redhat.com>
 <20200708093611.1453618-2-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <42d6eefa-2875-ff4d-c972-71fe405aec98@redhat.com>
Date:   Wed, 8 Jul 2020 13:25:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708093611.1453618-2-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 11:36, Vitaly Kuznetsov wrote:
> @@ -4973,7 +4969,28 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer)
>  	context->mmu_role.as_u64 = new_role.as_u64;
>  	reset_shadow_zero_bits_mask(vcpu, context);
>  }
> -EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
> +
> +static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer)
> +{
> +	struct kvm_mmu *context = vcpu->arch.mmu;
> +	union kvm_mmu_role new_role =
> +		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
> +
> +	if (new_role.as_u64 != context->mmu_role.as_u64)
> +		shadow_mmu_init_context(vcpu, cr0, cr4, efer, new_role);
> +}
> +
> +void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
> +			     gpa_t nested_cr3)
> +{
> +	struct kvm_mmu *context = vcpu->arch.mmu;
> +	union kvm_mmu_role new_role =
> +		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
> +
> +	if (new_role.as_u64 != context->mmu_role.as_u64)
> +		shadow_mmu_init_context(vcpu, cr0, cr4, efer, new_role);
> +}
> +EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
>  
>  static union kvm_mmu_role

As a follow up, the assignments to context should stop using
vcpu->arch.mmu in favor of root_mmu/guest_mmu.

Paolo


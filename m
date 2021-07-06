Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624033BD861
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhGFOjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:39:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232481AbhGFOjg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0dw2C24IYhsTlppTrcEqtz5YCldeKMDuVEIPmvao1so=;
        b=AsHxm1d1VplMxjrOkk0ac15pL02nZ2CTpqodoVHJbG0okngO9wSJwe/vORiz9C0RFXbsps
        W9AmaUCx73QmnRuAv06n8p0DHtUgp2J/iYYXE/cTCPn0jvmOQ2cU652D4C46N/sF0bk6lS
        qulcKJtxWAb/OKPDNoISjT0zRv6U22o=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-XIWVt5BCP-qz3TR16vqaQQ-1; Tue, 06 Jul 2021 09:44:25 -0400
X-MC-Unique: XIWVt5BCP-qz3TR16vqaQQ-1
Received: by mail-ed1-f72.google.com with SMTP id p23-20020aa7cc970000b02903948bc39fd5so10825926edt.13
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0dw2C24IYhsTlppTrcEqtz5YCldeKMDuVEIPmvao1so=;
        b=K/xyBvS1+ibiCrG2r9jbK9B1YUL/RsrLrHTot9oWoZfNS1taP5eaK2ZOtDPJdZGpIt
         65kVWhQalhhqP+UZ9baRuEL3ktJPBjmVIlNbDDKmCTu5EYJbN+yPv+R+Nb5myT8Lbaf8
         vTtVhKjZYXvPpEN4aPdbOPM68ZXIWTHV6R6elPQrjbuHK839zSXdA1BoTjZDm0hsI3bQ
         rKf7bpk4ThXNPslY5E+KrbY4M29+lVuhQM6xgrFXvibbinTBR38a6Dmhkk7VFiUYUGV7
         /3Yxsz4AG8K/maSnh3EUSMQByd5xqEok0Jez3nNxvCpovMYdv7jA41Yc70pQu76kFoIO
         evcA==
X-Gm-Message-State: AOAM530PhTohvrtC35RvGIsqBmmO9X03t7QNGSvFcHhujH2EDQmIO6M6
        uP/6kCFvT6sUcM9lR5EsPxAxxtt5JIUGoRgHECfAPx0cLkSU6seD69pV22PN7gz1oE1LlhU2r5t
        Lh7JkWktXeUcu
X-Received: by 2002:a17:907:9491:: with SMTP id dm17mr16092040ejc.520.1625579064816;
        Tue, 06 Jul 2021 06:44:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9RrhrIXK4HIIR1Pibe4/In21DTRjgbvaA8upkBqLZuBNsIBTFNx/Eyp5gadwqw3D0JpIbQA==
X-Received: by 2002:a17:907:9491:: with SMTP id dm17mr16092007ejc.520.1625579064580;
        Tue, 06 Jul 2021 06:44:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p8sm1167072eds.15.2021.07.06.06.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:44:24 -0700 (PDT)
Subject: Re: [RFC PATCH v2 16/69] KVM: x86/mmu: Zap only leaf SPTEs for
 deleted/moved memslot by default
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <78d02fee3a21741cc26f6b6b2fba258cd52f2c3c.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3ef7f4e7-cfda-98fe-dd3e-1b084ef86bd4@redhat.com>
Date:   Tue, 6 Jul 2021 15:44:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <78d02fee3a21741cc26f6b6b2fba258cd52f2c3c.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Zap only leaf SPTEs when deleting/moving a memslot by default, and add a
> module param to allow reverting to the old behavior of zapping all SPTEs
> at all levels and memslots when any memslot is updated.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++++++++-
>   1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8d5876dfc6b7..5b8a640f8042 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -85,6 +85,9 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
>   static bool __read_mostly force_flush_and_sync_on_reuse;
>   module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
>   
> +static bool __read_mostly memslot_update_zap_all;
> +module_param(memslot_update_zap_all, bool, 0444);
> +
>   /*
>    * When setting this variable to true it enables Two-Dimensional-Paging
>    * where the hardware walks 2 page tables:
> @@ -5480,11 +5483,27 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
>   	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
>   }
>   
> +static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> +{
> +	/*
> +	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> +	 * case scenario we'll have unused shadow pages lying around until they
> +	 * are recycled due to age or when the VM is destroyed.
> +	 */
> +	write_lock(&kvm->mmu_lock);
> +	slot_handle_level(kvm, slot, kvm_zap_rmapp, PG_LEVEL_4K,
> +			  KVM_MAX_HUGEPAGE_LEVEL, true);
> +	write_unlock(&kvm->mmu_lock);
> +}
> +
>   static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>   			struct kvm_memory_slot *slot,
>   			struct kvm_page_track_notifier_node *node)
>   {
> -	kvm_mmu_zap_all_fast(kvm);
> +	if (memslot_update_zap_all)
> +		kvm_mmu_zap_all_fast(kvm);
> +	else
> +		kvm_mmu_zap_memslot(kvm, slot);
>   }
>   
>   void kvm_mmu_init_vm(struct kvm *kvm)
> 

This is the old patch that broke VFIO for some unknown reason.  The 
commit message should at least say why memslot_update_zap_all is not 
true by default.  Also, IIUC the bug still there with NX hugepage splits 
disabled, but what if the TDP MMU is enabled?

Paolo


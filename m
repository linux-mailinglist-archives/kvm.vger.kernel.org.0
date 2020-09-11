Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25B32665E5
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgIKRQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:16:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32076 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726228AbgIKRQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 13:16:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599844593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZIYsyXJ8ywDIaj8FeKR2rSXn6BX0Y2iuA9bZ+7HRd1I=;
        b=Iz1ej4fSbw9kcyzNEYXT1DqJ9rultQcPra7tiDfj7lZy5XgbJD8uhTKgaTPbXv77z9/lLg
        NX56r1BfUupemTzwdLBsqLQBvdZVGDc1RAcZjEvQvBqtHWp3WHO1LbETIwpkiMnGm8plnx
        BvgcyhwGR+9VsI0lz5mkjarGUXDwkIk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381--yYw5pcfNmi2H7U9N9NYCQ-1; Fri, 11 Sep 2020 13:16:30 -0400
X-MC-Unique: -yYw5pcfNmi2H7U9N9NYCQ-1
Received: by mail-wr1-f71.google.com with SMTP id b7so3721876wrn.6
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 10:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZIYsyXJ8ywDIaj8FeKR2rSXn6BX0Y2iuA9bZ+7HRd1I=;
        b=UGHA+ZEC9xtnFcGP39s+kOcDDvLic8IKrcbSnXjN2c+g8Sj5ujuuHs8wzcAMotM9ME
         PYHfcvyOpyyT5D7V2R6W6t0BSIF0mtVZU+fkeaMt0Z5LPJgQQtwXDVM1E2ieUrkZVVuy
         Rr0dk/k5ic7TcgF2wanybfDh/axcuXfExLgY7kWLPG/WEmd++dhxFib1v2/O1GoVV4AX
         UsiCRNpmjjnho+3nOLcW+wP+oTPCRYAYzJh5wAcJsOoGHp5ai+48NFh+Wo5q4miGlQQU
         l02FyeCzIDyp5QC4HDjW2Ix4IXI9C8qufTEiY5qdWRhHUx0FqY/nLU8iERtzLZ9nGOvL
         KU9Q==
X-Gm-Message-State: AOAM533TnUspAocBu0brYNt+0nIpGFiazljEgSRn4vq7Xq7qkhJ6r/WA
        dX4L5T3oCNhpRg8SMSjPodrx1VInx6/KS6OQdFR14+XOL4qfQ7OrpDF1U9qjNROmX4LEe8YZxNY
        WXpQ6xLwNfwma
X-Received: by 2002:adf:f382:: with SMTP id m2mr2876490wro.327.1599844589610;
        Fri, 11 Sep 2020 10:16:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLDVAzC6EF7s8wacyh/9QgVLvue/fSpLMye6yCXQhCyCcxkQfGHVkuy/JjDoAtwvRAvvpmuw==
X-Received: by 2002:adf:f382:: with SMTP id m2mr2876470wro.327.1599844589410;
        Fri, 11 Sep 2020 10:16:29 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v6sm5562089wrt.90.2020.09.11.10.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 10:16:28 -0700 (PDT)
Subject: Re: [PATCH V2] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <87y2ltx6gl.fsf@vitty.brq.redhat.com>
 <20200902135421.31158-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35d079d4-6cb8-b2d0-a4d4-7be92b30a1ea@redhat.com>
Date:   Fri, 11 Sep 2020 19:16:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200902135421.31158-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/20 15:54, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> When kvm_mmu_get_page() gets a page with unsynced children, the spt
> pagetable is unsynchronized with the guest pagetable. But the
> guest might not issue a "flush" operation on it when the pagetable
> entry is changed from zero or other cases. The hypervisor has the 
> responsibility to synchronize the pagetables.
> 
> The linux kernel behaves as above for many years, But
> 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
> inadvertently included a line of code to change it without giving any
> reason in the changelog. It is clear that the commit's intention was to
> change KVM_REQ_TLB_FLUSH -> KVM_REQ_TLB_FLUSH_CURRENT, so we don't
> unneedlesly flush other contexts but one of the hunks changed
> nearby KVM_REQ_MMU_SYNC instead.
> 
> The this patch changes it back.
> 
> Link: https://lore.kernel.org/lkml/20200320212833.3507-26-sean.j.christopherson@intel.com/
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from v1:
> 	update patch description
> 
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4e03841f053d..9a93de921f2b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2468,7 +2468,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  		}
>  
>  		if (sp->unsync_children)
> -			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
>  
>  		__clear_sp_write_flooding_count(sp);
>  
> 

Queued, thanks.

Paolo


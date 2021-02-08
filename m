Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A07F313118
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhBHLkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:40:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233365AbhBHLif (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 06:38:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612784226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FRVdxrImUiPLKR5+ep3bKLlsb+cGXPiY/H7oj/ZApPg=;
        b=LOazIzJgzmLvAvsAmIMuut8hm8rvmQf4PnrH3xyXdZHjKUbMYhU3FSkXWHIcuezoUp2V0h
        VQfWJqiPRhn0R39aEe9Q+z/7VoHmjl8xEKGTOUjvWTIhot/hsmbGvz599AI6fB9chMZRZn
        G4RcwxD8cUCJGwTqKmZWj6tzochdAF0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-x41pDr2ZPXu96HSD6TySmQ-1; Mon, 08 Feb 2021 06:37:05 -0500
X-MC-Unique: x41pDr2ZPXu96HSD6TySmQ-1
Received: by mail-wr1-f70.google.com with SMTP id f5so2671385wro.7
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 03:37:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FRVdxrImUiPLKR5+ep3bKLlsb+cGXPiY/H7oj/ZApPg=;
        b=MIpZtqL+GbGhgDrX3JVw4Fueh4hs9+VrpA8EuLwhgxfRRFArSIl9YsuckDnD2X+gIs
         DTqFQHW7tCDkcVCYrekApgkyJWmUvKbBzeu1LKtft0kiD6eP3/XxA2p10MT7z0F3XUaA
         wcC8S3O1USaLh6+ICnyadZjJDNoQTwwCXRW2+FA07zBwSCC+imK6/EDx/dBrNm/UFZSn
         QzryBSBcvDAib1x0K/sODW3xFVrDivK9EBx2fFB+O20IApyvKs132OGZ9lGYB+147vp2
         vxNP3TwFqT02AzEOIXIiTmxeJduUsON/uvJYj/5Y4afB/eF1EsjFJCDNy6X0dpfk1Nf9
         dArA==
X-Gm-Message-State: AOAM532J5hmgL9ZQvDgSVzCiMMlqho/FouDpYjb6EXbRyey7Qbfm3gBJ
        hNAS09YvgWXezgXLSlzTxMf4smTBcbOMzwxJUOtXklK5XSr5/uvwoi2umaM/wNCch9IDAOqExXw
        S4YbSbCIsRioY
X-Received: by 2002:a5d:4e4c:: with SMTP id r12mr19404678wrt.354.1612784224008;
        Mon, 08 Feb 2021 03:37:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx13bYpO/sf/MU4H+HI0kgp3YEGzTx3AvtfowcY26z5cNnVUSFmv+/6pL66lFcdvURdeKXsxg==
X-Received: by 2002:a5d:4e4c:: with SMTP id r12mr19404650wrt.354.1612784223796;
        Mon, 08 Feb 2021 03:37:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id t7sm13799049wrv.75.2021.02.08.03.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 03:37:02 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86/MMU: Do not check unsync status for root SP.
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
References: <20210207122254.23056-1-yu.c.zhang@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <671ae214-22b9-1d89-75cb-0c6da5230988@redhat.com>
Date:   Mon, 8 Feb 2021 12:36:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210207122254.23056-1-yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/21 13:22, Yu Zhang wrote:
> In shadow page table, only leaf SPs may be marked as unsync.
> And for non-leaf SPs, we use unsync_children to keep the number
> of the unsynced children. In kvm_mmu_sync_root(), sp->unsync
> shall always be zero for the root SP, , hence no need to check
> it. Instead, a warning inside mmu_sync_children() is added, in
> case someone incorrectly used it.
> 
> Also, clarify the mmu_need_write_protect(), by moving the warning
> into kvm_unsync_page().
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

This should really be more of a Co-developed-by, and there are a couple 
adjustments that could be made in the commit message.  I've queued the 
patch and I'll fix it up later.

Paolo

> ---
> Changes in V2:
> - warnings added based on Sean's suggestion.
> 
>   arch/x86/kvm/mmu/mmu.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 86af582..c4797a00cc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1995,6 +1995,12 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
>   	LIST_HEAD(invalid_list);
>   	bool flush = false;
>   
> +	/*
> +	 * Only 4k SPTEs can directly be made unsync, the parent pages
> +	 * should never be unsyc'd.
> +	 */
> +	WARN_ON_ONCE(sp->unsync);
> +
>   	while (mmu_unsync_walk(parent, &pages)) {
>   		bool protected = false;
>   
> @@ -2502,6 +2508,8 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
>   
>   static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>   {
> +	WARN_ON(sp->role.level != PG_LEVEL_4K);
> +
>   	trace_kvm_mmu_unsync_page(sp);
>   	++vcpu->kvm->stat.mmu_unsync;
>   	sp->unsync = 1;
> @@ -2524,7 +2532,6 @@ bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>   		if (sp->unsync)
>   			continue;
>   
> -		WARN_ON(sp->role.level != PG_LEVEL_4K);
>   		kvm_unsync_page(vcpu, sp);
>   	}
>   
> @@ -3406,8 +3413,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>   		 * mmu_need_write_protect() describe what could go wrong if this
>   		 * requirement isn't satisfied.
>   		 */
> -		if (!smp_load_acquire(&sp->unsync) &&
> -		    !smp_load_acquire(&sp->unsync_children))
> +		if (!smp_load_acquire(&sp->unsync_children))
>   			return;
>   
>   		write_lock(&vcpu->kvm->mmu_lock);
> 


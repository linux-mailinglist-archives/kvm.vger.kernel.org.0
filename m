Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C9D294C1C
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 14:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442155AbgJUMAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 08:00:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2442137AbgJUMAN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 08:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603281611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FEqXz7G12+BmHZNYqLH7P68s5dXdeke9n26KkMvS1JY=;
        b=MMLv2eACuOpw5++KX1+KNDzyq0Qr9sNXQFnpgHKhdJUdzURIIm6WhqThrGjvO/tJZN+pi0
        1QTalElMZdn2tqOejLsfTtxcb3318dORun1thh1qxnkbF3iTPhRhaMe+HN4IQmP8cyQtoA
        PNa3OwjYpLvmHYDfGMOijMxRZPoPURY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-cKoifXvrPQiP1NczkwQeEQ-1; Wed, 21 Oct 2020 08:00:08 -0400
X-MC-Unique: cKoifXvrPQiP1NczkwQeEQ-1
Received: by mail-wm1-f70.google.com with SMTP id c204so1305415wmd.5
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 05:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FEqXz7G12+BmHZNYqLH7P68s5dXdeke9n26KkMvS1JY=;
        b=fF6x/IlZg3WMT7E/wthiEnIwpUK701Z01nIMhsf0YqsaRjWFmUXJCQpYFqzR8QZzGA
         bAQUAYF0ajNYtvfKNd0804ed85Y4nIYb5nZwQJ8TbxTFMj9BAwV1QI2Qdo02Q7isj06U
         J2fhtNiIYDSl7gW546R8eQZl6/f+6YzmAJDMJL54DFXjUK3oZ7NgKSdh7RqKdqB2lEH0
         BG+YJY1R4T62yIB4Wm6QqfVqdG5C8ELw3OJIr79kQtruuEixmxg5supy4gojsvG5OsZ5
         2255UzWgWcMH5Xz0v1WLNcEsxwo5TMgZIp54a+EIdBEaMLOxEHWs4qi6k2nuHq1D0l2b
         ivMA==
X-Gm-Message-State: AOAM5300NCDqeXBHVG3etHi/pB9hEa8578IMg7RQxTybr0eBGE8Moi6G
        MmK10S5G/cF+jfJgaOG2rBMCibFh4HoSb5M3q8HaaJMwLPQZKVQM7c89MlxALKygmJeO4Xby589
        407SdWLqkS/3H
X-Received: by 2002:a1c:f30d:: with SMTP id q13mr3126690wmq.36.1603281606804;
        Wed, 21 Oct 2020 05:00:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHhHdy2ZltzmZpn86eWLCHMlwJ/xFHhZ81m7k3oEdPSWZPH4DPgsohX7uVZ9pypeXKMWfgUg==
X-Received: by 2002:a1c:f30d:: with SMTP id q13mr3126664wmq.36.1603281606572;
        Wed, 21 Oct 2020 05:00:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d30sm3601490wrc.19.2020.10.21.05.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 05:00:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] KVM: VMX: Stash kvm_vmx in a local variable for Hyper-V paravirt TLB flush
In-Reply-To: <20201020215613.8972-3-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com> <20201020215613.8972-3-sean.j.christopherson@intel.com>
Date:   Wed, 21 Oct 2020 14:00:04 +0200
Message-ID: <875z736b7f.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Capture kvm_vmx in a local variable instead of polluting
> hv_remote_flush_tlb_with_range() with to_kvm_vmx(kvm).
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6d53bcc4a1a9..6d41c99c70c4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -516,26 +516,27 @@ static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
>  static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  		struct kvm_tlb_range *range)
>  {
> +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
>  	struct kvm_vcpu *vcpu;
>  	int ret = 0, i;
>  
> -	spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> +	spin_lock(&kvm_vmx->ept_pointer_lock);
>  
> -	if (to_kvm_vmx(kvm)->ept_pointers_match == EPT_POINTERS_CHECK)
> +	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK)
>  		check_ept_pointer_match(kvm);
>  
> -	if (to_kvm_vmx(kvm)->ept_pointers_match != EPT_POINTERS_MATCH) {
> +	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
>  			/* If ept_pointer is invalid pointer, bypass flush request. */
>  			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
>  				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
>  							    range);
>  		}
> -	} else if (VALID_PAGE(to_kvm_vmx(kvm)->hv_tlb_eptp)) {
> -		ret = hv_remote_flush_eptp(to_kvm_vmx(kvm)->hv_tlb_eptp, range);
> +	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
> +		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
>  	}
>  
> -	spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
> +	spin_unlock(&kvm_vmx->ept_pointer_lock);
>  	return ret;
>  }
>  static int hv_remote_flush_tlb(struct kvm *kvm)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EA7462E29
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 09:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbhK3IGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 03:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239390AbhK3IGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 03:06:51 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F908C061574;
        Tue, 30 Nov 2021 00:03:32 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r11so83220195edd.9;
        Tue, 30 Nov 2021 00:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y3OjoArPACL/x2z/KPmqVt1SHQfGrEG51zBDxpyeVJ4=;
        b=Rc0Rnyd5FBS1g11SUugefNt50KNwWJifSMXXpkvM2zEgUikS4qVbAdhPmfyv492dJD
         aWk2rq4E/Ho/TiYxXqGOAbsntJX2DybjZlncwcb/1EkhOG9nRwVOzRu6pJD8DC85mG6I
         vyq5DqFFdooE3k+4VZdKbqT1+scpG0H7Tceb3/zps/a2WpRmuBGNjRcL04I6OF56eQPc
         VMbaA3wILpOgzx+7RokJIVB+MU7M9Gf1Ww87yzrIDv4oDV/2NSOOwzt5GGQY0dU8caUb
         Y+zi7KLF+vUzaIocaKuSmrebziuhSZ9Tx+Orf/x5Jbhy6Y/sinzuHy/F7PzLzD4y+0uw
         ZqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y3OjoArPACL/x2z/KPmqVt1SHQfGrEG51zBDxpyeVJ4=;
        b=tkHshgERqHzr1ZcjaCluTyiWjsCL3w0dT/mu9XhPBQrm2iuVvF1PVTEqGyZpCrGl6k
         1xgLXe61oLJl1BYcg70+vErObx9aYY01cKfqB+cdVWuu0NtbbumNpbIhIrkrv0vDhKbB
         lpFyCGXO+aSgXPjQqcXlI7voyPSdz57zxvAgw99nY1aGxWM4PDF2pwp2ucuslpuqNx6L
         ybO68ki7KLwqxPbPFjEKTSgL8xjS4TiVJv706cXy+ZlwFi43jYM6okLICrh95bi4J9Ol
         FR3vGo8avilwtWlzYf+7GrkOm9oUi9/7tCul1Fo4Otpm3nIr+ZbX76L+RF3yKbBSHPaa
         mcLA==
X-Gm-Message-State: AOAM530ml2BogUaFAo5+vt8oMKp9+ic2gswvPR9YRPF5ns/g2UYJSxUl
        V31+VN4EWR0IY2isUatdXmA=
X-Google-Smtp-Source: ABdhPJxIWTfddArRgY9lnTND2FNXQy7NujYHAcrA/2ukXnM9X6Bj32tjvj/dqG4bjqgyNr1bJECVeg==
X-Received: by 2002:a17:907:3e96:: with SMTP id hs22mr66982659ejc.139.1638259410717;
        Tue, 30 Nov 2021 00:03:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id jz4sm8590408ejc.19.2021.11.30.00.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 00:03:30 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <4fa1e465-1939-aff2-94bb-fbc400d6c323@redhat.com>
Date:   Tue, 30 Nov 2021 09:03:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 01/28] KVM: x86/mmu: Use yield-safe TDP MMU root iter in
 MMU notifier unmapping
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211120045046.3940942-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 05:50, Sean Christopherson wrote:
> Use the yield-safe variant of the TDP MMU iterator when handling an
> unmapping event from the MMU notifier, as most occurences of the event
> allow yielding.
> 
> Fixes: e1eed5847b09 ("KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if possible")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 377a96718a2e..a29ebff1cfa0 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1031,7 +1031,7 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>   {
>   	struct kvm_mmu_page *root;
>   
> -	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
>   		flush |= zap_gfn_range(kvm, root, range->start, range->end,
>   				       range->may_block, flush, false);
>   
> 

Queued, thanks.

Paolo

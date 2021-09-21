Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188BC4134EB
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 15:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhIUOAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 10:00:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232981AbhIUOAr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 10:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632232758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pc5zTd5423g5oCDswwWi0/B+KfF4NWiO9C9OXU0iE9E=;
        b=T5FWN7zsgisf/WUo0LY86969psiw6Uv+shDGzWxJPKnZBahhxzS2BODLhehcuEtpwhyARF
        Tb96oo4alMJ/KETXRqTrWFOfWlwiujVqtve0dxX2uwMfeWVWkC1aiq91bI+kabtNIRLGeh
        txXXYA07f5h3OLNHx5Ik74tAbnRIHgU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-n360UIgEO12NbqP0lsju1g-1; Tue, 21 Sep 2021 09:59:17 -0400
X-MC-Unique: n360UIgEO12NbqP0lsju1g-1
Received: by mail-wr1-f69.google.com with SMTP id r9-20020a5d4989000000b0015d0fbb8823so8875259wrq.18
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 06:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Pc5zTd5423g5oCDswwWi0/B+KfF4NWiO9C9OXU0iE9E=;
        b=QHnJYd2+9gLNHf1hLGkC3cqhFsrDI7bjFsy8J8SmFCZrXVoHWB35lxp25gTe2+in6k
         FLCTsTdmFAjRpvT4KQAwnEwcNwaPV2jShwZAwatZ2pQXOS5JwrxfIDXE7bSqy4TXIEB3
         HqxjmRoVGNvASETMmaO4C4cybfpMaPXmB40P6K2ERsNHWbZp72D4zHGG0maD5OwR8qke
         VyUpZ2L2Ru7MzN6g3Dh/1O/n3hY1sS2z4466pqdUB9PVPRsPmzk9uFq57yeJOgKS9rqz
         qQatQ2m4Qk/xsqOo9jgKJLz6a/HmFceyasEZfzNNww5UIBvuuqRC29AkU31DwTeYK/Dq
         Lchg==
X-Gm-Message-State: AOAM530dWI24Z2/gWhwhUteKd/hcDnDNKZf60DtYlhGOdohXBaAoHPlQ
        HR6YMZtY1yiLXSHXPjsa+9wNh6Uq8rIzbU8Z4F3vD8vqF4snQraonxfC/KpauUYa4fEvPDcbGg9
        /I9exdW94n4Ei
X-Received: by 2002:adf:b7c5:: with SMTP id t5mr35306463wre.322.1632232755952;
        Tue, 21 Sep 2021 06:59:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfch/IQXeY1K+uMr/zZV4z09c6bx4WdCg2bKY2MIL2HNzsSxO6UdUPmI3PDEUkN2UmPgH0og==
X-Received: by 2002:adf:b7c5:: with SMTP id t5mr35306437wre.322.1632232755724;
        Tue, 21 Sep 2021 06:59:15 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t18sm18466238wrp.97.2021.09.21.06.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:59:15 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 10/10] KVM: x86: WARN on non-zero CRs at RESET to
 detect improper initalization
In-Reply-To: <20210921000303.400537-11-seanjc@google.com>
References: <20210921000303.400537-1-seanjc@google.com>
 <20210921000303.400537-11-seanjc@google.com>
Date:   Tue, 21 Sep 2021 15:59:14 +0200
Message-ID: <8735py9gi5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> WARN if CR0, CR3, or CR4 are non-zero at RESET, which given the current
> KVM implementation, really means WARN if they're not zeroed at vCPU
> creation.  VMX in particular has several ->set_*() flows that read other
> registers to handle side effects, and because those flows are common to
> RESET and INIT, KVM subtly relies on emulated/virtualized registers to be
> zeroed at vCPU creation in order to do the right thing at RESET.
>
> Use CRs as a sentinel because they are most likely to be written as side
> effects, and because KVM specifically needs CR0.PG and CR0.PE to be '0'
> to correctly reflect the state of the vCPU's MMU.  CRs are also loaded
> and stored from/to the VMCS, and so adds some level of coverage to verify
> that KVM doesn't conflate zero-allocating the VMCS with properly
> initializing the VMCS with VMWRITEs.
>
> Note, '0' is somewhat arbitrary, vCPU creation can technically stuff any
> value for a register so long as it's coherent with respect to the current
> vCPU state.  In practice, '0' works for all registers and is convenient.
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ec61b90d9b73..4e25baac3977 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10800,6 +10800,16 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	unsigned long new_cr0;
>  	u32 eax, dummy;
>  
> +	/*
> +	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
> +	 * to handle side effects.  RESET emulation hits those flows and relies
> +	 * on emulated/virtualized registers, including those that are loaded
> +	 * into hardware, to be zeroed at vCPU creation.  Use CRs as a sentinel
> +	 * to detect improper or missing initialization.
> +	 */
> +	WARN_ON_ONCE(!init_event &&
> +		     (old_cr0 || kvm_read_cr3(vcpu) || kvm_read_cr4(vcpu)));
> +
>  	kvm_lapic_reset(vcpu, init_event);
>  
>  	vcpu->arch.hflags = 0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


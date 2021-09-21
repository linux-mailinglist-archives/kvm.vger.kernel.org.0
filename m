Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3405A413488
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhIUNmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 09:42:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232953AbhIUNmQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 09:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632231646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iVJ6jA04IK22G/jDsobPeYSFtrQJ6cK0uRhiwpn8U+A=;
        b=BCkxrYRQZ1J9Tqp9ObBhXqddwzEDGn6eiRhc/lQrJi6H8tkznx7P+Xz5ifxwwJr7FBCYOR
        qgy475T21jDYSG/5H8ZiFEzTxLHP3jrw5se2ha70mH+dyx5DfTFBzQGw9kc4J6DcO1+s8x
        r0TxHYmNdRpIhl3r1k3IjyzyExRJYPw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-N8kDrmLpMLi9-QHOiZptsQ-1; Tue, 21 Sep 2021 09:40:45 -0400
X-MC-Unique: N8kDrmLpMLi9-QHOiZptsQ-1
Received: by mail-wr1-f69.google.com with SMTP id u10-20020adfae4a000000b0016022cb0d2bso1085613wrd.19
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 06:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iVJ6jA04IK22G/jDsobPeYSFtrQJ6cK0uRhiwpn8U+A=;
        b=jJzx8kQVgJkN36nXIrAERt5B41E5hU6UXdLUNOHDuOwV9DMkyHcVsXs68wWs8L8QKh
         QfYtg2uWf40c3zTruvRWV5SKrikxjEhqARUZ5Xoo08vzsNiolUTqOaLhK/ycqvqLBBZN
         iVaydjsB9SJPWB05LLfjNV4X6GH7Z02t6XDAoD7ncXQzG9KsqAEAI+sQNq+JF4nKQsHx
         +XPHLWB4+BCtiD1oD3ssCd1k3S+jW8e5jMdwWaPBEOTzlS5FnB/tv+0H+qY5TzBPVLG3
         h/VSW3IA4YVMc2xf6wQMSDps7K1JxRxsQbuu/QRHYS/pL+pjw2rNOj9gs07JHeWk9mjy
         BAYw==
X-Gm-Message-State: AOAM530SdB71fX+JUAzA7qWxqsfYLs4t1hHnoiMC9iKELqgMOKkE/PPS
        gLJ0iCLvQ6osNAhYXIoa0d6sHTkxYMGQvljiqvRc3/B6a/LyW+escDPuSN/w4JVKqAVV2K2kzhx
        mxqqvJvGcMCuq
X-Received: by 2002:adf:f98b:: with SMTP id f11mr35736934wrr.333.1632231644683;
        Tue, 21 Sep 2021 06:40:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlSORnU4CdGqTxRO6z9tsqPEPkQvl1bjfap/OC7IHg1t6vYcBPuzbONjGJRhB0te/lOAdMjQ==
X-Received: by 2002:adf:f98b:: with SMTP id f11mr35736908wrr.333.1632231644470;
        Tue, 21 Sep 2021 06:40:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s15sm19581151wrb.22.2021.09.21.06.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:40:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 01/10] KVM: x86: Mark all registers as avail/dirty at
 vCPU creation
In-Reply-To: <20210921000303.400537-2-seanjc@google.com>
References: <20210921000303.400537-1-seanjc@google.com>
 <20210921000303.400537-2-seanjc@google.com>
Date:   Tue, 21 Sep 2021 15:40:42 +0200
Message-ID: <87bl4m9hd1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Mark all registers as available and dirty at vCPU creation, as the vCPU has
> obviously not been loaded into hardware, let alone been given the chance to
> be modified in hardware.  On SVM, reading from "uninitialized" hardware is
> a non-issue as VMCBs are zero allocated (thus not truly uninitialized) and
> hardware does not allow for arbitrary field encoding schemes.
>
> On VMX, backing memory for VMCSes is also zero allocated, but true
> initialization of the VMCS _technically_ requires VMWRITEs, as the VMX
> architectural specification technically allows CPU implementations to
> encode fields with arbitrary schemes.  E.g. a CPU could theoretically store
> the inverted value of every field, which would result in VMREAD to a
> zero-allocated field returns all ones.
>
> In practice, only the AR_BYTES fields are known to be manipulated by
> hardware during VMREAD/VMREAD; no known hardware or VMM (for nested VMX)
> does fancy encoding of cacheable field values (CR0, CR3, CR4, etc...).  In
> other words, this is technically a bug fix, but practically speakings it's
> a glorified nop.

Just to make the picture complete, according to TLFS, Enlightened VMCS
must also be zero allocated and the encoding is known. Still a nop ;-)

>
> Failure to mark registers as available has been a lurking bug for quite
> some time.  The original register caching supported only GPRs (+RIP, which
> is kinda sorta a GPR), with the masks initialized at ->vcpu_reset().  That
> worked because the two cacheable registers, RIP and RSP, are generally
> speaking not read as side effects in other flows.
>
> Arguably, commit aff48baa34c0 ("KVM: Fetch guest cr3 from hardware on
> demand") was the first instance of failure to mark regs available.  While
> _just_ marking CR3 available during vCPU creation wouldn't have fixed the
> VMREAD from an uninitialized VMCS bug because ept_update_paging_mode_cr0()
> unconditionally read vmcs.GUEST_CR3, marking CR3 _and_ intentionally not
> reading GUEST_CR3 when it's available would have avoided VMREAD to a
> technically-uninitialized VMCS.
>
> Fixes: aff48baa34c0 ("KVM: Fetch guest cr3 from hardware on demand")
> Fixes: 6de4f3ada40b ("KVM: Cache pdptrs")
> Fixes: 6de12732c42c ("KVM: VMX: Optimize vmx_get_rflags()")
> Fixes: 2fb92db1ec08 ("KVM: VMX: Cache vmcs segment fields")
> Fixes: bd31fe495d0d ("KVM: VMX: Add proper cache tracking for CR0")
> Fixes: f98c1e77127d ("KVM: VMX: Add proper cache tracking for CR4")
> Fixes: 5addc235199f ("KVM: VMX: Cache vmcs.EXIT_QUALIFICATION using arch avail_reg flags")
> Fixes: 8791585837f6 ("KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 86539c1686fa..e77a5bf2d940 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10656,6 +10656,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	int r;
>  
>  	vcpu->arch.last_vmentry_cpu = -1;
> +	vcpu->arch.regs_avail = ~0;
> +	vcpu->arch.regs_dirty = ~0;
>  
>  	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
>  		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


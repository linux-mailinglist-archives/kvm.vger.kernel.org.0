Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1568367E27
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 11:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhDVJvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 05:51:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230341AbhDVJvk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 05:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619085065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DL0LvSptSw1OR4qFWXug2ce4aufBqHnVMVGyRJFHbIA=;
        b=axty2cdODH4fwdxLxf/bqyUaK5pW6U+LM3/BBDdfnlm0hIb5meup15R35MGTPrNRYwbnMM
        I+l2DSA9aUKGRF0+gm5WxD11emDkvDH042XsV12/fccgz8CmVEhRaHPWZ5YV6La/wjO3xk
        KI16jZwB/wnjo6PhptLm2IvWUzhAU5k=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-D4dOuVmxPnmFg8afIb4SNQ-1; Thu, 22 Apr 2021 05:51:02 -0400
X-MC-Unique: D4dOuVmxPnmFg8afIb4SNQ-1
Received: by mail-ed1-f70.google.com with SMTP id z3-20020a05640240c3b029037fb0c2bd3bso16571074edb.23
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 02:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DL0LvSptSw1OR4qFWXug2ce4aufBqHnVMVGyRJFHbIA=;
        b=PKHhX4lvXG0otE+N/K9UpktlCHHPwydg8QblL3qwnfwGhtiZ+cn7lQu94nnXXhDvLL
         O7G/oZuRQSIqiTMNnCHIIJnePiaZQjZWfmpxXs3NPrlsZd8hQLE+ewKCaz+OCBqjqOlb
         oCn0zIQ2Ic/K6uxD4IiinKH3Q/KFYMiX1pqxlk2g9veQWtBVr0zUOLviLPxBXeXWX7St
         hxvBx8FzNj2T8TCUhGhEizD76Bzl0TQfkbEUrwrh1CRTUjy1oVto+gM/f9EKfPkV6ao+
         rWDu6ej1JXjfUxh250OymE0s3fab/+y2mxm0QkD+JgdT+1j/5hca8W4q49wUqNw314/2
         fgaA==
X-Gm-Message-State: AOAM53269HTwKfm7q0gQb/sHEyxG+bgNIlfk2Lez/wjcFWk6KZ9EqQdR
        UlSB7hfTQqa2Gzm74e6HFEX78W2X1xif3p0twe98sGt3GUSkvgddPK4ecXyJdqB3a3YUP7GLtys
        kkXjoMjA/mcNi
X-Received: by 2002:a17:906:b104:: with SMTP id u4mr2464646ejy.211.1619085061441;
        Thu, 22 Apr 2021 02:51:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7MByC5DDDsRQtir8pa2yWMLJwpIC7olJd5ApG1r7karH2maV0p/pxOZNSl2zWI2710X64CQ==
X-Received: by 2002:a17:906:b104:: with SMTP id u4mr2464626ejy.211.1619085061232;
        Thu, 22 Apr 2021 02:51:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l9sm1464525ejz.96.2021.04.22.02.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 02:51:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 7/9] KVM: x86/xen: Drop RAX[63:32] when processing
 hypercall
In-Reply-To: <20210422022128.3464144-8-seanjc@google.com>
References: <20210422022128.3464144-1-seanjc@google.com>
 <20210422022128.3464144-8-seanjc@google.com>
Date:   Thu, 22 Apr 2021 11:51:00 +0200
Message-ID: <877dkuhcl7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Truncate RAX to 32 bits, i.e. consume EAX, when retrieving the hypecall
> index for a Xen hypercall.  Per Xen documentation[*], the index is EAX
> when the vCPU is not in 64-bit mode.
>
> [*] http://xenbits.xenproject.org/docs/sphinx-unstable/guest-guide/x86/hypercall-abi.html
>
> Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/xen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index ae17250e1efe..7f27bb65a572 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -673,7 +673,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>  	bool longmode;
>  	u64 input, params[6];
>  
> -	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
> +	input = (u64)kvm_register_readl(vcpu, VCPU_REGS_RAX);
>  
>  	/* Hyper-V hypercalls get bit 31 set in EAX */
>  	if ((input & 0x80000000) &&

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Alternatively, as a minor optimization, you could've used '!longmode'
check below, something like:

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index ae17250e1efe..7df1498d3a41 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -682,6 +682,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 
        longmode = is_64_bit_mode(vcpu);
        if (!longmode) {
+               input = (u32)input;
                params[0] = (u32)kvm_rbx_read(vcpu);
                params[1] = (u32)kvm_rcx_read(vcpu);
                params[2] = (u32)kvm_rdx_read(vcpu);

-- 
Vitaly


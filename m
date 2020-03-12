Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 348E0182DE6
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 11:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgCLKgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 06:36:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43086 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726028AbgCLKgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 06:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584009384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GH7fU1TWEWw40X0bZzMnWywwid5YSvqvgDDmRobv45Y=;
        b=iXtPj5wgcCMHSPMzUsWRxwATQWYS/jAqATCs65UX95fNsBSU8NojmKBiZ0siIQNqoCgXSm
        bjdMrPSTDAzVtdUbL1L/5EPCPAaPVkeYNMJnR/m0riWF5afhlS0BRIlPbI/di/7mI0sHVq
        wkrvCNSM/fhh2LY7SCxCQzZUM0LJJE4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-WyqlkljOPneoXxL6SYTMWA-1; Thu, 12 Mar 2020 06:36:21 -0400
X-MC-Unique: WyqlkljOPneoXxL6SYTMWA-1
Received: by mail-wr1-f72.google.com with SMTP id o9so2400914wrw.14
        for <kvm@vger.kernel.org>; Thu, 12 Mar 2020 03:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GH7fU1TWEWw40X0bZzMnWywwid5YSvqvgDDmRobv45Y=;
        b=ThNxD8F7ay1pSawVZrUbhtSWdMdoWG9Jz7oYUvvcBOJFczpeCTtTq68V8kzU1Vo+Jp
         3vo/ytEw04tV3XArvz5IKs4nWKr6yoCnJeVuHNTy4uz3QCZH96EG9PHtd5Znr4A3zgW2
         XPa1uAZe6L3JszMcOQSD+PYQWV/bdcWTXcG5LqGuGG5rHQT4NP+kHY9XLGdInxbUi50w
         0ZlBoChnSUaQ2AZYiodQZxn/zVYn+W5Ils6U1cxltE5IP1sTN4wFWdv0A8SN7bd2lsOs
         zvMW6Li+oslnsMf20aAQLM9OwfYSzxyUPh6xPwpuwfqXLT8OXbJDXR5KAecz14nWL0kz
         jLZA==
X-Gm-Message-State: ANhLgQ3vlsB0ezPNdcG9Np1AFtgyXVdQOzLBT+RkWqjxjOuaHRGPN/E6
        ZbSBWog9H9y6fEfeG0KxGf5rn+nCGm9AYjemYs4MOGqNjHQtI+y5CVub/6HLg5q3EsSjqscXQab
        6Fece0dies66v
X-Received: by 2002:a1c:2e4d:: with SMTP id u74mr4107936wmu.96.1584009380311;
        Thu, 12 Mar 2020 03:36:20 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs7zWG7tWo2aK3FgLZH9xdm8Y5FGguMSvAZpJaTh4TPxo4IM8BRiVjLFQaYc3w9c3HX8ctjrA==
X-Received: by 2002:a1c:2e4d:: with SMTP id u74mr4107908wmu.96.1584009380046;
        Thu, 12 Mar 2020 03:36:20 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l7sm2679012wrw.33.2020.03.12.03.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 03:36:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize vmexit time when not exposing PMU
In-Reply-To: <1584007547-4802-1-git-send-email-wanpengli@tencent.com>
References: <1584007547-4802-1-git-send-email-wanpengli@tencent.com>
Date:   Thu, 12 Mar 2020 11:36:19 +0100
Message-ID: <87r1xxrhb0.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> PMU is not exposed to guest by most of cloud providers since the bad performance 
> of PMU emulation and security concern. However, it calls perf_guest_switch_get_msrs()
> and clear_atomic_switch_msr() unconditionally even if PMU is not exposed to the 
> guest before each vmentry. 
>
> ~1.28% vmexit time reduced can be observed by kvm-unit-tests/vmexit.flat on my 
> SKX server.
>
> Before patch:
> vmcall 1559
>
> After patch:
> vmcall 1539
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 40b1e61..fd526c8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6441,6 +6441,9 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>  	int i, nr_msrs;
>  	struct perf_guest_switch_msr *msrs;
>  
> +	if (!vcpu_to_pmu(&vmx->vcpu)->version)
> +		return;
> +
>  	msrs = perf_guest_get_msrs(&nr_msrs);
>  
>  	if (!msrs)

Personally, I'd prefer this to be expressed as

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40b1e6138cd5..ace92076c90f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6567,7 +6567,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
        pt_guest_enter(vmx);
 
-       atomic_switch_perf_msrs(vmx);
+       if (vcpu_to_pmu(&vmx->vcpu)->version)
+               atomic_switch_perf_msrs(vmx);
+
        atomic_switch_umwait_control_msr(vmx);
 
        if (enable_preemption_timer)

(which will likely produce the same code as atomic_switch_perf_msrs() is
likely inlined).

Also, (not knowing much about PMU), is
"vcpu_to_pmu(&vmx->vcpu)->version" check correct?

E.g. in intel_is_valid_msr() correct for Intel PMU or is it stated
somewhere that it is generic rule?

Also, speaking about cloud providers and the 'micro' nature of this
optimization, would it rather make sense to introduce a static branch
(the policy to disable vPMU is likely to be host wide, right)?

-- 
Vitaly


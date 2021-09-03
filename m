Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849A9400340
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 18:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349985AbhICQ1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 12:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349971AbhICQ1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 12:27:41 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94A8C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 09:26:41 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k24so6013743pgh.8
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 09:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BYBpFSXUwEJhsCIyXdW0SZlpa2rC9yP3pgFymkdEWK8=;
        b=lKWUYeQJp7pLg5MBv2HvNSr7jEOttJQyn/TOA+bjf+87fMIkq9hHnI88tqZGY+oPAs
         0U2MDd6HfUAmTySAtO97+gUhHDNqsQV6eUcWtauRKsRmo3hGMeLMVNJ/1cWJYmA6O++z
         X5KrIbEoBH02TmvsF38RRpx0m1GXysUOTHzlXQoBz0h6tAdOBTEVLb9LAsH70Pp6sDVN
         +UAC07J/q5hDheQFEYZFMRQDcOqOQj9ljEISafVki+xHGhefNhqD1TDX5TIlcZe8fcPS
         cTOnvxumcTitReEsVEn0fVv7GspNQTicIg78msMXhPoRxKNgwIqiwi0LI+jHU+rKQBxK
         uivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BYBpFSXUwEJhsCIyXdW0SZlpa2rC9yP3pgFymkdEWK8=;
        b=JrFZu9h0E5TQChHxDmPq01PQ0QNbs5R4yy/3sqPJSDLIlFxG11P0ZcTBje43NzatUp
         LKkRwCPs1fUF+snL8oBBWKgSY4B3zO74euNikWBkbmLA/dZvIQ56hSRrMQUAw0tm28sv
         Pbqz/zcfO+iZyC8rNd2EijtuCcMNZ2C3cAfGYBMnFPA/Oqv9Std6zNHeClojg1izhXD6
         empBmy1PTRjVXlc81k3mEHjlHu9KNWEGVnlsNN2j+9TWFCvK/5Ja0Bi7s5t6lXz0l0EA
         UxYsNImNdPRS9UuditlDR4Vv1ac3fW08u5aaDJrQ9TbVgbZFbSSSoWUynJsBuoCwnUT1
         7idw==
X-Gm-Message-State: AOAM5327g6c2cICWJ/fBHJ4OlRuV06ZzsNUrlw1Dctcre5f3r4LpSxDd
        tic0r80lvZ7gD66IOTA1KXYrnw==
X-Google-Smtp-Source: ABdhPJw/vPhyGDqcRlM0wPHZ9PBRcDG+lfKSj0uVaOgFAxb9F7s4ZZ0MtnUwG85mno4uCZmHxt7VXg==
X-Received: by 2002:a63:91c3:: with SMTP id l186mr4342925pge.264.1630686401156;
        Fri, 03 Sep 2021 09:26:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q29sm7623467pgc.91.2021.09.03.09.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 09:26:40 -0700 (PDT)
Date:   Fri, 3 Sep 2021 16:26:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 8/8] KVM: Make kvm_make_vcpus_request_mask() use
 pre-allocated cpu_kick_mask
Message-ID: <YTJMvI1GE5Ux7eVE@google.com>
References: <20210903075141.403071-1-vkuznets@redhat.com>
 <20210903075141.403071-9-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903075141.403071-9-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021, Vitaly Kuznetsov wrote:
> kvm_make_vcpus_request_mask() already disables preemption so just like
> kvm_make_all_cpus_request_except() it can be switched to using
> pre-allocated per-cpu cpumasks. This allows for improvements for both
> users of the function: in Hyper-V emulation code 'tlb_flush' can now be
> dropped from 'struct kvm_vcpu_hv' and kvm_make_scan_ioapic_request_mask()
> gets rid of dynamic allocation.
> 
> cpumask_available() checks in kvm_make_vcpu_request() and
> kvm_kick_many_cpus() can now be dropped as they checks for an impossible
> condition: kvm_init() makes sure per-cpu masks are allocated.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a4752dcc2a75..91c1e6c98b0f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9224,14 +9224,8 @@ static void process_smi(struct kvm_vcpu *vcpu)
>  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
>  				       unsigned long *vcpu_bitmap)
>  {
> -	cpumask_var_t cpus;
> -
> -	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
> -
>  	kvm_make_vcpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC,
> -				    vcpu_bitmap, cpus);
> -
> -	free_cpumask_var(cpus);
> +				    vcpu_bitmap);

Nit, this can all go on a single line.

>  }
>  
>  void kvm_make_scan_ioapic_request(struct kvm *kvm)

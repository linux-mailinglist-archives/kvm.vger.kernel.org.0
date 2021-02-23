Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FED6322F6D
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 18:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhBWRQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 12:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbhBWRQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 12:16:00 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D28C06174A
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:15:20 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id f8so10218424plg.5
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jj9DO+ke1KJUo/ZsSRRN0jt9Q3wZoLjHifVaJsOxwGI=;
        b=NBHYqeiCKYpYjjdFRCdD58+WuzPuM0LZQ+R3Qo3dV+StHkW3szwnnkFIgVEwE3kQab
         zjBGdp/jvMBHJUqK2TeSBWrnV1L4tG/8XRt/BHhZnrcG6Iu1rSiXKsYc41wmYM+44SxG
         0jYfbtDmeOWtoq6/L1XD/ed6gUlGF0/1CYnia/EtyQ8E0By9IEh6hCrsKftUJdYOiwrN
         uUnRoxW4PubejoSP7jFqpmnAaF6zlhJxSuWA8U0uXvERpdzDy0OFYam3zETUlxAWG71M
         nrgH2zcXQoXIVMKDFslhay5uiySvS7CV4gH+Jjby8jtjfjaFvWlw0vIZO4nr54w5n8qz
         /+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jj9DO+ke1KJUo/ZsSRRN0jt9Q3wZoLjHifVaJsOxwGI=;
        b=XYAGWBWPgtsWMc8xVUeI0R2UIXRLlW/pBy30RIg9f1yY79cGAqK5MJLCboCALQ2K1x
         jLz4A74dOTLW7p79iebqSJTSWjov99cwsIJUgaljoobWw/NWbcFSL9LhlYhG/WVmxrC6
         Y+3yseYKQq3tjleaVoKfNa1KqBjExlrezzI7hSlonJ9FRbpOKw+mwob59VxgELleE7R+
         GvSyRn111eZS6mMZ9S7PLpB/IINXYLhotovcwLfTZ9bgXR3Uym6KueZNfifDMmo6RHPe
         5Aoh7CviXQlrkbj241v+nEvecJ35WeSurMmJug1gzXyacOksG5Ne+SZz/YrGaIXtNNnn
         Ks2Q==
X-Gm-Message-State: AOAM5331i/8wyaHMXkmzxNH6wwd0mP1fyfiNZvWq5dENK7HfaCo6/PK1
        48VOQpWPn070iYL3tWuTc9DkKA==
X-Google-Smtp-Source: ABdhPJxrc6FVzTc+KiYGWNkxpla4tFwe8MryZL/oMXcurKjkRkhgGsjUIXsXmXBqOM0VefRajHTtIA==
X-Received: by 2002:a17:90a:de8d:: with SMTP id n13mr30320105pjv.136.1614100519509;
        Tue, 23 Feb 2021 09:15:19 -0800 (PST)
Received: from google.com ([2620:15c:f:10:c939:813f:76bc:d651])
        by smtp.gmail.com with ESMTPSA id m10sm3825929pjn.33.2021.02.23.09.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 09:15:18 -0800 (PST)
Date:   Tue, 23 Feb 2021 09:15:12 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: vmx/pmu: Fix dummy check if lbr_desc->event is
 created
Message-ID: <YDU4II6Jt+E5nFmG@google.com>
References: <20210223013958.1280444-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223013958.1280444-1-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 23, 2021, Like Xu wrote:
> If lbr_desc->event is successfully created, the intel_pmu_create_
> guest_lbr_event() will return 0, otherwise it will return -ENOENT,
> and then jump to LBR msrs dummy handling.
> 
> Fixes: 1b5ac3226a1a ("KVM: vmx/pmu: Pass-through LBR msrs when the guest LBR event is ACTIVE")
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index d1df618cb7de..d6a5fe19ff09 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -320,7 +320,7 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>  	if (!intel_pmu_is_valid_lbr_msr(vcpu, index))
>  		return false;
>  
> -	if (!lbr_desc->event && !intel_pmu_create_guest_lbr_event(vcpu))
> +	if (!lbr_desc->event && intel_pmu_create_guest_lbr_event(vcpu))
>  		goto dummy;

Wouldn't it be better to create an event only on write?  And really, why create
the event in this flow in the first place?  In normal operation, can't event
creation be deferred until GUEST_IA32_DEBUGCTL.DEBUGCTLMSR_LBR=1?  If event
creation fails in that flow, I would think KVM would do its best to create an
event in future runs without waiting for additional actions from the guest.

Also, this bug suggests there's a big gaping hole in the test coverage.  AFAICT,
event contention would lead to a #GP crash in the host due to lbr_desc->event
being dereferenced, no?

>  
>  	/*
> -- 
> 2.29.2
> 

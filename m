Return-Path: <kvm+bounces-2567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D697FB294
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:22:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F14481C20C39
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF28B134C0;
	Tue, 28 Nov 2023 07:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBfmLuVj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04C7197
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701156109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rE1VEO/P4SWtiM2JUk8giEN5tkTYagzMpscsqMITB5w=;
	b=ZBfmLuVjITC4d0QGdcTNNm30luLtv6PXLQogfwiJB2qyOq3QwN7WeQW/eoMkaIrRem4ezP
	ZcLjGvkO2v4qhd7PyUJX0QPTTSlmQqD1cOcuDQVxtggT2GRSYrfrcCeTWM6iI3gmn1JW1r
	xx2c4iol96qfQkVnUTS0NyCWlGwlvNU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-AvAWkds9OZu3-schdsCPjA-1; Tue, 28 Nov 2023 02:21:48 -0500
X-MC-Unique: AvAWkds9OZu3-schdsCPjA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40b40234b64so16923535e9.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 23:21:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701156107; x=1701760907;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rE1VEO/P4SWtiM2JUk8giEN5tkTYagzMpscsqMITB5w=;
        b=DiIr7qWP+gauOSPvU7LZ3tVlpTH9VvQqfh68nWRwio6b4DBZzopR5jMqEVru4iOwOm
         cBZWJ3QqbtSrpHnIwh4nDKjXG+OC2TOs+aZMivlUNK5ZSjr77FnWS/oxJxOx/f6C8QMX
         ny2ve1Oqs5MhI2cL6uLycmflvAo9nvDthxQsh5GR57g4Zq4YGuXBwh/07W1Q9XztMdyK
         606KkiFQxrDxovtPBZsBSim2lIWAiS6LHcWRuAosbAmDYGTPudYqk6mmU8OurlhqQ8pX
         dPGDGZJJj6HSIlegG1FeaU8Comom2riwF4IHXGwM2DVvmY0ua4g2Ek6I1adODxfrqsDA
         o6EQ==
X-Gm-Message-State: AOJu0YygAVeACsqVerEatsmX61PzusMt521Y36gTGoyCcoyOF9BN8BBF
	4EteCvWLH+jCeh2ZpizYXtTf4s5vC6gx6aASB14qtkEOr46Hmbkb/N2vZpqLH8hf5gFVmYMYHHz
	z7zJRNO09M4lC
X-Received: by 2002:a05:600c:450b:b0:40a:20f3:d127 with SMTP id t11-20020a05600c450b00b0040a20f3d127mr10318544wmo.35.1701156107368;
        Mon, 27 Nov 2023 23:21:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFfRAqrROjHJ1qTtcsKosFtEkpI+uCXd2x8KsHl5ZzJYdXsn5YxcHbf1j1XUd/tosccrg8O+Q==
X-Received: by 2002:a05:600c:450b:b0:40a:20f3:d127 with SMTP id t11-20020a05600c450b00b0040a20f3d127mr10318535wmo.35.1701156107013;
        Mon, 27 Nov 2023 23:21:47 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id o7-20020a05600c510700b0040b36ad5413sm16255957wms.46.2023.11.27.23.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 23:21:46 -0800 (PST)
Message-ID: <b11d9a96cf1b49eea92a8f3eec31272d47c82fb8.camel@redhat.com>
Subject: Re: [RFC 08/33] KVM: x86: Don't use hv_timer if CAP_HYPERV_VSM
 enabled
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com,
 corbert@lwn.net,  kys@microsoft.com, haiyangz@microsoft.com,
 decui@microsoft.com, x86@kernel.org,  linux-doc@vger.kernel.org
Date: Tue, 28 Nov 2023 09:21:44 +0200
In-Reply-To: <20231108111806.92604-9-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-9-nsaenz@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> VSM's VTLs are modeled by using a distinct vCPU per VTL. While one VTL
> is running the rest of vCPUs are left idle. This doesn't play well with
> the approach of tracking emulated timer expiration by using the VMX
> preemption timer. Inactive VTL's timers are still meant to run and
> inject interrupts regardless of their runstate.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>  arch/x86/kvm/lapic.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f55d216cb2a0..8cc75b24381b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -152,9 +152,10 @@ static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>  
>  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_x86_ops.set_hv_timer
> -	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
> -		    kvm_can_post_timer_interrupt(vcpu));
> +	return kvm_x86_ops.set_hv_timer &&
> +	       !(kvm_mwait_in_guest(vcpu->kvm) ||
> +		 kvm_can_post_timer_interrupt(vcpu)) &&
> +	       !(kvm_hv_vsm_enabled(vcpu->kvm));
>  }

This has to be fixed this way or another.

One idea is to introduce new MP state (KVM_MP_STATE_HALTED_USERSPACE), which will be set
on vCPUs that belong to inactive VTLs, and then userspace will do KVM_RUN which will block
as if it were for halted state but as soon as vCPU becomes unhalted, it will return to
the userspace instead of running again.

If we go with the approach of using polling on the inactive VTL's vcpus, then we can switch to a 
software timer just before we start polling.

Also note that AVIC/APICv and their IOMMU's have to be treated the same way. 

It is disabled during vCPU blocking due to the same reasons of vCPU not 
being assigned a physical CPU.

Currently it happens to work because you disable APIC accelerated map, which in turn disables (inhibits)
the APICv/AVIC.

Once again if we go with the approach of polling, we should ensure that polling does more or less
the same things as kvm_vcpu_block does (we should try to share as much code as possible as well).

Best regards,
	Maxim Levitsky






>  
>  static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)






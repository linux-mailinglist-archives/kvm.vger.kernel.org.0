Return-Path: <kvm+bounces-39795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A1ADA4A7F5
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 03:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A7ED189CD76
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFDD1A841F;
	Sat,  1 Mar 2025 02:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dHCg7nhg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E60E135A53
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 02:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740795625; cv=none; b=GHfHHEdXMXLE7Vymwry4c2gQbcd7rpYhJ/nSR2kA/4PuBipkGUvpdqCUWQfp5yA6rXtjBDPOL/nocq2n/RtdY/xLB/gPATP4tUYzK1AGS5lu+BRSF3VZ6xr8I/ChYSjIX76cs2s+zUvbGSy7IC3UE8nY6weYidD2th7fqfX2UFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740795625; c=relaxed/simple;
	bh=r+RC0mIps7ewdOPZ4EEiV9cS+FrkUb1ahc0bnutamnc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oYOxcerBP3JETGr5xbcscwfCyL0KYypAZxTkpgnyp9uzs7HLkhSCU2zYxWCsyblB2x5Q/YyUxoL5cPqzdy5xAbQ6tUh8ZSO1vuXkQvuozm/2TrXWQX4UiVUgZlfVYg4+gjLALYr+CAB4fSamy1kWcwySlp2zreUda7ONtGEipZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dHCg7nhg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740795622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HTnYslHOv+eTL/DqddUqxrEboLCZua2gUzvZ8+gxONE=;
	b=dHCg7nhgFeTfVX2k24gbND8Gr14xEKisHv9n+X8EZv3MX1AiufBQ2Gz++CCdCl1mt6gb01
	gO70GtAW6Eoin3OgvLfe/zaQ6DllwhFVu0FYx/gQxqJR2pDuVGC9135m1eFyElUfg13uci
	Mj986pkcXaYRSGkYRcn6TWAOhAz6CyE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-VargBB1uNmiS6wF7C_4X4A-1; Fri, 28 Feb 2025 21:20:20 -0500
X-MC-Unique: VargBB1uNmiS6wF7C_4X4A-1
X-Mimecast-MFC-AGG-ID: VargBB1uNmiS6wF7C_4X4A_1740795620
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e682a1c92aso30666436d6.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:20:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740795620; x=1741400420;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HTnYslHOv+eTL/DqddUqxrEboLCZua2gUzvZ8+gxONE=;
        b=a92hFdFE1JTUvSOxvUxBkF9jtZfGXR/WX9NdMwcFleeH0e5FLtsygdvhYsWbn8XXUP
         Injpz+gD3ACmJk+tWLr92ZW1nB0f7uxeHjsufNLH+bQ2PBshn/JGmVHDXmw1BZeDlq+K
         8N9Zb9KeIEdyYtjINjPPzJLCPiUXwEDbdnPTLjYN5VC7T4I983u5nOh7luwA8vjTU4Ec
         cjA8avcoa1rMFcgQvHMiwOkZCLkRzWghrskKq3l865+bqLSRAx+9YDzQtGx7tbLz3eov
         yR5lM3XoYdSUTQvTRodkGcvanNMhJlF7RrgQH7kQemywPrYKQ5WJbVd1vufsk/7dLK9F
         FSyg==
X-Gm-Message-State: AOJu0YyMcoM0q4plhZUoydRupII+s8eukFAYpuma3wmMxDaQduHapzJT
	Kl1+t6tGVCqRREAY/lVGVA50eY1iLOkGEUjG7TAHRC4RV8OYE4niJXxPDD+Cl7g2w+EhC+wlWSp
	zDbmnNtZpMf1xt/EnQYkjzFail3IdL7MXVUrExyul9Ozqb6DwmiZQr7Z2iw==
X-Gm-Gg: ASbGnctJ8QsNAFGK1OoCQ7VgfMhp1q93K6FLHVl+sAC+usac020cFeF/Oynp8wjT/4i
	Uy6tIQHZwIGWHWgfGaXBxTR6iXNtl1Eg5Q+Qopy/HYUp5yNDfPwevmML4GXeXLorAID+caSBnjm
	Oc3u5+NzFiPMbGgEBoT76BeaGPVUYxagjXli24m2dV8ZvqCNDkRqr9EtbH3WNQOkx2xHhvEmqml
	r14os9o7gF3LKrWlyGUk+TETs1m9ROGaKoAn92XRFUE7eTK585iSWvfX13fmnkg4NHNX3nvESMG
	lW3kBwkd40mkVeY=
X-Received: by 2002:ac8:5d51:0:b0:471:c701:7351 with SMTP id d75a77b69052e-474bc0555f7mr90583211cf.5.1740795619997;
        Fri, 28 Feb 2025 18:20:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFiZgCFc2hn/kvur+lHvwbd/WviuYdHQmq0M/KRn9MwiVff1NxhXYVWIt3YpdM4S1uPfV06Q==
X-Received: by 2002:ac8:5d51:0:b0:471:c701:7351 with SMTP id d75a77b69052e-474bc0555f7mr90583001cf.5.1740795619689;
        Fri, 28 Feb 2025 18:20:19 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47472409b48sm31824401cf.64.2025.02.28.18.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 18:20:19 -0800 (PST)
Message-ID: <540397690642d3aa7e77775a721ba5a62bbdc2ae.camel@redhat.com>
Subject: Re: [RFC PATCH 12/13] KVM: nSVM: Service local TLB flushes before
 nested transitions
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 21:20:18 -0500
In-Reply-To: <20250205182402.2147495-13-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-13-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> KVM does not track TLB flush requests for L1 vs. L2. Hence, service
> local flush that target the current context before switching to a new
> one. Since ASIDs are tracked per-VMCB, service the flushes before every
> VMCB switch.
> 
> This is conceptually similar to how nVMX calls
> kvm_service_local_tlb_flush_requests() in
> nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(), with the
> following differences:
> 
> 1. nVMX tracks the current VPID based on is_guest_mode(), so local TLB
>    flushes are serviced before enter_guest_mode() and
>    leave_guest_mode(). On the other hand, nSVM tracks the current ASID
>    based on the current VMCB, so the TLB flushes are serviced before an
>    VMCB switch.
> 
> 2. nVMX only enters and leaves guest mode in
>    nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(). Other paths
>    like vmx_set_nested_state() and vmx_leave_nested() call into these
>    two functions. On the other hand, nSVM open codes the switch in
>    functions like svm_set_nested_state() and svm_leave_nested(), so
>    servicing the flush in svm_switch_svm() is probably most reliable.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5e7b1c9bfa605..6daa7efa9262b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1421,6 +1421,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
>  {
> +	/*
> +	 * ASIDs are tracked per-VMCB. Perform any pending TLB flushes for the
> +	 * current VMCB before switching to a new one.
> +	 */
> +	kvm_service_local_tlb_flush_requests(&svm->vcpu);
> +
>  	svm->current_vmcb = target_vmcb;
>  	svm->vmcb = target_vmcb->ptr;
>  }


Note that another difference between SVM and VMX is that this code will only set tlb_ctl
in the current vmcb, the actual flush can happen much later, when we do VM entry with this vmcb,
e.g if we are now in L2, the flush will happen when we enter L2 again.

I think that this is correct but I might be mistaken.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky



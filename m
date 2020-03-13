Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9654A184897
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 14:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCMN5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 09:57:03 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52051 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbgCMN5B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 09:57:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584107819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EkZK0Yw0b3AmsS+1K+/HHxMBgsPW+vDT8ZosmzTnnFM=;
        b=R+Dj7d3jGfXTMaB2dGpWIEdxcimM2ZDEPnp546uptWYYyprZFNXtoMvQhXpScSe93nyPtL
        ra89GtELsxvMXAVah+HbqZRgzn9eQ8zHIKaemQxz8MwZqEE2PY+oLT7fS5T78bdcSw791e
        WjBoQSNADkIx9urE16QHIJIHqOTgs7A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-5yeUm_LmPty4oLR8Wrui4g-1; Fri, 13 Mar 2020 09:56:58 -0400
X-MC-Unique: 5yeUm_LmPty4oLR8Wrui4g-1
Received: by mail-wm1-f70.google.com with SMTP id f9so1386567wme.7
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 06:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EkZK0Yw0b3AmsS+1K+/HHxMBgsPW+vDT8ZosmzTnnFM=;
        b=aIE0Fu+D05UKKssFJFf7rl7Xvlh9YQX9jWsY/NZv9Nnkwjf0+WaNXmG5hs5ZU6pkJR
         HKK38Q6KhZkxC9qhKCRzunfSRXFOAzTMaJNTzVQoikmjpArfvfL3S5wm42xSdMYijpD2
         fXZNjj/6AasYcDHWdA8jkZ00PW28E1iUMHpQAXLo/X3TrHsuef3k4hS4qdtKM3j26iIl
         WAnZ5MMxfnzwZvaKTGSVDMH1gYulq+FNblTp7LddgE7lntPQqaf2Yri0rWv3u7si5RXA
         WWstuwdPyUlB2VPb4isKMFBBjreESq6gftv7YRLAVftu2ry2kKsH/KTBsJvY2t5vmH5T
         1+Cw==
X-Gm-Message-State: ANhLgQ0i1HAFYi7S0LLgWiqY5gLfSv4q6ITk+TLTuv9wQK7k81YUCyCU
        PITuMT1nEvrZbRyUUQuWaADoQfO8cbGbi1FrIahNNkyWsueNhBe9OCw+pyTgYrDwxc3aWq5mw9+
        nyHR8r7TmYe6e
X-Received: by 2002:a5d:6446:: with SMTP id d6mr17116237wrw.335.1584107817155;
        Fri, 13 Mar 2020 06:56:57 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsHnSokoI6DLr0MqcBliww9h/fQiT7vpU6EgENRVhdcolPrQmSdo+WdzskiBNYfgVvwjYhFqA==
X-Received: by 2002:a5d:6446:: with SMTP id d6mr17116218wrw.335.1584107816972;
        Fri, 13 Mar 2020 06:56:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a73sm1012706wme.47.2020.03.13.06.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 06:56:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 07/10] KVM: nVMX: Cast exit_reason to u16 to check for nested EXTERNAL_INTERRUPT
In-Reply-To: <20200312184521.24579-8-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com> <20200312184521.24579-8-sean.j.christopherson@intel.com>
Date:   Fri, 13 Mar 2020 14:56:55 +0100
Message-ID: <87mu8knys8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Explicitly check only the basic exit reason when emulating an external
> interrupt VM-Exit in nested_vmx_vmexit().  Checking the full exit reason
> doesn't currently cause problems, but only because the only exit reason
> modifier support by KVM is FAILED_VMENTRY, which is mutually exclusive
> with EXTERNAL_INTERRUPT.  Future modifiers, e.g. ENCLAVE_MODE, will
> coexist with EXTERNAL_INTERRUPT.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8fbbe2152ab7..86b12a2918c5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4337,7 +4337,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
>  	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>  
>  	if (likely(!vmx->fail)) {
> -		if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
> +		if ((u16)exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
>  		    nested_exit_intr_ack_set(vcpu)) {
>  			int irq = kvm_cpu_get_interrupt(vcpu);
>  			WARN_ON(irq < 0);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


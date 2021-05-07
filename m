Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A85376972
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 19:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbhEGRXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 13:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbhEGRXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 13:23:13 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C764C061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 10:22:12 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id i14so7627680pgk.5
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 10:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kaWNJOZNHQM17GdENePY8QBaToZgJGQqlauYDVc5v3M=;
        b=g4na67SI3DU41cZ7ScTQtXqlRqH211zEraccRSDgDDwNgtInz+HmQByazYcejNlRr/
         Gf0kUnOzULnveI8gdNfFEdeXbCWo4EPnAjIZDIerX5HaLfZW7Egfq01NLVdUn8+x8dGh
         FTkGj+smF50744mbvtq76UudGGreGUqp0Gk1ZaXvW3uEgIwDJ2JmIPI5QOu6YbgsUEef
         ZX7y0DMrV6zUjMiHyonN75GdQvMlddjhEyqW4HfZEjHDjJQW+bKo5GWgD4XCzulb0SAX
         afKtM/91aVbF8pPAeLSRpOsgN7+IwNzSsLgl65vGFhNmKL/v0IfM4rLoG8pbjNB1u/Wr
         xbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kaWNJOZNHQM17GdENePY8QBaToZgJGQqlauYDVc5v3M=;
        b=RmPzl3JZfiyoyCMabtxdpZso1SJyY4cqWtl0x99zvmpl6rQCv+foEwdPEvMv9caux9
         Rbe4et4xVhR1SIIfgsqVkh14H8vtQr6mbbP2OeSC3kw3Usa9bW/+fkSBEKSP152URJas
         NuHa7p+Jlvldq2kvJS+sd6jjuGhaCO0xUKQNywreVkLQPJz5LEHs80TzsGC/sy0dMmwU
         U8/YK9SJa2IhFxh+FTlEoEjIXbEjsqDVxzFnf4mqOHuzoP0CUgRGw1QjhutaQCTxVNlw
         IUKDCXqqj8KFXNN1Phe/v1QbAaNwT3SkMKqLZS/qZ8HYUOo1pphwopDlxhOwj2DfI/BK
         dDDQ==
X-Gm-Message-State: AOAM532Uqke+OMgcGl8tKI3X1dqRELoSnU5+mbuwAhdaDwkPe2Qhxo3Y
        dTwNTJ3LOGxusALt+o3veNblRCiqNEfKvw==
X-Google-Smtp-Source: ABdhPJzpnBiQSsQs8KvPugdihlSYjycu70EHmHY203mpg57K2QJ9jk4ingLCEsO3hudvrKa6Qy45/A==
X-Received: by 2002:a62:2904:0:b029:25c:13f2:47d4 with SMTP id p4-20020a6229040000b029025c13f247d4mr11365705pfp.4.1620408131821;
        Fri, 07 May 2021 10:22:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x22sm3788187pfp.138.2021.05.07.10.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 10:22:11 -0700 (PDT)
Date:   Fri, 7 May 2021 17:22:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YJV3P4mFA7pITziM@google.com>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.528132061@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507130923.528132061@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021, Marcelo Tosatti wrote:
> Index: kvm/arch/x86/kvm/vmx/posted_intr.c
> ===================================================================
> --- kvm.orig/arch/x86/kvm/vmx/posted_intr.c
> +++ kvm/arch/x86/kvm/vmx/posted_intr.c
> @@ -203,6 +203,25 @@ void pi_post_block(struct kvm_vcpu *vcpu
>  	local_irq_enable();
>  }
>  
> +int vmx_vcpu_check_block(struct kvm_vcpu *vcpu)
> +{
> +	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> +
> +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> +		return 0;
> +
> +	if (!kvm_vcpu_apicv_active(vcpu))
> +		return 0;
> +
> +	if (!kvm_arch_has_assigned_device(vcpu->kvm))
> +		return 0;
> +
> +	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR)
> +		return 0;
> +
> +	return 1;

IIUC, the logic is to bail out of the block loop if the VM has an assigned
device, but the blocking vCPU didn't reconfigure the PI.NV to the wakeup vector,
i.e. the assigned device came along after the initial check in vcpu_block().
That makes sense, but you can add a comment somewhere in/above this function?

> +}
> +
>  /*
>   * Handler for POSTED_INTERRUPT_WAKEUP_VECTOR.
>   */
> @@ -236,6 +255,26 @@ bool pi_has_pending_interrupt(struct kvm
>  		(pi_test_sn(pi_desc) && !pi_is_pir_empty(pi_desc));
>  }
>  
> +void vmx_pi_start_assignment(struct kvm *kvm, int device_count)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
> +		return;
> +
> +	/* only care about first device assignment */
> +	if (device_count != 1)
> +		return;
> +
> +	/* Update wakeup vector and add vcpu to blocked_vcpu_list */

Can you expand this comment, too?  Specifically, I think what you're saying is
that the wakeup will cause the vCPU to bail out of kvm_vcpu_block() and go back
through vcpu_block() and thus pi_pre_block().

> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!kvm_vcpu_apicv_active(vcpu))
> +			continue;
> +
> +		kvm_vcpu_kick(vcpu);

Actually, can't we avoid the full kick and instead just do kvm_vcpu_wake_up()?
If the vCPU is in guest mode, i.e. kvm_arch_vcpu_should_kick() returns true,
then by definition it can't be blocking.  And if it about to block, it's
guaranteed to see the assigned device.

> +	}
> +}

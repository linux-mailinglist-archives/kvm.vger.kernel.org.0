Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0BF34647D
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhCWQJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbhCWQIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:08:53 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0079C061574
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 09:08:52 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f10so5112172pgl.9
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 09:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SHe57VVrdBa1bFwRDqVR/he3mxMIJgeI52tgfT4P3Gc=;
        b=bpAbEHhWMOWeo1A4GPrqirZN/9Odu67rl6qzQYkPcBhF2v0cOaLOzz/5mH4x8K+wjg
         zDfK3y9wiLo/J1e736WNT0wTH/sdxCM6Hny902V9/vV6QQBMuu/rdJinXcMxGF4CpQBx
         7OBOWoMjy+Ncu1vVunRBO9Qg1nYcDRTE4aLu748fLJhEx8ChEwmJ9GpBENIV5GcxcQuZ
         9dYKQ3px22s0LxP2BrFr65YA61ormNJcdS48Omz11M/N6KMkuuGa/OLPNhf/ay5fo4J/
         NJ083lVDyWryLejG3+ZiaKPYj+jOfIny839QfdrGLt3Q8UObqjiCd8CK5QYZcuMQ2wTC
         3l6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SHe57VVrdBa1bFwRDqVR/he3mxMIJgeI52tgfT4P3Gc=;
        b=CHnkGH23phDkS3BQwdK0P/ESy+dazIuF/zJlrEWAVxp6tpbj7StnMmUpacWRZGOnT/
         9rYAb5PtPbrcJ9Cg6OaAD9I3zRA3m9Vp2UsOEQvZNJidYrSihUcCxIPEPZ6SvGT2r8vy
         VR1xWtczV5x++WXFHZNbq/otU1mIcymqQD83S4rj+D4uavndq7SbtrLE5HlKAhJ3chTg
         zRdP9BT2C2SGWncs9f+wkAVUji8ccv4pmUqKVz/4+8SpSv/f849h0XAZ0UCgdyGQiwRm
         b2mLK/JS7nYBlbgmQuvwO0Xi+vqxxiGmK2iEx8O9Uv5JnS8zaRc8LsJBktW5KYjMczd1
         R07A==
X-Gm-Message-State: AOAM531e1uHnml9wJE2wKmkj3LptEOI5D5kZcchlWZmu2By0A1HRpVag
        yi0E/QSEe6IB0lZeh5xAb2C6lA==
X-Google-Smtp-Source: ABdhPJwuN7uO+rsS4FbOWNWYA10/SbOjp0fo+EXdCdz0PbJiohWrPxFdSdCMFhj1xsuG4xq0IlbwqA==
X-Received: by 2002:aa7:8d04:0:b029:1ed:2328:f677 with SMTP id j4-20020aa78d040000b02901ed2328f677mr5434917pfe.26.1616515732163;
        Tue, 23 Mar 2021 09:08:52 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a7sm17231034pfo.105.2021.03.23.09.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 09:08:51 -0700 (PDT)
Date:   Tue, 23 Mar 2021 16:08:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wei.huang2@amd.com
Subject: Re: [PATCH] KVM: nSVM: Additions to optimizing L12 to L2 vmcb.save
 copies
Message-ID: <YFoSj9xmCzHe0/X7@google.com>
References: <20210317162930.28135-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317162930.28135-1-cavery@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 17, 2021, Cathy Avery wrote:
> Extend using the vmcb12 control clean field to determine which
> vmcb12.save registers were marked dirty in order to minimize
> register copies by including the CR bit.
> 
> This patch also fixes the init of last_vmcb12_gpa by using an invalid
> physical address instead of 0.
> 
> Tested:
> kvm-unit-tests
> kvm selftests
> Fedora L1 L2
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 9 ++++++---
>  arch/x86/kvm/svm/svm.c    | 2 +-
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 8523f60adb92..6f9a40e002bc 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -449,9 +449,12 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  	}
>  
>  	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
> -	svm_set_efer(&svm->vcpu, vmcb12->save.efer);
> -	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
> -	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
> +
> +	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_CR))) {
> +		svm_set_efer(&svm->vcpu, vmcb12->save.efer);
> +		svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
> +		svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);

This doesn't seem correct.  Regardless of when vmcb12 was last touched, KVM
still needs to set L2's state in vcpu->arch and set the correct MMU context.

> +	}
>  
>  	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 271196400495..41f5cd1009ca 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1234,7 +1234,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	svm->asid = 0;
>  
>  	svm->nested.vmcb12_gpa = 0;
> -	svm->nested.last_vmcb12_gpa = 0;
> +	svm->nested.last_vmcb12_gpa = -1;

INVALID_PAGE would be even better.

>  	vcpu->arch.hflags = 0;
>  
>  	if (!kvm_pause_in_guest(vcpu->kvm)) {
> -- 
> 2.26.2
> 

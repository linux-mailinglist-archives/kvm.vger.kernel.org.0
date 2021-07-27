Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332B93D79A6
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 17:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbhG0PZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 11:25:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232643AbhG0PXh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 11:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627399414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K9vnN9wL7bbivI7Hwt9tBs1nCKBEhS3YAOrtS2yFzAo=;
        b=KRy2++35NySWkyrPA7SwjV68pgvVBJoVv38NqSEkmpTEYAhdx0tfUussUsxK9nfuzeabOm
        um/tSzyL01gmeg6desNdMHFcbJbs0qy/tWFch8BmeSgOKwPEMvdRcLtAVSboqK9L8l7E2k
        u76E+tvHJ61wKhv87f4tjiWHrNZYKgo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-uinpEqkTOt2hwFGDT_MnTQ-1; Tue, 27 Jul 2021 11:23:32 -0400
X-MC-Unique: uinpEqkTOt2hwFGDT_MnTQ-1
Received: by mail-ej1-f70.google.com with SMTP id n9-20020a1709063789b02905854bda39fcso1624632ejc.1
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 08:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=K9vnN9wL7bbivI7Hwt9tBs1nCKBEhS3YAOrtS2yFzAo=;
        b=FcCke/vNiaZj+owB/uwMpRoKhXxSGrHSsTjpS0C++YOulRsYcyNwNqME2r8KdcYYfc
         m54J9kQZ7NXjDaPabDwDUB3dF1+nJYpfSLZhtaqmexfRakj8nYa4S+c5Anc/gU6tOK00
         6F057anwVnC+akdaPGvjNzWo/bJElLXhH+7jbrY38mGnYTaYhRNA6KczW1HL6Tad+TCE
         EoFH84o4knOczYpz/daOIS+Sxc6kIvUX1VyCOZ4w+tH1PQmkjp3kYs2lJX4+HePE5Q4c
         yVMWmSpkj9qe3itV9hZ5856Aazf3LF6/yTJEwTTgxqIlgzqXvlTPdugqoVAfRObfnoFF
         rbhQ==
X-Gm-Message-State: AOAM533AL3vPIBkT4cIVG/tLaCG9ArpBQ1JCqL9zC1oNUYtRBnF4+kKr
        UWsctnnJ1lRd0ERNHpot+sbKPa4u3oEdsE31uRQuZa7n/+hplIvTJ4tOo8wFwlGlclXGLivScAG
        X+JZObt5h+qMhhOCGyo3/j76UyjjTTEzSJZm0Cv4znd0/BJyGz/mDcU8MSdxEyrvJ
X-Received: by 2002:aa7:c956:: with SMTP id h22mr27834809edt.378.1627399411381;
        Tue, 27 Jul 2021 08:23:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziLlMRBKgJ1MU+hRRcFdLOJqyAASXy4lbQBYorQQKdWpyIS4+ytKilfOPL91Ubb5c5gfus2A==
X-Received: by 2002:aa7:c956:: with SMTP id h22mr27834785edt.378.1627399411116;
        Tue, 27 Jul 2021 08:23:31 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l17sm1391591edt.52.2021.07.27.08.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 08:23:30 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: delay svm_vcpu_init_msrpm after svm->vmcb is
 initialized
In-Reply-To: <20210726165843.1441132-1-pbonzini@redhat.com>
References: <20210726165843.1441132-1-pbonzini@redhat.com>
Date:   Tue, 27 Jul 2021 17:23:29 +0200
Message-ID: <87zgu76ary.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Right now, svm_hv_vmcb_dirty_nested_enlightenments has an incorrect
> dereference of vmcb->control.reserved_sw before the vmcb is checked
> for being non-NULL.  The compiler is usually sinking the dereference
> after the check; instead of doing this ourselves in the source,
> ensure that svm_hv_vmcb_dirty_nested_enlightenments is only called
> with a non-NULL VMCB.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Vineeth Pillai <viremana@linux.microsoft.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [Untested for now due to issues with my AMD machine. - Paolo]

At least this doesn't seem to break kvm-amd on bare metal, so

Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> ---
>  arch/x86/kvm/svm/svm.c          | 4 ++--
>  arch/x86/kvm/svm/svm_onhyperv.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9a6987549e1b..4bcb95bb8ed7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1406,8 +1406,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  		goto error_free_vmsa_page;
>  	}
>  
> -	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
> -
>  	svm->vmcb01.ptr = page_address(vmcb01_page);
>  	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
>  
> @@ -1419,6 +1417,8 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	svm_switch_vmcb(svm, &svm->vmcb01);
>  	init_vmcb(vcpu);
>  
> +	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
> +
>  	svm_init_osvw(vcpu);
>  	vcpu->arch.microcode_version = 0x01000065;
>  
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> index 9b9a55abc29f..c53b8bf8d013 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -89,7 +89,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenments(
>  	 * as we mark it dirty unconditionally towards end of vcpu
>  	 * init phase.
>  	 */
> -	if (vmcb && vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
> +	if (vmcb_is_clean(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS) &&
>  	    hve->hv_enlightenments_control.msr_bitmap)
>  		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
>  }

-- 
Vitaly


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3551B4627FA
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 00:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhK2XRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 18:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbhK2XRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 18:17:13 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760FFC0C20C9
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 15:00:05 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id r5so17610475pgi.6
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 15:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fu57TmLlacgYPf1On7AJdZQDIqIw6tfTDvKlTzKuCCQ=;
        b=h8RXa6MGjRYFDY/r/0egR75GDPpGDGpT5L7xHWN6UzvVpvnSrRCJLMxl1F0gCbRtFY
         GRF+458D5I55trFqqhX8K+Ok4WRamtugq3z6L/mOp2aLe/J2FVpdQxRs5T4dzo5O54pJ
         NQtyQ5hLkKzFTT02U66S9dj1BAoCFeMWwVERQNd4rAElvrU/CXcQTme+8O4kWDxe/k4h
         E41XADu0f9BMuUTg01OkOhlMIxXEjfuSTsAJNNYpKVsw6lXEPMT4s4NQbvKKC9UiVFzc
         u2ulo1h8HFPoR0/p8csc4dcWMY4xF2cYF5s3IJ2+O9bmaYSSulIYLrvEWD1NELp9mxBM
         GDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fu57TmLlacgYPf1On7AJdZQDIqIw6tfTDvKlTzKuCCQ=;
        b=NeMZlPqsCcXtC8AiYGxQNHXFArJrb0gFQz2c1GQiDgddP8wrq5+o2K6do6FsdYeZmK
         2mniGt882umgb49Nn0IsnIj4dU4wbtUKROnXmxTXHLQ8l69p2rwqhVraVB6SwUpg7e3b
         o5E+ki8DBHzClReuLb/bXCpfyd8jVqB6Ga4bZnfy5PhYGsdSmeUHb6l9VbJPbPBc/l+q
         9j+P8edfD3lcNdm0o6uR8T241uATZ+rNi4g0H6/drwn7M4m8cd/0nuq22979zvaxAoGq
         TUac5RhckFxjweVIbDQzpoBJFoUAxjPGcy7nH2Uif4uI3LuDdUH2cSYiUgvRnDtqf0/l
         HZdQ==
X-Gm-Message-State: AOAM530g/Dvx5ULqcB1BqqWovODErAcwz4gQX5/A1Q3dPKNqRp+O0zYD
        cw7YchNNaU//TmdJKXVmMtF7gQ==
X-Google-Smtp-Source: ABdhPJw7Ce/D+YHRgeYrsg6zB7J9MzmwYmG2A457xSiIQhaiOSF/JBCR8dYBhYTa4kHZF+HNTjJAUw==
X-Received: by 2002:a62:52cd:0:b0:49f:a7b8:69ad with SMTP id g196-20020a6252cd000000b0049fa7b869admr42592576pfb.3.1638226804702;
        Mon, 29 Nov 2021 15:00:04 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q10sm987064pjd.0.2021.11.29.15.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:00:03 -0800 (PST)
Date:   Mon, 29 Nov 2021 23:00:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pgonda@google.com
Subject: Re: [PATCH 06/12] KVM: SEV: initialize regions_list of a mirror VM
Message-ID: <YaVbcJ1lxIeEUBE1@google.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
 <20211123005036.2954379-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211123005036.2954379-7-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Paolo Bonzini wrote:
> This was broken before the introduction of KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM,
> but technically harmless because the region list was unused for a mirror
> VM.  However, it is untidy and it now causes a NULL pointer access when
> attempting to move the encryption context of a mirror VM.
> 
> Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 23a4877d7bdf..dc974c1728b6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2004,6 +2004,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  	mirror_sev->fd = source_sev.fd;
>  	mirror_sev->es_active = source_sev.es_active;
>  	mirror_sev->handle = source_sev.handle;
> +	INIT_LIST_HEAD(&mirror_sev->regions_list);


Heh, I still think the list should be initialized when the VM is created.

On Wed, Feb 24, 2021 at 9:37 AM Sean Christopherson <seanjc@google.com> wrote:

> > +     mutex_unlock(&kvm->lock);
> > +     mutex_lock(&mirror_kvm->lock);
> > +
> > +     /* Set enc_context_owner and copy its encryption context over */
> > +     mirror_kvm_sev = &to_kvm_svm(mirror_kvm)->sev_info;
> > +     mirror_kvm_sev->enc_context_owner = kvm;
> > +     mirror_kvm_sev->asid = asid;
> > +     mirror_kvm_sev->active = true;
>
> I would prefer a prep patch to move "INIT_LIST_HEAD(&sev->regions_list);" from
> sev_guest_init() to when the VM is instantiated.  Shaving a few cycles in that
> flow is meaningless, and not initializing the list of regions is odd, and will
> cause problems if mirrors are allowed to pin memory (or do PSP commands).



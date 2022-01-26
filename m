Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE9449CF03
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 16:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiAZP4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 10:56:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232848AbiAZP4F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 10:56:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643212565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FJWfgd90wDJ2caykgoOLYgRtS2Ouj0kY/I7mDEGleaM=;
        b=PFsO1Nw9B3Y7WPti18QPRwchp+u2QqgBxCZ+jQgYvBJzBSSQhtlHRiDN4pEDq548ysySbz
        bkBf+vcGG7zckPPeVIz4Lc8SaVeF5Ugbl8wleG/3GYN8qlvGXeltv5ZaqNKZllvNPxPAul
        JvapjCz+KKCFLuKpYpl7CrE5Yvop+/0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-FHqbJ4J7NpqqDizAGiNOIg-1; Wed, 26 Jan 2022 10:56:03 -0500
X-MC-Unique: FHqbJ4J7NpqqDizAGiNOIg-1
Received: by mail-wr1-f72.google.com with SMTP id g6-20020adfbc86000000b001a2d62be244so4474725wrh.23
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 07:56:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FJWfgd90wDJ2caykgoOLYgRtS2Ouj0kY/I7mDEGleaM=;
        b=uwa0O4TKXYQxwGn+gU9Hyw1Ptj+thEFGLsQVxsyYwwA9iyQ/id2G3o/vbtluF56aL9
         dSSkgCPaAboCB7lVoqy/laeaPIiYUJAeFRdPmB7r2O25Ujyjq3/hV6i2CulvBGtEmP8G
         YRufJPfi4utPiCtm8U1lxnkH8+7Q8YMZ4B64936i9hAmpD2OxYu/38K3xDBjgDHip8Sb
         bQmLcpAv02MpJzPU6gMbuqjNsGLZ4KYhsznNfS+V6sXgWiHacnqMmo7CifRw6V82V+Pv
         ZZ5+QV/50sd61Hf6CC87xzPW8JPE7UeM1oFPuMGWG+MST6LlHamYQjoAJIFN3P4I3Pjx
         EL1g==
X-Gm-Message-State: AOAM530NKllKTh8IXCawkmzwPTN4UNHZgkdeHCXo7aR5wotiJMCbKtRx
        ta8XsqBQXjCuEyJC86dXe19At0dOXk7oMtyIXhTCbHWXGElH2UhqI+P/rs2nt+hLGjQQ/UIVYij
        M5vGpfTyqHFT4
X-Received: by 2002:a05:600c:3551:: with SMTP id i17mr7941088wmq.21.1643212562440;
        Wed, 26 Jan 2022 07:56:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwRQ8DNnI8KrRxxFt7FdCM/y7wG2icqG9UafMU81NHIVWpIdY0LeJq8CZHEpbDd1boleaNUkA==
X-Received: by 2002:a05:600c:3551:: with SMTP id i17mr7941071wmq.21.1643212562161;
        Wed, 26 Jan 2022 07:56:02 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l15sm3328294wmh.6.2022.01.26.07.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 07:56:01 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: WARN on any attempt to allocate shadow VMCS
 for vmcs02
In-Reply-To: <20220125220527.2093146-1-seanjc@google.com>
References: <20220125220527.2093146-1-seanjc@google.com>
Date:   Wed, 26 Jan 2022 16:56:00 +0100
Message-ID: <87r18uh4of.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> WARN if KVM attempts to allocate a shadow VMCS for vmcs02.  KVM emulates
> VMCS shadowing but doesn't virtualize it, i.e. KVM should never allocate
> a "real" shadow VMCS for L2.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f235f77cbc03..92ee0d821a06 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4851,18 +4851,20 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
>  	struct loaded_vmcs *loaded_vmcs = vmx->loaded_vmcs;
>  
>  	/*
> -	 * We should allocate a shadow vmcs for vmcs01 only when L1
> -	 * executes VMXON and free it when L1 executes VMXOFF.
> -	 * As it is invalid to execute VMXON twice, we shouldn't reach
> -	 * here when vmcs01 already have an allocated shadow vmcs.
> +	 * KVM allocates a shadow VMCS only when L1 executes VMXON and frees it
> +	 * when L1 executes VMXOFF or the vCPU is forced out of nested
> +	 * operation.  VMXON faults if the CPU is already post-VMXON, so it
> +	 * should be impossible to already have an allocated shadow VMCS.  KVM
> +	 * doesn't support virtualization of VMCS shadowing, so vmcs01 should
> +	 * always be the loaded VMCS.
>  	 */
> -	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
> +	if (WARN_ON(loaded_vmcs != &vmx->vmcs01 || loaded_vmcs->shadow_vmcs))
> +		return loaded_vmcs->shadow_vmcs;

Stupid question: why do we want to care about 'loaded_vmcs' at all,
i.e. why can't we hardcode 'vmx->vmcs01' in alloc_shadow_vmcs()? The
only caller is enter_vmx_operation() and AFAIU 'loaded_vmcs' will always
be pointing to 'vmx->vmcs01' (as enter_vmx_operation() allocates
&vmx->nested.vmcs02 so 'loaded_vmcs' can't point there!).

> +
> +	loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
> +	if (loaded_vmcs->shadow_vmcs)
> +		vmcs_clear(loaded_vmcs->shadow_vmcs);
>  
> -	if (!loaded_vmcs->shadow_vmcs) {
> -		loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
> -		if (loaded_vmcs->shadow_vmcs)
> -			vmcs_clear(loaded_vmcs->shadow_vmcs);
> -	}
>  	return loaded_vmcs->shadow_vmcs;
>  }
>  
>
> base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33

-- 
Vitaly


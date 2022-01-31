Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBACE4A4BB1
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 17:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380256AbiAaQUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 11:20:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380236AbiAaQTu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Jan 2022 11:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643645988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7XAQrszQc36R3ke0TAxdHZ08nKa5sNGKhk1YO8Fovj8=;
        b=IFFS7/Tl7usmJHDERSWl9Vae2UapkbnZffdG8fqSG97S419uja5PZUvbhO2h0aq8bChGhs
        Y0EVyadYua+XF+qBPH214IHrKiJXX2YdTeUdsWZGSLKmsdRl4pDyjX5DMK6i98E+lM0yn2
        QBAPAe/tCeTOiOWHj+Uo6yWZlIiZqQE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-MRH6j-CAPV-sIB7UZTVsSA-1; Mon, 31 Jan 2022 11:19:47 -0500
X-MC-Unique: MRH6j-CAPV-sIB7UZTVsSA-1
Received: by mail-wm1-f72.google.com with SMTP id 7-20020a1c1907000000b003471d9bbe8dso99516wmz.0
        for <kvm@vger.kernel.org>; Mon, 31 Jan 2022 08:19:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7XAQrszQc36R3ke0TAxdHZ08nKa5sNGKhk1YO8Fovj8=;
        b=C4BDmc8mTlOgNLWwpE0DnPyU0ISEpTTxO8CmuAGsNgrmJdoui+UyvNsfhO8OmwXdX4
         1sjyyV/E55uyk8pcPwTxtKUbKEc5Y9lbyHUv1JmXzbIyeTzuba6VniPIKgTRt3eGnoSe
         hrqEwY5457XKccA52BE4tHIsdRhi987fpcVa0B41z8u1YqL02C4tRAJFN8LJRvPoPFlC
         JQOyGQi/WP5EMrmhE/25L6ZiKGiJermobi21xQTDmc6HhqZtHJS+NBgLk9rAuA8TdYjw
         JHyrqBWIMDgs/KVDh+/cisGOchbiyAuWvEVpFRzkeZeaJO4NPzx0HxOTabVuGHu4AfGt
         iPXw==
X-Gm-Message-State: AOAM533Z+YR4TPDUcWjti8j9H+HOMZeNw8xTyYQB6YCKS6e9/BzytE/e
        vMbUndqwA6OppB03ClH2/76bEGPTnpw3u55SgsfK0RDL3zOOIcClV58P7dIEObk7XHXYIhyUKa+
        BUneQA33nviBg
X-Received: by 2002:a5d:59a2:: with SMTP id p2mr17317640wrr.664.1643645986193;
        Mon, 31 Jan 2022 08:19:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjTqFOp4VER/3BLKVfseVZxxqwlCXqz39uMizZQGUFjVQiLnivMq8zfHMjAGzTIq/UZ02yGg==
X-Received: by 2002:a5d:59a2:: with SMTP id p2mr17317622wrr.664.1643645985976;
        Mon, 31 Jan 2022 08:19:45 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y3sm14007593wry.109.2022.01.31.08.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 08:19:45 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 09/22] KVM: x86: Uninline and export hv_track_root_tdp()
In-Reply-To: <20220128005208.4008533-10-seanjc@google.com>
References: <20220128005208.4008533-1-seanjc@google.com>
 <20220128005208.4008533-10-seanjc@google.com>
Date:   Mon, 31 Jan 2022 17:19:44 +0100
Message-ID: <87ee4ng9nj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Uninline and export Hyper-V's hv_track_root_tdp(), which is (somewhat
> indirectly) the last remaining reference to kvm_x86_ops from vendor
> modules, i.e. will allow unexporting kvm_x86_ops.  Reloading the TDP PGD
> isn't the fastest of paths, hv_track_root_tdp() isn't exactly tiny, and
> disallowing vendor code from accessing kvm_x86_ops provides nice-to-have
> encapsulation of common x86 code (and of Hyper-V code for that
> matter).

We can add a static branch for "kvm_x86_ops.tlb_remote_flush ==
hv_remote_flush_tlb" condition and check it in vendor modules prior to
calling into hv_track_root_tdp() but I seriously doubt it'll bring us
noticable performance gain.

>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/kvm_onhyperv.c | 14 ++++++++++++++
>  arch/x86/kvm/kvm_onhyperv.h | 14 +-------------
>  2 files changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
> index b469f45e3fe4..ee4f696a0782 100644
> --- a/arch/x86/kvm/kvm_onhyperv.c
> +++ b/arch/x86/kvm/kvm_onhyperv.c
> @@ -92,3 +92,17 @@ int hv_remote_flush_tlb(struct kvm *kvm)
>  	return hv_remote_flush_tlb_with_range(kvm, NULL);
>  }
>  EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
> +
> +void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
> +{
> +	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
> +
> +	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
> +		spin_lock(&kvm_arch->hv_root_tdp_lock);
> +		vcpu->arch.hv_root_tdp = root_tdp;
> +		if (root_tdp != kvm_arch->hv_root_tdp)
> +			kvm_arch->hv_root_tdp = INVALID_PAGE;
> +		spin_unlock(&kvm_arch->hv_root_tdp_lock);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(hv_track_root_tdp);
> diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
> index 1c67abf2eba9..287e98ef9df3 100644
> --- a/arch/x86/kvm/kvm_onhyperv.h
> +++ b/arch/x86/kvm/kvm_onhyperv.h
> @@ -10,19 +10,7 @@
>  int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  		struct kvm_tlb_range *range);
>  int hv_remote_flush_tlb(struct kvm *kvm);
> -
> -static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
> -{
> -	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
> -
> -	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
> -		spin_lock(&kvm_arch->hv_root_tdp_lock);
> -		vcpu->arch.hv_root_tdp = root_tdp;
> -		if (root_tdp != kvm_arch->hv_root_tdp)
> -			kvm_arch->hv_root_tdp = INVALID_PAGE;
> -		spin_unlock(&kvm_arch->hv_root_tdp_lock);
> -	}
> -}
> +void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
>  #else /* !CONFIG_HYPERV */
>  static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
>  {

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


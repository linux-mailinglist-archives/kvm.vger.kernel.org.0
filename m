Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80007C7705
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 21:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442355AbjJLTh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 15:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442344AbjJLThZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 15:37:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3F0DD
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697139400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f40ECg2BWJ+FRhYEW/MQ1+sUR8MJ/9jI0RjlSlj5qW8=;
        b=VrxCpF+dSapDX5I6M5VIZO1u8HLI9JTMSZIKRhI4Ak/sfM5fIqiaT4JBwVU/DSvbzN02BW
        dQ4Jc3cCFArVpu8w1/luydBJcUGQeMXeD5X90+/Wxazod7xl1Dbx+ItnjKi4rVZwYIC5yK
        BnrlE7AHPPLNuehFBSrrPz4Fxng0jX0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-l049FDXdMoWVYDQlQVXflQ-1; Thu, 12 Oct 2023 15:36:39 -0400
X-MC-Unique: l049FDXdMoWVYDQlQVXflQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-405917470e8so10380555e9.1
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697139398; x=1697744198;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f40ECg2BWJ+FRhYEW/MQ1+sUR8MJ/9jI0RjlSlj5qW8=;
        b=IX92VqHYfcWNfPN9FKwESoFvW3Wq6Y8EvAxBmr/92p1efHSXNfUkQiQK/fdHqF+kia
         kvM9K2lBx1w/P0WwxPBEEyDKh4l8c5wSbVfUzeGy5I+Znr2U4lnFx7+Dzp+qvrnZsfbK
         Ff4uspJmEd1Ic3n+/TBEbaFmw2mMRFdf6KqwDNsbX9o56c1OFzycCiFu/CyGlE15onPT
         7gS9MQqWshHm+tQkJziXly7H5zladMNVNrRfhZaI5kLTXK/j17OcXE1l45UnZhj7imA6
         CAzTaylNLmMvmI6GjlVRBIe37Ha8pqsq6mRw7XpsLbJ3+IjFA1jCFdcKjUrwPr8AHc1L
         ZgfA==
X-Gm-Message-State: AOJu0YwjLa8Hrzf40xxsi4X4bCdKwxFVHaQD4L0Su9WNmSZcWW5ksl85
        rxPAF6t441s4YS9lefzHLC/KsiTcyaZkA3tsBkRqgSKW1UVxdv205FGYU4b/riBgWlmpzYpPvn8
        WSke47YmOWyAPK/IEw0eY
X-Received: by 2002:a1c:7917:0:b0:3fb:feb0:6f40 with SMTP id l23-20020a1c7917000000b003fbfeb06f40mr23240695wme.11.1697139397876;
        Thu, 12 Oct 2023 12:36:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwadNAgttPxV0+UD0jmESSywtk0s36O+gYzlhFpxwuzDHEcy2VicR1G1Q2hAR/jVG2e54dLA==
X-Received: by 2002:a1c:7917:0:b0:3fb:feb0:6f40 with SMTP id l23-20020a1c7917000000b003fbfeb06f40mr23240687wme.11.1697139397633;
        Thu, 12 Oct 2023 12:36:37 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c248800b0040472ad9a3dsm628108wms.14.2023.10.12.12.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 12:36:37 -0700 (PDT)
Message-ID: <ccea65f81ed5530189f2d24af7c16158cf5ee1cd.camel@redhat.com>
Subject: Re: [PATCH RFC 04/11] KVM: x86: hyper-v: Introduce
 kvm_hv_synic_auto_eoi_set()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Date:   Thu, 12 Oct 2023 22:36:35 +0300
In-Reply-To: <20231010160300.1136799-5-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
         <20231010160300.1136799-5-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-10-10 у 18:02 +0200, Vitaly Kuznetsov пише:
> As a preparation to making Hyper-V emulation optional, create a dedicated
> kvm_hv_synic_auto_eoi_set() helper to avoid extra ifdefs in lapic.c
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.h | 5 +++++
>  arch/x86/kvm/lapic.c  | 2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index f83b8db72b11..1897a219981d 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -105,6 +105,11 @@ int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
>  void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
>  int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
>  
> +static inline bool kvm_hv_synic_auto_eoi_set(struct kvm_vcpu *vcpu, int vector)
> +{
> +	return to_hv_vcpu(vcpu) && test_bit(vector, to_hv_synic(vcpu)->auto_eoi_bitmap);
> +}
> +
>  void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu);
>  
>  bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index dcd60b39e794..0e80c1fdf899 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2899,7 +2899,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
>  	 */
>  
>  	apic_clear_irr(vector, apic);
> -	if (to_hv_vcpu(vcpu) && test_bit(vector, to_hv_synic(vcpu)->auto_eoi_bitmap)) {
> +	if (kvm_hv_synic_auto_eoi_set(vcpu, vector)) {
>  		/*
>  		 * For auto-EOI interrupts, there might be another pending
>  		 * interrupt above PPR, so check whether to raise another

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


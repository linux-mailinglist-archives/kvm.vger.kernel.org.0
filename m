Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF6B7C7708
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 21:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442481AbjJLThk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 15:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442393AbjJLThh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 15:37:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A99E6
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697139411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LmGTrpqewTswoSpR8DSjj/XKiSXLuGXnUJ07rtGjW3w=;
        b=GmE4YdRIuDACklyF0O4QEJr2riVuLOo84p1FLChuULB1tOC6T0lYhcucZQ6bjLseQRs1sv
        bdGJiPe7psZkUfqJX8zhMcMSKVF9uJApsZ9vAaNkd7VKSeUNNeuoP4ILkQgc4lcxbUuTbk
        pTqMxVf53PQW+tTpPTJMj8zsmTeY0wo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-vFrLOrdvNS28l3hK0C-pJg-1; Thu, 12 Oct 2023 15:36:49 -0400
X-MC-Unique: vFrLOrdvNS28l3hK0C-pJg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4067f186094so9483875e9.1
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697139408; x=1697744208;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LmGTrpqewTswoSpR8DSjj/XKiSXLuGXnUJ07rtGjW3w=;
        b=wwUMAgW6XtqpyGAQmjvsSgA8sVsbGSeL8yy1vAivjVCk4Po/E36EnKvJk0RSAL8347
         xdBkTnNpNk40c5+QAZLl8TgMAXkrEWgtlZhh+LPi15WaYB8g3o1co4aLs2iTRh80JoXb
         uxYAxALnBPs4WWz4WS3OAKhROYoDUJo98TXaSYlUjay/P/LK3E7Cqto/SoWuBlIHD/rL
         r5TV7Tw1wM5+LLqYCT3lJgGAbxBL5wjBIhrb3w5TzSRL6kipa987fOr7AN61NkE16cZH
         0044N2LH1btsDSoU4hBEMjcG+/PoOXNO1I1XcOH31qCxhh3i/BF5BYQ0bE2KstkoPjvQ
         5M1Q==
X-Gm-Message-State: AOJu0YzCWyroWSvlwMashND9jfSX4JPO/fXf9EEINvZ6dJhlmmOmes45
        Oa8E5aUT0QRB4DDewdycZTRmjCBbYAx6/lBMM1W1x6hsouDOixRGXiPeVbmMYdP85Y0mxqRKKhU
        LRLlYR4L1XAnC/KiNDntt
X-Received: by 2002:a7b:cd0a:0:b0:405:3ae6:2400 with SMTP id f10-20020a7bcd0a000000b004053ae62400mr22255826wmj.23.1697139408474;
        Thu, 12 Oct 2023 12:36:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOAOzz/cLP+Oxa/tpzHOxH6BXt14cWwi5HOdf5y4AwQ3CspFA5TqiBHR+WxotrzT8LKLVTQw==
X-Received: by 2002:a7b:cd0a:0:b0:405:3ae6:2400 with SMTP id f10-20020a7bcd0a000000b004053ae62400mr22255808wmj.23.1697139408172;
        Thu, 12 Oct 2023 12:36:48 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id 1-20020a05600c020100b003feea62440bsm604911wmi.43.2023.10.12.12.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 12:36:47 -0700 (PDT)
Message-ID: <e9092c88813a9cfa9d02928eb818788a0af1147c.camel@redhat.com>
Subject: Re: [PATCH RFC 05/11] KVM: x86: hyper-v: Introduce
 kvm_hv_synic_has_vector()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Date:   Thu, 12 Oct 2023 22:36:46 +0300
In-Reply-To: <20231010160300.1136799-6-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
         <20231010160300.1136799-6-vkuznets@redhat.com>
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
> kvm_hv_synic_has_vector() helper to avoid extra ifdefs in lapic.c.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.h | 5 +++++
>  arch/x86/kvm/lapic.c  | 3 +--
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 1897a219981d..ddb1d0b019e6 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -105,6 +105,11 @@ int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
>  void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
>  int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
>  
> +static inline bool kvm_hv_synic_has_vector(struct kvm_vcpu *vcpu, int vector)
> +{
> +	return to_hv_vcpu(vcpu) && test_bit(vector, to_hv_synic(vcpu)->vec_bitmap);
> +}
> +
>  static inline bool kvm_hv_synic_auto_eoi_set(struct kvm_vcpu *vcpu, int vector)
>  {
>  	return to_hv_vcpu(vcpu) && test_bit(vector, to_hv_synic(vcpu)->auto_eoi_bitmap);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0e80c1fdf899..37904c5d421b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1475,8 +1475,7 @@ static int apic_set_eoi(struct kvm_lapic *apic)
>  	apic_clear_isr(vector, apic);
>  	apic_update_ppr(apic);
>  
> -	if (to_hv_vcpu(apic->vcpu) &&
> -	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
> +	if (kvm_hv_synic_has_vector(apic->vcpu, vector))
>  		kvm_hv_synic_send_eoi(apic->vcpu, vector);
>  
>  	kvm_ioapic_send_eoi(apic, vector);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com

Best regards,
	Maxim Levitsky


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85856616CD
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 17:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbjAHQmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 11:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbjAHQm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 11:42:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAAAFCFB
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 08:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673196101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4s/QZKVUjJInw3dpc/keTZ8lxnmM7v0FokGT4KsySWM=;
        b=edEhfyfdGiXjAuK+lXuhYDSSz6xcNP7z2WMtOOXqS8xPRtuNBBpcdo2IV7vPKa0+WEjbcD
        ebhbq5CscfHWZ2vBaHf+uAP8MCbbn1OTrEQYwLQmKtWDburu8GjVrGAysxImARjhVOg9Y6
        hVkhnL+oQlM6f+t6VrrJSOME1nwbXyw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-613-EEQNPh5TNliB19mXmrOhlA-1; Sun, 08 Jan 2023 11:41:39 -0500
X-MC-Unique: EEQNPh5TNliB19mXmrOhlA-1
Received: by mail-ej1-f70.google.com with SMTP id dn11-20020a17090794cb00b007c14ea70afcso3970415ejc.0
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 08:41:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4s/QZKVUjJInw3dpc/keTZ8lxnmM7v0FokGT4KsySWM=;
        b=iaCE8LgXn09BPRXr8Jo+EYXIU+fJiBtsOIn+gEAc6tYp+azsaZdoY+o/0ShG6Mnzpv
         HczL9xZdY5FAxf+QQrfR7r5QlvsBE8/Rl9+D+IuRx9pBetCAhuhUQQ4F8IXx3WIPxitG
         dPXMK6LPmShoONky5lqphk6URQR0eFWaypab0EFFgvguv4j0MPrmecfuDJ93cJnKG5ge
         fYuSsBBW+Ljjn3wQlmzCD1M6AKywzvWdcGZUk0YsPam/2ZVbYzj+9NO7zXVoygYboB3D
         33VdNmrVf0ZCLfmvjGtSKMl0IRnW0xJwTpEH5U5JLeWqhxy2GqF3i3a4l8q7HjOoM4mV
         mAsg==
X-Gm-Message-State: AFqh2kqrHzHrLeeOIFycBl8+CdE7en6iu6TiFbLjOTfPuQgCPBBKq/2H
        E5MwCblpy3mC2RxAKEOYyI3Az2xXeqn/rg+v9bxLjJ+vMPUgN4bw3gAsg3FxOhFHgc977ChniFy
        fsbN2H4O2qA1I
X-Received: by 2002:a17:906:92c4:b0:82d:e2a6:4b1e with SMTP id d4-20020a17090692c400b0082de2a64b1emr62874112ejx.47.1673196098421;
        Sun, 08 Jan 2023 08:41:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtQ/bAa3HUi/l5qV9b+adt9SPqwBY82YCtGPImcLOPPIbwX5OYijW/0pkUMWru9iPtkLQTQ5g==
X-Received: by 2002:a17:906:92c4:b0:82d:e2a6:4b1e with SMTP id d4-20020a17090692c400b0082de2a64b1emr62874102ejx.47.1673196098243;
        Sun, 08 Jan 2023 08:41:38 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id lb6-20020a170907784600b007ad69e9d34dsm2682045ejc.54.2023.01.08.08.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 08:41:37 -0800 (PST)
Message-ID: <d1dd4636735912700198cfade57670a968ce433f.camel@redhat.com>
Subject: Re: [PATCH 2/6] KVM: x86: Inject #GP on x2APIC WRMSR that sets
 reserved bits 63:32
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Sun, 08 Jan 2023 18:41:36 +0200
In-Reply-To: <20230107011025.565472-3-seanjc@google.com>
References: <20230107011025.565472-1-seanjc@google.com>
         <20230107011025.565472-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-07 at 01:10 +0000, Sean Christopherson wrote:
> Reject attempts to set bits 63:32 for 32-bit x2APIC registers, i.e. all
> x2APIC registers except ICR.  Per Intel's SDM:
> 
>   Non-zero writes (by WRMSR instruction) to reserved bits to these
>   registers will raise a general protection fault exception
> 
> Opportunistically fix a typo in a nearby comment.
> 
> Reported-by: Marc Orr <marcorr@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f77da92c6ea6..bf53e4752f30 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3108,13 +3108,17 @@ static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
>  static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
>  {
>  	/*
> -	 * ICR is a 64-bit register in x2APIC mode (and Hyper'v PV vAPIC) and
> +	 * ICR is a 64-bit register in x2APIC mode (and Hyper-V PV vAPIC) and
>  	 * can be written as such, all other registers remain accessible only
>  	 * through 32-bit reads/writes.
>  	 */
>  	if (reg == APIC_ICR)
>  		return kvm_x2apic_icr_write(apic, data);
>  
> +	/* Bits 63:32 are reserved in all other registers. */
> +	if (data >> 32)
> +		return 1;
> +
>  	return kvm_lapic_reg_write(apic, reg, (u32)data);
>  }
>  
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


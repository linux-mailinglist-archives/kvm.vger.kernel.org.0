Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8B47C5A0D
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 19:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbjJKRHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 13:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbjJKRHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 13:07:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131318F
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697044011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6zT0LIXBuOC5NElULkdQF6S1xpV1tOLufDMDSGepFKw=;
        b=W5RgdN3Epax82nKR3d3y4T85o1kIZOaFLO9/HVOLHQbbSrywcQM+l+Dtwye1Qm0iqagzXR
        j2iOX6np+rtVjsHKIo5F5oTnUvD98fkopLnqv4AAfQMbWRnYzxTkgCBL4+wf0uBGh3voBQ
        qq96jcaDqkPIoKAiY/dr3348qqR05vk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-5KsDuoMhOGuAJf8HcSE6_g-1; Wed, 11 Oct 2023 13:06:50 -0400
X-MC-Unique: 5KsDuoMhOGuAJf8HcSE6_g-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9a9e12a3093so792266b.0
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:06:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697044009; x=1697648809;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6zT0LIXBuOC5NElULkdQF6S1xpV1tOLufDMDSGepFKw=;
        b=RUhXU52CKrRYlyP2ooOyJr+Kf9cSOUIpB3SZamaol7tTU2c6yxUXWf8uqViMk+F4YC
         bnZbeL/5rOw+S8NoPdzSoa59IbewMPRJxpIjeFvKQBF/6S70hd6v7JUORj+4777/lQkQ
         OkyZmUz7LomEdjN6MIk8X6Xj8Fc9miRqDSz3EVHAzQ3k4GUQTV+ewmht6scbCJLe9wvC
         44v47XPDrAcgQBkCZt/DU9EJw6ec/otcoQxocnHuw+U1FGOCplnJEoNaJXQqXToL7Db3
         I6evhCm7HX7ESrMHvUcGXmOThD3PcCPFs//RLAiqmQi2j2ASRr1L/msjPSETakHqMxvu
         un4Q==
X-Gm-Message-State: AOJu0YyZ76t3Jx5DgOwRjoEpNTqJfkcQIpZxiMz2CsO4TMjsVkoNoK8Q
        Uroardil5HB0dpTSYW/sEhvkEq5SAgjHcNRTiPFNQWXRRoAREkaDMETqxUt4NyaztT3ar9XxZxd
        ZGHMkR5lp4lUe
X-Received: by 2002:a17:906:112:b0:9ae:659f:4d2f with SMTP id 18-20020a170906011200b009ae659f4d2fmr16048859eje.26.1697044008615;
        Wed, 11 Oct 2023 10:06:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG110ZfGjqS/lhxCsUEJ9ZUagxghpUIUjj6SDYUbMoZ1DpwrxbCBuPohPB3JOw7GrP4TPWPZw==
X-Received: by 2002:a17:906:112:b0:9ae:659f:4d2f with SMTP id 18-20020a170906011200b009ae659f4d2fmr16048840eje.26.1697044008229;
        Wed, 11 Oct 2023 10:06:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id pw1-20020a17090720a100b009ada9f7217asm9898446ejb.88.2023.10.11.10.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Oct 2023 10:06:47 -0700 (PDT)
Message-ID: <3b7bb7a5-a8c9-d5b9-7221-d2a03ce49f84@redhat.com>
Date:   Wed, 11 Oct 2023 19:06:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Bartosz Szczepanek <bsz@amazon.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <b46ee4de968733a69117458e9f8f9d2a6682376f.camel@infradead.org>
 <ZSXdYcMUds-DrHAd@google.com>
 <7fba6d8fc3de0bcb86bf629a4f5b0217552fe999.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] KVM: x86: Don't wipe TDP MMU when guest sets %cr4
In-Reply-To: <7fba6d8fc3de0bcb86bf629a4f5b0217552fe999.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/23 10:20, David Woodhouse wrote:
> But __kvm_mmu_refresh_passthrough_bits() only refreshes
> role.base.cr0_wp and not the other two. Do we need this?
> 
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5159,6 +5159,8 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
>                  return;
>   
>          mmu->cpu_role.base.cr0_wp = cr0_wp;
> +       mmu->cpu_role.base.smep_andnot_wp = mmu->cpu_role.ext.cr4_smep && !cr0_wp;
> +       mmu->cpu_role.base.smap_andnot_wp = mmu->cpu_role.ext.cr4_smap && !cr0_wp;
>          reset_guest_paging_metadata(vcpu, mmu);
>   }

{smep,smap}_andnot_wp only matter for shadow paging.  You can remove 
them from this function, and instead assign which is not called for 
shadow paging anyway, and set them in the root_role in kvm_init_shadow_mmu.

Paolo


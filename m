Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8757559C918
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 21:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbiHVTkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 15:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiHVTkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 15:40:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD8348C9A
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 12:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661197212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PrW6FQ33VHjaFPww6I50ua2R22m09A1ZPI8tkRBeC24=;
        b=Mr9ChQo4NC26DMBt36HlE5lzAiaQF8ip0+4+zMz34TT29P+4lTrRtp4VS4pRgzBcuRXuLB
        nNrH6OLf5TohT1sC0DmgvkdCPb2ieR2QwNQ2NlM0LhqNLukUM2HMqLx6mK18WXgMc/ypm4
        hkxmph1Nr1dHpnnTn7ijE4sr9gUoRGU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-18aZJSJXPCKK2XhWOdbAIQ-1; Mon, 22 Aug 2022 15:40:11 -0400
X-MC-Unique: 18aZJSJXPCKK2XhWOdbAIQ-1
Received: by mail-ed1-f69.google.com with SMTP id y10-20020a056402358a00b00446da94e669so1766512edc.3
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 12:40:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=PrW6FQ33VHjaFPww6I50ua2R22m09A1ZPI8tkRBeC24=;
        b=bDG0vBP7cawbPxbkV/vEGLZnUSdxdzdhqDVHDM+ZSGYWVBiXpzPCPYF9BjScVP1QPM
         n8/paQyfgzAvFUxTf8gpnJXcExV4E6XELC1c+RmTSEe+HT04CEVaVW/sbKhJs7hzNvmZ
         LQlQdpDamEklBmxOD4B0BoC1z/3/ksvJaSD2sHKE4eGbKSaWwk3Ec9b37BQUYdozJLGW
         uCCN2bYdD5TiiCa6ErG5bKQTtVA0L25JDkVtn0EDrxYhHTPGuH7Fa4XFRN53tVnxy5ZO
         saonWsK+SwnMA7OaLBV6c1K+cyslPufBJxTwzsDjRXXqKWp1BN85wd10/zjRBAtSMAbt
         gHHw==
X-Gm-Message-State: ACgBeo3aE3tmriFRIexgXkPjXAtGvaTScHp+iPCNYDI/dgieNKZlTpkA
        YL4GM+8plNrtw2Ahi7mKz/x7Pctb/UREpJubGxvXSR3oY3D05PptCba++0dWmkkbJCQiSgj3a4I
        VCcBmThQKcOsb
X-Received: by 2002:a17:906:eecb:b0:73c:5bcb:8eb3 with SMTP id wu11-20020a170906eecb00b0073c5bcb8eb3mr12429534ejb.284.1661197210453;
        Mon, 22 Aug 2022 12:40:10 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4niDRL1RcFobHgT2AB075N+mpNaqURdq6mZbMNFfEFmFM9xPuItdS4fWDKpGE3WRVJj+XW2A==
X-Received: by 2002:a17:906:eecb:b0:73c:5bcb:8eb3 with SMTP id wu11-20020a170906eecb00b0073c5bcb8eb3mr12429529ejb.284.1661197210269;
        Mon, 22 Aug 2022 12:40:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v1-20020a50d081000000b0043a7c24a669sm160532edd.91.2022.08.22.12.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 12:40:09 -0700 (PDT)
Message-ID: <4edc98dc-31b4-bfb4-bb8e-4b453b006dec@redhat.com>
Date:   Mon, 22 Aug 2022 21:40:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 3/7] KVM: nVMX: Make an event request when pending an
 MTF nested VM-Exit
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, seanjc@google.com, stable@vger.kernel.org
References: <20220822170659.2527086-1-pbonzini@redhat.com>
 <20220822170659.2527086-4-pbonzini@redhat.com>
 <CALMp9eRaTV+B6+SA0ecwi6u6KfNyVX33VToYQe-A5ovS=UAwUg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eRaTV+B6+SA0ecwi6u6KfNyVX33VToYQe-A5ovS=UAwUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/22 19:52, Jim Mattson wrote:
> On Mon, Aug 22, 2022 at 10:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Set KVM_REQ_EVENT when MTF becomes pending to ensure that KVM will run
>> through inject_pending_event() and thus vmx_check_nested_events() prior
>> to re-entering the guest.
>>
>> MTF currently works by virtue of KVM's hack that calls
>> kvm_check_nested_events() from kvm_vcpu_running(), but that hack will
>> be removed in the near future.  Until that call is removed, the patch
>> introduces no functional change.
>>
>> Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
> What happens if live migration occurs before the KVM_REQ_EVENT is processed?

Good point, this must be squashed in:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ab135f9ef52f..a703b71d675d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6481,6 +6481,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
  	if (ret)
  		goto error_guest_mode;
  
+	if (vmx->nested.mtf_pending)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
  	return 0;
  
  error_guest_mode:

so that the other side restores the request.

Paolo


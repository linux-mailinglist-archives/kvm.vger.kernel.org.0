Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1B26944E7
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 12:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjBMLz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 06:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBMLz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 06:55:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A74614498
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 03:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676289289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WcMhCkMbOmOTj/bH4Sy4OqKGZb6rFPHQNFiH34s50Yo=;
        b=Mt8nLHrr4NKNJQnq7nUEUWg5UbpvoQQk/XqnS5up8uEAfYQHPDZNv631XearUfVsNZLIIq
        6SESKGUgfxZrchCUe8LdHt/6ENdq4gpyPmexbxducAehwq4WhqybLuoNugMK1o3q7/vzog
        ueDcf9CWpdG5pOc679U1hz2w347P4ag=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-RUrEiOY0NaO_9mfcDpgYbQ-1; Mon, 13 Feb 2023 06:54:48 -0500
X-MC-Unique: RUrEiOY0NaO_9mfcDpgYbQ-1
Received: by mail-qv1-f71.google.com with SMTP id ng1-20020a0562143bc100b004bb706b3a27so6734052qvb.20
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 03:54:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WcMhCkMbOmOTj/bH4Sy4OqKGZb6rFPHQNFiH34s50Yo=;
        b=ujKXJ/9xHOm5B3gsY/4h2fVVHUMake3eOV4IKr/85rVeYxAJMCCoRY9SjSCsAUEMrL
         oPCNiR7XuGihk5vhLLtZyY7/DKkYCmaULG2h7lUGNJTd67H/nuNgYqXZWxHqdBKrRcVg
         gy9tQhch1JjMlYU21hrzUo1GHYtJ3R9elk1Rw/oBBj03gr0HfV+szg24z3GqCCQXr019
         Yh8+drwBJBf94oeKzwVyx0XIIRgJHytNhwXb8/l4Ln0NqU0zOfLtC6qpPEZUYIFDZO49
         yVIEWJi18oIxulm3uJfXiyQwGEtzzlz7z3Flgi3kDgrxBmC67BFmBubwOsNOM1eXf2IJ
         Ef/Q==
X-Gm-Message-State: AO0yUKV66Ev7KtrIrEBBTM8rsdNrhRt8OfTt1VFLyfWgRi9GX8wVUUwN
        gd7mMcziqCpCia84UFYIe9g7OH18Aba6wSw/UwM0Kxy7x3HWqjjGQ2JjulZygMckb12n57Ri5Vx
        f4JymrqWS468csDC/6A==
X-Received: by 2002:a05:622a:c2:b0:3b7:fafc:73e3 with SMTP id p2-20020a05622a00c200b003b7fafc73e3mr41611988qtw.41.1676289287613;
        Mon, 13 Feb 2023 03:54:47 -0800 (PST)
X-Google-Smtp-Source: AK7set8wayXAY07eSAsLUy1EuKEjpZecWkh4cqVU76wUx7sPcdjPhPEbbVGGf6BKp6NafvFeXHvmsw==
X-Received: by 2002:a05:622a:c2:b0:3b7:fafc:73e3 with SMTP id p2-20020a05622a00c200b003b7fafc73e3mr41611965qtw.41.1676289287297;
        Mon, 13 Feb 2023 03:54:47 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e11-20020ac8010b000000b003b62e9c82ebsm9268360qtg.48.2023.02.13.03.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 03:54:46 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: VMX: Rename "KVM is using eVMCS" static key
 to match its wrapper
In-Reply-To: <20230211003534.564198-4-seanjc@google.com>
References: <20230211003534.564198-1-seanjc@google.com>
 <20230211003534.564198-4-seanjc@google.com>
Date:   Mon, 13 Feb 2023 12:54:44 +0100
Message-ID: <87pmaddbln.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Rename enable_evmcs to __kvm_is_using_evmcs to match its wrapper, and to
> avoid confusion with enabling eVMCS for nested virtualization, i.e. have
> "enable eVMCS" be reserved for "enable eVMCS support for L1".
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/hyperv.c | 2 +-
>  arch/x86/kvm/vmx/hyperv.h | 4 ++--
>  arch/x86/kvm/vmx/vmx.c    | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
> index 274fbd38c64e..79450e1ed7cf 100644
> --- a/arch/x86/kvm/vmx/hyperv.c
> +++ b/arch/x86/kvm/vmx/hyperv.c
> @@ -609,7 +609,7 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
>  }
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> -DEFINE_STATIC_KEY_FALSE(enable_evmcs);
> +DEFINE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
>  
>  /*
>   * KVM on Hyper-V always uses the latest known eVMCSv1 revision, the assumption
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index a54a2fdf0a5b..9623fe1651c4 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -67,11 +67,11 @@ static inline u64 evmcs_read_any(struct hv_enlightened_vmcs *evmcs,
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
>  
> -DECLARE_STATIC_KEY_FALSE(enable_evmcs);
> +DECLARE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
>  
>  static __always_inline bool kvm_is_using_evmcs(void)
>  {
> -	return static_branch_unlikely(&enable_evmcs);
> +	return static_branch_unlikely(&__kvm_is_using_evmcs);
>  }
>  
>  static __always_inline int get_evmcs_offset(unsigned long field,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d80cbe01b5d7..651037b06eb2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -579,7 +579,7 @@ static __init void hv_init_evmcs(void)
>  
>  		if (enlightened_vmcs) {
>  			pr_info("Using Hyper-V Enlightened VMCS\n");
> -			static_branch_enable(&enable_evmcs);
> +			static_branch_enable(&__kvm_is_using_evmcs);
>  		}
>  
>  		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


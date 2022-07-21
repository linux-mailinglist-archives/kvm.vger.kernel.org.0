Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6117A57C1B0
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 02:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiGUAkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 20:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiGUAku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 20:40:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98B4422CE
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:40:48 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id go3so159886pjb.0
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KH9fFq73YQqYjsyxO6D0porLgzRsQltbJ34jnP4zXh4=;
        b=iz0p9LKdQrmSzQP8AJxjJmN5xTZMXPJIEDuiBSaEGGcfBu5jQnyU9Y3SlAs4Tcts5z
         b8vgoydsX+KvP9162K7c8oMq08HrTAw8utpXVekIOdbu0T/8SpFijkrCDU4duZARtohG
         KYc+N3uq6eDBWFIoWWyhIg96+pwBa9ttxrTYKMwimLT8Y3MJhqh7lcPOYCQoQWQmArrp
         rjr4+76QmCH5Ip98Ac6YBIynpYgoGe768jB8IMHF5N6fwtOKwQs6Mo1WZ6ysI4U+FNDK
         GALqiXlnSGzpldLgKa0Vq/uNpx2xPKaYpA+ER/K8Dn6a8Wi9sWGEII0XNb22552nGUQg
         X0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KH9fFq73YQqYjsyxO6D0porLgzRsQltbJ34jnP4zXh4=;
        b=bxS7JYYnV5RdF7b1mKbHn8FGJK6E7vvXhZMtOaYOREDyAa285zzSsUU7g9j/RB0W93
         5rnycRNw2tjZ/MRvJSv6MB+QI/Sxy8vvasQkr1O9aZnUyYb/xanklOimqU4XHwbu7ZIC
         Qil33LhoNeAnSmojyWwiov4ChNNrxEIHvywKrm6IJUe1u+WgGzMuMCIH5dzBgwQNeYBK
         N5u5MjNwmRpJMckWf6I5OkVcBg6mzb0ikK6QpTI4+r4gUXp8PKnzo0xYNRZFeCndkk35
         qr8tbDocy80wnZ9vHgu9fYdmhZCiMJam6ijaI4p2WLeplnoZCREPViO5CmTyaThtg1nA
         GLgg==
X-Gm-Message-State: AJIora+T28D5WFXiF9VYigslFRxJDCZHUsYEAqHyy7Egncj5C5+1KXE3
        cHdKLO2w/VeWIVT1zSzJuu9qKw==
X-Google-Smtp-Source: AGRyM1umqan83UN80lOz+jt46sai3tfTEzFIsGmDof83tydt4zEPllCUXAFqQDQt7Q8Fo+UUvVe83Q==
X-Received: by 2002:a17:90b:4b0a:b0:1f0:5c2d:fe72 with SMTP id lx10-20020a17090b4b0a00b001f05c2dfe72mr8524569pjb.150.1658364048295;
        Wed, 20 Jul 2022 17:40:48 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id r5-20020a635145000000b0040dd052ab11sm96429pgl.58.2022.07.20.17.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 17:40:47 -0700 (PDT)
Date:   Thu, 21 Jul 2022 00:40:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: emulator/smm: add structs for KVM's
 smram layout
Message-ID: <YtigjIgWj40QSsMA@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-8-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621150902.46126-8-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> Those structs will be used to read/write the smram state image.
> 
> Also document the differences between KVM's SMRAM layout and SMRAM
> layout that is used by real Intel/AMD cpus.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/kvm_emulate.h | 139 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 139 insertions(+)
> 
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 89246446d6aa9d..7015728da36d5f 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -503,6 +503,145 @@ enum x86_intercept {
>  	nr_x86_intercepts
>  };
>  
> +
> +/*
> + * 32 bit KVM's emulated SMM layout
> + * Loosely based on Intel's layout
> + */
> +
> +struct kvm_smm_seg_state_32 {
> +	u32 flags;
> +	u32 limit;
> +	u32 base;
> +} __packed;
> +
> +struct kvm_smram_state_32 {
> +
> +	u32 reserved1[62];			/* FE00 - FEF7 */
> +	u32 smbase;				/* FEF8 */
> +	u32 smm_revision;			/* FEFC */
> +	u32 reserved2[5];			/* FF00-FF13 */
> +	/* CR4 is not present in Intel/AMD SMRAM image*/
> +	u32 cr4;				/* FF14 */
> +	u32 reserved3[5];			/* FF18 */

Again, I love this approach, but we should have compile-time asserts to verify
the layout, e.g. see vmx_check_vmcs12_offsets().

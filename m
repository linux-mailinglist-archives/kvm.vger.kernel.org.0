Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90CD57C151
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 02:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbiGUAGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 20:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiGUAGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 20:06:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CE130F42
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:06:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q41-20020a17090a1b2c00b001f2043c727aso3767362pjq.1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zl8f6HPV5Rh1bVpXZpG/PEaQanwB5mTX2EqFow7ycko=;
        b=Xx7vzVCyr7mRNu58QYoYyo86qSl8a+kuEDUBCY48OhL3YMALD4/CAq8hvTzABMUoTd
         uLKYr3y4hrF00Y2NyJzRGrJaK38Q2z+sC2ERNsYkS1c9dsBOVNA9jXjyq0QxR8taQyeD
         Gd6zwv6JAFcwxovkErY66KP7MJdOHq2cqNWX7qtLy8V/KvN7PjxI8ahnilmA5QpG46lB
         J3ZTJeb/LfJju34WO9NAzVCgwoUyOs6BO5kCCLohNr7x+pvUX3j1uNyezyyCqD4ZS68N
         YmYocE3jf8eaDS8U/L3ZCYZEznzJZrlG9D1avRqB6bOMqeB6B3aU1+4ML0Re5B4+JqOJ
         MLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zl8f6HPV5Rh1bVpXZpG/PEaQanwB5mTX2EqFow7ycko=;
        b=Romc2xe3ciS1tm5Krsopqy3yKerNHjS5jpf1a6cdQ+e4KuFVHRe+4b/WXEchRo01XI
         CPn797RFI4VXNRba5Nj4UILmRSZAv1WWgeJJYb8o2m8fDmbrMIDSF/QeL8lhhVeFEcTR
         Mf/mI0E9vf8tYI4xgnPET6OVbgMyPCbJSIoU5UpF9GI3QllsWm34znBRNy8iyff4KCXJ
         DlNvQ/M6q1pMQXkgGkIgGfQvHJMGIMJ8VC6zUIv12PaIx7FHK/DesK3R3O30bcAEwDwh
         4RUvT1qSSovsNCGhiWoKl1IA0HvhgBnl1OPZUNsbPBzj2IWDThnsRMiPWy/8sU5fbW2J
         /C3Q==
X-Gm-Message-State: AJIora9dZRRzVEi7PpAa5kCyvjvTv2fECDf67lJvdazCno280aKeVta/
        qw0DaW9Ebcba7zh6vORRnVB/AQ==
X-Google-Smtp-Source: AGRyM1u0qqrMwXFL3ruItNWgLDmjtV7VS1B/ZOauP14OjkD++cleqCJs9fxb05Cy971+zEUN/4hCZw==
X-Received: by 2002:a17:90b:1d01:b0:1f2:104:6424 with SMTP id on1-20020a17090b1d0100b001f201046424mr7992254pjb.101.1658361977426;
        Wed, 20 Jul 2022 17:06:17 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id i66-20020a626d45000000b00525373aac7csm221278pfc.26.2022.07.20.17.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 17:06:16 -0700 (PDT)
Date:   Thu, 21 Jul 2022 00:06:13 +0000
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
Subject: Re: [PATCH v2 06/11] KVM: x86: emulator/smm: number of GPRs in the
 SMRAM image depends on the image format
Message-ID: <YtiYdTWQ7Vy+IHLO@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-7-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621150902.46126-7-mlevitsk@redhat.com>
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
> On 64 bit host, if the guest doesn't have X86_FEATURE_LM, we would

s/we would/KVM will

> access 16 gprs to 32-bit smram image, causing out-ouf-bound ram
> access.
> 
> On 32 bit host, the rsm_load_state_64/enter_smm_save_state_64
> is compiled out, thus access overflow can't happen.
> 
> Fixes: b443183a25ab61 ("KVM: x86: Reduce the number of emulator GPRs to '8' for 32-bit KVM")

Argh, I forgot that this one of the like five places KVM actually respects the
long mode flag.  Even worse, I fixed basically the same thing a while back,
commit b68f3cc7d978 ("KVM: x86: Always use 32-bit SMRAM save state for 32-bit kernels").

We should really harden put_smstate() and GET_SMSTATE()...

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---

Nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/emulate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 002687d17f9364..ce186aebca8e83 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2469,7 +2469,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt,
>  	ctxt->eflags =             GET_SMSTATE(u32, smstate, 0x7ff4) | X86_EFLAGS_FIXED;
>  	ctxt->_eip =               GET_SMSTATE(u32, smstate, 0x7ff0);
>  
> -	for (i = 0; i < NR_EMULATOR_GPRS; i++)
> +	for (i = 0; i < 8; i++)
>  		*reg_write(ctxt, i) = GET_SMSTATE(u32, smstate, 0x7fd0 + i * 4);
>  
>  	val = GET_SMSTATE(u32, smstate, 0x7fcc);
> @@ -2526,7 +2526,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>  	u16 selector;
>  	int i, r;
>  
> -	for (i = 0; i < NR_EMULATOR_GPRS; i++)
> +	for (i = 0; i < 16; i++)
>  		*reg_write(ctxt, i) = GET_SMSTATE(u64, smstate, 0x7ff8 - i * 8);
>  
>  	ctxt->_eip   = GET_SMSTATE(u64, smstate, 0x7f78);
> -- 
> 2.26.3
> 

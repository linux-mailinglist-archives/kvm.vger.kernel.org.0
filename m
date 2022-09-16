Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A555BB356
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 22:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiIPUO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 16:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiIPUOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 16:14:21 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAD3BA9D5
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 13:14:20 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q62-20020a17090a17c400b00202a3497516so651236pja.1
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 13:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9EpRyveJwinf2g/2n5O6cqr+ncXZffrYpgB3rVZ1U7s=;
        b=AkRPBWvSEoaTjwD6gRh46L4FcUM9k1BQQJzQUThnz5J5uZGaHxVU82WRcKah0NkkGY
         t1WafwQWXAXX8ICa+9vWjmdSs8NtzolRC1cOSQm9CUCNKLmdP2sez+CGIBw6iq3FjXO2
         8PI55ym9IXs71CXffKJWwBZHj7LvmDoLQdRfa1edtAhkVgZGNm7OXoV6Om5mBPVGj3rT
         /kWuGrSy7IXQ8o/nCnBuYpAHfy1EwuHsMT2ufPrCuUwnEtoglCo1DWzaWVZZarCP5x8J
         eF+bVv9DUVkK5Iv1U4J0wHe2QqbeihXndGeUkkeq4LPQtXhdtrTIgfI7kUyiAzzYFe5k
         CsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9EpRyveJwinf2g/2n5O6cqr+ncXZffrYpgB3rVZ1U7s=;
        b=pSw+rUY0GqxJP+x7/SONNa+Zzdcuqlitn3+b9dh2F/4inQo2m4GnB1gF5SzNvnbpx3
         4CGdmIHw7y4tmeMbI18ec3ByiQorPYyCcrAgJFeGlUOlHoS9i8flXVTsRYi9K39XkWar
         8GOuN1v26f5J1+xqGPeo9gXT9TGPnNLbHytci7Zus5e02R14jRmoNU/XGPSPM62ja26Z
         PBDWXnPMd1IP3y7QIKxGwKH2gwhAgYXmxelBxt5HAItKrAi7Y/DzvrwH26Anq8FWCnUP
         Mr5T1AYrHPPE0rCaA54O8ybZ63MhxI+mXcQsR8OdARGAGfEL3B8wL8vf4G6aCQyfK+0R
         Tfsw==
X-Gm-Message-State: ACrzQf1nqv99eVldkxM4PkBsFEQdgj16/jjmFWzaF3mEB1aYkF1vXyBs
        lPb9lz+heDbhJuMAE3Dg4RilMg==
X-Google-Smtp-Source: AMsMyM6MeJrbOV8j8gdA7uPANkkK+Xcczxzmk8FzfAW6PD/qhn+3P4hX7qxNP3tSd9MGo6s4LAqqaQ==
X-Received: by 2002:a17:902:8648:b0:178:1b71:c295 with SMTP id y8-20020a170902864800b001781b71c295mr1468549plt.148.1663359259666;
        Fri, 16 Sep 2022 13:14:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o8-20020a1709026b0800b0016d6963cb12sm13765151plk.304.2022.09.16.13.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 13:14:19 -0700 (PDT)
Date:   Fri, 16 Sep 2022 20:14:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Avi Kivity <avi@redhat.com>, Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org
Subject: Re: [PATCH 2/5] KVM: svm: Disallow EFER.LMSLE on hardware that
 doesn't support it
Message-ID: <YyTZFzaDOufASxqd@google.com>
References: <20220916045832.461395-1-jmattson@google.com>
 <20220916045832.461395-3-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916045832.461395-3-jmattson@google.com>
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

On Thu, Sep 15, 2022, Jim Mattson wrote:
> KVM has never properly virtualized EFER.LMSLE. When the "nested"
> module parameter is true, it allows an SVM guest to set EFER.LMSLE,
> and it passes the bit through in the VMCB, but the KVM emulator
> doesn't perform the required data segment limit checks in 64-bit mode.
> 
> With Zen3, AMD has dropped support for EFER.LMSLE. Hence, if a Zen3
> guest sets EFER.LMSLE, the next VMRUN will fail with "invalid VMCB."
> 
> When the host reports X86_FEATURE_NO_LMSLE, treat EFER.LMSLE as a
> reserved bit in the guest. Now, if a guest tries to set EFER.LMSLE on
> a host without support for EFER.LMSLE, the WRMSR will raise a #GP.
> 
> At the moment, the #GP may come as a surprise, but it's an improvement
> over the failed VMRUN. The #GP will be vindicated anon.
> 
> Fixes: eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be set with nested svm")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f3813dbacb9f..7c4fd594166c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5012,7 +5012,9 @@ static __init int svm_hardware_setup(void)
>  
>  	if (nested) {
>  		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
> -		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
> +		kvm_enable_efer_bits(EFER_SVME);
> +		if (!boot_cpu_has(X86_FEATURE_NO_LMSLE))
> +			kvm_enable_efer_bits(EFER_LMSLE);

Since KVM doesn't correctly virtualize EFER.LMSLE, I wonder if we can get away with
dropping support entirely.  I.e. delete the reference to EFER_LMSLE and unconditionally
set F(NO_LMSLE) in KVM_GET_SUPPORTED_CPUID.

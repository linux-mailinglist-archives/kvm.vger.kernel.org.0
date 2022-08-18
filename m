Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B3B598AB4
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbiHRRtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 13:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243068AbiHRRts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 13:49:48 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5A1C22BA
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:49:46 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso2724834pjh.5
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=9DsDwT22PvIrk8KHMwJ4ojUKw5VmQXY3VeVmmTdugFY=;
        b=dWVWBD0NtA2732x4FF3h3VXV9QrF8WCyK9Xq3/5pIPDN5c86oYi6pd3E9Tqzmih61D
         XnsOe6zN2dBFud6HcHR2TkmRnpUN4cbSmB6/ezyBroFT1kk1jpFkmivR4jYnNugQ8FCC
         BPR07fC/5T+Bhdaj7/2hzP3SiucmLnoMKltgU0WQYGyMOMiTax5IVuAaE0BhlUR80QW2
         0z+vUjonVlwZtRBhiS8KckiRKkzQp0Dvl97cyMHVh9HwpFXUc5/ZzSTltF/N2xqtr1vV
         iurbgm6EKrbjvJUwUSpZP1hN02Xu1jzOe4/p7363eNgCDdKQuhlWoxy6WYYvyO4G0tDR
         W1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=9DsDwT22PvIrk8KHMwJ4ojUKw5VmQXY3VeVmmTdugFY=;
        b=Vy2AfdYcbpdYvjYPifqPA5pqS8j2HA6kAqH276zn4L75C3NnEo2FLSA27ggN5zjvrP
         xrIJaO0r3iBwxrNcB/7AHm5kT6a6zsbl4LLucFlRuMdtghGBANrvo+NiWqYni+A6ttFI
         Z5WxemX/HpcO4ZPAKOGOD6Oj8NgKcdmymgTeACmzoPa15i2tHQI6ZKhhMtrFTjWsbZax
         NlBVpKKZSA+X0fgJcDVuw9oaOZ6MTwa3ZlreiJXotJP2dW9azQPDxrH2B59mBr7ntTTU
         gGWcPajUpTiQGqx2R7P5zfMvuK3fQ2gZc/36brk2FypIeIKDpBUQEHkci0oIwsD6S7Zn
         gkxQ==
X-Gm-Message-State: ACgBeo0eeKjcMfMUjlKE3gf+2+H0+7dsfaJQx/NdchbBDocLl8EdSZDn
        xAgSGrGMa5VRgOO3nVRYyj4xzw==
X-Google-Smtp-Source: AA6agR4xdRGg/7F/tdy10J4KT9KsESLpZLsqDBIGuLR0y4Zg077lgqYhN6Lj/jXTbwiQ/RkkA+Tc8Q==
X-Received: by 2002:a17:90b:4f42:b0:1f5:6976:7021 with SMTP id pj2-20020a17090b4f4200b001f569767021mr4302756pjb.30.1660844985933;
        Thu, 18 Aug 2022 10:49:45 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 186-20020a6219c3000000b00535f293bac6sm736695pfz.14.2022.08.18.10.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:49:45 -0700 (PDT)
Date:   Thu, 18 Aug 2022 17:49:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 22/26] KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL
 errata handling out of setup_vmcs_config()
Message-ID: <Yv57tmu09nOQcFrf@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-23-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802160756.339464-23-vkuznets@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> While it seems reasonable to not expose LOAD_IA32_PERF_GLOBAL_CTRL controls
> to L1 hypervisor on buggy CPUs, such change would inevitably break live
> migration from older KVMs where the controls are exposed. Keep the status quo
> for now, L1 hypervisor itself is supposed to take care of the errata.

As noted before, this statement is wrong as it requires guest FMS == host FMS,
but it's irrelevant because KVM can emulate the control unconditionally.  I'll
test and fold in my suggested patch[*] (assuming it works) and reword this part
of the changelog.  Ah, and I'll also need to fold in a patch to actually emulate
the controls without hardware support.

[*] https://lore.kernel.org/all/YtnZmCutdd5tpUmz@google.com

> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 59 +++++++++++++++++++++++++-----------------
>  1 file changed, 35 insertions(+), 24 deletions(-)
> 

...

> @@ -8192,6 +8199,10 @@ static __init int hardware_setup(void)
>  	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
>  		return -EIO;
>  
> +	if (cpu_has_perf_global_ctrl_bug())
> +		pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
> +			     "does not work properly. Using workaround\n");

Any objections to opportunistically tweaking this?

		pr_warn_once("kvm: CPU has VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL erratum,"
			     "using MSR load/store lists for PERF_GLOBAL_CTRL\n");

> +
>  	if (boot_cpu_has(X86_FEATURE_NX))
>  		kvm_enable_efer_bits(EFER_NX);
>  
> -- 
> 2.35.3
> 

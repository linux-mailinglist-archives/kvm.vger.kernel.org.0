Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B433F58AE2E
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbiHEQ3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 12:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241388AbiHEQ3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 12:29:33 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A4D1C920
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 09:29:31 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g12so2692583pfb.3
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 09:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=NVt7Ojg3Pa9myW1UbaAE8JylBQrIfDsdr5w11ENknyw=;
        b=lFQZi1y05/nvkc6BXdArl9nxUC1CMoH7PILR8V4/ROTQMYu78xXHNpbWVHulHnGtX+
         ED10wQPlrJB/4a3/wgamkJy43WE0rxYMtQTsmHd+gtLFWQVVOPc1irb8FJRL/d9wAbxn
         0Zw2Y+WVaFg4tGE4IEH2RRJ7eU9VfSk+z2x4jN/Gkam9r6a7uj9Gy4swGlxhRI6PH6RL
         L2zrnvP6MN5U9QStnSfJL1Y9gg0zML0/XkDVeEh8rp2nD3mLfLk7gJrs2IsQkUAbp1CP
         ES+9Yij3IV6vhzH3RTuq+f/DQSk/jPeyNph49hAP35OTN9Us/O7Syihk8WbwLmEFAqDo
         EtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=NVt7Ojg3Pa9myW1UbaAE8JylBQrIfDsdr5w11ENknyw=;
        b=Y2cFlXO6OzAUdvzXvhg4bBCZz3dDX6434JCKO5A4c66lPVSWeJXYkhIh0Wg8amIEs5
         V+sEtv3trck/DbfsmPsAW82Ur7aB2szmpPNoHGLNs0nl3bSLNmlW/xS7qF93lPbyfU1t
         ydK0JHUi1Z8j5Uh9o1hKFVK/G37+/ZVAWy8Kd1VSwctWWIXdA7EBvTxmHI6JnnR77v4T
         6WyQHM+VssEH1K9kZgEN3rC38SavCKEksCpAWr+XbOpNXh+pXOpA55nvR8B9FyHzGhFB
         nTLgb/yN6td8d4cHxBmv+WjQidjbLKu761aZr443F0w5YcpcGvkcDs/fyDhe0yVyy4fH
         z32A==
X-Gm-Message-State: ACgBeo1DaDH/tKQ5cNVmvWHHKeaNb245zZbqL317IEha4ei22ItEoyIs
        l0nRvMyo6kMLi078ROVkLOlBNw==
X-Google-Smtp-Source: AA6agR5+qG2pYhy9LeF+iT26oZG1qHU3SLkrzITuutbQNXg0ttnlL7wTy7pN+ka1mTZ4g/wCBkRUuw==
X-Received: by 2002:aa7:88d1:0:b0:52e:f8e:aab5 with SMTP id k17-20020aa788d1000000b0052e0f8eaab5mr7738603pff.63.1659716970583;
        Fri, 05 Aug 2022 09:29:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b0016dcbdf9492sm3296786plg.92.2022.08.05.09.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 09:29:29 -0700 (PDT)
Date:   Fri, 5 Aug 2022 16:29:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86: Reject writes to PERF_CAPABILITIES feature
 MSR after KVM_RUN
Message-ID: <Yu1FZX7hwT1X7DSw@google.com>
References: <20220805083744.78767-1-likexu@tencent.com>
 <20220805083744.78767-2-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805083744.78767-2-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> KVM may do the "wrong" thing if userspace changes PERF_CAPABILITIES
> after running the vCPU, i.e. after KVM_RUN. Similar to disallowing CPUID
> changes after KVM_RUN, KVM should also disallow changing the feature MSRs
> (conservatively starting from PERF_CAPABILITIES) after KVM_RUN to prevent
> unexpected behavior.
> 
> Applying the same logic to most feature msrs in do_set_msr() may
> reduce the flexibility (one odd but reasonable user space may want
> per-vcpu control, feature by feature)

I don't follow this argument.  vcpu->arch.last_vmentry_cpu is per-vCPU, nothing
prevents userspace from defining 

> and also increases the overhead.

Yes, there is a small amount of overhead, but it's trivial compared to the massive
switch statements in {svm,vmx}_set_msr().  And there are multiple ways to make the
overhead practically meaningless.

Ha!  Modern compilers are fantastic.  If we special case the VMX MSRs, which isn't
a terrible idea anyways (it's a good excuse to add proper defines instead of open
coding "MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC" everywhere), then the lookup
can use a compile-time constant array and generate what is effectively a switch
statement without actually needed a switch statemen, and without needed to play
macro games are have redundant lists (maintenance burden).

E.g. with some prep work, the lookup can be this

/*
 * All feature MSRs except uCode revID, which tracks the currently loaded uCode
 * patch, are immutable once the vCPU model is defined.  Special case the VMX
 * MSRs to keep the primarly lookup loop short.
 */
static bool kvm_is_immutable_feature_msr(u32 msr)
{
	int i;

	if (msr >= KVM_FIRST_VMX_FEATURE_MSR && msr <= KVM_LAST_VMX_FEATURE_MSR)
		return true;

	for (i = 0; i < ARRAY_SIZE(msr_based_features_all_except_vmx); i++) {
		if (msr == msr_based_features_all_except_vmx[i])
			return msr != MSR_IA32_UCODE_REV;
	}

	return false;
}

which gcc translates to a series of CMP+JCC/SETcc instructions.

   0x00000000000291d0 <+48>:	8d 86 80 fb ff ff	lea    -0x480(%rsi),%eax
   0x00000000000291d6 <+54>:	83 f8 11	cmp    $0x11,%eax
   0x00000000000291d9 <+57>:	76 65	jbe    0x29240 <do_set_msr+160>
   0x00000000000291db <+59>:	81 fe 29 10 01 c0	cmp    $0xc0011029,%esi
   0x00000000000291e1 <+65>:	74 5d	je     0x29240 <do_set_msr+160>
   0x00000000000291e3 <+67>:	81 fe 8b 00 00 00	cmp    $0x8b,%esi
   0x00000000000291e9 <+73>:	0f 94 c0	sete   %al
   0x00000000000291ec <+76>:	81 fe 0a 01 00 00	cmp    $0x10a,%esi
   0x00000000000291f2 <+82>:	0f 94 c2	sete   %dl
   0x00000000000291f5 <+85>:	08 d0	or     %dl,%al
   0x00000000000291f7 <+87>:	75 3e	jne    0x29237 <do_set_msr+151>
   0x00000000000291f9 <+89>:	81 fe 45 03 00 00	cmp    $0x345,%esi
   0x00000000000291ff <+95>:	74 36	je     0x29237 <do_set_msr+151>

I'll send a series.

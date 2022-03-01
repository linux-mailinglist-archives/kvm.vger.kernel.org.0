Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82194C923B
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbiCARzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbiCARzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:55:39 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5091419A5
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:54:58 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id p8so14947751pfh.8
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 09:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IrlX1EuXuhvZFO5dyfwsKkbcsiZCA12sMewuJW1ZcQg=;
        b=VaCU/amEuSGHsWyLjWVzhe4lT4UoHiib+D1qJwuxcT0I0vyV/0YaAhz5h0ndF6eg8c
         Cit87v2fsFLtpZ965a6BJbXSLH1dL2gZsxv9ZYp5SlLL3Yf4b52bk00PMi4SLUgddVDD
         E1Nf01htX0Ejx69EUqV/ZWhuP16S1Ub8joiSbL2DtYbay7LGYmo9oigmnDhNWytR56xr
         zHGG9Rla0TY0wMTspHpdcNjFUB/t2V6l7vXKjXlTXp65Ae+G7S5hSszJU6TAe7uhOrIW
         x8vicH6kLZUq0hqfNFxXd9egOibFCmoFZDhWw+BijO+9X8sid1SgUKaXvwj/SULQRGLe
         wIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IrlX1EuXuhvZFO5dyfwsKkbcsiZCA12sMewuJW1ZcQg=;
        b=3emFGAyhWAk+WRP/ivQ6xIU65enTyeAG/Np/ZhDPjVewhMkHrUIR4Y+AyrJv+A6fRK
         wP8HW9DWG+w/Ti0x1w7EeVc5pAde1sT/3dCf1rtQizEY0lLEMMnsI9/aoAqPSFbE5YZh
         7xC6jc5zILMsEX6yqJVmN/YlMutCP1mnvouHaY/kWCti9j19n8e8ikaaQ0fBXJbVy2EU
         /XRhon/POQTMUnrNVQunPESoBC28Tz2lMMMH6QYKC/m37pVk8Op0eWWymDY4dJ6Etg5/
         Sj+9HzjiGQbR7PifKPAUh5ash6N91bEkCwlh9blg5BhRblDmmlkGmICRXr8nVbuqkidH
         mGag==
X-Gm-Message-State: AOAM533+roVmrdJ9Ms3NceuUFzv/qqfn5GY5VbqU2V/B9ycgyPWbGoPK
        0RXn+j8T7rSosq+cV/Njp3JHEQ==
X-Google-Smtp-Source: ABdhPJzQ+0ITtmk7Ryr/RS5lmTXIldDRcloM8HHgtST1nO90BTbDSEp+Dxflytdbw/6uQN1KOq5Ugg==
X-Received: by 2002:a63:e60:0:b0:374:6620:f372 with SMTP id 32-20020a630e60000000b003746620f372mr22253197pgo.557.1646157298000;
        Tue, 01 Mar 2022 09:54:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k130-20020a633d88000000b00378c359ea29sm4384360pga.12.2022.03.01.09.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 09:54:57 -0800 (PST)
Date:   Tue, 1 Mar 2022 17:54:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peng Hao <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  kvm: x86: Improve virtual machine startup performance
Message-ID: <Yh5d7XBD9D4FhEe3@google.com>
References: <20220301063756.16817-1-flyingpeng@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301063756.16817-1-flyingpeng@tencent.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022, Peng Hao wrote:
>  From: Peng Hao <flyingpeng@tencent.com>
> 
> vcpu 0 will repeatedly enter/exit the smm state during the startup
> phase, and kvm_init_mmu will be called repeatedly during this process.
> There are parts of the mmu initialization code that do not need to be
> modified after the first initialization.
> 
> Statistics on my server, vcpu0 when starting the virtual machine
> Calling kvm_init_mmu more than 600 times (due to smm state switching).
> The patch can save about 36 microseconds in total.
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
> @@ -5054,7 +5059,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
>  {
>  	kvm_mmu_unload(vcpu);
> -	kvm_init_mmu(vcpu);
> +	kvm_init_mmu(vcpu, false);

This is wrong, kvm_mmu_reset_context() is the "big hammer" and is expected to
unconditionally get the MMU to a known good state.  E.g. failure to initialize
means this code:

	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);

will not update the shadow_root_level as expected in response to userspace changing
guest.MAXPHYADDR in such a way that KVM enables/disables 5-level paging.

The SMM transitions definitely need to be fixed, and we're slowly getting there,
but sadly there's no quick fix.

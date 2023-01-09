Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19388662D0E
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 18:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbjAIRnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 12:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbjAIRn2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 12:43:28 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBC319023
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 09:43:27 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 200so553057pfx.7
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 09:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GSSXv+I+w/8fq5Yx5Ez6ORBTwPIwCfMMjmGhcpp+UqU=;
        b=g0eGXd1q88kKO1UBdVGzjP/95p/jpiFOz1tlu9gArFeF2qE16G4bVRKZnTw+XZWtP+
         EXrJCYtuU4eMsLsoIGwLHGE/k07Dndjexhtc4+89wiIh6t0htZq88FgfPeF2HiM+62gW
         6bVYPLutu6hFNdoSRn3rQ3obSPWJsZ/DaHbp0ph0JiEXjk2KMis4Qd8AW9xA1OlPRfcO
         IRE2Tydovrr2fE+hnvN0agTBvFC49yxzQWirTToKPy0kam/RY/O5O+6uTm/r2z8YrQ3h
         YOdKyhwgMJMT55xd9yRJf6srnW5aApxQjTtPOI1niagvZTpis4FDOtgy/qD+Nl8IXzWT
         vPfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GSSXv+I+w/8fq5Yx5Ez6ORBTwPIwCfMMjmGhcpp+UqU=;
        b=Cc87EI7j5wq5fF+xICFev8li8kc5rd/j+qdEtgBgd2Y6ZIjAamOYQI99iT0EKgC2AU
         5YxwzSkEPKhvMntsbzEct/2AHKlBi83uf5rdHjoc5Nxa2qI8pYbrIGlLYwdt2r2uEbR6
         vsouktUxIzhR91LUuifaSBu5odPw0cb7xHGtEoDXc8M7lvZENYridYvEKDR1JlO/FMB9
         C9iNoWmXK5dL+nK+Dx5L8+pmSNj3Igi+GjxBMi1ZGWmb5ZckAyQJBoNiEnNpoAsqpVSJ
         xV9M4rUS/+JblRsOwUvgsZlpVck/pQ+dI7WLuxY47+7j45UgzV6q0QaOD+Pznmn29TV+
         +0ow==
X-Gm-Message-State: AFqh2kp2qe4i4S0DPQtwiNGqUsKaeZTMK5JfjkI/HIlfeH35Ie6X7p3B
        7ZC4PWKkHQ4q97TSTEEIrpx+4Q==
X-Google-Smtp-Source: AMrXdXuahdX5fT5IrjPkz4RnJUA4Kk4OaigXHUxhSIcCKVvee6MrvxGtSvPNdBbAdchzeYDmGAb45w==
X-Received: by 2002:aa7:9249:0:b0:576:9252:d06 with SMTP id 9-20020aa79249000000b0057692520d06mr740111pfp.0.1673286207259;
        Mon, 09 Jan 2023 09:43:27 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k197-20020a6284ce000000b00574b86040a4sm6350861pfd.3.2023.01.09.09.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 09:43:26 -0800 (PST)
Date:   Mon, 9 Jan 2023 17:43:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH rcu 01/27] arch/x86: Remove "select SRCU"
Message-ID: <Y7xSO2dW1sy21RVz@google.com>
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-1-paulmck@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105003813.1770367-1-paulmck@kernel.org>
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

On Wed, Jan 04, 2023, Paul E. McKenney wrote:
> Now that the SRCU Kconfig option is unconditionally selected, there is
> no longer any point in selecting it.  Therefore, remove the "select SRCU"
> Kconfig statements.
> 
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: <x86@kernel.org>
> Cc: <kvm@vger.kernel.org>
> ---

...

> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index fbeaa9ddef598..9306d99585188 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -46,7 +46,6 @@ config KVM
>  	select KVM_XFER_TO_GUEST_WORK
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  	select KVM_VFIO
> -	select SRCU

Would it be too much trouble to bundle all of the KVM changes into a single patch?
The SRCU requirement is a generic KVM requirement that's handled in the arch Kconfigs
purely because of KVM's somewhat roundabout Kconfig setup.

>  	select INTERVAL_TREE
>  	select HAVE_KVM_PM_NOTIFIER if PM
>  	help
> -- 
> 2.31.1.189.g2e36527f23
> 

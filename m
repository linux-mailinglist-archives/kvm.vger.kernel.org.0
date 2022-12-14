Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8209E64D136
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiLNUa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiLNUaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:30:01 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74B047322
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:18:22 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id t17so8162686pjo.3
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XZ1n8+nIX2hZn3XsXYGq2hnC9XLQZy4UoT+8m2Z4kb0=;
        b=TGPBdcm94aFHv9Hel/S/gt3YaCFowv1ATI2xs9dHbFllFBpJjqpraZHUTu8hakg2EH
         JH+KQV05qZStUJdzHvvTsWTzsviroFniuzTmlbtHm3BUbeQBvWYKze7+2wZ2REGMDgc4
         lXm1dREGmZYvfR0VkhwpFjyeoqV4CszWtUoaRPfyZLEbaDAyECXgcp0Et3te/l/srJj3
         tRxE2DOG9g2soP2PJkJ79IJv/BWPQbI7bGMFUv/FfFejb62gtA57kX5m1mH/J/N4C3g4
         9vDYgy8/tbZenvvPcUYtWT4DLzoLXDFSTuCzQYs6tqoJXZMJywizr1ooZJE/Yqj0KQwC
         H4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZ1n8+nIX2hZn3XsXYGq2hnC9XLQZy4UoT+8m2Z4kb0=;
        b=rreZqIiQj34XNqsRUofwv1W4z0kJZauNPG/stYteZDopmdnRQZmCtgNf3fEFtND+OJ
         Eq1irWYiCgzdUT3/GEOl6hiSTqnFvVdqGFggsOgM+xDmk7XrA7kM/hTktkhg2ZaeRBVd
         1pL8Pn5FHQmcRszrTUMHTdGibZ2GVEPQxFKdxdsaV1bY3lzU7dClYoPE4eACCtlPccJs
         XNeIro8X8cldbrLv7P0RJcXSP0CTInrCC5tY6kKBgO39kygf+/IBZTxShDbAZhkdDaN1
         93rG1RVnXIScf1brhKoKJSCea/Iz+UMkKZYHabooyyeWxWJJ3qgDbg1ndiUu2kcPrTmF
         Dn9w==
X-Gm-Message-State: ANoB5plN2zjAzRaFsljtcv4FiCsIG7tGn5iMk6/CdhczKARMbBbBiQMQ
        m1LFs6M9uWT2jU2cDjtfp+Ru1w==
X-Google-Smtp-Source: AA0mqf7b4mseBOFUuKioL6u6q2TVXaZahq2LyEAjz2IeFqIcLn3TQifnz7xlQm/6M5KXgsh+4C4ZlQ==
X-Received: by 2002:a17:902:da8d:b0:189:3a04:4466 with SMTP id j13-20020a170902da8d00b001893a044466mr1011167plx.2.1671049102301;
        Wed, 14 Dec 2022 12:18:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ik13-20020a170902ab0d00b0017d97d13b18sm2290816plb.65.2022.12.14.12.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 12:18:21 -0800 (PST)
Date:   Wed, 14 Dec 2022 20:18:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhang Chen <chen.zhang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardware
 mitigations
Message-ID: <Y5oviY0471JytWPo@google.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-6-chen.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210160046.2608762-6-chen.zhang@intel.com>
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

On Sun, Dec 11, 2022, Zhang Chen wrote:
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> Guests that have different family/model than the host may not be aware
> of hardware mitigations(such as RRSBA_DIS_S) available on host. This is
> particularly true when guests migrate. To solve this problem Intel
> processors have added a virtual MSR interface

Is there any actual "processor" support here?  To me, this looks like Intel is
foisting a paravirt interface on KVM and other hypervisors without collaborating
with said hypervisors' developers and maintainers.

I get that some of the mitigations are vendor specific, but things like RETPOLINE
aren't vendor specific.  I haven't followed all of the mitigation stuff very
closely, but I wouldn't be surprised if there are mitigations now or in the future
that are common across architectures, e.g. arm64 and x86-64.  Intel doing its own
thing means AMD and arm64 will likely follow suit, and suddenly KVM is supporting
multiple paravirt interfaces for very similar things, without having any control
over the APIs.  That's all kinds of backwards.

And having to wait for Intel to roll out new documentation when software inevitably
comes up with some clever new mitigation doesn't exactly fill my heart with joy.

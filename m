Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE536B128F
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 21:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCHUC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 15:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCHUC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 15:02:56 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8A8C80A3
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 12:02:52 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id fy8-20020a17090b020800b002374c592205so1282705pjb.5
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 12:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678305772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RlHJgcEUiCdCCweXLtFT1l38YCKbKBv5+91EvM02bTQ=;
        b=UyzwIOXNBgfe0IPjcpCAi7k759C2+FoyrNWYdOymeyKSB25SBSQr4dGFCFPde9P2NA
         xhTjmb7SKckbChHx+v2ssj1IvxzLSKj7XM9S13S7iOQoNjRNyAJDXFsILqNj7pdc5f90
         +6PtvJkAy/YznvLEV1/9DGm6gLift8xvZGkw4QkhtjuqBPlzwcjk6y+ezYcx0DAxEjk5
         +4avJs1n9fjfRsK6nlqYT49/JzGrHm3RHmLT3IgAzC1oFVbCT5VZ1bLXpYEKSkX5qrfS
         fvZzuakiePr/WE9NvoStdpoB6EA55dS65Q5HBgZ+zdWhZVKTladgX/7aNeCEJScLo9Nf
         RgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678305772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RlHJgcEUiCdCCweXLtFT1l38YCKbKBv5+91EvM02bTQ=;
        b=Gq6FgaKA+rQ6dCxBrHG4HrEXgfOSB/JLckvfDgTERjh2pfYm5VUvFQb8IVDbzRwbqN
         RXSvXn0z2jXhMAAQ6go+gweqCLt35I9IKKGUqkZMav8OXRHX3SrW37VG9mgAZ30kxC+Q
         RG+qMJXg7vH8sfIJYhgLZGcmTeiPfixkKxu+3fMgfJvcY7iWZVzvN/xGAasYRIo9tGB7
         g7GIWEaC1elJCDhahBUaM03mwJgryvy2dmLtZaCwXqLcf7uFz8XY3NDOjcFWoS51jKz3
         HElQxOvkq8IjC0IS7gw0ZIHAgy1hKgWgD3nyEHiWjiijiLdaKcYjMKIqmmzhkY1Tret3
         Zbwg==
X-Gm-Message-State: AO0yUKXNLhuHujMlmLLJ4UAteqJsjRtcJ3PtGyNC/UZFPn/GWiQfrzVY
        xk3WEEqLG7dZh+mfxYZ8aMYWZePqyyI=
X-Google-Smtp-Source: AK7set+axUvJKLLTFbex2OaycDYkyyaAoKxr6ncYGyBZiRD3Sj7VH4S9mNFKaAJMwkpWpMTS2eNDP1d3Jtg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ca0f:b0:236:736d:2581 with SMTP id
 x15-20020a17090aca0f00b00236736d2581mr7214958pjt.8.1678305772167; Wed, 08 Mar
 2023 12:02:52 -0800 (PST)
Date:   Wed, 8 Mar 2023 12:02:50 -0800
In-Reply-To: <20230308072936.1293101-1-robert.hu@intel.com>
Mime-Version: 1.0
References: <20230308072936.1293101-1-robert.hu@intel.com>
Message-ID: <ZAjp6qrQtuLmoMmM@google.com>
Subject: Re: [PATCH] KVM: x86: Remove a redundant guest cpuid check in kvm_set_cr4()
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        robert.hoo.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023, Robert Hoo wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> If !guest_cpuid_has(vcpu, X86_FEATURE_PCID), CR4.PCIDE would have been in
> vcpu->arch.cr4_guest_rsvd_bits and failed earlier kvm_is_valid_cr4() check.
> Remove this meaningless check.
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---

Nice!  I think I'll add

Fixes: 4683d758f48e ("KVM: x86: Supplement __cr4_reserved_bits() with X86_FEATURE_PCID check")

when applying (won't happen until next week).

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486ED61523A
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 20:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiKATXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 15:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiKATXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 15:23:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919C2B63
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 12:23:27 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l6so14183666pjj.0
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 12:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3aqeV5l/sHqTnwOEPV4S0gaKQZzoX95b7TdrMvLIU2g=;
        b=EI+y8oeUUHvB7DgAa9XMPokkWAo8GRJwNPhRMsnH7hDa24zOt6p3Y8vgxhJtMa5YLx
         rhT4GntHAMlxJ8iF0KOAnROyNWPAE8Uez78xZbX7le5Fj3i2tBOBpm5wAobmmmecOLhM
         88B2LZxAMgUqpm/Y91cjpQoqOuEYAsWzmi6GvmpTi+2djT+Bu7+skZ0KTbsP6GcCmrYy
         vCxNUiEnWiJGzcizt8ES6a8sTzd8C4yQK70/EyNVoC6bTfuAYUdjUxUcdI7xj8j2Pxf3
         Hi/iaSLmnNHqwurjuZyIUTRoFCSYMrM3+5hooA39M8JAOwaBqJwwGgBIMmCJCIgSUbQQ
         K75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aqeV5l/sHqTnwOEPV4S0gaKQZzoX95b7TdrMvLIU2g=;
        b=r0PYwIXbo/jBYyD6E3ZF7bJAa74qXf0bmPywgTqZFLV7zNdsM+4Bn+XGF8Kz8Sh5lE
         eb6BxzLLfb5BeaiK7N1crxWtoswybrfwITX+4NK3YBKW9B9TpAt3fV3AevbQAcl5ryeE
         2YcjQoqJ5YC0luqNz0o9A+FOyz4S5pzjn2XTJfTFL0yHUJ2P2OXjg2+cNWwkWX9Cqnbw
         eEmjvPz6JpvuYcPlBbwl00UzkKGMiy73v88cvepWP3XqAJGPsbIfaVhmr0YaVtWvW9kj
         1jG/65s50s3ezJ2lterOODBOmCsBpvf8YwAFzhc/oOJK5qdcnaIQO053q0WOmK9T3nl7
         ji/Q==
X-Gm-Message-State: ACrzQf1MEpsf6NI84XuG+6kyFUyR1qD4wEKHp7RYTBe48LouveGk1S+W
        w+VsUljdR7dQuH98BsL1xcwfH6/cd3XhmA==
X-Google-Smtp-Source: AMsMyM72cOS1vFikd8sBQjmN+eadeDIi+8uznBOw9lNUjC0GAYQEj7hsWeoa2JLADJ3q3pFT39Pmpg==
X-Received: by 2002:a17:902:9a05:b0:187:eca:fc19 with SMTP id v5-20020a1709029a0500b001870ecafc19mr17692707plp.125.1667330606978;
        Tue, 01 Nov 2022 12:23:26 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e1-20020a056a0000c100b0052d4cb47339sm6880120pfj.151.2022.11.01.12.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 12:23:26 -0700 (PDT)
Date:   Tue, 1 Nov 2022 19:23:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2 2/2] KVM: VMX: Execute IBPB on emulated VM-exit when
 guest has IBRS
Message-ID: <Y2FyK6WrT1tcWAPp@google.com>
References: <20221019213620.1953281-1-jmattson@google.com>
 <20221019213620.1953281-3-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019213620.1953281-3-jmattson@google.com>
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

On Wed, Oct 19, 2022, Jim Mattson wrote:
> According to Intel's document on Indirect Branch Restricted
> Speculation, "Enabling IBRS does not prevent software from controlling
> the predicted targets of indirect branches of unrelated software
> executed later at the same predictor mode (for example, between two
> different user applications, or two different virtual machines). Such
> isolation can be ensured through use of the Indirect Branch Predictor
> Barrier (IBPB) command." This applies to both basic and enhanced IBRS.
> 
> Since L1 and L2 VMs share hardware predictor modes (guest-user and
> guest-kernel), hardware IBRS is not sufficient to virtualize
> IBRS. (The way that basic IBRS is implemented on pre-eIBRS parts,
> hardware IBRS is actually sufficient in practice, even though it isn't
> sufficient architecturally.)
> 
> For virtual CPUs that support IBRS, add an indirect branch prediction
> barrier on emulated VM-exit, to ensure that the predicted targets of
> indirect branches executed in L1 cannot be controlled by software that
> was executed in L2.
> 
> Since we typically don't intercept guest writes to IA32_SPEC_CTRL,
> perform the IBPB at emulated VM-exit regardless of the current
> IA32_SPEC_CTRL.IBRS value, even though the IBPB could technically be
> deferred until L1 sets IA32_SPEC_CTRL.IBRS, if IA32_SPEC_CTRL.IBRS is
> clear at emulated VM-exit.
> 
> This is CVE-2022-2196.
> 
> Fixes: 5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

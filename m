Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603B479B7A7
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjIKUuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241092AbjIKPBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 11:01:51 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637F6E40
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 08:01:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58fb8933e18so47905877b3.3
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 08:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694444505; x=1695049305; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b0h492hhBpi4c7QjU/Eg4y9r9cK5ab5e3uk7UqAdbaQ=;
        b=Pr8mt8rkLiApjr2WrJ6nHLqYYW68/+aAH9BAVW69JalJsNr5mqyqVJdDnmbXH69CRj
         pzOAXCCmgcSRn+hE3qCSq5xZcnhWqAFiJjxdU0YYBblqO48BnSEeRnhCiVEjXIjwtoUF
         K7sGeU7d/qm4WPZ3nFtjqhcrw9aL53pUWZRK2OOphWXPKBWnBTXPdK1NErt15qSN/mQx
         CG1ZflvNRt7MajJi2Ga7aaaPnXYvTDJA3suETB/+JPJC8eAw98ZxGrFsfU8RKrqPyiQ+
         yqz5oL3RANHdCY/++y931JrR8VvVaWKyjAOA/JbMd/4no95cA5N2BChMvd8uTadp/vE1
         DISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694444505; x=1695049305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b0h492hhBpi4c7QjU/Eg4y9r9cK5ab5e3uk7UqAdbaQ=;
        b=MkLFtgjuzRAjPWgspnrHzrOgXDQoq2L9z69bEt2bEPCwtqM8PErUJQqFOA4OMNoWwp
         flrPzJqFe7PKIibZ97ixuYU7XO9xS4Vv3FmJKeMju1OlKwJZV0gUOXDtJzcS13+F5IoQ
         kV5GnIxhclB1IBGpGM39zfFiLNDlFNDHGW4QYJ2tTBA57klfkc+d0G0K4IAQOrTcv12j
         xyH573TFuMwAL1uHvQI1vqITg5+MZ4V0D4r9W1ggWwdMYONay3cd1bFIAvklELCabD0g
         d0xuwaoLVJmWxgxF1Gkgm+Sxab4rLCWr932uNSo2lSlIJlTFvcOhyjmVidRplt+7+UXE
         GRKA==
X-Gm-Message-State: AOJu0YyUZjAe8LfeuPBSbJxUVoY5+ieEbje2AVXQd6sG8WmIdDUGlBbk
        ZglVsBrTx7anHfbmI0kq5Y78oDlgRRc=
X-Google-Smtp-Source: AGHT+IHFy6Z2B6TX5cvZ3QqsmLTdgDZNZyoDuthM3YMwP4/tCuZIqq0zhX3hLRzEEghmYVjFBeHBbfVKodU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:168e:b0:d7f:2cb6:7d8c with SMTP id
 bx14-20020a056902168e00b00d7f2cb67d8cmr223777ybb.13.1694444505636; Mon, 11
 Sep 2023 08:01:45 -0700 (PDT)
Date:   Mon, 11 Sep 2023 08:01:44 -0700
In-Reply-To: <20230911061147.409152-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230911061147.409152-1-mizhang@google.com>
Message-ID: <ZP8r2CDsv3JkGYzX@google.com>
Subject: Re: [PATCH] KVM: vPMU: Use atomic bit operations for global_status
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023, Mingwei Zhang wrote:
> Use atomic bit operations for pmu->global_status because it may suffer from
> race conditions between emulated overflow in KVM vPMU and PEBS overflow in
> host PMI handler.

Only if the host PMI occurs on a different pCPU, and if that can happen don't we
have a much larger problem?

> Fixes: f331601c65ad ("KVM: x86/pmu: Don't generate PEBS records for emulated instructions")
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/pmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index edb89b51b383..00b48f25afdb 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -117,11 +117,11 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>  			skip_pmi = true;
>  		} else {
>  			/* Indicate PEBS overflow PMI to guest. */
> -			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
> -						      (unsigned long *)&pmu->global_status);
> +			skip_pmi = test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
> +						    (unsigned long *)&pmu->global_status);
>  		}
>  	} else {
> -		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> +		set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>  	}
>  
>  	if (!pmc->intr || skip_pmi)
> 
> base-commit: e2013f46ee2e721567783557c301e5c91d0b74ff
> -- 
> 2.42.0.283.g2d96d420d3-goog
> 

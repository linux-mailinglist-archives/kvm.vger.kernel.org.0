Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949C7744411
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 23:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjF3VtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 17:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjF3VtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 17:49:19 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EB130F7
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 14:49:18 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-262e2cb725eso2132525a91.0
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 14:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688161758; x=1690753758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zTUka4vChlAMOHcpVhHgty9kj/qOPTWJd50kkZc81hM=;
        b=rHvFl4koS/Nebfb5q2rMzvlY3IzPjKCLC0q3nL4OZsNyKj7mRpsyhSWRkRZGdxuElJ
         a2w2GAHr5L1wtRqX6PVfNEH1G9dvLp7nm3FQ1+i2utLNjdsc8K/eumgNMk8kroYqvpFj
         zJ64Z89YSeQNwW/SRmPISAe7I9EtWem3EXJKH+VEbxEDJJsYpTU6kkbi8QjcNuzB90r7
         G3FqYjOeG42HYyqBU/pN7sLEpeuIxvKV9M3MvqGh6cMR/eda7bRt5LvX7sOc4oh+WB3f
         1mT259bNfSuPFIHRJaQqsvVFkTnrBpJR3Mn9v3CKxcbGZzS2GxO+z7GYPtZQ4IkOYyzm
         N3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688161758; x=1690753758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zTUka4vChlAMOHcpVhHgty9kj/qOPTWJd50kkZc81hM=;
        b=SQyuCbIvLGhSJDBXV9VsP7wmVWDGKLajLoKlytJ5iFJ587DSmWeoX8KMTgGlDj0I5R
         devh/GpyCarwBgmAO7qOAEsLdf4Sr0SokqD47cttTNVFyCYwTyZVu3/x0SaNrnl7VB1R
         vA/3KyCcC5Gb9/jxdQnqUniDlHWydrl0jTcHboFKx7/g3NQe3lZHO0gpf6daQb5DA46Z
         6ziNGUzsU6TSxEGepvkSx/T+fRGVfwsIUD1mSJRhHTppYeAqhCWztsOXXKBH7qUhWmxm
         qwGuECZJD7AVJlRt02HHjDc35V2M3Iw0qGPjdJI1lDq/bpIE+H+R0H4gIIMaGzHrhhoa
         Utxg==
X-Gm-Message-State: AC+VfDzkS3prvVuLAJcGGk2OB/Y7s8S4VNKsT8bAXfoSkyDIt+2DwjSx
        vROeYB4hxkVhmc7IYHU5F5gwvdXFPeE=
X-Google-Smtp-Source: ACHHUZ5HGnnUm8T1L1VacYYEQr/B4a0MtvpWAOIX8lbADrvRgJAvGdTHeJduKXjuDdP6rFPrOM+5e8UM5YI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3c03:b0:25e:cd8e:e85b with SMTP id
 pb3-20020a17090b3c0300b0025ecd8ee85bmr4235323pjb.1.1688161758313; Fri, 30 Jun
 2023 14:49:18 -0700 (PDT)
Date:   Fri, 30 Jun 2023 14:49:16 -0700
In-Reply-To: <20230615063757.3039121-6-aik@amd.com>
Mime-Version: 1.0
References: <20230615063757.3039121-1-aik@amd.com> <20230615063757.3039121-6-aik@amd.com>
Message-ID: <ZJ9N3GMNuKJXc5wQ@google.com>
Subject: Re: [PATCH kernel 5/9] KVM: SVM/SEV/SEV-ES: Rework intercepts
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023, Alexey Kardashevskiy wrote:
> @@ -2976,6 +2977,16 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  	svm_set_intercept(svm, TRAP_CR4_WRITE);
>  	svm_set_intercept(svm, TRAP_CR8_WRITE);
>  
> +	/*
> +	 * DR7 access must remain intercepted for an SEV-ES guest to disallow
> +	 * the guest kernel set up a #DB on memory that's needed to vector a #DB
> +	 * as otherwise the CPU gets stuck in an infinite #DB loop.
> +	 */

This isn't correct.  Letting the guest configuring breakpoints would be weird
and nonsensical, but it wouldn't lead to infinite #DBs so long as KVM intercepts
#DB.

KVM intercepts DR7 when DebugSwap isn't enabled because otherwise KVM has no way
of context switching DR[0-3] for the guest.  At least, I assume that's the case,
AFAICT the APM never actually says what happens with DR[0-3] when DebugSwap is
disabled.

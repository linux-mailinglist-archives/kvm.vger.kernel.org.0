Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D61268CAD8
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjBFX5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBFX5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:57:04 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E9B20D33
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 15:57:03 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id a5so6581112pfv.10
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 15:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x3gKOYcKtKvpnUNHeN8jhSozLmErJO9ze/Ruc4qjQAk=;
        b=OFB9uTeEr45wLRshrbqJnnQ+xH1fNS2KO3oY6bliZyueOCmW2Ofkw/lrRunkcohH0G
         4qPvIsK0nS/6zJqlCWku4yYKL1nnCkNJck9uV2FRrUK1N4TGN6qzjX91nZUPUy0kecWw
         o7jKHbUnn3VFzrUSIEPobpS7aTIt+9i7HQaISLx9CXxNs2VyjJR48X2c6uB02FGeqzB4
         9z/nF9CnQy/sO7/YfEFQbgFGplBUDsZCNiBFNtJR0CNhWuQZ4qQsqjIVuSssg/YXGd7C
         CZ0FSwxBjsHBcUhCa1m6Xz7yhnxmah5VvaLVkuVhZpNkjK1z+E4N0/+4Li9CSxMXhBr+
         F/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x3gKOYcKtKvpnUNHeN8jhSozLmErJO9ze/Ruc4qjQAk=;
        b=2Ri+L1hLvjeyD72nNEXgL+1AdN9Bo7A3SbufI8YCj3YcM1KwAQoCMO0A8kfSeKIlI/
         gtEcRstwjJb73+JmrRBxcSMqr2YtqyCWrVeKdkIx/RBYd/dDpoilHpOxWJhqKtGK3RO8
         9GMjtZVXeg2Xz031PzBhQ3R4IUOLV5KouONHFE09ADbCqtoj0ez9dOvabSTZjUrQu1Kd
         SK101G0KcWy9R1BnvxI7xBj2RDWkhwlPvdJ7uzQVn6JPYertSI6Ew1D8gNZSmqeZUHeI
         oZbOWpCWeFCd+0ANjUUP5exOuvw3qvjSJPAmPnONtUfDtZjbeu8/UXZlJrhTZdJ1Jxoe
         UCJg==
X-Gm-Message-State: AO0yUKXH/FypTlz+tM2opPfFZbC6qGfkWH14HaFW4r3+v0m4KW8xX/1F
        e4EhkPCqqLCwo5obVudQOvCyyQ==
X-Google-Smtp-Source: AK7set/ve+6Uoauy3qMrQfW3NXIvuw+hZtO/L+tw4j4Zt4GgGVGAic2LZsUQvnCTYINUAESjv+JBjQ==
X-Received: by 2002:aa7:999a:0:b0:592:4dc2:a2c7 with SMTP id k26-20020aa7999a000000b005924dc2a2c7mr1212676pfh.13.1675727822530;
        Mon, 06 Feb 2023 15:57:02 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id j23-20020aa78d17000000b005772d55df03sm29376pfe.35.2023.02.06.15.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 15:57:01 -0800 (PST)
Date:   Mon, 6 Feb 2023 15:56:57 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 3/5] KVM: x86/mmu: Optimize SPTE change for aging gfn
 range
Message-ID: <Y+GTyVHvpskr8YxD@google.com>
References: <20230203192822.106773-1-vipinsh@google.com>
 <20230203192822.106773-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203192822.106773-4-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03, 2023 at 11:28:20AM -0800, Vipin Sharma wrote:
> No need to check all of the conditions in __handle_changed_spte(). Aging
> a gfn range implies resetting access bit or marking spte for access
> tracking.
> 
> Use atomic operation to only reset those bits. This avoids checking many
> conditions in __handle_changed_spte() API. Also, clean up code by
> removing dead code and API parameters.

Suggest splitting out the dead code cleanup to make it easier to review.

> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 68 ++++++++++++++------------------------
>  1 file changed, 25 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 83f15052aa6c..18630a06fa1f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1251,32 +1228,37 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>  /*
>   * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
>   * if any of the GFNs in the range have been accessed.
> + *
> + * No need to mark corresponding PFN as accessed as this call is coming from
> + * MMU notifier for that page via HVA.

Thanks for adding this comment.

Can you just extend it to mention that the information is passed via the
return value? e.g.

 * No need to mark corresponding PFN as accessed as this call is coming
 * from the clear_young() or clear_flush_young() notifier, which uses
 * the return value to determine if the page has been accessed.


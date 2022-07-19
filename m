Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4336657A9F4
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 00:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbiGSWnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 18:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbiGSWnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 18:43:01 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE95D59249
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 15:43:00 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z3so940643plb.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 15:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3mBMNTNhashQoUW+48e8V6j0bFm9Antzk3St87vtHyQ=;
        b=sbILa/KKpaY/yaJBO8yP6X5Tf3PfNDgbJK2WWJHf09SLNUW9sePi5k4LtP7CecLnZF
         z8fHFi8S7PTaNe1ny88KxX7bgthd9DzxzNmusdUgsJgPP/AJMFV9y2lG7kp4kZsbr47c
         C1j/haDut2mgx72jxqeWBejL/dW7ib+P+TQ8RxkzsgqM/QDGaRtAOa1rSXd2azdEeXfY
         Yx5RwTeDcj3fk0AQNkcXqwv7sQbaDnWD1HwtoW6p0CRh95uq5d3mrTX4G+1xmXdSA9wa
         r+fj/ruXM3x1yjXDQ+/Gp6K+jMJ4MhxMx7v1rCIFwt8AW1HrE2IRLHkMhITdo/QMOV2/
         YiLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3mBMNTNhashQoUW+48e8V6j0bFm9Antzk3St87vtHyQ=;
        b=WB1DRSV2vWg+tDQXb/6W2pZVua9fXP94D0YTIxf5KcYBuqKAxFvgLAgGdvROBu7DxZ
         +2iU5vNZaF7SDNNrYZQ+m2QLbnfbZv9PEf3ry4jWdHcmyPLiKID3B8f0UA2e5ABgl5qV
         GMM2WrayP/2N9C/w+DflkMrbbFZ/eCbKY6i8V3a/NuB7aepuhd0ilGL0cmrFFKA0/5tV
         kN+Ds9E+nXnVMpAc4I+5XeNY2BmQrMC5o/vXuuBgLICFOs7FBfRRk/3GJI2MBMwnRaDA
         9AoVXG4f86JBflIYSMfVLmIOa3I2+Ffyd4iPN0WN4JQ7DZjjOodl0khHsEfrgrioOSnJ
         eDHg==
X-Gm-Message-State: AJIora9ro/v0tjSNwaGJLwAAH2ahd19Ul8Q7/4XIEhNzNb1GUmtVfUmS
        cwE3YBPEAnpI7rv8PJxkBAJA+Q==
X-Google-Smtp-Source: AGRyM1vPLoWkMbH196Cy88DSN5XsqMQVREA4QruekZ7i34VY83xVjisjTYv51mdZYk9VzlutlXr9Jg==
X-Received: by 2002:a17:90b:1b42:b0:1f0:447f:995c with SMTP id nv2-20020a17090b1b4200b001f0447f995cmr1791428pjb.200.1658270580349;
        Tue, 19 Jul 2022 15:43:00 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y36-20020a634b24000000b0040cfb5151fcsm10496778pga.74.2022.07.19.15.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 15:43:00 -0700 (PDT)
Date:   Tue, 19 Jul 2022 22:42:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 07/12] KVM: X86/MMU: Remove the check of the return
 value of to_shadow_page()
Message-ID: <YtczcE8bxNJfWwZ5@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-8-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-8-jiangshanlai@gmail.com>
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

On Sat, May 21, 2022, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Remove the check of the return value of to_shadow_page() in
> mmu_free_root_page(), kvm_mmu_free_guest_mode_roots(), is_unsync_root()
> and is_tdp_mmu() because it can not return NULL.

s/can not/can no longer, to make it very clear the to_shadow_page() _could_ return
NULL in the past, but something changed.

And please explain _why_ it can no longer return NULL, even if that's just a
reference to kvm_mmu_alloc_local_shadow_page() or whatever it ends up being named.
That can also tie into the obsolete sp handling.

> Remove the check of the return value of to_shadow_page() in
> is_page_fault_stale() and is_obsolete_root() because it can not return
> NULL and the obsoleting for local shadow page is already handled by
> a different way.
> 
> When the obsoleting process is done, all the obsoleted non-local shadow
> pages are already unlinked from the local shadow pages by the help of
> the parent rmap from the children and the local shadow pages become
> theoretically valid again.  The local shadow page can be freed if
> is_obsolete_sp() return true, or be reused if is_obsolete_sp() becomes
> false.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---

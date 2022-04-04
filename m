Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADE04F1C0B
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380609AbiDDVVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379571AbiDDRfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:35:31 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0C8D59
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 10:33:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id s11so4323461pla.8
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 10:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3eEb1Fbi03Tqfrd9+V/qD2RzIsPJ4iRE2QaaWt7eods=;
        b=l/xcKvP+X/QNDFo8xztJ73QES2Bgc0urPyjP8JRiWoVOq7xTRLys6nwW8ykl/7cTKd
         QoKEoYcj9dyoHPKku12UZfF5UyXIUp+ZVpz+cxWV9sWRVB1ae0+hkVGKeUFMsK9jUu2F
         lwCfZWPoxX8GfuuLJ8ecimBfibmEtZxJq1kwvqzoaWxoEQbrgOeTLOZgV6c3wRJEEeQx
         rCtwRHS1vfYQZwpsM3vnxgWTVgBZ66YUQIfmChct9n8ArkKRUgBO2Rt49Uxq2WUSblwM
         WQUlsfWFVlj/hPdKjyWf1QFXQntETu4xbL4dJOTqNP0N7lFCJZOAfmvDeVZEy4+yfyoX
         HXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3eEb1Fbi03Tqfrd9+V/qD2RzIsPJ4iRE2QaaWt7eods=;
        b=QOHSzs9dLZcnD36jKEqZF8hI/KuCChlmZoAXXXouxADEcSBMw+v2f8Rr7o89ut7xLS
         1CEuc8+Q3uajZYe2iDbF34rqge1sfsRleNVflr3bMuKtxSCMZQZS5rWMxURWLitHwe1I
         GnDkb9bLK8fhC3KyxrT8qTFff4ioV3Fn74Ov4KdQ4HtcgKnavwWlhS73YJcJCjkhIjCH
         ZZIMVANaINOfQ4Lr5hX5RpG6XGPI2iAWlPMn/gzd20JNwye//sHjrB6744tvH8Of34PF
         b7SJvY7hylQnl8zOkCk3VG9ohWDgb1bIa6efqgoT2BYWixaMrk88vVnrgiEmUNVimlI0
         dtHQ==
X-Gm-Message-State: AOAM530wblEY77wsVY5JlT7iwnKRVe+Wbq/UoDX2QCrYTRJtwoCldMCf
        R0cBEWH81JRmZST6X3J+JbZUlQ==
X-Google-Smtp-Source: ABdhPJxYv9sp2wZAlY2XXftWgMKjZXUHM83ydJOkHJkf644kZkqhPJr0fwd+bpDuyqb2kqscBTDZJw==
X-Received: by 2002:a17:903:22c9:b0:156:9c66:5cf4 with SMTP id y9-20020a17090322c900b001569c665cf4mr768264plg.22.1649093613751;
        Mon, 04 Apr 2022 10:33:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x67-20020a623146000000b004fdf02851e5sm6463233pfx.220.2022.04.04.10.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:33:32 -0700 (PDT)
Date:   Mon, 4 Apr 2022 17:33:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@kernel.org
Subject: Re: [PATCH 2/4] KVM: Only log about debugfs directory collision once
Message-ID: <Yksr6etwnN0iW8ZH@google.com>
References: <20220402174044.2263418-1-oupton@google.com>
 <20220402174044.2263418-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402174044.2263418-3-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 02, 2022, Oliver Upton wrote:
> In all likelihood, a debugfs directory name collision is the result of a
> userspace bug. If userspace closes the VM fd without releasing all
> references to said VM then the debugfs directory is never cleaned.
> 
> Even a ratelimited print statement can fill up dmesg, making it
> particularly annoying for the person debugging what exactly went wrong.
> Furthermore, a userspace that wants to be a nuisance could clog up the
> logs by deliberately holding a VM reference after closing the VM fd.
> 
> Dial back logging to print at most once, given that userspace is most
> likely to blame. Leave the statement in place for the small chance that
> KVM actually got it wrong.
> 
> Cc: stable@kernel.org
> Fixes: 85cd39af14f4 ("KVM: Do not leak memory for duplicate debugfs directories")

I don't think this warrants Cc: stable@, the whole point of ratelimiting printk is
to guard against this sort of thing.  If a ratelimited printk can bring down the
kernel and/or logging infrastructure, then the kernel is misconfigured for the
environment.

> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 69c318fdff61..38b30bd60f34 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -959,7 +959,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  	mutex_lock(&kvm_debugfs_lock);
>  	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
>  	if (dent) {
> -		pr_warn_ratelimited("KVM: debugfs: duplicate directory %s\n", dir_name);
> +		pr_warn_once("KVM: debugfs: duplicate directory %s\n", dir_name);

I don't see how printing once is going to be usefull for a human debugger.  If we
want to get rid of the ratelimited print, why not purge it entirely?

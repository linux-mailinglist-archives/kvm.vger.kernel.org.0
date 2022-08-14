Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1519591D60
	for <lists+kvm@lfdr.de>; Sun, 14 Aug 2022 02:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbiHNAx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Aug 2022 20:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240162AbiHNAxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Aug 2022 20:53:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F89B8274A
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 17:53:22 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q16so3806425pgq.6
        for <kvm@vger.kernel.org>; Sat, 13 Aug 2022 17:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=jofgmKhxh1t9fhLakJOdgJ9K7nYkZv3Rdys2VmAxWeg=;
        b=ULaG/37CEyYC40FoGyGLlMqUzBHHmg8nFqL/UwnM0PCmRU+xpN5GvvwI3PcYLFSsCv
         pG3ZhNVXKqfBxlKDTxy5AHS5cmovBGguWy8e0DoTyi4j11foq/nR38lhnR7GP//gOHrV
         jV/q00cBqPGImFOjvVDC54zAz63L7yOmeC9KqupDLadz/kpwC/2n3F3H69CalBmptkda
         qbaDIl8QthoLk2bA3oU6WATc1I74kv1ofLwuB5bp2BIAQ3qewOktPfJRZr6+iUgn6rwG
         dvoHXuhY0QDic5KDT2hJy2iAiOJqrdKVNkoYIg1QqbQLiGMHQtmxa2VdIU40shM3ut7C
         PJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=jofgmKhxh1t9fhLakJOdgJ9K7nYkZv3Rdys2VmAxWeg=;
        b=F7kVF5Jf20TmU8wHVnwanCvDY8fqf/Jg9RJO8pb8CfClYcIO6uiuIEUa2WSP9wDKKb
         1psGNSwW0vY2vDA/plvNhY5NBd0sNRAqkARntzhj/qek9+fv/ecwNHCMd/3AestW1QjF
         ykyH+WVTPFJfs18Ke+m9cG6Ho7rGxzqAmajMS9QPYSoaWppxqUphuR5mBzl499xhxrla
         OOnyQrYUqkrEkmVFAG7+yggVshZ1la87RxL/I1INdLjOdG7elLn2OzBYTnGeQ/ECRojw
         NSGRdNXM+VJcYdmN7svwVRN3DhEEA4PRRpfuIqiKcAwD9Jt7uEr+cr5J91YJ2WbZYjpB
         btrw==
X-Gm-Message-State: ACgBeo3D6Q4tkVvCX8RMKQSMBlcs4tgDEcLZFdpW9YnV+2cTNYvnejIQ
        dNNrg+AxH5ZDJisKm58s9Xb2Ew==
X-Google-Smtp-Source: AA6agR5PqpCiAIzFuopGFHzgg8EwzkWYiRbWREcn3rxJrDJyCIjX4fa4z0/Ddc/zajJvW4340OXFgQ==
X-Received: by 2002:a05:6a00:b87:b0:52f:35bc:f904 with SMTP id g7-20020a056a000b8700b0052f35bcf904mr10347532pfj.74.1660438402005;
        Sat, 13 Aug 2022 17:53:22 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b0016d6963cb12sm4326543plg.304.2022.08.13.17.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 17:53:21 -0700 (PDT)
Date:   Sun, 14 Aug 2022 00:53:18 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 1/8] KVM: x86/mmu: Bug the VM if KVM attempts to
 double count an NX huge page
Message-ID: <YvhHfkbkVCWPy12W@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805230513.148869-2-seanjc@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 05, 2022, Sean Christopherson wrote:
> WARN and kill the VM if KVM attempts to double count an NX huge page,
> i.e. attempts to re-tag a shadow page with "NX huge page disallowed".
> KVM does NX huge page accounting only when linking a new shadow page, and
> it should be impossible for a new shadow page to be already accounted.
> E.g. even in the TDP MMU case, where vCPUs can race to install a new
> shadow page, only the "winner" will account the installed page.
> 
> Kill the VM instead of continuing on as either KVM has an egregious bug,
> e.g. didn't zero-initialize the data, or there's host data corruption, in
> which carrying on is dangerous, e.g. could cause silent data corruption
> in the guest.
> 
> Reported-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3e1317325e1f..36b898dbde91 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -804,7 +804,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  
>  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -	if (sp->lpage_disallowed)
> +	if (KVM_BUG_ON(sp->lpage_disallowed, kvm))
>  		return;
>  
>  	++kvm->stat.nx_lpage_splits;
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 

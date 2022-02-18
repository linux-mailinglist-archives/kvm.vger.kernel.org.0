Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AB84BC322
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 01:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240288AbiBSAAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 19:00:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbiBSAAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 19:00:16 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177542599C0
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 15:59:59 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id l19so3591668pfu.2
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 15:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bF+kadvtXphhO74WqkXqArBv71tts+NWvqqIHsF6pqU=;
        b=fR9iTp6Jc38F95EPHtI42XUM74mmtiWgyfLjsrZq+94KR33LFTdbWl73/13Q0m+1Il
         iN4McXYYOkb9kHHDSdXqaipcdhZ+BnoPP9gnI0a+7wXOwIcNi1id3Gt5Fz+cWg7yyoNC
         CR/wnlTyV/CbjIOD3s2DATFcJCbHDt8f40ddcz2lBQI4qeMWO7NM11YUyvVJbg1kvzeA
         vEx/m+ZDhtvfzTtewb5FGXtqhmLLUGTG32HmTk9vqmDzvzWkzhjBJqOfgHEkliD+gSQX
         g+DW7YsQ+XO0rtpZ0GwnWAzCKL9889gMKT0+U85EnD5OS6ihiHWczZnkBpga76NFv2T2
         6/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bF+kadvtXphhO74WqkXqArBv71tts+NWvqqIHsF6pqU=;
        b=Khb1ml3nnRr6cUekpu0pxkBByQdxaCzaTdsgIbc6+k1bf0ktxJjhBgeQdhyOLnhKqt
         PgXq3uDdNCrd9JNGA2KryMzB1H5tfdTsBhN+7mNsuwauftkwe1xJxr4ZQloYyEH8uE6S
         4/I6xwJxKH3SRZRGDNC8tQqdIydPP4jOHIOHgCOB0hPig7/7IGWOPVgMAD4NKUI6M9IC
         3eEV33p3ztDHC82DcafVhGhCYoW10yxQAPbNgGJKtD/5BOvEtl6e5rYJhEbwJXGh6CsA
         6O582KyGYgdasWySvfdCwtmTjNVVflI7vnt9lVPCEW5hxB/j+FpYY9WBhcOzcgSreduK
         mlxw==
X-Gm-Message-State: AOAM530dmaujWt/p9nw4ORLrdlVcMT8xieU+PXBl59+lUtSIwsQmuKJZ
        ypNn/DMSe8PVQsV1cV416silxw==
X-Google-Smtp-Source: ABdhPJw5EQVwQses0OZ5O/BbE5LuFqDk2NwDxSOBbA/mnTV4r7uT5knR9p1zTWZP4nqy9lrMqDkSaQ==
X-Received: by 2002:a63:f357:0:b0:373:9242:6b95 with SMTP id t23-20020a63f357000000b0037392426b95mr8113263pgj.536.1645228798470;
        Fri, 18 Feb 2022 15:59:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f8sm1192550pfv.100.2022.02.18.15.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 15:59:57 -0800 (PST)
Date:   Fri, 18 Feb 2022 23:59:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 11/18] KVM: x86/mmu: Always use current mmu's role
 when loading new PGD
Message-ID: <YhAy+lFk+pEIt0gf@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-12-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-12-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> Since the guest PGD is now loaded after the MMU has been set up
> completely, the desired role for a cache hit is simply the current
> mmu_role.  There is no need to compute it again, so __kvm_mmu_new_pgd
> can be folded in kvm_mmu_new_pgd.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

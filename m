Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A76B578047
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 12:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiGRKyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 06:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiGRKyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 06:54:31 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340F4D11D
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 03:54:30 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bk26so16428695wrb.11
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 03:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EnNyVXrZhTsXbUVxkr3n4VsUhRgF1qEMC8DKDk1V3bg=;
        b=rA1jEp0LpZP1+P6mDlvjxu6wXht3l3c85gezvxbNTLmGEt+mwhGqy8ciWXMPEiQhsV
         Py0iFtckCil7igYZcFp6sDt9mXipN8SxsYKXB5MT84MHrGLgoU3DpAvT4AD37DSgCo41
         O2wryFz75Kg83wzds9RuyLwCZeqZc7MgLh7CfbywkTH7Ra8ougAgyYpb/Yl90sKTdEFV
         9X6BfYNDnl6+npLtohqcJirL2eijkmdGaL+ShhNBfVUdkzqXuAlyfZMAB0qlmZ5JYBc3
         HFpTXa1MudIGNW7loLT1zL2/chxy33iqWg5/mSXStWMV3XpVFqIWy2xSLd3ZT3tBeNR5
         RBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EnNyVXrZhTsXbUVxkr3n4VsUhRgF1qEMC8DKDk1V3bg=;
        b=XUKgyhaHPx+L8LcQlKgL9xqocQUMuPlhtXa0jiO0811YTnBxwKjfCLkoms/ymGXjCL
         9B5xtQ3gAg8MPnRJjCxjMLTl1ia43QtX0SfzSt5ob3ynQsroUmlxjbrnlsCZ/pFzQlm6
         hci1Iebtxd/VlRt0a8roXigiJrCiea6/ls4eQWEWfTONRL898W4UwYvBrhrnodTVgF/z
         JlmO6YAVbtTr3m+1DdHTDu0tG3b4R5oYQOp/nexh/FI5Kh0GsifpIuj6cX2LGValJeCa
         YH4Q0FtCet0/Npg8R/bXevMezcozo9y8ZEnaPEcf2rRbjMu3MHbz1gfmV+vzLwk3A4YI
         IfSw==
X-Gm-Message-State: AJIora9yFtX9wZGnOPTMHHFjsPH8UQv4NKeUUGGvtItJYkZ0wcsaT6er
        yNodEu4CtphwWik/3CveFTjlsw==
X-Google-Smtp-Source: AGRyM1s++fQ9NM06ad06/mDC5sdqkaLBhNndHCSSldelrOBvrP9ZoL8WSbkS9NkWyl/ehH7BaNd77Q==
X-Received: by 2002:adf:d20e:0:b0:21d:7654:729b with SMTP id j14-20020adfd20e000000b0021d7654729bmr22523907wrh.239.1658141668639;
        Mon, 18 Jul 2022 03:54:28 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id o42-20020a05600c512a00b0039c457cea21sm15087975wms.34.2022.07.18.03.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 03:54:28 -0700 (PDT)
Date:   Mon, 18 Jul 2022 11:54:24 +0100
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 03/24] KVM: arm64: Add flags to struct hyp_page
Message-ID: <YtU74D9fcLCpHHwc@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-4-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-4-will@kernel.org>
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

On Thu, Jun 30, 2022 at 02:57:26PM +0100, Will Deacon wrote:
> From: Quentin Perret <qperret@google.com>
> 
> Add a 'flags' field to struct hyp_page, and reduce the size of the order
> field to u8 to avoid growing the struct size.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  6 +++---
>  arch/arm64/kvm/hyp/include/nvhe/memory.h |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 14 +++++++-------
>  3 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> index 0a048dc06a7d..9330b13075f8 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> @@ -7,7 +7,7 @@
>  #include <nvhe/memory.h>
>  #include <nvhe/spinlock.h>
>  
> -#define HYP_NO_ORDER	USHRT_MAX
> +#define HYP_NO_ORDER	0xff

BUG_ON in hyp_page_ref_inc() might now need to test for 0xff/HYP_NO_ORDER
instead of USHRT_MAX.

[...]

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C177E606845
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 20:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiJTShH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 14:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJTShG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 14:37:06 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9293E1FAE5E
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:37:05 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y1so378601pfr.3
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 11:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xpGs2us7vJ/1PgIyeRQg1QvX2YWRQI4pAV7rF5cc6cY=;
        b=AAFWCZ6WzW+YbePPkLpshonjKSklzzlQagf7LA8j6A4pgwR3zMizz+4Zt7ggSw7IvB
         l4UUK8K5iqfjrgC1H5TWjIcP6xT+31IVezM1gbWPBtbm0ZOc9h6egvKH5zRPeKx95oNT
         iVhiD6XDAq0ZJ+/jfO91dQJsW67pXhAjzXJDFF3X68iK8jzeKQLt8oqzHU9YYqVLUXBr
         omUqePu8MXISV2f7oGWZ8yfYC1an1Rd5/qW2kv3aGyn64W1Sj1kz6iJzUYkXXCxZL/Zb
         lHZ/Nuh9mKszeUoA9YJbLNVO3YwMXa5QUMyLBLihZntPY+ZvEh3Mb4AJGRZjMDwp2rbc
         iu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xpGs2us7vJ/1PgIyeRQg1QvX2YWRQI4pAV7rF5cc6cY=;
        b=K/+PEkfY5LLf32jMn99zBAK3uJEDVlj1dAAWiZrubytC4L99HU9XvJmAkielGwDKnb
         Kbwzk+7CVOZOuvtL5ESufwvReDcNrohGtimiTIalrU/rR6dj0TiMAq2szqXI9X4C18FR
         2gc90r2nXmERPVt5k3rc+QKaIBtozS0ob9f8ji0bPd9csc6YCz1VK1VFKjyFFKrR0syG
         ztVJ25LfiF6fCGtTt/0a+Ym3xiZgXSPVYUaYU2y6u2ddeoY7iA1xvUnVMO8J4imrcdMA
         XR1OeW9DWECzu/0oCkY74ZO/fUYE+t2rBsgVK8nJQNFXvMWK9I/wItJTlmb2PD/TIJyF
         L5xA==
X-Gm-Message-State: ACrzQf1OhyC1+4MJND6oNS/3DAyQd6NUQ3N/mwXLj18gmCHtinFzGZrR
        GGwq36TKkaKOzC9rYjyiJquvUqc+XC5VDg==
X-Google-Smtp-Source: AMsMyM4sIeIROxnqtovav5o809J34HJTe6OGsj3n0G2ST83Qr46fjXhbN0J8wCeGKM54KaLU0dOjDw==
X-Received: by 2002:a62:84d1:0:b0:565:b27c:8140 with SMTP id k200-20020a6284d1000000b00565b27c8140mr14946005pfd.14.1666291024972;
        Thu, 20 Oct 2022 11:37:04 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 73-20020a63064c000000b0043c732e1536sm11932315pgg.45.2022.10.20.11.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 11:37:04 -0700 (PDT)
Date:   Thu, 20 Oct 2022 18:37:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 13/16] svm: move vmcb_ident to svm_lib.c
Message-ID: <Y1GVTMo5/GGmx53U@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-14-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020152404.283980-14-mlevitsk@redhat.com>
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

On Thu, Oct 20, 2022, Maxim Levitsky wrote:

Changelog please.  
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/svm_lib.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
>  lib/x86/svm_lib.h |  4 ++++

What about calling these simply svm.{c,h} and renaming x86/svm.{c,h} to something
like svm_common.{c,h}?  Long term, it would be wonderful to rid of x86/svm.{c,h}
by genericizing the test framework, e.g. there's a ton of duplicate code between
SVM and VMX.

>  x86/svm.c         | 54 -----------------------------------------------
>  x86/svm.h         |  1 -
>  4 files changed, 58 insertions(+), 55 deletions(-)
> 
> diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
> index 9e82e363..2b067c65 100644
> --- a/lib/x86/svm_lib.c
> +++ b/lib/x86/svm_lib.c
> @@ -103,3 +103,57 @@ void setup_svm(void)
>  
>  	setup_npt();
>  }
> +
> +void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> +			 u64 base, u32 limit, u32 attr)

Funky indentation and wrap.

void vmcb_set_seg(struct vmcb_seg *seg, u16 selector, u64 base, u32 limit,
		  u32 attr)

> +{
> +	seg->selector = selector;
> +	seg->attrib = attr;
> +	seg->limit = limit;
> +	seg->base = base;
> +}
> +
> +void vmcb_ident(struct vmcb *vmcb)
> +{
> +	u64 vmcb_phys = virt_to_phys(vmcb);
> +	struct vmcb_save_area *save = &vmcb->save;
> +	struct vmcb_control_area *ctrl = &vmcb->control;
> +	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK

Ugh, a #define for '3' and '9' (in lib/x86/desc.h?) would be nice, but that can
be left for another day/patch.

> +		| SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;

Pre-existing mess, but can you move the '|' to the previous line?  And align the
code?

> +	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> +		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;

| on the previous line.

	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK |
			    SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK |
			    SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;

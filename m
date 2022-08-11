Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AB159070F
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 21:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiHKTlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 15:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbiHKTlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 15:41:46 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439D995AD2
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 12:41:45 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d16so17761288pll.11
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 12:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=FTvV+r4SxFTcnoWh01bKEFwjf+Gpnp38zT+sxZWWUUM=;
        b=kvYz6HUUDvbG0h7v8a4t4DEYCK7c5eq9K3pXYJCLg9Ny64+dzzVhzf8tyZEEoQlCQE
         fn3m1TAVzJcw+3oCn/C9AXuJW5wUby8TRE2ssPQ2MbiyLxl2vpWxQzz1Ew78hWs7cnVG
         LoPbkfS7d6PwjOybPfjUF24h7tdPmD2MBuwtjkBrtfw33ShzqljOhJTfedZkjUiNL1uk
         4MuX2izHAVRz0p6cawvIqvu48X2huz9jyJDOJFjJhHRJgENcgElE5ztflFHmTgOYHTS9
         /QhLWkED1JW896elvU2ufc7BVClks1I8iPpPGbBugLLcgmBDhkqThkDWRxLPZWWM7SN3
         VUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=FTvV+r4SxFTcnoWh01bKEFwjf+Gpnp38zT+sxZWWUUM=;
        b=5DVFuODNQRcQ2FK8mzDvkF4wswWJZECeaf7jLZ8AZ1igWJdlSj5RlaKKBcaVVU2zKq
         C+wuyshTBb+UeKEbOmf2p5kyPKW+BO8v/6SXWQrT1aJ4hIn+Rn0T3EizpsRRm4osc1cb
         8cfBzHfiSoyMShhiYQEJ2bAapmYD5HnhIh0Yip3UUjqkxzEzSYEzP4cX3+7Wvm4SfRaO
         dU0gMDH735cusL6JUWkWJegvcOu8YM1VScmbzfoF7ozSpVLV2KN773yQW8xlyj8Fy7ol
         o0VhNB132v7WAp6fqPDhYe9OSR42y9M/nQ9ZqvdNDNuPJCT1xGfF21YJVAPwDOY6dHKm
         RsYg==
X-Gm-Message-State: ACgBeo3KdQZ8cxflj8AvAN3gwgbQ2fC9NEp9WJX3w44HentVnIveOieL
        fLwdifIlEFatJ8wxLoo0PUKlUA==
X-Google-Smtp-Source: AA6agR4ZzMi8yCe2GmWkNjY/xLNXCNUJi+1T7JQUYJfvWciCxoXZ+4zfVV7IB6MVrEFiaUWsM0x3WQ==
X-Received: by 2002:a17:903:2309:b0:16f:784:ea5c with SMTP id d9-20020a170903230900b0016f0784ea5cmr736811plh.100.1660246904618;
        Thu, 11 Aug 2022 12:41:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i128-20020a626d86000000b005281d926733sm50192pfc.199.2022.08.11.12.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 12:41:44 -0700 (PDT)
Date:   Thu, 11 Aug 2022 19:41:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 2/3] kvm: Add new pfn error KVM_PFN_ERR_SIGPENDING
Message-ID: <YvVbdFEhNKJUXVDB@google.com>
References: <20220721000318.93522-1-peterx@redhat.com>
 <20220721000318.93522-3-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721000318.93522-3-peterx@redhat.com>
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

On Wed, Jul 20, 2022, Peter Xu wrote:
> Add one new PFN error type to show when we got interrupted when fetching

s/we/KVM

> the PFN due to signal pending.
> 
> This prepares KVM to be able to respond to SIGUSR1 (for QEMU that's the
> SIGIPI) even during e.g. handling an userfaultfd page fault.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/kvm_host.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 83cf7fd842e0..06a5b17d3679 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -96,6 +96,7 @@
>  #define KVM_PFN_ERR_FAULT	(KVM_PFN_ERR_MASK)
>  #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
>  #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
> +#define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
>  
>  /*
>   * error pfns indicate that the gfn is in slot but faild to
> @@ -106,6 +107,16 @@ static inline bool is_error_pfn(kvm_pfn_t pfn)
>  	return !!(pfn & KVM_PFN_ERR_MASK);
>  }
>  
> +/*
> + * When KVM_PFN_ERR_SIGPENDING returned, it means we're interrupted during
> + * fetching the PFN (a signal might have arrived), we may want to retry at

Please avoid "we".  Tthe first "we're" can refer to KVM and/or the kernel,
whereas the second is a weird mix of KVM and userspace (KVM exits to userspace,
but it's userspace's decision whether or not to retry).

Easiest thing is to avoid the "we" entirely and not speculate on what may happen.
E.g.

 /*
  * KVM_PFN_ERR_SIGPENDING indicates that fetching the PFN was interrupted by a
  * pending signal.  Note, the signal may or may not be fatal.
  */

> + * some later point and kick the userspace to handle the signal.
> + */
> +static inline bool is_sigpending_pfn(kvm_pfn_t pfn)
> +{
> +	return pfn == KVM_PFN_ERR_SIGPENDING;
> +}
> +
>  /*
>   * error_noslot pfns indicate that the gfn can not be
>   * translated to pfn - it is not in slot or failed to
> -- 
> 2.32.0
> 

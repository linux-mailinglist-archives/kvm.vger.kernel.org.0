Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CED496452
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 18:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382039AbiAURnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 12:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381001AbiAURmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 12:42:35 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDE1C061760
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 09:41:33 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id w190so3330052pfw.7
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 09:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A08Ccraan/AKDZfYkDQ9mm3WlR3VsKmTkfr8toIHlHM=;
        b=SGlFOIc1sMpla6BJvpx4/MxlT+28zl3a04jhvp9QYpl3fcIV5eG2dstIg8QMh4Skqk
         j85T224IZJnztnH97jgYW8ZTn4UJmNlUz0+pXo0DPZjflSbnBWs/DNAdv6/lOsvCMm97
         txFAE6oxn9ua3mqQbuzJTBCEKzQl6A/fjDuZPGbjaQUemCkJNSrkDEE6Hxz7iZmaEC1k
         NvbGw7HxfULDHyJITSJmX3gmsRbnHiJW4KcLdx5BnKH4O3Lj/ozACUpRXHDYg4GxekaE
         ZFkmLA5iC49F5xOeXYvO92wTGORrqtm+z7fO0VOk/RDRrEWGHOZKp+te7Z2N7WjQOx3q
         vZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A08Ccraan/AKDZfYkDQ9mm3WlR3VsKmTkfr8toIHlHM=;
        b=vFTChMM/i5lCcHzIDzg/ARUWDEYvrTWoC0B2Y3RVB5h57NsyFBPt8dU6rQZeMQ9/kI
         vbOpKmfHMZJ5TkACgSAiWNwbyIU0hGG7FdGKAr8XamSWCE7pNLwiy3fpt40NpldVhto/
         WntWVCPkrPRnlpjnrzhd6d8ZNNeRf2uGi0z4DBBQe9adtPlXwEZz0pcn3nVeQX4nich0
         waYUnNpGYeocmo5sDT86OXnK9tabaZMCK4zJBk5vy14UZGWUN3Sk5XDUxmh2o96UVy3O
         Scxh9RxVvy8nuAw5Q5Qh2nMnexssBTWfamzeK7Bsr1miwGRmYvIf+56+qSM8D40d2Ez5
         CaSw==
X-Gm-Message-State: AOAM530lQy9t6FwehJp9t2J1JCfSsk1NmZSXys3p46tfcYBZLZ9VzQBI
        uLBVNRxvyWxcWmJlg55deouyLg==
X-Google-Smtp-Source: ABdhPJzSXXvOYYHgRVPijDxuwCBBXp7YZtFak1w6xBQ8ACTqju/uw6i23EnKaSSYWU+nGZLjHwaw7w==
X-Received: by 2002:a63:f807:: with SMTP id n7mr3761498pgh.162.1642786892851;
        Fri, 21 Jan 2022 09:41:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p64sm5361656pga.13.2022.01.21.09.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 09:41:32 -0800 (PST)
Date:   Fri, 21 Jan 2022 17:41:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH v4 2/3] x86: Add support for running a
 nested guest multiple times in one test
Message-ID: <YerwSEIvpVs9un23@google.com>
References: <20220121155855.213852-1-aaronlewis@google.com>
 <20220121155855.213852-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121155855.213852-3-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 21, 2022, Aaron Lewis wrote:
> KUT has a limit of only being able to run one nested guest per vmx test.
> This is limiting and not necessary.  Add support for allowing a test to
> run guest code multiple times.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  x86/vmx.c | 24 ++++++++++++++++++++++--
>  x86/vmx.h |  2 ++
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index f4fbb94..51eed8c 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1884,15 +1884,35 @@ void test_add_teardown(test_teardown_func func, void *data)
>  	step->data = data;
>  }
>  
> +static void __test_set_guest(test_guest_func func)
> +{
> +	assert(current->v2);
> +	v2_guest_main = func;
> +}
> +
>  /*
>   * Set the target of the first enter_guest call. Can only be called once per
>   * test. Must be called before first enter_guest call.
>   */
>  void test_set_guest(test_guest_func func)
>  {
> -	assert(current->v2);
>  	TEST_ASSERT_MSG(!v2_guest_main, "Already set guest func.");
> -	v2_guest_main = func;
> +	__test_set_guest(func);
> +}
> +
> +/*
> + * Set the target of the enter_guest call and reset the RIP so 'func' will
> + * start from the beginning.  This can be called multiple times per test.
> + */
> +void test_override_guest(test_guest_func func)
> +{
> +	__test_set_guest(func);
> +	init_vmcs_guest();
> +}
> +
> +void test_set_guest_finished(void)
> +{
> +	guest_finished = 1;

Adding test_set_guest_finished() should be a separate commit.

>  }
>  
>  static void check_for_guest_termination(union exit_reason exit_reason)
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 4423986..11cb665 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -1055,7 +1055,9 @@ void hypercall(u32 hypercall_no);
>  typedef void (*test_guest_func)(void);
>  typedef void (*test_teardown_func)(void *data);
>  void test_set_guest(test_guest_func func);
> +void test_override_guest(test_guest_func func);
>  void test_add_teardown(test_teardown_func func, void *data);
>  void test_skip(const char *msg);
> +void test_set_guest_finished(void);
>  
>  #endif
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194555F5D8C
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJFAO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiJFAOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:14:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAFA356ED
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:14:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o9-20020a17090a0a0900b0020ad4e758b3so193988pjo.4
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NPRVzBaVZ9YyNu6FLenRmgIhaa2hp6qDkfP+CaVAIGk=;
        b=mXMNHH5XOl9a3BpyRf0OW6UGuW1+o3c6nzSKeK5JBv9QS9paVtX4nkcuw6ilwpO8M9
         pTD6cSMXs+0UvLHDnlJ4F4/rsxZfru1+vLHH/UfKYRY2y1BXCwsA4cs2LCOCcLGbJ48t
         9Dc0pS8GCk+589pZrnZCC4pCk77x7UkKvxioO7XEHs1YTrBJLoT2dwArISPIUhXvM3yY
         /ZF6wWLK/ghCYPh397SdcvDfclw+HCck00Nhaf5skY2HA/6pCZvNqKc8cj/29lGeZaGw
         JepT+QwpU9qas/Rpba6GzdH4qUD/MJSh/l10+RskCMaNwY0GqnMejOC32nh0dn/mtALK
         VWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NPRVzBaVZ9YyNu6FLenRmgIhaa2hp6qDkfP+CaVAIGk=;
        b=p2xz7vEikWQrIqp5XAjlK3j0cDsiWqKkcia7xvNO2CzqKTg4QtWtUhGy515AU3Y3zn
         9OBt+Eqa/AJ/EXeQkL4snztsirwFJ7Q893f8gQ7WnSzxGFfZMvyCTPIgHFjLa6A8b0YH
         A8jipQz4LBUqYSXhqH0w9HK/dzq5UXzbJrvjyQ1/tqfXLeQxkV9aS+VEqFt0wciMQ5HG
         g1JSY/GYuVf4ovNVJQBQ1oNWI2bvMDfE20S03FPM7YKHKDQE/u2mlRR4qPGWBWnzHAJ4
         Cjf8rsQCwci+iR2TFewCVl6wnYyfDGH9fTpjaHAebEfhGMjuvRcysjS0XxB2vXAePeTK
         ZYPg==
X-Gm-Message-State: ACrzQf1AvtjDE+67hrDiULbSVYac179Jwkr++ZDj+psZHdl5TcrJTzYG
        3Nx0LUyb63qQDXZZ5xeWdjaNQA==
X-Google-Smtp-Source: AMsMyM4gI1s6pO1AYZYByn4NE7gj7vhUN+L+WWuO0l2WGy1l8zPvW7d9eNAjW0MNj62V9rNRPtdzlw==
X-Received: by 2002:a17:902:bd05:b0:179:bbad:acff with SMTP id p5-20020a170902bd0500b00179bbadacffmr1771135pls.170.1665015261532;
        Wed, 05 Oct 2022 17:14:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t24-20020a17090a449800b001f8c532b93dsm1691353pjg.15.2022.10.05.17.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 17:14:21 -0700 (PDT)
Date:   Thu, 6 Oct 2022 00:14:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhao Liu <zhao1.liu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v2] KVM: SVM: Replace kmap_atomic() with kmap_local_page()
Message-ID: <Yz4d2cXYi91UQT0Y@google.com>
References: <20220928092748.463631-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928092748.463631-1-zhao1.liu@linux.intel.com>
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

On Wed, Sep 28, 2022, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> The use of kmap_atomic() is being deprecated in favor of
> kmap_local_page()[1].
> 
> The main difference between kmap_atomic() and kmap_local_page() is the
> latter allows pagefaults and preemption.

Uber nit, I would phrase this as saying that local mappings don't disable
page faults and preemption, which is slightly different than stating that they
allow pagefaults/preemption.  E.g. if preemption is already disabled.

> There're 2 reasons we can use kmap_local_page() here:
> 1. SEV is 64-bit only and kmap_locla_page() doesn't disable migration in

Nit, s/kmap_locla_page/kmap_local_page

For future reference, even better would be to use human language after "introducing"
the functions, e.g.

  The main difference between atomic and local mappings is that local
  mappings don't disable page faults or preemption.

Obviously that doesn't magically prevent typos, but it does make the changelog
easier to read (IMO).

> this case, but here the function clflush_cache_range() uses CLFLUSHOPT
> instruction to flush, and on x86 CLFLUSHOPT is not CPU-local and flushes
> the page out of the entire cache hierarchy on all CPUs (APM volume 3,
> chapter 3, CLFLUSHOPT). So there's no need to disable preemption to ensure
> CPU-local.
> 2. clflush_cache_range() doesn't need to disable pagefault and the mapping
> is still valid even if sleeps. This is also true for sched out/in when
> preempted.
> 
> In addition, though kmap_local_page() is a thin wrapper around
> page_address() on 64-bit, kmap_local_page() should still be used here in
> preference to page_address() since page_address() isn't suitable to be used
> in a generic function (like sev_clflush_pages()) where the page passed in
> is not easy to determine the source of allocation. Keeping the kmap* API in
> place means it can be used for things other than highmem mappings[2].
> 
> Therefore, sev_clflush_pages() is a function that should use
> kmap_local_page() in place of kmap_atomic().
> 
> Convert the calls of kmap_atomic() / kunmap_atomic() to kmap_local_page() /
> kunmap_local().
> 
> [1]: https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com
> [2]: https://lore.kernel.org/lkml/5d667258-b58b-3d28-3609-e7914c99b31b@intel.com/
> 
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Suggested-by: Ira Weiny <ira.weiny@intel.com>
> Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---

No need to send a v3, the above are all the nittiest of nits.

Reviewed-by: Sean Christopherson <seanjc@google.com>

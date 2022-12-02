Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC26640E56
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiLBTVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbiLBTVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:21:20 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2134F1403
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:21:19 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b11so5830844pjp.2
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 11:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=usM3bR4WQp2e8qAkFnEqBmmtfmdcd+yWf9kFQzarIDo=;
        b=ABp0UGoStrLWSxLJd3CBchjb5Owo3FHAyn9ni3oFnfeOSxUhKo7aV37tfGR7ICt7cH
         M/HKj8jNybdMP4l96zbX8mc9im9eLWie0/jk5pQgXiv/Nfu5sOe09qaWfK8U6mGIYGxa
         ZgYXgdLuw+gr+GrQ9/roFVBsAYOunsTaTgVfmTXx+h9L/07dz7ZvJwahEx5t+f5EDRj5
         Evq8iEEKd8MSCRkfx0+aQf2pl1Qw6t4EWAs5NsBNI2XMh+ZK5FtJU+hHqzxaTflpUYZT
         LD6CM3BnoC72a7g8RTHJxKvfrXKGR3RWC2aKVEHRmUxUPcaF+qFhFJxH0RsyFL5oVMVb
         dP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usM3bR4WQp2e8qAkFnEqBmmtfmdcd+yWf9kFQzarIDo=;
        b=52WCeAD0hloV7VRuakdC9KHVheUCkVT7xO55Uu3kZlrPsAW4Toy/6/2pXe2d3/S+2r
         cH+nC+GaIicJanAosRrue5Q8Y6JYuJQWjODuJC7+p55OeoMxmMa6/fUwnW3TCr76BEu/
         gFdC/QHVe4MeaZTr+8sDb9gLB1uhjs54GxSkrmjA2r1C1Aw0VjRxd4qRHX7PDnXjFiQh
         WrnIJdIO9eRIMSDJ4wRvj1CzqmMNtGwqjFqZM8r4z08SKiviVQIWQIMWZwbN/P1A5Yoi
         59/4H+KjSOJem+ef5ZZLS9uXrtmE5Qv6+jYfoHOYwQ/3OJ+0cKRkAqCNlshoi3j5nPrP
         OBaA==
X-Gm-Message-State: ANoB5pkzDuyOhyP8aRAZmv8x8PVzDSbe+At1BsDZQ98KQHpK1f6MbPNq
        DJ0dM6ICwG2ydO1rjKj35h0XDw==
X-Google-Smtp-Source: AA0mqf4sMDA2r3y/BHrRS12xSskL1ohC9y7Obgi7aRmnvJdxXh4dvG9E6uMndP1MFEwCAJqxQdGoRQ==
X-Received: by 2002:a17:903:240a:b0:188:abb9:290 with SMTP id e10-20020a170903240a00b00188abb90290mr53599345plo.86.1670008879118;
        Fri, 02 Dec 2022 11:21:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k60-20020a17090a14c200b00219220edf0dsm5042634pja.48.2022.12.02.11.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 11:21:18 -0800 (PST)
Date:   Fri, 2 Dec 2022 19:21:15 +0000
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
Message-ID: <Y4pQK72G37fQIrAq@google.com>
References: <20220928092748.463631-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928092748.463631-1-zhao1.liu@linux.intel.com>
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

On Wed, Sep 28, 2022, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> The use of kmap_atomic() is being deprecated in favor of
> kmap_local_page()[1].
> 
> The main difference between kmap_atomic() and kmap_local_page() is the
> latter allows pagefaults and preemption.
> 
> There're 2 reasons we can use kmap_local_page() here:
> 1. SEV is 64-bit only and kmap_locla_page() doesn't disable migration in
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

Merged to kvm/queue, thanks!

https://lore.kernel.org/all/Y4lHxds8pvBhxXFX@google.com

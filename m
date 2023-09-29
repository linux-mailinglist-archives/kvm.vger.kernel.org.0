Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD027B377A
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 18:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbjI2QGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 12:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjI2QGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 12:06:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95970139
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 09:06:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d85fc108f0eso20805154276.2
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 09:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696003596; x=1696608396; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7748UyaRicB9vuLDG8lZI9y3UedmYNxjGs6THbhcXv4=;
        b=RXNb67qu11jninh8BDYQXR5zj0hykn/FKs1CckBo9yx44BFcW2CmRH7zWbuT6kFmEL
         iPoVyO7CXc4co3E8weYq8XPqWXfSvyRdRcJV2BRdGt7ApYhJEKiqDIrOm9Ix7JbeujVM
         NBxmEg5UpRH1iNHRzxWPkH5Tc50sHpoyYN9hrDDknuTUNSv2/qFdGbU6nUnCwTrIEYQX
         fuF5Y+UH4kMw3YvLW5wdKVAyvOu/JaUhB4KDIkF5+fY7iBZooD4Hc77u+ornlxfgWa11
         g83/6YWS9R1cZpcH4DuLq+zPaArEJvYPbQ7Br0+oz7zXAbnuysMO1vBkY0clSNn8YAeU
         jqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696003596; x=1696608396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7748UyaRicB9vuLDG8lZI9y3UedmYNxjGs6THbhcXv4=;
        b=S/rZ6/MOCMTIOfuITq1BvYhk44Z189heU9BvOoOjbnk6un5xEPxdrOZSQuhpD5Ynnc
         HE/CnhRLJ2pX8UDWZNOgafFutgNvM7gnpv1jVRv4WcrZ03RwOl+mEDWVDKj/peXVvVsZ
         bj/Q+cGJePi4cAhvqvzb9kGtgXONuSW+ZlxcvywT+F1vxf1QU6C6+qklV3lnLZSiS7A7
         2L1N+hvPvI/Ax7vq/9oFtq4pWcVBic/+1vyuXppakDWqTNQXGFh0I49Ao6Zu5Epau7yI
         qqGOB0BZHXBK1IiB2zmhvKcxxsmJsm7b/yP2uNLHnjR9N4oIGJPXr9UUOpn484sIt3G8
         xriA==
X-Gm-Message-State: AOJu0YwovO1xc4pUMj5fg6jTiE90EiU/K9eIj3mKZ/sgOouHjtZ+qeOG
        ADhJG9qlhEEeJMLS9ZRZ+7EYyLwUS/s=
X-Google-Smtp-Source: AGHT+IHsLuz2yP+DLr1l3LAHJNofVqpdj+3qr9V+VXcf0rZX5bCoeLknAcYmDIAgg+yEvB5YVWisfrv0cgc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa8a:0:b0:d80:eb4:9ca with SMTP id
 t10-20020a25aa8a000000b00d800eb409camr74309ybi.0.1696003595874; Fri, 29 Sep
 2023 09:06:35 -0700 (PDT)
Date:   Fri, 29 Sep 2023 09:06:34 -0700
In-Reply-To: <ZRZeaP7W5SuereMX@infradead.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <ZRZeaP7W5SuereMX@infradead.org>
Message-ID: <ZRb2CljPvHlUErwM@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From:   Sean Christopherson <seanjc@google.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     David Stevens <stevensd@chromium.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023, Christoph Hellwig wrote:
> On Mon, Sep 11, 2023 at 11:16:30AM +0900, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> > 
> > This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> > that is backed by struct pages that aren't currently being refcounted
> > (e.g. tail pages of non-compound higher order allocations) into the
> > guest.
> > 
> > Our use case is virtio-gpu blob resources [1], which directly map host
> > graphics buffers into the guest as "vram" for the virtio-gpu device.
> > This feature currently does not work on systems using the amdgpu driver,
> > as that driver allocates non-compound higher order pages via
> > ttm_pool_alloc_page.
> > 
> > First, this series replaces the __gfn_to_pfn_memslot API with a more
> > extensible __kvm_faultin_pfn API. The updated API rearranges
> > __gfn_to_pfn_memslot's args into a struct and where possible packs the
> > bool arguments into a FOLL_ flags argument. The refactoring changes do
> > not change any behavior.
> 
> Instead of adding hacks to kvm you really should fix the driver / TTM
> to not do weird memory allocations.

I agree that the driver/TTM behavior is nasty, but from a KVM perspective the vast
majority of this series is long-overdue cleanups (at least, IMO).  All of those
cleanups were my requirement for adding support for the behavior David and friends
actually care about.

KVM needs to be aware of non-refcounted struct page memory no matter what; see
CVE-2021-22543 and, commit f8be156be163 ("KVM: do not allow mapping valid but
non-reference-counted pages").  I don't think it makes any sense whatsoever to
remove that code and assume every driver in existence will do the right thing.

With the cleanups done, playing nice with non-refcounted paged instead of outright
rejecting them is a wash in terms of lines of code, complexity, and ongoing
maintenance cost.

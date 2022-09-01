Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2C65A9EDD
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 20:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiIASWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 14:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiIASWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 14:22:10 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96145275DF
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 11:22:09 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q15so12870724pfn.11
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 11:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=JgOGkHj4YTC8R2m7X32+Sm46m1jWk2GkaUwEBjIwozo=;
        b=JsU8YnOQbMFIRwg8LymD9wAca0qPRumEYwoqNC33kkyLGPSi2Lt2wUeKB7vSiIrOJw
         o2kdh/hyvE1SBaCDVZUYJSTJiH23DaL7HRk02mi+o5RNJpkNKyD4BCfOly9DlDym+bxr
         a5JhOTFZza5AkVXSv+YE0+iMG3thq8d/L8MdGjD07LAodNESwCWLxrbhJACv7lYsWSZC
         vv87D/TjGwwB2s/CcIer83FOZqyjCcAocAVELqrD9xXWGDlk5iT2xlwLQcljTJJpwdU5
         OYs1odaA0sHVmD7744/BnadPMLoQ75uH0CyOWhc9qU9sCjeZkicYLpZSA2Gaw9Xr8whz
         BG5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JgOGkHj4YTC8R2m7X32+Sm46m1jWk2GkaUwEBjIwozo=;
        b=4fX0XMNQUasWpfswfEKE232rguy6p+4ZHOpG1LF95K7++9R0I3FEtIBGihwjZEtDkD
         hSxveU1BFSH3QcIESv193eriTCwZrEkS7MNcC5p85Jl4dM65m/+mkyXshbAYXnmELb8w
         wyrg24G+RPF/We0v0X18SEHWb2GH6+SOrTnm38ohCO8TNcTDnCZu3QH4kiDG6HsQ7vGK
         rg4/EgDnHtLSoxsnhaaUDB32n11rfI2qnpqcN8yq51j1bVDifytpCu7/zXh5jgRlRGbZ
         V4hhPzrFDdgfKqdJlzJc7Gfacw8I1o67ELA7Mp+iI8xZrMpWIM870U1BtQDQuK3HFxjS
         YxYg==
X-Gm-Message-State: ACgBeo1ZNNPRt0c22xzlBGcHB5XenNyjdyUMgtIA0bkNS24+fnxCji/Z
        bh0PB95ILUspbkt3tyQ+Rqs4Cw==
X-Google-Smtp-Source: AA6agR4daETyo+/Uyu69WPYNusvW7g1Y0Bvr8+NrspioJ0XxygaFLHGKf8IiuvIwsV5hxmNffyG+AA==
X-Received: by 2002:a62:b519:0:b0:537:9723:5cf2 with SMTP id y25-20020a62b519000000b0053797235cf2mr32635705pfe.15.1662056529038;
        Thu, 01 Sep 2022 11:22:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a15-20020a1709027e4f00b0016ed20eacd2sm14109878pln.150.2022.09.01.11.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 11:22:08 -0700 (PDT)
Date:   Thu, 1 Sep 2022 18:22:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, oupton@google.com
Subject: Re: [PATCH v2 1/3] KVM: selftests: Create source of randomness for
 guest code.
Message-ID: <YxD4TcxXL38py7NS@google.com>
References: <YwlCGAD2S0aK7/vo@google.com>
 <gsntk06pwo62.fsf@coltonlewis-kvm.c.googlers.com>
 <YxDxagzRx0opmBBy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxDxagzRx0opmBBy@google.com>
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

On Thu, Sep 01, 2022, Ricardo Koller wrote:
> On Tue, Aug 30, 2022 at 07:01:57PM +0000, Colton Lewis wrote:
> > David Matlack <dmatlack@google.com> writes:
> > > I think this is broken if !partition_vcpu_memory_access. nr_randoms
> > > (per-vCPU) should be `nr_vcpus * vcpu_memory_bytes >> vm->page_shift`.
> > 
> > 
> > Agree it will break then and should not. But allocating that many more
> > random numbers may eat too much memory. In a test with 64 vcpus, it would
> > try to allocate 64x64 times as many random numbers. I'll try it but may
> > need something different in that case.
> 
> You might want to reconsider the idea of using a random number generator
> inside the guest. IRC the reasons against it were: quality of the random
> numbers, and that some random generators use floating-point numbers. I
> don't think the first one is a big issue. The second one might be an
> issue if we want to generate non-uniform distributions (e.g., poisson);
> but not a problem for now.

I'm pretty I had coded up a pseudo-RNG framework for selftests at one point, but
I cant find the code in my morass of branches and stashes :-(
 
Whatever we do, make sure the randomness and thus any failures are easily
reproducible, i.e. the RNG needs to be seeded pseudo-RNG, not fully random.

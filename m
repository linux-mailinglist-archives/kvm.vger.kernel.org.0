Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE01616D47
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 20:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiKBS76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiKBS7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:59:35 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5085B13F87
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:59:18 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 130so17240798pfu.8
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ozfijFL6oisXA0Rywz9UlgsF3nC4xugKejf2BN/hMCQ=;
        b=WjSssknYHNDKNXVAC4m9Z+qWXUWoIjb1R2WF95ECyXQqK9TnGf9BQGsa8R9v5iDyCO
         r1g/IWi7jmIjmD6bG/mUPj9AeS0CYRsAdUVGcSIYibRi+zcuRcKQicApfrpp6qvDRM9M
         R5DUTmbCEO/GCAZQvPNVi1CzszkRIayc1PMse6Zv0JgaZACrOrQNXkJ8G+4zOjgXV8rG
         v8qgLotiQyEJpBz5emzw8XXTUrO8iGmIdNQVEQIW+jGYp821AqYfC+q4sk22c9nF6evs
         TyVDiFoijZCCo9XMliQtfGnUsrJ1vRlABl+C7ziz4tgiflT2Y50XwhC41K/QKF2ToH/a
         PwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozfijFL6oisXA0Rywz9UlgsF3nC4xugKejf2BN/hMCQ=;
        b=8OzFBfE/qM9tq+HhBdTZA4ion+uATk6pOUdki2+8t0mfdVrMXOeSzd1YcG6o+o4jn7
         Pit78sDN6lUVHvf2H3bjwEgvl6cSynjQC/GMfYv8bQsBGWsR1QAotzApLzbEsOellCJd
         2S6+OV5N4FYy0AugOo5/PVlEaf3Bt3u7vmLERdiF9kPXigikenfRnidGZGXJxFHQxnY3
         BmRwrvBUTsDUnaW/xz7vcyTqfAOXFTX+KcoIoS322JGYuEC/6TLy5EZITddi+rb6S7gN
         QFLtYBZRIKDOCJ2z2qd6aGHmVvmtmgViajMJuetXO9HXvAK6dGvMHYH3n++cDt8MNOLh
         /uAw==
X-Gm-Message-State: ACrzQf1uZwePLmnERvSKCrp1gupTPr+zoxfO1+3xOkJhWy3eTYJM2M2b
        HDGGAkaP0HCS8Z655Q74EZ/h9g==
X-Google-Smtp-Source: AMsMyM7pZQ31wit4DKIfpjFcUOZdw5alHxSslQKpojZbI31esAaJxU+LL0AH44hmWerSfc/wAQ4JBA==
X-Received: by 2002:a63:1041:0:b0:46e:c6eb:22ee with SMTP id 1-20020a631041000000b0046ec6eb22eemr22767269pgq.442.1667415557761;
        Wed, 02 Nov 2022 11:59:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mg7-20020a17090b370700b0020d3662cc77sm1786677pjb.48.2022.11.02.11.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 11:59:17 -0700 (PDT)
Date:   Wed, 2 Nov 2022 18:59:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 00/30] KVM: hardware enable/disable reorganize
Message-ID: <Y2K+AQG+44sKFWDV@google.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
 <Y0da+Sj3BjYnMoh3@google.com>
 <Y0jfwi5yo0oMQ5lv@google.com>
 <38d7f8af-3cf0-0d5b-3fda-a2a3326f7b28@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38d7f8af-3cf0-0d5b-3fda-a2a3326f7b28@redhat.com>
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

On Wed, Nov 02, 2022, Paolo Bonzini wrote:
> On 10/14/22 06:04, Sean Christopherson wrote:
> > Good news (from a certain point of view):
> > The reason that the "generic h/w enabling" doesn't help much is because after sorting
> > out the myriad issues in KVM initialization, which is even more of a bug-ridden mess
> > than I initially thought, kvm_init() no longer has_any_  arch hooks.  All the compat
> > checks and whatnot are handled in x86, so tweaking those for TDX should be easier,
> > or at the very least, we should have more options.
> > 
> > Sorting everything out is proving to be a nightmare, but I think I have the initial
> > coding done.  Testing will be fun.  It'll likely be next week before I can post
> > anything.
> 
> Hi Sean,
> 
> is this the same series that you mentioned a couple hours ago in reply to
> Isaku?

Yep.

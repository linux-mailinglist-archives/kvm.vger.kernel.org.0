Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB7D683459
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 18:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjAaRy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 12:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjAaRyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 12:54:51 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264A441091
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:54:50 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id jh15so6829253plb.8
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3y5KXqbwM7S+3TSIV2+iJC/5fSMZAmwGmsybCJzUWVI=;
        b=EhOvXuZM2rbtLF+9K7KJYILF6pdEN0B3cmGQMGxBI23Ce8goh5ec7hZMvgswGI4E1t
         UbpKBTbpFsFgvWaRhSc3Wb4lYdzXM0NAG/sqdexFNamSfkRx0eAZLmOUBAgE6lwg1/X3
         6M/wG9oLicGjpmejdg26i3ge/EuPN1Dh8r1OWB3ZhGCu4tKWManshJga64ddrS4Tl44h
         5PXusS17cGHZtCpuPGTEmsayLa9uzk0k6Quv+dW5lhg/OKRLBOgvjlrEcPZ/bB81nXwt
         rXw6XPpLwA5CYRgIj71xJ4fXI/1Gro8kafy5bYzW7mNcm1iEpGiD7/ZzFpAtt1CBQJ1m
         FiuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3y5KXqbwM7S+3TSIV2+iJC/5fSMZAmwGmsybCJzUWVI=;
        b=P+EGO5P2qpg1nQzM883IQVy/nBQdqM/hBiT4HlT2RwoRVXz3COEvTSGfqCBEtP3Hpe
         65cCREdilerI8GNVM+VMFQP09xq8rAJGGJWPhh2ekVZjVSiKd2NQmmMNoC77axcELBwC
         tiCUqCHJYS0lHl1s7c7JQW+frb7azCwPTogwQE8DiMxHDF0qvhr8k2zWZ7cfUrfixJub
         7Ovp+V0LNMDtAVdKI1ti9UOwB2WGFuO+uHZn07tcWXfr9IDc/W/1HgJ7YTwbFDiW/Qyu
         rSba+RPBziNNf5ZTpwaU37OHX6jA6/B/BOR6cwdzBakr/FAKiTsvbc+12W8a2ptouKRo
         XDog==
X-Gm-Message-State: AO0yUKWYlA4oDgmoSdtfuivDnNM0TcijA18IzFIVF7HU9s5F/dgiksEj
        USw17sSrJ8WmyITxP9dNjJZjnQ==
X-Google-Smtp-Source: AK7set+NG++vuTQOQmy/0ftGsGfCswkpSt/zi/uGyIVyubf/0EesW8LRThheEc104G8bKJ6RVBBngg==
X-Received: by 2002:a05:6a21:3a82:b0:a4:efde:2ed8 with SMTP id zv2-20020a056a213a8200b000a4efde2ed8mr54946pzb.0.1675187689388;
        Tue, 31 Jan 2023 09:54:49 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p27-20020a637f5b000000b004788780dd8esm8835273pgn.63.2023.01.31.09.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 09:54:48 -0800 (PST)
Date:   Tue, 31 Jan 2023 17:54:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is
 enabled
Message-ID: <Y9lV5XEf7NV8i9uI@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi>
 <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org>
 <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
 <Y9g0KGmsZqAZiTSP@google.com>
 <Y9hsV02TpQeoB0oN@google.com>
 <Y9lTz3ryasgkfhs/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9lTz3ryasgkfhs/@google.com>
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

On Tue, Jan 31, 2023, Oliver Upton wrote:
> On Tue, Jan 31, 2023 at 01:18:15AM +0000, Sean Christopherson wrote:
> > On Mon, Jan 30, 2023, Oliver Upton wrote:
> > > I think that Marc's suggestion of having userspace configure this is
> > > sound. After all, userspace _should_ know the granularity of the backing
> > > source it chose for guest memory.
> > > 
> > > We could also interpret a cache size of 0 to signal that userspace wants
> > > to disable eager page split for a VM altogether. It is entirely possible that
> > > the user will want a differing QoS between slice-of-hardware and
> > > overcommitted VMs.
> > 
> > Maybe.  It's also entirely possible that QoS is never factored in, e.g. if QoS
> > guarantees for all VMs on a system are better met by enabling eager splitting
> > across the board.
> > 
> > There are other reasons to use module/kernel params beyond what Marc listed, e.g.
> > to let the user opt out even when something is on by default.  x86's TDP MMU has
> > benefited greatly from downstream users being able to do A/B performance testing
> > this way.  I suspect x86's eager_page_split knob was added largely for this
> > reason, e.g. to easily see how a specific workload is affected by eager splitting.
> > That seems like a reasonable fit on the ARM side as well.
> 
> There's a rather important distinction here in that we'd allow userspace
> to select the page split cache size, which should be correctly sized for
> the backing memory source. Considering the break-before-make rules of
> the architecture, the only way eager split is performant on arm64 is by
> replacing a block entry with a fully populated table hierarchy in one
> operation. AFAICT, you don't have this problem on x86, as the
> architecture generally permits a direct valid->valid transformation
> without an intermediate invalidation. Well, ignoring iTLB multihit :)
> 
> So, the largest transformation we need to do right now is on a PUD w/
> PAGE_SIZE=4K, leading to 513 pages as proposed in the series. Exposing
> that configuration option in a module parameter is presumptive that all
> VMs on a host use the exact same memory configuration, which doesn't
> feel right to me.

Can you elaborate on the cache size needing to be tied to the backing source?
Do the issues arise if you get to a point where KVM can have PGD-sized hugepages
with PAGE_SIZE=4KiB?  Or do you want to let userspace optimize _now_ for PMD+4KiB?

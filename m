Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC0650A601
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiDUQnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiDUQnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:43:51 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCC140E59
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:41:01 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id k12so3417500ilv.3
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zJ2PGSI6AkHDlxF/GNqF8HmtNwa9bQE1NjwYidDeeG4=;
        b=pb+EWMdmgz1SYFX5XMH36PJu8yBtqr0Vp8AGddG8kaiOE9UKasHUfSsrOs+kJgSuXR
         OKFrxOBeYXDavmOeFnwrkdLL4nrogRXknJiEortPNN9IvfWb8G+Nd6qlAWgieJnihyTv
         bdZgytwpwpts9HrOXNDERUlnemXOUdayTIjMlMen7VrjysCHLtHhwnpMsskmUJnPLeru
         DTDn/wXdO8zWEHnAZtRNNPaB46buoPfiZ5vWQle6tdzev3eBZl4u/WHtpRquc/yNM/gE
         VyGcIVWlh+r6XYvo4+irYPo8nPKy9YfO/PULBFjDZMDLESvIdrXpn77TvcarqOxmgu2u
         ZWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zJ2PGSI6AkHDlxF/GNqF8HmtNwa9bQE1NjwYidDeeG4=;
        b=iWStDk7brpaLh+IEy0cOrtIcfT6QVIx1iL9t6DDX6BLG7qTU+zxjm5f7gBIXdrt070
         /wu7q6kSS/eLJkLepz6lC2gu2PTIbwaDd7r01jYTX6Lf2S+6vEfqyq4ScB135j6TUNC/
         CLNQIBhBbE8F6tx7kx1QGQ9yO6wmtpYy6AJknpKCIJadbWmT6ZORfMUCjitw8TeqEU0i
         RijxWiZtryiosdvP4loghqQJyiOBDJ01SKaEiV9Ccesix2/C+VIj/NkFs2LjDJy3WC4n
         rY73YrSY5j1eSXoaquVt1EEYIq3y2fY8rMGx10QBrlzZ1Hd9uwwxHWZcDxbFmdxuI1AO
         f6bQ==
X-Gm-Message-State: AOAM532n/8bVOLVNzRHuPuFUEkYn3KKUiCgNBAiI5EEZhz1I3NumIFVj
        bPMxkpOwdxwq5kI9ZR4oyKaSUQ==
X-Google-Smtp-Source: ABdhPJznCuS8lVwwartmfDZ1hMkeoqvEWgOgvlXvcS6SugJ8SjoFWUQHCgUp+HIoFk3yQVSQ1VLNBA==
X-Received: by 2002:a92:6c08:0:b0:2c6:123f:48c9 with SMTP id h8-20020a926c08000000b002c6123f48c9mr301117ilc.22.1650559260642;
        Thu, 21 Apr 2022 09:41:00 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id j12-20020a6b310c000000b0065744ce0180sm117650ioa.8.2022.04.21.09.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 09:40:59 -0700 (PDT)
Date:   Thu, 21 Apr 2022 16:40:56 +0000
From:   Oliver Upton <oupton@google.com>
To:     Quentin Perret <qperret@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YmGJGIrNVmdqYJj8@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
 <YmFactP0GnSp3vEv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmFactP0GnSp3vEv@google.com>
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

On Thu, Apr 21, 2022 at 01:21:54PM +0000, Quentin Perret wrote:
> Hi Oliver,
> 
> On Friday 15 Apr 2022 at 21:58:53 (+0000), Oliver Upton wrote:
> > Breaking a table pte is insufficient to guarantee ownership of an
> > unlinked subtree. Parallel software walkers could be traversing
> > substructures and changing their mappings.
> > 
> > Recurse through the unlinked subtree and lock all descendent ptes
> > to take ownership of the subtree. Since the ptes are actually being
> > evicted, return table ptes back to the table walker to ensure child
> > tables are also traversed. Note that this is done both in both the
> > pre-order and leaf visitors as the underlying pte remains volatile until
> > it is unlinked.
> 
> Still trying to get the full picture of the series so bear with me. IIUC
> the case you're dealing with here is when we're coallescing a table into
> a block with concurrent walkers making changes in the sub-tree. I
> believe this should happen when turning dirty logging off?

Yup, I think that's the only time we wind up collapsing tables.

> Why do we need to recursively lock the entire sub-tree at all in this
> case? As long as the table is turned into a locked invalid PTE, what
> concurrent walkers are doing in the sub-tree should be irrelevant no?
> None of the changes they do will be made visible to the hardware anyway.
> So as long as the sub-tree isn't freed under their feet (which should be
> the point of the RCU protection) this should be all fine? Is there a
> case where this is not actually true?

The problem arises when you're trying to actually free an unlinked
subtree. All bets are off until the next RCU grace period. What would
stop another software walker from installing a table to a PTE that I've
already visited? I think we'd wind up leaking a table page in this case
as the walker doing the table collapse assumes it has successfully freed
everything underneath.

The other option would be to not touch the subtree at all until the rcu
callback, as at that point software will not tweak the tables any more.
No need for atomics/spinning and can just do a boring traversal. Of
course, I lazily avoided this option because it would be a bit more code
but isn't too awfully complicated.

Does this paint a better picture, or have I only managed to confuse even
more? :)

--
Thanks,
Oliver

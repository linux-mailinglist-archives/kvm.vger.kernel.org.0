Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F019B70CCFD
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 23:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbjEVVzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 17:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjEVVzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 17:55:08 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB8A100
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 14:55:07 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1ae469d881fso36259355ad.0
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 14:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684792507; x=1687384507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lsrdrfpStLHLCMcnUFm2bSNiOQJ8DFjC7VWw2vxFB9U=;
        b=3tTDxTYNGWf9angAoyiEj35tUIWKL6KNh6Tt+rSkge5LajeXEwtweh7tj3xiQTSc38
         iv+rkHwLQur/ja0cpDHOZ4HdUpKv1e4ZFNi5BLvyQGW8LXWLxpL0CZ76idAI0vUmIqfO
         zT1xmizSSaeQnl+nfygCxJLtB7GZ92jHfMSG05m8baSg+6EE8g/xWSFsfAwCfx6dWvIj
         am6E5D7S3pKxpYKnVaUdxfqmZpzjbAdBttvgQ7IVHZAgClLc2YYIGCNLIGKSUvOX1Asp
         HZOlJXIqNRWXxIlTOczhsApaxyJJGELiCb7nAWOj/62KnAYg8rOLdWg8YxcGxQ9FlmC0
         rc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684792507; x=1687384507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lsrdrfpStLHLCMcnUFm2bSNiOQJ8DFjC7VWw2vxFB9U=;
        b=Y6qTqNdVliPzTtYe7h2DYTS790JxiB7vMIQrKkuss0ops0O1mGtywy8FX1ImMrMwr6
         KW/wOhBYzrRbH5aCPEXDWLgM+99e1C6rJK//6H4clHLEzZqKGUMhHvU9bKcqKn30AUM3
         cCdZV2NqidjcQVjRn0gpgH3+qlofi7hupBLk5CoOWN/YNEVjUJ1uiQfjdbFHcc+gMWd/
         Cbz02xXkbfhF1xL0AQiHd2JgS6pRpomm2bUYT4oUXcysbbS7TOMYMQs3aJb6jirUrOA5
         c/2pK5V8YYA4Fs7aFFOC4ITfgtl6uKrv54rxwornuuZwSHh8ttPZHQBFwORrCskTKJRu
         WPyg==
X-Gm-Message-State: AC+VfDzD2nm9eRQiX6K9BNfN7BVoMtQDu7O4w9A9+DecvAbr7/HEWDfP
        XuceXhtvrESPKYOuRQ4A6tLKQduy17o=
X-Google-Smtp-Source: ACHHUZ4stFl0yANjF7GxRhiw9rEdZkfyfXAEA1DldggtFR98FAXWGyVwNlCjxcqGuUvDiNyJ5Ejy3a3pwtY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22c4:b0:1ac:4e96:cd22 with SMTP id
 y4-20020a17090322c400b001ac4e96cd22mr2951472plg.5.1684792506826; Mon, 22 May
 2023 14:55:06 -0700 (PDT)
Date:   Mon, 22 May 2023 14:55:05 -0700
In-Reply-To: <20230330085802.2414466-5-stevensd@google.com>
Mime-Version: 1.0
References: <20230330085802.2414466-1-stevensd@google.com> <20230330085802.2414466-5-stevensd@google.com>
Message-ID: <ZGvkuVlkdmgl2UBH@google.com>
Subject: Re: [PATCH v6 4/4] KVM: mmu: remove over-aggressive warnings
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Remove two warnings that require ref counts for pages to be non-zero, as
> mapped pfns from follow_pfn may not have an initialized ref count.

This patch needs to be moved earlier, e.g. if just this patch is reverted, these
WARNs will fire on a guest with non-refcounted memory.

The shortlog and changelog also need to be reworded.  The shortlog in particular
is misleading, as the the WARNs aren't overly agressive _in the current code base_,
but rather are invalidated by KVM allowing non-refcounted struct page memory to
be mapped into the guest.

Lastly, as I mentioned in previous versions, I would like to keep the sanity
check if possible.  But this time, I have a concrete idea :-)

When installing a SPTE that points at a refcounted page, set a flag stating as
much.  Then use the flag to assert that the page has an elevate refcount whenever
KVM is operating on the page.  It'll require some additional plumbing changes,
e.g. to tell make_spte() that the pfn is refcounted, but the actual code should be
straightforward.

Actually, we should make that a requirement to allow an arch to get non-refcounted
struct page memory: the arch must be able to keep track which pages are/aren't
refcounted.  That'll disallow your GPU use case with 32-bit x86 host kernels (we're
out of software bits in PAE SPTEs), but I can't imaging anyone cares.  Then I
believe we can make that support mutually exclusive with kvm_pfn_to_refcounted_page(),
because all of the kvm_follow_pfn() users will know (and remember) that the pfn
is backed by a refcounted page.

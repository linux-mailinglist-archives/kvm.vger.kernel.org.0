Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88F6422D3
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 06:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiLEFvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 00:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiLEFvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 00:51:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF25D10F
        for <kvm@vger.kernel.org>; Sun,  4 Dec 2022 21:51:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b11so10206226pjp.2
        for <kvm@vger.kernel.org>; Sun, 04 Dec 2022 21:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n/3g71sZYS1arRrHDyi+DR5mNcLeU7WNBhjw+Wlf1Xo=;
        b=cYn/nAw0Ws61jXvBUhPM1vmJHkD/22vD2Sn3+K76w49Kp0zmUsPPU5hXVO+Bu0lhGv
         LqqdTpLXMwAPIiOXhJ6/8In4cIc0ghPIPrRGwz3wLvfTp8mJcsDxf/FRcwEZZphNYN5K
         qzvehgWBe2G+o3n5QApbNmxjmPsCufAlX/mpu++RZAtH+n95AGwSshQEIpVuH1pMxnzR
         8NEp9TxYsqyb7C2ioTAH6NNx0C1+D4CJp1usSM8gWP8FMg+xKsvmbDBwrhYydG96vK7g
         00bh15sXZtXt1ZgHlrGNPSmqH7VN9ats6dDDrt2U2oDEDQUcOMeU0fiJta0w/iIFyUql
         inzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n/3g71sZYS1arRrHDyi+DR5mNcLeU7WNBhjw+Wlf1Xo=;
        b=VaJwFS8A1rodjEDtjV4xY726tCKMhIqFjJ7bZ+iLpRnt2ao4jh7TBMZs9dURo+bygF
         WjaMCyWW6gFWeG/Cp2l8N+kofaRzF3Y3aY3XObtqfnDmQk0omlSKRPwOZz8bU1w3h4VS
         GVQ1RHmY+WHhRJ/yXkVmHpZxcMqv45xDr1s/ic0HoTg1LQgI+fBH8+8OiBJpFr+PZJfb
         BSRq011a1Fiv1In9Rclm1+hQywqF7jFDX8AjalIS6tGBiOb4HbMfTz8j5ppF1M4mL9Hn
         v3y+yruokPobTha9m5HucZhOUbmWKjWoyFsuYPTPcFl/qMRvOZ0pCtIGZYLBUKAZJHEj
         GfkA==
X-Gm-Message-State: ANoB5pmFoeClEiQ6FCbQt8DE1f/FOTVAk5Ty2i6es8dGOPy9YADIsL2v
        ispeduXG9TI94tvnYpHo5poXAhv5kBUOSOvj4vU=
X-Google-Smtp-Source: AA0mqf6kWqWPoKVUaLvRbnwYzzWjm6w9AFHV5qTk3d/QQMh6okJGCJdU1eiiRoC9l1A93Sa97YH/vg==
X-Received: by 2002:a17:902:e8c1:b0:189:c948:14a4 with SMTP id v1-20020a170902e8c100b00189c94814a4mr8532451plg.74.1670219477737;
        Sun, 04 Dec 2022 21:51:17 -0800 (PST)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id lx3-20020a17090b4b0300b002195819d541sm261423pjb.8.2022.12.04.21.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 21:51:16 -0800 (PST)
Date:   Mon, 5 Dec 2022 05:51:13 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y42G0c9yBk2KHc+g@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-9-oliver.upton@linux.dev>
 <CGME20221114142915eucas1p258f3ca2c536bde712c068e96851468fd@eucas1p2.samsung.com>
 <d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com>
 <Y3J97ZTef8HLUv4i@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y3J97ZTef8HLUv4i@google.com>
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

On Mon, Nov 14, 2022, Oliver Upton wrote:
> Hi Marek,
> 
> On Mon, Nov 14, 2022 at 03:29:14PM +0100, Marek Szyprowski wrote:
> > This patch landed in today's linux-next (20221114) as commit 
> > c3119ae45dfb ("KVM: arm64: Protect stage-2 traversal with RCU"). 
> > Unfortunately it introduces a following warning:
> 
> Thanks for the bug report :) I had failed to test nVHE in the past few
> revisions of this series.
> 
> > --->8---
> > 
> > kvm [1]: IPA Size Limit: 40 bits
> > BUG: sleeping function called from invalid context at 
> > include/linux/sched/mm.h:274
> > in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
> > preempt_count: 0, expected: 0
> > RCU nest depth: 1, expected: 0
> > 2 locks held by swapper/0/1:
> >   #0: ffff80000a8a44d0 (kvm_hyp_pgd_mutex){+.+.}-{3:3}, at: 
> > __create_hyp_mappings+0x80/0xc4
> >   #1: ffff80000a927720 (rcu_read_lock){....}-{1:2}, at: 
> > kvm_pgtable_walk+0x0/0x1f4
> > CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc3+ #5918
> > Hardware name: Raspberry Pi 3 Model B (DT)
> > Call trace:
> >   dump_backtrace.part.0+0xe4/0xf0
> >   show_stack+0x18/0x40
> >   dump_stack_lvl+0x8c/0xb8
> >   dump_stack+0x18/0x34
> >   __might_resched+0x178/0x220
> >   __might_sleep+0x48/0xa0
> >   prepare_alloc_pages+0x178/0x1a0
> >   __alloc_pages+0x9c/0x109c
> >   alloc_page_interleave+0x1c/0xc4
> >   alloc_pages+0xec/0x160
> >   get_zeroed_page+0x1c/0x44
> >   kvm_hyp_zalloc_page+0x14/0x20
> >   hyp_map_walker+0xd4/0x134
> >   kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
> >   __kvm_pgtable_walk+0x1a4/0x220
> >   kvm_pgtable_walk+0x104/0x1f4
> >   kvm_pgtable_hyp_map+0x80/0xc4
> >   __create_hyp_mappings+0x9c/0xc4
> >   kvm_mmu_init+0x144/0x1cc
> >   kvm_arch_init+0xe4/0xef4
> >   kvm_init+0x3c/0x3d0
> >   arm_init+0x20/0x30
> >   do_one_initcall+0x74/0x400
> >   kernel_init_freeable+0x2e0/0x350
> >   kernel_init+0x24/0x130
> >   ret_from_fork+0x10/0x20
> > kvm [1]: Hyp mode initialized successfully
> > 
> > --->8----
> > 
> > I looks that more changes in the KVM code are needed to use RCU for that 
> > code.
> 
> Right, the specific issue is that while the stage-2 walkers preallocate
> any table memory they may need, the hyp walkers do not and allocate
> inline.
> 
> As hyp stage-1 is protected by a spinlock there is no actual need for
> RCU in that case. I'll post something later on today that addresses the
> issue.
> 

For each stage-2 page table walk, KVM will use
kvm_mmu_topup_memory_cache() before taking the mmu lock. This ensures
whoever holding the mmu lock won't sleep. hyp walkers seems to
miss  this notion completely, whic makes me puzzeled. Using a spinlock
only ensures functionality but seems quite inefficient if the one who
holds the spinlock try to allocate pages and sleep...

But that seems to be a separate problem for nvhe. Why do we need an RCU
lock here. Oh is it for batching?

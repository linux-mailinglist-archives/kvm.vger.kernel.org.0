Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8682597507
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 19:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbiHQRZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 13:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbiHQRZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 13:25:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227EFA027A;
        Wed, 17 Aug 2022 10:25:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B24B2612AB;
        Wed, 17 Aug 2022 17:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1E2C433D6;
        Wed, 17 Aug 2022 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660757102;
        bh=ZTD0yTCE3YoAij/5K0t2/ZUlwJCWY5Buw6REabl/WR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SC2J5w+BXqr7lkuRfY2QM2puWBjyj5GOP6h+wLPgx64dkkM+tCRVdWsIQbGiRCiIP
         HS1DIM/JFDsLiNWXImyXnJAEql4l81hy1lSRe9YMugF7RDL9vmprjJPiL2ngIQK74F
         NEO2ZMkx/eaYaCUlkqbMXLYhbvkPgc997CnqKEYY=
Date:   Wed, 17 Aug 2022 10:25:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Sean Christopherson <seanjc@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, Huang@google.com,
        Shaoqin <shaoqin.huang@intel.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count
 secondary page table uses.
Message-Id: <20220817102500.440c6d0a3fce296fdf91bea6@linux-foundation.org>
In-Reply-To: <CAJD7tkYJcsSvCUCkNgcWvi2Xoa3GDZk81p5GUptZzkOkrhrTWQ@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
        <20220628220938.3657876-2-yosryahmed@google.com>
        <YsdJPeVOqlj4cf2a@google.com>
        <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
        <Ys3+UTTC4Qgbm7pQ@google.com>
        <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
        <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
        <Yvpir0nWuTsXz322@cmpxchg.org>
        <CAJD7tkYJcsSvCUCkNgcWvi2Xoa3GDZk81p5GUptZzkOkrhrTWQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Aug 2022 08:39:23 -0700 Yosry Ahmed <yosryahmed@google.com> wrote:

> Thanks a lot, Johannes! I haven't ifdeffed it yet so I'll send a v7
> with a few nits and collect ACKs. Andrew, would you prefer me to
> rebase on top of mm-unstable? Or will this go in through the kvm tree?
> (currently it's based on an old-ish kvm/queue).

Through KVM is OK by me, assuming there'll be ongoing work which is
dependent on this.

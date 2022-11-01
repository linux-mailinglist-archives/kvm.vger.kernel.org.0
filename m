Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA47761531D
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 21:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiKAUWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 16:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiKAUWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 16:22:20 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB261C93C
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 13:22:19 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b29so14464286pfp.13
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 13:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xVkJZtEBpIeuzqQn3nnjuzEWSUM1mVqhj+nnH0c1tQc=;
        b=M4X/osJ6VqZpKNtuP99fp4hNhqecoTugRL5QfWaIhyUxA9c53vT2gzUsKKGIv4cq+D
         N4IonfyyypScYrsv8ODBCuTAKMU/o3MuedyC4XY7mQxji9pS70V0SKgDvwYFSfWhghQ5
         DSHIteFpQ5DT8H/yuhvbuDJ+aT14g2LOoyFC7UtDqZDOCQSYZGT07KnHz1DlHeril/bj
         KZ6lYlB1F8nR11PVom9zZllOxYKCdv33fJC9+NNvtrvNHgsPRLMmiaeyoIMyvL0/2rzw
         cm6ucLucJ1hX/EB3aXe+tUxGs+j1hQ/M65oNHUJ7CRlwtvLEnlMzSzEVZREE3HFHamlW
         wBrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVkJZtEBpIeuzqQn3nnjuzEWSUM1mVqhj+nnH0c1tQc=;
        b=Ds+5ajLSqR5377TMDEDcBrnaNsP9mbUSZOcSci3zXzMUUrvckMFhfEveua/OPjA50d
         2amF5SKDAS3HbE9yDDlB1mEFqP/TO/+AqcoExxNt5laHMiKKkpnBXjicP8N1hr/bGpFY
         j9WMr3/Vl1F/kmBqXgg77hFwLyWG5WnduodPp3vagzT7x6Ws3C7z6wjB9Hw+rvjW8lHZ
         oH+GA/Vg6hQMC++3fugox8t+WJ6QzhrFrmaM2A632zctGFUjQcWpMZw6b1uryrCfJfBS
         PP5Arc3f+zCG9w0pfGUzxlxpL6DqMk0NFGwdVX4BK4vODmlostQa62SazT/T+sF+dJFJ
         ttCQ==
X-Gm-Message-State: ACrzQf02NiFDzxHPPSNW0yNMNNxHcDdbHCTDRx0L/M5yHPCz1yNP7lAs
        TZgrIY0DZUyIkMNwKqdK5JG0fw==
X-Google-Smtp-Source: AMsMyM7fD/Ym5AIcfwQwPvEeDSThfT/5hUO484wIK3KagW5eWCNhPeqPpcfATaT8FOx4g4d/EWqTBw==
X-Received: by 2002:a05:6a00:2481:b0:56b:dc84:7ad1 with SMTP id c1-20020a056a00248100b0056bdc847ad1mr21687157pfv.43.1667334139000;
        Tue, 01 Nov 2022 13:22:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x5-20020a170902ec8500b00187022627d8sm6816709plg.62.2022.11.01.13.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 13:22:18 -0700 (PDT)
Date:   Tue, 1 Nov 2022 20:22:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y2F/96RnvGPompIC@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-9-oliver.upton@linux.dev>
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

On Thu, Oct 27, 2022, Oliver Upton wrote:
> The use of RCU is necessary to safely change the stage-2 page tables in
> parallel.

RCU isn't strictly necessary, it's simply _a_ way to ensure readers have gone
away prior to freeing memory.  E.g. another method (used on x86 at least), is to
disable IRQs when walking page tables without holding mmu_lock, and then requiring
paths that free page tables to effectively do an IPI shootdown of all CPUs that
are reading page tables.

And "safely change" is misleading.  RCU doesn't allow safely _changing_ page
tables; if RCU did, then patch 10 wouldn't need to implement atomic updates.
Protecting page table walks with RCU is purely about ensuring readers have gone
away prior to freeing the backing memory, an entirely different mechanism is needed
to allow parallel updates, e.g. the CMPXCHG + KVM_INVALID_PTE_LOCKED approach to
ensure only one walker "owns" the detached page table.

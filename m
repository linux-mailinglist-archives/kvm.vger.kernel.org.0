Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505EA595733
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 11:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiHPJzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 05:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiHPJzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 05:55:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557ABA46F
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RA9err+4VBM5JcyhsLuXBY7qUbIMDNqhPfnAXwRd15k=; b=c1zM092IBza7T3THQ1xeQ4iIxx
        XExGDvqYDbSg8U3vihDNf53ScZWjcl2y1h4b/HKAT76PH6YXtQghJb8jy+If3cCwzcfxgbHIMA30r
        DaMp6SJNmNf5zk9x2UcRy1oIYEQu4X22lTgc79FtGnXx84uhSVda1zGbUxd3QQrErurrLllUbOQhe
        HpjMWsy/RdOGalLDnzIUKx8zdIe7JKqqsBO1GSH00t+0IDFh40MjjY1lp09b+eXZYF+0fw/UttuUH
        IVzVE9VpUiapcpbpql4HkH+OtSAGWnuj2KMao+TP3JgWjgSLsE/dZ4u+ZEJZ9rP49Zzxew3Y9d+0M
        jtoknqyA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNrkp-002u6x-HZ; Tue, 16 Aug 2022 08:16:52 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2457A980264; Tue, 16 Aug 2022 10:16:51 +0200 (CEST)
Date:   Tue, 16 Aug 2022 10:16:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is
 enabled
Message-ID: <YvtSc9ofTg1z8tt7@worktop.programming.kicks-ass.net>
References: <20220815230110.2266741-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 04:01:01PM -0700, David Matlack wrote:
> Patch 1 deletes the module parameter tdp_mmu and forces KVM to always
> use the TDP MMU when TDP hardware support is enabled.  The rest of the
> patches are related cleanups that follow (although the kvm_faultin_pfn()
> cleanups at the end are only tangentially related at best).
> 
> The TDP MMU was introduced in 5.10 and has been enabled by default since
> 5.15. At this point there are no known functionality gaps between the
> TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
> better with the number of vCPUs. In other words, there is no good reason
> to disable the TDP MMU.

Then how are you going to test the shadow mmu code -- which I assume is
still relevant for the platforms that don't have this hardware support
you speak of?

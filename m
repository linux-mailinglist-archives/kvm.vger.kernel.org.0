Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171257D5E3C
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 00:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344658AbjJXWbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 18:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344668AbjJXWbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 18:31:36 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9524210FF;
        Tue, 24 Oct 2023 15:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0xrKrG6QLKZInY7sNS1L6a1MY23Abv3L3T0w5lz/TMA=; b=VNspa/YtTP5+n3bl8xr0Vi9mpW
        aY5dzdce1UF2qLu4fOB6a+NS8h9aviD7kgHLrvrJRwwYz+/ynf2FK/xBXtLrgfUMNvha6Lys9vVnH
        CgUYX/75kt5d4Wi+9dcrgAidikQg1M0cDP9kMG+tRl1SAsyonyJTGEVdt1lVeN0G8SHu4mNhs1BdT
        urnbZzaSJFWlZOob24Il0AQdI5BTM1yVyHWxfabm2J/YClX/enU6iX7M+d7DYwuXkcW33EEKF4q4Z
        KSH8yK2Wp3U8vUbqz4Cqe/mu21CEbwwWUTH+BDkutTyfvqpH+RbSie9cS4o2IRONDl8mxTdEZ0LMd
        DnGHQGHw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvPuq-00FpoV-0q;
        Tue, 24 Oct 2023 22:30:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id BBD0E300451; Wed, 25 Oct 2023 00:30:23 +0200 (CEST)
Date:   Wed, 25 Oct 2023 00:30:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Luck, Tony" <tony.luck@intel.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "antonio.gomez.iglesias@linux.intel.com" 
        <antonio.gomez.iglesias@linux.intel.com>,
        "Milburn, Alyssa" <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231024223023.GI33965@noisy.programming.kicks-ass.net>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
 <20231024163515.aivo2xfmwmbmlm7z@desk>
 <20231024163621.GD40044@noisy.programming.kicks-ass.net>
 <20231024164520.osvqo2dja2xhb7kn@desk>
 <20231024170248.GE40044@noisy.programming.kicks-ass.net>
 <DD2F34A0-4F2F-4C8C-A634-7DBEF31C40F0@zytor.com>
 <SJ1PR11MB6083E3E2D35B30F4E40E8FE7FCDFA@SJ1PR11MB6083.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083E3E2D35B30F4E40E8FE7FCDFA@SJ1PR11MB6083.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 06:49:07PM +0000, Luck, Tony wrote:
> > the only overhead to modules other than load time (including the runtime linking) is that modules can't realistically be mapped using large page entries.
> 
> If there were some significant win for using large pages, couldn't the

There is. The 4k TLBs really hurt. Thomas and me ran into that when
doing the retbleed call depth crud. Similarly Song ran into it with BPF,
they really want eBPF JIT to write to large pages.

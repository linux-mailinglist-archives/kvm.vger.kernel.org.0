Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0485736589
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 09:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjFTH7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 03:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjFTH7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 03:59:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE461729;
        Tue, 20 Jun 2023 00:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BZECT2dbtdQzJxRKjUga30Xmntvvyra9f2PegQf5YA4=; b=de+bOqx9/anW6oVh6YmJvCVeRR
        cYjE9B4blJW5E8eOr/pwAy/iz6GLAI9SJ6i2rNJlNTKQIiM9cHnB0K8OA0mU4bFO1Jk06PWASYn8P
        SkD1gZN4oKesbZpa4qAReA45F4ruvysyYc9AdwskypURpGcSd/9mjE9VezWYFlnH9wNP6qPP5MH+4
        p1LyFzVLLaFyz1lLBcsehIq/aGPiNV556lTvkjb6N8cMgYGwgvFzGhle4157+xORsSlDilkCIfN5S
        UIvKqIK2Iw9qf/PzBNxrrFZWN+oqj2Yl1bF27J6i9XKaCR75QgH/LkXyl2Rme8RXEHwSdfHCtLia0
        0cBxtrSw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qBWG0-00Cphv-05; Tue, 20 Jun 2023 07:58:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2C12B30020B;
        Tue, 20 Jun 2023 09:58:31 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0802123BE1E49; Tue, 20 Jun 2023 09:58:30 +0200 (CEST)
Date:   Tue, 20 Jun 2023 09:58:30 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Message-ID: <20230620075830.GU4253@hirez.programming.kicks-ass.net>
References: <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
 <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
 <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
 <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
 <5782c8c2bb3e76a802e4a81c553a21edbaee7c47.camel@intel.com>
 <be258af9-a329-6f03-fcf9-9dafad42c97f@intel.com>
 <20230619144651.kvmscndienyfr3my@box.shutemov.name>
 <63477d22-26ef-dd08-a3b0-93931b7d1d16@intel.com>
 <0be5634f390015ee6badb3f2b2154ad90eb70434.camel@intel.com>
 <4069285d-1653-4cbf-a3b3-24727697754b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4069285d-1653-4cbf-a3b3-24727697754b@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 19, 2023 at 06:06:30PM -0700, Dave Hansen wrote:
> On 6/19/23 17:56, Huang, Kai wrote:
> > Any comments to below?
> 
> Nothing that I haven't already said in this thread:
> 
> > Just use a normal old atomic_t or set_bit()/test_bit().  They have
> > built-in memory barriers are are less likely to get botched.
> 
> I kinda made a point of literally suggesting "atomic_t or
> set_bit()/test_bit()".  I even told you why: "built-in memory barriers".
> 
> Guess what READ/WRITE_ONCE() *don't* have.  Memory barriers.

x86 has built-in memory barriers for being TSO :-) Specifically all
barriers provided by spinlock (acquire/release) are no-ops on x86.

(strictly speaking locks imply stronger order than they have to because
TSO atomic ops imply stronger ordering than required)

There is one (and only the one) re-ordering possible on TSO and that is
the store-buffer, later loads can fail to observe prior stores.

If that is a concern, you need explicit barriers.

This is #MC, much care and explicit open-coded crap is expected. Also,
this is #MC, much broken is also expected :-( As in, the current #MC
handler is a know pile of shit.

Basically the whole of #MC should be noinstr -- it isn't and that's a
significant problem.

Also we still very much suffer the NMI <- #MC problem and the #MC latch
is known broken garbage.

Whatever you do, do it very carefully, double check and be more careful.

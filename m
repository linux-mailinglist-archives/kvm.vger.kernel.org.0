Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1536A736531
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 09:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjFTHtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 03:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbjFTHs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 03:48:59 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1BF199A;
        Tue, 20 Jun 2023 00:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tDwACWsZWyvQQ7KO5OXodC3aVuzBmZwAsrzP9VHieio=; b=pjkEIqNAZVkLNrHA0rYEme4LqJ
        95b/SIiPlio8YOMhBRCW8VyOFKLb6nZ6K9wC9OtgcZa0kU4BXJLJf4W164EPMu/FbzjVxrDWYWkkv
        LrjiKSqbtYt7ViPqo45PVjlQBxCvQzrPqr+rxhcNpPQ3DozUrKQhY2NhEoXxmpLVMC0jzQuYCo76s
        je2w+weJT3MlR6shRDoT6R8biQLtMxiRva/z6P+k4UkZAapX7zZxwJ4APYDyntWjQwEwSUoRWU5f4
        TQxJ+jek5OwM4rGBcRLfd4TVkASJRaim3Z4qDEDIxPmfbnMsxe3xQP73GIbfG0McQstvN8D5aI38R
        z+lhkQcA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBW5u-00Fyhm-2p;
        Tue, 20 Jun 2023 07:48:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C0DFF300322;
        Tue, 20 Jun 2023 09:48:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A143D23BE1E49; Tue, 20 Jun 2023 09:48:05 +0200 (CEST)
Date:   Tue, 20 Jun 2023 09:48:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
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
Message-ID: <20230620074805.GT4253@hirez.programming.kicks-ass.net>
References: <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
 <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
 <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
 <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
 <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
 <5782c8c2bb3e76a802e4a81c553a21edbaee7c47.camel@intel.com>
 <be258af9-a329-6f03-fcf9-9dafad42c97f@intel.com>
 <20230619144651.kvmscndienyfr3my@box.shutemov.name>
 <63477d22-26ef-dd08-a3b0-93931b7d1d16@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63477d22-26ef-dd08-a3b0-93931b7d1d16@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 19, 2023 at 04:41:13PM -0700, Dave Hansen wrote:
> On 6/19/23 07:46, kirill.shutemov@linux.intel.com wrote:
> >>>
> >>> Using atomic_set() requires changing tdmr->pamt_4k_base to atomic_t, which is a
> >>> little bit silly or overkill IMHO.  Looking at the code, it seems
> >>> arch_atomic_set() simply uses __WRITE_ONCE():
> >> How about _adding_ a variable that protects tdmr->pamt_4k_base?
> >> Wouldn't that be more straightforward than mucking around with existing
> >> types?
> > What's wrong with simple global spinlock that protects all tdmr->pamt_*?
> > It is much easier to follow than a custom serialization scheme.
> 
> Quick, what prevents a:
> 
> 	spin_lock() => #MC => spin_lock()
> 
> deadlock?
> 
> Plain old test/sets don't deadlock ever.

Depends on what you mean; anything that spin-waits will deadlock,
doesn't matter if its a test-and-set or not.

The thing with these non-maskable exceptions/interrupts is that they
must be wait-free. If serialization is required it needs to be try based
and accept failure without waiting.

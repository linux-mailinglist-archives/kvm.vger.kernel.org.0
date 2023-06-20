Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F826736A03
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 12:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbjFTK4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 06:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjFTK4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 06:56:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE198109;
        Tue, 20 Jun 2023 03:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8BRZB7IQy1y+6aXuOJBtxvQaRvGQfzc7ssU6i3h0tfQ=; b=F+a8aeJkj2DZTF42cL8azBfLYt
        erGY4rRQmeUkWJhjdvWrYqMFArNmSzit4S1telmnI+DG/MLkdEkIpx0WCkgtCdWkLIVVsZJDDVL/J
        rT7iB3pirq/HkBtEkkDWooJcSUQZfht7mhxqJvXkE6BJc1u3IOJcMwHczLFPXarWLkkg4U9r+N+ZN
        OJItdcEbddviKcqFD1mlAwC8zBjAm2LuanwOwQwX+djT5lCxKvMifY1jxfj9R35QPD3xwtDsbYBrb
        VaVTc8acLP0GaGvScsX17ZlqUIqRII1M1Fstnv22CHT+q1sh8m/1XkR0IDDSZ1ml3nq9fRwTcGa0Y
        V+/hFh6Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qBZ1y-00Czjm-DY; Tue, 20 Jun 2023 10:56:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3A3ED300274;
        Tue, 20 Jun 2023 12:56:13 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 13DA223BE1E49; Tue, 20 Jun 2023 12:56:13 +0200 (CEST)
Date:   Tue, 20 Jun 2023 12:56:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
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
Message-ID: <20230620105612.GA4253@hirez.programming.kicks-ass.net>
References: <cover.1685887183.git.kai.huang@intel.com>
 <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
 <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
 <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
 <20230620081131.GV4253@hirez.programming.kicks-ass.net>
 <93b49134cdf5c7f0658ba0aeb2b1a49778b2aece.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93b49134cdf5c7f0658ba0aeb2b1a49778b2aece.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 10:42:32AM +0000, Huang, Kai wrote:
> On Tue, 2023-06-20 at 10:11 +0200, Peter Zijlstra wrote:
> > On Mon, Jun 12, 2023 at 03:06:48AM +0000, Huang, Kai wrote:
> > 
> > > +       __mb();
> > 
> > __mb() is not a valid interface to use.
> 
> Thanks for feedback!
> 
> May I ask why, for education purpose? :)

it's the raw MFENCE wrapper, not one of the *many* documented barriers.

Also, typicaly you do *not* want MFENCE, MFENCE bad.

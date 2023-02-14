Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7696968C7
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 17:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjBNQHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 11:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjBNQHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 11:07:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B552D59;
        Tue, 14 Feb 2023 08:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xB/bwHUPt+tors+Z68y+j7FdmLb0N8TJZt0zwsIot58=; b=CTHUOp6aV30XJQb0TsxIkcV0H/
        EKB/ASpBeMl8tqBBoOsmGjRD3qlxw0BZ666waF+v2V3m3K3h7Cskgjfihb/AKeQZo/w3ahZNW5Ugv
        skC8xW1AByrYgc/8eCx8hqxbmaEgC7lVxSnQW5NQ8JRhF7y3yEQ67lBLZBQIwhtAnOsvFq7oJ9cl3
        ZD73ZFgPKnD41RDl/hQQni8Ivb7JLhOI1Z0gFj/ICHRn93P4lokxy6W9TpkG5bbuXbhaQXyo3U4m+
        wyX5joNmyufLd62fUtHsNInOo8TARUtKfKkDrkIJ3ZQpkWF0my9Vi6AovqVcKuizB4cv3CfmgzSkM
        5O8lTg7A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRxpQ-006cuy-Ho; Tue, 14 Feb 2023 16:06:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7D6323021E2;
        Tue, 14 Feb 2023 15:12:11 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 603C223BDBD82; Tue, 14 Feb 2023 15:12:11 +0100 (CET)
Date:   Tue, 14 Feb 2023 15:12:11 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
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
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Message-ID: <Y+uWu9hLMZ35JHlY@hirez.programming.kicks-ass.net>
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
 <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
 <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
 <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
 <43fec733ea5331c6de4592dbf44a62e0c61eecb1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43fec733ea5331c6de4592dbf44a62e0c61eecb1.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 12:02:22AM +0000, Huang, Kai wrote:
> On Mon, 2023-02-13 at 14:43 -0800, Dave Hansen wrote:
> > On 2/13/23 13:19, Huang, Kai wrote:
> > > > On 2/13/23 03:59, Kai Huang wrote:
> > > > > To avoid duplicated code, add a
> > > > > helper to call SEAMCALL on all online cpus one by one but with a skip
> > > > > function to check whether to skip certain cpus, and use that helper to
> > > > > do the per-cpu initialization.
> > > > ...
> > > > > +/*
> > > > > + * Call @func on all online cpus one by one but skip those cpus
> > > > > + * when @skip_func is valid and returns true for them.
> > > > > + */
> > > > > +static int tdx_on_each_cpu_cond(int (*func)(void *), void *func_data,
> > > > > +                           bool (*skip_func)(int cpu, void *),
> > > > > +                           void *skip_data)
> > > > I only see one caller of this.  Where is the duplicated code?
> > > The other caller is in patch 15 (x86/virt/tdx: Configure global KeyID on all packages).
> > > 
> > > I kinda mentioned this in the changelog:
> > > 
> > >         " Similar to the per-cpu module initialization, a later step to config the key for the global KeyID..."
> > > 
> > > If we don't have this helper, then we can end up with having below loop in two functions:
> > > 
> > >         for_each_online(cpu) {
> > >                 if (should_skip(cpu))
> > >                         continue;
> > > 
> > >                 // call @func on @cpu.
> > >         }
> > 
> > I don't think saving two lines of actual code is worth the opacity that
> > results from this abstraction.
> 
> Alright thanks for the suggestion.  I'll remove this tdx_on_each_cpu_cond() and
> do directly.
> 
> But just checking:
> 
> LP.INIT can actually be called in parallel on different cpus (doesn't have to,
> of course), so we can actually just use on_each_cpu_cond() for LP.INIT:
> 
> 	on_each_cpu_cond(should_skip_cpu, smp_func_module_lp_init, NULL, true);
> 
> But IIUC Peter doesn't like using IPI and prefers using via work:
> 
> https://lore.kernel.org/lkml/Y30dujuXC8wlLwoQ@hirez.programming.kicks-ass.net/
> 
> So I used smp_call_on_cpu() here, which only calls @func on one cpu, but not a
> cpumask.  For LP.INIT ideally we can have something like:
> 
> 	schedule_on_cpu(struct cpumask *cpus, work_func_t func);
> 
> to call @func on a cpu set, but that doesn't exist now, and I don't think it's
> worth to introduce it?

schedule_on_each_cpu() exists and can easily be extended to take a cond
function if you so please.


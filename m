Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07B263444D
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiKVTHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbiKVTG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:06:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D73D8CFFB;
        Tue, 22 Nov 2022 11:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iF4AjT0TuyMM/apGrDH02XmhOks7vs/u/bD1CuJwmjs=; b=JsjL9CVQC0ssTneONk7yiJiQHv
        8Ju4QsHydkE0qUK6YSWkjRZq0BMdWkeDc6dOX05KhSPozfg5e3lI8NrmPG5mpwJ4Th1f0v08uW0EF
        6Uhdr5k9kVRjh1ChA1XNL8mm/lzG1fW6jlO5amjqzoh8rvYh0wtTJYFu4Cg/mcIUH4iXRevpPQlr1
        au50xKMuxYf5xVWYR7uHtatEP/9cku4SLFjutl3wGichdzd74EmBfG8JHROybK++7OKaKuIw9v1rI
        5WfnKze9DA0Y+wZhTOolu+aRT47VzyIvCrBAJaISKd03cXp44gnW256bRK0vYqmQlwPEBdLZm2Klu
        4NJmhfaA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxYbS-006fYD-Oc; Tue, 22 Nov 2022 19:06:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8C476300202;
        Tue, 22 Nov 2022 20:06:34 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 76A4A20B64111; Tue, 22 Nov 2022 20:06:34 +0100 (CET)
Date:   Tue, 22 Nov 2022 20:06:34 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com,
        pbonzini@redhat.com, dave.hansen@intel.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y30dujuXC8wlLwoQ@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3yUdcJjrY2LhUWJ@hirez.programming.kicks-ass.net>
 <87bkozgham.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkozgham.ffs@tglx>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 04:06:25PM +0100, Thomas Gleixner wrote:
> On Tue, Nov 22 2022 at 10:20, Peter Zijlstra wrote:
> 
> > On Mon, Nov 21, 2022 at 01:26:28PM +1300, Kai Huang wrote:
> >
> >> Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
> >> BIOS-enabled CPUs, and the SEMACALL can run concurrently on different
> >> CPUs.  Implement a mechanism to run SEAMCALL concurrently on all online
> >> CPUs and use it to shut down the module.  Later logical-cpu scope module
> >> initialization will use it too.
> >
> > Uhh, those requirements ^ are not met by this:
> 
>   Can run concurrently != Must run concurrently
>  
> The documentation clearly says "can run concurrently" as quoted above.

The next sentense says: "Implement a mechanism to run SEAMCALL
concurrently" -- it does not.

Anyway, since we're all in agreement there is no such requirement at
all, a schedule_on_each_cpu() might be more appropriate, there is no
reason to use IPIs and spin-waiting for any of this.

That said; perhaps we should grow:

  schedule_on_cpu(struct cpumask *cpus, work_func_t func);

to only disturb a given mask of CPUs.

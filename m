Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EDC5E64B9
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 16:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiIVOJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 10:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiIVOJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 10:09:55 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3B329803;
        Thu, 22 Sep 2022 07:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zNhQCtxWvF8Q4IPC7y5tVcrAmAIZN451YsFdgUZWDIc=; b=A7i7iCjsZIyacHXjYkAX/Is2WG
        nYl2smRxQ+vg/w0NtHXTN7nsAwptTVQa/DD1mchpHaecIYUzSLH5c/MsTtcQWrBeUYySiIEOyiZOB
        RgOmu9kVpSOQ0sZJtg96+sm7Oo+XBI1e12tZ5ZCEi6BKQBaLUGeP5jmyJnLBkd2wHmqFUSKs77Vsg
        REVJNeT6iicS4GQtsyq8D+KNONDTXnpD7I7/K1STaqFNTyaqpwGMK0+Y7NINryPQW47137XE38kV5
        kvdSiP5bVt2kJW0S684xSdn5XRTV6ST7vbr2njJUPR2SQ6hqZ9NEVqCi3LpTYppAPNk9ZDpHRQdAn
        i8eeZB0A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obMtR-00EyUS-GE; Thu, 22 Sep 2022 14:09:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 85E89300169;
        Thu, 22 Sep 2022 16:09:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 61E3B2BBF7EBF; Thu, 22 Sep 2022 16:09:32 +0200 (CEST)
Date:   Thu, 22 Sep 2022 16:09:32 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Message-ID: <YyxsnAFYMLn2U9BT@hirez.programming.kicks-ass.net>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
 <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
 <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Yyxke/IO+AP4EWwT@hirez.programming.kicks-ass.net>
 <DS0PR11MB637346E9F224C5330CDEF3BFDC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB637346E9F224C5330CDEF3BFDC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 01:59:53PM +0000, Wang, Wei W wrote:
> On Thursday, September 22, 2022 9:35 PM, Peter Zijlstra
> > On Thu, Sep 22, 2022 at 12:58:49PM +0000, Wang, Wei W wrote:
> > 
> > > Add a function to expose the current running PT event to users. One
> > > usage is in KVM, it needs to get and disable the running host PT event
> > > before VMEnter to the guest and resumes the event after VMexit to host.
> > 
> > You cannot just kill a host event like that. If there is a host event, the guest
> > looses out.
> 
> OK. The intention was to pause the event (that only profiles host info) when switching to guest,
> and resume when switching back to host.

If the even doesn't profile guest context, then yes. If it does profile
guest context, you can't.

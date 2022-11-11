Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294DD625610
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 10:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbiKKJCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 04:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbiKKJBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 04:01:23 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1543E8B2C8;
        Fri, 11 Nov 2022 00:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7oiumkaMQQyjNkLGmwWCVHqqI/kjNBm/sKIgai8zho0=; b=RIl5sfLe5Q1R3nPE1Rrribekjy
        hZ4m8leSCQvHZix6c5W/nIAOM5SI8Cyk/lNy6yBPK0ofeU2bqHxb2wiAepsE0UnEDhYfLJZ6vFZrk
        qJLueb0GtSsLMNio9xixR7UY/imyngrDYZkvu761CUnPK1Zpp0mH9WLyjCRVbYCRGEf25tBA1Dzjy
        kCo4W3H26zE+Z1VrrAO/mQpTzehz8tMej58JSRNRDXQE1BH3FXv8fpfGtGdwl6prgTPnJGHbxtKF4
        fHUjT7/YGDnAQp7IUguWaLFXUrOn5jqrMiufAsbFyEJeKK88zBkQlgOkOhHWjyR6RkjabiPFaI2+A
        J11MwGIw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1otPrh-00AYSs-DZ; Fri, 11 Nov 2022 08:58:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6154C301BE3;
        Fri, 11 Nov 2022 09:58:20 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 47CEA20243A99; Fri, 11 Nov 2022 09:58:20 +0100 (CET)
Date:   Fri, 11 Nov 2022 09:58:20 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Message-ID: <Y24OrBr1By28wgJG@hirez.programming.kicks-ass.net>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161DDABE8095ADC95B8BC73A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB2161DDABE8095ADC95B8BC73A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 08:36:30PM +0000, Li, Xin3 wrote:
> > > > +#pragma GCC diagnostic push
> > > > +#pragma GCC diagnostic ignored "-Wcast-function-type"
> > >
> > > How does this not break CFI ?
> > 
> > I wasn't aware of it, will check.
> 
> CFI needs $(cc-option,-fsanitize=kcfi), which, reported on LWN on Jun, 2002,
> had not yet landed in the LLVM mainline (I'm using GCC).  So looks we are
> replying on people keeping an eye on it to make sure it's not broken?

We're relying on that warning you disabled.

> Even we are unable to test it now, we should find a solution.

You can test this just fine. Build llvm.git and compile a kernel with
CFI_CLANG=y. This is not hard, my ADL runs such a kernel as we speak.


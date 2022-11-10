Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3B9624CAB
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 22:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiKJVNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 16:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbiKJVNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 16:13:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5E358BC7;
        Thu, 10 Nov 2022 13:13:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACC6FCE24C6;
        Thu, 10 Nov 2022 21:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99FFC433D6;
        Thu, 10 Nov 2022 21:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668114776;
        bh=hlxx+8EYpls14cLcfzrM8Xzl08ejjMlEeB2I7xYIzPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pzS5Vq9qWmnCmxwsvgQtlCzwrk+6gqG9oprabqE2TRR6xtCdTsP7/lb/IieSfiaB9
         BDxRR3W/HgfhcM5Sbbh4JqwOA67Q9mpibxXAGur5r33rfK1xhcSlFIwyxlljj0qlwT
         ms1V1LYXzBs+fVd1oFuqAZsv2hFlQww2coacf0QsRM2e3D/acisrCmesj62OyCzXds
         lciqfR9JGQmYwJKtuOmrAnMyEhbbZFZgNz0LptzyQCvOMAbkfOjUcREkinJ2gff0yn
         ulzqgu53TzRzv+/BlZKEhc1gRMqiOoQ6QIAML63HomJY79uR5Q4UhNxtptTZ5GXx9f
         ej7O1wi0FiI6g==
Date:   Thu, 10 Nov 2022 14:12:53 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     "Li, Xin3" <xin3.li@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, llvm@lists.linux.dev,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for
 system interrupt dispatch
Message-ID: <Y21pVXipq4lRiDMf@dev-arch.thelio-3990X>
References: <20221110061545.1531-1-xin3.li@intel.com>
 <20221110061545.1531-3-xin3.li@intel.com>
 <Y2y8obdYDXo9vlH/@hirez.programming.kicks-ass.net>
 <BN6PR1101MB21619E2092AFF048422C6311A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161DDABE8095ADC95B8BC73A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR1101MB2161DDABE8095ADC95B8BC73A8019@BN6PR1101MB2161.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Well, the entire point of the warning that you are disabling here is to
catch potential CFI failures at compile time, rather than run time :)

Clang also has -Wcast-function-type-strict, which Gustavo and Kees are
working on getting enabled, so that even more CFI failures can be caught
at compile time.

https://github.com/ClangBuiltLinux/linux/issues/1724
https://lore.kernel.org/all/?q=-Wcast-function-type-strict

Cheers,
Nathan

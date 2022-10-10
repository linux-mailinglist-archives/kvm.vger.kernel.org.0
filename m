Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615905FA20D
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiJJQio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 12:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJJQil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 12:38:41 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6EC6BD46
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 09:38:40 -0700 (PDT)
Date:   Mon, 10 Oct 2022 18:38:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665419917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DAqCfXmPAfSByMhD6MnhwZhOeKTx7BvVXaiEKQfnv8w=;
        b=qvQkaMprtrIhsRmSPR12/JX+tHQmJLGZ3uO9XdGvv8TLO9leE8g4wKaSqH8PcyjByIxCon
        UGxreVo0tx5nb9DGezoLSckQrjDwuaktEhPbWLg3OgWY8F9xJFVfweXZ6rO43ffxV89VUQ
        TyLOpI1ogHcl8nOiqrJux2hppn2pMfY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v6 2/3] KVM: selftests: randomize which pages are written
 vs read
Message-ID: <20221010163830.lcgfpxhqozryfyul@kamzik>
References: <20220912195849.3989707-1-coltonlewis@google.com>
 <20220912195849.3989707-3-coltonlewis@google.com>
 <Y0CSOKOq0T48e0yr@google.com>
 <20221008095032.kcbvpdz4o5tunptn@kamzik>
 <Y0QwQCq3pyb0v/b3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0QwQCq3pyb0v/b3@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 02:46:24PM +0000, Sean Christopherson wrote:
> On Sat, Oct 08, 2022, Andrew Jones wrote:
> > On Fri, Oct 07, 2022 at 08:55:20PM +0000, Sean Christopherson wrote:
> > > On Mon, Sep 12, 2022, Colton Lewis wrote:
> > > > @@ -393,7 +403,7 @@ int main(int argc, char *argv[])
> > > >  
> > > >  	guest_modes_append_default();
> > > >  
> > > > -	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
> > > > +	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
> > > 
> > > This string is getting quite annoying to maintain, e.g. all of these patches
> > > conflict with recent upstream changes, and IIRC will conflict again with Vipin's
> > > changes.  AFAICT, the string passed to getopt() doesn't need to be constant, i.e.
> > > can be built programmatically.  Not in this series, but as future cleanup we should
> > > at least consider a way to make this slightly less painful to maintain.
> > >
> > 
> > I wonder if a getopt string like above is really saying "we're doing too
> > much in a single test binary". Are all these switches just for one-off
> > experiments which developers need? Or, are testers expected to run this
> > binary multiple times with different combinations of switches?
> 
> Even if it's just 2 or 3 switches, I agree we need a way to run those configs by
> default.
> 
> > If it's the latter, then I think we need a test runner script and config file
> > to capture those separate invocations (similar to kvm-unit-tests). Or, change
> > from a collection of command line switches to building the file multiple
> > times with different compile time switches and output filenames.
> 
> What about a mix of those two approaches and having individual scripts for each
> config?  I like the idea of one executable per config, but we shouldn't need to
> compile multiple times.  And that would still allow developers to easily run
> non-standard configs.

Sounds good to me. Come to think of it we have that in kvm-unit-tests too
after running 'make standalone', which generates individual scripts per
configuration. IIRC, people doing testing seemed to prefer running the
standalone versions with their own runners too.

Thanks,
drew

> 
> I'd prefer to avoid adding a test runner, partly because I can never remember the
> invocation strings, partly becuase I don't want to encourage mega tests like the
> VMX and SVM KVM-unit-tests.

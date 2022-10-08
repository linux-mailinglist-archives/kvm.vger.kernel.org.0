Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2B65F84A7
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJHJum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Oct 2022 05:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJHJui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Oct 2022 05:50:38 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3082042D45
        for <kvm@vger.kernel.org>; Sat,  8 Oct 2022 02:50:35 -0700 (PDT)
Date:   Sat, 8 Oct 2022 11:50:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665222634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z2ZkYxEmGQXPz/45TkJJknVMlw8vPU4nddhOpAc1+jI=;
        b=BMCmUnGzn75mZCu9lmT/uDyu+WvJNT5yNnFodC7GOKj8i7P7uarIPgBf/9cvmAztahL8vT
        bM3/lQCaKFcd/UCA+1xrm8lTHFiyeDwrZE49PtgHyXaNN4X79TcojnjVIgGpkWw5rPI0Ka
        reGqI8GmCZxuZtgU1tChRscEZuFgBTI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v6 2/3] KVM: selftests: randomize which pages are written
 vs read
Message-ID: <20221008095032.kcbvpdz4o5tunptn@kamzik>
References: <20220912195849.3989707-1-coltonlewis@google.com>
 <20220912195849.3989707-3-coltonlewis@google.com>
 <Y0CSOKOq0T48e0yr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0CSOKOq0T48e0yr@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 07, 2022 at 08:55:20PM +0000, Sean Christopherson wrote:
> On Mon, Sep 12, 2022, Colton Lewis wrote:
> > @@ -393,7 +403,7 @@ int main(int argc, char *argv[])
> >  
> >  	guest_modes_append_default();
> >  
> > -	while ((opt = getopt(argc, argv, "ghi:p:m:nb:f:v:or:s:x:")) != -1) {
> > +	while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
> 
> This string is getting quite annoying to maintain, e.g. all of these patches
> conflict with recent upstream changes, and IIRC will conflict again with Vipin's
> changes.  AFAICT, the string passed to getopt() doesn't need to be constant, i.e.
> can be built programmatically.  Not in this series, but as future cleanup we should
> at least consider a way to make this slightly less painful to maintain.
>

I wonder if a getopt string like above is really saying "we're doing too
much in a single test binary". Are all these switches just for one-off
experiments which developers need? Or, are testers expected to run this
binary multiple times with different combinations of switches? If it's
the latter, then I think we need a test runner script and config file to
capture those separate invocations (similar to kvm-unit-tests). Or, change
from a collection of command line switches to building the file multiple
times with different compile time switches and output filenames. Then,
testers are just expected to run all binaries (which is what I think most
believe / do today).

Thanks,
drew

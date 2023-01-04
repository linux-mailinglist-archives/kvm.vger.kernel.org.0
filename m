Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7296F65D685
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 15:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjADOtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 09:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjADOs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 09:48:58 -0500
X-Greylist: delayed 87536 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 Jan 2023 06:48:54 PST
Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204D2311
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 06:48:50 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:48:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672843728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MNwZOyqLj9xn1bPxHWKDATNAwq2xM0+a42rxaXN/zHk=;
        b=SDkyp9hiu7kn1BByvEk60S0KcSMWKqzbM4LJg5LMUjRbGQrmy6VQLFQ19pQoZFgQQws7w+
        yOUsiPOM65ohUzepnaf3PgtxsqnPMDKttNTbzCi+ZDGc32/X7ZksOqL3vHr90DSZs1AzvV
        WvYQdlj9VkPb69Ud4yHpVHaxxfujmK0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Message-ID: <20230104144844.ldhurl73imixvrx2@orel>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
 <167161061144.28055.8565976183630294954@t14-nrb.local>
 <167161409237.28055.17477704571322735500@t14-nrb.local>
 <20221226184112.ezyw2imr2ezffutr@orel>
 <20230104120720.0d3490bd@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104120720.0d3490bd@p-imbrenda>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 12:07:20PM +0100, Claudio Imbrenda wrote:
> On Mon, 26 Dec 2022 19:41:12 +0100
> Andrew Jones <andrew.jones@linux.dev> wrote:
> 
> > On Wed, Dec 21, 2022 at 10:14:52AM +0100, Nico Boehr wrote:
> > > Quoting Nico Boehr (2022-12-21 09:16:51)  
> > > > Quoting Claudio Imbrenda (2022-12-20 18:55:08)  
> > > > > A recent patch broke make standalone. The function find_word is not
> > > > > available when running make standalone, replace it with a simple grep.
> > > > > 
> > > > > Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > > > > Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
> > > > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> > > > 
> > > > I am confused why find_word would not be available in standalone, since run() in runtime.bash uses it quite a few times.
> > > > 
> > > > Not that I mind the grep, but I fear more might be broken in standalone?  
> > 
> > standalone tests don't currently include scripts/$ARCH/func.bash, which
> > may be an issue for s390x. That could be fixed, though.
> > 
> > > > 
> > > > Anyways, to get this fixed ASAP:
> > > > 
> > > > Acked-by: Nico Boehr <nrb@linux.ibm.com>  
> > > 
> > > OK, I get it now, find_word is not available during _build time_.  
> > 
> > That could be changed, but it'd need to be moved to somewhere that
> > mkstandalone.sh wants to source, which could be common.bash, but
> > then we'd need to include common.bash in the standalone tests. So,
> > a new file for find_word() would be cleaner, but that sounds like
> > overkill.
> 
> the hack I posted here was meant to be "clean enough" and
> arch-only (since we are the only ones with this issue). To be
> honest, I don't really care __how__ we fix the problem, only that we do
> fix it :)
> 
> what do you think would be the cleanest solution?

A new file, but, like I said, that may be overkill at this time.

Thanks,
drew

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E35365C1FC
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 15:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbjACOaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 09:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237746AbjACO36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 09:29:58 -0500
Received: from out-95.mta0.migadu.com (out-95.mta0.migadu.com [IPv6:2001:41d0:1004:224b::5f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0921ABF1
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 06:29:56 -0800 (PST)
Date:   Tue, 3 Jan 2023 15:29:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672756193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e/LxniUhtMkX+49PYqP3jGuncSO12U4DcW65DRhxDmo=;
        b=sn8CuaH6gQtTkqwgrUmYpgsMv0BzH2NYWBkybS/gnVH4IUypLHxXwrjGXYpTYhEINPgY4r
        ULqNDCkeS1MdeNNGQfMbTV7Bx2yS+0FqqXQf+YVuXsLfTUKt6Cj+B3I1GTfYgM/aTgzezZ
        M+FeadUoxt4iri7T0cz06nLxWtOGzxc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, seiden@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Message-ID: <20230103142625.cams54t4hckc4n6r@orel>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
 <167161061144.28055.8565976183630294954@t14-nrb.local>
 <167161409237.28055.17477704571322735500@t14-nrb.local>
 <20221226184112.ezyw2imr2ezffutr@orel>
 <afdd57003ac8dbb639907b3093049c92c40ec488.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afdd57003ac8dbb639907b3093049c92c40ec488.camel@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 03, 2023 at 03:04:01PM +0100, Nina Schoetterl-Glausch wrote:
> On Mon, 2022-12-26 at 19:41 +0100, Andrew Jones wrote:
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
> 
> What is wrong with including common.bash?

for_each_unittest() isn't something that standalone tests need and,
theoretically, other non-standalone related functions could be introduced
there. Packaging functions for standalone tests which aren't needed by
the standalone tests isn't super clean. But, it's not really a problem
either.

Thanks,
drew

> 
> > a new file for find_word() would be cleaner, but that sounds like
> > overkill.
> > 
> > Thanks,
> > drew
> > 
> > > 
> > > Please make this a:
> > > 
> > > Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> 

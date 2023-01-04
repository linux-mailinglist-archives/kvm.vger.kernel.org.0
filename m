Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1F065D68A
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 15:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjADOuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 09:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjADOt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 09:49:57 -0500
Received: from out-193.mta0.migadu.com (out-193.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39853B931
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 06:49:56 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:49:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672843794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c5+azPSl9t3Nzh5rdp+z+EbLNQg5/hYpCKX3CHSNXfg=;
        b=gBQTMAJ1FF0jejXuilFHa3Jl6i4qexrgKiTtd9agdDWS/VpwsreqaOVdTqpmlC2GY5l3jC
        +K4c19DKVUvU4mFoo5cMhbJ/ivGZkc2uQZ7qi0rqDpuYmQ3QDw0AE2ylL767mz7E9pd/RA
        Qql0rWf5NjzJqov1p8hIuSYASjHnDTM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Message-ID: <20230104144954.w6sr26xxr5mn64yv@orel>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
 <20221226183634.7qr7f4otucfzat5g@orel>
 <af8e6828-6342-17d0-858f-20de5ef6e1a6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af8e6828-6342-17d0-858f-20de5ef6e1a6@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 01:52:21PM +0100, Thomas Huth wrote:
> On 26/12/2022 19.36, Andrew Jones wrote:
> > On Tue, Dec 20, 2022 at 06:55:08PM +0100, Claudio Imbrenda wrote:
> > > A recent patch broke make standalone. The function find_word is not
> > > available when running make standalone, replace it with a simple grep.
> > > 
> > > Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > > Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
> > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > ---
> > >   scripts/s390x/func.bash | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> > > index 2a941bbb..6c75e89a 100644
> > > --- a/scripts/s390x/func.bash
> > > +++ b/scripts/s390x/func.bash
> > > @@ -21,7 +21,7 @@ function arch_cmd_s390x()
> > >   	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> > >   	# run PV test case
> > > -	if [ "$ACCEL" = 'tcg' ] || find_word "migration" "$groups"; then
> > > +	if [ "$ACCEL" = 'tcg' ] || grep -q "migration" <<< "$groups"; then
> > 
> > What about the '-F' that find_word has?
> 
> "migration" is only one string without regular expressions in it, so I
> assume the -F does not matter here, does it?

You're right. I got carried away at checking equivalence.

Thanks,
drew

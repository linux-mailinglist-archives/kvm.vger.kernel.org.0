Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E41957A70A
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 21:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiGSTQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 15:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239034AbiGSTQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 15:16:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4075406A;
        Tue, 19 Jul 2022 12:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54EC9617E2;
        Tue, 19 Jul 2022 19:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78753C341C6;
        Tue, 19 Jul 2022 19:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658258196;
        bh=0PjpSGcoteZHK4XLNcEAGQXzpfq6Pep1XLwpwyZ7Kto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hOoQZba3bRR8nPLmpqRCiLUmZdhHJoA9JGA9TNtZQyB/0FGFyPZFgbVmHAz2sYExY
         J05BggZsSCSFB0Mnpt8J8gmOtwNhzrlo+lCEUTJK84a7eZpnXrVx/cs5J9GsFWamC3
         Yxt9V6Lyi/YSs7hikCUfa54knuUFMJZsJvlqdgATAWbjxSIqyVBerveD0a6wRuRnCd
         UuBA+xc+F+j4C8nVo7CPGHme4MPytGBRkIuVI5u+ALZWok5itlnzzFxa7mY42vwGlR
         WAx9l4I9VauQdqjoE+cb3fC1CwRCTueXmqKmWLd4Lcr5M53dJ6ZORXpIMrYjXZ0jtn
         EcZ1XN/ZgjF+Q==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4309A40374; Tue, 19 Jul 2022 16:16:33 -0300 (-03)
Date:   Tue, 19 Jul 2022 16:16:33 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 01/35] perf tools: Fix dso_id inode generation comparison
Message-ID: <YtcDETLcT98jLIIB@kernel.org>
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-2-adrian.hunter@intel.com>
 <YtV0vXJLbfTywZ1B@kernel.org>
 <569b5766-eb6f-8811-c5e5-f5a6972a0fd5@intel.com>
 <CAP-5=fXF1VRKjjBt+kv7QqQSbLonaZZoo__2qT1MtvHSZueEEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fXF1VRKjjBt+kv7QqQSbLonaZZoo__2qT1MtvHSZueEEw@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Tue, Jul 19, 2022 at 08:13:18AM -0700, Ian Rogers escreveu:
> On Tue, Jul 19, 2022 at 3:18 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
> >
> > On 18/07/22 17:57, Arnaldo Carvalho de Melo wrote:
> > > Em Mon, Jul 11, 2022 at 12:31:44PM +0300, Adrian Hunter escreveu:
> > >> Synthesized MMAP events have zero ino_generation, so do not compare zero
> > >> values.
> > >>
> > >> Fixes: 0e3149f86b99 ("perf dso: Move dso_id from 'struct map' to 'struct dso'")
> > >> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > >> ---
> > >>  tools/perf/util/dsos.c | 10 ++++++++--
> > >>  1 file changed, 8 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/tools/perf/util/dsos.c b/tools/perf/util/dsos.c
> > >> index b97366f77bbf..839a1f384733 100644
> > >> --- a/tools/perf/util/dsos.c
> > >> +++ b/tools/perf/util/dsos.c
> > >> @@ -23,8 +23,14 @@ static int __dso_id__cmp(struct dso_id *a, struct dso_id *b)
> > >>      if (a->ino > b->ino) return -1;
> > >>      if (a->ino < b->ino) return 1;
> > >>
> > >> -    if (a->ino_generation > b->ino_generation) return -1;
> > >> -    if (a->ino_generation < b->ino_generation) return 1;
> > >> +    /*
> > >> +     * Synthesized MMAP events have zero ino_generation, so do not compare
> > >> +     * zero values.
> > >> +     */
> > >> +    if (a->ino_generation && b->ino_generation) {
> > >> +            if (a->ino_generation > b->ino_generation) return -1;
> > >> +            if (a->ino_generation < b->ino_generation) return 1;
> > >> +    }
> > >
> > > But comparing didn't harm right? when its !0 now we may have three
> > > comparisions instead of 2 :-\
> > >
> > > The comment has some value tho, so I'm merging this :-)
> >
> > Thanks. I found it harmful because the mismatch resulted in a new
> > dso that did not have a build ID whereas the original dso did have
> > a build ID.  The build ID was essential because the object was not
> > found otherwise.
> 
> That's good to know, could we add that also to the comment? Perhaps:
> 
> Synthesized MMAP events have zero ino_generation, avoid comparing them
> with MMAP events with actual ino_generation.

I see now, thanks, adding this comment.

- Arnaldo

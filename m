Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4914C57B80B
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 16:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiGTOGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 10:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGTOGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 10:06:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ACF32D9E;
        Wed, 20 Jul 2022 07:06:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 961FEB81FAA;
        Wed, 20 Jul 2022 14:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCDCC3411E;
        Wed, 20 Jul 2022 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658325972;
        bh=JdFJAqOxLAfb5Yq94un8cNYo4CbhmY27QaDJa69gR6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g0QwqwHRKiTXpS777eYeQUO0EztPZTc5wh8WW7qnkbA4qrdLuAO8aR6D5+wrWH1Mo
         aZKLH9riS1YBVxERaQ3kdljU4vmYmugoGp0wD1gxjO5UN5u39cOev53pLys/uhlati
         pC9bVK0eAVUhaeBZERS2EuI8ZyrjDUA9VbLQxHHENzk8qIjOqTH5p8g87goZGSsE/R
         EWtDrG8xOBtcAhVXLNemjx5bOaXCLj5FNZOcC57ybOttOP57GwOCDE32N4JCrtg8qr
         uLrtHEuMrFjJazdydUkkmDcZl8BQt+OJBsONoAo8yeoSiIecgp5jGs9LYZByweoGqx
         T1qnsFP9CI6uA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0381240374; Wed, 20 Jul 2022 11:06:08 -0300 (-03)
Date:   Wed, 20 Jul 2022 11:06:08 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 27/35] perf tools: Add perf_event__is_guest()
Message-ID: <YtgL0M/jHSC9/BBG@kernel.org>
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-28-adrian.hunter@intel.com>
 <CAP-5=fXC4SYyV3DJKxy0atW1RRSS8EouD+t=pXuqJPSQ=x_jMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fXC4SYyV3DJKxy0atW1RRSS8EouD+t=pXuqJPSQ=x_jMA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Tue, Jul 19, 2022 at 06:11:47PM -0700, Ian Rogers escreveu:
> On Mon, Jul 11, 2022 at 2:33 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
> >
> > Add a helper function to determine if an event is a guest event.
> >
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > ---
> >  tools/perf/util/event.h | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> > diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> > index a660f304f83c..a7b0931d5137 100644
> > --- a/tools/perf/util/event.h
> > +++ b/tools/perf/util/event.h
> 
> Would this be better under tools/lib/perf ?

In general I think we should move things to libperf when a user requests
it, i.e. it'll be needed in a tool that uses libperf.

- Arnaldo
 
> Thanks,
> Ian
> 
> > @@ -484,4 +484,25 @@ void arch_perf_synthesize_sample_weight(const struct perf_sample *data, __u64 *a
> >  const char *arch_perf_header_entry(const char *se_header);
> >  int arch_support_sort_key(const char *sort_key);
> >
> > +static inline bool perf_event_header__cpumode_is_guest(u8 cpumode)
> > +{
> > +       return cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
> > +              cpumode == PERF_RECORD_MISC_GUEST_USER;
> > +}
> > +
> > +static inline bool perf_event_header__misc_is_guest(u16 misc)
> > +{
> > +       return perf_event_header__cpumode_is_guest(misc & PERF_RECORD_MISC_CPUMODE_MASK);
> > +}
> > +
> > +static inline bool perf_event_header__is_guest(const struct perf_event_header *header)
> > +{
> > +       return perf_event_header__misc_is_guest(header->misc);
> > +}
> > +
> > +static inline bool perf_event__is_guest(const union perf_event *event)
> > +{
> > +       return perf_event_header__is_guest(&event->header);
> > +}
> > +
> >  #endif /* __PERF_RECORD_H */
> > --
> > 2.25.1
> >

-- 

- Arnaldo

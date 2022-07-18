Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085255785EC
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 16:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbiGRO5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 10:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbiGRO5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 10:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A94624BC1;
        Mon, 18 Jul 2022 07:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE636121D;
        Mon, 18 Jul 2022 14:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CBCC341C0;
        Mon, 18 Jul 2022 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658156223;
        bh=tvnrYCwPOy/jqOS9PbQOyPjjTl1nXUhSVUGKj0uhTsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PY159bs4RfPcumuYo+AsZpHEPSahT4VC5bDmQn+ZggzLgE/omF0tMpyMvGfJL+sBn
         YCuvRX2sjAVhlb5Urtd+CIaH0Ky5a4dKBuPfVo602/Fss9GtP1/gJMrDKlFVbnd0gP
         Vl/MRbJFOlfbVmmL3K3GF8ZYrD1cLWjSwdePk/rhthQ515p3QI7DSMc/z26UemOP/j
         Y1RO66oBzHwvckcJECN4loURSQMXSSMrJwJp9sknP9fq4RYlDaL3Ep3F5/x4u45pET
         hqukMwNehFP0ZgJ15Y7bInoaEcvfJ789rbcmXohcCIyFXi5wTIw2V/gCOCoxgtE93L
         WGK8QS35Zn7Jw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2A96040374; Mon, 18 Jul 2022 11:57:01 -0300 (-03)
Date:   Mon, 18 Jul 2022 11:57:01 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 01/35] perf tools: Fix dso_id inode generation comparison
Message-ID: <YtV0vXJLbfTywZ1B@kernel.org>
References: <20220711093218.10967-1-adrian.hunter@intel.com>
 <20220711093218.10967-2-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711093218.10967-2-adrian.hunter@intel.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Mon, Jul 11, 2022 at 12:31:44PM +0300, Adrian Hunter escreveu:
> Synthesized MMAP events have zero ino_generation, so do not compare zero
> values.
> 
> Fixes: 0e3149f86b99 ("perf dso: Move dso_id from 'struct map' to 'struct dso'")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/dsos.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/dsos.c b/tools/perf/util/dsos.c
> index b97366f77bbf..839a1f384733 100644
> --- a/tools/perf/util/dsos.c
> +++ b/tools/perf/util/dsos.c
> @@ -23,8 +23,14 @@ static int __dso_id__cmp(struct dso_id *a, struct dso_id *b)
>  	if (a->ino > b->ino) return -1;
>  	if (a->ino < b->ino) return 1;
>  
> -	if (a->ino_generation > b->ino_generation) return -1;
> -	if (a->ino_generation < b->ino_generation) return 1;
> +	/*
> +	 * Synthesized MMAP events have zero ino_generation, so do not compare
> +	 * zero values.
> +	 */
> +	if (a->ino_generation && b->ino_generation) {
> +		if (a->ino_generation > b->ino_generation) return -1;
> +		if (a->ino_generation < b->ino_generation) return 1;
> +	}

But comparing didn't harm right? when its !0 now we may have three
comparisions instead of 2 :-\

The comment has some value tho, so I'm merging this :-)

- Arnaldo

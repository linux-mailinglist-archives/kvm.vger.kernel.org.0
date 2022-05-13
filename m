Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A37526529
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 16:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381381AbiEMOrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 10:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381642AbiEMOq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 10:46:59 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E09488A9;
        Fri, 13 May 2022 07:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652453195; x=1683989195;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=7M550510N4y+k5TC74sJtTjxH6gUaD3AaC0jMB7il0c=;
  b=c8kqHpiXGnee5eyvcW9QOI3eq3yK4FwTnEPhzpG/VHtfyPnEVILq6Wjq
   1NZPF46qpW3pFwOR9w2PWlf2dNgLaNSF1nMYBdrckysnR4lf9vautoRrb
   N8hhw4G2wel7WTsE1sYWv6/kQFqwbYlaBMFWX+P8xQTaKo7uBAFNNla/K
   M4O7vNYraBveiSafKNiq9LL4SXZtj41kTLfxKpxo+PpXWLhKW+2cOTrqh
   CXCG0p7BRmoY4NRVNCvGQ69nv0Rf7g2GGGeYYwQa8hCSZjUgCMpGxqN1Z
   yCePrir7l0MpCAh24wsHhuwYPV6sHjrQyK/h5SUPFNg+F91WWJZUvSPWR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="267913222"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="267913222"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 07:46:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="543285030"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.54.74.11])
  by orsmga006.jf.intel.com with ESMTP; 13 May 2022 07:46:34 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 55F43301AB6; Fri, 13 May 2022 07:46:34 -0700 (PDT)
From:   Andi Kleen <ak@linux.intel.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 6/6] perf intel-pt: Add guest_code support
References: <20220513090237.10444-1-adrian.hunter@intel.com>
        <20220513090237.10444-7-adrian.hunter@intel.com>
Date:   Fri, 13 May 2022 07:46:34 -0700
In-Reply-To: <20220513090237.10444-7-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Fri, 13 May 2022 12:02:37 +0300")
Message-ID: <875ym9h4mt.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adrian Hunter <adrian.hunter@intel.com> writes:

> A common case for KVM test programs is that the guest object code can be
> found in the hypervisor process (i.e. the test program running on the
> host). To support that, a new option "--guest-code" has been added in
> previous patches.
>
> In this patch, add support also to Intel PT.
>
> In particular, ensure guest_code thread is set up before attempting to
> walk object code or synthesize samples.

Can you make it clear in the documentation what parts runs on the host
and what parts on the guest? 

I'm still not fully sure how it exactly finds the code on the host,
how is the code transferred?

Other than that more support for this use case is very useful.

-Andi

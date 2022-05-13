Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D1D52690D
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358316AbiEMSNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiEMSNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:13:52 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB07219CEF6;
        Fri, 13 May 2022 11:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652465630; x=1684001630;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=BWYV+Oi9Z/0NNbOFw08aSu8Ir6Eg+66KwQpMi+GhjdE=;
  b=OxmfL+GJC3tvEHYQulZ/RA3UbR2vhyc5DDkcArAsfO6HJhBNZlsZxyR8
   kWyONr+nTfihd/Y8WFvYjQDgGtOJF1Tyu0GHbKBR9NOT8UzS8LM30Xw7f
   52Dr9/kmh00B/VMptZm+WuVHPmn8+/ua5XXJNB8MHVjhUOunPyLXc2SFO
   ACEjeyKdKOvEM99hGoizI/UU9AORyXnlwAi+X+AevqwGqJTlBv6qEU1ro
   4CPCXB0ke4KRXaE+NdjtPP3oJTJ7kvtyTPe4NJb9q8UyWvdsZ5n5L4lrQ
   nDzBvhZxChy7iOPzOhmk2stRW+YIg2LTGtqPY55z42iJHeZn5a9K1btni
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="270048382"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="270048382"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 11:13:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="712512622"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.54.74.11])
  by fmsmga001.fm.intel.com with ESMTP; 13 May 2022 11:13:49 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id C84F9301AB6; Fri, 13 May 2022 11:13:49 -0700 (PDT)
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
        <875ym9h4mt.fsf@linux.intel.com>
        <df56f04b-cb25-5a47-ffef-b2e2ee0f6b74@intel.com>
Date:   Fri, 13 May 2022 11:13:49 -0700
In-Reply-To: <df56f04b-cb25-5a47-ffef-b2e2ee0f6b74@intel.com> (Adrian Hunter's
        message of "Fri, 13 May 2022 18:14:49 +0300")
Message-ID: <871qwxgv1e.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adrian Hunter <adrian.hunter@intel.com> writes:
>> 
>> I'm still not fully sure how it exactly finds the code on the host,
>> how is the code transferred?
>
> I don't know.  From a quick look at the code in
> tools/testing/selftests/kvm/lib/kvm_util.c it seems to be using
> KVM_SET_USER_MEMORY_REGION IOCTL.

Okay so it assumes that the pages with code on the guest are still intact: that is
you cannot quit the traced program, or at least not do something that would
fill it with other data?. Is that correct?

It sounds like with that restriction it's more useful for kernel traces.

-Andi

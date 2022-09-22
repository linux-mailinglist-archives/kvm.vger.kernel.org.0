Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473055E63B4
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 15:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiIVNff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 09:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiIVNfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 09:35:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C978E990;
        Thu, 22 Sep 2022 06:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B6ccnQNtEUaB0ueDsfRYZRXgSdTI2hBeAmgJaqGNlrQ=; b=nbCgwfzCZBiVCd73mEtHLIpBeb
        hZyapg4sqOKKXxyqKoi5FVmZaMOKf3wvGxyPxmEnctVhhZT4M4W2lEbY+gNk0wU3CPO5ag3cIjmb1
        wcvsD0s3tfCFBUguB9gGQtjT8OtUYkgO6gQ/s+hBtu2Twq93guH4b2RCicPYPJI2TNUH0Fj6RCssu
        xU+Kg2Sm0ir2dBEdFNamBlmCYBj/3KhsoYsinOCTZr5YPpPzoU/wmCovXPRlGKKSEtbNrdWCd5aT6
        jHnDyGnGmAwbMFjACndCBwk6kW2fUGCEYuYxxZeCw7j/jEAH+ywoRREVSBNJi46DccIG/UUIqx4GV
        NIUVvjfQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obMLs-00Ey8h-Ms; Thu, 22 Sep 2022 13:34:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C7D79300023;
        Thu, 22 Sep 2022 15:34:51 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9A0832BBA39BD; Thu, 22 Sep 2022 15:34:51 +0200 (CEST)
Date:   Thu, 22 Sep 2022 15:34:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Message-ID: <Yyxke/IO+AP4EWwT@hirez.programming.kicks-ass.net>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
 <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
 <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 12:58:49PM +0000, Wang, Wei W wrote:

> Add a function to expose the current running PT event to users. One usage is in KVM,
> it needs to get and disable the running host PT event before VMEnter to the guest and
> resumes the event after VMexit to host.

You cannot just kill a host event like that. If there is a host event,
the guest looses out.

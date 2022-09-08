Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BADB5B1F87
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 15:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiIHNpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 09:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiIHNpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 09:45:40 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ACB5C956;
        Thu,  8 Sep 2022 06:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=twY36YI+Be9YAlDEXSHaceHAZcOE50tyeV0xFsPeMQc=; b=mcWsEqKY9fToo/d5WOKSIiaU/+
        c9m1nn0Fjz+ycqPz886l04XsEVOmCTHE1uwdgKBF+9EB+HMm9Ar5BBeoZAmEy3jfZIq+6OiRa8niy
        xCUGSjrKAvkrah8NZ4IlpBM3qJICx2aqX3mO1dYKSE5ithkYarsrw8bu7x/XY1O6OLsLV8ld7lSF5
        sHmWirU5ndTkGSI3Gh4mu/cVsRe2/J+p5xyhvicoYAH909H1sGYd+7LQsXUFRG/ahT443YElt3zDP
        kc+bKPTRRXKq4d5hgpcS9R+kzluYZkbg76nqb3nnVHI1ZuPPXtv5GeaZoJzZyUn3NnSGZ4mA0mK9I
        OYNfTfrw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oWHqM-00AkJb-5L; Thu, 08 Sep 2022 13:45:22 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BC7AE30013F;
        Thu,  8 Sep 2022 15:45:20 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 918BB207AB808; Thu,  8 Sep 2022 15:45:20 +0200 (CEST)
Date:   Thu, 8 Sep 2022 15:45:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v4 0/5]  KVM: x86: Intel LBR related perf cleanups
Message-ID: <Yxnx8InRcF94zi0n@hirez.programming.kicks-ass.net>
References: <20220901173258.925729-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901173258.925729-1-seanjc@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 05:32:53PM +0000, Sean Christopherson wrote:

> Sean Christopherson (5):
>   perf/x86/core: Remove unnecessary stubs provided for KVM-only helpers
>   perf/x86/core: Drop the unnecessary return value from
>     x86_perf_get_lbr()
>   KVM: VMX: Move vmx_get_perf_capabilities() definition to vmx.c
>   KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()
>   KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs

These look good to me; how do you want this routed, if through the KVM
tree:

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

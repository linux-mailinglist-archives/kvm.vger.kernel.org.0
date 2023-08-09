Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C77F775628
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 11:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjHIJKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 05:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjHIJKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 05:10:42 -0400
Received: from out-82.mta0.migadu.com (out-82.mta0.migadu.com [IPv6:2001:41d0:1004:224b::52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB41E1FCE
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 02:10:41 -0700 (PDT)
Date:   Wed, 9 Aug 2023 09:10:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691572240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mvmzvKOGcM7VTd90ZNc4xMJrUWrhIk71OKZHdX1ecXM=;
        b=qrezTWI5AElJZqV9qQGcT9+Kg1Sv+qGaGp0ABG0ROC2hAq8H45AlVEdjXZmLHcWdvrAN3v
        UzgLZj9d3z52lNjfEviNP8FCivMcqGZikDTWDs5h5Ill5r0bZfDRxCFUdB+utjW4CZS/M9
        zYb9t9t6JFETPi3apcQaXR40eklcy1Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Huang Shijie <shijie@os.amperecomputing.com>, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
        peterz@infradead.org, ingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, namhyung@kernel.org, irogers@google.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, patches@amperecomputing.com,
        zwang@amperecomputing.com
Subject: Re: [PATCH] perf/core: fix the bug in the event multiplexing
Message-ID: <ZNNYCQjsi30APZQ+@linux.dev>
References: <20230809013953.7692-1-shijie@os.amperecomputing.com>
 <864jl8ha8y.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864jl8ha8y.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 09:48:29AM +0100, Marc Zyngier wrote:

[...]

> Another question is how the same thing is handled on x86? Maybe they
> don't suffer from this problem thanks to specific architectural
> features, but it'd be good to find out, as this may guide the
> implementation in a different way.

I'm pretty sure the bug here is arm64 specific. x86 (at least on intel)
fetches the guest PMU context from the perf driver w/ irqs disabled
immediately before entering the guest (see atomic_switch_perf_msrs()).

-- 
Thanks,
Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EE2726977
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbjFGTHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjFGTHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:07:16 -0400
Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126D61B0
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 12:07:13 -0700 (PDT)
Date:   Wed, 7 Jun 2023 21:07:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686164832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cp/j3lpAjoA93pjc15VpuFruRtECtbGhaqaYmi+uaO8=;
        b=D+SPzO7/r1BmYqrzM4dcRYiMjPoxgnLZjzFApnPX2US1oxAiprh53/iViae3U9OXjl96KA
        cBoEKM70d8XrKsn3vjrdep6lpNn5ww6IljRaCafseSC+XYJKAwRI5+T66UmzQarm0ivKUz
        O55VlPCv5zgVhQSGctLaajh7MUTUciM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Message-ID: <20230607-a12c8e1d270b53e522756648@orel>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531201438.3881600-1-eric.auger@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 10:14:32PM +0200, Eric Auger wrote:
> On some HW (ThunderXv2), some random failures of
> pmu-chain-promotion test can be observed.
> 
> pmu-chain-promotion is composed of several subtests
> which run 2 mem_access loops. The initial value of
> the counter is set so that no overflow is expected on
> the first loop run and overflow is expected on the second.
> However it is observed that sometimes we get an overflow
> on the first run. It looks related to some variability of
> the mem_acess count. This variability is observed on all
> HW I have access to, with different span though. On
> ThunderX2 HW it looks the margin that is currently taken
> is too small and we regularly hit failure.
> 
> although the first goal of this series is to increase
> the count/margin used in those tests, it also attempts
> to improve the pmu-chain-promotion logs, add some barriers
> in the mem-access loop, clarify the chain counter
> enable/disable sequence.
> 
> A new 'pmu-mem-access-reliability' is also introduced to
> detect issues with MEM_ACCESS event variability and make
> the debug easier.
> 
> Obviously one can wonder if this variability is something normal
> and does not hide any other bug. I hope this series will raise
> additional discussions about this.
> 
> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v2
> 
> History:
> v1 -> v2:
> - Take into account Alexandru's & Mark's comments. Added some
>   R-b's and T-b's.
> 
> Eric Auger (6):
>   arm: pmu: pmu-chain-promotion: Improve debug messages
>   arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
>     values
>   arm: pmu: Add extra DSB barriers in the mem_access loop
>   arm: pmu: Fix chain counter enable/disable sequences
>   arm: pmu: Add pmu-mem-access-reliability test
>   arm: pmu-chain-promotion: Increase the count and margin values
> 
>  arm/pmu.c         | 196 +++++++++++++++++++++++++++++++++-------------
>  arm/unittests.cfg |   6 ++
>  2 files changed, 148 insertions(+), 54 deletions(-)
> 
> -- 
> 2.38.1
>

Hi Eric,

I'm eager to merge this, but I'll give Alexandru some time to revisit it
since he had comments on the last revision.

Thanks,
drew

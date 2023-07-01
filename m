Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C165C7448E1
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 14:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjGAMU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 08:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjGAMU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 08:20:57 -0400
Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [IPv6:2001:41d0:203:375::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5682F3C1B
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 05:20:43 -0700 (PDT)
Date:   Sat, 1 Jul 2023 14:20:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688214041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Lw5BxQqRENeAyOxae7u46Of4H2ihVGlnfYenVZcBCc=;
        b=S0vrhFUtIU/vl/Mn/+gtJ+v58R/68TUxZiV/+Jccqv4pBv8HX/r1vhUObyzZRv79UvmMcM
        jk7GwNwS49R+T3x1TVD+bQm1JYvWIwKQpvGPrewNRCFlQIeBUmfUri8h3RmjsgJdZz342q
        Qoj+wGBMeVaL8L3fXA8/LOLY4p5OCCU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Message-ID: <20230701-d2f20d86b8cb9735a9f1dd69@orel>
References: <20230619200401.1963751-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619200401.1963751-1-eric.auger@redhat.com>
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

On Mon, Jun 19, 2023 at 10:03:55PM +0200, Eric Auger wrote:
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
> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v3
> 
> History:
> 
> v2 -> v3:
> - took into account Alexandru's comments. See individual log
>   files
> 
> v1 -> v2:
> - Take into account Alexandru's & Mark's comments. Added some
>   R-b's and T-b's.
> 
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
>  arm/pmu.c         | 208 ++++++++++++++++++++++++++++++++--------------
>  arm/unittests.cfg |   6 ++
>  2 files changed, 153 insertions(+), 61 deletions(-)
> 
> -- 
> 2.38.1
>

Merged. Thanks, Eric!

drew

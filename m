Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A1A7A8E42
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 23:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjITVMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 17:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjITVMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 17:12:42 -0400
Received: from out-217.mta1.migadu.com (out-217.mta1.migadu.com [IPv6:2001:41d0:203:375::d9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2F49E
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 14:12:36 -0700 (PDT)
Date:   Wed, 20 Sep 2023 21:12:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695244354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EoUJ+vC7dyHc4K1PhRWk1cP4axcoR/iMI8O3D2rH4lY=;
        b=nRiL2bpy2TvTJglYvs33qdCvn+bntJIqeFLZAQ008Kh+KjusCOOUq6O7scKrO2N6lGZ447
        wdyM74RKMJ8MiwBGBne8n/vHE2RLBbEhrWTqojIiycJD+VQbnINfiM5f19woTYK0+D1dMX
        aj0Js4mG+/ntjHCDt8mp6aXb0/VaF9c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined dirty log
Message-ID: <ZQtgPSsOGgWE4MZ1@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <ZQHxm+L890yTpY91@linux.dev>
 <14eb2648eb594dd9a46a179733cee0df@huawei.com>
 <ZQOm9gUo8un+claf@linux.dev>
 <853b333084c4462a870bb2a37ec65935@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <853b333084c4462a870bb2a37ec65935@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 09:55:22AM +0000, Shameerali Kolothum Thodi wrote:

[...]

> > Sorry, this was rather nonspecific. I was describing the pre-copy
> > strategies we're using at Google (out of tree). We're carrying patches
> > to use EPT D-bit for exitless dirty tracking.
> 
> Just curious, how does it handle the overheads associated with scanning for
> dirty pages and the convergence w.r.t high rate of dirtying in exitless mode? 

A pool of kthreads, which really isn't a good solution at all. The
'better' way to do it would be to add some back pressure to the guest
such that your pre-copy transfer can converge with the guest and use the
freed up CPU time to manage the dirty state.

But hopefully we can make that a userspace issue.

-- 
Thanks,
Oliver

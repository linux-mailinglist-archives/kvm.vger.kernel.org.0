Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C2B7D5E8C
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 01:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344593AbjJXXEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 19:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344515AbjJXXEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 19:04:36 -0400
Received: from out-200.mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A8E10C6
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 16:04:34 -0700 (PDT)
Date:   Tue, 24 Oct 2023 23:04:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698188672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+i9nlbE8cuhzaIFBavKLVyMhmf7wc/8N7QLazfwuA5E=;
        b=ja8jpqTBFPm4QkYeWD+yG6eDinCH0szYgsImLTVghPo0lusSEbJrsVijn2vhsMhbt+LEPU
        XRkTTfYEPzcdjbqoKooBetpnsPxBFJ6nvuYt+ftX+i365En3CeIddLeruxcqgvB6hmRRwT
        PfGvKWD+cqptx9AToYaYIRd1A2wGJt4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Miguel Luis <miguel.luis@oracle.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 5/5] KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as
 RAZ/WI
Message-ID: <ZThNeyX0muR5yvey@linux.dev>
References: <20231023095444.1587322-1-maz@kernel.org>
 <20231023095444.1587322-6-maz@kernel.org>
 <7DD05DC0-164E-440F-BEB1-E5040C512008@oracle.com>
 <86jzrc3pbm.wl-maz@kernel.org>
 <ZThINaAfNDNrIAqI@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZThINaAfNDNrIAqI@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 10:41:57PM +0000, Oliver Upton wrote:
> On Tue, Oct 24, 2023 at 06:25:33PM +0100, Marc Zyngier wrote:
> > On Mon, 23 Oct 2023 19:55:10 +0100, Miguel Luis <miguel.luis@oracle.com> wrote:
> > > Also, could you please explain what is happening at PSTATE.EL == EL1
> > > and if EL2Enabled() && HCR_EL2.NV == ‘1’  ?
> > 
> > We directly take the trap and not forward it. This isn't exactly the
> > letter of the architecture, but at the same time, treating these
> > registers as RAZ/WI is the only valid implementation. I don't
> > immediately see a problem with taking this shortcut.
> 
> Ugh, that's annoying. The other EL2 views of AArch32 state UNDEF if EL1
> doesn't implement AArch32. It'd be nice to get a relaxation in the
> architecture to allow an UNDEF here.

Correction (I wasn't thinking): RES0 behavior should be invariant, much
like the UNDEF behavior of the other AA32-specific registers.

-- 
Thanks,
Oliver

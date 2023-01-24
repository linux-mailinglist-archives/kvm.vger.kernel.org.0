Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81CB678D0D
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 01:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbjAXA4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 19:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbjAXA4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 19:56:21 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED0B1A972
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 16:56:20 -0800 (PST)
Date:   Tue, 24 Jan 2023 00:56:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674521779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MOqp2XFlnHGFMJtO0tmCKwbMW2UjfrBeLXOpbSiE3+w=;
        b=gHyHuIqqHwyEJIYUKODisWBVyERQsnbw4WLc+N+eJrJobDfJJ/FChKDtyshxY/Dsq7GUCn
        hrmf+zijbRQhtkIeX+WR/fOK5rNXAgOM5rY1fMphMd7Q6YxAbM3YVX/bUcOse8KCDsy672
        ZYnCikcVKLEwV8effANAk4BGQUZR9ts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ben Gardon <bgardon@google.com>
Cc:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into
 ctx->flags
Message-ID: <Y88sq1cQUzVj9B4D@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-2-ricarkol@google.com>
 <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 04:51:16PM -0800, Ben Gardon wrote:
> On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> > indicate that the walk is on a removed table not accesible to the HW
> > page-table walker. Then use it to avoid doing break-before-make or
> > performing CMOs (Cache Maintenance Operations) when mapping a removed
> 
> Nit: Should this say unmapping? Or are we actually going to use this
> to map memory ?

I think the *_REMOVED term feels weird as it relates to constructing a
page table. It'd be better if we instead added flags to describe the
operations we intend to elide (i.e. CMOs and TLBIs). That way the
implementation is generic enough that we can repurpose it for other use
cases.

--
Thanks,
Oliver

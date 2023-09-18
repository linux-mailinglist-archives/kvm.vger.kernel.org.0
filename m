Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17EA7A4FA7
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjIRQso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjIRQsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:48:23 -0400
Received: from out-227.mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41FB19A2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:47:36 -0700 (PDT)
Date:   Mon, 18 Sep 2023 09:47:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695055654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ln9R1K2AMa49HKt735eiLwbod7abzVOhRToBSq2nvNc=;
        b=PFJBeutpTuE5oKhT4iAo5E2TezyBTkbOoFpoDr9CAofMUMrs+vvBLm3svfFoU/zrhN3JkF
        jKLW1vZOSefLlzcKx2jNzfEo/1sH19ZdAlwPTgI63viOtPrXXEg79oyy8mb86OVbquu2Ql
        9aioXtXmYuV0JwAnsdXFHof4cdcdRxo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
Message-ID: <ZQh/H5aMoqpYgVZg@linux.dev>
References: <20230817003029.3073210-1-rananta@google.com>
 <20230817003029.3073210-3-rananta@google.com>
 <ZQSxgWWZ3YdNgeiC@linux.dev>
 <CAJHc60ytL7T73wwabD8C2+RkVgN3OQsNuBwdQKz+Qen9b_hq9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60ytL7T73wwabD8C2+RkVgN3OQsNuBwdQKz+Qen9b_hq9A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 09:41:02AM -0700, Raghavendra Rao Ananta wrote:
> On Fri, Sep 15, 2023 at 12:33 PM Oliver Upton <oliver.upton@linux.dev> wrote:

[...]

> > This would eliminate the possibility of returning ENODEV to userspace
> > where we shouldn't.
> >
> I understand that we'll be breaking the API contract and userspace may
> have to adapt to this change, but is it not acceptable to document and
> return ENODEV, since ENODEV may offer more clarity to userspace as to
> why the ioctl failed? In general, do we never extend the APIs?

Yes, we extend the existing interfaces all the time, but we almost
always require user opt in for user-visible changes in behavior. Look at
the way arm64_check_features() is handled -- we hide the 'detailed'
error and return EINVAL due to UAPI.

--
Thanks,
Oliver

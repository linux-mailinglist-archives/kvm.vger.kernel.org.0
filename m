Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893207CEB0C
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjJRWRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjJRWRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:17:14 -0400
Received: from out-198.mta0.migadu.com (out-198.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F6F111
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:17:11 -0700 (PDT)
Date:   Wed, 18 Oct 2023 22:17:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697667429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ztNFzRAh3XJ3IwivXV0tZ5qyOZlUiSKoGVQq6wIcNls=;
        b=ekUfSPU3v18059DZdZrVpew7QpqnJJ1sYScvAhqqc/pvIZCmu+oApZt8bUO6OXug6NmjNy
        i8pjmvtCEc58wMOafrBz96SXMRUdrgbDW2XXYNfUDDgtbLusEzevbfeI1SUHT+3PKgXfFc
        kwVxhDtEeZCbrh9xSGm5Msv8LXMXUyA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Eric Auger <eauger@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
Message-ID: <ZTBZYNPMw4A7kr6n@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
 <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
 <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com>
 <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
 <CAJHc60yr5U+sxSAaZipei_4TNaU0_EAWKLG8cr+5v_Z1WYRMuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60yr5U+sxSAaZipei_4TNaU0_EAWKLG8cr+5v_Z1WYRMuw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 02:16:36PM -0700, Raghavendra Rao Ananta wrote:

[...]

> I had a brief discussion about this with Oliver, and it looks like we
> might need a couple of additional changes for these register accesses:
> - For the userspace accesses, we have to implement explicit get_user
> and set_user callbacks that to filter out the unimplemented counters
> using kvm_pmu_valid_counter_mask().
> - For the guest accesses to be correct, we might have to apply the
> same mask while serving KVM_REQ_RELOAD_PMU.

To be precise, the second issue is that we want to make sure KVM's PMU
emulation never uses an invalid value for the configuration, like
enabling a PMC at an index inaccessible to the guest.

-- 
Thanks,
Oliver

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18D7D0233
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 21:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346407AbjJSTGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 15:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345286AbjJSTGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 15:06:07 -0400
Received: from out-198.mta0.migadu.com (out-198.mta0.migadu.com [IPv6:2001:41d0:1004:224b::c6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56459CA
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 12:06:06 -0700 (PDT)
Date:   Thu, 19 Oct 2023 19:05:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697742363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RLHQdgbSkkxaLwkcFuueBvH7VycJBav8fBuH03XXBKY=;
        b=oQgChljYtL/bUrXu6LUkQIGrJjc8WiMnPJS8uSqF2+0i85LF0qAbU6vRorb3R0acf+NEdw
        gZcIJiAeOfohEj96llKypUMIb4sxUnfqGRyEqX7ybGc8+qgLJHdDMTQZKuEBMCAeSa9VIN
        TrPbM/1wjV8d1yKxluF426hrzLWEA+M=
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
Message-ID: <ZTF-FlDtvha-6Pw1@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
 <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
 <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com>
 <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
 <CAJHc60yr5U+sxSAaZipei_4TNaU0_EAWKLG8cr+5v_Z1WYRMuw@mail.gmail.com>
 <CAJHc60yQSzsuTJLcyzs5vffgRzR5i0vKQwLnhavAon6hoSkb+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60yQSzsuTJLcyzs5vffgRzR5i0vKQwLnhavAon6hoSkb+A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

Can you please make sure you include leading and trailing whitespace for
your inline replies? The message gets extremely dense and is difficult
to read.

Also -- delete any unrelated context from your replies. If there's a
localized conversation about a particular detail there's no reason to
keep the entire thread in the body.

On Thu, Oct 19, 2023 at 11:46:22AM -0700, Raghavendra Rao Ananta wrote:
> On Wed, Oct 18, 2023 at 2:16 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> > I had a brief discussion about this with Oliver, and it looks like we
> > might need a couple of additional changes for these register accesses:
> > - For the userspace accesses, we have to implement explicit get_user
> > and set_user callbacks that to filter out the unimplemented counters
> > using kvm_pmu_valid_counter_mask().
> Re-thinking the first case: Since these registers go through a reset
> (reset_pmu_reg()) during initialization, where the valid counter mask
> is applied, and since we are sanitizing the registers with the mask
> before running the guest (below case), will implementing the
> {get,set}_user() add any value, apart from just keeping userspace in
> sync with every update of PMCR.N?

KVM's sysreg emulation (as seen from userspace) fails to uphold the RES0
bits of these registers. That's a bug.

-- 
Thanks,
Oliver

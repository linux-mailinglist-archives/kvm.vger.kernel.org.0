Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE093740161
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjF0Qg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 12:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjF0QgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 12:36:25 -0400
Received: from out-59.mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E46109
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 09:36:23 -0700 (PDT)
Date:   Tue, 27 Jun 2023 16:36:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687883781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TdPWXSyjblV3/5xOatcCVLPo7q0/XX1p8z7/HRrMyY4=;
        b=EXIZVy5J6MxGX9EQ+OKpXpnnjbw5vcyBncQrLh1i58J5rK3yZEUFuI1CpFoLhqMING/XeP
        KXHTTGtwb2mpSmLdpYfZnQfT8KEgSBAzQk7Yr6uodNnP/9VUfXRhrmcb6YtTumqyh/1+1j
        WQz0gZ20fj54qKqWLkxZptQhaLjcGAQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: timers: Use CNTHCTL_EL2 when setting
 non-CNTKCTL_EL1 bits
Message-ID: <ZJsQAFlsx0GssfL2@linux.dev>
References: <20230627140557.544885-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230627140557.544885-1-maz@kernel.org>
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

On Tue, Jun 27, 2023 at 03:05:57PM +0100, Marc Zyngier wrote:
> It recently appeared that, whien running VHE, there is a notable
> difference between using CNTKCTL_EL1 and CNTHCTL_EL2, despite what
> the architecture documents:
> 
> - When accessed from EL2, bits [19:18] and [16:10] same bits have
>   the same assignment as CNTHCTL_EL2
> - When accessed from EL1, bits [19:18] and [16:10] are RES0
> 
> It is all OK, until you factor in NV, where the EL2 guest runs at EL1.
> In this configuration, CNTKCTL_EL11 doesn't trap, nor ends up in
> the VNCR page. This means that any write from the guest affecting
> CNTHCTL_EL2 using CNTKCTL_EL1 ends up losing some state. Not good.
> 
> The fix it obvious: don't use CNTKCTL_EL1 if you want to change bits
> that are not part of the EL1 definition of CNTKCTL_EL1, and use
> CNTHCTL_EL2 instead. This doesn't change anything for a bare-metal OS,
> and fixes it when running under NV. The NV hypervisor will itself
> have to work harder to merge the two accessors.
> 
> Note that there is a pending update to the architecture to address
> this issue by making the affected bits UNKNOWN when CNTKCTL_EL1 is
> user from EL2 with VHE enabled.
> 
> Fixes: c605ee245097 ("KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org # v6.4

Looks good. I'll probably open a fixes branch around -rc1 and pick this
patch up then.

-- 
Thanks,
Oliver

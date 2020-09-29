Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2CD27C2C1
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 12:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgI2KuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 06:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI2KuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 06:50:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74AC3207C4;
        Tue, 29 Sep 2020 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601376611;
        bh=+I6vWV6P/qLfkwTM5yFDXU97X8kNtec29ztsEGOJdkI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pfTAeyF0I6swVhhX5Ipfkso18w0joB1zkX5353v8f9nLyFPXnGZ15eBJPKN3sHwMd
         F19mZ62c+2/97x2BqhQwTGlFeDhHY7Fy2B2QqgkGa1nEJzs3NfOiLbN0tpfM2NTcW7
         md0GD5TzXewY0Es6DVpCAJDNYY+H4ZepDQtRtfVc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kNDCz-00FlHa-KA; Tue, 29 Sep 2020 11:50:09 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 29 Sep 2020 11:50:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        catalin.marinas@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        wanghaibin.wang@huawei.com, yezengruan@huawei.com,
        shameerali.kolothum.thodi@huawei.com, fanhenglong@huawei.com,
        prime.zeng@hisilicon.com
Subject: Re: [RFC PATCH 0/4] Add support for ARMv8.6 TWED feature
In-Reply-To: <20200929091727.8692-1-wangjingyi11@huawei.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <913250ae919fb9453feadd0527827d55@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com, yezengruan@huawei.com, shameerali.kolothum.thodi@huawei.com, fanhenglong@huawei.com, prime.zeng@hisilicon.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-09-29 10:17, Jingyi Wang wrote:
> TWE Delay is an optional feature in ARMv8.6 Extentions. There is a
> performance benefit in waiting for a period of time for an event to
> arrive before taking the trap as it is common that event will arrive
> “quite soon” after executing the WFE instruction.

Define "quite soon". Quantify "performance benefits". Which are the
workloads that actually benefit from this imitation of the x86 PLE?

I was opposed to this when the spec was drafted, and I still am given
that there is zero supporting evidence that it bring any gain over
immediate trapping in an oversubscribed environment (which is the only
case where it matters).

Thanks,

         M.

> 
> This series adds support for TWED feature and implements TWE delay
> value dynamic adjustment.
> 
> Thanks for Shameer's advice on this series. The function of this patch
> has been tested on TWED supported hardware and the performance of it is
> still on test, any advice will be welcomed.
> 
> Jingyi Wang (2):
>   KVM: arm64: Make use of TWED feature
>   KVM: arm64: Use dynamic TWE Delay value
> 
> Zengruan Ye (2):
>   arm64: cpufeature: TWED support detection
>   KVM: arm64: Add trace for TWED update
> 
>  arch/arm64/Kconfig                   | 10 +++++
>  arch/arm64/include/asm/cpucaps.h     |  3 +-
>  arch/arm64/include/asm/kvm_arm.h     |  5 +++
>  arch/arm64/include/asm/kvm_emulate.h | 38 ++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h    | 19 ++++++++-
>  arch/arm64/include/asm/virt.h        |  8 ++++
>  arch/arm64/kernel/cpufeature.c       | 12 ++++++
>  arch/arm64/kvm/arm.c                 | 58 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/handle_exit.c         |  2 +
>  arch/arm64/kvm/trace_arm.h           | 21 ++++++++++
>  10 files changed, 174 insertions(+), 2 deletions(-)

-- 
Jazz is not dead. It just smells funny...

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44502CFC83
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 19:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgLESWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 13:22:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgLESWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 13:22:47 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 052B323138;
        Sat,  5 Dec 2020 18:22:07 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1klcC4-00GNe7-SK; Sat, 05 Dec 2020 18:22:05 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 05 Dec 2020 18:22:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH v3 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
In-Reply-To: <a82cf9ff-f18d-ce0a-f7a2-82a56cbbec40@linaro.org>
References: <20201204073126.6920-1-zhukeqian1@huawei.com>
 <20201204073126.6920-3-zhukeqian1@huawei.com>
 <a82cf9ff-f18d-ce0a-f7a2-82a56cbbec40@linaro.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <ef43679b6710fc4320203975bc2bde98@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: daniel.lezcano@linaro.org, zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, tglx@linutronix.de, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, sean.j.christopherson@intel.com, julien.thierry.kdev@gmail.com, broonie@kernel.org, akpm@linux-foundation.org, alexios.zavras@intel.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Daniel,

On 2020-12-05 11:15, Daniel Lezcano wrote:
> Hi Marc,
> 
> are you fine with this patch ?

I am, although there still isn't any justification for the pos/lsb
rework in the commit message (and calling that variable lsb is somewhat
confusing). If you are going to apply it, please consider adding
the additional comment below.

> 
> 
> On 04/12/2020 08:31, Keqian Zhu wrote:
>> ARM virtual counter supports event stream, it can only trigger an 
>> event
>> when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 
>> changes,
>> so the actual period of event stream is 2^(cntkctl_evnti + 1). For 
>> example,
>> when the trigger bit is 0, then virtual counter trigger an event for 
>> every
>> two cycles.

"While we're at it, rework the way we compute the trigger bit position 
by
  making it more obvious that when bits [n:n-1] are both set (with n 
being
  the most significant bit), we pick bit (n + 1)."

With that:

Acked-by: Marc Zyngier <maz@kernel.org>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650272F0EA4
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 10:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbhAKJAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 04:00:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727623AbhAKJAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 04:00:15 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 530C822581;
        Mon, 11 Jan 2021 08:59:34 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kyt2y-006cel-8W; Mon, 11 Jan 2021 08:59:32 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 11 Jan 2021 08:59:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Haibo Xu <haibo.xu@linaro.org>
Cc:     arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
In-Reply-To: <CAJc+Z1GFHp17+ROTyDnfS4QLs0kCEVBCD7+OBkHZA53q-zmiLQ@mail.gmail.com>
References: <20201210160002.1407373-1-maz@kernel.org>
 <CAJc+Z1GFHp17+ROTyDnfS4QLs0kCEVBCD7+OBkHZA53q-zmiLQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <47c1fd0431cb6dddcd9e81213b84c019@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: haibo.xu@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com, andre.przywara@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Haibo,

On 2021-01-11 07:20, Haibo Xu wrote:
> On Fri, 11 Dec 2020 at 00:00, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> This is a rework of the NV series that I posted 10 months ago[1], as a
>> lot of the KVM code has changed since, and the series apply anymore
>> (not that anybody really cares as the the HW is, as usual, made of
>> unobtainium...).
>> 
>> From the previous version:
>> 
>> - Integration with the new page-table code
>> - New exception injection code
>> - No more messing with the nVHE code
>> - No AArch32!!!!
>> - Rebased on v5.10-rc4 + kvmarm/next for 5.11
>> 
>> From a functionality perspective, you can expect a L2 guest to work,
>> but don't even think of L3, as we only partially emulate the
>> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
>> as well as anything that would require a Stage-1 PTW. What we want to
>> achieve is that with NV disabled, there is no performance overhead and
>> no regression.
>> 
>> The series is roughly divided in 5 parts: exception handling, memory
>> virtualization, interrupts and timers for ARMv8.3, followed by the
>> ARMv8.4 support. There are of course some dependencies, but you'll
>> hopefully get the gist of it.
>> 
>> For the most courageous of you, I've put out a branch[2]. Of course,
>> you'll need some userspace. Andre maintains a hacked version of
>> kvmtool[3] that takes a --nested option, allowing the guest to be
>> started at EL2. You can run the whole stack in the Foundation
>> model. Don't be in a hurry ;-).
>> 
> 
> Hi Marc,
> 
> I got a kernel BUG message when booting the L2 guest kernel with the
> kvmtool on a FVP setup.
> Could you help have a look about the BUG message as well as my
> environment configuration?
> I think It probably caused by some local configurations of the FVP 
> setup.

No, this is likely a bug in your L1 guest, which was fixed in -rc3:

2a5f1b67ec57 ("KVM: arm64: Don't access PMCR_EL0 when no PMU is 
available")

and was found in the exact same circumstances. Alternatively, and if
you don't want to change your L1 guest, you can just pass the --pmu
option to kvmtool when starting the L1 guest.

Hope this helps,

         M.
-- 
Jazz is not dead. It just smells funny...

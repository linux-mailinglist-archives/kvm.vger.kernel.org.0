Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DE1305E73
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 15:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhA0Oib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 09:38:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231852AbhA0OgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 09:36:06 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D62F7207C4;
        Wed, 27 Jan 2021 14:35:25 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l4lul-00AOQ3-Dz; Wed, 27 Jan 2021 14:35:23 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 27 Jan 2021 14:35:23 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: Re: [PATCH v2 6/7] KVM: arm64: Upgrade PMU support to ARMv8.4
In-Reply-To: <59700102-5340-b5ec-28e2-d95ee3e59c6b@arm.com>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-7-maz@kernel.org>
 <59700102-5340-b5ec-28e2-d95ee3e59c6b@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <1b594e7b1f47e372ea84f759507db0b9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2021-01-27 14:09, Alexandru Elisei wrote:
> Hi Marc,
> 
> On 1/25/21 12:26 PM, Marc Zyngier wrote:
>> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
>> pretty easy. All that is required is support for PMMIR_EL1, which
>> is read-only, and for which returning 0 is a valid option as long
>> as we don't advertise STALL_SLOT as an implemented event.
> 
> According to ARM DDI 0487F.b, page D7-2743:
> 
> "If ARMv8.4-PMU is implemented:
> - If STALL_SLOT is not implemented, it is IMPLEMENTATION DEFINED
> whether the PMMIR
> System registers are implemented.
> - If STALL_SLOT is implemented, then the PMMIR System registers are
> implemented."
> 
> I tried to come up with a reason why PMMIR is emulated instead of being 
> left
> undefined, but I couldn't figure it out. Would you mind adding a 
> comment or
> changing the commit message to explain that?

The main reason is that PMMIR gets new fields down the line,
and doing the bare minimum in term of implementation allows
us to gently ease into it.

We could also go for the full PMMIR reporting on homogeneous
systems too, as a further improvement.

What do you think?

         M.
-- 
Jazz is not dead. It just smells funny...

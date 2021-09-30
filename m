Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF9F41D6BB
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 11:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349576AbhI3JtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 05:49:02 -0400
Received: from foss.arm.com ([217.140.110.172]:51308 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238648AbhI3JtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 05:49:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14B2FD6E;
        Thu, 30 Sep 2021 02:47:19 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DD8C3F793;
        Thu, 30 Sep 2021 02:47:17 -0700 (PDT)
Message-ID: <acd37032-b07f-c30c-f65f-d40cd85d2e74@arm.com>
Date:   Thu, 30 Sep 2021 10:48:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 1/5] KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing
 a virtual GICv3
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        kernel-team@android.com
References: <20210924082542.2766170-1-maz@kernel.org>
 <20210924082542.2766170-2-maz@kernel.org>
 <7fe293a6-16af-929f-33b1-aa89675197b0@arm.com> <87k0iztljq.wl-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
In-Reply-To: <87k0iztljq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/29/21 17:04, Marc Zyngier wrote:
> Hi Alex,
>
> On Wed, 29 Sep 2021 16:29:09 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Hi Marc,
>>
>> On 9/24/21 09:25, Marc Zyngier wrote:
>>> Until now, we always let ID_AA64PFR0_EL1.GIC reflect the value
>>> visible on the host, even if we were running a GICv2-enabled VM
>>> on a GICv3+compat host.
>>>
>>> That's fine, but we also now have the case of a host that does not
>>> expose ID_AA64PFR0_EL1.GIC==1 despite having a vGIC. Yes, this is
>>> confusing. Thank you M1.
>>>
>>> Let's go back to first principles and expose ID_AA64PFR0_EL1.GIC=1
>>> when a GICv3 is exposed to the guest. This also hides a GICv4.1
>>> CPU interface from the guest which has no business knowing about
>>> the v4.1 extension.
>> Had a look at the gic-v3 driver, and as far as I can tell it does
>> not check that a GICv3 is advertised in ID_AA64PFR0_EL1. If I didn't
>> get this wrong, then this patch is to ensure architectural
>> compliance for a guest even if the hardware is not necessarily
>> compliant, right?
> Indeed. Not having this made some of my own tests fail on M1 as they
> rely on ID_AA64PFR0_EL1.GIC being correct. I also pondered setting it
> to 0 when emulating a GICv2, but that'd be a change in behaviour, and
> I want to think a bit more about the effects of that.
>
>> GICv4.1 is an extension to GICv4 (which itself was an extension to
>> GICv3) to add support for virtualization features (virtual SGIs), so
>> I don't see any harm in hiding it from the guest, since the guest
>> cannot virtual SGIs.
> Indeed. The guest already has another way to look into this by
> checking whether the distributor allows active-less SGIs.

Thank you for the clarification, the patch looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Thanks,
>
> 	M.
>

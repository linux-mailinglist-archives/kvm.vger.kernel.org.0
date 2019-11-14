Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC753FC9CE
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfKNPVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:21:53 -0500
Received: from foss.arm.com ([217.140.110.172]:44992 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbfKNPVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 10:21:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D614F328;
        Thu, 14 Nov 2019 07:21:52 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE3D13F52E;
        Thu, 14 Nov 2019 07:21:51 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping
 GICD_CTLR.DS
To:     Vladimir Murzin <vladimir.murzin@arm.com>,
        Andre Przywara <andre.przywara@arm.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-10-andre.przywara@arm.com>
 <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
 <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com>
 <20191114141745.32d3b89c@donnerap.cambridge.arm.com>
 <90cdc695-f761-26bd-d2a7-f8655ce04463@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <187393bb-a32d-092d-d0ea-44c58a54d1de@arm.com>
Date:   Thu, 14 Nov 2019 15:21:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <90cdc695-f761-26bd-d2a7-f8655ce04463@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/14/19 2:50 PM, Vladimir Murzin wrote:
> On 11/14/19 2:17 PM, Andre Przywara wrote:
>> On Thu, 14 Nov 2019 13:39:33 +0000
>> Vladimir Murzin <vladimir.murzin@arm.com> wrote:
>>
>>> Hi,
>>>
>>> On 11/12/19 4:42 PM, Alexandru Elisei wrote:
>>>> Are we not testing KVM? Why are we not treating a behaviour different than what
>>>> KVM should emulate as a fail?
>>> Can kvm-unit-tests be run with qemu TCG?
>> Yes, it does that actually by default if you cross compile. I also tested this explicitly on TCG: unlike KVM that actually passes all those tests.
>> If you set the environment variable ACCEL to either tcg or kvm, you can select this at runtime:
>> $ ACCEL=tcg arm/run arm/gic.flat -smp 3 -append irq
> Great! Then, IMO, it is absolutely valid to test this functionality!

TCG emulates a GIC with a single security state for me:

/usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=3,accel=tcg
-cpu cortex-a57 -device virtio-serial-device -device virtconsole,chardev=ctd
-chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
arm/gic.flat -append irq
PASS: gicv3: irq: SPI triggered by CPU write
PASS: gicv3: irq: disabled SPI does not fire
PASS: gicv3: irq: now enabled SPI fires
INFO: gicv3: irq: GROUP: GIC is one security state only
[..]

But that could change someday, so I'm fine with failing only if we are not allowed
to have GICD_CTLR.DS=1, because that will prevent us from testing group 0 interrupts.

Thanks,
Alex
> Thanks
> Vladimir
>
>> Cheers,
>> Andre
>>

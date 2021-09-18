Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E13410791
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 18:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbhIRQTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Sep 2021 12:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhIRQTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Sep 2021 12:19:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7E1C061574
        for <kvm@vger.kernel.org>; Sat, 18 Sep 2021 09:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=72laBgllLDvPPa2HfsaMPLygXh5K0JehqshRy10whlY=; b=ZTkaeV2R+oaPcuuO5Pm/NzZiPl
        wxPGSGhljHUAHbjxgWz04hQIljJMoZzyNNSn0XLtWKp8AFrP7o0+5p0JeLoAEyL/2sSFmE9V3WuNR
        3whi7jZZ09yrvQNHhzmAR0EwqVLUWe58qL2l+12TsdfXeKIQiwwIa9yNWuQKsfwopR+5miv1fFZIu
        CeJXfaPzGp6OqCCkAK1QgdqIeVQyOhMw+WaUQqmVrDob1FT6j8sUjfhq7Zmrx9IvkEEQbYO9EXAUI
        yjayHJyEitoKoLlPQaEh+HS0N3x2U4rCfFJuRcSvuPE8yyAartBF9Phg+Ih8A8S7hDzP3RLj+Yxb0
        y0JBZyNQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54638)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mRd2D-0000Nl-Gb; Sat, 18 Sep 2021 17:17:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mRd29-0000Wl-UH; Sat, 18 Sep 2021 17:17:45 +0100
Date:   Sat, 18 Sep 2021 17:17:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>
Subject: REGRESSION: Upgrading host kernel from 5.11 to 5.13 breaks QEMU
 guests - perf/fw_devlink/kvm
Message-ID: <YUYRKVflRtUytzy5@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This morning, I upgraded my VM host from Debian Buster to Debian
Bullseye. This host (Armada 8040) runs libvirt. I placed all the VMs
into managedsave, which basically means their state is saved out by
QEMU ready to be resumed once the upgrade is complete.

Initially, I was running 5.11 on the host, which didn't have POSIX
ACLs enabled on tmpfs. Sadly, upgrading to Bullseye now requires
this to be enabled, so I upgraded the kernel to 5.13 to avoid this
problem - without POSIX ACLs on tmpfs, qemu refuses to even start.

Under Bullseye with 5.13, I could start new VMs, but I could not
resume the saved VMs - it would spit out:

2021-09-18T11:14:14.456227Z qemu-system-aarch64: Invalid value 236 expecting positive value <= 162
2021-09-18T11:14:14.456269Z qemu-system-aarch64: Failed to load cpu:cpreg_vmstate_array_len
2021-09-18T11:14:14.456279Z qemu-system-aarch64: error while loading state for instance 0x0 of device 'cpu'
2021-09-18T11:14:14.456887Z qemu-system-aarch64: load of migration failed: Invalid argument

Essentially, what this is complaining about is that the register
list returned by the KVM_GET_REG_LIST ioctl has reduced in size,
meaning that the saved VM has more registers that need to be set
(236 of them, after QEMU's filtering) than those which are actually
available under 5.13 (162 after QEMU's filtering).

After much debugging, and writing a program to create a VM and CPU,
and retrieve the register list etc, I have finally tracked down
exactly what is going on...

Under 5.13, KVM believes there is no PMU, so it doesn't advertise the
PMU registers, despite the hardware having a PMU and the kernel
having support.

kvm_arm_support_pmu_v3() determines whether the PMU_V3 feature is
available or not.

Under 5.11, this was determined via:

	perf_num_counters() > 0

which in turn was derived from (essentially):

	__oprofile_cpu_pmu && __oprofile_cpu_pmu->num_events > 0

__oprofile_cpu_pmu can be set at any time when the PMU has been
initialised, and due to initialisation ordering, it appears to happen
much later in the kernel boot.

However, under 5.13, oprofile has been removed, and this test is no
longer present. Instead, kvm attempts to determine the availability
of PMUv3 when it initialises, and fails to because the PMU has not
yet been initialised. If there is no PMU at the point KVM initialises,
then KVM will never advertise a PMU.

This change of behaviour is what breaks KVM on Armada 8040, causing
a userspace regression.

What makes this more confusing is the PMU errors have gone:

5.13:
[    0.170514] PCI: CLS 0 bytes, default 64
[    0.171085] kvm [1]: IPA Size Limit: 44 bits
[    0.172532] kvm [1]: vgic interrupt IRQ9
[    0.172650] kvm: pmu event creation failed -2
[    0.172688] kvm [1]: Hyp mode initialized successfully
...
[    1.479833] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 7 counters available

5.11:
[    0.138831] PCI: CLS 0 bytes, default 64
[    0.139245] hw perfevents: unable to count PMU IRQs
[    0.139251] hw perfevents: /ap806/config-space@f0000000/pmu: failed to register PMU devices!
[    0.139503] kvm [1]: IPA Size Limit: 44 bits
[    0.140735] kvm [1]: vgic interrupt IRQ9
[    0.140836] kvm [1]: Hyp mode initialized successfully
...
[    1.447789] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 7 counters available

Overall, what this means is that the only way to safely upgrade from
5.11 to 5.13 (I don't know where 5.12 fits in this) is to completely
shut down all your VMs. You can't even migrate them to another
identical machine across these kernels. You have to completely shut
them down.

I did manage to eventually rescue my VMs after many hours, by booting
back into 5.11, and then screwing around with bind mounts to replace
/dev with a filesystem that did have POSIX ACLs enabled, so libvirt
and qemu could then resume the VMs and cleanly shut them down all
down.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

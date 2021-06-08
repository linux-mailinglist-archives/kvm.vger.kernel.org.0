Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C5439F5F9
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhFHMFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhFHMF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:05:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D1606128D;
        Tue,  8 Jun 2021 12:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623153816;
        bh=TfjLAVqrZKwY0IV8e659Z+X17Esbdt1qHTkNeo85xFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pYN7LoM6VXDlHC86InF+wbIpNoZ+dZXNObun7GakAu7R5a8W3BG81LOuOz8d/sH5x
         s83SjjcEl8PrKI2oNFvWIwg5FZjzdX3GTbDLgYC4q32pAWe88ejEtjUy0vXOz3aAzw
         27rFTeOXsNh7AgJJRytR6hHQYOsUmLe3zFwnm3uARUPXc/tpnJlaYELoIxgw39VsfJ
         Tp/szkmmqVyGAIrI4YfvYvhLEqIc0Th4GI5UQO3+KPSPpBV6MfVJGwdgSGdTjigvFF
         3EUIMnpInNWXZWh3CuJhaFq2T4+xoNvZhBCfazSNXJsqTaQffSrvws8eTmIwNQCpYw
         +kGoVyl8/Hl1w==
Date:   Tue, 8 Jun 2021 13:03:31 +0100
From:   Will Deacon <will@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] KVM: arm64: Parse reserved-memory node for pkvm
 guest firmware region
Message-ID: <20210608120330.GC10174@willie-the-truck>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-4-will@kernel.org>
 <20210604142141.GC69333@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604142141.GC69333@C02TD0UTHF1T.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mark,

On Fri, Jun 04, 2021 at 03:21:41PM +0100, Mark Rutland wrote:
> On Thu, Jun 03, 2021 at 07:33:46PM +0100, Will Deacon wrote:
> > Add support for a "linux,pkvm-guest-firmware-memory" reserved memory
> > region, which can be used to identify a firmware image for protected
> > VMs.
> 
> The idea that the guest's FW comes from the host's FW strikes me as
> unusual; what's the rationale for this coming from the host FW? IIUC
> other confidential compute VM environments allow you to load up whatever
> virtual FW you want, but this is measured such that the virtual FW used
> can be attested.

The rationale is that, as far as possible, we're trying to keep the EL2
code simple and agnostic of the guest and the SoC. We therefore assign
validation of the guest payload to this firmware image which is executed
when first entering the guest and made inaccessible to the host kernel
as part of the deprivilege operation during boot. The VMM could still
provide its own virtual firmware, which would then be measured by the
firmware here and chainloaded. We just deprivilege that logic from EL2
to EL1.

For pKVM on Android, it is the Android Bootloader which loads both the
host kernel and the guest firmware (which is actually just u-boot).
Before entering the host, it verifies and measures the guest firmware,
appending secrets to the reserved memory region which are later used by
the firmware to generate per-VM identities. These certificates are then
used by the guest to establish a communication channel with Android's
"Keymint" [1] HAL on the host and get access to hardware-backed key
resources. That way we have a certificate chain which ties directly into
Android Verified Boot [2] and extends to the guest payload without KVM
having to be aware of any of it.

Since this is all pretty specific to Android, delegating it to the
firmware allows others to use their own mechanisms without bloating the
privileged code at EL2 or enforcing a specific flow.

A straightforward extension in future would be to make this firmware
optional when spawning a protected VM, but since we have no need for
that in Android (where we require the firmware), we elected to keep
things minimal at first.

Cheers,

Will

[1] https://source.android.com/security/keystore
[2] https://source.android.com/security/verifiedboot

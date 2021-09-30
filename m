Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074DF41DE52
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 18:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348089AbhI3QEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 12:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347588AbhI3QEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 12:04:40 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6FAB6136A;
        Thu, 30 Sep 2021 16:02:57 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mVyWN-00E1nE-Sz; Thu, 30 Sep 2021 17:02:55 +0100
MIME-Version: 1.0
Date:   Thu, 30 Sep 2021 17:02:55 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     Fuad Tabba <tabba@google.com>, kvmarm@lists.cs.columbia.edu,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, drjones@redhat.com,
        oupton@google.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v6 03/12] KVM: arm64: Move early handlers to per-EC
 handlers
In-Reply-To: <20210930133444.GC23809@willie-the-truck>
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-4-tabba@google.com>
 <20210930133444.GC23809@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <2b007cfc37203c84237d4a523cb0cadb@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, tabba@google.com, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, christoffer.dall@arm.com, pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-09-30 14:35, Will Deacon wrote:
> On Wed, Sep 22, 2021 at 01:46:55PM +0100, Fuad Tabba wrote:
>> From: Marc Zyngier <maz@kernel.org>

>> +static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 
>> *exit_code)
>> +{
>> +	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
>> +	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
>> +		return true;
> 
> I think you're now calling this for the 64-bit CP15 access path, which 
> I
> don't think is correct. Maybe have separate handlers for 32-bit v4 
> 64-bit
> accesses?

Good point. The saving grace is that there is no 32bit-capable CPU that
requires GICv3 trapping, nor any 64bit cp15 register in the GICv3
architecture apart form the SGI registers, which are always handled at 
EL1.
So this code is largely academic!

Not providing a handler is the way to go for CP15-64.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

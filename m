Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8699529AA4A
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 12:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898980AbgJ0LIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 07:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898975AbgJ0LIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 07:08:18 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8589021655;
        Tue, 27 Oct 2020 11:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603796897;
        bh=hN0qy1y7mET6+8oBNyv6KDyBxf+wqltkkA89flTvk2g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RMlyud2QvQfcVq+rDgM86g3QNRieFI/7Rw11vGogACyi2THdd68p5C5TfD92/QQN6
         m5OTG9uyCFeOf0korrVWCqoBEWA8zoij9zbHBkggbW922lqwYcnvafLSTHtJPZ2bH0
         jO9D82+RWqGYQBV11sRc7SMMODdHYlhozByn0+74=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kXMpr-004fCh-7M; Tue, 27 Oct 2020 11:08:15 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 11:08:15 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: Re: [PATCH 03/11] KVM: arm64: Make kvm_skip_instr() and co private to
 HYP
In-Reply-To: <a2b942e5-651b-4733-4332-98b33fc6689b@arm.com>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-4-maz@kernel.org>
 <a2b942e5-651b-4733-4332-98b33fc6689b@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <3ae9d792ea381ba42874ebe5f7c08347@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, ascull@google.com, will@kernel.org, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-10-27 10:55, Suzuki K Poulose wrote:
> On 10/26/20 1:34 PM, Marc Zyngier wrote:
>> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
>> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
>> to increment PC post emulation is now signalled via a flag in the
>> vcpu structure.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>

[...]

>> +static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
>> +{
>> +	if (vcpu_mode_is_32bit(vcpu)) {
>> +		kvm_skip_instr32(vcpu);
>> +	} else {
>> +		*vcpu_pc(vcpu) += 4;
>> +		*vcpu_cpsr(vcpu) &= ~PSR_BTYPE_MASK;
>> +	}
>> +
>> +	/* advance the singlestep state machine */
>> +	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
>> +}
>> +
>> +/*
>> + * Skip an instruction which has been emulated at hyp while most 
>> guest sysregs
>> + * are live.
>> + */
>> +static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
>> +{
>> +	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
>> +	vcpu_gp_regs(vcpu)->pstate = read_sysreg_el2(SYS_SPSR);
>> +
>> +	__kvm_skip_instr(vcpu);
> 
> Did you mean kvm_skip_instr() instead ?

Damn. How embarrassing! Yes, of course. I should have thrown my TX1 at 
it!

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

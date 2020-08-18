Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B537C2482F8
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 12:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgHRKaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 06:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgHRKaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 06:30:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F286206DA;
        Tue, 18 Aug 2020 10:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597746620;
        bh=9ED5nbVPRnIiQLubybjj1HI9b9VbQnnui7vFmaJAEic=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fMVjPgLb4b5JwRaBdB4p22fsfoteyOLe+6GwBkR2d4S/o4JnOBawPAjxgG/nm+diq
         fEcTj9f2IBYZs6ZxM2h173GZx7c21JRd/jJ1UyCLZQB0G5i6/vd9ANpIa8NNkbK8H5
         No4d1/R/Nzprq1u2cR3njIhKGYthc6pMu7ro4fQ4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k7ysj-003rr2-Ft; Tue, 18 Aug 2020 11:30:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 18 Aug 2020 11:30:17 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix sleeping while atomic BUG() on OOM
In-Reply-To: <20200818101607.GB15543@willie-the-truck>
References: <20200811102725.7121-1-will@kernel.org>
 <ff1d4de2-f3f8-eafa-6ba5-3e5bb715ae05@redhat.com>
 <20200818101607.GB15543@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <edbd49c6ad999b71af3c2a64c920f418@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, suzuki.poulose@arm.com, james.morse@arm.com, tsbogend@alpha.franken.de, paulus@ozlabs.org, sean.j.christopherson@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-18 11:16, Will Deacon wrote:
> On Tue, Aug 18, 2020 at 08:31:08AM +0200, Paolo Bonzini wrote:
>> On 11/08/20 12:27, Will Deacon wrote:
>> > Will Deacon (2):
>> >   KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()
>> >   KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set
>> >
>> >  arch/arm64/include/asm/kvm_host.h   |  2 +-
>> >  arch/arm64/kvm/mmu.c                | 19 ++++++++++++++-----
>> >  arch/mips/include/asm/kvm_host.h    |  2 +-
>> >  arch/mips/kvm/mmu.c                 |  3 ++-
>> >  arch/powerpc/include/asm/kvm_host.h |  3 ++-
>> >  arch/powerpc/kvm/book3s.c           |  3 ++-
>> >  arch/powerpc/kvm/e500_mmu_host.c    |  3 ++-
>> >  arch/x86/include/asm/kvm_host.h     |  3 ++-
>> >  arch/x86/kvm/mmu/mmu.c              |  3 ++-
>> >  virt/kvm/kvm_main.c                 |  3 ++-
>> >  10 files changed, 30 insertions(+), 14 deletions(-)
>> >
>> 
>> These would be okay for 5.9 too, so I plan to queue them myself before
>> we fork for 5.10.
> 
> Thanks, Paolo. Let me know if you want me to rebase/repost.
> 
> Please note that I'm planning on rewriting most of the arm64 KVM 
> page-table
> code for 5.10, so if you can get this series in early (e.g. for -rc2), 
> then
> it would _really_ help with managing the kvm/arm64 queue for the next 
> merge
> window.
> 
> Otherwise, could you and Marc please set up a shared branch with just 
> these,
> so I can use it as a base?
> 
> Please let me know.

Given that this doesn't directly applies to -rc1, I'll push out a branch
shortly with the conflicts resolved.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

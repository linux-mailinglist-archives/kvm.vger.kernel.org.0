Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992514633C7
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 13:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241248AbhK3MIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 07:08:15 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34340 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241212AbhK3MIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 07:08:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3BF64CE18FE;
        Tue, 30 Nov 2021 12:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BB0C53FC7;
        Tue, 30 Nov 2021 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273891;
        bh=XZV+A03r+U14NNevxoQ+VNb6roKLqHnitP/KB5VE1bU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZlVLLcdQtjmMpvoqZ3crREGG4Tx9/cX7mlIGiOZd6h9BzUwUxvGRirVIKaUOaxjYT
         j5gtsnHmy3Pom8gpoKBLdTa9+zq0ksimfkkU+GFV8UpMhBa78nezSi2q5jNEQwAhWJ
         xq4G0RHYn2hCaCVVjpP6TiYxrQmuhlZ9TN3UAYwPmlw/EHu8tPf53sycoGgXFr8+3e
         p50fi7NH3GxciImqpxsMc5nV7QmRHXLcBYfxtqsN348RGG9ktb9N6rfUlFESziCNeM
         iyjgvu0+fxThDkF7ypznoZv3ZG7ohR4/74jaqNLB+4LCg4pB1MEHTAlZtTjNGF/jPM
         yrr//SJISMS0w==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1ms1sP-008rkT-FI; Tue, 30 Nov 2021 12:04:49 +0000
MIME-Version: 1.0
Date:   Tue, 30 Nov 2021 12:04:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 10/43] KVM: arm64: Move vGIC v4 handling for WFI out
 arch callback hook
In-Reply-To: <3490c50e-50d2-f906-3383-b87e14b14fab@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-11-seanjc@google.com>
 <9236e715-c471-e1c8-6117-6f37b908a6bd@redhat.com>
 <875ytjbxpq.wl-maz@kernel.org>
 <be1cf8c7-ed87-b8eb-1bca-0a6c7505d7f8@redhat.com>
 <3490c50e-50d2-f906-3383-b87e14b14fab@redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <4826a7e2dbecc5d57323d18d725d6d69@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, seanjc@google.com, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, paulus@ozlabs.org, anup.patel@wdc.com, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, borntraeger@de.ibm.com, frankja@linux.ibm.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, atish.patra@wdc.com, david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, dmatlack@google.com, oupton@google.com, jingzhangos@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-11-30 11:39, Paolo Bonzini wrote:
> On 10/26/21 18:12, Paolo Bonzini wrote:
>> On 26/10/21 17:41, Marc Zyngier wrote:
>>>> This needs a word on why kvm_psci_vcpu_suspend does not need the
>>>> hooks.  Or it needs to be changed to also use kvm_vcpu_wfi in the 
>>>> PSCI
>>>> code, I don't know.
>>>> 
>>>> Marc, can you review and/or advise?
>>> I was looking at that over the weekend, and that's a pre-existing
>>> bug. I would have addressed it independently, but it looks like you
>>> already have queued the patch.
>> 
>> I have "queued" it, but that's just my queue - it's not on kernel.org 
>> and it's not going to be in 5.16, at least not in the first batch.
>> 
>> There's plenty of time for me to rebase on top of a fix, if you want 
>> to send the fix through your kvm-arm pull request.  Just Cc me so that 
>> I understand what's going on.
> 
> Since a month has passed and I didn't see anything related in the
> KVM-ARM pull requests, I am going to queue this patch.  Any conflicts
> can be resolved through a kvmarm->kvm merge of either a topic branch
> or a tag that is destined to 5.16.

Can you at least spell out *when* this will land?

There is, in general, a certain lack of clarity about what you are 
queuing,
where you are queuing it, and what release it targets.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...

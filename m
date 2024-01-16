Return-Path: <kvm+bounces-6340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F37E982F1AE
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 16:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92B631F2477A
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 15:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F241C2BB;
	Tue, 16 Jan 2024 15:37:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6E31C284;
	Tue, 16 Jan 2024 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 495D549183;
	Tue, 16 Jan 2024 16:37:20 +0100 (CET)
Message-ID: <ef81ff36-64bb-4cfe-ae9b-e3acf47bff24@proxmox.com>
Date: Tue, 16 Jan 2024 16:37:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Temporary KVM guest hangs connected to KSM and NUMA balancer
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <832697b9-3652-422d-a019-8c0574a188ac@proxmox.com>
 <ZaAQhc13IbWk5j5D@google.com>
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <ZaAQhc13IbWk5j5D@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sean,

On 11/01/2024 17:00, Sean Christopherson wrote:
> This is a known issue.  It's mostly a KVM bug[...] (fix posted[...]), but I suspect
> that a bug in the dynamic preemption model logic[...] is also contributing to the
> behavior by causing KVM to yield on preempt models where it really shouldn't.

I tried the following variants now, each applied on top of 6.7 (0dd3ee31):

* [1], the initial patch series mentioned in the bugreport ("[PATCH 0/2]
KVM: Pre-check mmu_notifier retry on x86")
* [2], its v2 that you linked above ("[PATCH v2] KVM: x86/mmu: Retry
fault before acquiring mmu_lock if mapping is changing")
* [3], the scheduler patch you linked above ("[PATCH] sched/core: Drop
spinlocks on contention iff kernel is preemptible")
* both [2] & [3]

My kernel is PREEMPT_DYNAMIC and, according to
/sys/kernel/debug/sched/preempt, defaults to preempt=voluntary. For case
[3], I additionally tried manually switching to preempt=full.

Provided I did not mess up, I get the following results for the
reproducer I posted:

* [1] (the initial patch series): no hangs
* [2] (its v2): hangs
* [3] (the scheduler patch) with preempt=voluntary: no hangs
* [3] (the scheduler patch) with preempt=full: hangs
* [2] & [3]: no hangs

So it seems like:

* [1] (the initial patch series) fixes the hangs, which is consistent
with the feedback in the bugreport [4].
* But weirdly, its v2 [2] does not fix the hangs.
* As long as I stay with preempt=voluntary, [3] (the scheduler patch)
alone is already enough to fix the hangs in my case -- this I did not
expect :)

Does this make sense to you? Happy to double-check or run more tests if
anything seems off.

Best wishes,

Friedrich

[1] https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com/
[2] https://lore.kernel.org/all/20240110012045.505046-1-seanjc@google.com/
[3] https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com/
[4] https://bugzilla.kernel.org/show_bug.cgi?id=218259#c6



Return-Path: <kvm+bounces-6390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41FD78306A7
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 14:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 581C71C22800
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 13:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523C61EB43;
	Wed, 17 Jan 2024 13:09:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040A614A87;
	Wed, 17 Jan 2024 13:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705496975; cv=none; b=p5VF2LDxI0Hj2HIez3jnKW74HzCWBvroXWzmI40+wbgQeSss7sjnk1/OUWIfRDD8NLOBuVVQWNqYxv9ZprB2kPH4ibAOzU0oMDkItoYS4eQ2hFcAK8Jb6OPnWcp1KZVd+zd9ZKw9FY2QCrZB56JQVXhAivzWA0Sf50jwd1POqpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705496975; c=relaxed/simple;
	bh=fYYHB0VyLbRkjnGemOOKTFx4j4HGmAk7y1tiXw6SEAk=;
	h=Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=q2ilyCGk44g9BHxFuNN22jFfb08b9mGGtGMS4YqPoRXy74+JhkcEkV6wh/ifPiXhAdBUTc+DkwuvyMSD1CtNFJtHYTvP4O4WbrntnTmfzVPya91EUh5uYrGLYbvWGHTbimHfjxz1EsaAIFxaKG0SYdN9MlqS/uLmSQZhh9rnM1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 69F82457C2;
	Wed, 17 Jan 2024 14:09:29 +0100 (CET)
Message-ID: <e8f6bc21-c4e6-40de-838a-d374adb4e888@proxmox.com>
Date: Wed, 17 Jan 2024 14:09:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Temporary KVM guest hangs connected to KSM and NUMA balancer
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <832697b9-3652-422d-a019-8c0574a188ac@proxmox.com>
 <ZaAQhc13IbWk5j5D@google.com>
 <ef81ff36-64bb-4cfe-ae9b-e3acf47bff24@proxmox.com>
 <Zaa654hwFKba_7pf@google.com>
Content-Language: en-US
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <Zaa654hwFKba_7pf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/01/2024 18:20, Sean Christopherson wrote:
>> Does this make sense to you? Happy to double-check or run more tests if
>> anything seems off.
>  
> Ha!  It too me a few minutes to realize what went sideways with v2.  KVM has an
> in-flight change that switches from host virtual addresses (HVA) to guest physical
> frame numbers (GFN) for the retry check, commit 8569992d64b8 ("KVM: Use gfn instead
> of hva for mmu_notifier_retry").
> 
> That commit is in the KVM pull request for 6.8, and so v2 is based on top of a
> branch that contains said commit.  But for better or worse (probably worse), the
> switch from HVA=GFN didn't change the _names_ of mmu_invalidate_range_{start,end},
> only the type.  So v2 applies and compiles cleanly on 6.7, but it's subtly broken
> because checking for a GFN match against an HVA range is all but guaranteed to get
> false negatives.

Oof, that's nifty, good catch! I'll pay more attention to the
base-commit when testing next time. :)

> If you can try v2 on top of `git://git.kernel.org/pub/scm/virt/kvm/kvm.git next`,
> that would be helpful to confirm that I didn't screw up something else.

Pulled that repository and can confirm:

* 1c6d984f ("x86/kvm: Do not try to disable kvmclock if it was not
enabled", current `next`): reproducer hangs
* v2 [1] ("KVM: x86/mmu: Retry fault before acquiring mmu_lock if
mapping is changing") applied on top of 1c6d984f: no hangs anymore

If I understand the discussion on [1] correctly, there might be a v3 --
if so, I'll happily test that too.

> Thanks very much for reporting back!  I'm pretty sure we would have missed the
> semantic conflict when backporting the fix to 6.7 and earlier, i.e. you likely
> saved us from another round of bug reports for various stable trees.

Sure! Thanks a lot for taking a look at this!

Best wishes,

Friedrich

[1] https://lore.kernel.org/all/20240110012045.505046-1-seanjc@google.com/



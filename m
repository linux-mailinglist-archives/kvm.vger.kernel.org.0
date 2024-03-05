Return-Path: <kvm+bounces-11012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 601A5872221
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 15:57:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1733C1F221A2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56F0126F21;
	Tue,  5 Mar 2024 14:57:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp238.sjtu.edu.cn (smtp238.sjtu.edu.cn [202.120.2.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E89126F1D;
	Tue,  5 Mar 2024 14:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709650637; cv=none; b=HFOg0PGkxeRAtYq08SkhPdQYqxrmTHDzOMX71zfCDYmyG0UqWrkX/b/SGbwsIT7L0ycMoj9dB5oN1SxDJ1jx25iqZQvmnREJ1jpCDlZjHWp0RiqZRW81+7ZxeS6nGCgX5oQpdlGypjKjdyBeOvdUN9mDO/SUdk86GHoEo+MbnZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709650637; c=relaxed/simple;
	bh=MCI8FrWoh73Sxz96+HLoOzEC8uhjSDDNbG870C/UW8w=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=qOxc/J7maV/xVdzokK6tBOhxOlO8kKStS4+ulcyjoq+R73p/SGi/cO7qwkcoszHIgQtOmDcv6iDdqVktaqnE0bbzhWavtvRNB83jyQfqVh5jbMjshxYMxEAPQiu1lHooXjPuOY3I8IDtNDHj1XuA0Ezsv7+yo+uiNfPzGuhrlL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
	by smtp238.sjtu.edu.cn (Postfix) with ESMTPS id 9E76BBEDE;
	Tue,  5 Mar 2024 22:57:03 +0800 (CST)
Received: from mstore135.sjtu.edu.cn (unknown [10.118.0.135])
	by mta90.sjtu.edu.cn (Postfix) with ESMTP id 62D5837C878;
	Tue,  5 Mar 2024 22:57:03 +0800 (CST)
Date: Tue, 5 Mar 2024 22:57:03 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini <pbonzini@redhat.com>, tglx <tglx@linutronix.de>, 
	thomas lendacky <thomas.lendacky@amd.com>, kvm <kvm@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <722904540.5000784.1709650623262.JavaMail.zimbra@sjtu.edu.cn>
Subject: Re: [PATCH] KVM:SVM: Flush cache only on CPUs running SEV guest
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 10.0.6_GA_4585 (ZimbraWebClient - GC122 (Win)/10.0.6_GA_4585)
Thread-Index: MUWiCXlfMum3WwlzB2dt/UpqVaVaDA==
Thread-Topic: Flush cache only on CPUs running SEV guest

On Mon, Mar 04, 2024, Sean Christopherson wrote:
> Instead of copy+paste WBINVD+cpumask_clear() everywhere, add a prep patch to
> replace relevant open coded calls to wbinvd_on_all_cpus() with calls to
> sev_guest_memory_reclaimed().  Then only sev_guest_memory_reclaimed() needs to
> updated, and IMO it helps document why KVM is blasting WBINVD.

> I'm also pretty sure this should be a cpumask_var_t, and dynamically allocated
> as appropriate.  And at that point, it should be allocated and filled if and only
> if the CPU doesn't have X86_FEATURE_SME_COHERENT

I notice that several callers of wbinvd_on_all_cpus() must use wbinvd to flush cache
instead of using clflush or just doing nothing if the CPU has X86_FEATURE_SME_COHERENT,
according to https://github.com/AMDESE/linux/commit/2e2409afe5f0c284c7dfe5504058e8d115806a7d
Therefore, I think the flush operation should be divided into two functions. One is the 
optimized wbinvd, which does not consider X86_FEATURE_SME_COHERENT, and the other is 
sev_guest_memory_reclaimed(), which should use clflush instead of wbinvd in case of 
X86_FEATURE_SME_COHERENT. Thus the cpumask struct should be exist whether the CPU has
X86_FEATURE_SME_COHERENT or not.

Besides, if we consider X86_FEATURE_SME_COHERENT to get rid of wbinvd in sev_guest_memory_reclaimed(),
we should ensure the clflush is called on corresponding addresses, as mentioned in  
https://github.com/AMDESE/linux/commit/d45829b351ee6ec5f54dd55e6aca1f44fe239fe6 
However, caller of sev_guest_memory_reclaimed() (e.g., kvm_mmu_notifier_invalidate_range_start()) 
only get HVA belongs to userspace(e.g., qemu), so calling clflush with this HVA may 
lead to a page fault in kernel. I was wondering if notifying userspace applications to 
do clflush themselves is the only solution here. But for the sake of safety, maybe KVM 
cannot left the work for untrusted userspace applications?

Or should I just temporarily ignore the X86_FEATURE_SME_COHERENT scenario which is hard to implement, 
and just refine the patch only for wbinvd_on_all_cpus() ?

Best regards,
Zheyun Shen


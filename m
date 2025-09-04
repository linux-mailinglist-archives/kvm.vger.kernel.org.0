Return-Path: <kvm+bounces-56852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8672EB44A7F
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 01:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EF4E1BC030E
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 23:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 923922F83AA;
	Thu,  4 Sep 2025 23:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGFEfNiS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE122F60D1;
	Thu,  4 Sep 2025 23:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757029289; cv=none; b=OG5HE6AHKVNUwuihW2cU5kaMMkSMDQPOyg866X5Vv2+U7DWDGPn9Gj7rt6ExljYIeq8ZR714OVil+HOR4t4FPXPZ70yCuy5d7MBI8yTLeKd8i9yvFD22RxQBm4rAVD/Z+yBD1agL3EZEMgfnepZAYF4RLuoU10qMeLgmAEXv/4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757029289; c=relaxed/simple;
	bh=FXSCx6Zola7pSIKISL/TTWzUvg3jHW6dDupjOWBR9lE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOi97P6+Pe+6xfvDusBZnXPU6f02TbicBGE5sTH0usqQuqj9SflTG3QXF3V9juBBMXMJUSy/aH2ksDXo+JAoirzW6wUZhh1SF1iaXD1qVLLRjVGTVZZRqkm6Siw0T5H6IBF8QEHTbMXX8FB51E0ZP9KGPg1WxWOUMIOsI63QHmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGFEfNiS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A26EC4CEF0;
	Thu,  4 Sep 2025 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757029289;
	bh=FXSCx6Zola7pSIKISL/TTWzUvg3jHW6dDupjOWBR9lE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dGFEfNiSpDwfJ33AtkShNPM078gopMDZtzNhmg6Vx1TpHFUOEvHE+k+nQY+CIaWt5
	 ldWncxa93/0mE3j+f0i1Zf9yrOAJ+75RyW+J1YwN9tXAIyt16lM0sjyPFDPMbSNME9
	 iAWsaSqDPvNGQEzmBsNdR6uepNSln8tH6NyayMc2Hs5KL//qxSgb18Q53qhXSKKTs6
	 m1as719tex5fuOBePlRAFY6+mm5bWvyJ9wGVFmA8ooOZOzSAGKCmC9nu1o09XoeMOK
	 dHazGYMYzfoQcWMEFYNS67lV9mMee8b+DdnvMtqZmWlNl7GJ16FSdXhv+Mq5nHvjJE
	 LI6S0TEtEv4Xg==
Date: Thu, 4 Sep 2025 23:41:27 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Mukesh R <mrathor@linux.microsoft.com>
Subject: Re: [PATCH v2 0/7] Drivers: hv: Fix NEED_RESCHED_LAZY and use common
 APIs
Message-ID: <aLojpyTwAMdb1z6D@liuwe-devbox-ubuntu-v2.lamzopl0uupeniq2etz1fddiyg.xx.internal.cloudapp.net>
References: <20250828000156.23389-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828000156.23389-1-seanjc@google.com>

On Wed, Aug 27, 2025 at 05:01:49PM -0700, Sean Christopherson wrote:
> Fix a bug where MSHV root partitions (and upper-level VTL code) don't honor
> NEED_RESCHED_LAZY, and then deduplicate the TIF related MSHV code by turning
> the "kvm" entry APIs into more generic "virt" APIs.
> 
> This version is based on
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git hyperv-next
> 
> in order to pickup the VTL changes that are queued for 6.18.  I also
> squashed the NEED_RESCHED_LAZY fixes for root and VTL modes into a single
> patch, as it should be easy/straightforward to drop the VTL change as needed
> if we want this in 6.17 or earlier.
> 
> That effectively means the full series is dependent on the VTL changes being
> fully merged for 6.18.  But I think that's ok as it's really only the MSHV
> changes that have any urgency whatsoever, and I assume that Microsoft is
> the only user that truly cares about the MSHV root fix.  I.e. if the whole
> thing gets delayed, I think it's only the Hyper-V folks that are impacted.
> 
> I have no preference what tree this goes through, or when, and can respin
> and/or split as needed.
> 
> As with v1, the Hyper-V stuff and non-x86 architectures are compile-tested
> only.
> 
> v2:
>  - Rebase on hyperv-next.
>  - Fix and converge the VTL code as well. [Peter, Nuno]
> 
> v1: https://lore.kernel.org/all/20250825200622.3759571-1-seanjc@google.com
> 

I dropped the mshv_vtl changes in this series and applied the rest
(including the KVM changes) to hyperv-next.

Thanks,
Wei


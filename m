Return-Path: <kvm+bounces-33573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 256559EE3F7
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 11:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AE5C1889149
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 10:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2502101A8;
	Thu, 12 Dec 2024 10:20:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C27D20E02C
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 10:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733998805; cv=none; b=uL23LImPgy9Gf9dyumhLN1ddVYt90z+wXGNEahrkFz1O0EJ6lj92DEw+3SfkHJRJVBr+u/mO+Az7Lvj9WgN4oWc16qf67/oAlKr5xxk1kMqVE7XXokqD9UL5O/ADbFgLI1GocdSTB8jVXxITbc5J8bae30Itll/N0DoyB46Twl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733998805; c=relaxed/simple;
	bh=k3Rz4LCRhOnkzmWbmq98VHxoPAPLx1Is1t6Es6icUXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lh9x6zq/prRXyCEpLsBTHspr5yliII+pmNRsKgWCuqtZ1lLXuzbG80vkhSmPP2Ga0x9hQAzAF2pEK5eMVfo88W30t44QzLvoxhM8l3mADwskqqheFH46rQ05zSaWw7OxYE7q6BqaxaGkUaRTXkSk3b1ThFPLKV4FLXVfkZZjKEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=pass smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1tLgIJ-007aKf-1U;
	Thu, 12 Dec 2024 11:19:43 +0100
Date: Thu, 12 Dec 2024 11:19:43 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Sean Christopherson <seanjc@google.com>
Cc: Bernhard Kauer <bk@alpico.io>, kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: Drop the kvm_has_noapic_vcpu optimization
Message-ID: <Z1q4vxmEmZbkOiqC@mias.mediconcil.de>
References: <20241021102321.665060-1-bk@alpico.io>
 <Z1eXyv2VVsFiw_0i@google.com>
 <Z1ecILHBlpkiAThl@google.com>
 <Z1f45XzpgDMC2cvI@mias.mediconcil.de>
 <Z1nI22dBe01m3_k6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1nI22dBe01m3_k6@google.com>

On Wed, Dec 11, 2024 at 09:16:11AM -0800, Sean Christopherson wrote:
> On Tue, Dec 10, 2024, Bernhard Kauer wrote:
> > On Mon, Dec 09, 2024 at 05:40:48PM -0800, Sean Christopherson wrote:
> > > > With a single vCPU pinned to a single pCPU, the average latency for a CPUID exit
> > > > goes from 1018 => 1027 cycles, plus or minus a few.  With 8 vCPUs, no pinning
> > > > (mostly laziness), the average latency goes from 1034 => 1053.
> > 
> > Are these kind of benchmarks tracked somewhere automatically?
> 
> I'm not sure what you're asking.  The benchmark is KVM-Unit-Test's[*] CPUID test,
> e.g. "./x86/run x86/vmexit.flat -smp 1 -append 'cpuid'".

There are various issues with these benchmarks.

1. The absolute numbers depend on the particular CPU. My results
   can't be compared to your absolute results.

2. They have a 1% accuracy when warming up and pinning to a CPU.
   Thus one has to do multiple runs.

      1 cpuid 1087
      1 cpuid 1092
      5 cpuid 1093
      4 cpuid 1094
      3 cpuid 1095
     11 cpuid 1096
      8 cpuid 1097
     24 cpuid 1098
     11 cpuid 1099
     17 cpuid 1100
      8 cpuid 1101
      1 cpuid 1102
      4 cpuid 1103
      1 cpuid 1104
      1 cpuid 1110

3. Dynamic Frequency scaling makes it even more inaccurate.  A previously idle
   CPU can be as low as 1072 cycles and without pinning even 1050 cycles. 
   This 2.4% and 4.6% faster than the 1098 median.

4. Patches that seem not to be worth checking for or where the impact is
   smaller than measurement uncertainties might make the system slowly
   slower.


Most of this goes away if a dedicated machine tracks performance numbers
continously.


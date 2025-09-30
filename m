Return-Path: <kvm+bounces-59192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05099BAE126
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E81A1944B21
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2418024290D;
	Tue, 30 Sep 2025 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S0K3mXIT"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDA1224245
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250357; cv=none; b=BNF0TKF1ud0j+l2wPhjk1FNouxa7LjE8WUioaTklEbhNKn2s2lQYtBoXTcukja5rYLEuLHVO8UFARw3X6DyiVZfsCYFksiEElIMmpuoBXtoxc8xp0ZLL2M7m2gXXau3JXr/lyIyO3QhL3tXz7iDoXdkauqRUqtWGg3E3PCq8UbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250357; c=relaxed/simple;
	bh=K/OW5QVJiYUdeHnfxTsx43OwQg//BxaPlBCvPJ8I494=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGgN81lcZ1ulbmythbGGGfAdf4eG45TVCaCY+IR5+xdsulc7blHEScVvGHrfyg8O8+R/9j1LgqcYVMXcox/ToFn1N/0zi2ZWCHgZEKVDSeX1XR5in+vFMIdsYVnQuKznI1l6l5iAbVAZqO8pZcmKFiU9HVV4gViqMpT8dcvq3XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S0K3mXIT; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 30 Sep 2025 16:38:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759250342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B3CKhHSKM3GAHgQOBi5L/lbF/hi6x7IpHKwCLnAX/hw=;
	b=S0K3mXITYdBzco4OPx4s4kDHufQW7Dk1ZDHiLzDl8uf2PmJOi5N6RYV70/g2vltuhqShCW
	Uq5wmuYVFEmvtPQe2aLA/gbBMHqPHwFp82r4XI3ZHS+mdWOIOv+pw9Dv+fJWTAe1FYlpey
	aZms9l3QNdGWgxU67Tz/+F0U19FlsAQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sohil Mehta <sohil.mehta@intel.com>, "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Advertise EferLmsleUnsupported to userspace
Message-ID: <qglalt6crrqevdpvsp25tlo3onmcuhyneft2cptwxzebj7ych5@dmk2xhsjvlgl>
References: <20250925202937.2734175-1-jmattson@google.com>
 <byqww7zx55qgtbauqmrqzyz4vwcwojhxguqskv4oezmish6vub@iwe62secbobm>
 <CALMp9eRvf54jCrmWXH_WDZwB7KJcM3DLtPubvDibAUKj7-=yyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eRvf54jCrmWXH_WDZwB7KJcM3DLtPubvDibAUKj7-=yyg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 30, 2025 at 09:02:46AM -0700, Jim Mattson wrote:
> On Tue, Sep 30, 2025 at 8:31 AM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> >
> > On Thu, Sep 25, 2025 at 01:29:18PM -0700, Jim Mattson wrote:
> > > CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20] is a defeature
> > > bit. When this bit is clear, EFER.LMSLE is supported. When this bit is
> > > set, EFER.LMLSE is unsupported. KVM has never supported EFER.LMSLE, so
> > > it cannot support a 0-setting of this bit.
> > >
> > > Set the bit in KVM_GET_SUPPORTED_CPUID to advertise the unavailability
> > > of EFER.LMSLE to userspace.
> >
> > It seems like KVM allows setting EFER.LMSLE when nested SVM is enabled:
> > https://elixir.bootlin.com/linux/v6.17/source/arch/x86/kvm/svm/svm.c#L5354
> >
> > It goes back to commit eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be
> > set with nested svm"), the commit log says it was needed for the SLES11
> > version of Xen 4.0 to boot with nested SVM. Maybe that's no longer the
> > case.
> >
> > Should KVM advertise EferLmsleUnsupported if it allows setting
> > EFER.LMSLE in some cases?
> 
> I don't think KVM should allow setting the bit if it's not going to
> actually implement long mode segment limits. That seems like a
> security issue. The L1 hypervisor thinks that the L2 guest will not be
> able to access memory above the segment limit, but if there are no
> segment limit checks, then L2 will be able to access that memory.

Yeah this sounds bad.

On HW that supports EFER.LMSLE we're mostly virtualizing it, but not
entirely.

On HW that doesn't support it, we're not advertising
EferLmsleUnsupported and we allow the guest to set EFER.LMSLE, so the
VMRUN will fail with the invalid EFER (or immediate #VMexit?), and the
VM will crash.

> 
> It should be possible for KVM to implement long mode segment limits on
> hardware that supports the feature, but offering the feature on
> hardware that doesn't support it is infeasible.

I am not sure what we can and cannot do in terms of backward
compatibility. Ideally we'd stop allowing EFER.LMSLE completely, but
maybe we cannot break old users like that on HW that supports
EFER.LMSLE.

> 
> Do we really want to implement long mode segment limits in KVM, given
> that modern CPUs don't support the feature?

Probably not, and it causes crashes today anyway so I don't think anyone
depends on it.


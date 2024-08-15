Return-Path: <kvm+bounces-24291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 580A895375E
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8988C1C245E0
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B971F1B9B58;
	Thu, 15 Aug 2024 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CmgqOmJP";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1KmzIFai"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795BC1B3739;
	Thu, 15 Aug 2024 15:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723736054; cv=none; b=U1GwBKkhLPySihhgRtLqroz43KnXEthRPK4FQ6hVl4s+zAYt/fGWICd1D/LtpzDLihb1eHsb3cQVgUeQhAuJJJshm8vysMms1m8wv637kGubmM7OYhlWiRVM/EbMNnTJr+gdTP2J8R61QW9Vbi6E3TER9sXpeis/ye1y5RkDmWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723736054; c=relaxed/simple;
	bh=43bVPuZyOnLGe42cYp7OOkOZfbglB1bik6tRdeNS+yY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=r5UCeBgWQR5ae2hro/QEhNV5Pkjq+04ukHHQ/iq24M0hJD1afzwdn3s9fKyPrmwa7+C9FSr4yO7TDiFeER9HIAqE7IZf7HNqM4IP+N1UsMczY5GHg14i9g3UQFxeYVCL6/xSoTKo3j8NWFxmWIJocWalaZ2MCTLz5lGlNPAM9qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CmgqOmJP; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1KmzIFai; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723736051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bFCC+n03Hh7o5d7QnJPx32st3+SECAs+nlR5Jgdd/8k=;
	b=CmgqOmJPPfPKNWQLoDHnQoyaDO22Ikplh1HRJ8vS9/wl4VWVSIPr0oPCbczyBsKsB4wbJo
	coiuwGn1TVKxcoz1+/12WiQcQRUSG5VQ7+UQ+HGl1oGuNWhdqoeGvCcpNdFLfn7Zlw7Ryr
	7k3uHjgG4R5sj1spF8LdzuZPg69p5KJNwM6Ng0vM+4ppjVgChvCFsd89+a1xKhpC5FCxlU
	q1TmW/sIN3n5aeXdIHozVDqPh//lNkR+HPpVPXdzpqoPWQ6DfTaMkC57iI00ngL+8rlGPF
	HdgueoaZ5Z4As510N6+5m1oEK5nwSKfTNjSzJvyuil9rGYcDsNCSxiamKAGaBw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723736051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bFCC+n03Hh7o5d7QnJPx32st3+SECAs+nlR5Jgdd/8k=;
	b=1KmzIFainOz36kgrDRrA5u4iOZcds1Je6RtVvXuDOynu+vKvxwENGF0GJ/5qDJN3UIDEl9
	JTwFyxjgKW46wkCQ==
To: Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Xiaoyao Li
 <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, Jim Mattson
 <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li
 <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v8 01/10] x86/cpu: KVM: Add common defines for
 architectural memory types (PAT, MTRRs, etc.)
In-Reply-To: <20240605231918.2915961-2-seanjc@google.com>
References: <20240605231918.2915961-1-seanjc@google.com>
 <20240605231918.2915961-2-seanjc@google.com>
Date: Thu, 15 Aug 2024 17:34:11 +0200
Message-ID: <87bk1tn6ks.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Jun 05 2024 at 16:19, Sean Christopherson wrote:

> Add defines for the architectural memory types that can be shoved into
> various MSRs and registers, e.g. MTRRs, PAT, VMX capabilities MSRs, EPTPs,
> etc.  While most MSRs/registers support only a subset of all memory types,
> the values themselves are architectural and identical across all users.
>
> Leave the goofy MTRR_TYPE_* definitions as-is since they are in a uapi
> header, but add compile-time assertions to connect the dots (and sanity
> check that the msr-index.h values didn't get fat-fingered).
>
> Keep the VMX_EPTP_MT_* defines so that it's slightly more obvious that the
> EPTP holds a single memory type in 3 of its 64 bits; those bits just
> happen to be 2:0, i.e. don't need to be shifted.
>
> Opportunistically use X86_MEMTYPE_WB instead of an open coded '6' in
> setup_vmcs_config().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>


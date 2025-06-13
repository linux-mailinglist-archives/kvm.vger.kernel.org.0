Return-Path: <kvm+bounces-49421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B700AD8F36
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AB421E6FC0
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D2C2BF079;
	Fri, 13 Jun 2025 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eLSN0g7I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55B02BF065
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 14:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749823861; cv=none; b=DGNmlDVvbJ7siWuKcMAP2toaZOejv6QzHXVbihPhfAQfsomrRuTtl+zRIDJ/c1sS4GP+hrX+hYnHyQuTPqMpGbFarHQgAQdv/yvBFqkz/k2O2/Y8DlN5QKpo4PXTNvaXRGF82pTFPg2ABkIHN1yJhFE7sx045TK0a2ukLpLRs/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749823861; c=relaxed/simple;
	bh=KsMsyRZXElvuHkJ96w1G569AzFpOqniYxrD/MRoCgA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RIGMlXQsbcf+Kdw0f1zHTRIqz5rznaR801RPgFNq0bkGxa7rD0WFDI5ncIaNea7JyqsPswyfQztCcgbuGv3ETjRu4f2/JDu8wNEAguyvA/fMQ+0hgz2fMSLlBTrdx89hL5ZMz1Lmd7jUH5V0RB1VJqGDyJxu01rpo264bZ1/xSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eLSN0g7I; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e33ae9d5so2299944a12.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 07:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749823859; x=1750428659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KFKxciq4Ln4zlYp2JiFF7Swu6ECCNV/1MfY2qSFQNn4=;
        b=eLSN0g7IgA3pRVM4dOdej9OHNVsITq1iUTAM3EFnSvc9xnx9nrag9ftxSAe9POLEiU
         ypr75AuFPYgNLHLSYJil1vckV1UXQgf83EB7z2Xmq1FT8Zg02D3UZRgr1HE6bTN1y84I
         ZJAi1g7TTRg/HyfM6TlKgzuaRTNt6JvStpNPHoI+L7jpdwOwAAlr4eZGMdx8690ZXUig
         kmsUhY8G30wghnAAa++QPJQtCXvx8DMG5yN1m63y6FI3bn+1sjndO+6yZQUmd6+W81l8
         ls5+9ODcvpBMUL4qQvlsHfjspi+5PE7fpqog6xKePI2yFCqI+c6XqhiuRvnUaKTD9btd
         c7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749823859; x=1750428659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KFKxciq4Ln4zlYp2JiFF7Swu6ECCNV/1MfY2qSFQNn4=;
        b=d7QTPd0BFUVzmP7CDDMk/jo6prYyGeSDCRSihT89DMMh8zwrMPYR8izFabJVbKzP9S
         lAiIZsuKHwASw0HgVRcUy8tcCsDZqfBcBhunXQ6eD0SVMpes4YxZzRnit341kutFPGAc
         DizlqZAnyass3Bs2aXbDJNM5SDcyp9D+rS0Qb0CE9MM5YoITsYOwKHwrAuPSjtDDyS9U
         V/Dny/DP6dib6n7/M51yamEyGYNtrA1Dj4Clb7Y1N3OEeG6s0AulHRpozOgUIRDaSEQ7
         eHu6TEmDBwo+/o+fXgAlmrWRDuTpBcfAPkkWvzgjjNurRKaK3tAf2lDyoEbPFK+3UmTq
         STfA==
X-Forwarded-Encrypted: i=1; AJvYcCXku4qbiEq/Qyj6J0edCl2LjB0QpHYTpQ6GPfVtxumEwoxWlmKePA3EbaWjAsNITtrntuI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqRCRvhd1JKax25fHRHC/Q6GjELdMw+avHc6CRtJPuxaCP5Y5R
	Btva4rw5fVTFBfkmKU/DDRdsFq9saV8LgjduJ+XZoQi15ERR2Pbpq94opz7bqchGWrEj7/McAW4
	6KxQa5A==
X-Google-Smtp-Source: AGHT+IFN3c4N91I5ZhjfG8LYZwpTxT5er4jDbXzzE1DZU2whHqoP1gUgS61lLn6FCV62f4VbZN+4TFLFz4w=
X-Received: from pgam16.prod.google.com ([2002:a05:6a02:2b50:b0:b2e:c0d6:cbd3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a127:b0:21f:5b6f:36d5
 with SMTP id adf61e73a8af0-21facb26d8bmr4729208637.10.1749823859107; Fri, 13
 Jun 2025 07:10:59 -0700 (PDT)
Date: Fri, 13 Jun 2025 07:10:57 -0700
In-Reply-To: <20250613071536.GG2273038@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613070118.3694407-1-xin@zytor.com> <20250613070118.3694407-3-xin@zytor.com>
 <20250613071536.GG2273038@noisy.programming.kicks-ass.net>
Message-ID: <aEwxcVzQubz3BmmJ@google.com>
Subject: Re: [PATCH v1 2/3] x86/traps: Initialize DR7 by writing its
 architectural reset value
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, brgerst@gmail.com, tony.luck@intel.com, 
	fenghuay@nvidia.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 13, 2025, Peter Zijlstra wrote:
> On Fri, Jun 13, 2025 at 12:01:16AM -0700, Xin Li (Intel) wrote:
> 
> > While at it, replace the hardcoded debug register number 7 with the
> > existing DR_CONTROL macro for clarity.
> 
> Yeah, not really a fan of that... IMO that obfuscates the code more than
> it helps, consider:

+1, and NAK to the KVM changes.  Pretty much everything in KVM deals with the
"raw" names.  The use of dr6 and dr7 is pervasive throughout the VMX and SVM
architectures:

 vmcs.GUEST_DR7
 vmcb.save.dr6
 vmcb.save.dr7

And is cemented in KVM's uAPI:

 kvm_debug_exit_arch.dr6
 kvm_debug_exit_arch.dr7
 kvm_debugregs.dr6
 kvm_debugregs.dr7

Using DR_STATUS and DR_CONTROL is not an improvement when everything else is using
'6' and '7'.  E.g. I skipped the changelog and was very confused by the '6' =>
DR_STATUS change in the next patch.

And don't even think about renaming the prefixes on these :-)

#define DR6_BUS_LOCK   (1 << 11)
#define DR6_BD		(1 << 13)
#define DR6_BS		(1 << 14)
#define DR6_BT		(1 << 15)
#define DR6_RTM		(1 << 16)
/*
 * DR6_ACTIVE_LOW combines fixed-1 and active-low bits.
 * We can regard all the bits in DR6_FIXED_1 as active_low bits;
 * they will never be 0 for now, but when they are defined
 * in the future it will require no code change.
 *
 * DR6_ACTIVE_LOW is also used as the init/reset value for DR6.
 */
#define DR6_ACTIVE_LOW	0xffff0ff0
#define DR6_VOLATILE	0x0001e80f
#define DR6_FIXED_1	(DR6_ACTIVE_LOW & ~DR6_VOLATILE)

#define DR7_BP_EN_MASK	0x000000ff
#define DR7_GE		(1 << 9)
#define DR7_GD		(1 << 13)
#define DR7_FIXED_1	0x00000400
#define DR7_VOLATILE	0xffff2bff


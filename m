Return-Path: <kvm+bounces-49935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B14BADFCC5
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 07:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDAB417B41D
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 05:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CBD24167B;
	Thu, 19 Jun 2025 05:16:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE88634;
	Thu, 19 Jun 2025 05:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750310191; cv=none; b=p3DBgkxoJSgeDpexPouw3Qg5E8nTZjnYWnyNB6wrHfNTTCo8++K/7fX7YXTf4faR/HNr+ALmsiZWdB34CAvAESmYi68TxhEz7vdyw+mLcdsJh/b0TfRNPAB0CX7nnWHO2JJ/h/3PaqKthR+7SqW3Zzy07y33GWU4nSTFPFPcnYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750310191; c=relaxed/simple;
	bh=dtFmcYi1DdN6XoNVHxvk4UIwsnwnzxpivxlVkb9bDTI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Td9aOeLcsOkrcfaDkf8RgAwpVqEVbNyarDf/ZiuUGztfYeAY3VAwVrOzhinTdgnCVf+sAtba9nBF+2LA7A1vDTV/Qgdc+we+3iJEt/jTe2I13fim2Bn61bjNtG5llvLZZDIMENyP8qdskPuNsl05oG/Fp0+Zph7DPrsWekzs95I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 24AE992009C; Thu, 19 Jun 2025 07:16:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 1537592009B;
	Thu, 19 Jun 2025 06:16:22 +0100 (BST)
Date: Thu, 19 Jun 2025 06:16:22 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Sean Christopherson <seanjc@google.com>
cc: Sohil Mehta <sohil.mehta@intel.com>, "Xin Li (Intel)" <xin@zytor.com>, 
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de, 
    Ingo Molnar <mingo@redhat.com>, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, peterz@infradead.org, 
    brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
Subject: Re: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
In-Reply-To: <aFHUZh6koJyVi3p-@google.com>
Message-ID: <alpine.DEB.2.21.2506190607470.37405@angie.orcam.me.uk>
References: <20250617073234.1020644-1-xin@zytor.com> <20250617073234.1020644-2-xin@zytor.com> <fa32b6e9-b087-495a-acf1-a28cfed7e28a@intel.com> <aFHUZh6koJyVi3p-@google.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 17 Jun 2025, Sean Christopherson wrote:

> Yeah, the name is weird, but IMO DR6_INIT or DR6_RESET aren't great either.  I'm
> admittedly very biased, but I think KVM's DR6_ACTIVE_LOW better captures the
> behavior of the bits.  E.g. even if bits that are currently reserved become defined
> in the future, they'll still need to be active low so as to be backwards compatible
> with existing software.

 FWIW I'd call this macro DR6_DEFAULT, to keep it simple and explicitly 
express our intent here (we want to set our default after all).

 I think reusing DR6_ACTIVE_LOW could be risky, regardless of its KVM use, 
because there's no guarantee the semantics of a future architectural 
addition will match the name, i.e. the value of 0 may actually *disable* 
what we currently have always enabled and while technically this could 
count as "feature active", this double-negation might just make one's head 
spin unnecessarily.  Plus we may actually want to have that stuff disabled 
by default then.

  Maciej


Return-Path: <kvm+bounces-58132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5234EB889D5
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 11:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF7E83AD7E0
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2882FF643;
	Fri, 19 Sep 2025 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJV6Kf0k"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469B92F25EF;
	Fri, 19 Sep 2025 09:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758274768; cv=none; b=PazOO4uVMxSYF3PELBs5mFGtGKpJq3dOQOYH3gugS7Sg4qGnfpdjysbBnH+IoQO3iNXfn6fp/j1OfcGDf878bAXBBFGJ8b9WEcn3QxZdOQe2E66vw530Bca6/nzoHjKJp3Lw8i2k2yDAyTOTk+Jm/g1KqE1yTrbijrXIn+zTvpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758274768; c=relaxed/simple;
	bh=KwLzMQLT7wi5XfbeBsM5cIPpIimjD49D5PPQYk+Dueg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O5crTvxiYSWDmfEwrRh1qe9uMB4vWqBItbzuHn3lDBU85YRMqMQppzJU0X6DRqqo8/AHNrIm//d0mSPNs0db0bZkHFhgfYZ2gm2aPemnfEfi/Zjo3af18L35CueGPVPsYvSSySVfjJ8BSYXLKwBA8NNjIzO3QzOOZliYV/AG6+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJV6Kf0k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467B1C4CEF0;
	Fri, 19 Sep 2025 09:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758274767;
	bh=KwLzMQLT7wi5XfbeBsM5cIPpIimjD49D5PPQYk+Dueg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lJV6Kf0kzv3UBOQN4+VkMEWTvgavXdln5W95vWAHRfbyIkw9VADK5+96/AKqHzlkp
	 fp3qOPgmwTAbNt/TqKZmZh9mXwpjNy/XhVyHEepfBeT52ATo6MMYyGfz2RYA2bFWeU
	 tqPbpBknmkn0+1Zxa3WqMqYr7LfsuV9i6khbM+VK2fl710gtg/d+Bbne+NfYeVxNat
	 vk5u9qvyJIoPtPozTQ8PqDtktVcMJl98ge9W0wK6mEWFiazNUsoDJLK64TTz3Qx7O6
	 ginM0xPHQf4ggG3hpMQnzYEdTRrNoTEsZ0yTajev2QhRobHrKxyYEUaoPwf3FTXTtb
	 XfzCR5X+HTzZw==
Date: Fri, 19 Sep 2025 15:05:08 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] KVM: SVM: Move x2AVIC MSR interception helper to
 avic.c
Message-ID: <34dkuvu3s47ypxivxaqeyxdvgia6npjiw7b43mkvciqmngra4h@5hl5y7fzcyv5>
References: <20250919002136.1349663-1-seanjc@google.com>
 <20250919002136.1349663-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919002136.1349663-2-seanjc@google.com>

On Thu, Sep 18, 2025 at 05:21:31PM -0700, Sean Christopherson wrote:
> Move svm_set_x2apic_msr_interception() to avic.c as it's only relevant
> when x2AVIC is enabled/supported and only called by AVIC code.  In
> addition to scoping AVIC code to avic.c, this will allow burying the
> global x2avic_enabled variable in avic.
> 
> Opportunistically rename the helper to explicitly scope it to "avic".
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 57 ++++++++++++++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm.c  | 49 -----------------------------------
>  arch/x86/kvm/svm/svm.h  |  1 -
>  3 files changed, 54 insertions(+), 53 deletions(-)

Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen



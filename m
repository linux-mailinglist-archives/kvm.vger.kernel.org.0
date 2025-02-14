Return-Path: <kvm+bounces-38193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0BBA366AE
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 21:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 751AA3B178F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 20:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6CD1C84C5;
	Fri, 14 Feb 2025 20:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ZUTNJpsH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD6D1519AB;
	Fri, 14 Feb 2025 20:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739563830; cv=none; b=XlXDkyAStXGq2S7CGm57t8o5biWtK/HZIz3VHxOnZY4vZFPZ7U5ExeO/uOwfL9YHRqydijK7tCmIc+E2c4tZXa+2qGPYywRsTKanMdIo3rviM7yC8NZ185Sl3REYKGNw+h9FtLAouqHuv+QaG6NeaxAR9QMvjhlUvLvt82a3Afo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739563830; c=relaxed/simple;
	bh=9bkdPbfYP8qkO/O8V7qdFgXNOyCEhYUIkoDTs1E8mjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pj6/pQMExMAiLczVlbVwXXdpTiGklBO0fECaRxc6IAN7KUJY4garoB3eFXhSDV1AZ2e6EE0Hk9IS9by0lC2DvXrfXn0VFmznKhREXTBSbq6LKo6OV3opsAAQ6ANPCh+iLy8DYlbrE+C63TN2QqP4u13AjWiHbxORadAjmp9tf98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ZUTNJpsH; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6CF5340E0176;
	Fri, 14 Feb 2025 20:10:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id v7e3ERKG7aYb; Fri, 14 Feb 2025 20:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739563822; bh=Jvpzn5pW1ksEmaE2Dx5X88B2qb28vkHA3CBjRxRYaK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZUTNJpsHT6BVJ6vbMrlVAg5emvws4fwnXF2wKHuxi7xRKfSJ52SMxZ9g736416VOW
	 M1vyUATAkTlMOCNXucq1iLi0Mlv8/CVkunuklGmX1A2Rg9rsDYWA69egeji2SP8ceF
	 qnBOwBMeV52DMY1lFAWhOVW0+Eq3GJs4g/8qvj5MFdCU1c5gNYDBI/U/fbSqcUPnRH
	 bXb9iiXVofynVAr3Y1q5ggjEBlFFYJn0eXbpRVu1Brk3WXiOC16KvhEZK+b+9eZ8dv
	 bFH1td7cdyOT0ZWmhjKGdLMTPcC1/lsjrD91NtkWcCQaYU/u8KQMhrxuLfligqrgXy
	 nS+7wh694h+ejB+mbbD1ibMjxjmIkPBIfTM8WsmTt7zmyoxoHUi/wvzOQPJVK/WEGt
	 7BdDT89Go4N1AcXr2HWde3YU2lU2umSkh/VbAGPh3MQxsN6zfESpjN3y6WKa0qw8LP
	 t4tPbGL3dhzBsC2B2QzRGNeDbG62t9B9YBV15nhUT9G+hflTAcG5Rt8qwHeL8IJHdv
	 gkWI6dINWdi0jSI8YrwJgjvH6C4wn78Tsfpy9RXnZzq7GO1PPj2VSEMtABog5fbB5G
	 Dkgw5OhyuOC2K4E78a9FgsRIL4Pjr1btG3qVerCuoUnMUkCFXWazJ1ETd6FFHa+PZo
	 O6FCaFUYjJeHZxZ1kyArl+k8=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 79CAD40E00C9;
	Fri, 14 Feb 2025 20:10:11 +0000 (UTC)
Date: Fri, 14 Feb 2025 21:10:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Patrick Bellasi <derkling@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250213175057.3108031-1-derkling@google.com>

On Thu, Feb 13, 2025 at 05:50:57PM +0000, Patrick Bellasi wrote:
> The "should be set identically across all processors in the system" makes me
> wondering if using the "KVM's user_return approach" proposed here is robust
> enough. Could this not lead to the bit being possibly set only on some CPU
> but not others?

That's fine, we should update that paper.

> If BpSpecReduce does not prevent training, but only the training from being
> used, should not we keep it consistently set after a guest has run, or until an
> IBPB is executed?

After talking with folks internally, you're probably right. We should slap an
IBPB before clearing. Which means, I cannot use the MSR return slots anymore.
I will have to resurrect some of the other solutions we had lined up...

Stay tuned.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette


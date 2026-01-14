Return-Path: <kvm+bounces-68061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3046FD2093D
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 18:37:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 485D73052224
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 17:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC99302767;
	Wed, 14 Jan 2026 17:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpL6kfB8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD122C3271;
	Wed, 14 Jan 2026 17:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768412082; cv=none; b=WearmnjvxE0NLP2hlM+uTciAQ9hjb0/UJbLZ88nOssb6UPo07X7soYStPy7dAJNG9O+w8RXsW0if9pZWQoFpxxwSX6qyNcqyrVjXHlJDugfEfbf3/39NUQtX9fXRCiepBGM6DXlVr56GgUg9T7gH6Y9D16XhmQ1FB3lbF6CrU5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768412082; c=relaxed/simple;
	bh=wZaVmMPAsFC5ffkftcAz4ns4rT76VinzRRIB6qdQ8tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9H6O+xfGZQimiWUBW91xiH6oIOeivSqtX3ROzCKB0mzf8ZeL5rwrvGQPxTWAEpRJwP+TdKnvoCuCqe8KzXiaUo9u7SZ6yeMg1DpfLVYzTIYbHlEXfsE3wF+AXVtksAiP0gf54AF/jniw7WmwXwKTi2waM8Jly5bcf6NqKrK5/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpL6kfB8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB8AC4CEF7;
	Wed, 14 Jan 2026 17:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768412082;
	bh=wZaVmMPAsFC5ffkftcAz4ns4rT76VinzRRIB6qdQ8tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TpL6kfB8e4RCVuULBl8Z6zYlPTnztEi2BW5xcj8DgPHyG+4yWOOfh7p9GbTT4fVPU
	 oFWATbE20FKfuFzdvVAKqIMVoM+T9HzD22F01TCQPiyIBteUe0fIs3UrVzY8T6FGEi
	 YWcyb/2whiC9MNMhqkmL+pki7wIQlxTkjxCDxWMBtoOz8DQN2UQBj8NqU/K7YNvUp7
	 vW0NyPRTxPsuXgAipqDVzqr+uZ7bqmckiD/JEf1rhjzxTMRyprYGTAbxuJjSGwiu70
	 CLOuKKzBmi7Qwi0Y8wNTBvDZAyVecwd7wQ3fbjK0+VOEvKFOkdo6vCtstsOYnRc/Yl
	 SPlPuWlBnD75Q==
Date: Wed, 14 Jan 2026 23:05:54 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH] KVM: SVM: Check vCPU ID against max x2AVIC ID if and
 only if x2AVIC is enabled
Message-ID: <aWfOY7v3T_SRdHMp@blrnaveerao1>
References: <20260112232805.1512361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112232805.1512361-1-seanjc@google.com>

On Mon, Jan 12, 2026 at 03:28:05PM -0800, Sean Christopherson wrote:
> When allocating the AVIC backing page, only check one of the max AVIC vs.
> x2AVIC ID based on whether or not x2AVIC is enabled.  Doing so fixes a bug
> where KVM incorrectly inhibits AVIC if x2AVIC is _disabled_ and any vCPU
> with a non-zero APIC ID is created, as x2avic_max_physical_id is left '0'
> when x2AVIC is disabled.
> 
> Fixes: 940fc47cfb0d ("KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode")
> Cc: stable@vger.kernel.org
> Cc: Naveen N Rao (AMD) <naveen@kernel.org>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

I think the bad commit is:
f628a34a9d52 ("KVM: SVM: Replace "avic_mode" enum with "x2avic_enabled" boolean")

... which introduced x2avic_enabled.

Other than that:
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>


Thanks,
Naveen



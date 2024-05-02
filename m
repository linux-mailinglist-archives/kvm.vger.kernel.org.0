Return-Path: <kvm+bounces-16423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1786C8B9EE1
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 18:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6A6D281AC7
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 16:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006DE16D4C9;
	Thu,  2 May 2024 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BvG9lA4H"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427661EA6F
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714668645; cv=none; b=XLvbbOXQt2sP3CLQeWbWcjpQYy3STdNp6J3nMgqEWCGhqvYtgeqRKYeT3O4S0fnyeFoaLl3f2TGGbScJ3PA/c6RR6ENqP0QZNdwhxnkVd3cxW5WF1C0h+utszxbyxlLL3cjDSa2io7rCiZPJXX9rl1xBlBO5iI0GH8JcRpxan/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714668645; c=relaxed/simple;
	bh=KOsbzfYBhi43BT3vLFyzL7+KSxDzFfPT7d/apWLfF4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAAsXoSVHO6mJvW+/cxWgZzf72f0Fva9/u1g9rTJHcYeRKKTydseEib90/C8nU6I/qcLLl7YZZrRjXtY4V3ZdfRXgxf5Oy/qMbqXzPaYZUu9C13UWVGEegtC8RDurD1uM38ulAgs5I1PG5Olvl5kxG65G3uVE8i3TqEQF1ogafI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BvG9lA4H; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 2 May 2024 09:50:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714668640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hpWKZwA6w6835XfJyp6UfuhrR8rSmcgdYf8EdTGLeNg=;
	b=BvG9lA4HVdECQeHpOpwA4LdgmpttMCCCpaxWuj4MU5PyRhJ8bhYMHiaDPH4q49R9IJ65C2
	tpTyvXvGO2vSsDCWoZNQeehpNllwQBBBK+LYKPg3VeaK34agor/o4/i759vUfkyfNWkfVK
	Lw4r449xMSGTeOVGNbjpFfK+/+fqWto=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH] KVM: arm64: Move management of __hyp_running_vcpu to
 load/put on VHE
Message-ID: <ZjPEXPO0PNq4PQQ8@linux.dev>
References: <20240502154030.3011995-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502154030.3011995-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 04:40:30PM +0100, Marc Zyngier wrote:
> The per-CPU host context structure contains a __hyp_running_vcpu that
> serves as a replacement for kvm_get_current_vcpu() in contexts where
> we cannot make direct use of it (such as in the nVHE hypervisor).
> Since there is a lot of common code between nVHE and VHE, the latter
> also populates this field even if kvm_get_running_vcpu() always works.
> 
> We currently pretty inconsistent when populating __hyp_running_vcpu
> to point to the currently running vcpu:
> 
> - on {n,h}VHE, we set __hyp_running_vcpu on entry to __kvm_vcpu_run
>   and clear it on exit.
> 
> - on VHE, we set __hyp_running_vcpu on entry to __kvm_vcpu_run_vhe
>   and never clear it, effectively leaving a dangling pointer...
> 
> VHE is obviously the odd one here. Although we could make it behave
> just like nVHE, this wouldn't match the behaviour of KVM with VHE,
> where the load phase is where most of the context-switch gets done.
> 
> So move all the __hyp_running_vcpu management to the VHE-specific
> load/put phases, giving us a bit more sanity and matching the
> behaviour of kvm_get_running_vcpu().
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver


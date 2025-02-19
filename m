Return-Path: <kvm+bounces-38615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3566FA3CD4D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 00:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3C1D3A7D84
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 23:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824C1257457;
	Wed, 19 Feb 2025 23:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Oo+3Vg/G"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25E91CAA65
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 23:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740007166; cv=none; b=RO4y57pd1BmbTsT1fPjvLMBXNYuD7Vx7OR8Y1VNi0Ysuvsrd5+O49RszlWxSVClTC9cHxbc3+/I/ydgp/pVd10cxh1NQfNfvCMknoRoBgpXWIfnvEcPc0RZ0YiXuZnE2O/3NQG19wGeR+gcGeSE+zzfBvvBAgxe+f5ocHGcPqQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740007166; c=relaxed/simple;
	bh=SwVIv3Wq+khucr35x1I00QEauKzA1nGVYUlz47Jo98Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWwrbpmuN4WS3fwJKKED2aASm8rkuXxVFeN/0+B1/RvU7aHvV0aSH6X7mntPe5nqhRpaAGcY6FvSQqOJG0skkYorLsRPjtvYJE+wSDk+hXN7iNI2UBuM96BwyXgvsDKUIPl/GNoH3OSN4UGdhLP4GsUS90u+Ghi9Kw90cdx43fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Oo+3Vg/G; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 19 Feb 2025 15:19:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740007151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fETwu0L8tuv2gAhj94uky1reANW9J8SOc983NJCn42o=;
	b=Oo+3Vg/GkwMMP6P5U1rzYe+IcwpjTIyuFeGqIgKcvt0Ivu48GQwydujT3JBpRYxJN44xiq
	RpRLrC1JuWy2u6suu6NUAMjAAbLktGpYQTO1TsVY2F7C6rN02twpucUGoyS4yrN3shOtmz
	DKvOcQ7/VItsXMkwEVzyvQgrr7AmpfU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 13/14] KVM: arm64: Allow userspace to request
 KVM_ARM_VCPU_EL2*
Message-ID: <Z7Zm6ryZ126gMLZ2@linux.dev>
References: <20250215173816.3767330-1-maz@kernel.org>
 <20250215173816.3767330-14-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215173816.3767330-14-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 15, 2025 at 05:38:15PM +0000, Marc Zyngier wrote:
> Since we're (almost) feature complete, let's allow userspace to
> request KVM_ARM_VCPU_EL2* by bumping KVM_VCPU_MAX_FEATURES up.
> 
> We also now advertise the features to userspace with a new capabilities.
> 
> It's going to be great...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver


Return-Path: <kvm+bounces-15863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6AD8B1357
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 21:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 869982841AC
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 19:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D7B78C7D;
	Wed, 24 Apr 2024 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f2Ehzlp9"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A1C78297
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 19:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713986134; cv=none; b=h3LeorOFmd8sr/zOXmPIKxMthEaQ2ob6uHFBoFxt+Xx3PRkE4KDlWLlZgX8ps7tZzN0CSP8bYF+42OfvRCkcvrLcFcjyMDHv3MAxQl+vvAnYFV/JPMMoIFd3RS1IpwfLrFjdG+9pD7wFMwuf5Nroyvn5gJDp7OlFOh2mfv3tkKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713986134; c=relaxed/simple;
	bh=cbs4/GsRFbvvwAe9pesFouoUlPJUcj+w4760zN9rM0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmsK61DiaYT9osnAGu4kUWPZMXwEYSm0kxr0RNVB0L3Uf+aKo2wSyUX9wEgXQTuZcr8jDm+eOGEA5nO/89EqVKBxnHmhTuX32WC8K6ciKg+RrkVjBO3MkwTTJ65pCWIBCZJI/qfQQ2krwI0T+MMiJSf7zc/y9pVp+CO5stGIFxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f2Ehzlp9; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713986130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0j4vcSotV/ab5MF4MQ/aE+G24A8P8JLJufLFK3Fsk8U=;
	b=f2Ehzlp9Y3QKl29jh0E6wfi4deuDgFWgTeIEDJ75XR1NdVNOVALCuxQ0YE/UP6H5CsCV6i
	kCq59FQKWz2hLq1j7VcrV0KRotTjatBAl5b8k9GMBsYEoCPVAzBb5ZIZ1Nv/qwNe7U8uUn
	yXCfBYcx23bdV3tA2dIKTTsFBi79ZSE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	James Morse <james.morse@arm.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Avoid NULL dereference in vgic-v2 device attr accessors
Date: Wed, 24 Apr 2024 19:15:19 +0000
Message-ID: <171398579443.3801637.10801372488006477660.b4-ty@linux.dev>
In-Reply-To: <20240424173959.3776798-1-oliver.upton@linux.dev>
References: <20240424173959.3776798-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 24 Apr 2024 17:39:57 +0000, Oliver Upton wrote:
> Alex reports that it is possible to trigger a NULL dereference via the
> vgic-v2 device attribute accessors, stemming from a lack of sanitization
> of user input...
> 
> Here's a fix + regression test for the bug. Obviously, I intend to take
> these as a fix ASAP.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/2] KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
      https://git.kernel.org/kvmarm/kvmarm/c/6ddb4f372fc6
[2/2] KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF
      https://git.kernel.org/kvmarm/kvmarm/c/160933e330f4

--
Best,
Oliver


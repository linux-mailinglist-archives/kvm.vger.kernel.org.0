Return-Path: <kvm+bounces-54331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D20D5B1EE0C
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 19:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C05794E37A5
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 17:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC611E7C2D;
	Fri,  8 Aug 2025 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TjBv3uTP"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526E11E9B2D
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754675517; cv=none; b=ZLCZVMf4062UrH9HmT0/X4u65Y0xMqmeWf9/AoCm4h+bdPkwhl454HFUUalG1Fh1bRvhOt2jBIh/4fiZC5+LuxG3zPOw3kU3UoyIELlHAhHCkHMDHjs7B/DRoM5ZmEwr/8e1ZTLlozZZosyRj7PaWcUeIV4OhG9VgLvOpGreh+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754675517; c=relaxed/simple;
	bh=hxrjISdcMq/zhiwSZtMIXiWoTS8p4piOhKFH3YSYVqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D3aXmaa3X54IFPuCq1Mcnt/b2X/r4dQzfzAHv7KM10C3wAdWwtueiYFY1T9pdMfJbYY+5UKAG7LxFFlgNlvMdtMcVHMP+yQEfr/42/HYqQrQZeocwTMM9Tt9r5+lQXhTx1wb89EgBIWpiadyoJ7Q0jTuYW6cnYvBdz1ja3OBDjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TjBv3uTP; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754675513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uthDb2V9VnfDGIFco/8/5Vth9/1+6ayqM33H17ywDDw=;
	b=TjBv3uTPpnUUUk1BOXj2DLhhvAirakucf1WD1UeUTLhIZzcMCu5BrrLjQSiNCyZ48vzpYG
	AcTpsZu1YGa/k38Jxuet+m5Hqn/IhN5tAHbcarvWnCTsURVefdFTUfJ9EcW5oGyj5MVUTG
	hblrSi8R7bLZ0CuccLJ4J+pBnfFS2f8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Properly check ESR_EL2.VNCR on taking a VNCR_EL2 related fault
Date: Fri,  8 Aug 2025 10:51:33 -0700
Message-Id: <175467548051.670500.10792473108238657623.b4-ty@linux.dev>
In-Reply-To: <20250730101828.1168707-1-maz@kernel.org>
References: <20250730101828.1168707-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 30 Jul 2025 11:18:28 +0100, Marc Zyngier wrote:
> Instead of checking for the ESR_EL2.VNCR bit being set (the only case
> we should be here), we are actually testing random bits in ESR_EL2.DFSC.
> 
> 13 obviously being a lucky number, it matches both permission and
> translation fault status codes, which explains why we never saw it
> failing. This was found by inspection, while reviewing a vaguely
> related patch.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nv: Properly check ESR_EL2.VNCR on taking a VNCR_EL2 related fault
      https://git.kernel.org/kvmarm/kvmarm/c/07f557f60a9a

--
Best,
Oliver


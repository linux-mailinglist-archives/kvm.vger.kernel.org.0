Return-Path: <kvm+bounces-24813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88DE495B005
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 10:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBEE41C2271C
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 08:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8CF13C812;
	Thu, 22 Aug 2024 08:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jqxinqx+"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE372AD31
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 08:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724314571; cv=none; b=nRsbK0AHDkFBeFKnybxYzSpfAZMZFfPWylokkjeMq4HuGVlOiGBKDq+AZjusAVnHdLzyzqCxhdbcIuOaSyY8P2i7IXM8au1FatqEmrqVqfMPwoJC0fDvMteAWVaLrnrEI7rfGXH85/EWRfrDGoFk6v28UIkbl3l40TkJB5DMn2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724314571; c=relaxed/simple;
	bh=o5E46Xsb+BlTB2zC+u0hFLeCrAXDtPVQ6nr9N66H1+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VSidf7ZwdY2ZzQJcjiQdNAlsMauRsh7ReBGCnNfwxXE9Ujw3VkkO9yUBP6b+z+saOMgaViHqlAqDcEKWt94yOmP8yyDoUvmV5FJSsnDezQORpJiTrp/32LcipTz5alPu+eA+KucWLU6iqSgMXXyiNXtwnZk4vD5AshD97fV9mv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jqxinqx+; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724314567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1gK+Roe+VZc4bhdfUlpfcFVrYk93QsyMczdTtdp7Mk=;
	b=Jqxinqx+WqcC2agGavlOiXIaKq+HhJTYeGSdWbOftYI9H1NPTixbPV616iIKrC9edDoRMW
	P/nt4GfHbfBlZ8BP4icfPUX4eF+iMalCGTiZH5QWml/JDx+LmtNKVMBcMFrb4Ct9IrJFRV
	xL7X5ZaY8s2RG3q4MuhM/DHuKCvf67Q=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: (subset) [PATCH 01/12] KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
Date: Thu, 22 Aug 2024 08:15:55 +0000
Message-ID: <172431442241.2387551.1840120236670803060.b4-ty@linux.dev>
In-Reply-To: <20240820100349.3544850-2-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org> <20240820100349.3544850-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 20 Aug 2024 11:03:38 +0100, Marc Zyngier wrote:
> On a system with a GICv3, if a guest hasn't been configured with
> GICv3 and that the host is not capable of GICv2 emulation,
> a write to any of the ICC_*SGI*_EL1 registers is trapped to EL2.
> 
> We therefore try to emulate the SGI access, only to hit a NULL
> pointer as no private interrupt is allocated (no GIC, remember?).
> 
> [...]

Applied to kvmarm/fixes, thanks!

[01/12] KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
        https://git.kernel.org/kvmarm/kvmarm/c/3e6245ebe7ef

--
Best,
Oliver


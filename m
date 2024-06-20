Return-Path: <kvm+bounces-20146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE11E910F58
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A4C6284397
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565B31B5823;
	Thu, 20 Jun 2024 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bnk/m78c"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2061B5807
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718905185; cv=none; b=JeieW2OoNKRtX5nyq/89o6f5U4t7CLWkPup4vQ13nemw4sFmIIrmfVU6UqqYLQH2b+VQHaI1UIqcZeBSz7Zm7alCd5jIoNGYyx/YXj0vqDDXSjE08O55ogdKThsHCL1w0bgxLWNCbLJAzOMnBCa9CNwQDlda9Ijwl8ZLI9L1IFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718905185; c=relaxed/simple;
	bh=oMDPZXkOqyWUCpkLJroHMS8cDvMBn2+L37sdHRJkzsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FGgyDoRIg+fkfcn9fZ0XKT2l5xg6rAifs0G2QM4FU291Alo++Gg5uhu4hVw8I4GC/EtuxTVCN1BQO7ARcBAQc71zqW1zw7ECM7iLIS48+Qfw0rEgCJMo9+UcRZ6acw11oaw17PICbcG2c47YcVIJxvlc2p4YTgr9fHjlXPfXrws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bnk/m78c; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718905180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5k/mqyQHSNQbgC0Oj9mNxKhD7o2n/7C/7pyjSDJcjo=;
	b=bnk/m78cQ7+qKvef1ORSH7n1oW/DPak+UQEoTlZI8AuTnEKRyHLYrdNl4zIO+hImRm8l/J
	R9t91rYGnzZHH8pX0CtaKlHvtVo2yo7fNjLGNF6CApJ8gHCrBOqGTUKL+dH//SYQRxQWho
	GbzIeflrANCLTJoZAfnF32RzTyGPRD4=
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: sebott@redhat.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: maz@kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	kvm@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 00/10] KVM: arm64: Allow userspace to modify CTR_EL0
Date: Thu, 20 Jun 2024 17:39:29 +0000
Message-ID: <171890515830.1223590.8660930452290685977.b4-ty@linux.dev>
In-Reply-To: <20240619174036.483943-1-oliver.upton@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 19 Jun 2024 17:40:26 +0000, Oliver Upton wrote:
> As I'd mentioned on the list, here is my rework of Sebastian's CTR_EL0
> series. Changes this time around:
> 
>  - Drop the cross-validation of the guest's CTR_EL0 with CLIDR_EL1 and
>    the CCSIDR_EL1 hierarchy, instead independently checking these
>    registers against the system's CTR_EL0 value.
> 
> [...]

Applied to kvmarm/next, thanks!

[01/10] KVM: arm64: Get sys_reg encoding from descriptor in idregs_debug_show()
        https://git.kernel.org/kvmarm/kvmarm/c/4e8ff73eb7ae
[02/10] KVM: arm64: Make idregs debugfs iterator search sysreg table directly
        https://git.kernel.org/kvmarm/kvmarm/c/410db103f6eb
[03/10] KVM: arm64: Use read-only helper for reading VM ID registers
        https://git.kernel.org/kvmarm/kvmarm/c/97ca3fcc15cc
[04/10] KVM: arm64: Add helper for writing ID regs
        https://git.kernel.org/kvmarm/kvmarm/c/d7508d27dd88
[05/10] KVM: arm64: nv: Use accessors for modifying ID registers
        https://git.kernel.org/kvmarm/kvmarm/c/44241f34fac9
[06/10] KVM: arm64: unify code to prepare traps
        https://git.kernel.org/kvmarm/kvmarm/c/f1ff3fc5209a
[07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID register
        https://git.kernel.org/kvmarm/kvmarm/c/2843cae26644
[08/10] KVM: arm64: show writable masks for feature registers
        https://git.kernel.org/kvmarm/kvmarm/c/bb4fa769dcdd
[09/10] KVM: arm64: rename functions for invariant sys regs
        https://git.kernel.org/kvmarm/kvmarm/c/76d36012276a
[10/10] KVM: selftests: arm64: Test writes to CTR_EL0
        https://git.kernel.org/kvmarm/kvmarm/c/11a31be88fb6

--
Best,
Oliver


Return-Path: <kvm+bounces-62387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BEFC42C55
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 12:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 524964E3CEE
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 11:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCD02ECD32;
	Sat,  8 Nov 2025 11:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MfKQI63V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF5F134AB;
	Sat,  8 Nov 2025 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762603137; cv=none; b=jbfoupBn+P33JBioIzhZBUK0mmm9mxDnc4dFqp3eTA/7TxFILD6xKdje83ADNXnWG3EI+RirYz3a7olcNrHr/4rwAUNbg3ZI7Y/UEXHwyPYeSw0wiLFWgt+lEs+MMx8PJ5abIXuwnMNFfYbAdx6IbkiO/vdRBR7BUEDW13saXlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762603137; c=relaxed/simple;
	bh=71r+OcXQB1X7Xbdn1EcsiniewMLKe/3Ylt4UqFQfgeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZ5N4oH7nEgebeEiJzTxhk4gDt0iv6Gu0Hma1pHkIGw1ODdBc2eCs1CQgjgpSrbdO4aYo1vxOYcDS8rm7G3bDuLvy+Xr1r3grqocx7QjQFDBOLVpdvQzDF+j17tPlRDZTaXQVuHGr8vP4VNGBWAJ62nKt9Oma1WukDVXe/h0UXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MfKQI63V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821EEC116C6;
	Sat,  8 Nov 2025 11:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762603137;
	bh=71r+OcXQB1X7Xbdn1EcsiniewMLKe/3Ylt4UqFQfgeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfKQI63Vbjwp935xilRzB7++lSedhoFohgzR9zEsNcklEA+133G3o1yz+5cQBQSz4
	 qOjcCgCMZWbtkP3MeT3Im8efloiXfyW9hR4mknFZmtGCUNmhtVXDFZzQW3EJ79+d1V
	 bpTm0dfzJbc/v+NS/gVSxP2wHanU/SzneKSBSki6QJEdO/P1AFRBAHGPR1IgbKxesz
	 qIScoFBBbgybCkwSxmkuKD+BMAj7NMzGcclNsHR9mG350P4ZS4NNaXy7udK4Bj685T
	 txsytUteQy8HlC3jwTeWjgrLxrMKMYGnjYN/fGxuo/IeqNqy4PfNM8IkzLaA9Qq/Q7
	 wl1kk+qsB6dhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vHhap-00000003Ten-0jtr;
	Sat, 08 Nov 2025 11:58:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fix handling of ID_PFR1_EL1.GIC
Date: Sat,  8 Nov 2025 11:58:47 +0000
Message-ID: <176260312692.1201099.17567101607721197970.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030122707.2033690-1-maz@kernel.org>
References: <20251030122707.2033690-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, peter.maydell@linaro.org, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 30 Oct 2025 12:27:04 +0000, Marc Zyngier wrote:
> Peter reported[0] that restoring a GICv2 VM fails badly, and correctly
> points out that ID_PFR1_EL1.GIC isn't writable, while its 64bit
> equivalent is. I broke that in 6.12.
> 
> The other thing is that fixing the ID regs at runtime isn't great.
> specially when we could adjust them at the point where the GIC gets
> created.
> 
> [...]

Applied to fixes, thanks!

[1/3] KVM: arm64: Make all 32bit ID registers fully writable
      commit: 3f9eacf4f0705876a5d6526d7d320ca91d7d7a16
[2/3] KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured
      commit: 8a9866ff860052efc5f9766f3f87fae30c983156
[3/3] KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip
      commit: 50e7cce81b9b2fbd6f0104c1698959d45ce3cf58

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




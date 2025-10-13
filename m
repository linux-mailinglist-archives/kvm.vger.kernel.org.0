Return-Path: <kvm+bounces-59927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EB145BD55CF
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 19:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E0EED4FB9CD
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 16:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBF429B793;
	Mon, 13 Oct 2025 16:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qpb05tO7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84A129D29A;
	Mon, 13 Oct 2025 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374579; cv=none; b=R+O0JUP2wMx5/slbJanbXS+bZiEeZr4cjO8yLdIKB7+wod/eOgUsUV2awtDSCCWdVV6hwXi4vahpeLTw2+UbiJoVDWVj3nBmvOavwe+NBbVKAYdvuSGALzU3wbiPePIgSTugQQ0yBTrqFQ/Lq44l6pOGgNBooZvZDEfDW4ABkO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374579; c=relaxed/simple;
	bh=oCjPIm76LeAR7DfSG4KlC7i2J3UvMls2jcJsn1nEWxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m2LQXWxd/pPUnM+vfp0JxseFRB2GFfUbvd1Npj3vOWHnrNz8cEdhLlEUN71MyAV57/CtFdbL42EJ4NA0KlIm4BgM0vJeSpGIjCEENtdHm41U0NfkD8zFVMCnCt5HFhv1FskUEB2ECfvcGY87vNVp7xV96efrI/nejJKy7Ek6iB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qpb05tO7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86924C4CEE7;
	Mon, 13 Oct 2025 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760374579;
	bh=oCjPIm76LeAR7DfSG4KlC7i2J3UvMls2jcJsn1nEWxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpb05tO772ZPfXZUyLLCko/z4F0vClyyZnetI+E2KnCLb9bL9xJFFyFJ7CXh0xgYl
	 AbTeicJzvYTLc+eu6pBpQfMuP2aPiFmJiyfvBnPqFhLBjIYSfiDa63BiBll+fPH5HV
	 OEbAvXtO/KfudobNdFhcfw5WJtjL10KOLOr4fgHlRfrIAeIK7EdMWkXqpZFLAM8mn5
	 rvANRZEP+ytVvcMndjX4fORUEqy+yKyVMJca6Bvs8JrD2PjqK6yXsT/gN2ivg2k5WH
	 dT9P/BpZFv+GY1mXb/rq8Op0ondmigG61hHUVVTKZlLB1XyS8MoSKb/Lb3pwLU4sSP
	 biMkJR/8PWeHw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8LqL-0000000DaVX-2zDr;
	Mon, 13 Oct 2025 16:56:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	oliver.upton@linux.dev,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3 or v3 guests
Date: Mon, 13 Oct 2025 17:56:15 +0100
Message-ID: <176037441180.969330.798856280799815530.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007160704.1673584-1-sascha.bischoff@arm.com>
References: <20251007160704.1673584-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, oliver.upton@linux.dev, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 07 Oct 2025 16:07:13 +0000, Sascha Bischoff wrote:
> The ICH_HCR_EL2 traps are used when running on GICv3 hardware, or when
> running a GICv3-based guest using FEAT_GCIE_LEGACY on GICv5
> hardware. When running a GICv2 guest on GICv3 hardware the traps are
> used to ensure that the guest never sees any part of GICv3 (only GICv2
> is visible to the guest), and when running a GICv3 guest they are used
> to trap in specific scenarios. They are not applicable for a
> GICv2-native guest, and won't be applicable for a(n upcoming) GICv5
> guest.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3 or v3 guests
      commit: 3193287ddffbce29fd1a79d812f543c0fe4861d1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




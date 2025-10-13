Return-Path: <kvm+bounces-59925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E03BD5485
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:56:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DDAF188E461
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 16:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749F729B224;
	Mon, 13 Oct 2025 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="trPHgSRY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9A5299AB5;
	Mon, 13 Oct 2025 16:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374569; cv=none; b=b1GYNGXiIHGDiI2BYUBcvJu64J6p3GfSXReh6/lw5Rp60uOzCjwprllQJ71LYbuvGUjxC6kBuDHj6MEbWUams7p04GMKSRFjCQrlZuCQnxta3slNIQIX2c7MPKWAKUhzEmq2i7L9NBYOqkbMmaCUnAMTbi7LIdq+2vSqCo5HhxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374569; c=relaxed/simple;
	bh=sd9F7LKzjBt18Z15j1B/UODVQPX/E6AKnZXYGSGrx2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j0oo0HYa7mSdv21y+wgsqtctIYQJKGXl2x8o9kj9meO+5SV3//UrGoOY5bwpllvjkbEJjcR3/RBAvS7900aFBKIAZpcoGunHoYJHho0vs7/zry7xCRdkd9fs5hJR0jMI6uWRQQU/BUF9jv4wazRGKDBvyVwFts2cx019K3yXWT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=trPHgSRY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B02EC4CEE7;
	Mon, 13 Oct 2025 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760374566;
	bh=sd9F7LKzjBt18Z15j1B/UODVQPX/E6AKnZXYGSGrx2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trPHgSRYR15AsEyLrXzc5GcvFzPthAKhfJe7hSMSBg9aO5z+HNKwcx0coC0eI/lrV
	 pbB+FaRqOQa+G5JjFF82ELQgWS1feIQl4yU+apNd8eh/CPmW0AilpmTbSZnbdXspCP
	 Ba5Krrq+DwmNjY7pm7eWO86IXDrll/Vk45s9eM7E0oZKzKMcZDyZz2Y1Pw+EV+oywA
	 UbyExvvWziegxMqCBV3+/NcstjrVF/bk4nFCaHzTyW1ek6XuJuNhRORbG7J0QjPa1t
	 xuwjnD5Zi+1GPFzUJ7fEqkvrldl3FGehPukoFn4LUzqAowmSRQMGfsH0a8KUBRE95N
	 2VOOFf33HFyPg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v8Lq7-0000000DaUR-36zN;
	Mon, 13 Oct 2025 16:56:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 00/13] KVM: arm64: De-specialise the timer UAPI
Date: Mon, 13 Oct 2025 17:55:59 +0100
Message-ID: <176037441182.969330.8699539271005870715.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929160458.3351788-1-maz@kernel.org>
References: <20250929160458.3351788-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 29 Sep 2025 17:04:44 +0100, Marc Zyngier wrote:
> Since the beginning of the KVM/arm64 port, the timer registers were
> handled out of the normal sysreg flow when it came to userspace
> access, leading to extra complexity and a bit of code duplication.
> 
> When NV was introduced, the decision was made early to handle the new
> timer registers as part of the generic infrastructure. However, the
> EL0 timers were left behind until someone could be bothered to
> entangle that mess.
> 
> [...]

Applied to fixes, thanks!

[01/13] KVM: arm64: Hide CNTHV_*_EL2 from userspace for nVHE guests
        commit: 4cab5c857d1f92b4b322e30349fdc5e2e38e7a2f
[02/13] KVM: arm64: Introduce timer_context_to_vcpu() helper
        commit: aa68975c973ed3b0bd4ff513113495588afb855c
[03/13] KVM: arm64: Replace timer context vcpu pointer with timer_id
        commit: 8625a670afb05f1e1d69d50a74dbcc9d1b855efe
[04/13] KVM: arm64: Make timer_set_offset() generally accessible
        commit: a92d552266890f83126fdef4f777a985cc1302bd
[05/13] KVM: arm64: Add timer UAPI workaround to sysreg infrastructure
        commit: 77a0c42eaf03c66936429d190bb2ea1a214bd528
[06/13] KVM: arm64: Move CNT*_CTL_EL0 userspace accessors to generic infrastructure
        commit: 09424d5d7d4e8b427ee4a737fb7765103789e08a
[07/13] KVM: arm64: Move CNT*_CVAL_EL0 userspace accessors to generic infrastructure
        commit: 8af198980eff2ed2a5df3d2ee39f8c9d61f40559
[08/13] KVM: arm64: Move CNT*CT_EL0 userspace accessors to generic infrastructure
        commit: c3be3a48fb18f9d243fac452e0be41469bb246b4
[09/13] KVM: arm64: Fix WFxT handling of nested virt
        commit: 892f7c38ba3b7de19b3dffb8e148d5fbf1228f20
[10/13] KVM: arm64: Kill leftovers of ad-hoc timer userspace access
        commit: 386aac77da112651a5cdadc4a6b29181592f5aa0
[11/13] KVM: arm64: selftests: Make dependencies on VHE-specific registers explicit
        commit: 6418330c8478735f625398bc4e96d3ac6ce1e055
[12/13] KVM: arm64: selftests: Add an E2H=0-specific configuration to get_reg_list
        commit: 4da5a9af78b74fb771a4d25dc794296d10e170b1
[13/13] KVM: arm64: selftest: Fix misleading comment about virtual timer encoding
        commit: 5c7cf1e44e94a5408b1b5277810502b0f82b77fe

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




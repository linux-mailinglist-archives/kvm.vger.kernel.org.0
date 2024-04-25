Return-Path: <kvm+bounces-15908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7883C8B21B0
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3515B2881A9
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 12:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60FCC1494BE;
	Thu, 25 Apr 2024 12:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+feseYX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A171494AF;
	Thu, 25 Apr 2024 12:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714048389; cv=none; b=thbG0AUEhAFbfqN9dxZ4MSEeGwlcvPbVcGSoWfaKKHy0vhb58j/P1TE9QUhBqDptp7W5DyM9Q07EsDicn2lomYvfhpSN1SZ/oegd11ED6gMy114kr7EZ2uFx3GINpSc2+lyj1gxCNnksnZOoz7uEGShDGleimuMsqnWTeYCIjsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714048389; c=relaxed/simple;
	bh=B3vHwjyjqH1ixQmXgi7bGPwG/IbnE1RHJRVIK2Jscmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNhO8oy01sOta0bawau2s/yMpLO4aZTmjvwlvdpQFciDlspaHx4LKTk1WdSStIyeSLR4qe+NfliprF+83TOgZcdqpRkDkuNPL64eb4S3MOhO2y+9GdmV2Ms+90SGSXClPnGHxZ6GOUAfPHbTe9UP5Ty1sskwtwSUKj9nLw8Ltj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+feseYX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212CAC113CC;
	Thu, 25 Apr 2024 12:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714048389;
	bh=B3vHwjyjqH1ixQmXgi7bGPwG/IbnE1RHJRVIK2Jscmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+feseYXdjhpRwi/N3M7dtSkOqvGP3+/hGe1qwabvjbtM/vzcDor6L1dtZBrpJI/m
	 2e5iglQpMpeNx5/HwPX6gSrgoNJAcyzptNp+4fwPjaR9X3bG5ceagXF5JKDGVdu9OB
	 t2BuFAt6UtW33fXzI4RaKDY6/fOwSNFlJLJ2E8BF/RHu4QhX1+3gRN77gFQKy5TcU2
	 iPr7+jCvPrLamcV6m3XZNYTOr0ArXrpNdEPIE9XK0WkX1BO+Zin5VQqqjxIAMEwAAO
	 Ba6o0OnU9fAILD6osUSZOyQbIq/MnV1Iow2k3ww2yx6r0EuFLdaPt8u7N67CpIDhFY
	 6nMaUoLYhfTcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rzyHi-007tW9-PC;
	Thu, 25 Apr 2024 13:33:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/19] KVM: arm64: Transition to a per-ITS translation cache
Date: Thu, 25 Apr 2024 13:33:03 +0100
Message-Id: <171404835709.2338103.11155685781713839680.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, eric.auger@redhat.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 22 Apr 2024 20:01:39 +0000, Oliver Upton wrote:
> v2: https://lore.kernel.org/kvmarm/20240419223842.951452-1-oliver.upton@linux.dev/
> 
> v2 -> v3:
>  - Add lockdep assertion to kvm_vfio_create() (Sean)
>  - Address intermediate compilation issue in vgic_its_invalidate_cache()
>    (Marc)
>  - Use a more compact cache index based on the DID/EID range of the ITS
>    (Marc)
>  - Comment improvements (Marc)
>  - Avoid explicit acquisition of the translation cache's xa_lock()
>    (Marc)
>  - Eliminate the need to disable IRQs to acquire the translation cache's
>    xa_lock()
>  - Collapse internal helper into vgic_its_check_cache()
> 
> [...]

Applied to next, thanks!

[01/19] KVM: Treat the device list as an rculist
        commit: ea54dd374232cc3b6d0ac0a89d715d61ebb04bf6
[02/19] KVM: arm64: vgic-its: Walk LPI xarray in its_sync_lpi_pending_table()
        commit: 720f73b750e66ca753c56c29801009c28bb484ac
[03/19] KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_invall()
        commit: c64115c80fc8abacfb89c36d650b7021ebb3d739
[04/19] KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_cmd_handle_movall()
        commit: 11f4f8f3e6e0697fb640d5c6c79b27c2233bc3da
[05/19] KVM: arm64: vgic-debug: Use an xarray mark for debug iterator
        commit: 85d3ccc8b75bb5a443edb3c42fa22e97da2e60ec
[06/19] KVM: arm64: vgic-its: Get rid of vgic_copy_lpi_list()
        commit: 30a0ce9c4928640efd3112d01d432d0778878b7e
[07/19] KVM: arm64: vgic-its: Scope translation cache invalidations to an ITS
        commit: c09c8ab99a8afb24f6b4a6bc7c2767fec348ae81
[08/19] KVM: arm64: vgic-its: Maintain a translation cache per ITS
        commit: 8201d1028caa4fae88e222c4e8cf541fdf45b821
[09/19] KVM: arm64: vgic-its: Spin off helper for finding ITS by doorbell addr
        commit: dedfcd17faf8718f4842e7fbfcd2e7026854d7f5
[10/19] KVM: arm64: vgic-its: Use the per-ITS translation cache for injection
        commit: e64f2918c6e7a2c2cbf310d1b571d1a886b91475
[11/19] KVM: arm64: vgic-its: Rip out the global translation cache
        commit: ec39bbfd55d07de2e2d4111f35c7ad9523c89ec3
[12/19] KVM: arm64: vgic-its: Get rid of the lpi_list_lock
        commit: 481c9ee846d27c72acc0c3bb23025c7fdad8c171
[13/19] KVM: selftests: Align with kernel's GIC definitions
        commit: d82689bdd828833bd582c2bf7a85071cacb52990
[14/19] KVM: selftests: Standardise layout of GIC frames
        commit: 1505bc70f80df9824e9d68d15a7452856df7488c
[15/19] KVM: selftests: Add quadword MMIO accessors
        commit: 232269eb7dd5242877abfab1d47a1eb049a44b95
[16/19] KVM: selftests: Add a minimal library for interacting with an ITS
        commit: be26db61e880b3892f189e9ef54b7b80599245bf
[17/19] KVM: selftests: Add helper for enabling LPIs on a redistributor
        commit: 03e560ab539009856266b0cf8c100c9f7d1f8fee
[18/19] KVM: selftests: Use MPIDR_HWID_BITMASK from cputype.h
        commit: c3c369b508d9a447436b7abb2fded9aec18953ff
[19/19] KVM: selftests: Add stress test for LPI injection
        commit: 96d36ad95b03c89857d405b3317efb0188ac59cb

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




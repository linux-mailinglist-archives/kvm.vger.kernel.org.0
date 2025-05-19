Return-Path: <kvm+bounces-46959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A21FEABB587
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 09:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EA623AAF95
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 07:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F91A266576;
	Mon, 19 May 2025 07:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdR80dEY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C05265CCC;
	Mon, 19 May 2025 07:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747638249; cv=none; b=K1uMM0dikysgWQNc9HP+NcwOPG8OuB0B18ZscjTdtnt3weELA85SSo8R/kE//HwwvaWeJAoB5xh7k1janKAkYimwP4JRpzaQSh/mOcCJ5JYoA2SVr0E4qs0gw+VfNx7ET1++dkYKjS3cO1Mf6Onauur5dAqdX64cGBY1d6IzI+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747638249; c=relaxed/simple;
	bh=cDw2N1Mdxs2LWWEBQ4N2j84UnkVJ9i6iMGcYABUbhko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RLpnCxawWcYvGNm4S7KZQ3UFg382Y9ROFlGIk8A9NHInm+aAYy7D3CCSyAxqCBHFcDCPPyWTp+peM7JomoUge7NFumA6zgnXRhJitbpOysOVpynYNcGtRXCw3TAnFuZ1b9dfreWd2u8LSA3vBudcG1n1R67E3YxYTzQW0BVSNBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdR80dEY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F8EC4CEED;
	Mon, 19 May 2025 07:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747638249;
	bh=cDw2N1Mdxs2LWWEBQ4N2j84UnkVJ9i6iMGcYABUbhko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdR80dEYtyEEkSFobE97EkC0XL3p+bTCus707WtssnqSKalDPqSaZou6YOSquFCBU
	 RuMuVhuX2wEbmYcc9Y0tgjPvmzShate7YudiLDEPkYG+SpHzrEBg6k5GGmvoShyHcB
	 l06WDZqs6Mqm1JWDVUAyKKhQ3tcqiwOyNI43JNm2chkl8QMkYP8v80UFfVOE4JCwGN
	 11PmENyFD2GOn7Y9UiOdNdq2DOyH347oWb8G5gz9oiVK4moTIXqDZ3xqhYTyGYoKue
	 5s4vykNtRJVEZV4paMtXUYgeaHnPtHisXo5gM14NshUAlZICMixVjI7OJKiVcg2knz
	 C3HHpZ0OizqJw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uGuXe-00G8Jz-DZ;
	Mon, 19 May 2025 08:04:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v4 00/17] KVM: arm64: Recursive NV support
Date: Mon, 19 May 2025 08:04:02 +0100
Message-Id: <174763823024.3048822.12064289612158911186.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250514103501.2225951-1-maz@kernel.org>
References: <20250514103501.2225951-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 14 May 2025 11:34:43 +0100, Marc Zyngier wrote:
> This is probably the most interesting bit of the whole NV adventure.
> So far, everything else has been a walk in the park, but this one is
> where the real fun takes place.
> 
> With FEAT_NV2, most of the NV support revolves around tricking a guest
> into accessing memory while it tries to access system registers. The
> hypervisor's job is to handle the context switch of the actual
> registers with the state in memory as needed.
> 
> [...]

Applied to next, thanks!

[01/17] arm64: sysreg: Add layout for VNCR_EL2
        commit: fb3066904a4e2562cbcf71b26b0f0dc7a262280c
[02/17] KVM: arm64: nv: Allocate VNCR page when required
        commit: 469c4713d48028186e4bbf4b74ebce273af9a394
[03/17] KVM: arm64: nv: Extract translation helper from the AT code
        commit: 34fa9dece52757727ed2ffd5cf4713c6cd0b707f
[04/17] KVM: arm64: nv: Snapshot S1 ASID tagging information during walk
        commit: a0ec2b822caba9ccdefa397918071e591b19e144
[05/17] KVM: arm64: nv: Move TLBI range decoding to a helper
        commit: 85bba00425ae0b4b30938ebfdde6d986e5423aff
[06/17] KVM: arm64: nv: Don't adjust PSTATE.M when L2 is nesting
        commit: bd914a981446df475be27ef9c5e86961e6f39c5a
[07/17] KVM: arm64: nv: Add pseudo-TLB backing VNCR_EL2
        commit: ea8d3cf46d57bc1e131ca66ebc3e9aabe40234ef
[08/17] KVM: arm64: nv: Add userspace and guest handling of VNCR_EL2
        commit: 6fb75733f148ecd6c1898df0098b37f70a80f002
[09/17] KVM: arm64: nv: Handle VNCR_EL2-triggered faults
        commit: 069a05e53549685d2b5e54ceb51db1fd04aa50d7
[10/17] KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2
        commit: 2a359e072596fcb2e9e85017a865e3618a2fe5b5
[11/17] KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers
        commit: 7270cc9157f474dfc46750a34c9d7defc686b2eb
[12/17] KVM: arm64: nv: Program host's VNCR_EL2 to the fixmap address
        commit: 73e1b621b25d7d45cebf9940cad3b377d3b94791
[13/17] KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2
        commit: 4ffa72ad8f37e73bbb6c0baa88557bcb4fd39929
[14/17] KVM: arm64: nv: Plumb TLBI S1E2 into system instruction dispatch
        commit: aa98df31f6b42d3379869b82588bebaec4ce474b
[15/17] KVM: arm64: nv: Remove dead code from ERET handling
        commit: 6ec4c371d4223adae6f9c0f7f1bd014d381b2170
[16/17] KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
        commit: a7484c80e5ca1ae0c397bb8003bc588f0dcf43f4
[17/17] KVM: arm64: Document NV caps and vcpu flags
        commit: 29d1697c8c8f64e4d8bb988f957ca1d4980937dc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




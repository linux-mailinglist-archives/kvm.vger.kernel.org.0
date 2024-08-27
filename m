Return-Path: <kvm+bounces-25191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD4A9615AD
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 19:41:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCD49B22114
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44C91CDA3C;
	Tue, 27 Aug 2024 17:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etDD3jbD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87B01D174E;
	Tue, 27 Aug 2024 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724780471; cv=none; b=Tbj2QUyJ2NLCOfl3jsSsm2aGuttSnPTQgjxvK9T2g5aOo8OvYGaCTCMpXVlOoLRtYbbM8UtDSStdMGOize1nREZHuJNA8sANQ2Wmft+ZQnmAP95FC2akjfQiLPBK5x5iGNGMAv+K4hKkXZ+9SpamYNaoN4LwNM2Lg2p6YhIAvhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724780471; c=relaxed/simple;
	bh=2Dvq4GZvvDxmHQJvbFtFaGiDmWeBUJew29WRzq1TQvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7lBDYNYs1fPgNmEfNqyVFbxPasE4E0sm4n5Djplf7M/gggdXhntM9kADDGRb0BlFVyMQFzRm5S4abRVgnn0Ky4ufJKhpRcqHr2JSSEmcaFhQcbMmEuU4aClJ7brLmIpWXomTBPWt2ol2cgXA1G/kLnpJDPIdYCYVGtS6cnX+Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etDD3jbD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B740EC567F2;
	Tue, 27 Aug 2024 17:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724780470;
	bh=2Dvq4GZvvDxmHQJvbFtFaGiDmWeBUJew29WRzq1TQvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etDD3jbDgZ+SRILbgMnE/vIVnMjmSUlTDB31wijltFe47mvBupdZwxVmnDErGEgWw
	 P1U3evJLWch3mB+MEEeT6z+ePrJcG9W6P5JMV3ZBEBj+qyRAF206h6CRgnZvmACBYX
	 EYnfGW0XABe1snzjKcJpu4XaWXT83DLc6HayyemZ65QsCgF18jbKFoRSVbDVrQ2GLf
	 /WIc7Ur7plj/Aph4v4ieLx6QgtKZQTldWOaJnGYC5nzahkTH7/pkqv2V7MvP06iOns
	 tsPw9af7fePrTjq2i2I9uakadx8ZfLe3qZxQ45xh4XeRJJT6/TFCGovE2IUCrOHCwy
	 k2JUnP5P+X+EA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sj0Bo-007Jr4-Pg;
	Tue, 27 Aug 2024 18:41:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH v2 00/11] KVM: arm64: Handle the lack of GICv3 exposed to a guest
Date: Tue, 27 Aug 2024 18:41:05 +0100
Message-Id: <172478045782.3912073.2560526498433188972.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827152517.3909653-1-maz@kernel.org>
References: <20240827152517.3909653-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 27 Aug 2024 16:25:06 +0100, Marc Zyngier wrote:
> It recently appeared that, when running on a GICv3-equipped platform
> (which is what non-ancient arm64 HW has), *not* configuring a GICv3
> for the guest could result in less than desirable outcomes.
> 
> We have multiple issues to fix:
> 
> - for registers that *always* trap (the SGI registers) or that *may*
>   trap (the SRE register), we need to check whether a GICv3 has been
>   instantiated before acting upon the trap.
> 
> [...]

Applied to next, thanks!

[01/11] KVM: arm64: Move GICv3 trap configuration to kvm_calculate_traps()
        commit: d2137ba8d8fe56cd2470c82b98e494cbcababd76
[02/11] KVM: arm64: Force SRE traps when SRE access is not enabled
        commit: 5739a961b542530626cb3afb721efa688b290cce
[03/11] KVM: arm64: Force GICv3 trap activation when no irqchip is configured on VHE
        commit: 8d917e0a8651377321c06513f42e2ab9a86161f4
[04/11] KVM: arm64: Add helper for last ditch idreg adjustments
        commit: 795a0bbaeee2aa993338166bc063fe3c89373d2a
[05/11] KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest
        commit: 5cb57a1aff7551bcb3b800d33141b06ef0ac178b
[06/11] KVM: arm64: Add ICH_HCR_EL2 to the vcpu state
        commit: 9f5deace58da737d67ec9c2d23534a475be68481
[07/11] KVM: arm64: Add trap routing information for ICH_HCR_EL2
        commit: 15a1ba8d049855c5ae454c84e6dd2d7657bacbe8
[08/11] KVM: arm64: Honor guest requested traps in GICv3 emulation
        commit: 59af011d001b836aa52a3dbb5c54daf6fffb511e
[09/11] KVM: arm64: Make most GICv3 accesses UNDEF if they trap
        commit: 4a999a1d7ae52592723a9a219aaa7a3406d66dd6
[10/11] KVM: arm64: Unify UNDEF injection helpers
        commit: cd08d3216fc4e684f05fe4cf696a275a975f6499
[11/11] KVM: arm64: Add selftest checking how the absence of GICv3 is handled
        commit: de2e75209303b98d3169a249a1bc847be9657d9b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




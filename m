Return-Path: <kvm+bounces-68176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 550BCD24536
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 12:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 42D3A3020FC4
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 11:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBD73939DD;
	Thu, 15 Jan 2026 11:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uBayVj/n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1601392C29;
	Thu, 15 Jan 2026 11:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477752; cv=none; b=eFVAkyhWtce48BiU72hEEAY9/qzpGOSjfHK8E0QK52PDk1bdiZWv1MZJ7mVmw6ggUL4nGCkddrCrynocH9E6T7HdCRC50HS3ceMYUShA08FCbPtdEvvTFt5qMkFKnfqY28mcRNnLvYZBApQHWL3e78qeE36rE0Gtw9RjJSVrA5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477752; c=relaxed/simple;
	bh=b5MwZd6IEwDZvkIBVY2DBQ3kAUAx76ac/X+w5A+//CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DbL0MNJxsz/qZSVyf4wLhjbyGSNFZ5RZ8FUdfjgvGomMBSGAZw4nv5mh02ia7chdwf73nThp4bhx/fM0MLOr2YfEGZ0ruCnMpKgf+nmlqxAr6lQbsvWdpBNc/XPDhcdm/z/NZ0bYXL5vpLA+wRIiWR+C3S6qW9DhsWbaT3K2mYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uBayVj/n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFBCC116D0;
	Thu, 15 Jan 2026 11:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768477752;
	bh=b5MwZd6IEwDZvkIBVY2DBQ3kAUAx76ac/X+w5A+//CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBayVj/nfVUeKP5xuoOl/hqvGbfAlSTDNpCkRC4vmTamfH+4cHQXpSspH+7ClelXY
	 Kd7LCVJ2WqFtgCZDAd3oMJUnKO66tepzxTGO7MIzzY4QqQIWAAU9K0KDvLchhd4qdk
	 EYYjMgHIDjh92/oyfw4PRFEa7g9YsYx91zYivm9iEt7Sxds3GvMCSfepG/evmTjidY
	 U71xn1q85ZcC4ukEvJH0Iq8chmqWAAgAgbCV3TZtp9ALCxxfnaxAkfHTTEGIPFbVPj
	 moA1by4q7rvYqWIO9Zfx68rsh+TJFGgKgwngTBSVuZcORwQAS4tjfbMggLhq85IiHS
	 w1w0pJPZdnMHw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vgLqf-00000002VhW-35WM;
	Thu, 15 Jan 2026 11:49:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v2 0/6] KVM: arm64: VTCR_EL2 conversion to feature dependency framework
Date: Thu, 15 Jan 2026 11:49:06 +0000
Message-ID: <176847771285.3689365.14003323952807162943.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251210173024.561160-1-maz@kernel.org>
References: <20251210173024.561160-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, alexandru.elisei@arm.com, Sascha.Bischoff@arm.com, qperret@google.com, tabba@google.com, sebastianene@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 10 Dec 2025 17:30:18 +0000, Marc Zyngier wrote:
> This is a follow-up on my VTCR_EL2 sanitisation series, with extra
> goodies, mostly as a consequence of Alexandru's patches and review.
> 
> * From [1]:
> 
>   - Added two patches fixing some FEAT_XNX issues: one dating back
>     from the hVHE introduction, and the other related to the newer
>     stuff in 6.19.
> 
> [...]

Applied to next, thanks!

[2/6] arm64: Convert ID_AA64MMFR0_EL1.TGRAN{4,16,64}_2 to UnsignedEnum
      commit: f1640174c8a769511641bfd5b7da16c4943e2c64
[3/6] arm64: Convert VTCR_EL2 to sysreg infratructure
      commit: a035001dea37b885efb934e25057430ae1193d0a
[4/6] KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co
      commit: c259d763e6b09a463c85ff6b1d20ede92da48d24
[5/6] KVM: arm64: Convert VTCR_EL2 to config-driven sanitisation
      commit: 9d2de51825598fc8e76f596c16368362753d8021
[6/6] KVM: arm64: Honor UX/PX attributes for EL2 S1 mappings
      commit: 80cbfd7174f31010982f065e8ae73bf337992105

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




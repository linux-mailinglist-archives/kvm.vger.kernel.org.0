Return-Path: <kvm+bounces-63053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E359FC5A3E9
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:53:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 971FE4FAFAB
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2219E30EF6E;
	Thu, 13 Nov 2025 21:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GvkUI3zh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A103246F3;
	Thu, 13 Nov 2025 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763069868; cv=none; b=Uk+eCAI/LlGCKZ4rniMVI40mjYdZfYExDzyX4X9PS133MsHysyQIpM8uhDNyDCcyhpA126IMcVLsIgXryV+kLK42KmAoO794iEU2Sph/1ZnsOfpXbCvB0U4Kot6Sq5DA0e7pbLezpX2kr+0lzNl0Oz/ONgFo3CN2feBTWmF7Y/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763069868; c=relaxed/simple;
	bh=rxL7Gci2ztB1l+oHFBXQu9xc4TlmQwnasATOD0+gSsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m2Ynpk23OpE+V2I0a5vO6aF1nzs+F7Os+wBrYFFq0cQwXpdmVjhg5LiCDvhZUV360iR9J7uz47d3ZC1lUHa9U+Kw0UX6Xwj6suOOK0AWmojjp+lAXdNUnl0fBnLZWK9npsPwmFGDtBNiHXVHAiOcE9qzcEtPMB+0BXulqCQKsrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GvkUI3zh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC1DC113D0;
	Thu, 13 Nov 2025 21:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763069867;
	bh=rxL7Gci2ztB1l+oHFBXQu9xc4TlmQwnasATOD0+gSsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvkUI3zh4TXQWAF/jkz1rD8ACMooMrT6gTt6F7LqLMW0pIbenBrms060ck2KP7zLm
	 5Qg6dNO4uS5dUXXfrC2ZSdYAR1Oe2qhtLoF64+aaRC9q1iD0QlGn6+LgoweHYF2iXq
	 PM7/Ey2rJpvQUR4ofpCIfRTxVeI3rq6OBU3D2iHnXWljtJKoQ/+aMB6vxTQWQf2Lih
	 c8jH5OjwrC4pdKMeR7Kjo7m8aSonT3vptbPfqXgc/4/8nBMPWd2eHVllqhY/+0S2/u
	 8uetADDxajYTDLYQevWVJ4pXGiXpmYMGgvf81FEhuecA1cz/YDODAjLZP6weJ6hODn
	 GFjPZZ12zK7Hw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] KVM: arm64: GICv3: Check the implementation before accessing ICH_VTR_EL2
Date: Thu, 13 Nov 2025 13:37:45 -0800
Message-ID: <176306986138.2184993.9505471875702043816.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113172524.2795158-1-maz@kernel.org>
References: <20251113172524.2795158-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 13 Nov 2025 17:25:24 +0000, Marc Zyngier wrote:
> The ICH_HCR_EL2 patching code is generally GIC implementation agnostic,
> except when checking for broken Apple HW, which imposes to read
> ICH_VTR_EL2.
> 
> It is therefore important to check whether we are running on such
> HW before reading this register, as it will otherwise UNDEF when
> run on HW that doesn't have GICv3.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: GICv3: Check the implementation before accessing ICH_VTR_EL2
      https://git.kernel.org/kvmarm/kvmarm/c/8ed2ae76f20c

--
Best,
Oliver


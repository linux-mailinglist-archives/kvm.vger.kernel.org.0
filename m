Return-Path: <kvm+bounces-64615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E65F7C88425
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 07:24:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B55134E5A01
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C8C30EF62;
	Wed, 26 Nov 2025 06:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7HbiMb5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CC228314C;
	Wed, 26 Nov 2025 06:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764138264; cv=none; b=sNijXtEtY6bjIMybGZG4kEs55DggfZdXuCVr4n7VEaUTNpwS+lO/gLFuMziaPSVi9pFKJx32HdwwGc3lSFGDb4xRH2JvKeL315+SUuurfSn1TlIR3fk0xCLUa3/sJdFQGDpWVO7Hg1eh1OTS2tjC2zfjUKSePVPaXT5vtljV0WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764138264; c=relaxed/simple;
	bh=sUiCwKNe3z+sHXocE2lAIW6X2BDWSB17D73K2hnpa5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=arRZTnJhx9MBf8a/Ts6CGzJp1Fx8TueKIDFyuaQaRBpK/xafe0qmDE32KJeCTOlevxQTacZoyU3R5hzmApJUMMHVCdb1IrcCmyBwxkvyd8kyxSNl/cTcxiW5rUUT7dLuhG/CInVxpbY+7NZEpTtkxt6/hEJ0HNxE0rmCOkWH/pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u7HbiMb5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F198C113D0;
	Wed, 26 Nov 2025 06:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764138263;
	bh=sUiCwKNe3z+sHXocE2lAIW6X2BDWSB17D73K2hnpa5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7HbiMb5vvG6nk6FBQ/uO/KiTOokMUrIiXr30Yq+FYW9t9QyYCGht/Xil4RxlxTaI
	 +lJfXdSvyXVzUUfyfLbLwXDGZrgR4qaqRBVVLnwidX6Vao3oAv8E/HXjBIwu50LFp7
	 tbFe8JW2jjUtelsqUyq4FcPth059RPEMNMcOZsOnZ3v8bZiSIKpG+QZe5RhEjX/5iK
	 g/t4qeoZHTJMyHC2mdQ/dE04glKiLkuWW0HwG+q/5kxqp4VuUqy7k9EsRGldoL+A6t
	 /xy2bkUa+2/Q3kNQf4+6DSdn3WuZ6WEdqAiKZ89QuQe6en5vOZXJKZQVZEmnvf4z3E
	 +MYB5J6s3uI9A==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Convert ICH_HCR_EL2_TDIR cap to EARLY_LOCAL_CPU_FEATURE
Date: Tue, 25 Nov 2025 22:24:20 -0800
Message-ID: <176413825565.1765923.11158518614832526682.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251125160144.1086511-1-maz@kernel.org>
References: <20251125160144.1086511-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Nov 2025 16:01:44 +0000, Marc Zyngier wrote:
> Suzuki notices that making the ICH_HCR_EL2_TDIR capability a system
> one isn't a very good idea, should we end-up with CPUs that have
> asymmetric TDIR support (somehow unlikely, but you never know what
> level of stupidity vendors are up to). For this hypothetical setup,
> making this an "EARLY_LOCAL_CPU_FEATURE" is a much better option.
> 
> This is actually consistent with what we already do with GICv5
> legacy interface, so flip the capability over.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Convert ICH_HCR_EL2_TDIR cap to EARLY_LOCAL_CPU_FEATURE
      https://git.kernel.org/kvmarm/kvmarm/c/64d67e7add10

--
Best,
Oliver


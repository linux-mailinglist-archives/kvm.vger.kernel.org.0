Return-Path: <kvm+bounces-16513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA588BADCB
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 15:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC231C21BC8
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 13:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A762153BFE;
	Fri,  3 May 2024 13:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCl2yHHJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ECE153BEE;
	Fri,  3 May 2024 13:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714743332; cv=none; b=MVFEeKwNazWiMWt6wuQV5IJOwQTsxQAMzsCmVaai+3Dp/PyAMusJjKn2ybzyxKTAmRAZmA0VfGQyslZST+nGUrYoz2ZNwpIZZw0YMz37WoLqT0r22mqHaNkFiYvisc0ZHUHsnoTp2En8Znu0vrl5J08x2QNX4MwJRxZaZCpJ6MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714743332; c=relaxed/simple;
	bh=BvENLRYbFMQcqoQZl0GKVZ/ssG9xqu4OZFThI74E6mE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o8KbvajCETGcHHP0wqKcBq/Kj27JV+dJcmpTn4d9JA19Qkv3SDeJ7Lj2L0Y9VoutERFcF8xjxiGSNyonIB1IEapRWlOuus+rp/+KbqPemm1SR4x2EtX1pPRq+dR8mWffta+uqiRSxkANCDwK9BHIk9/LiukEMk3Msvshmmtknu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WCl2yHHJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B99DC4AF1B;
	Fri,  3 May 2024 13:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714743330;
	bh=BvENLRYbFMQcqoQZl0GKVZ/ssG9xqu4OZFThI74E6mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCl2yHHJYG4XdrI95Np2IB4PW1zh++y27Nd4NkgbAGM+R8rF55h4AeXyh1/umKfz/
	 8ciNM45R29XkkBXZjZnwc17v51frM4LB9ZxNzNDFt48q/1+FRVb8vLu34DxD5XacsE
	 DqXevIO5FtaZwfx6XLyynBnBl8VjzUdTX9e4Ml6qUenzEMJGLZrVz4dxX7ytjuu2Qa
	 suWphn2L7VwwKTiY3AjyFZDIlb93ZDkBZXAA+eyQZU7gD4zkqAhDf148ws79yjLxlC
	 Z4J5iVli0F6/MESWH09/yB8TOXQXkAOvAFJTgszC+m/rkpGDRPOPtAKH/IHK62fjxM
	 3C4gessjKYD+w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2t4S-00AKZC-9A;
	Fri, 03 May 2024 14:35:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Allocate private interrupts on demand
Date: Fri,  3 May 2024 14:35:17 +0100
Message-Id: <171474325427.3225213.9683195489644361681.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240502154545.3012089-1-maz@kernel.org>
References: <20240502154545.3012089-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 02 May 2024 16:45:45 +0100, Marc Zyngier wrote:
> Private interrupts are currently part of the CPU interface structure
> that is part of each and every vcpu we create.
> 
> Currently, we have 32 of them per vcpu, resulting in a per-vcpu array
> that is just shy of 4kB. On its own, that's no big deal, but it gets
> in the way of other things:
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: vgic: Allocate private interrupts on demand
      commit: 03b3d00a70b55857439511c1b558ca00a99f4126

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




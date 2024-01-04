Return-Path: <kvm+bounces-5680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2593B824923
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD7971F22AC6
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAE72C1B8;
	Thu,  4 Jan 2024 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPKJcYq/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D990A2E83C;
	Thu,  4 Jan 2024 19:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8BBC433C8;
	Thu,  4 Jan 2024 19:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704396850;
	bh=ts7oBygcUTeseDhGdz2zZvobB1+fOB8NQDkTgbrEGUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPKJcYq/wzBROMcwFkLR1N70qVzN3I87IZrr2nARAakcsHph0GbuY3Ff2nMRFx73P
	 OkHoAX18RaHejuHzkOdlZjLIdpfANc4YLqWpttSKQ82TMoRnbP60mKfRKypDn+kYD5
	 n1qS1Yihn+vRSiOz4Rw0vcqnjRdBqqbLqyTfhe0/ddCwow1afcYcMONT2876bp+ePS
	 z3CH7zpbOZ59QuHVS3FIaGGntc2H6r7RGNaFf6DIpzCi8t9lndIhwY+1d3l34C9pRr
	 7oBn3vvOpBlwGq5DyN+9hDh9Qchw90fIdLcLYaiTEtr2X5mfR7KqB+zoO1oj1lYPgT
	 uh81idvY/pMLw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rLTTj-008uJy-6D;
	Thu, 04 Jan 2024 19:34:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Raghavendra Rao Ananta <rananta@google.com>,
	kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Avoid potential UAF in LPI translation cache
Date: Thu,  4 Jan 2024 19:33:57 +0000
Message-Id: <170439682675.922629.13779049551870724303.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240104183233.3560639-1-oliver.upton@linux.dev>
References: <20240104183233.3560639-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, rananta@google.com, kvm@vger.kernel.org, james.morse@arm.com, yuzenghui@huawei.com, stable@vger.kernel.org, suzuki.poulose@arm.com, jingzhangos@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 4 Jan 2024 18:32:32 +0000, Oliver Upton wrote:
> There is a potential UAF scenario in the case of an LPI translation
> cache hit racing with an operation that invalidates the cache, such
> as a DISCARD ITS command. The root of the problem is that
> vgic_its_check_cache() does not elevate the refcount on the vgic_irq
> before dropping the lock that serializes refcount changes.
> 
> Have vgic_its_check_cache() raise the refcount on the returned vgic_irq
> and add the corresponding decrement after queueing the interrupt.

Applied to next, thanks!

[1/1] KVM: arm64: vgic-its: Avoid potential UAF in LPI translation cache
      commit: ad362fe07fecf0aba839ff2cc59a3617bd42c33f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




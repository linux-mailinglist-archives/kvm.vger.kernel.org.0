Return-Path: <kvm+bounces-31531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6909C47BA
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 22:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85E6AB2F21F
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8571B5338;
	Mon, 11 Nov 2024 20:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NSky0qXt"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F2213A250
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 20:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731357633; cv=none; b=TheahwHRZZNwHQFmmidQQu3syYg23dIjwqkI+JQRmeupCEnaKHXpVgX0+Z+gZz2ty3r0OWuh0gJFyoVQ68HIeAi5UeJ2hQidR7SHeZSNgZpBr9AOelScWuLtZkEPce5WSz++TvbiYPmHSZS1CS8SW8E+cR2w6YfwHkqvcYt7aJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731357633; c=relaxed/simple;
	bh=oERcGQ9LDVehJFUMZyeiUnRg+hZ6+rOpSWGKGuiOaKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBaCDYSOcAs/7RlzRQ2RP/9EWui2FHXCVt8cmv61kuKwl2AfVuEoBNUUFcdqu/bI25fpsWZQQE2xYuHAEpnWAt++o8PennDqHqHtnVyyPMoxTx0KotIJRJq0R9y91dOtkaxccaEAAGtgy1rofv1Vpj89mdACNwVkw0b3cg+rjDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NSky0qXt; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731357629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9CAj9JaGMN0ybNM1og6EH7btRUNarOLzlzuHTkv93s=;
	b=NSky0qXt3FYZ1uz0lOO9GCgsPfAGi+hlH9gH52cProQINk5600PTWNOFHccqjfU+OaRCfF
	t6d6uVZ5IEdvMi7EPmtGKg214jQbT/V7GI2CRh3Vur2lw6eVacBlV+8dEWOU6KKMJDnZkQ
	qVkuJ46lmP6hM9u5vD/+H6Q6xWS0LZE=
From: Oliver Upton <oliver.upton@linux.dev>
To: ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	KVMARM <kvmarm@lists.linux.dev>,
	Oliver Upton <oliver.upton@linux.dev>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	KVM <kvm@vger.kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Cc: Colton Lewis <coltonlewis@google.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Shusen Li <lishusen2@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v4 0/5] Some fixes about vgic-its
Date: Mon, 11 Nov 2024 20:40:03 +0000
Message-ID: <173135744708.2975582.6187985686343920631.b4-ty@linux.dev>
In-Reply-To: <20241107214137.428439-1-jingzhangos@google.com>
References: <20241107214137.428439-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 7 Nov 2024 13:41:32 -0800, Jing Zhang wrote:
> This patch series addresses a critical issue in the VGIC ITS tables'
> save/restore mechanism, accompanied by a comprehensive selftest for bug
> reproduction and verification.
> 
> The fix is originally from Kunkun Jiang at [1].
> 
> The identified bug manifests as a failure in VM suspend/resume operations.
> The root cause lies in the repeated suspend attempts often required for
> successful VM suspension, coupled with concurrent device interrupt registration
> and freeing. This concurrency leads to inconsistencies in ITS mappings before
> the save operation, potentially leaving orphaned Device Translation Entries
> (DTEs) and Interrupt Translation Entries (ITEs) in the respective tables.
> 
> [...]

Taking the immediate fixes for now, selftest might need a bit more work
(will review soon). Note that I squashed patch 2 + 3 together as well.

Applied to kvmarm/next, thanks!

[3/5] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
      https://git.kernel.org/kvmarm/kvmarm/c/7fe28d7e68f9
[4/5] KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
      https://git.kernel.org/kvmarm/kvmarm/c/e9649129d33d
[5/5] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
      https://git.kernel.org/kvmarm/kvmarm/c/7602ffd1d5e8

--
Best,
Oliver


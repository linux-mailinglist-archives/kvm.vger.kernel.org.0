Return-Path: <kvm+bounces-20326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED41913591
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 20:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAEC1B2103B
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 18:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7772D60A;
	Sat, 22 Jun 2024 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uw9GAdys"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B8F17C69
	for <kvm@vger.kernel.org>; Sat, 22 Jun 2024 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719079907; cv=none; b=Pi35LUwS9wBFInmCcF04+QKrjjMStTNbnoyKCkpdHTM1atZTApSRzm0jePzMTymKf9EcmXQQzuZh9OqdxdA0tCbkHWIKEWIeppw+CCpZwLj7VROKBJZN7gD3hz18xLgbhes0D6OkdMe7pE4A7zvmi4iFUAlxsxjEjUrerFZklQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719079907; c=relaxed/simple;
	bh=d2LNPAq7fK626gKlLPB5CXfTr0T/bJfbrXYCQHghlME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TCcCDdQno8J0HIAHs+w+H63ZEB9rj1TH1mATnkv+lwj5Cd5QiE6NK2Y/YGP2dYLrx4Pmujgqd3XawphPTbY/QBCWSHhyxQpbh3evI9M2fDhHXFWgaAkDXR0vmz+BYTqvgScDk09Zg96S4xDOsI02A6OSX80s6yrJghEcfQNSqGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Uw9GAdys; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: oliver.upton@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719079903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UiCNktgQ2BGKd0x5MWOPZUe5B4f2UrwqJVUmPmayKdo=;
	b=Uw9GAdysZxt+dEoCEq8ueSLIVztZzklnQ5H2gDt5Q4tQzsSd6DKkRxFCdUxaK1O6UtGqs1
	iSipPMc6Sl5059DYkU4CQQoHs++8zpp0w3XhYe91yAR/cZfcwlKadroPWxuIfdzn4DjgwR
	zmTuSbRG2PhjmCuw39fm+QxvBnbiHEE=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvm@vger.kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Assert that MPIDR_EL1 is unchanged across vCPU reset
Date: Sat, 22 Jun 2024 18:11:33 +0000
Message-ID: <171907984340.2922035.15334849502762820051.b4-ty@linux.dev>
In-Reply-To: <20240621225045.2472090-1-oliver.upton@linux.dev>
References: <20240621225045.2472090-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 21 Jun 2024 22:50:45 +0000, Oliver Upton wrote:
> commit 606af8293cd8 ("KVM: selftests: arm64: Test vCPU-scoped feature ID
> registers") intended to test that MPIDR_EL1 is unchanged across vCPU
> reset but failed at actually doing so.
> 
> Add the missing assertion.
> 
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: selftests: Assert that MPIDR_EL1 is unchanged across vCPU reset
      https://git.kernel.org/kvmarm/kvmarm/c/7ff163c26dd3

--
Best,
Oliver


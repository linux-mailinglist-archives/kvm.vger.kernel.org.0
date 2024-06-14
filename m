Return-Path: <kvm+bounces-19714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F127909340
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A03E288C72
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 556F11AB909;
	Fri, 14 Jun 2024 20:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="syFJwenP"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB51F1A3BB1
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718395964; cv=none; b=QVtebcySVO4fysl9XeganKlBNjlmB3cXDNEn1ktldxUnGIIPzwdyOF/os2W58bha9QXVraa39s/ZRhw/s8lj3l4Zu26lxOn3lh/EUc+m58Qr/15QD+ZAW+hUTsVCzoJWji5I7VT4xMRpfpwBChLy0hBeAQHxEpsMv2TQi94DFAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718395964; c=relaxed/simple;
	bh=oZjsCzFCbJSD90TB64x6dRc25o9iotk3a8IHULwKXow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NsufDqfax5DrNo8HliH8mSLIuFKYAyU9kkWqR8ZiyOa32dj18PQkKxA7Xpm658k9S/Qo2zadJoobEeEQ2XQynCBWLbMQDc/CWcDoedp1Hkpefn6Q9NL1BTxEzeE//ROc+uKP6pPHdWrV6iKr6uXHOjttaShk5eveg6da6cttU4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=syFJwenP; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvm@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718395959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JlzAV0tmpVS9NuQqVdxMb9B5p//nrTOGvG6Ai4IvREs=;
	b=syFJwenPeeak7hSSMKMLwZL81m+ePkBBHaS88KUSdJ3IhWHgAvtbK4RaSAd5ksvuUokrBu
	JCaO8vOXIjvQAZux9Bv5r2803jHdojWysiGeEFXCu/St5gty1Fhv2gF++eqRrM9e/Ou7hK
	rxahccN/Lz37K1s2xv2ayoNXr5bTd+I=
X-Envelope-To: coltonlewis@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: linux-doc@vger.kernel.org
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: corbet@lwn.net
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvm@vger.kernel.org,
	Colton Lewis <coltonlewis@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-doc@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v6] KVM: arm64: Add early_param to control WFx trapping
Date: Fri, 14 Jun 2024 20:12:27 +0000
Message-ID: <171839594069.633615.6902666817551787618.b4-ty@linux.dev>
In-Reply-To: <20240523174056.1565133-1-coltonlewis@google.com>
References: <20240523174056.1565133-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 23 May 2024 17:40:55 +0000, Colton Lewis wrote:
> Add an early_params to control WFI and WFE trapping. This is to
> control the degree guests can wait for interrupts on their own without
> being trapped by KVM. Options for each param are trap and notrap. trap
> enables the trap. notrap disables the trap. Note that when enabled,
> traps are allowed but not guaranteed by the CPU architecture. Absent
> an explicitly set policy, default to current behavior: disabling the
> trap if only a single task is running and enabling otherwise.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Add early_param to control WFx trapping
      https://git.kernel.org/kvmarm/kvmarm/c/0b5afe05377d

--
Best,
Oliver


Return-Path: <kvm+bounces-23644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 704A394C35E
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 19:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03AB1B257DC
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96951917DE;
	Thu,  8 Aug 2024 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fqp/ny5y"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6706A19049C
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 17:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136937; cv=none; b=LsMVzE4jUIMEV9E6Uu0l7xFy0VACM/seuLBNuAITgycusjSGt4Z1snlQy92TcdZhMN55OKbnlcjTHh4Q+ZYX4AX9Yk/mCDy6j00eTfEXLW9k+Wp6lVNv+63oSJf8STwx+4nW32q6Pq3Z+kMF1nJe6c9rZMMPv03B1wyK5Tv4H5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136937; c=relaxed/simple;
	bh=o0ouofDivzDbVdCcNXL0wzjNSLS++RMw3fLPLc5jUAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tRKSfVKCWrjEhbxmeXpC2/kryHYnoz6bmXhsdI0nUmpE/hjlx6Hrj/C67QETEB9ltKGlFMCxNyceHnZOrV7+0e+TTWhGnHdID4jb3y3RTt1MuVXSoZb7UbZRbwuhonE67Vv2KuK5U815aYudCdT8OVT0rs/9BxWSI/HOxYys8SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fqp/ny5y; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723136933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=679sHMsabQp1CD97OrRjCvkbuEAESk7cJl/f+me4pGY=;
	b=fqp/ny5yotKGef+lDwkniatECMpL5V1HO51qnVHw1IOlkhI8j9MPnDy4v/e6fscj0wd6MM
	qAMExeEQ0gV0CmX4aRfZxORSBK7GGuV9LeW2JQ6EBSlgXQ2r/LNMaOUIUDyTDuPFppxBFQ
	1rSibq3s456e34UwcxlszZEp1kS2c1A=
From: Oliver Upton <oliver.upton@linux.dev>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: arm64: Correct feature test for S1PIE in get-reg-list
Date: Thu,  8 Aug 2024 17:08:40 +0000
Message-ID: <172313677522.561165.3929802952412744723.b4-ty@linux.dev>
In-Reply-To: <20240731-kvm-arm64-fix-s1pie-test-v1-1-a9253f3b7db4@kernel.org>
References: <20240731-kvm-arm64-fix-s1pie-test-v1-1-a9253f3b7db4@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 31 Jul 2024 17:21:13 +0100, Mark Brown wrote:
> The ID register for S1PIE is ID_AA64MMFR3_EL1.S1PIE which is bits 11:8 but
> get-reg-list uses a shift of 4, checking SCTLRX instead. Use a shift of 8
> instead.
> 
> 

Applied to kvmarm/fixes, thanks!

[1/1] KVM: selftests: arm64: Correct feature test for S1PIE in get-reg-list
      https://git.kernel.org/kvmarm/kvmarm/c/ad518452fd26

--
Best,
Oliver


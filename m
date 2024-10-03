Return-Path: <kvm+bounces-27857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B51C98F64C
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 20:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14E6CB227E1
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 18:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296471AB536;
	Thu,  3 Oct 2024 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJyYLdSD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47132182A0;
	Thu,  3 Oct 2024 18:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727980714; cv=none; b=hJPm0I4nbCdbaOTe3G8ufmTDZJQqafOhTt8pDLwzvMR8rASneILNMlWTMS3Y/BFbDpy49KIfwuoDuZqQRPt+GfQEwvxk4+Lj2s8q52GobkmkFGrwDFI0auPd7XkjTYLWX3yBTPoRVrw02zxjKEMNb/wEZaPNaqr3kZOxnyWuu0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727980714; c=relaxed/simple;
	bh=HjXKANVGbR9/XIdYwve4xbFnazJINYmdGpGAKFctDz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZB1ilm0Ci1rihcThZMxfm2NT0pybYb9jYgA1v7cLDCMd+Jc4Ykhhmu7MmDjg6PQ0Fw5bYBPQIKgoHG+NyG8cMamdUJqqQ9mS/6psRuzR8SU2lbHhwYNJHjtf9dL6Phgrg5yF5hX421MnBRzcDkDDyGUyOB1ZfZVi7NdvP6STxtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJyYLdSD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F173C4CECC;
	Thu,  3 Oct 2024 18:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727980713;
	bh=HjXKANVGbR9/XIdYwve4xbFnazJINYmdGpGAKFctDz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJyYLdSDEHeuhIp/aW0XL7sB2W7uVX3CTYbIGWy4GixjAO11dTzf6g/HSOdz+t9bT
	 hZLX7/v0GZfkywiGGPDEjrpd90anAjwDI+9REv62qqpUb89NFpsbX9XgI+fr4IaWO1
	 x9vKCmg6LRdsjKaUgVVjmREBLSKI/oFa9YjD/pNAqTZjyOOU9qTek1mkO+NazOTPkT
	 m1AEFWVDMSKxeUxwI4j3N3T2ltPRGuIuggxWhmUxeg8wEFKN2U8kGOinMxTxQXObZf
	 siTr2WQSjXNp6HWLr+6j3jR37fRmoqQFd2v4c3SnBh/r5cL5p3p7OmWhtA0uP0vmhv
	 x0AfMaMbtJi5g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1swQid-00HVnf-3z;
	Thu, 03 Oct 2024 19:38:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix kvm_has_feat*() handling of negative features
Date: Thu,  3 Oct 2024 19:38:19 +0100
Message-Id: <172798069153.2061073.17930897656296989464.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241002204239.2051637-1-maz@kernel.org>
References: <20241002204239.2051637-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 02 Oct 2024 21:42:39 +0100, Marc Zyngier wrote:
> Oliver reports that the kvm_has_feat() helper is not behaviing as
> expected for negative feature. On investigation, the main issue
> seems to be caused by the following construct:
> 
>  	(id##_##fld##_SIGNED ?					\
> 	 get_idreg_field_signed(kvm, id, fld) :			\
> 	 get_idreg_field_unsigned(kvm, id, fld))
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix kvm_has_feat*() handling of negative features
      commit: a1d402abf8e3ff1d821e88993fc5331784fac0da

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




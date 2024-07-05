Return-Path: <kvm+bounces-21047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E822928735
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 12:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF5B5284E3A
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 10:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5626814AD2D;
	Fri,  5 Jul 2024 10:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ah0ECE6U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF3C148853;
	Fri,  5 Jul 2024 10:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720176870; cv=none; b=UdM7fcw+5HyVLY1GObipwC9fobJTdeoeweZGWVrIKIOK0b1ZOdBCwj7Uv3P/gWC1EP+rFQlcxRIp7XyxsXn03py4Htb1d5GSBgejUoEFE4Pa+MH2uyRvVnS2MX3n6nFpzDiUAAw/CyFvaS99etP/B9pgng8Ky8C9EAe0mBGwJRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720176870; c=relaxed/simple;
	bh=LwFcWS6a0T11fX+OPNLcDiC797vYG5zuq6mIL0BRjgo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uC5uqoi4mdDdorSGBhRxC7T9OuHhkG3VhXReABptrJNo2vqwpIU5KFVcQZFpA4QwUGIW3V5LssA/02azijz4YkmdnQrxdYkhA+vcBIK2QOelCAjHPxJUiP2qCyEfbrqU02nhuH1V7FhFjxNsf0NoNPAyBWQ1JhxP/NnyIr0i3E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ah0ECE6U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA47C32781;
	Fri,  5 Jul 2024 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720176870;
	bh=LwFcWS6a0T11fX+OPNLcDiC797vYG5zuq6mIL0BRjgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ah0ECE6UIFbNSOGG9+gFfYVTwFm3fmkJYAsXJueTumbQZkPehLLBYVbRKbdGHIauk
	 kOGhtocZCACL00SjSoxDcqohtBiTRzMJ3vJ8SXU1I0J6mgMmqFXpdEEGAHAd+R8ZC8
	 HlsqA6KFijyg8WK+uToeshCt5NnqCqV97w9jU0keIzO0g0/YPWHzpRb+OKMARsoM38
	 tzkdwTv59Wjn5rKbSP8sm9QE5f+Yn5un5EcvmJEcvP7PABR3ERs0jQ4ljQK2ejEpjj
	 n6PwwSkLUXvZunB406XTkbgKooNtbuBsKqoF46hG6OAls5LJWEbDBieMcf9Jxim3Ui
	 Z2OhiRxrF0VuA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool] arm64: Allow the user to select the max SVE vector length
Date: Fri,  5 Jul 2024 11:54:17 +0100
Message-Id: <172017597959.498066.14103615138386317117.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240620165702.1134918-2-oliver.upton@linux.dev>
References: <20240620165702.1134918-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 20 Jun 2024 16:57:03 +0000, Oliver Upton wrote:
> Add a new flag, --sve-max-vl, which allows the user to specify an SVE
> vector length for the VM. Just zero out unsupported VLs from what KVM
> supports rather than cooking up the bitmap from scratch.
> 
> 

Applied to kvmtool (master), thanks!

[1/1] arm64: Allow the user to select the max SVE vector length
      https://git.kernel.org/will/kvmtool/c/ca31abf5d9c3

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev


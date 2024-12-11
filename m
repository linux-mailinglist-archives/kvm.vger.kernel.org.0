Return-Path: <kvm+bounces-33534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25CF39EDC33
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 00:47:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EAF7281ED4
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F0A1FA8D9;
	Wed, 11 Dec 2024 23:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IzHdR2m1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C831FA246
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 23:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733960672; cv=none; b=Bj8pcnnKQWNKqzX/kmzyi7Gp0xilBeHGYACf9G8V1wgAYYYzJt8zfy3sOzfnjInAimF+4t82T3JrUCIiEdYJtHSOUv2Mc4SLvNBCkKZHJbs6YcPyJWF9NJDAEkiBbLX5Sp0F5QP5DZYlosH9NBexQCMIRoPqL/IJQh3ARMr9tB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733960672; c=relaxed/simple;
	bh=xJBiiy1dPiFUJHk2IsbVTTbIQ0bCNnysNMUiT3TuuTE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V579Iv0UvEu+3k7gFjFdxmFzbq8laKq/v60Z6sBO2X2llD5+vIWTvVnWx+UQ2cK7u/mNKxfi/UrlbfGGilDYkzvGT3cq7ThAAYbd5b5SOz5iJtw/Cf6dyc+SZR+2VWE5Xtk3Ggip5h9EZF9zBg/EEm0N3ZpzdI8vpFy82jFUshY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IzHdR2m1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198AEC4CEDD;
	Wed, 11 Dec 2024 23:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733960672;
	bh=xJBiiy1dPiFUJHk2IsbVTTbIQ0bCNnysNMUiT3TuuTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzHdR2m1cki3GjJDtv1GPpfN1MgcmhIUFaq1XjF/0qP/af5K1mmUkrI0cdZxHoEf2
	 XvvB2or7vEBtKidynLBlL9aSxVPjt4Ok5H7bzpEfvfGFsjOf3xEwVG2nz/i2AEcilc
	 hWch4cI930vyEbkhHXScoKbYysjDA8s8iPlE4E6neINIZL36fJvtI1gHSbpbTvoVxH
	 qu4MxPUGTEZrzYuvcQJjCHyA1JfjUGtTNi3FdvlMj3+uwrpqF3/1lm5TWnA/+AW0Ip
	 r4KCfgxqwuJKBrHpLnM2LUS0DV3c4uPY5JCcv6OFfI8IJco3iY4pyHjpG42LXyYhjt
	 GOrYLahHWaFpA==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Keir Fraser <keirf@google.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>
Subject: Re: [kvmtool] Reset all VCPUs before any entering run loops
Date: Wed, 11 Dec 2024 23:44:17 +0000
Message-Id: <173395914101.2740195.13361898570549964241.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241211094514.4152415-1-keirf@google.com>
References: <20241211094514.4152415-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 11 Dec 2024 09:45:14 +0000, Keir Fraser wrote:
> VCPU threads may currently enter their run loops before all other
> VCPUs have "reset" to an appropriate initial state.
> 
> Actually this normally works okay, but on pKVM-ARM the VM's Hyp state
> (including boot VCPU's initial state) gets set up by the first VCPU
> thread to call ioctl(KVM_RUN). This races boot VCPU thread's
> intialisation of register state, and can result in the boot VCPU
> starting execution at PC=0.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] Reset all VCPUs before any entering run loops
      https://git.kernel.org/will/kvmtool/c/6d754d01fe2c

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev


Return-Path: <kvm+bounces-8444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B42B684F8FA
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 16:56:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5367F1F223FE
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 15:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5AB77690B;
	Fri,  9 Feb 2024 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiR+0jbE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0181D762EB
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707494171; cv=none; b=onPP4N2szKqDeIkCZteOAoCI11osM9LeA+syG8LnGHrtJUVANvfwx+VZa8eunUHK0Pn2KnRI5SB8KUOVGqdIag2s/9+OgTkgBTue5qKkQPwy7fK9iCSQqVZTQG+hQ+wTcTyDSHcJrGiYeh+a+l+lzHLm9suLl8/4OnBhpPfTrGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707494171; c=relaxed/simple;
	bh=5ruIq9Z1B95V9A4yYLO0KncDaXEDujVQQ7/NMo3sDQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BgFU5WNmEzzrUcvyJQvWUzTm8Wv5CorHjK8IRAvjbLeH2AQ+KFeOVGdmpKgYhAgwGEarNH4fIIr5Nofhv9OagR6HNkM2bFY2a8dPzXpogglXWl+TYevOFK8THJnJOKnzQaUr5+MNKJAYz91RW7PbeMbz4QlI4mhvLVQAGNZXx2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiR+0jbE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E1AC43399;
	Fri,  9 Feb 2024 15:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707494169;
	bh=5ruIq9Z1B95V9A4yYLO0KncDaXEDujVQQ7/NMo3sDQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiR+0jbEztUQ4IPOw6SOOG8wEQ/ZfsOZixzuIM5iZUCbMFrnWJpRfZ2VzUD3m3u3O
	 iGzwD1rG3qeOMiGov/JoRGzF9Yf5Fwgc4017FDPU9y2AEg+CQwhn3f9oJMuJccRhpQ
	 tcDHL+XHu18M9d8z/C3GhZFhRAZHgYToRnzZyK6ddEkTV24Y6I4Jh3QycdV3spqd1C
	 6o060Bjz9iK4wtRBKX2qxh+6aYQeLBtzxnAkkha0l/iz8W3v2bB4SpwSLEAwP2PO+f
	 lymZ9cNPfPKVn6aPjPknkSNEcXMlZVRXyHI+vJXM7+8gg34vnb+3vKjQgaQmjRA5/N
	 gRgchcafb3XSA==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Tengfei Yu <moehanabichan@gmail.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool] x86: Enable in-kernel irqchip before creating PIT
Date: Fri,  9 Feb 2024 15:55:58 +0000
Message-Id: <170749367634.2620688.8531282626829963930.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240129123310.28118-1-moehanabichan@gmail.com>
References: <20240129123310.28118-1-moehanabichan@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 29 Jan 2024 20:33:10 +0800, Tengfei Yu wrote:
> As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
> KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
> support via KVM_CREATE_IRQCHIP.
> 
> 

Applied to kvmtool (master), thanks!

[1/1] x86: Enable in-kernel irqchip before creating PIT
      https://git.kernel.org/will/kvmtool/c/e73a6b29f1eb

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev


Return-Path: <kvm+bounces-58003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF55B844C4
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 13:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26F394A04C7
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 11:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5567303A08;
	Thu, 18 Sep 2025 11:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0khHQlQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC65D2FB603
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 11:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758193622; cv=none; b=CE4SEPgPvVAtqRizCZ7KUfeA9ZdV4Gnh+5m8n0xg62D33AoPAisTEf6kkdAJQP0nuW8lJSENcxlWbEJMoTFHQNRQSaX/uOp0pXbNSfmxCETq5moG14yiDcVSptpaqdXgFTg3mat1gN4Cfqu2CJXtasxUGtMlXPWL/9KYWawGczE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758193622; c=relaxed/simple;
	bh=8zoQyk7ZIHU3R0yvj0JLc7j/O+kQ2j21k4jH1agLrIs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mbehHwnXRiuBrlbstWeVOyHesHnYvPef3zV/57OwfVKZvbhZR2iAP5M3eglGujZMC3LCX19SfrhnI0kXarvUJoW3SLuj0eLKonWEd0w/IasXTYIS3nnIEPDEIc9n8SOhzQiXnaBTJD2+8+45SEf3rtdJlP7MP3am/0v6vCPfQc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0khHQlQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D497DC4CEFB;
	Thu, 18 Sep 2025 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758193621;
	bh=8zoQyk7ZIHU3R0yvj0JLc7j/O+kQ2j21k4jH1agLrIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0khHQlQEVYMsOPFNE6r++aXJt3GsOtojCI3lUaN9LoOrCOjknoOyMmrSGE8sBqEw
	 BOl1q9PQpXbT/QI+wRXDmflagwjMwc8Z4giOf/KjEqx62U+GYB+bDsgEQONRoe0E7G
	 LaLERXZ0emvKNBqZxvHZmRmIylZlWbEbP/WvX/7f4569i8IFIBDd4tfF7Jo14v1ggd
	 Sm3E4UE0c9XgiTtUAQwwIFqAJpCIcwbTEX1W3f79KCEeAjTdYzsuuQZhqBQojGigXJ
	 NOkb3L26Gx4T0JbYUtW7LRjOqYI48Xq0vblIkH171Co/xWMWPzHonT88Eh5zZvw4sZ
	 DXFPfzL+VP2nA==
From: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Steven Price <steven.price@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvm@vger.kernel.org,
	Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH kvmtool v2] net/uip: Avoid deadlock in uip_tcp_socket_free()
Date: Thu, 18 Sep 2025 12:06:37 +0100
Message-Id: <175819216846.1966959.14006241285843545065.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250917134414.63621-1-steven.price@arm.com>
References: <20250917134414.63621-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 17 Sep 2025 14:44:14 +0100, Steven Price wrote:
> The function uip_tcp_socket_free() is called with the sk lock held, but
> then goes on to call uip_tcp_socket_close() which attempts to aquire the
> lock a second time, triggering a deadlock if there are outstanding TCP
> connections.
> 
> Rename the existing uip_tcp_socket_close() to a _locked variety and
> removing the locking from it. Add a new uip_tcp_socket_close() which
> takes the lock and calls the _locked variety.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] net/uip: Avoid deadlock in uip_tcp_socket_free()
      https://git.kernel.org/will/kvmtool/c/7ad32e5514ac

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev


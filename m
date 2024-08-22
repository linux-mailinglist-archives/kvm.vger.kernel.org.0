Return-Path: <kvm+bounces-24824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 478B895B854
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 392C1B282B7
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 14:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A83C1CC171;
	Thu, 22 Aug 2024 14:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WM810YPM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E76A2745D;
	Thu, 22 Aug 2024 14:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724336713; cv=none; b=SN+uxDKvXiQBQCcM75VMj9fKR06wQnq1vUVqDfQcA/+/mvpJRhBgOdsgTtwaXIXfStz01RU/JIm0Y3ES9LhY4j9WS3mFuzk9YxOKqo+YSddBk7VIcngxUfzCajwAy+BoiVEnSohwLDwdBDKOyzLdksYAx/hz67Y1SBod1Fs96sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724336713; c=relaxed/simple;
	bh=Hg6q+tnn5kvyEJ3+bV7IGQeyJB8Q/Lrbkl69LbKKeKM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sbru1XZEEz5Ky7n4UZPzmyxnfA5IfC5lxRyea8j76fIK7wmOVRJfRHuCBj09VVI9qwG0WXDctKMwWxRoE6sEV+Xe+mp3Gl/Fb4mqst7xXpDsNzn7mlb+FmZsCOF41lIkXpv5tu0vxTTL0A3ktZd9G5Xxv7UfJ+lO69LBDNAsMQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WM810YPM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A572C32782;
	Thu, 22 Aug 2024 14:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724336713;
	bh=Hg6q+tnn5kvyEJ3+bV7IGQeyJB8Q/Lrbkl69LbKKeKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WM810YPM44xk0qpyIzf+0Q61XVDgz350sXFexFDiOLMpF5NJ6vrLljoDSXlj9mEiU
	 Vb1xW1BPwG+xjD2JukYHMOjcmk4Q4qL05g60se4gZh8ivFsNFa2tzxkQmu5KvpvGkC
	 5w5B8Q0SjYJAMLwPpzf5KtUEkvvCALGJFP/LY2XQiUTY3C3Mm5AXaw+pwm0K30jpx9
	 mqknvCVN6BJAq5g/Q+aBC/FB/GWZfTU+hrEcB5RrmEmZNboDMJH8ZXaUbVBES53Fgz
	 8jX6IS/Om9hJHeApWmKCF+gSvBurSN58tjUsbS+YsmbLIsDxJvQHFIOc0ROEHRpyub
	 5b+o+GacKvSLQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sh8kR-005yRu-7i;
	Thu, 22 Aug 2024 15:25:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org,
	Colton Lewis <coltonlewis@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Ricardo Koller <ricarkol@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH v2] KVM: arm64: Move data barrier to end of split walk
Date: Thu, 22 Aug 2024 15:25:08 +0100
Message-Id: <172433664072.3702537.8419277728828269501.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240808174243.2836363-1-coltonlewis@google.com>
References: <20240808174243.2836363-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, coltonlewis@google.com, oliver.upton@linux.dev, ricarkol@google.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 08 Aug 2024 17:42:43 +0000, Colton Lewis wrote:
> This DSB guarantees page table updates have been made visible to the
> hardware table walker. Moving the DSB from stage2_split_walker() to
> after the walk is finished in kvm_pgtable_stage2_split() results in a
> roughly 70% reduction in Clear Dirty Log Time in
> dirty_log_perf_test (modified to use eager page splitting) when using
> huge pages. This gain holds steady through a range of vcpus
> used (tested 1-64) and memory used (tested 1-64GB).
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Move data barrier to end of split walk
      commit: 38753cbc4dca431d4354319c7481f6bd1a212baf

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




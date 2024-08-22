Return-Path: <kvm+bounces-24823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4236D95B851
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED2C72838AA
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 14:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C4E1CBEAE;
	Thu, 22 Aug 2024 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzydcEVw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9904E1CB336;
	Thu, 22 Aug 2024 14:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724336702; cv=none; b=SMyYH3cFqRaG/fJXaP06HzmG4r74S6VM0AmeypdB5b5QMo8K7yXpVZyfMoGhKPbnP4UsPrqIdxiFUxHttMGfC/jeBVEu9JhCVgmwbiQSDVYk6YUvomcrwQwrWl1JRamFbPzVoEIsGkghqaqcC0Yt/MKDff0hFSNTEcaDpYbmv0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724336702; c=relaxed/simple;
	bh=//vs0/j3dL5aitkeEHYmbgKTgUS1rli4/RnXiCWDaiI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G8XhvBUopgg8DX0+XDFS5Sc+PoZYk+rycOF7rAHx/0eKnjCPC/F9cPS6xR++ZzMxMcxZaX0AgtgvLqYhQ6Vs0PtKdq9F9PIc4KyeifMNMXd4KWq4LcMtd1fRbhjIS755k7WLlaca1qDmOLKd0gP9lSZZDynwz80LwgdsxgZMdPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzydcEVw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C97C32782;
	Thu, 22 Aug 2024 14:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724336702;
	bh=//vs0/j3dL5aitkeEHYmbgKTgUS1rli4/RnXiCWDaiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzydcEVwqkNhOKyJ5orBT6Sxiv1o3CueKVoCZOlKhB05hbfqLL4sRKMuFCWl3Pw6u
	 RRseBCTvZyCyCoLYr0nNUMCuPOOIVvq5vPvNsK+Sq4f9+d1ZOsnRLFCwa/7/Svz+7U
	 UnNdivfK/+izhZv/9R4l2xx7bS71Lmmcj0fMTebbQaShjAZYSIeCBaUWBYmh0HwFMH
	 h0axtuuZBYajoYjtLRupBGNS0Cz7je99YbSxJY/5mRCFAyAQefFTDdwQgGNA25wZEk
	 z2NtC8y+9AZo4jIXZD72NHp9laSWfTbJqAhMdUge6Qe1Srqq43pkpMpq2NO5+/NSVR
	 Morx7oLq2+asg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sh8kF-005yRg-MG;
	Thu, 22 Aug 2024 15:24:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	David Matlack <dmatlack@google.com>,
	David Stevens <stevensd@chromium.org>
Subject: Re: (subset) [PATCH v12 02/84] KVM: arm64: Disallow copying MTE to guest memory while KVM is dirty logging
Date: Thu, 22 Aug 2024 15:24:54 +0100
Message-Id: <172433664068.3702537.15170661496841359831.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240726235234.228822-3-seanjc@google.com>
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oliver.upton@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, seanjc@google.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, dmatlack@google.com, stevensd@chromium.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 26 Jul 2024 16:51:11 -0700, Sean Christopherson wrote:
> Disallow copying MTE tags to guest memory while KVM is dirty logging, as
> writing guest memory without marking the gfn as dirty in the memslot could
> result in userspace failing to migrate the updated page.  Ideally (maybe?),
> KVM would simply mark the gfn as dirty, but there is no vCPU to work with,
> and presumably the only use case for copy MTE tags _to_ the guest is when
> restoring state on the target.
> 
> [...]

Applied to next, thanks!

[02/84] KVM: arm64: Disallow copying MTE to guest memory while KVM is dirty logging
        commit: e0b7de4fd18c47ebd47ec0dd1af6503d4071b943

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




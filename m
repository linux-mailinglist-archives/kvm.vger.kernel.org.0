Return-Path: <kvm+bounces-57535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1A40B57563
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 12:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3F4217B05E
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 10:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2BA82F9C59;
	Mon, 15 Sep 2025 09:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uy/MHun2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BD927280E;
	Mon, 15 Sep 2025 09:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757930392; cv=none; b=JEvEokX7dHtdazBusknmdhkMvdNzLiltyppqgn2V8q56WlTjOXnm9KX5bcHnmlW8iE/LOiee/qT/jLBCppAbdqlZ1mefO74ngRIxaIcLMRMV0PvLEoX1MZ8ZRG1weJf2DGmGj2UeKz0zx3mRQPb83KyhONnWF8jaHqw0f0HAOvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757930392; c=relaxed/simple;
	bh=l4ynf+cyA3et/jBfIs6nmkskoymLiWmJNcg7GsX/poE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZRevSz5V8qO6FPyfS9nKUtYrMy4/NjeGoHtVWS86BfoxN04cTum6hihhz3i8ieWiZAqaha2TQP3EQhMjLZtOsfDGny7ihniRSu6SFXT3Mih+SWgP43TvNl9Ct3UbZqS/hzBLY2bF9AuhZaZRLkj+NShaziE91YJcN+PKsaAd5W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uy/MHun2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E050C4CEF1;
	Mon, 15 Sep 2025 09:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757930391;
	bh=l4ynf+cyA3et/jBfIs6nmkskoymLiWmJNcg7GsX/poE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uy/MHun2rSdJxZa6W+MCEgBhv4wvxqBHqeTeX8aBkDsk7SjpQzhLu2ZmuBd8sRvGw
	 k6WEg1W0uAL8D54IUojGx/u3AcDyidyoPJbmxixZhFIasgGrg9M2tXB98MxOswe/CS
	 LzYjGfn2WNmKBO3aQlKuTyyvG15i5QEAt6gK2defuByZJsjI00ozMCwUrIaTAg/xvj
	 s/fQUHYdcOVNAVFxoSNvVqoOk8vFR8kOZP3S1kZqfFIQuK9SXtHILi3mgkbmZwoUCn
	 PuzVG0BYfEW9UF5gJZe7kvk1pKhSnCR/HMydjD0//XAiIvn3AzzwUunFXg5CBIAn0R
	 n+FdVAi50PnTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy5zx-00000006Jee-0iH1;
	Mon, 15 Sep 2025 09:59:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Keir Fraser <keirf@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 0/4] KVM: Speed up MMIO registrations
Date: Mon, 15 Sep 2025 10:59:45 +0100
Message-Id: <175793036859.521995.4956413640156757969.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250909100007.3136249-1-keirf@google.com>
References: <20250909100007.3136249-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, keirf@google.com, seanjc@google.com, eric.auger@redhat.com, oliver.upton@linux.dev, will@kernel.org, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 09 Sep 2025 10:00:03 +0000, Keir Fraser wrote:
> This is version 4 of the patches I previously posted here:
> 
>  https://lore.kernel.org/all/20250819090853.3988626-1-keirf@google.com/
> 
> Changes since v3:
> 
>  * Rebased to v6.17-rc5
>  * Added Tested-by tag to patch 4
>  * Fixed reproducible syzkaller splat
>  * Tweaked comments to Sean's specification
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: vgic-init: Remove vgic_ready() macro
      commit: 8810c6e7cca8fbfce7652b53e05acc465e671d28
[2/4] KVM: arm64: vgic: Explicitly implement vgic_dist::ready ordering
      commit: 11490b5ec6bc4fe3a36f90817bbc8021ba8b05cd
[3/4] KVM: Implement barriers before accessing kvm->buses[] on SRCU read paths
      commit: 7788255aba6545a27b8d143c5256536f8dfb2c0a
[4/4] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
      commit: 7d9a0273c45962e9a6bc06f3b87eef7c431c1853

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




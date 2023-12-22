Return-Path: <kvm+bounces-5140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EBFA81CA79
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D6A3B22309
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FEF41946A;
	Fri, 22 Dec 2023 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozj8B26r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A8118C20;
	Fri, 22 Dec 2023 13:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC7AC433C7;
	Fri, 22 Dec 2023 13:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703250203;
	bh=LTeYnVWVO19688eGDeLJfIhPFSZW0RSk+4muNm4S6z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozj8B26rdYFle2xz2A07Vm+LrD/eysLy/AxC7tBNN8uYlSLHybIS3/VBkACeJDzCP
	 oBjQMv/3QXVZlRdQ7Dsxed0NvP+UXa9tBTySYCYBmd78kIerYD7VaX0NoVOguW3CaP
	 MQJkc4Tqci9Y7JqtLnMih7B7jPJasUqt5WYUGJGevjuG98kjl+Od/vtYKJqEAthUv+
	 4NbeSNhCodbytHMo0vHAKhHrPQddWz2koXaDmdX64CRsgX6qtBrbOMz68IR1T2+lE0
	 aU7od2hAa+zMloJ/nk0U/gTlRYA92Aj+JkxR4NzKbKS71DHD9iXbbet2JrtX5opyjC
	 GBrsfar2Ejqaw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rGfBR-006JUN-6H;
	Fri, 22 Dec 2023 13:03:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Fix + cleanup for GICv3 ISPENDR
Date: Fri, 22 Dec 2023 13:03:18 +0000
Message-Id: <170325013513.3484045.6210383840599915735.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231219065855.1019608-1-oliver.upton@linux.dev>
References: <20231219065855.1019608-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, yuzenghui@huawei.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, james.morse@arm.com, jiangkunkun@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 19 Dec 2023 06:58:52 +0000, Oliver Upton wrote:
> Here's the alternative approach I had suggested in response to Kunkun's
> bug report, building the GICv3 ISPENDR accessor on top of the existing
> ISPENDR / ICPENDR accessors. With these changes userspace should
> consistently read / configure the hardware pending state for GICv4.1
> vSGIs.
> 
> Oliver Upton (3):
>   KVM: arm64: vgic: Use common accessor for writes to ISPENDR
>   KVM: arm64: vgic: Use common accessor for writes to ICPENDR
>   KVM: arm64: vgic-v3: Reinterpret user ISPENDR writes as I{C,S}PENDR
> 
> [...]

I have queued this for 6.8, together with my GICv4.1 fix.

[1/3] KVM: arm64: vgic: Use common accessor for writes to ISPENDR
      commit: 13886f34444596e6eca124677cd8362a941b585b
[2/3] KVM: arm64: vgic: Use common accessor for writes to ICPENDR
      commit: 561851424d93e91083df4071781b68dc4ba1fc5a
[3/3] KVM: arm64: vgic-v3: Reinterpret user ISPENDR writes as I{C,S}PENDR
      commit: 39084ba8d0fceb477a264e2bb8dfd3553876b84c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.




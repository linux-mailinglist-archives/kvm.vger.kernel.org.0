Return-Path: <kvm+bounces-19350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 206369043F8
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 20:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0C73B21DA7
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 18:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A6A79B96;
	Tue, 11 Jun 2024 18:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BTRFtU9P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E81770FB;
	Tue, 11 Jun 2024 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718131725; cv=none; b=tebZ9OnKMWyk1JhTbZXAUVNIz1i/sdnnbhvNS4Y3tX75FCxy1japaO4uF5TnCZ+7tbxyf5dE4n4RO1AoAVqK+KLIpozv6y/F95adYLfWMpZjesRE+Vk/a6MqdJBTdR7JRJ4CIzqGBYN7ZaMkAVtKIlGEYfj6pGvH+1N29UrmJmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718131725; c=relaxed/simple;
	bh=hRWx5SJxiiKahzoFPUFc8ibQil2+PBpFZC4cpktnZIU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xji9ZmKRVeGvKTjxMfwz9jpxXBvLNweSTKPwnwA2Z4vbCXgPCLq+9/s8+wnGs8kzPv/0Me2aK6Szeoc+BoV8TDy7QKIYNGa3Wl+AmVnnEi/2aXebZrSp3/01NIs1mXIDfFn/CcmdI9VZ8OAcjQ/t2bCFjG+Pb6HKaZYDAqlNAUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BTRFtU9P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9E0C2BD10;
	Tue, 11 Jun 2024 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718131725;
	bh=hRWx5SJxiiKahzoFPUFc8ibQil2+PBpFZC4cpktnZIU=;
	h=From:To:Cc:Subject:Date:From;
	b=BTRFtU9PIhQyd10OtLBhzOx4BPSdODDJDbIsD4Cp1tb3nXjJqsWSNHEgGdxmXyj1j
	 7Jc35Z2mndSVXhU60ngwGkTVyis2rfSNPGdRAhvg9skH4LKhmp63gf6UKD8ca71vmP
	 3qnN5OHUxJSLmTt21aHxscMW/E4zjo4uUVN+PTDvKGu/cIRgMcnfx8rLvzJkR9Fhil
	 fTAqCIs8tNuH1/kSeGjH7bccBOXUQhcBGcAzQ9zgLrg9MEHkcc7Tv+jA6ZLjGnnnqO
	 5vsg3gMfanj0HnYTdnzMRBAyWA4tvZM/+OP5hjrGV7vZ/EtCgvGw9n0kE+ERNBKHql
	 6eYu/EYYhzt0w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sH6Xy-002rzJ-Nv;
	Tue, 11 Jun 2024 19:48:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.10, take #2
Date: Tue, 11 Jun 2024 19:48:39 +0100
Message-Id: <20240611184839.2382457-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, glider@google.com, oliver.upton@linux.dev, sudeep.holla@arm.com, vdonnefort@google.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's a smaller set of fixes for 6.10. One vgic fix adressing a UAF,
and a correctness fix for the pKVM FFA proxy.

Please pull,

        M.

The following changes since commit afb91f5f8ad7af172d993a34fde1947892408f53:

  KVM: arm64: Ensure that SME controls are disabled in protected mode (2024-06-04 15:06:33 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.10-2

for you to fetch changes up to d66e50beb91114f387bd798a371384b2a245e8cc:

  KVM: arm64: FFA: Release hyp rx buffer (2024-06-11 19:39:22 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.10, take #2

- Fix dangling references to a redistributor region if
  the vgic was prematurely destroyed.

- Properly mark FFA buffers as released, ensuring that
  both parties can make forward progress.

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Disassociate vcpus from redistributor region on teardown

Vincent Donnefort (1):
      KVM: arm64: FFA: Release hyp rx buffer

 arch/arm64/kvm/hyp/nvhe/ffa.c      | 12 ++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 +++++++++++++--
 arch/arm64/kvm/vgic/vgic.h         |  2 +-
 4 files changed, 27 insertions(+), 4 deletions(-)


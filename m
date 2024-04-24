Return-Path: <kvm+bounces-15864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 959348B13AF
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 21:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51FD4284462
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 19:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0792378C8C;
	Wed, 24 Apr 2024 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Icj8gA8i"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D091CD23
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 19:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713987599; cv=none; b=C/zIBxkxRAGYfaiJUYQTV8BsIq51bTz4J7v8f0fPA/wpYqER/nBRkmwCgorPmJ9la4fbnLkeGdQ1UuU2C2BE0XMPMEyhGJ6GbcSL4L0uiG/z4xlH7xuWpYypJXmwPHylZirO5Si1iIfU1vp1/2rKTi/zPSvtI5LikhBN9WVma0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713987599; c=relaxed/simple;
	bh=q7Pkz/P5Q1r9S/MSK+iYJj9CNTw0dzw9TJVCoC1wWDk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SBPGc4uZOpksCq2QmkvT5uZz+vPMlMjwCfoFOoZeOAv4byL8wxW7kmVjYz8/MH/zyPIxLIZKtcT994PIblZgZXdKw+BCj34h5qR7eArEWePFU7AZrkIpN45nMR2dLoII51wcbfu9nDxCQQ2DuFGA7nEw7P6rUz/1+PrHA6iPQd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Icj8gA8i; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 24 Apr 2024 12:39:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713987595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=cnPjgTMvR9FofAPW9yyaIH0hPQvBC2RXg4lyU2FvoVE=;
	b=Icj8gA8i13X0T1evVK/wfxqWP6zSZZQozIiD6J9Qo7jPnDMvHGpeVJAFTK1wM7wiNQGbX7
	px9sJWpr5n6CpDcp67NgRCzDtv0nIPBMH1VdQPmsvqH349cpE7E9sRu8noljYBlHR5Gdr/
	LnknUHHxcWwtlWXTDg+0gKTs+1O6KBI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	James Morse <james.morse@arm.com>,
	Alexander Potapenko <glider@google.com>
Subject: [GIT PULL] KVM/arm64 fixes for 6.9, part #2
Message-ID: <ZilgAmeusaMd_UeZ@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

Single fix this time around for a rather straightforward NULL
dereference in one of the vgic ioctls, along with a reproducer I've
added as a testcase in selftests.

Please pull.

-- 
Thanks,
Oliver

The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:

  Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.9-2

for you to fetch changes up to 160933e330f4c5a13931d725a4d952a4b9aefa71:

  KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF (2024-04-24 19:09:36 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.9, part #2

- Fix + test for a NULL dereference resulting from unsanitised user
  input in the vgic-v2 device attribute accessors

----------------------------------------------------------------
Oliver Upton (2):
      KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
      KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF

 arch/arm64/kvm/vgic/vgic-kvm-device.c           |  8 ++--
 tools/testing/selftests/kvm/aarch64/vgic_init.c | 49 +++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 4 deletions(-)


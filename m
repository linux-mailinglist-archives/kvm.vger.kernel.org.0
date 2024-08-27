Return-Path: <kvm+bounces-25147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16897960B69
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B36951F231AA
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 13:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10FA21C6F4F;
	Tue, 27 Aug 2024 13:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ar4mYpLY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC0B1C6899
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 13:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764116; cv=none; b=fQj5oeaEleBZBc0sF3+ehNNtwKtHG27vzbDhRoRmO1o4Ttfv0o2bjoBJU9eB8N7qFqaNA5s0lbsse5faYIWR1hK7CkwTfxWxR/8Ay63EO90uiqAeCN92/gEJRht3Wy2NzoIRSQzuumfOBB+nDzb+S91jaxH9aYeWRUXYpifMvjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764116; c=relaxed/simple;
	bh=aXlqjOf+2RvyqEdGkHnp+gbVK7RCcBbO0Rx1Vr5MLN8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=osEmgCJnD7JNqfrfgOGCMNhwPN5bCHszarATMvETx2PJI6BwHN2brc2TrUz3muboMCMZ8g0rfkbP50pztSk+4tR5fI4AuHe+e6uajy4IXW6he8wMZEjpDbr42pAVfeihDzJvhTbFGlm/javSW0xakg+YWuPP70V9dghi2pnDwhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ar4mYpLY; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-371b97cfd6fso3505204f8f.2
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 06:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724764112; x=1725368912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vmhgoThXpsRE2ZPXF8R0CGdwPpFNc8Epv22ahkVAR6E=;
        b=Ar4mYpLY2SN+jFaDls2QYld+i4o1VZ42yk36K9B3dOAM59MgHVz9UQoAdprzkRB1ZM
         itMsXs6oaRXk46qOJms6eec2nGDpNbl1FW1Nr9Ca690yg1vICUk7xTunw4b6WrEl6OC/
         7wII5r+Zx+BRzisctCb2evp7lW7XRIDz3C+/EkfFnQaEXPJJh+RXiR7RRliu0dBBfxQa
         rw1DZAbH6OfjlD5HeSHHOWYeDmcvnonSMi/8yiJCUeJ/0RFrCjAudoxBsVLZVHWO1CpL
         NNMZRT+7yXA0ftqJk4i+Js/bnGq52JXK5EyBjIjrkYuT9ZqeCpdT+HFYWoTOFRq4cPEv
         dMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724764112; x=1725368912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vmhgoThXpsRE2ZPXF8R0CGdwPpFNc8Epv22ahkVAR6E=;
        b=hS9KNLrmrGnqrUl0Exh6Q3TD2BO7XkgTLOFjY61/D4ajTUrScEpwhHOaLIxrpEURxV
         Zs64KNV4nO6QY4+QMJtxh+vsacbcTnQkIvANR8gxov+8IFi+X3mKv3cijGztoyvSdybS
         3qRleykr9HWgge6pdnY/BEtOmke3VeCai5knD3K3lICSPiVqWHSrKyx34+msHgXUZq2g
         hJt+nVqyEtC01ru9B4wXcna2pX44zvcsXVwmiHcoNBTdTfS5YHOdbkV7d5akv9CDCKen
         Vp/oRIrtRIjPrmWGirvLAc+o0mZjk97XdRt1FzA9yz3CPvEi3fG424fK8d8Y+NVRQ2R9
         Ml3Q==
X-Gm-Message-State: AOJu0YxMfe0Qa8PVURfS98l/UV+zflPHik7cXXSjrNaIQXYqAj0XqJ/H
	OfoDZM8YU93qpL3iTnnqvZXXDYeUMbP1PIncDWqwYYId5YmzK0HEDWoJalXh95s=
X-Google-Smtp-Source: AGHT+IGHn0fUmNiXD2kqIU9eVqVFjdu3ykcNSCWApUcSFi9kVI2cR/nL4JnTMb6vecuV/AX0n7YrfQ==
X-Received: by 2002:a5d:570b:0:b0:365:980c:d281 with SMTP id ffacd0b85a97d-3748c81a115mr1892925f8f.45.1724764111532;
        Tue, 27 Aug 2024 06:08:31 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ac516252asm184573695e9.26.2024.08.27.06.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 06:08:30 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 0DA6E5F9E6;
	Tue, 27 Aug 2024 14:08:30 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	arnd@linaro.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 0/3] altra workarounds for PCIE_64 with instrumentation
Date: Tue, 27 Aug 2024 14:08:26 +0100
Message-Id: <20240827130829.43632-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

While testing virtio-vulkan on the AVA platform we needed to include
some fixups for its PCI handling. As far as I know these have only
been included in various downstream kernel repos:

  https://community.amperecomputing.com/t/gpu-support-for-ampere-altra/274

The initial two patches are as we found them save for a fix to
align_ldst_regoff_simdfp in the alignment handler. The third and new
patch is trace point instrumentation so we could see how often the
workaround is being invoked.

Combined with Sean's PFN patches:

  https://lore.kernel.org/all/20240726235234.228822-1-seanjc@google.com/

And the Vulkan/Venus support for QEMU:

  https://patchew.org/QEMU/20240822185110.1757429-1-dmitry.osipenko@collabora.com/

I was able to test virtio-vulkan running in a Aarch64 KVM guest hosted
on my AVA platform with an AMD Radeon graphics card plugged into the
PCI bus.

I don't know if there is any interest in getting these upstream but I
figured it was worth posting to the lists for wider visibility and
discussion. For now I'll just carry these patches locally on my AVA
until I get a better system for PCI GPU experiments.

Thanks,

Alex.

Alex Bennée (1):
  ampere/arm64: instrument the altra workarounds

D Scott Phillips (2):
  ampere/arm64: Add a fixup handler for alignment faults in aarch64 code
  ampere/arm64: Work around Ampere Altra erratum #82288 PCIE_65

 arch/arm64/Kconfig                 |  22 +-
 arch/arm64/include/asm/insn.h      |   1 +
 arch/arm64/include/asm/io.h        |   3 +
 arch/arm64/include/asm/pgtable.h   |  29 +-
 arch/arm64/mm/Makefile             |   3 +-
 arch/arm64/mm/fault.c              | 726 +++++++++++++++++++++++++++++
 arch/arm64/mm/fault_neon.c         |  59 +++
 arch/arm64/mm/ioremap.c            |  38 ++
 drivers/pci/quirks.c               |   9 +
 include/asm-generic/io.h           |   4 +
 include/trace/events/altra_fixup.h |  57 +++
 mm/ioremap.c                       |   2 +-
 12 files changed, 945 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/mm/fault_neon.c
 create mode 100644 include/trace/events/altra_fixup.h

-- 
2.39.2



Return-Path: <kvm+bounces-32752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 083A09DBA3F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 16:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 154A7166442
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 15:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930431C07E4;
	Thu, 28 Nov 2024 15:09:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2D11BD9FE
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732806593; cv=none; b=mps6FS2I+E+UmGURV8GTeS4BLWY/lu2o87c6P8I9DmdP6aglU2JWHQ+oPvo7G0JdeXdUeZ5KckxtfchWM1s4Qd7eL2aE2/InQWh5Y16E7QlkgM0TFwCo4EwXOJddhjZUTCP9LqK8XM3TMcUrmWxJ9mDSqmWNYwg6gP0qkah3h94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732806593; c=relaxed/simple;
	bh=XLYYqBbfwK6LRtPg4GRCMfrYpGXdC+J9JPrXltqBRO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uXrtX54zI1ifulTdGP3/E7XY6/YtJz3HY27fnJZ6vnyuF1Tst41udBPGDZEIZMOb6O5HbDged98A16PSYx2gM/aHFsAuXF9So85c/sIYWgxQ0Ebx2MQnOjudOCfPhu6qu6HP0OSfv3EmJYbTGzSBSmfPep4ZTbXzNSOpU/Rgoa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 164421474;
	Thu, 28 Nov 2024 07:10:19 -0800 (PST)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A8B03F66E;
	Thu, 28 Nov 2024 07:09:47 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	apatel@ventanamicro.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	s.abdollahi22@imperial.ac.uk
Subject: [PATCH kvmtool 0/4] arm: Payload memory layout change
Date: Thu, 28 Nov 2024 15:09:37 +0000
Message-ID: <20241128150937.10685-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first 3 patches are fixes to kvm__arch_load_kernel_image(). I've CC'ed
the riscv maintainer because it looks to me like riscv is similarly
affected.

Patch #4 ("arm64: Increase the payload memory region size to 512MB") might
be controversial. Follows a bug report I received from Abdollahi Sina in
private. Details in the commit message, but the gist of the patch is that
the memory region where kernel + initrd + DTB are copied to are changed
from 256MB to 512MB.  As a result, the DTB and initrd are moved from below
ram_start + 256MB to ram_start + 512MB to accomodate a larger initrd.  If
users rely on finding the DTB and initrd at the current addresses, then I'm
not sure the patch is justified - after all, if someone really wants to use
such a large initrd instead of a disk image with virtio, then replacing
SZ_256M with SZ_512M locally doesn't look like a big ask.

On the other hand, if there are no users that rely on the current payload
layout, increasing the memory region size to 512MB to allow for more
unusual use cases, while still maintaining compatibility with older
kernels, doesn't seem unreasonable to me.

Please comment, I don't feel strongly either way - I'll happy drop the last
patch if there are objections.

Alexandru Elisei (4):
  arm: Fix off-by-one errors when computing payload memory layout
  arm: Check return value for host_to_guest_flat()
  arm64: Use the kernel header image_size when loading into memory
  arm64: Increase the payload memory region size to 512MB

 arm/aarch32/include/kvm/kvm-arch.h |  5 +-
 arm/aarch64/include/kvm/kvm-arch.h |  7 ++-
 arm/aarch64/kvm.c                  | 88 +++++++++++++++++++++++-------
 arm/kvm.c                          | 35 +++++++++---
 4 files changed, 105 insertions(+), 30 deletions(-)

-- 
2.47.0



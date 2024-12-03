Return-Path: <kvm+bounces-32936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD889E2858
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 17:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B01E5B2E5BC
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 16:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C5281F8938;
	Tue,  3 Dec 2024 16:16:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from riemann.telenet-ops.be (riemann.telenet-ops.be [195.130.137.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7091F8930
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242568; cv=none; b=eHxmP68S8okFY2Gp7xKhndzN9I9ruiakuGK/Nu1b8OwcRscpPaIbOOxoPskVEorvYgTpv2/Z7hA0PfrFAqkR2DIutGfl9NQm0nSWp1o5dZbKHx6msda6e++95WFxY8x5bh5Fz2AZUY/vCTehVyn7Npzky1vk1fvhiAb8ZKo3fCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242568; c=relaxed/simple;
	bh=b1m9jZprQYUbRGlvvXUB8jLOLQ+kqPuuU7N6MrP7aXs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DGMX3iPXjKarhnJiqqrRIjmZSOcEsUCcWYLwuHkZ7jRW9sDRSN/RP8bDC4J7x34Rj6emss8q+fz4fWTS5lYNlzsdD1kv7oIF+H3jExz0aJIY1ZmdTmRNJvO+P3UqO7CCrHGSpgv2wj9x9SXkwfKbkSMpqq3h/lEZBuifeQMCalE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
	by riemann.telenet-ops.be (Postfix) with ESMTPS id 4Y2m3m2ln7z4x7N7
	for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 17:16:04 +0100 (CET)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:829d:a1e7:5b32:5d8e])
	by andre.telenet-ops.be with cmsmtp
	id kGFw2D0013sLyzB01GFwsi; Tue, 03 Dec 2024 17:15:56 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1tIVZ5-000DLE-T6;
	Tue, 03 Dec 2024 17:15:55 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1tIVZ5-00AGsi-Q0;
	Tue, 03 Dec 2024 17:15:55 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Damien Le Moal <dlemoal@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>
Cc: linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] riscv: Remove duplicate CLINT_TIMER selections
Date: Tue,  3 Dec 2024 17:15:53 +0100
Message-Id: <448dba3309fe341f4095b227b75ae5fc6b05f51a.1733242214.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit f862bbf4cdca696e ("riscv: Allow NOMMU kernels to run in
S-mode") in v6.10, CLINT_TIMER is selected by the main RISCV symbol when
RISCV_M_MODE is enabled.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/riscv/Kconfig.socs | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
index f51bb24bc84c6e47..d4ea91cdb2b138b2 100644
--- a/arch/riscv/Kconfig.socs
+++ b/arch/riscv/Kconfig.socs
@@ -53,7 +53,6 @@ config ARCH_THEAD
 
 config ARCH_VIRT
 	bool "QEMU Virt Machine"
-	select CLINT_TIMER if RISCV_M_MODE
 	select POWER_RESET
 	select POWER_RESET_SYSCON
 	select POWER_RESET_SYSCON_POWEROFF
@@ -73,7 +72,6 @@ config ARCH_CANAAN
 config SOC_CANAAN_K210
 	bool "Canaan Kendryte K210 SoC"
 	depends on !MMU && ARCH_CANAAN
-	select CLINT_TIMER if RISCV_M_MODE
 	select ARCH_HAS_RESET_CONTROLLER
 	select PINCTRL
 	select COMMON_CLK
-- 
2.34.1



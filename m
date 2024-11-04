Return-Path: <kvm+bounces-30566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E92E9BBDE9
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 20:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14ADC2818F8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 19:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4106A18C342;
	Mon,  4 Nov 2024 19:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pvbYbRDY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD52AD2D;
	Mon,  4 Nov 2024 19:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730748089; cv=none; b=se0vov4aV+fIjmF/D3rzoB24qQYKrMyG72U3DGssiDyhznsD2Go75b4aKjndRR9lfmTQb2BDHvFcQcglC5kgnj8YXOLbKXvq8bsttMmbYnnTTCcEJlpojvmvtlrMjNcF0O2MTb2FxBIoCbZ2WzK7zSwjKdqOvdXfmAM+7p5iy68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730748089; c=relaxed/simple;
	bh=srsnEmNy8EqgMWWSao2qd7ZIE1/ia9oFgHAob0jN4H0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d5w14LV0AbqTuknL9gZbnfjqmyb9ZFDJASILnRMQd5uNp8fH66GSHidixA2anyRYwZPPc/PxKOqx4xkuQm4BNwR/54z/FKdp6S1MEwpnSHnTDnucCfY0r/4ZhtBio1yRryBRLidXM8osZfku1NVIvLN204Y0cMyXEdhH9ICe+h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pvbYbRDY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF103C4CECE;
	Mon,  4 Nov 2024 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730748088;
	bh=srsnEmNy8EqgMWWSao2qd7ZIE1/ia9oFgHAob0jN4H0=;
	h=From:To:Cc:Subject:Date:From;
	b=pvbYbRDYTVEtjkRIfobR7lI+Lm0UsV7fRe5dpaxwKiy7kgbsn0ZAwDe/XWxTT/4/N
	 8qr405SaAlQwnh5gYtSTw8kbgAWU3EZeNTvV2LQDvZkcppMCyaFOsg+bib37lH+ahU
	 wvhKtmGeSSgzrSG+G26Z0ADcuKkZCGpHtdj8DGmJHas5Ly01H3VIglgN1QfKGZElnF
	 BEXlwydzHJYTgA2ucPLTwyIC05Drz/ZV7vYvDAtfCFoSDjj6ETBX+if2yc4CF1Hukg
	 GDW5czFAZu90rmOewRpVmGTXcmn6HTRufTV2DBQfpwIAmVNtxuv9o4KH+8ssVoHCsr
	 B12eapXcbatLw==
From: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH kvmtool] riscv: Pass correct size to snprintf()
Date: Mon,  4 Nov 2024 20:21:19 +0100
Message-ID: <20241104192120.75841-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Björn Töpel <bjorn@rivosinc.com>

The snprintf() function does not get the correct size argument passed,
when the FDT ISA string is built. Instead of adjusting the size for
each extension, the full size is passed for every iteration. Doing so
will make __snprinf_chk() bail out on glibc.

Adjust size for each iteration.

Fixes: 8aff29e1dafe ("riscv: Append ISA extensions to the device tree")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
---
 riscv/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 8189601f46de..85c8f95604f6 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -157,7 +157,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 					   isa_info_arr[i].name);
 				break;
 			}
-			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN, "_%s",
+			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "_%s",
 					isa_info_arr[i].name);
 		}
 		cpu_isa[pos] = '\0';

base-commit: 3040b298156e4e2a82b27ac8db5bd63a72b3785b
-- 
2.43.0



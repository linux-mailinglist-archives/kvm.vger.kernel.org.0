Return-Path: <kvm+bounces-36604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9919DA1C6AB
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 08:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AD293A7068
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 07:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5036E86348;
	Sun, 26 Jan 2025 07:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="IbhnvUTb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D0A73451
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 07:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737877145; cv=none; b=UV1jdfuY7d6IOblFfrcSnb8kxsaKXZSr3d1pEQ8XwIRXcZuWML2+hSPBC6ybbrzrhZ3VZyu3XybMX7FHwrg0paN08Fl0dxOyeO6Xe8ukChDO/e8PXr9X0DlUhxl4CdcjC6maoS1Gs+Qglt+pZ5zzunraT83y+gWijeyXTPiMPQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737877145; c=relaxed/simple;
	bh=8YafTq7w40QHvC+gSfIT9UR4k35eayUGfx9hKfudNRo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DuwaWFD7yMnG9reHVOW4NaMl6gPBYExrq83FZf+UvnwztL9cwgj0/d0iRXaTNfoxFi9+LbHah5zVOyK574mM+WZnwxDufryGmOCCxn7PbSdQy+8RBrHhE0mBHrHjrrow6n56yRNJxVRJgB6OP2iBbxxVWHIsdz2u5Y7Or8aFN+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=IbhnvUTb; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-2a3bf796cccso1626730fac.1
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 23:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1737877142; x=1738481942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+sVQcTr3DQ3Yj0RB9gfOGE03OWd92mmhsEHZSx5B4rg=;
        b=IbhnvUTbcEz/6MwEtRoA14ewI/jqYqwq0Zwq+Rbgzd2DDXxBarAL8n6AZDlHXEi8mO
         u+G9MrhPS2I8KVE3Q5BIdka8KpI7jIpRbqUkYPMbHcdEeaZoHp11u52Kqr8n0kRQ1uxY
         RFlWQ/VXI013Y0RFNYEHBhEi3Qav6tjPoHLHf6ay7KS6dyb/mAmiVFkCxlc5HENDamCl
         mtrUBE9WYX+qkjPfPCV6s9Gx57W0uwjePFvB6VBLXLbAYLKWfyRvoOWJuvXo1FPMx5k2
         wYf/1hAxSn1Dt7lNGeQE7LSh/xQB0TDuqGS7CUQZQBkrg1gi5InfGqTQspsNeL/1L7x4
         dwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737877142; x=1738481942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sVQcTr3DQ3Yj0RB9gfOGE03OWd92mmhsEHZSx5B4rg=;
        b=UkWcr5+71dPEiYBLbbs3uynloEpHmzASfChWvDZMK0hqDZXV5aevH6os3SKeT8NdSk
         55Lc2AcC+ekDHeqphZvuSBAqQ7OCqADmGNeRDdwCZuilNoSGm9Ab0Ap3MH2loZsJeVjB
         WjFRxhJqeKvDtUGk4Q6yjp7WMS0vh79LVQv01vnvpynppFFproQK85M5ZRWjcyYNn6Cv
         nhme9GiEvkKuQseRFBCabJXfe4VghGCXfV9/DP/1tPKr+OjTMTPXczUa2jmR6UykpXdV
         xdsxTPtPwQ/Er1CaTR0zhQlXZuCr4iNbF/9h+98VMkq0KQK+WIVmOw306kA21GVOKE5T
         Thhw==
X-Gm-Message-State: AOJu0Yzj79FBtnodXLbSw2UnYCe91NniX2d1SdlkGuinweoxPITHfmso
	3dxovGePzPQbirBr8DGyKd3Qg8n0d+e19HRTCRpOFE7rDgI3l1sJY6qgvlu8LGxzg6FSRIjz8mW
	YbuKKJA==
X-Gm-Gg: ASbGncuEWxCnrsGICfotyokrgD+ewybJVmWKVcIdRq57mXY/aTFNgchdCmtjDEV3iYR
	mLHElBZArxBvQsqG2I8gTKsPbcnYvst6GQvj285U7TyNFpo0SMzPl7jFxt2ojSRE7m7iDkwYwZr
	xrr1ke5SkH4iE8E3h3VYdZ/noow45hdlKeGnYr4HIxdOHnYXl7KB/Y4nZsNWOFi0f5M7LVEzaGT
	jNQNbs4d+ZwIU7jknV0LLXFBvZYgqgsYTAVfs+SItHLM74lax4OBqoXwq121Fgg6R7+WD7iHhx4
	r4kTAzjOGJp8WZjlq/mbXx+kEMrVJJyH6hED2yY=
X-Google-Smtp-Source: AGHT+IHD5IFzH7l4AMHQBOEFQuVKf9qPj2IuYiidipjsn6+oWElPCE6JEz5EruB32s2UFQH0TzMUkA==
X-Received: by 2002:a05:6870:cd87:b0:29e:60c9:9dd8 with SMTP id 586e51a60fabf-2b1c0c5455dmr24455952fac.29.1737877142358;
        Sat, 25 Jan 2025 23:39:02 -0800 (PST)
Received: from ausc-rvsw-c-01-anton.tenstorrent.com ([38.104.49.66])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-724ecda4c3bsm1547143a34.1.2025.01.25.23.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2025 23:39:02 -0800 (PST)
From: Anton Blanchard <antonb@tenstorrent.com>
To: kvm@vger.kernel.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	Anton Blanchard <antonb@tenstorrent.com>
Subject: [PATCH kvmtool] riscv: Allow initrd to be above 256MB on 64 bit
Date: Sun, 26 Jan 2025 07:38:43 +0000
Message-Id: <20250126073843.4005907-1-antonb@tenstorrent.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Anton Blanchard <antonb@tenstorrent.com>
---
 riscv/kvm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/riscv/kvm.c b/riscv/kvm.c
index 1d49479..191fc31 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -109,16 +109,17 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	unsigned long guest_addr, kernel_offset;
 	ssize_t file_size;
 
+#if __riscv_xlen == 64
+	limit = kvm->ram_start + kvm->ram_size - 1;
+	/* Linux expects to be booted at 2M boundary for RV64 */
+	kernel_offset = 0x200000;
+#else
 	/*
 	 * Linux requires the initrd and dtb to be mapped inside lowmem,
 	 * so we can't just place them at the top of memory.
 	 */
 	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
 
-#if __riscv_xlen == 64
-	/* Linux expects to be booted at 2M boundary for RV64 */
-	kernel_offset = 0x200000;
-#else
 	/* Linux expects to be booted at 4M boundary for RV32 */
 	kernel_offset = 0x400000;
 #endif
-- 
2.34.1



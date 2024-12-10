Return-Path: <kvm+bounces-33380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBC39EA74C
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 05:48:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4361167292
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 04:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DA6A225797;
	Tue, 10 Dec 2024 04:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="hskE8gUx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D65C168BE
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 04:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806107; cv=none; b=ohN+y4h9GjCs5o1+OE+OCPmX8WX471LiDSinb3YUCQURJhztxaVM/TqdyM8lx8xa8HvFoi3Acl6A3N3bmrKRJUWqCIa05Yn0zWmzrfJeJJxi++NnXbbogg5tS9nWvgcaDsKoKtjnLUlsLODeA1iAd1vXXy9WSFcTczUOzRKkef8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806107; c=relaxed/simple;
	bh=BoC6hfRPoA+q2+d8Xa5TDb+6ELV9ylSkk+RMaFyMk0s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d3/1qwFWAdKP2+MvpF+dSUsuJWw57WvzZ3j3+q3jXyc7mnJqbj9Xk+qtbvYNMBosWpMU6+THLv6GOCD9rMDM902/yRktHMixVQl9qJ7PqR4wGfctukbJqKIaJtJrZ12kGPZRxzNYiZoUmV7GiLcUorK5X7qa3medhHOGp3rH3os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=hskE8gUx; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a813899384so14936805ab.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 20:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1733806105; x=1734410905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ysm1oj54LWkmS3Az6hrYrQOTvuJO2dDRHsxTKTq5C7s=;
        b=hskE8gUxkhHzXh017LmxKY4CdAN/nCltQRzZIflOvRxUH0+VvtJHPjJt9FMpgWIuul
         PFpw0W7Go3Y9NtV+9hPTL3dSfqyWxQTpmDv8hay0qZ0ZadvTDjGXb9WiJ6+xVsMCj9bI
         IrbRElvUSWwzkAYA9vwAjI9BBN3ytav60S4YAIGs52Tl/Vc7uODnOzfdFZxtgaqIXDf6
         kdTIf5IRVIkOLiQW9RLI8nK5ChNU987HD/GjZz1uk39j2VT/+bOPh2rFHW/tSvOV6yrl
         LoaEGati1JAbtlZ696Bd+f7S5TvrOjQlxe13iZK/krlRU+dEAAMWeXUDFE8FSPKrfAp9
         vM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733806105; x=1734410905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ysm1oj54LWkmS3Az6hrYrQOTvuJO2dDRHsxTKTq5C7s=;
        b=ArVqR5SxlFPg9dQhC423egEBLXtbMQQxDW9bgAZIpKA5Ns+sMmNnLqMKcBfjgBWfd8
         /WZjXRxofDO2fjCEoZUTju/HD4fyyQeS5a1eKn8lpqgtMSBU+g7KdZGWxfrqE51WIxCu
         KMdffZca27Owrqn2h1GcHhwqBcIyhg+gykziS3LWeJ3ebCGxrTK64mMI46KFv9zTMCns
         VdGVifFn5qgnhc8A5ObufujOFRei0v9CLtF4443DZqvnRbliFvP591hCw3kIlLmtEXPm
         TIP7GwIeH1beXUyqCEMBp0+YAgrrsNAOrbFpJxbwT/iIq50an84MmGICtZbUcKqZyOnE
         U8LA==
X-Gm-Message-State: AOJu0YxQvXymF4uIegWz3f7ysk9Wkf/GtVlwBHDXY7P0N6FfNRZ+BlYG
	IG/9pjSG0wQrzLljVQfD7o6bFASw7/I6q6q1u0XUxe5UKblc91/012kVqe548atXmTL5FV7WAy6
	Fb1rDzJ4JIVaymMuasBOlTbc/NBZEUDzPFsRzGuZGZUX0wPpImXj39GE6Fl1UXFdlK2D7nbqBFg
	9p+XtrsRVclsxLu8Mg5PZE5gsuf5Sg3IJ/pPL6ZAzs
X-Gm-Gg: ASbGncsopYk+CKDWRztqAcjmJGBULO5ieKjfWZcVRxiDkEK3ESmu5Ap+lzK/DBVtoRq
	iAXjPhdHVGC39BOsLO6Zy60vZz5MsOrlaDnshqlq6DnYeLfy2N42LggYVRHTx1PFuc9pZ4CDHJZ
	ZkOJkLp/aMeLoVHeu4y0SM1phiU6sHCi4bQmiQU5wkTVTnODCvNAHSWCvKkp3ZyG6FBBOblePU5
	B4RMdHwUAcQ+CettZ5fk8qGExSOw02soFnrL0Adf1RulJ0OPWpFwXOnaRYUNnSG8d8KFSaK0+Ik
	hnLeh+q2ViVG4PwgfnfAVe8j4g5s4CM=
X-Google-Smtp-Source: AGHT+IERE6DRG5n7ThAchliHnKy1QucLXNXFxyYycaXTSbN67HveNVbpZkffrGj3539reoSg+f4IKw==
X-Received: by 2002:a92:ca0e:0:b0:3a7:708b:da28 with SMTP id e9e14a558f8ab-3a9dbb27698mr31437385ab.21.1733806104972;
        Mon, 09 Dec 2024 20:48:24 -0800 (PST)
Received: from sholland-0826.internal.sifive.com ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a9c9da809dsm17022405ab.4.2024.12.09.20.48.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Dec 2024 20:48:24 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: kvm@vger.kernel.org
Cc: Samuel Holland <samuel.holland@sifive.com>
Subject: [kvm-unit-tests PATCH 1/3] riscv: Add Image header to flat binaries
Date: Mon,  9 Dec 2024 22:44:40 -0600
Message-Id: <20241210044442.91736-2-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241210044442.91736-1-samuel.holland@sifive.com>
References: <20241210044442.91736-1-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows flat binaries to be understood by U-Boot's booti command and
its PXE boot flow.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---
 riscv/cstart.S | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/riscv/cstart.S b/riscv/cstart.S
index b7ee9b9c..106737a1 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -39,15 +39,29 @@
  * The hartid of the current core is in a0
  * The address of the devicetree is in a1
  *
- * See Linux kernel doc Documentation/riscv/boot.rst
+ * See Linux kernel doc Documentation/arch/riscv/boot.rst and
+ * Documentation/arch/riscv/boot-image-header.rst
  */
 .global start
 start:
+	j	1f
+	.balign	8
+	.dword	0				// text offset
+	.dword	stacktop - ImageBase		// image size
+	.dword	0				// flags
+	.word	(0 << 16 | 2 << 0)		// version
+	.word	0				// res1
+	.dword	0				// res2
+	.ascii	"RISCV\0\0\0"			// magic
+	.ascii	"RSC\x05"			// magic2
+	.word	0				// res3
+
 	/*
 	 * Stash the hartid in scratch and shift the dtb address into a0.
 	 * thread_info_init() will later promote scratch to point at thread
 	 * local storage.
 	 */
+1:
 	csrw	CSR_SSCRATCH, a0
 	mv	a0, a1
 
-- 
2.39.3 (Apple Git-146)



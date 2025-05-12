Return-Path: <kvm+bounces-46227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71621AB425B
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ED24863339
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F112BFC8B;
	Mon, 12 May 2025 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rg/YBA15"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDEA2BF981
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073137; cv=none; b=jaQIMq4KDySwkXTmzdMoq8PIESq0JBVEPxN7wN+uiup9s+msPkTuuDXIoYqQaN36KsqvvW8jykQfFvGR2AbNNGlyRqK9nYKOpD31uiR+/FclkMQ1U1l+IVTQDm85Bx5gGq7Zpaxz7xExwLDjbQlj087azW/6t7HyF89aSQwAYhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073137; c=relaxed/simple;
	bh=4VSma7tBGQnF8/QKFfrPJksO4he5ezXQE7tRteaFFz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+gCvMe1QW8ikZTAVfejYsD2TEWAiV4cFt5mRZ8irsVzfMhFcz5NOCQFBFZ+oe8tjE0j1J7ZJcSbCc3D79285idMLRK6zOKSJVg3ime8CNung1k8ni1r5jqqx0uJTd6Nszmjc9fP0xkFFehHglSol/qRdijxyM07DuzcJYxI7pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rg/YBA15; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b1fde81de05so3033636a12.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073135; x=1747677935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=rg/YBA151reXI7kLW0iaBXH+ylk0BB9gNbOYiraMmL3RquzhRaGdw074kERpDQK1K+
         Jo4rWxw979EIXvEATWCO6/ORsdntlwBW2krfgGUyHz2K4Q1i8+hs+IrqIJfuWEXzPBUT
         KgXWLj6gQCp4q9eV6NKOs6ow6qvGFqk5NoztIBeNbf4gSX92Q0uJ82h+phkZmfGcw29C
         DlMmVi81Bnxe/mcXybHnz/HnfyjyT88LldT9BgCYKm+guJdcRcNqW016ofGeQdjauF6T
         i80csPJWmyOdb04RShpQcUfhPejcUeGru0SVhYDRjWnpK8ZTGX4qO9MOz+3fTF+jaTTg
         nQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073135; x=1747677935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3Dpv/gYklKxQ6NcaNjklM8os0pkN4N34WBJsdRDY08=;
        b=iKuOxbKadp+dN1QD89v0rQPLk8ZGhRt7awfR+Rc9EdN7rebKG+RESq0TRrwjbz6gI4
         m2sqzuRg2d3FONOZvL0lZ6xASntO7S3Fb94ihPrPck2842RlHkU+xS/xJLgcoeJlm0JM
         Jkl1xz70RZ+bV5ERyd47sW1Sbg/jRBWeIfnsvFiZWk8TmwlLI88YGz1WehH4rCEQtdTQ
         ZVgCuTFV6UcTZtA6XNWUBZ5v6RExLvwLRD76rpAiH0gO8plQdSuSm/ClgdAzwkC4X6ae
         7td7FaFRJuqdgji7W54HlMIR2qFTJueE1A2S8KD8xvRTTAuWTqeZxUYCAUDtJMIilJeW
         JLMA==
X-Forwarded-Encrypted: i=1; AJvYcCXgyaWI3f6JpaKp0su3TeG2+l+IAQoYVuATYBIWBKEnBKj3O7uT+j1al9KdKPeDoRGA1kk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvhEjzT2ySJ7pV2IjDIgRx+B4gKHO0P78zNDqm9UaIAIu44Wca
	w6BEevFNLraVOJ6MNwRNMvdJJEqxCs5GDP/sHaLm1nV3UO9xGspJfkLE2QEiIVo=
X-Gm-Gg: ASbGnctiQQA7GtuuSjSJscAcNZ8rpmLMSq0Sfx3SuCZ7tE/9MY7epaRqTqfxtHb7TIr
	9g3e9C6PrGyRdlLeIePvIqi1JpWkz13xw9SMSTrAG7X82V1avKbhvTxPqGK20Rp2OI6ic8h+f0A
	FyyQbfIY34+4qrhaRzPxh3lx3M4xLn8f3nLvAlBM5uB3IYN7FpgEfLHQAUBbEMgikVlI8iXCXS9
	ohnoL1QAxs7fOkcZe+QX28vlbzF5B6ZskRzaGgjTk4bdFR7+5LrZB9r4KTdvuYaHcf2HYORp+J0
	yY1Zks1HDx8oOpCAFTTiwz4VTkt4P9fbZa4EAl+XAOlUii3wOWg=
X-Google-Smtp-Source: AGHT+IFWkB6Mkaeg18gGVG6rVCrQjmce5SbsAO0IjrI+eadfe3VGrlqawH9YWYf9Z1SF5DVoMnYAtQ==
X-Received: by 2002:a17:902:ecc2:b0:223:4537:65b1 with SMTP id d9443c01a7336-22fc9185f13mr185461285ad.36.1747073135057;
        Mon, 12 May 2025 11:05:35 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:34 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 26/48] target/arm/arch_dump: compile file once (system)
Date: Mon, 12 May 2025 11:04:40 -0700
Message-ID: <20250512180502.2395029-27-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 06d479570e2..95a2b077dd6 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -15,7 +15,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
-  'arch_dump.c',
   'arm-powerctl.c',
   'arm-qmp-cmds.c',
   'cortex-regs.c',
@@ -38,6 +37,7 @@ arm_common_system_ss.add(files('cpu.c'), capstone)
 arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
   'cpu32-stubs.c'))
 arm_common_system_ss.add(files(
+  'arch_dump.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2



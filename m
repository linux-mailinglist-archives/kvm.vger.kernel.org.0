Return-Path: <kvm+bounces-41104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C93FA617CF
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBDE817FF51
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A26A42046B5;
	Fri, 14 Mar 2025 17:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eSGFr3Sh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CABA205AAC
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973526; cv=none; b=qC2+W0QlgX8UOQ5JnhbxKPgCQwU7C/Qsem2WkxswxvQW61NfbXDzq4hFvAeWpq0QEy9Bp5zHO/N7ar7VPTpQn7Eip9LemxaC1UZFqSen6CxyOdT+BAE/QimQ0tXzC2KFt5PS1oLv6tvY6ylxa6eTkqv4s+HMPr/FrBDnhMARlnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973526; c=relaxed/simple;
	bh=8cc5k/dBJ8A5yXdLs7/Et5ghEBM8BXgwEWxHnVDm94A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n/vzfK1i1SBCD1lV20r67n/SmgSgFFHU5yA+jqvU9BCGOFOihoE5PWlSsb6p0XhbpcJPApO4gATEAQd7mnaODsGrUJz7Ct0lD8N9iBukPeSU3yBmwol1iUL4LXhbYAkGHyLG2o601Tk5XsIJcqY882JSBHZsQjP+5R7OuGLuF5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eSGFr3Sh; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-219f8263ae0so42502515ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973525; x=1742578325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdsNHldr91xnqdGHk1DTLXuYnmkD/cCe/HKmA2EoKL4=;
        b=eSGFr3ShLRdZlAx7spXqQneFZtWnU6H0Kelsafd+f6pxw5IQmHREzw8+YnE51L1eBj
         02R1usCY+WcZ59aE5Uet0CMU8MxqsomA2yuKh0tE3TGcKMDaq/e3hQY+VMHgywV8kLQ4
         qG1bqaqHugJ3Anb3BBx+41wl1I80kevuQNXuuuUAMbyE8Z89QXaBfKHlxBpe8sHDJWfE
         1IwjcQ0nKWRy3mWjO3ALLNPc/On426wQqFeY3qeCDYEhmHP0s3n7HokBR1Owi3TEVehN
         BV8a8inThlRQGXfcAh7jDoCwr81iOxUC4OGDr3ibQ/Sp4nmO9ifFbWZPlwmaQ9RQoARV
         u1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973525; x=1742578325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdsNHldr91xnqdGHk1DTLXuYnmkD/cCe/HKmA2EoKL4=;
        b=tcSVQZOx4hBlUS+iUySC0mCu6mNQYpeRP+0KJ/mTpDoGhY1nfrg0KrvaPjylqQn3al
         gkPj4So7jTgDJSBSYQPdRi0K4ABiTpfh0knxBSlKA6Ozk0Aomo0OqjRsyjb4IiAAzBBI
         biMy0OVrCFh6vW13j4srfOds78toQg5vAmzzjhpJ69wbhz3Two3FZMpTnF+ikRYC0Ymg
         WAtkXpTRVta6S9OJv7aOKH7rhvbgOHw62dAOhTWNcYPNXVeNDysu7VUT9dPcDzH5THtg
         L0V7NNAp8LY+xbvetP5uH2ipkh0nwT9G3VH2nBjwUc3oUTPU7KOF0UkH2Ua7jKFPZI3d
         F7Gw==
X-Forwarded-Encrypted: i=1; AJvYcCVb4D7Ne6Gdd7Mn3CEZ81MeigQO7hE84lK0vq9DE/yPkhTU4PXOjLHmQmRK9WQMnI/kBPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyM8DfaoNBNoLX1wgtgkMKwus1yuJyjhLhdtm5iNdpkdTez2vI3
	KSr8Y/Z2VQbe+07z558yVQ2q8it0uEJzxkJBy81C9RB2D+vkYa3A0TrDde/ncLY=
X-Gm-Gg: ASbGncufpisTcxHL5IBma+KpuaXJCopZSdFvcPl7BJmZpRvAlZWgQfj25bAaoYmk+/U
	0KgDWwMfob7L6yaDLjrxlYWUw4r7sCxl3DM6RLitqtT2XT9JeLYLR/Rk4z3+4VmmJFRUIutB3Fo
	+VhcoS56D4gmawkkNXCrTRNbvdGOeeDMq4nybvBF2oIW7GjhzHbGMVxPWPjKoXJ9EQzo9IQZS+o
	O3r/1qV4GB9RGlkuZDs3a79gMrapdzq9AG/Hp1WCHBjILzYG0mWtoHAZngqy+Ey612sjF4lDYJ9
	KY52G/MtFP83oqQHqrQoH/ejejSoRzBu/rg80IAphP0z
X-Google-Smtp-Source: AGHT+IHKE9NhNFaDqc44peROMWsjYJioKgZvs6KA5f3lAVTw3ISh5g4Lmu4Vqxy0jtgBCp9rXQffRQ==
X-Received: by 2002:a05:6a21:1f81:b0:1f5:75a9:5257 with SMTP id adf61e73a8af0-1f5c1174fd0mr5240657637.13.1741973524846;
        Fri, 14 Mar 2025 10:32:04 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:32:04 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 17/17] system/ioport: make compilation unit common
Date: Fri, 14 Mar 2025 10:31:39 -0700
Message-Id: <20250314173139.2122904-18-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
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
 system/ioport.c    | 1 -
 system/meson.build | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/system/ioport.c b/system/ioport.c
index 55c2a752396..89daae9d602 100644
--- a/system/ioport.c
+++ b/system/ioport.c
@@ -26,7 +26,6 @@
  */
 
 #include "qemu/osdep.h"
-#include "cpu.h"
 #include "exec/ioport.h"
 #include "exec/memory.h"
 #include "exec/address-spaces.h"
diff --git a/system/meson.build b/system/meson.build
index 4f44b78df31..063301c3ad0 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -1,6 +1,5 @@
 specific_ss.add(when: 'CONFIG_SYSTEM_ONLY', if_true: [files(
   'arch_init.c',
-  'ioport.c',
   'globals-target.c',
 )])
 
@@ -13,6 +12,7 @@ system_ss.add(files(
   'dirtylimit.c',
   'dma-helpers.c',
   'globals.c',
+  'ioport.c',
   'memory_mapping.c',
   'memory.c',
   'physmem.c',
-- 
2.39.5



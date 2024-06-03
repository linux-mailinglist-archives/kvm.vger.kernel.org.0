Return-Path: <kvm+bounces-18645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F61B8D8221
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C21DFB24FE2
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD3C12D205;
	Mon,  3 Jun 2024 12:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QDs10sRc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4137112CD90
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 12:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417250; cv=none; b=nHOStS8Ay993c+1GpGrIhv5YCpZVCK6h+bHQJEWidEfXUSiCy90xy7wVj7a46tY4fLec0GG/BTFvUlm2VJo+pmK2MRsT8KfFT5ycVKf6ZPkeLDNqRqAEZfUjNSY1ff3h+my1XvH0J0AIVCetVha/SUvgcnKNC5rQFZkF6lWsN+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417250; c=relaxed/simple;
	bh=0OTl7piyZBsnWVf//teBd1PS5I2DMLJjR2HcQPklrts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DPxqsEIabtgHBcqKM7cJ+hxrj7T+vWurgCOSPpd4SryD8fT6iWRpdAPp3989c0vAxhWOkJV3V8C3hPGKCMV67NUUzrzebHez4lgw5C5Kr1lI+xxp+0l02MV5w6eB/NsIaXoVxYdOKaSdSJ5YXRh6rmiXbrZt2d/GjmBz2YyOvYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=QDs10sRc; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57a50fecbadso1957938a12.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 05:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1717417246; x=1718022046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=27rKdg359rdAsUT0jKrlkOxqEm84mxGFROFso13NE9E=;
        b=QDs10sRcmM0B3enMMIdYjvSLTk2ijDyWf14oUnOfhCz1d+xTs2x6GvsbezhUSkMiSY
         c6PktU8qVgvF0kX0OL20sQYjtjHGbGVVKaMfIKzd7sNEEoR5fsaimPg0m1A/jDF8NAHW
         nO8wqw6GvCxZfdagqxPpQ782onxWb+1XlSosJpsezf8bi7V2hvMFiwiUrzmitTvGLRxP
         tXQ0mS77ey7228QW9x98i4t99IL/ODbKANfjxQHDQZlrJzcll+npZUGcYJVgTRDTH3oD
         nDeGUNXb2k3j3ef3vrTobEl2mNL+sdGmWXwhA8dE9uTlnM0+0gbk+0A94taeQstGWLRK
         kEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417246; x=1718022046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=27rKdg359rdAsUT0jKrlkOxqEm84mxGFROFso13NE9E=;
        b=RSY+DgMWElFSlrksNFpcPCOAK6i3YK0leYOU1p6R24i88tu6X4xlQwoZ0EUgnABjTN
         1x78Ol8zD0R7SwlSDKJMtjRk7o/EJ7/v4w4rLSmOqMi+I08VznWlvbEdxs8xBMzJr51O
         rwals17AsN4lTmbRpxgL7EyuDYBLU06hTFmORLAY9gxgfGKjF041hM49GtPUyDf8V/np
         sEe6GHn0TuL3DzjjDspkx7kCwqzw9DwaW3IQh/PHnBmTfv7mEa/aeR52ZJmcfdN93B3K
         WHhv18VR7wwXbRMeXKoWGNym7dJJBrYxa1NHg5eJgLmnH8pncFpxUOEgDsrp9cbTDpwy
         QnXQ==
X-Gm-Message-State: AOJu0YwAvgH8aWhM5DdjDClZe08O2N4zE0CXU5VXe0ktiOATlKK0F6/+
	pnyyDv4tH9URxcsT/wN9sO5swWhNDqeTb1O4XQklVDWoygfeUQzzBGr/orvzgCyTRxpJZL3y7cw
	mOo8=
X-Google-Smtp-Source: AGHT+IEgtrEMMThYOBaPONRCHaninn6lbzBd4MKREZ7U/9lXgHUSpw2KICuz08vw/4KuVYTIw++ILg==
X-Received: by 2002:a50:ccd3:0:b0:57a:21ac:cffc with SMTP id 4fb4d7f45d1cf-57a365a9e33mr4774756a12.41.1717417246390;
        Mon, 03 Jun 2024 05:20:46 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a6b05b199sm525492a12.45.2024.06.03.05.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 05:20:46 -0700 (PDT)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	anup@brainfault.org,
	atishp@atishpatra.org
Subject: [PATCH] KVM: selftests: Fix RISC-V compilation
Date: Mon,  3 Jun 2024 14:20:46 +0200
Message-ID: <20240603122045.323064-2-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Due to commit 2b7deea3ec7c ("Revert "kvm: selftests: move base
kvm_util.h declarations to kvm_util_base.h"") kvm selftests now
requires implicitly including ucall_common.h when needed. The commit
added the directives everywhere they were needed at the time, but, by
merge time, new places had been merged for RISC-V. Add those now to
fix RISC-V's compilation.

Fixes: dee7ea42a1eb ("Merge tag 'kvm-x86-selftests_utils-6.10' of https://github.com/kvm-x86/linux into HEAD")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/lib/riscv/ucall.c    | 1 +
 tools/testing/selftests/kvm/riscv/ebreak_test.c  | 1 +
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index 14ee17151a59..b5035c63d516 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -9,6 +9,7 @@
 
 #include "kvm_util.h"
 #include "processor.h"
+#include "sbi.h"
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
diff --git a/tools/testing/selftests/kvm/riscv/ebreak_test.c b/tools/testing/selftests/kvm/riscv/ebreak_test.c
index 823c132069b4..0e0712854953 100644
--- a/tools/testing/selftests/kvm/riscv/ebreak_test.c
+++ b/tools/testing/selftests/kvm/riscv/ebreak_test.c
@@ -6,6 +6,7 @@
  *
  */
 #include "kvm_util.h"
+#include "ucall_common.h"
 
 #define LABEL_ADDRESS(v) ((uint64_t)&(v))
 
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 69bb94e6b227..f299cbfd23ca 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -15,6 +15,7 @@
 #include "processor.h"
 #include "sbi.h"
 #include "arch_timer.h"
+#include "ucall_common.h"
 
 /* Maximum counters(firmware + hardware) */
 #define RISCV_MAX_PMU_COUNTERS 64
-- 
2.45.1



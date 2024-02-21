Return-Path: <kvm+bounces-9250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCFE85CEC4
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 04:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66DC7284564
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1521134CD5;
	Wed, 21 Feb 2024 03:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F5H9zgBP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6812E842;
	Wed, 21 Feb 2024 03:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486160; cv=none; b=faFu+UTgEQTDeoYYdK+yn0a3MXhTmi1iTMP7ZEGp2VZ49+ayT4jHdWCQndqwf2iVFCZQwsQ/EIJ01eULd5iWFFEnGnKjEneaj2dqhgTG2qaD54Gnp+U+y8dQ9mVTqqocVnFy3k0jQIyHBq6otD5PJBg/bZKy3HY+i5863msx5Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486160; c=relaxed/simple;
	bh=MEerVrBTKNNzcjobYPP0RyiwtXU/Fqyl+6g7hmECOc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDsCl70nA75HcZGtdsKaQUeTyllqRv3E60pFppwfiDJMEPh6sywvyc/DgaMfJL/ig82uRNhr1yJXAZFfMgpfaiAIb6YKjcQqeLlpVJgGOL+IeVGA8OwxwAHsU5zxKb2FJdtZbjOr2NoxD6EmAF0SRNygZlcK0LSSf2nnO4Piclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F5H9zgBP; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d911c2103aso35187175ad.0;
        Tue, 20 Feb 2024 19:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486158; x=1709090958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKTDdfNq5MGrQ+0iUWX57avIL8YHWFp0YDpAZCY+Suc=;
        b=F5H9zgBPHhRR6QAq4SvhqW7AODj8MecEWcRjuEZ4P+KUzl1yn0HzO7+TLAcUfD6nP8
         aoP8pxGkA0akTu7JmJ4d3M6rA7isiIrmFcRSxOwF5ER434rCf0omUGMnqCrso3MGk6C3
         nrTyq1lSYxAicbzU3FTxNdAzyx01yL1PpjH0VbVOgKqYF6WlKbHQBQHEmK5iFmGLJJ/P
         tHz1veL4DHhmOmfgg//8ogVfHVcqlQZmq4LINILPzL7AVQyOUBN+xyCs5FRacKSJiLAQ
         jpBjGKrnmOFyl4xRRN64RGmpcNO9SEieGjFPt+gy9d/GRFj6XyqLYSnneNBYhGNNLETI
         TIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486158; x=1709090958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rKTDdfNq5MGrQ+0iUWX57avIL8YHWFp0YDpAZCY+Suc=;
        b=fjgjvyzhxhcQEYjkn+56nDC8El9JZQAeaEx0PQ6zYh/CpbC9JLbbu57lxrKIOPdFRr
         uiFmiU1J7j974pioAHsDtfDJmS8f+Rbc9t0LoIMQyQazSK2cNgP0Z6uovBJh0JWtX64L
         Qig7YvtkptwR9Cq3A/3rV8kPtOmYxOkuPOHY4tG8tEGOP/Maf8qXWigUBAcuat0CSEWL
         cmdx7IEKVKu5P4fpFlYLonX+06UBJvlGcwFkHG+0REaYCC28Pn40P4dR9xOWg2vfVNPd
         YJsC0zlXFf6rnkb4TuE0hWe+CuQySOsEnsAdzupoCYH3g1nnVMFBjSVf6FH0Oml60Euy
         mVlg==
X-Forwarded-Encrypted: i=1; AJvYcCXx36Bm3oRWxPVKO8JJ05NatYaxDBunw8uTysbfVf7R/bseVdprzEzmvIvdO/8dw13xgIY6pMZI+9QrJ9+P8uOtb5sZAdqT/SqntNDKWVimS5cQHrY3nCUKtirM+MtZfQ==
X-Gm-Message-State: AOJu0YyT3dIn5l/ZsrMqc/OulF9eO953nuqv/XShk+3htvhvZ+f/xn/4
	N8cWfcvJor1rtZRAG5XoaDgiTzqGaLewncjLMDeCw4T189M5TSlO
X-Google-Smtp-Source: AGHT+IH1x5xMI9uoPg2lnHlSiQRJh3IyeLPtdt/kc7CIoeguyY7MUFojlqvGni7okVmY4JK8i1uByQ==
X-Received: by 2002:a17:902:ccce:b0:1dc:30bb:b5cf with SMTP id z14-20020a170902ccce00b001dc30bbb5cfmr558973ple.59.1708486158130;
        Tue, 20 Feb 2024 19:29:18 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:29:17 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 8/8] migration: add a migration selftest
Date: Wed, 21 Feb 2024 13:27:57 +1000
Message-ID: <20240221032757.454524-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a selftest for migration support in  guest library and test harness
code. It performs migrations in a tight loop to irritate races and bugs
in the test harness code.

Include the test in s390, powerpc.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com> (s390x)
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/selftest-migration.c  | 29 +++++++++++++++++++++++++++++
 powerpc/Makefile.common      |  1 +
 powerpc/selftest-migration.c |  1 +
 powerpc/unittests.cfg        |  4 ++++
 s390x/Makefile               |  1 +
 s390x/selftest-migration.c   |  1 +
 s390x/unittests.cfg          |  4 ++++
 7 files changed, 41 insertions(+)
 create mode 100644 common/selftest-migration.c
 create mode 120000 powerpc/selftest-migration.c
 create mode 120000 s390x/selftest-migration.c

diff --git a/common/selftest-migration.c b/common/selftest-migration.c
new file mode 100644
index 000000000..54b5d6b2d
--- /dev/null
+++ b/common/selftest-migration.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Machine independent migration tests
+ *
+ * This is just a very simple test that is intended to stress the migration
+ * support in the test harness. This could be expanded to test more guest
+ * library code, but architecture-specific tests should be used to test
+ * migration of tricky machine state.
+ */
+#include <libcflat.h>
+#include <migrate.h>
+
+#define NR_MIGRATIONS 30
+
+int main(int argc, char **argv)
+{
+	int i = 0;
+
+	report_prefix_push("migration");
+
+	for (i = 0; i < NR_MIGRATIONS; i++)
+		migrate_quiet();
+
+	report(true, "simple harness stress test");
+
+	report_prefix_pop();
+
+	return report_summary();
+}
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index eb88398d8..da4a7bbb8 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -6,6 +6,7 @@
 
 tests-common = \
 	$(TEST_DIR)/selftest.elf \
+	$(TEST_DIR)/selftest-migration.elf \
 	$(TEST_DIR)/spapr_hcall.elf \
 	$(TEST_DIR)/rtas.elf \
 	$(TEST_DIR)/emulator.elf \
diff --git a/powerpc/selftest-migration.c b/powerpc/selftest-migration.c
new file mode 120000
index 000000000..bd1eb266d
--- /dev/null
+++ b/powerpc/selftest-migration.c
@@ -0,0 +1 @@
+../common/selftest-migration.c
\ No newline at end of file
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index e71140aa5..7ce57de02 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -36,6 +36,10 @@ smp = 2
 extra_params = -m 256 -append 'setup smp=2 mem=256'
 groups = selftest
 
+[selftest-migration]
+file = selftest-migration.elf
+groups = selftest migration
+
 [spapr_hcall]
 file = spapr_hcall.elf
 
diff --git a/s390x/Makefile b/s390x/Makefile
index b72f7578f..344d46d68 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -1,4 +1,5 @@
 tests = $(TEST_DIR)/selftest.elf
+tests += $(TEST_DIR)/selftest-migration.elf
 tests += $(TEST_DIR)/intercept.elf
 tests += $(TEST_DIR)/emulator.elf
 tests += $(TEST_DIR)/sieve.elf
diff --git a/s390x/selftest-migration.c b/s390x/selftest-migration.c
new file mode 120000
index 000000000..bd1eb266d
--- /dev/null
+++ b/s390x/selftest-migration.c
@@ -0,0 +1 @@
+../common/selftest-migration.c
\ No newline at end of file
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index f5024b6ee..a7ad522ca 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -24,6 +24,10 @@ groups = selftest
 # please keep the kernel cmdline in sync with $(TEST_DIR)/selftest.parmfile
 extra_params = -append 'test 123'
 
+[selftest-migration]
+file = selftest-migration.elf
+groups = selftest migration
+
 [intercept]
 file = intercept.elf
 
-- 
2.42.0



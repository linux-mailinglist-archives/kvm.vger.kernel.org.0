Return-Path: <kvm+bounces-56958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BEEFB481BE
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 03:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 074FD3BED54
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 01:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9248619D8A7;
	Mon,  8 Sep 2025 01:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMp7bOMR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B07E18C011
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 01:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757293597; cv=none; b=emRqdK+nYoP9F0KbgcYjEICADJIGaPUMxruMnTIzagI7qLNAAW0LMLrN7o0cczeyplvRSgClbVsvBigZ2zO6JkrhEdhMLxZcrFuhnBKxS1OGlbS65WCwHs7aNRTdjCPGMAZtcSopoWCMAJbo1KoE0DK+m8vMeIbVriVoMO6imQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757293597; c=relaxed/simple;
	bh=bio4pdcHCPp1zZ8lKgKK7Vs/pziRaa9VrhR2wfiOllU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iTc5EJILWKQlf9NxDmzYHWIZjF6wYxIo/cl7Eb//VZsOYVk1HmkYB6yCy7vkHGA+9zetFh6RBm2B4/yu3pdD9JevYU95pB44PvGPMpk1yp1+eqHhZpDjaq/yCOnr6zUXJvitUNU4a3eGJz+0VhJ4qn9fB/gSyTr2mrA2x92mqU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JMp7bOMR; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-77287fb79d3so3075171b3a.1
        for <kvm@vger.kernel.org>; Sun, 07 Sep 2025 18:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757293595; x=1757898395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x52qenm9MurOag/X/RQfSuUteyrVwLaCULCgBiyHGAM=;
        b=JMp7bOMRo9VOXST+YfOWt5n9RwHfvYYbjKZluHynfgfOiTLIntSOkg7spXQELWf9XJ
         FJ6oSXyVRJ/p6D4zJeRo5vGnuyQKh4EdBX+XN9YO5815YUWuadzWYrBnNOxvi3KXch7G
         LqSyskzoNulU+lNsy2utLIjBkqijRxBZjL/sgg/L9kK85JvaYroJrsZFtMDaOWXAn1zF
         dF8niEZmwKfni5ah8GWAUkk+rtG34SeqNhepIK14FAywbvFTwgjFrH8KIKXcaPX5ijLI
         GjWDa4w5VFikO4ViUejpB6wqf2yXuc0GvA0RdkRlLk/dMpOir5JIsNehKWErXx3jxqzR
         PmUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757293595; x=1757898395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x52qenm9MurOag/X/RQfSuUteyrVwLaCULCgBiyHGAM=;
        b=DBD8092o0yHNjuuh9JYWcNxoQjIFxmGXjBrux7DeFLzr+7BbeWq7Xq5pwE3MJpyNDo
         hBfHml2d91oU17rf0eLuQSqAZ5tgSkAZghzTjxr9sIIDBxUseSw7tWGvDF7Q2LfPEgmA
         IFDDFNrUqDwxQE84ajAuQ3Bnz4xb+2+0JcOqCFEqjrwO+6xksAeYjPJ0IEAjVyQ8Ktea
         oByk+jnEJyyeJyC7B2/CBB+nYPBuJKJFQtBbsSfPt4beHx/DsVHloF6BKjHRu3Chp6LI
         Z6Ic9F2G2nIyHsN6onIrvntt5y/oj0pJeQrplVn2kZJxIe+5sSFe0n5fH1148iPfFTRs
         8jEA==
X-Gm-Message-State: AOJu0Ywnj/oyOngBY+6rbxyQ2EfprGwKdmNVQMhU6G6O+9ptg6eX1EtE
	621YX2qDdHlyvAlkmhyW7OI0qxuCnzki3RIrOZvapGHIAxGCYKG3PDOc+uK+3w==
X-Gm-Gg: ASbGncuaWfbBRT0Cchdke0AypFbvzZenSfWCykPGE0WBA43MQfP3iF+n5B3rFxwK23V
	JQpgxMRVFLJOo15oIMA5RHHQ0+KwqvahVe8OxhUexBuw5kbo8ydRjq2fOzn5xIzLkKRRMfAYULy
	26zz6LCwCht8oEi0aOOJMXworKvOs/XgQNKbFH1woNcauKSiIa68ICTxIN8yOZnNpUiflLovKCb
	lCmvrvc3/a1ssbcOzfv0lLLNsVIwo4xsFp9JqxFb3BeTW+UJfvR0AhJLhWlSkHnQHdrORqe4wfF
	W8UJJhl1KiHCPrE609hdud6YXfW6oyrDzR6nXSuMtH0y1aF2tSrkFazqMeWunB4P8o2htVMZpxS
	ZWzkkzyKyuJf4OcXocNWxgmgIJCRa797XX/TArlGHaM5OAiXxautv+uQL9dAHNVMVN+JXfCwIaZ
	d8dlI=
X-Google-Smtp-Source: AGHT+IGhd+DSL/YzHjcZM4C5VoWFKFpV0K7Mf8VKBLu8L5Kvg9oYpegFik4oLq3/jvMoCMPyPXR8JA==
X-Received: by 2002:a17:902:ec8f:b0:24c:ccc2:af36 with SMTP id d9443c01a7336-251715f34efmr75961665ad.35.1757293595122;
        Sun, 07 Sep 2025 18:06:35 -0700 (PDT)
Received: from lima-default (123.253.189.97.qld.leaptel.network. [123.253.189.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25125d76218sm49507775ad.119.2025.09.07.18.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 18:06:34 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm-riscv@lists.infradead.org,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 1/2] build: work around secondary expansion limitation with some Make versions
Date: Mon,  8 Sep 2025 11:06:17 +1000
Message-ID: <20250908010618.440178-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GNU Make 4.2.1 as shipped in Ubuntu 20.04 has a problem with secondary
expansion and variable names containing the '/' character. Make 4.3 and
4.4 don't have the problem.

Instead of using the variable name from riscv/sbi-deps and matching it
from the riscv/sbi.* target name, name the variable sbi-deps and match
it by stripping the riscv/ directory name off the riscv/sbi.* target
name.

Reported-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 riscv/Makefile | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/riscv/Makefile b/riscv/Makefile
index beaeaefa..64720c38 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -18,12 +18,12 @@ tests += $(TEST_DIR)/isa-dbltrp.$(exe)
 
 all: $(tests)
 
-$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-asm.o
-$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-dbtr.o
-$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-fwft.o
-$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-sse.o
+sbi-deps += $(TEST_DIR)/sbi-asm.o
+sbi-deps += $(TEST_DIR)/sbi-dbtr.o
+sbi-deps += $(TEST_DIR)/sbi-fwft.o
+sbi-deps += $(TEST_DIR)/sbi-sse.o
 
-all_deps += $($(TEST_DIR)/sbi-deps)
+all_deps += $(sbi-deps)
 
 # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
 $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
@@ -113,7 +113,7 @@ cflatobjs += lib/efi.o
 .PRECIOUS: %.so
 
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
-%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o $$($$*-deps)
+%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o $$($$(notdir $$*)-deps)
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
 
@@ -129,7 +129,7 @@ cflatobjs += lib/efi.o
 		-O binary $^ $@
 else
 %.elf: LDFLAGS += -pie -n -z notext
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o $$($$*-deps)
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o $$($$(notdir $$*)-deps)
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
-- 
2.51.0



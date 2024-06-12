Return-Path: <kvm+bounces-19452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CEE4905588
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 16:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 337ED1C21142
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E54717F36A;
	Wed, 12 Jun 2024 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HYkinj0l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7286517F37B
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203549; cv=none; b=KwT4yXHIThREZ2LOc/NdR/r8nhZ3abG7+ATarg1qAqWDdPwEQMkKE5XujicXa4wQzJgudA47OQ1qfvWtzgm0oxEwwD5ZE5TntfXkjc2pUbaYLvgbdRv/B2qBhfBidboUzGgBIi8nxmO1+AHh4El0BEk1pjHbKUmSwoqlkMkc6lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203549; c=relaxed/simple;
	bh=525iSHGFzySOaZcAwhFnWOytU105ryL3mUGYZQ5QysU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pfnG+8eyCz2yhYyOHW44na/tKYEc0xm5+Y6DTeyQKOb+5y4w618sD7DYnhXGugoB5NLlJbPmqXFn8uRMAS8rI+Ac5/WKU0WK9MBSHVZIchsdVM4E9zAOi+DLZ4sJa/IVugEJUQ3wbdgF07uyRvESECOaOOqZtyEVKghaK8v5Yyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HYkinj0l; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a6ef793f4b8so520436966b.1
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 07:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718203545; x=1718808345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1YT/fTmpSMXujBzLEc4hNbgDadAZjkCKYFp3Xm3T6C8=;
        b=HYkinj0lh8fa3fjzGKuadfv/lxmW/OcdKlASlFOcrZBEY1TjAMIW3FVTPLwpPqUmXD
         sS5XgxlxEYpl4Pzpe7ZIKMLS9zhVeK+KI4CQobHis9QZOZ47q4SE25tCIhGT80PjxLCq
         xiouioSCvOP6o5zHcwCQK6Ia9UJXjaleKMTdYfo8OnqHaqCmN83rf2g8drFFJ8G/5FLd
         bj9gLuF5283BQ5MLVkiacqICStLTvcz/Fe8vvCxRBNjkYnFc6jQFsp8ueSAlNRbkBnGT
         D/5kYZDXHL3/i4YPd8rT49WJn/5vLKh/H2S5laGTDFMIYddhK63k1ncXLF7mCM+KSvgY
         ND4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718203545; x=1718808345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1YT/fTmpSMXujBzLEc4hNbgDadAZjkCKYFp3Xm3T6C8=;
        b=MpkGyt/q/X9M/mUspOH6RFSNMC3jQb0Y9GfmzqWBTNIgpsx3etfPd5DinHX5e0K5vG
         OYeB+r6y00FtgvM5WnqeoPiVYtdBayT69WCUdlBom8nn77XQ4Wro2Ek/orP7Y7thLxPm
         Lwphzq6WAzrB+7/pF9FGO8UiW2uFi9ba20JzaVbZfAS/QljIl6BdjPYj6kALG/bSsptt
         ZX6YbLvrgT/Ta5NBWWv550/hBWy6t7mCdaEjdaW6lME64WvMhtQvn/5By1UaXhfizFt0
         IVEAkjT/wWSqmWY4qYhykknOi10Dfro81uJTnJcyE8b/uhqlyKgh7xeoSD0PT0aRWbVS
         5ibw==
X-Gm-Message-State: AOJu0YzU7mZBGSwQoefOg62IgccyZqfZX+k/1lJdcvcGB3jljU/5+K7L
	kvowMqhGnQBzDr2rfkvXdMknriBYTst80F6cUx+KJyhrfd1HnPGK3BPpyMQI
X-Google-Smtp-Source: AGHT+IF3Dmvm5FyZ4u7IQTdSKATxDOHsB+gY6z17NvuTfr9UasxwDEMkGeCCaufT/q5uaNO6LTMRjg==
X-Received: by 2002:a17:906:f6c4:b0:a6e:fe2b:7d58 with SMTP id a640c23a62f3a-a6f47ff27c2mr110409666b.63.1718203544915;
        Wed, 12 Jun 2024 07:45:44 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab7c:f800:473b:7cbe:2ac7:effa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f18bbf3cbsm456440366b.1.2024.06.12.07.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 07:45:44 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: vsntk18@gmail.com,
	andrew.jones@linux.dev,
	jroedel@suse.de,
	papaluri@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	vkarasulli@suse.de
Subject: [kvm-unit-tests PATCH v8 00/12] Add #VC exception handling for AMD SEV-ES
Date: Wed, 12 Jun 2024 16:45:27 +0200
Message-Id: <20240612144539.16147-1-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

For AMD SEV-ES, kvm-unit-tests currently rely on UEFI to set up a
#VC exception handler. This leads to the following problems:

1) The test's page table needs to map the firmware and the shared
   GHCB used by the firmware.
2) The firmware needs to keep its #VC handler in the current IDT
   so that kvm-unit-tests can copy the #VC entry into its own IDT.
3) The firmware #VC handler might use state which is not available
   anymore after ExitBootServices.
4) After ExitBootServices, the firmware needs to get the GHCB address
   from the GHCB MSR if it needs to use the kvm-unit-test GHCB. This
   requires keeping an identity mapping, and the GHCB address must be
   in the MSR at all times where a #VC could happen.

Problems 1) and 2) were temporarily mitigated via commits b114aa57ab
("x86 AMD SEV-ES: Set up GHCB page") and 706ede1833 ("x86 AMD SEV-ES:
Copy UEFI #VC IDT entry") respectively.

However, to make kvm-unit-tests reliable against 3) and 4), the tests
must supply their own #VC handler [1][2].

This series adds #VC exception processing from Linux into kvm-unit-tests,
and makes it the default way of handling #VC exceptions.

If --amdsev-efi-vc is passed during ./configure, the tests will continue
using the UEFI #VC handler.

[1] https://lore.kernel.org/all/Yf0GO8EydyQSdZvu@suse.de/
[2] https://lore.kernel.org/all/YSA%2FsYhGgMU72tn+@google.com/

v8:
- Addressed review comments by Sean Christopherson.
  - Moved architectural definitions to lib/x86/svm.h
  - Moved test specific definitions to x86/svm_tests.h
  - Moved get_supported_xcr0() to xsave.c since it's used only in that test
  - Removed sev_es_wr_ghcb_msr() and sev_es_rd_ghcb_msr() to avoid extra
    layer of obfuscation
  - Moved architectural definitions in lib/x86/amd_sev_vc.c to lib/x86/svm.h

v7:
- Rebased the patches on top of the current state of the test suite.
- Addressed review comment by Andrew Jones:
  - moved macros unlikely()/likely to linux/compiler.h

v6:
- Rebased the patches on top of the current state of the test suite.
- Rebased the insn decoder on linux kernel e8c39d0f57f.
- Add a line about configuration option --amdsev-efi-vc in the
  x86/efi/README.md file.

Vasant Karasulli (12):
  x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
  x86: Move architectural code to lib/x86
  lib: Define unlikely()/likely() macros in compiler.h
  lib: x86: Import insn decoder from Linux
  x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
  x86: AMD SEV-ES: Prepare for #VC processing
  lib/x86: Move xsave helpers to lib/
  x86: AMD SEV-ES: Handle CPUID #VC
  x86: AMD SEV-ES: Handle MSR #VC
  x86: AMD SEV-ES: Handle IOIO #VC
  x86: AMD SEV-ES: Handle string IO for IOIO #VC
  lib/x86: remove unused SVM_IOIO_* macros

 .gitignore                         |    2 +
 Makefile                           |    3 +
 configure                          |   21 +
 lib/linux/compiler.h               |    3 +
 lib/x86/amd_sev.c                  |   13 +-
 lib/x86/amd_sev.h                  |  140 ++++
 lib/x86/amd_sev_vc.c               |  469 +++++++++++
 lib/x86/desc.c                     |   17 +
 lib/x86/desc.h                     |    1 +
 lib/x86/insn/README                |   23 +
 lib/x86/insn/gen-insn-attr-x86.awk |  443 +++++++++++
 lib/x86/insn/inat.c                |   86 ++
 lib/x86/insn/inat.h                |  233 ++++++
 lib/x86/insn/inat_types.h          |   18 +
 lib/x86/insn/insn.c                |  735 +++++++++++++++++
 lib/x86/insn/insn.h                |  279 +++++++
 lib/x86/insn/insn_glue.h           |   32 +
 lib/x86/insn/x86-opcode-map.txt    | 1191 ++++++++++++++++++++++++++++
 lib/x86/msr.h                      |    1 +
 lib/x86/processor.h                |   23 +
 lib/x86/setup.c                    |    8 +
 {x86 => lib/x86}/svm.h             |  150 +---
 x86/Makefile.common                |   15 +-
 x86/Makefile.x86_64                |    1 +
 x86/efi/README.md                  |    4 +
 x86/kvmclock.c                     |    4 -
 x86/svm.c                          |    2 +-
 x86/svm_npt.c                      |    2 +-
 x86/svm_tests.c                    |    2 +-
 x86/svm_tests.h                    |  113 +++
 x86/xsave.c                        |    7 -
 31 files changed, 3898 insertions(+), 143 deletions(-)
 create mode 100644 lib/x86/amd_sev_vc.c
 create mode 100644 lib/x86/insn/README
 create mode 100644 lib/x86/insn/gen-insn-attr-x86.awk
 create mode 100644 lib/x86/insn/inat.c
 create mode 100644 lib/x86/insn/inat.h
 create mode 100644 lib/x86/insn/inat_types.h
 create mode 100644 lib/x86/insn/insn.c
 create mode 100644 lib/x86/insn/insn.h
 create mode 100644 lib/x86/insn/insn_glue.h
 create mode 100644 lib/x86/insn/x86-opcode-map.txt
 rename {x86 => lib/x86}/svm.h (72%)
 create mode 100644 x86/svm_tests.h


base-commit: a68956b3fb6f5f308822b20ce0ff8e02db1f7375
--
2.34.1



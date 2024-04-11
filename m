Return-Path: <kvm+bounces-14291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF98E8A1DD1
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DD711C24AFB
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B98758AB0;
	Thu, 11 Apr 2024 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+L6Ou9C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C345458211
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856592; cv=none; b=mKXpqR68YR09PVkkNJibk4Jvth4ATeoYIunuE9XUb34m6XcxXrheUx5iNh7D3Rlu7h9Xwkd7BHjli0lrAqL6DQY6o7PLeTww96QlezHKO90MQGjshRFlO7N5Dv3d1yyDgyF3VYTMRzgyJFdKQDlN711MieWrZgLychr59bNrLkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856592; c=relaxed/simple;
	bh=HERpBbaGXM3iI0arOPaVxSOfoWrmQS4jv1UIWtWYEqE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fOARqTgiMEd4mynJGbID4ngfbl526h0cZXEQnxnRNL8Tlrky/fA/cLwHvWiVVdXiUZ2dTu+zwEIb3Z16tzzT7+hmhR0afQbf7DZ7fEeGrlLMDyo84ld64MmRU6F8jgKsjJn0IzQt0QF3D7M0TwX6feMQtketgri4Bn29Shu/5t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+L6Ou9C; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-56e2ac1c16aso54405a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856589; x=1713461389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tIqyOtiyEDfcD/yE59IX07GFlegLUVRbDIlhCBW+IAA=;
        b=Q+L6Ou9Cpyl5TQHrrqBvbIYmBTcu/7XQ+Nfg9qkrs4SDwYLpNe/xDa93L4hXdwrb2c
         XbGMLvSMgiluhREpRZ381SveayACbxSewj0b8ED4HEeW+ePob+MLfjCk4NTevs3feqUP
         Tmyl4/BGpoyJZmBea8S8O0Fid3a+ijrhpvCOnfBlh4cTMNdGzGRA9QFrcWQbtGc1E6VW
         JrP78i2KMnTvEouB/mONR7P2jezrC0zDlwJlw+TyWYeUSBP0d0bv9fV03j+UqS4ZT4zm
         au74zpesTVJylZ1bI+BsMv0xUzeDfm2ZU6FR39RknQCQWYmDt4kEInchPAzAkXIVvmis
         Ywsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856589; x=1713461389;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tIqyOtiyEDfcD/yE59IX07GFlegLUVRbDIlhCBW+IAA=;
        b=QW37iaYzWw/6MDOktnGHczNFkoUT7nYFQnqCkp2CmhR7pAiqgazxqwSF7nIc9Bmux5
         eTWuviqsdzRLJT+J7Ze0QGn0fmRCmKMp64mszlLm3qbepkNrzKgai3IuvN/jNJurYHVf
         ltceNv73bbJlVmhk6vFpgIKYD1i8ypXScOvxOTFoz0Ok5fMwhOIvjmQyPDc5LyJoU6hL
         BFDZQmGQdDdB5oYybKVTv+UgcDM/8sNptYwBg1fIrKLJd+G98FNEPqO2EKk8LN2baVpS
         AQ4X2FgYg9Lt/fNH3kRgx2WhTIK7sab/or1GJOR735GjVYvcrRxiz9bKJ+PkV+AC7XqF
         MR/A==
X-Gm-Message-State: AOJu0YxVQ8NY4sK+yEkEBdofFiAVi+6jBUFswGkBntze4sDA54IUB17s
	c8YAQVRd8VICa1/Ei9C2o1GJSw9QgfNVbNgIM5INd2I36j3maeMpoUbZAA==
X-Google-Smtp-Source: AGHT+IH0SXdyxWxSXZ3B6ghxA1gOYH9NxfesJNPgs3elfszILuoteuRfA+ifjguFWZjKsQJk74twiw==
X-Received: by 2002:a50:9f88:0:b0:56b:a077:2eee with SMTP id c8-20020a509f88000000b0056ba0772eeemr304914edf.4.1712856588378;
        Thu, 11 Apr 2024 10:29:48 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:29:47 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	zxwang42@gmail.com,
	Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v6 00/11] Add #VC exception handling for AMD SEV-ES
Date: Thu, 11 Apr 2024 19:29:33 +0200
Message-Id: <20240411172944.23089-1-vsntk18@gmail.com>
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

v6:
- Rebased the patches on top of the current state of the test suite.
- Rebased the insn decoder on linux kernel e8c39d0f57f.
- Add a line about configuration option --amdsev-efi-vc in the
  x86/efi/README.md file.

v5:
- Rebased the patches on top of the current state of the test suite.
- Rebased the insn decoder on linux kernel b320441c04.
- Used the definition of struct ghcb and struct vmcb_save_area
  in the linux kernel b320441c04.

Vasant Karasulli (11):
  x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
  x86: Move svm.h to lib/x86/
  lib: Define unlikely()/likely() macros in libcflat.h
  lib: x86: Import insn decoder from Linux
  x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
  x86: AMD SEV-ES: Prepare for #VC processing
  lib/x86: Move xsave helpers to lib/
  x86: AMD SEV-ES: Handle CPUID #VC
  x86: AMD SEV-ES: Handle MSR #VC
  x86: AMD SEV-ES: Handle IOIO #VC
  x86: AMD SEV-ES: Handle string IO for IOIO #VC

 .gitignore                         |    2 +
 Makefile                           |    3 +
 configure                          |   21 +
 lib/libcflat.h                     |    3 +
 lib/x86/amd_sev.c                  |   13 +-
 lib/x86/amd_sev.h                  |  140 ++++
 lib/x86/amd_sev_vc.c               |  500 ++++++++++++
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
 lib/x86/processor.h                |   25 +-
 lib/x86/setup.c                    |    8 +
 {x86 => lib/x86}/svm.h             |   19 +-
 lib/x86/xsave.c                    |   26 +
 lib/x86/xsave.h                    |   15 +
 x86/Makefile.common                |   16 +-
 x86/Makefile.x86_64                |    1 +
 x86/efi/README.md                  |    4 +
 x86/kvmclock.c                     |    4 -
 x86/svm.c                          |    2 +-
 x86/svm_tests.c                    |    2 +-
 x86/xsave.c                        |   17 +-
 31 files changed, 3832 insertions(+), 48 deletions(-)
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
 rename {x86 => lib/x86}/svm.h (97%)
 create mode 100644 lib/x86/xsave.c
 create mode 100644 lib/x86/xsave.h


base-commit: 7b0147ea57dc29ba844f5b60393a0639e55e88af
--
2.34.1



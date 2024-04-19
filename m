Return-Path: <kvm+bounces-15330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B67238AB320
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:16:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A982281C9E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264F3130E4F;
	Fri, 19 Apr 2024 16:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y21HVUt2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC3E130A72
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543394; cv=none; b=F/5qRBolVApJaRvSsY9J/jWRwahLOMS6vWyeIfHk2JZdLf9L13hJInNZhN9ewldNUkDKJVCT8WutrF0c7IUC+xb74LvUY1sf1E2ALR3FPmdocf46g8N6Zaif9YVyzjWmy29TmZfmuJ2cjF2rXaum5eBxGCS7cfcnamxdX5VH5Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543394; c=relaxed/simple;
	bh=wHozWbyCboxqQli6i5EIrI0TRU37nrf2n3sNUvoDEPY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M5xSshUpphtXWFwYTQghUAUHZZvH+EGESKODKhXyrjjfNkC0E4uNUaLCFILV3ybpmhk4BmdPeBkpgeRWLz87V/OCCnMNfO7gnlxqTBFxsblQWQDJGNieUFks63VyOzSPo6fI1syDeyRQu4/FvrLV5B0zmq8xnaaYla/pn/37pE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y21HVUt2; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-418c2bf2f90so12901495e9.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543388; x=1714148188; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gHOtu3Ki1z1icjDiGhweLqZl3N99sfRSsSoi46JPnLk=;
        b=Y21HVUt205jCjlLYyzEhFt/LDg89qPKOYlesO3/p/iWRZ6OEk25O221mw4z50XnsEJ
         1wFrAwg0rqKiK/hVQu2p7CjZkqM5MOzkMFRhNLs3R7xpmofI9Y66yIDW6Ff3jZPvmm+Z
         XibvekLkoFEQNZVUSNOj5qhVnPiZVM6tELK68XjWhVd3GYcJFF00+SluMPrTGMx2cOvK
         v9gnVfmtyvFSRGb77wBmxnl9GJqxCVnbFNK3NeyFjUTIGKdxCw3KZeCdBviPvZaMndtN
         A+aD7zrBJtJ46QRCkrAbisMywCR1MeVpieb9Am7QePh9kDrYfemztSqZcI7A332/3drz
         qxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543388; x=1714148188;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gHOtu3Ki1z1icjDiGhweLqZl3N99sfRSsSoi46JPnLk=;
        b=BvKUmQ3uNde3aNxQg3vx62UuG9Nu+h4aIyNJshOyVukxMg3RAF/EaQ2eVD8ZhTpYN5
         IZ2I+qRpebkQ2bOoz/eu/BnUoQuTSqQAGFahnalhUbT3nhaKi7Ou1jwV0UyK5DJXsJJ/
         HE1qBg+uiu2f5j+7LxHUV679zWV3DWxklX0PoaQDQHDEORguG1Ut2lSH0YI/mqw9vyos
         ii5gTWMc2y5uX3s10ny4m8KzqSQw48C0HmwmiyOozD/MNaTCQd2WZ+MNBH2gb2FiDeYy
         dU7pT9nHw5grH5YnYbQZvOdK0KUOVeiUwuzZmzlM+5zQsmfY7bygeOcn45LhyUBQ7nZq
         JS6w==
X-Gm-Message-State: AOJu0Yydg3HUx4vUikztH3BDde3n/USYso37wd4Aq1CEkV5eohyYeYFv
	jNE5NslJUx/i0Go/I8CUi5Ho+YZKRw0XJP18jAwh0bHwai2bs8jNVHGuwSqH
X-Google-Smtp-Source: AGHT+IHNbVO7MeUzj90fsbleRNi/Yi7NVSrr1r8ecz7+P7kdjJGC+xVfisTlyIocdvBmEdza1kj6yQ==
X-Received: by 2002:a05:600c:4f4d:b0:418:98fc:a46a with SMTP id m13-20020a05600c4f4d00b0041898fca46amr4470375wmq.15.1713543388029;
        Fri, 19 Apr 2024 09:16:28 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:27 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v7 00/11] Add #VC exception handling for AMD SEV-ES
Date: Fri, 19 Apr 2024 18:16:12 +0200
Message-Id: <20240419161623.45842-1-vsntk18@gmail.com>
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

v7:
- Rebased the patches on top of the current state of the test suite.
- Addressed review comment by Andrew Jones:
  - moved macros unlikely()/likely to linux/compiler.h

v6:
- Rebased the patches on top of the current state of the test suite.
- Rebased the insn decoder on linux kernel e8c39d0f57f.
- Add a line about configuration option --amdsev-efi-vc in the
  x86/efi/README.md file.

Vasant Karasulli (11):
  x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
  x86: Move svm.h to lib/x86/
  lib: Define unlikely()/likely() macros in compiler.h
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
 lib/linux/compiler.h               |    3 +
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


base-commit: 69ee03b0598ee49f75ebab5cd0fe39bf18c1146e
--
2.34.1



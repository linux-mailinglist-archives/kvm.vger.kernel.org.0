Return-Path: <kvm+bounces-11560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 279588784D5
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A83ED1F24F2B
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14794E1DD;
	Mon, 11 Mar 2024 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEwLHWE+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64114AEC3;
	Mon, 11 Mar 2024 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710173861; cv=none; b=qYghE8GeVpoqoUXW/322OwWt7K/3TypgfxT/iI+2kTnCmPSEAl7aLmeyGmukPiihxVMW3Qn8E668i3AEO+3t15dE+n31S9K2SyRsd6N846yvV0Ya4ynMzaLM2aUjLGXj8laiftB6iN+ldN2X5rKISCs0qppFWRumaCYrQzo3MOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710173861; c=relaxed/simple;
	bh=dZ0oYtFBE/0c+pXjkBPcJJBxvUJ6uPY7Lm71TuKqwyo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r050mVtEi/Mp+gdf5TC0RgD/2MKxS1cKADzmWTNjZyh3tR7AZ6OXUBWlBhek8a8iLdRCSeWxhqg/zMJCclurRklRhee/9nA0tKOgAOWkq1W5ldDC7JVrG6MWuDqS0SdtP0Wb/RjxjFnd7eJwYJZUHEY14H2/I1lKz5z4ZDrNW6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEwLHWE+; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4131b1f8c91so21100905e9.3;
        Mon, 11 Mar 2024 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710173852; x=1710778652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KhgroYwDHirsSK6NEpHEOPOQNxUnb5y1s4Aku7Fobs0=;
        b=YEwLHWE+/71gjp0433qU6KzDuO7EBhtMZC7bmID5u7SJyHtDHDERtWEXDohqaREmES
         wC26VQ+XfbQowoChSmm1CIlnnr3/9EvSBKV7cJ0vgwRJlFAAm+xDmdbTivYreEQCXc52
         81/wN9dYGRhO6EtB/Y29T26s5/x0WyWmfSM8fyXklpOjwpjhmtmBKkXvWvPU4GwJ9851
         ibiGlmZR1+QKtzxHdG3ZhJ6hMVby/m44ll5BoPw7nqwgNH6TJAbN8tVMLgg27JN+k+Di
         Kh+8JvfTKuvVpXA0DENo10w03lMxXO26wNRCupqdXlv4XPLSQWzMxYOJV+1oPzo86xTs
         fShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710173852; x=1710778652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KhgroYwDHirsSK6NEpHEOPOQNxUnb5y1s4Aku7Fobs0=;
        b=eE8vL2vVmP1iddpSXU+NWY5E7zB1lJbSgfVLKI3lPE2n2N85zCz7NFiYRvDgf2R/jr
         /qECSwLYANXihQtGvJhqNKUPD1sFw8we7ChNNEQVsVlChwpn9pmSAI1HrR5xX+0Vf6Pn
         CEqdampYRglGB93xsJUzP8riv5fqNV/FR4z0leW3UhHIoL8yggQPKIXyRwQFM9AYzXey
         1V4bLoT3Q/L3W7B6X+ogEso/uAoCBGfuf9NktVNCFRoaSEy/FsVyp9fpg8ek3/HpEbr2
         dJVvhX6IvwqbbCmn4iMkDx7GEF7RJBK3A+kQhjZKxAF6KOeJEIn1DZ36CPu971Nu0Dvq
         ahow==
X-Forwarded-Encrypted: i=1; AJvYcCVzhotYt7sDwCVHRvXr5jcnVPSzwf5JOnFJHGRbfCpi74icD9XJXCKRtXSh6usif8M+ZaVDYK7LdfADAgG3q0dEM+5NHIrrveKuyLUPBADu98yj95z0eyHjelwcBFbC6VrKD8DJhDmKSuzJYpE5St3oYlIM3/QXLvwd
X-Gm-Message-State: AOJu0Ywh01a4ICmWOt4DKJcgMFxeaQfTb6/k2csLiwIId5wDza84TdgL
	3Cr+mqWXzObLFOiTIf4Q8U580zDDe2a5BkMAIKuAzqGpMit2sfKi
X-Google-Smtp-Source: AGHT+IFOXZkK2STurIgXVxbzpgve2av/2k7r2YA7lYoWxFHnDOWhnUJF1kkXWaz1HUNUDRTofP3laA==
X-Received: by 2002:a05:600c:5011:b0:413:2bcf:de2c with SMTP id n17-20020a05600c501100b004132bcfde2cmr1743625wmr.9.1710173852290;
        Mon, 11 Mar 2024 09:17:32 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab47:8200:c3b9:43af:f8e1:76f9])
        by smtp.gmail.com with ESMTPSA id ba14-20020a0560001c0e00b0033e96fe9479sm2823815wrb.89.2024.03.11.09.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 09:17:31 -0700 (PDT)
From: Vasant Karasulli <vsntk18@gmail.com>
To: x86@kernel.org
Cc: joro@8bytes.org,
	cfir@google.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	ebiederm@xmission.com,
	erdemaktas@google.com,
	hpa@zytor.com,
	jgross@suse.com,
	jslaby@suse.cz,
	keescook@chromium.org,
	kexec@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	luto@kernel.org,
	martin.b.radev@gmail.com,
	mhiramat@kernel.org,
	mstunes@vmware.com,
	nivedita@alum.mit.edu,
	peterz@infradead.org,
	rientjes@google.com,
	seanjc@google.com,
	stable@vger.kernel.org,
	thomas.lendacky@amd.com,
	virtualization@lists.linux-foundation.org,
	Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v4 0/9] x86/sev: KEXEC/KDUMP support for SEV-ES guests
Date: Mon, 11 Mar 2024 17:17:18 +0100
Message-Id: <20240311161727.14916-1-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

Hi,

here are changes to enable kexec/kdump in SEV-ES guests. The biggest
problem for supporting kexec/kdump under SEV-ES is to find a way to
hand the non-boot CPUs (APs) from one kernel to another.

Without SEV-ES the first kernel parks the CPUs in a HLT loop until
they get reset by the kexec'ed kernel via an INIT-SIPI-SIPI sequence.
For virtual machines the CPU reset is emulated by the hypervisor,
which sets the vCPU registers back to reset state.

This does not work under SEV-ES, because the hypervisor has no access
to the vCPU registers and can't make modifications to them. So an
SEV-ES guest needs to reset the vCPU itself and park it using the
AP-reset-hold protocol. Upon wakeup the guest needs to jump to
real-mode and to the reset-vector configured in the AP-Jump-Table.

The code to do this is the main part of this patch-set. It works by
placing code on the AP Jump-Table page itself to park the vCPU and for
jumping to the reset vector upon wakeup. The code on the AP Jump Table
runs in 16-bit protected mode with segment base set to the beginning
of the page. The AP Jump-Table is usually not within the first 1MB of
memory, so the code can't run in real-mode.

The AP Jump-Table is the best place to put the parking code, because
the memory is owned, but read-only by the firmware and writeable by
the OS. Only the first 4 bytes are used for the reset-vector, leaving
the rest of the page for code/data/stack to park a vCPU. The code
can't be in kernel memory because by the time the vCPU wakes up the
memory will be owned by the new kernel, which might have overwritten it
already.

The other patches add initial GHCB Version 2 protocol support, because
kexec/kdump need the MSR-based (without a GHCB) AP-reset-hold VMGEXIT,
which is a GHCB protocol version 2 feature.

The kexec'ed kernel is also entered via the decompressor and needs
MMIO support there, so this patch-set also adds MMIO #VC support to
the decompressor and support for handling CLFLUSH instructions.

Finally there is also code to disable kexec/kdump support at runtime
when the environment does not support it (e.g. no GHCB protocol
version 2 support or AP Jump Table over 4GB).

The diffstat looks big, but most of it is moving code for MMIO #VC
support around to make it available to the decompressor.

The previous version of this patch-set can be found here:

	https://lore.kernel.org/lkml/20220127101044.13803-1-joro@8bytes.org/

Please review.

Thanks,
   Vasant

Changes v3->v4:
        - Rebased to v6.8 kernel
	- Applied review comments by Sean Christopherson
	- Combined sev_es_setup_ap_jump_table() and sev_setup_ap_jump_table()
          into a single function which makes caching jump table address
          unnecessary
        - annotated struct sev_ap_jump_table_header with __packed attribute
	- added code to set up real mode data segment at boot time instead of
          hardcoding the value.

Changes v2->v3:

	- Rebased to v5.17-rc1
	- Applied most review comments by Boris
	- Use the name 'AP jump table' consistently
	- Make kexec-disabling for unsupported guests x86-specific
	- Cleanup and consolidate patches to detect GHCB v2 protocol
	  support

Joerg Roedel (9):
  x86/kexec/64: Disable kexec when SEV-ES is active
  x86/sev: Save and print negotiated GHCB protocol version
  x86/sev: Set GHCB data structure version
  x86/sev: Setup code to park APs in the AP Jump Table
  x86/sev: Park APs on AP Jump Table with GHCB protocol version 2
  x86/sev: Use AP Jump Table blob to stop CPU
  x86/sev: Add MMIO handling support to boot/compressed/ code
  x86/sev: Handle CLFLUSH MMIO events
  x86/kexec/64: Support kexec under SEV-ES with AP Jump Table Blob

 arch/x86/boot/compressed/sev.c          |  45 +-
 arch/x86/include/asm/insn-eval.h        |   1 +
 arch/x86/include/asm/realmode.h         |   5 +
 arch/x86/include/asm/sev-ap-jumptable.h |  30 +
 arch/x86/include/asm/sev.h              |   7 +
 arch/x86/kernel/machine_kexec_64.c      |  12 +
 arch/x86/kernel/process.c               |   8 +
 arch/x86/kernel/sev-shared.c            | 234 +++++-
 arch/x86/kernel/sev.c                   | 372 +++++-----
 arch/x86/lib/insn-eval-shared.c         | 912 ++++++++++++++++++++++++
 arch/x86/lib/insn-eval.c                | 911 +----------------------
 arch/x86/realmode/Makefile              |   9 +-
 arch/x86/realmode/rm/Makefile           |  11 +-
 arch/x86/realmode/rm/header.S           |   3 +
 arch/x86/realmode/rm/sev.S              |  85 +++
 arch/x86/realmode/rmpiggy.S             |   6 +
 arch/x86/realmode/sev/Makefile          |  33 +
 arch/x86/realmode/sev/ap_jump_table.S   | 131 ++++
 arch/x86/realmode/sev/ap_jump_table.lds |  24 +
 19 files changed, 1695 insertions(+), 1144 deletions(-)
 create mode 100644 arch/x86/include/asm/sev-ap-jumptable.h
 create mode 100644 arch/x86/lib/insn-eval-shared.c
 create mode 100644 arch/x86/realmode/rm/sev.S
 create mode 100644 arch/x86/realmode/sev/Makefile
 create mode 100644 arch/x86/realmode/sev/ap_jump_table.S
 create mode 100644 arch/x86/realmode/sev/ap_jump_table.lds


base-commit: e8f897f4afef0031fe618a8e94127a0934896aba
--
2.34.1



Return-Path: <kvm+bounces-43832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A66A97225
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 18:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB8D47A1F08
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA39290BCF;
	Tue, 22 Apr 2025 16:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="astmXMRG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212BD28A3E2
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 16:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745338400; cv=none; b=WALROC+kd2JVtOspctwhwmBVCts9mRV6D4zOpJQk9j82wtICDBPM7pl7O5Kml0ElFIiJpf5ss9QNKSGk8K+tQMPMzms2mY7N2XzQwUCKkel1WjhsIm7/Cc/Ooi1yT2EQ+O9ZPGyzuxmcfjmWprES/Bs+J0YoBmgC5lo77AhAXik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745338400; c=relaxed/simple;
	bh=pbLKhbB4JL8XJ7YdSiOmPWI9WMEe67/YSYPH4sMBOo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mmjv+QXQX3IEF4W3JLeOY1qQMusCife8YIEu8Pz3Z1JfZiNBl4tOV2IE8Lpd0To8mRbtDj8VpZ5oD85GX09Cs1U0WnNwQ6x1BWY3SQqr5fgZT/joyNpbdH0dc/3TD+r+6mscWTDXlnMhPV0shwnX0B0BlipqQ47OBPIHylc1HWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=astmXMRG; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-224341bbc1dso52411925ad.3
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745338397; x=1745943197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=600fD9G54NVOaVyktaguhJ2soOvTwp92HG4EGx1g2F4=;
        b=astmXMRGSN7srM9usmq/Ds8srcQJJ3/04W8BYcEwPba3ePyqZOp146gVM/nLFP3I+W
         vpRTKWynniIVBF5IrZqEp2VDczoajwyshDdGsldGB5zLOqGPNwOZ0AYCtzrT4OUR9ny2
         /DpgxjMH54c/bE5PBNuiMDVXYARPJinSFeJzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745338397; x=1745943197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=600fD9G54NVOaVyktaguhJ2soOvTwp92HG4EGx1g2F4=;
        b=Gdby2duRm0N/2/V9aAuYJJnXW7n2bNYTvYNK/IJVwEv4yFxPCi+M0ZQH5rof96VCxo
         CAROkmDxHUaHkZJFHmC+B6jLFNHT7bTx30Y3n6krwR5qlE5KcAle+27Vp1X9XvxyddT1
         ksWa43qC6qRNAHQ/nBnv8uzhnr/yE+TbdO8T62VSG3zlLh1ocCZph98vQ+fPbiNLVvNK
         YVrYnAOcmIb07WL5u+dBbwL8nUap3ZaRj48iNVGASpiFp+Vt2VTlpE5bBQuNq9MhhC6o
         yJJPvweUrL1n5PW1Tn5y24rScbXDhwzEVetnnupstqJ1YJlIHasTHW7+mL/W8gnQy0rR
         wxNg==
X-Forwarded-Encrypted: i=1; AJvYcCVmB4a7OPVMp0ESQFizx5LXEhnyZSeTYt1KwzEXrEKjheW8ZRHr534jOyd7CohNONJJrto=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPieaD6yoW0qNAD7jMWXYS0HSXuoPSgPc7np5VlXeOwh74smnH
	ZswMpKvvw62eN+fugOr3Uss6UvYQo5Ay9Ao9hsA1VUgrvOYWMd4V0/LTCipyWg==
X-Gm-Gg: ASbGncvaS5ZAXF8dLT/81GGXyNTbeY71eHA++fMiygoVNu633V1QDtaGw/7ZZoEg1C5
	KOeJLbsZgTLNIJerfcoFCpPqgmLuDMqAYIuojA0673lKZCK4lwoCebrZzGf7l8gpRnNmAoQ9OSY
	ZINTs9g9daxTBDvbnnDKl8XDhCuPGREgsmoBCYpauEblMmphPZ+LQAWSLY0S62q55+OVx401rYK
	y7K/ZeDRsz+f7jEIH0anO2eN62bZA+GbdPlq/d64sKXj90p9swocLJ1sotjSPLJG3jlsobjjyXD
	9UryJP4UsMzKE9cJa4fKwA2P2D+6UKHkoQTx95VXVhVYp/3N7K8okV4ZCQ/VlfYy7WszjnnEefI
	q8Ud+z/SA8aexXV8V2CR99+CkYnfgQRwj
X-Google-Smtp-Source: AGHT+IG4yc4cb3WLCu0YV3tQuWd6qB+0bI0V9npN8A4vdqCFBhKVqwsTx1FIXsxdSH/WoeELa5WdxQ==
X-Received: by 2002:a17:903:19ed:b0:223:62f5:fd44 with SMTP id d9443c01a7336-22c53607f99mr272215925ad.40.1745338397363;
        Tue, 22 Apr 2025 09:13:17 -0700 (PDT)
Received: from localhost.localdomain (pool-173-49-113-140.phlapa.fios.verizon.net. [173.49.113.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50eb03d2sm87462375ad.142.2025.04.22.09.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 09:13:17 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: linux-kernel@vger.kernel.org
Cc: Zack Rusin <zack.rusin@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Doug Covelli <doug.covelli@broadcom.com>,
	Shuah Khan <shuah@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Joel Stanley <joel@jms.id.au>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 0/5] KVM: Improve VMware guest support
Date: Tue, 22 Apr 2025 12:12:19 -0400
Message-ID: <20250422161304.579394-1-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the second version of a series that lets us run VMware
Workstation on Linux on top of KVM.

The most significant change in this series is the introduction of
CONFIG_KVM_VMWARE which is, in general, a nice cleanup for various
bits of VMware compatibility code that have been scattered around KVM.
(first patch)

The rest of the series builds upon the VMware platform to implement
features that are needed to run VMware guests without any
modifications on top of KVM:
- ability to turn on the VMware backdoor at runtime on a per-vm basis
(used to be a kernel boot argument only)
- support for VMware hypercalls - VMware products have a huge
collection of hypercalls, all of which are handled in userspace,
- support for handling legacy VMware backdoor in L0 in nested configs
- in cases where we have WS running a Windows VBS guest, the L0 would
be KVM, L1 Hyper-V so by default VMware Tools backdoor calls endup in
Hyper-V which can not handle them, so introduce a cap to let L0 handle
those.

The final change in the series is a kselftest of the VMware hypercall
functionality.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Zack Rusin <zack.rusin@broadcom.com>
Cc: Doug Covelli <doug.covelli@broadcom.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org

Zack Rusin (5):
  KVM: x86: Centralize KVM's VMware code
  KVM: x86: Allow enabling of the vmware backdoor via a cap
  KVM: x86: Add support for VMware guest specific hypercalls
  KVM: x86: Add support for legacy VMware backdoors in nested setups
  KVM: selftests: x86: Add a test for KVM_CAP_X86_VMWARE_HYPERCALL

 Documentation/virt/kvm/api.rst                |  86 +++++++-
 MAINTAINERS                                   |   9 +
 arch/x86/include/asm/kvm_host.h               |  13 ++
 arch/x86/kvm/Kconfig                          |  16 ++
 arch/x86/kvm/Makefile                         |   1 +
 arch/x86/kvm/emulate.c                        |  11 +-
 arch/x86/kvm/kvm_vmware.c                     |  85 ++++++++
 arch/x86/kvm/kvm_vmware.h                     | 189 ++++++++++++++++++
 arch/x86/kvm/pmu.c                            |  39 +---
 arch/x86/kvm/pmu.h                            |   4 -
 arch/x86/kvm/svm/nested.c                     |   6 +
 arch/x86/kvm/svm/svm.c                        |  10 +-
 arch/x86/kvm/vmx/nested.c                     |   6 +
 arch/x86/kvm/vmx/vmx.c                        |   5 +-
 arch/x86/kvm/x86.c                            |  74 +++----
 arch/x86/kvm/x86.h                            |   2 -
 include/uapi/linux/kvm.h                      |  27 +++
 tools/include/uapi/linux/kvm.h                |   3 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/vmware_hypercall_test.c | 121 +++++++++++
 20 files changed, 614 insertions(+), 94 deletions(-)
 create mode 100644 arch/x86/kvm/kvm_vmware.c
 create mode 100644 arch/x86/kvm/kvm_vmware.h
 create mode 100644 tools/testing/selftests/kvm/x86/vmware_hypercall_test.c

-- 
2.48.1



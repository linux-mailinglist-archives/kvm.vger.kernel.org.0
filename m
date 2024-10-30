Return-Path: <kvm+bounces-29990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F779B5A68
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 04:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DF9D1F237A8
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 03:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5FE019925B;
	Wed, 30 Oct 2024 03:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FTheNNpr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A0215E96
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 03:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730259321; cv=none; b=sVm+hdOcOEnWWTtt/c6sQU3c6iQeMLKOxUgfjIZlyuaKmuWIOkK4Z35+WCupRszkYHULtoWTT9abRYQqttY0YkMbhO/gtr4aoP+oTgt2rmUhPJxOIlDwghQzuixe9DgihRedYHeDEK2IK067l0zDeUjartHAcgL+x1wB0KZ7+EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730259321; c=relaxed/simple;
	bh=5e4ocqngMv3Nw+NiLalHLhMct3lABs8i5ufhVHb2AMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aw1CmOWaJTcNH48dvjUJHrGVw3hqw1MCHcPsk6dv8fqXVNnSy6DSIyKhI2sWuQYCXADIKwDFiui9FsC+X3NORN9i0lltfjKrWR+nT9LtzoXqH2st2U8CznzrSrlCxJNtTkEOWwAKjCKF7uknHlThLh0TVDqgW/LQQWjLhnF+iWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FTheNNpr; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-46094b68e30so44439361cf.0
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 20:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730259318; x=1730864118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9JEeBcFfasGQ6HuKHVexcEVIYh65tRgrqLCGh6hPlck=;
        b=FTheNNprsoZcwjBwYZghPYXFnKSqw5kB/rs+t5a19dshLRbB3jMA+qyYAjIJCT66oC
         Xj0RPG3HiszX0fkRwCpMx0pj9kjXChRiTpSf4ETXtRZZ+Uggm2epvOU1lFra37Kc0RMe
         VkJ+2nXHZ3r+HElwBHwX46T7xqkd8PjmZuxJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730259318; x=1730864118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9JEeBcFfasGQ6HuKHVexcEVIYh65tRgrqLCGh6hPlck=;
        b=L2Rt4xtNvkE98Dghcy1+nTMT+FjkAFiCtQKMni2XDIZHSGsUUjccGldhiIYFjmBoFr
         Lta9JDh+naRxYa6x5i1NRDB+p4iEk52i0nY35tFLo0KrXluG7dFsytb6WfLZtq5Wf7AH
         P3q+EcQ9/jNt+/3shDriVV3bgpVgntZjOeER2bws4U0dqAIABII6CRL4mjBJr/Z7Z9n/
         kl8UZQYoiZs2PMA5gcUpLfBkduSAJt8CQTAQ4Wsaog3gHFdP8ZFOsjzvD0ltyOC9lCjy
         0EP0FZZ/WXs5juCdr1QN3nBjc/aHmnx3LVBQ/UVmhlo73Rd0WuzW48CYUh8/8VFC4rX1
         5S6g==
X-Gm-Message-State: AOJu0YwDIZLdJj81mef5x8XpqkQw4+IjyyH9TZIHKW11AwDM7Xrqcass
	DoJaLLails5xgAak0ge99Sw/tcWxUwlmBzz3fD/Ys05WLHxKLStKd503g0PGeCj0TE2sVmUDmoR
	u/VlWlVzInlLcLwnCps1bYnUArEFUvFWtOQtl9vClY//AK9x5UR1v7lEyu+PvHUJ/5un/jawrw3
	c8ATlq/bPq49FAmfkPqX83ckxwbbU9SvzJVw==
X-Google-Smtp-Source: AGHT+IGxokqRzi/WYjMzIeo65ayF9NndKXyEQUP6dEcLmqJeJbC/i1rAV4J0HLQa+JmeRHEVQS2NaA==
X-Received: by 2002:a05:622a:14cd:b0:460:abf3:c454 with SMTP id d75a77b69052e-4613bffab89mr198985621cf.18.1730259318475;
        Tue, 29 Oct 2024 20:35:18 -0700 (PDT)
Received: from localhost.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-461323a4840sm51015561cf.86.2024.10.29.20.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 20:35:18 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: kvm@vger.kernel.org
Cc: Zack Rusin <zack.rusin@broadcom.com>,
	Doug Covelli <doug.covelli@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shuah Khan <shuah@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Joel Stanley <joel@jms.id.au>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86: Small changes to support VMware guests
Date: Tue, 29 Oct 2024 23:34:06 -0400
Message-ID: <20241030033514.1728937-1-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To be able to switch VMware products running on Linux to KVM some minor
changes are required to let KVM run/resume unmodified VMware guests.

First allow enabling of the VMware backdoor via an api. Currently the
setting of the VMware backdoor is limited to kernel boot parameters,
which forces all VM's running on a host to either run with or without
the VMware backdoor. Add a simple cap to allow enabling of the VMware
backdoor on a per VM basis. The default for that setting remains the
kvm.enable_vmware_backdoor boot parameter (which is false by default)
and can be changed on a per-vm basis via the KVM_CAP_X86_VMWARE_BACKDOOR
cap.

Second add a cap to forward hypercalls to userspace. I know that in
general that's frowned upon but VMwre guests send quite a few hypercalls
from userspace and it would be both impractical and largelly impossible
to handle all in the kernel. The change is trivial and I'd be maintaining
this code so I hope it's not a big deal.

The third commit just adds a self-test for the "forward VMware hypercalls
to userspace" functionality.

Cc: Doug Covelli <doug.covelli@broadcom.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Zack Rusin <zack.rusin@broadcom.com>
Cc: kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org

Zack Rusin (3):
  KVM: x86: Allow enabling of the vmware backdoor via a cap
  KVM: x86: Add support for VMware guest specific hypercalls
  KVM: selftests: x86: Add a test for KVM_CAP_X86_VMWARE_HYPERCALL

 Documentation/virt/kvm/api.rst                |  56 ++++++++-
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/emulate.c                        |   5 +-
 arch/x86/kvm/svm/svm.c                        |   6 +-
 arch/x86/kvm/vmx/vmx.c                        |   4 +-
 arch/x86/kvm/x86.c                            |  47 ++++++++
 arch/x86/kvm/x86.h                            |   7 +-
 include/uapi/linux/kvm.h                      |   2 +
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/vmware_hypercall_test.c        | 108 ++++++++++++++++++
 11 files changed, 227 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmware_hypercall_test.c

-- 
2.43.0



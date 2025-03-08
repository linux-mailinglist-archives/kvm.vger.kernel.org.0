Return-Path: <kvm+bounces-40469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72596A5770F
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 02:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2C43175E48
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 01:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5232AF0A;
	Sat,  8 Mar 2025 01:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GfqgObte"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87DE3D6A
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 01:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741395834; cv=none; b=rGS+7nm1EcmAe41UlccYQrbge+o3rTs5KR4oxfLG6+Bvg6F+P2vFt085chbawh2GArgqCQe2NuB8VMhMTp5kYjz7tj3LH7ziZPuN7csiF6K+v8JzJ9qEtMFhd8DdZAdJXYKH+MJkiNARgIAnhpKldjywJI9EyjjAcmGusQLqpoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741395834; c=relaxed/simple;
	bh=/ofrthbSNPaQPq3caZAYf9Qx+hSbpRZY+NvEWMWo8XQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fgOCNKhfQ9ANKK4nxUmIDjeCqDAk4nG7Eh9hOAtrxyf3Cp9LJr8se3Xt1jp676z2bTSVtQdQdD32Btr+Gf/0j6Lm5HQs4vr+epuqAWjN7QuQ2kLkQHncVFz7fyyZLiFRz05dcsbNSF4+YV1OcD8hWZQewiif5XUCYa6ubGbMKCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GfqgObte; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff78bd3026so3088214a91.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 17:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741395831; x=1742000631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqQr4oQvnsPw+cTT9PvxSvmEQJ4hCJszbEkJb8FFZds=;
        b=GfqgObteH27K0bl4DHRuTsklU9Or5uh5QDGngUC2d3yh3qH4TnNfGlH0jnJyD2BPUR
         iHWlUaZXaMLoZyqTyzVhQWSG6w9FZ8Q6FE+VyWhkDnVOAEPhDssLqoVpsEKi5faIn2gB
         ofV6zamXKuRKbRsf3DiyCicDhmNcjw1D3vKxa93TAEcMuzRGbTWmyjhfPC2rlvVklQBc
         aYkMb4sl5BhAseVB3ShQ6Quqp71lz9nGEZ/YZH+iHBiorO+5nXVDwDAdHtZ0lU7ot1CP
         CrEPiBvI1nrOpPrnZ6ECNMnWtmPex1LNSa64XhJmjrTnZBYAW/I8hUOQ9tQRzQkuK2kB
         +JOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741395831; x=1742000631;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rqQr4oQvnsPw+cTT9PvxSvmEQJ4hCJszbEkJb8FFZds=;
        b=IfvvZWfEwZ3x+8CNs7dJFTWAxe7AraCtUbjXmqe+MCr8pFwKhZnTVfVX/zVdmT+D8J
         IQQxcXrrCn22xdKeuPlEqzTazlBsYe+8MoXZLwOaHVVZvfwbgi+m9PhbwjPBkhTgXRJ4
         bN1gUOA9xE4tCjfNe5/yRv8xedKnilzApECq0Qhc4Fty4PAfAAhc6oPd2si72tLgYzIK
         QpkL1WAnJW2kLudBJuvF21xnlb+5r8QNFA1KQmaETvX0O4wvvYmev2hlhMk96dZSAimp
         T0ggveLCP/p6ZBl3xjd7dDC0MsUCM2rL0Bs1Pl+SNQF6uwVB64JznVh8mmmde1kLCZA9
         iXzQ==
X-Gm-Message-State: AOJu0Yy8oDUKgpIu/oGqDOhzHnxYDqA4f6e1hPdMhTtMs76jC/tKM91t
	4DC8sKh+IW4J8Ab+Rq1fvKmah9F/DeBdkNExL1KdeHOae4EXdUFa1AtYOFrhM5dCsJN+74x4Keh
	+MQ==
X-Google-Smtp-Source: AGHT+IElMMv+icxs3En0gO6dXDlMALdp2D7ZhELX41lXXs6JRqAonGUgeifVn6QYUUEj0C8jkiPCGjYtzsQ=
X-Received: from pgf2.prod.google.com ([2002:a05:6a02:4d02:b0:ad5:2dcc:552b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:99a0:b0:1ee:e655:97ea
 with SMTP id adf61e73a8af0-1f544cae4famr9981806637.41.1741395830996; Fri, 07
 Mar 2025 17:03:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Mar 2025 17:03:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250308010347.1014779-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Fixes for 6.14-rcN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a handful of fixes for 6.14.  The DEBUGCTL changes are the most
urgent, as they fix a bug that was introduced in 6.13 that results in Steam
(and other applications) getting killed due to unexpected #DBs.

The following changes since commit c2fee09fc167c74a64adb08656cb993ea475197e:

  KVM: x86: Load DR6 with guest value only before entering .vcpu_run() loop (2025-02-12 08:59:38 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.14-rcN.2

for you to fetch changes up to f9dc8fb3afc968042bdaf4b6e445a9272071c9f3:

  KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isn't supported by KVM (2025-03-04 09:19:18 -0800)

----------------------------------------------------------------
KVM x86 fixes for 6.14-rcN #2

 - Set RFLAGS.IF in C code on SVM to get VMRUN out of the STI shadow.

 - Ensure DEBUGCTL is context switched on AMD to avoid running the guest with
   the host's value, which can lead to unexpected bus lock #DBs.

 - Suppress DEBUGCTL.BTF on AMD (to match Intel), as KVM doesn't properly
   emulate BTF.  KVM's lack of context switching has meant BTF has always been
   broken to some extent.

 - Always save DR masks for SNP vCPUs if DebugSwap is *supported*, as the guest
   can enable DebugSwap without KVM's knowledge.

 - Fix a bug in mmu_stress_tests where a vCPU could finish the "writes to RO
   memory" phase without actually generating a write-protection fault.

 - Fix a printf() goof in the SEV smoke test that causes build failures with
   -Werror.

 - Explicitly zero EAX and EBX in CPUID.0x8000_0022 output when PERFMON_V2
   isn't supported by KVM.

----------------------------------------------------------------
Sean Christopherson (11):
      KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out of the STI shadow
      KVM: selftests: Assert that STI blocking isn't set after event injection
      KVM: SVM: Drop DEBUGCTL[5:2] from guest's effective value
      KVM: SVM: Suppress DEBUGCTL.BTF on AMD
      KVM: x86: Snapshot the host's DEBUGCTL in common x86
      KVM: SVM: Manually context switch DEBUGCTL if LBR virtualization is disabled
      KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
      KVM: SVM: Save host DR masks on CPUs with DebugSwap
      KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
      KVM: selftests: Ensure all vCPUs hit -EFAULT during initial RO stage
      KVM: selftests: Fix printf() format goof in SEV smoke test

Xiaoyao Li (1):
      KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isn't supported by KVM

 arch/x86/include/asm/kvm_host.h                    |  1 +
 arch/x86/kvm/cpuid.c                               |  2 +-
 arch/x86/kvm/svm/sev.c                             | 24 +++++++----
 arch/x86/kvm/svm/svm.c                             | 49 ++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h                             |  2 +-
 arch/x86/kvm/svm/vmenter.S                         | 10 +----
 arch/x86/kvm/vmx/vmx.c                             |  8 +---
 arch/x86/kvm/vmx/vmx.h                             |  2 -
 arch/x86/kvm/x86.c                                 |  2 +
 tools/testing/selftests/kvm/mmu_stress_test.c      | 21 ++++++----
 .../selftests/kvm/x86/nested_exceptions_test.c     |  2 +
 tools/testing/selftests/kvm/x86/sev_smoke_test.c   |  3 +-
 12 files changed, 91 insertions(+), 35 deletions(-)


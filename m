Return-Path: <kvm+bounces-63063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C5EC5A68A
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3A5F04E46EE
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C18326D4C;
	Thu, 13 Nov 2025 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GlS1JJCj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FB02E0412
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 22:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074590; cv=none; b=qRCdwoGXrG3+h5XaeeYdb7KSp84xF6uWqaaluibgk/32zVpebC5iUNDWu1pxjzjmF1YPz0gJ6YNsHh4bvYDxv5FnfoTZRT/Z9AzLwrK7RWPOd+uqPN8Hau3SmFBzjsjQM0wpKEuZTdGi+joiDa9u2J2dTiQP1RXa8dm4T1TkX8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074590; c=relaxed/simple;
	bh=JpkwLkYqfTWH2af+ev8jNXHZlL9P9xWFIzFSqfC4azA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hhkSNAPpg6tT5ySRj8MGqBi43htRrKCpYNU1zlFTBWtNx5osRih7UWrd3xsAWJdua4p/3JOeYxu0WWFv8MkYY1ib4JofRmIc9FQ9EpIBkCh/CFY2cqE3INGWiraJzysSUZHgWjJ9GWESJlJogvCGmph7UEviaIFtae7AMQui0cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GlS1JJCj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297df52c960so33242215ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 14:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763074588; x=1763679388; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wx3PLPcjBq2xtoETuBloY8IxxCjDmn23349GjtidbtI=;
        b=GlS1JJCjqo7c7XjeL1zYxj2ihqyWblpQqv07CHRNR3NJYcTgyql5WVJxd+E+xQVnL9
         LRepsqG8H4HaXAWpGFEfRBcygNvGP9CYWxxlUX6xSxlQ+FFy7xyUnnP9r7nsL85bY9Nm
         QdHj2gfYOeLwKiTy45E4mySy8QEsVNBHATHgxwqyUMD6T7id91r3+Gspmkvw7ly2IqRy
         bQuc5M2Lk4EgcFuQ84kAv9CAtgXFpDdGdmzxHpAlIcgVKGe8oboXi1o2FtInnJQdv4RN
         tRKKN2d70iiKK0DRHjA2lE9L4TsmkES90tRISJ06jJAcr9OI4g3D/x13KHy0HG92+IUK
         K7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763074588; x=1763679388;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wx3PLPcjBq2xtoETuBloY8IxxCjDmn23349GjtidbtI=;
        b=ZGLawiPhfcdBKu1dmSV9IJMG2ZQ3nNKljAbmWunrd/XYRGbyfHcBsMUFwjo2DlnYCx
         euBKKfm/00AHD1AiImOPz6NGbdiIP1lGJVi44SL0GY7OijeHl1rJzu7by/O1Y+BA66RL
         vh1b4H+kWK5vycmMMzfXF+UPfJiIkK3FsU9+1JFMbgmQwh4VXPoQNsKJ4EdB/JGvTtAy
         z0BWUWn9FwLBnLaq64Phv32BLfl8gmkvmPbziw1lx5TaSOitxPMm2m71zu9NFc5vdu86
         FgfIu5EvUr5bahh/aJuKs5AfLUwas5I4e7pQtogdx4WvmUxDTk4O54SjALAAgp2Wvl+g
         8JDQ==
X-Gm-Message-State: AOJu0YwJXduSJ0ZD15NUd13AwOwdeUJY647cZW5ooW6WHJPBiYVRytMW
	tgYUxSpAc5KB8EBQdVdtkf+TX6nJH/NyI/08FE/sW5WdFkluRGtcO8wr6id7RUlMjd8LBViDHQG
	4UPxJhA==
X-Google-Smtp-Source: AGHT+IH8hcBLZQlPdbuJlMzm1zBVW2nQnz2ncq3rgCivH92im1o3royXQQqD/TFcgKzEMyHzondAYjwZTLk=
X-Received: from plmd10.prod.google.com ([2002:a17:903:eca:b0:27e:4187:b4d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c942:b0:296:ec5:ab3d
 with SMTP id d9443c01a7336-2986a782c9cmr6357595ad.61.1763074588214; Thu, 13
 Nov 2025 14:56:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 14:56:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113225621.1688428-1-seanjc@google.com>
Subject: [PATCH 0/9] KVM: SVM: Fix (hilarious) exit_code bugs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Hyper-V folks, y'all are getting Cc'd because of a change in
include/hyperv/hvgdk.h to ensure HV_SVM_EXITCODE_ENL is an unsigned value.
AFAICT, only KVM consumes that macro.  That said, any insight you can provide
on relevant Hyper-V behavior would be appreciated :-)


Fix bugs in SVM that mostly impact nested SVM where KVM treats exit codes
as 32-bit values instead of 64-bit values.  I have no idea how KVM ended up
with such an egregious flaw, as the blame trail goes all the way back to
commit 6aa8b732ca01 ("[PATCH] kvm: userspace interface").  Maybe there was
pre-production hardware or something?

I'm also fairly surprised no one has noticed, as at least Xen treats exit
codes as 64-bit values.  Maybe the only people that run hypervisor tests on
top of KVM are also running KVM, or similarly buggy tests?  /shrug

The most dangerous aspect of the mess is that simply fixing KVM would likely
break KVM-on-KVM setups if only L1 is patched.  To try and avoid such
breakage while also fixing KVM, I opted to have KVM retain its checks on
only bits 31:0 if KVM is running as a VM (as detected by
X86_FEATURE_HYPERVISOR).

I stumbled on this when trying to resolve a array_index_nospec() build failure
on 32-bit kernels (array_index_nospec() requires the index to fit in an
"unsigned long").

Oh, and I have KUT changes to detect the nSVM bugs.

Because of the potential for breakage, I tagged only the nSVM fixes for
stable@.  E.g. I almost botched things by sending this as two separate
series, which would have create a window where svm_invoke_exit_handler()
would process a 64-bit code when running KVM-on-KVM and thus break if L0
KVM left gargage in bits 63:32.

Sean Christopherson (9):
  KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested
    VM-Exits
  KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR
    (failed VMRUN)
  KVM: SVM: Add a helper to detect VMRUN failures
  KVM: SVM: Open code handling of unexpected exits in
    svm_invoke_exit_handler()
  KVM: SVM: Check for an unexpected VM-Exit after RETPOLINE "fast"
    handling
  KVM: SVM: Filter out 64-bit exit codes when invoking exit handlers on
    bare metal
  KVM: SVM: Treat exit_code as an unsigned 64-bit value through all of
    KVM
  KVM: SVM: Limit incorrect check on SVM_EXIT_ERR to running as a VM
  KVM: SVM: Harden exit_code against being used in Spectre-like attacks

 arch/x86/include/asm/svm.h      |  3 +-
 arch/x86/include/uapi/asm/svm.h | 32 ++++++++++-----------
 arch/x86/kvm/svm/hyperv.c       |  1 -
 arch/x86/kvm/svm/nested.c       | 29 +++++++------------
 arch/x86/kvm/svm/sev.c          | 36 ++++++++----------------
 arch/x86/kvm/svm/svm.c          | 49 +++++++++++++++++++--------------
 arch/x86/kvm/svm/svm.h          | 17 ++++++++----
 arch/x86/kvm/trace.h            |  2 +-
 include/hyperv/hvgdk.h          |  2 +-
 9 files changed, 82 insertions(+), 89 deletions(-)


base-commit: 16ec4fb4ac95d878b879192d280db2baeec43272
-- 
2.52.0.rc1.455.g30608eb744-goog



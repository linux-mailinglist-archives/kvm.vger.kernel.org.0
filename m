Return-Path: <kvm+bounces-41430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A68D8A67B9A
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 233E419C7220
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38124214A64;
	Tue, 18 Mar 2025 18:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZT2M8kRa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D5D2147E4
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742321003; cv=none; b=KwyvzXP/bcjwg0RMGP12aE3Sw/FHWR/ZLy4fiXHcu03aW92OtljFWVWa4YlCfytllCRzIL2VSaYnd7ju+wh4ojhwaSNbCYeze7lcU1ATilcBt1GmaygivNhYG+JBssL7t8ob2XXfQ6LFl4LCZ19WENaIqCABJ43wkVRbViUJOVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742321003; c=relaxed/simple;
	bh=vIjqe14c0RNfUySlFRGhO3NbU8KsbO/xK6TEyVXoxlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F/EimshqyWmXFUIVr5+JB+S7r1mfi1YObmmlf7wxls72FCCjInIa7jaeBEJY6Mlq7Loj8WusH9Wo1JOZEI+DkbVUVShGuyCpSQjkOk06y97akBfGJ83DSgst0nazo+717U5lgFlgJSYHK/Dyd+xU1rc6Y9QE0TDsaqzW/Hlsq/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZT2M8kRa; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff68033070so5482458a91.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742321001; x=1742925801; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IT302M+FVQY9sewvC6bjI5Mn+MvLFGrIcg+szg8Yono=;
        b=ZT2M8kRabwlk2iEhwXRhS/ppHqgPlmvR/kYjd9Yl0boL3tSWUaaw5FWAuE8gUR734N
         mF7FZBlECbzEznbxkwnP5KY7+BhoX3LZlJTqzO8ulVVI2FpbGSLpIWjdiKudAFKivuzN
         4znVISczHY+rqdXaEMyM6qGzVt253O1rlzv4bHbhI7t+V/OAEAuEPpRNWQ/UV8MYgBEw
         70pQ8hHiW6ugNjdo8z+dcnmoVC1hSx+djUFCQye17EGUneazVMwACnR/7WKpDwQAigDI
         t4mk81yPwgFF54zaBVkuJ5L5y0rYZd9Cqy90r6MRryBttXiRY2S+6ez2MNrjkLwcBb9m
         9QYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742321001; x=1742925801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IT302M+FVQY9sewvC6bjI5Mn+MvLFGrIcg+szg8Yono=;
        b=CbO5HpxUx7wfxYQIXorX/El3i1GNgnnrRV0UR1lROCBs8pdwO+WL82Gikd1KrU0sjO
         20W7UIoWT8JzmdHzhZqLQH8jvwWlbs4q+fCh1Q6Lnn5CTZOS2C6SvPuDt7c5X3WcHY8+
         x5vDbSDyx2jOXci6pgSJ6pfoadoE/9HjvmJhOtTXsR+GZgj70fmxls7AsrvGj+f8MBvn
         /0B/XZlVlHWRgPAq6b6wmzwZAyHNXbAAFEjI9NPm7zY5XgtAfq3lEZiNrLFXn05CGkyK
         8+emGIjE7SoLmOp4Ckx3ly5OEf5qzItIlKfg/vo0ob3t6Rl/Lhy3aDBl9+mhy9rlx5O2
         qnwg==
X-Gm-Message-State: AOJu0YxdXO4XjpAsDztqWDyD8fPwGqaCmxb1P1n9+YXiCyxFe8V7KxXS
	lLB0HcgLia+DQpTshpnWFnpARA7QUMbtBAeRVfyXcfbXqsrTxoeM+dVUEEZencac6CpZR0gHNp9
	Jug==
X-Google-Smtp-Source: AGHT+IGTi12zBNscf00G47hXQDPJPN/IGQpF4zQKmAap+oOue+uk/UXuOBX0o4O/LU5EKKlFNLTOYrGynXY=
X-Received: from pjbnw1.prod.google.com ([2002:a17:90b:2541:b0:2ff:6132:8710])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cd0:b0:2f6:dcc9:38e0
 with SMTP id 98e67ed59e1d1-301a52908d0mr5763909a91.0.1742321001312; Tue, 18
 Mar 2025 11:03:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Mar 2025 11:03:03 -0700
In-Reply-To: <20250318180303.283401-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318180303.283401-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318180303.283401-9-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Xen changes for 6.15
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Harden and optimize KVM's handling of the Xen hypercall MSR; syzkaller discovered
that setting the userspace-configurable index to collide with XSS could coerce
KVM into writing guest memory during vCPU creation.

The other change is to fix a flaw related to Xen TSC CPUID emulation.

The following changes since commit a64dcfb451e254085a7daee5fe51bf22959d52d3:

  Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-xen-6.15

for you to fetch changes up to a2b00f85d7839d74a2f6fcbf547d4bf2e82c34e5:

  KVM: x86: Update Xen TSC leaves during CPUID emulation (2025-02-25 07:09:55 -0800)

----------------------------------------------------------------
KVM Xen changes for 6.15

 - Don't write to the Xen hypercall page on MSR writes that are initiated by
   the host (userspace or KVM) to fix a class of bugs where KVM can write to
   guest memory at unexpected times, e.g. during vCPU creation if userspace has
   set the Xen hypercall MSR index to collide with an MSR that KVM emulates.

 - Restrict the Xen hypercall MSR indx to the unofficial synthetic range to
   reduce the set of possible collisions with MSRs that are emulated by KVM
   (collisions can still happen as KVM emulates Hyper-V MSRs, which also reside
   in the synthetic range).

 - Clean up and optimize KVM's handling of Xen MSR writes and xen_hvm_config.

 - Update Xen TSC leaves during CPUID emulation instead of modifying the CPUID
   entries when updating PV clocks, as there is no guarantee PV clocks will be
   updated between TSC frequency changes and CPUID emulation, and guest reads
   of Xen TSC should be rare, i.e. are not a hot path.

----------------------------------------------------------------
David Woodhouse (1):
      KVM: x86/xen: Only write Xen hypercall page for guest writes to MSR

Fred Griffoul (1):
      KVM: x86: Update Xen TSC leaves during CPUID emulation

Sean Christopherson (5):
      KVM: x86/xen: Restrict hypercall MSR to unofficial synthetic range
      KVM: x86/xen: Add an #ifdef'd helper to detect writes to Xen MSR
      KVM: x86/xen: Consult kvm_xen_enabled when checking for Xen MSR writes
      KVM: x86/xen: Bury xen_hvm_config behind CONFIG_KVM_XEN=y
      KVM: x86/xen: Move kvm_xen_hvm_config field into kvm_xen

 Documentation/virt/kvm/api.rst  |  4 ++++
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/cpuid.c            | 16 +++++++++++++
 arch/x86/kvm/x86.c              | 13 +++++++----
 arch/x86/kvm/x86.h              |  1 +
 arch/x86/kvm/xen.c              | 52 +++++++++++++++--------------------------
 arch/x86/kvm/xen.h              | 30 ++++++++++++++++++++----
 8 files changed, 80 insertions(+), 43 deletions(-)


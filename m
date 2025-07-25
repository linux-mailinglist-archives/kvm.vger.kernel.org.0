Return-Path: <kvm+bounces-53486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16DD3B1267C
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:09:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CEF11CC48B7
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6921C263C69;
	Fri, 25 Jul 2025 22:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xefJQAMM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E52A2620D2
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481250; cv=none; b=RxbMnUAec5fB882nDlf6+ypBVV/Aij9NjQ8n3j3wfm734sx3bAZ+0kM7ca+voqVheUKqO7xmYv6nMhlwhj071Jt80zcInouQW7CTHfbmwAhkYJ6+FD6Sx40RT5rLvL7ZmzycetnHSrPUsi1K9qEwb+1gxUZZpw3XDiWvsS2hKvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481250; c=relaxed/simple;
	bh=WW0CPobFKPKKFowOGKB20x9PGbl9U9qdV93bltr20mE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=idw5VNoXPmNPG4/0mx6pLqylOPWkUmVLU8E1+TuwncjkWBXvzmd8/Z5wt6clpI2n/enDfEvYjlwvlZ1bIosKv63+IjxkUYV3wKhjbA3WFWVNKZJ1eyuSSbNRKOootrG7iSE92EL0EPMdeArKKGByXr2k9cLOFNR5P+youtLBEpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xefJQAMM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313c3915345so3854595a91.3
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481248; x=1754086048; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8j/hFPuge5KpGKM7Z6Z8NdL5vgVmo6tZrIZIEVn/Aec=;
        b=xefJQAMMAsNPgiRXD/Wmc9ERPm4eTOw1rVeQ+ubUVQ93OcmUOjXtPY2UrBdlWnocZj
         zDr8h8N7dTo0n2Of0OZHmURCmQbfiYsjJVhPaMah1UFRBo4IlB7MigLTkMvpfnpR6RNV
         DZVfzVoAFlkEjT4pNtb0pp/l5OF/c+oUJrfB3SMKCUX6AoJc9vRfmukQzHkf1PdloAwH
         XfHMB07DjW3/B6kDz59SkWbD/iZgeqSorTzTIF0iq83WF90f3kfH+sc1xvdCZFBHde/C
         qjZQMPdZPMUqgrcnKG4o03fz9q56PHMqhCE0ECP6DFphAB4H8u+YoPfd2VRfsV+4IPuz
         vpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481248; x=1754086048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8j/hFPuge5KpGKM7Z6Z8NdL5vgVmo6tZrIZIEVn/Aec=;
        b=duoMEyKW7FinTbZ6i64eR9hfCV3n/oCpAKNWmEeSf60EL6lyBJVvbzOh5NxjuEE2xS
         7TZItLQ+r81VtkvS9sekDcoMTXaz7U5Ui4ihGHMFin/Vv1vAniJjQZy3HhmHQN6mK7GC
         5/fkLk9fNROlgl7ALAExqbk1sRjrEkQE+MTq9ulFw6JeRpPhpMZ7GZxPXSiYu+xTw1G+
         N2va56VmpzPAQcEbhUNEgknZ++KGzai9PSu9tQg+h52yapCZM9I2+WmHUnMc/icyWE3A
         k6pqHzIqoOH9uAct+22x2R7m/MGJoYwH6TXy0//qL7vlcLrMugyM/SnBGtS/f02EwYgJ
         XRSA==
X-Gm-Message-State: AOJu0YydAh63eulJ+g29omSxkA+ePVm4/T/yzL3+mYz8d90KEdMyQ7n1
	27HaXDLiMSDKGBHG5hP5DijL6Ynkb2cNPvieOWcpy2h8+GyKsWjIybHNM0FpEhqPnLpuZ49j4IF
	vkXwUBg==
X-Google-Smtp-Source: AGHT+IFAboWw2/BOR/wRCxEdR+bb1CH4oPn7JnWHbasz79mqqVXFyZTEHFOKsrapSEfkqh6cip3P5D07OC4=
X-Received: from pjbsl3.prod.google.com ([2002:a17:90b:2e03:b0:312:1e70:e233])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5868:b0:311:fde5:e224
 with SMTP id 98e67ed59e1d1-31e77730540mr5598498a91.6.1753481248395; Fri, 25
 Jul 2025 15:07:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:07 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-8-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Dynamically allocate the shadow MMU's hashed page list, as it's a whopping
32KiB and isn't needed when using the TDP MMU without nested VMs.  The TDX
change is quite out of place, but it's in here as "KVM: x86: Use kvzalloc()
to allocate VM struct" depends on both the TDX change and on dynamically
allocating the hashed list (KVM uses kvzalloc() purely because the 32KiB
for the list blows up the size of struct kvm).

The following changes since commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5:

  KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities (2025-06-20 14:20:20 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.17

for you to fetch changes up to 9c4fe6d1509b386ab78f27dfaa2d128be77dc2d2:

  KVM: x86/mmu: Defer allocation of shadow MMU's hashed page list (2025-06-24 12:51:07 -0700)

----------------------------------------------------------------
KVM x86 MMU changes for 6.17

 - Exempt nested EPT from the the !USER + CR0.WP logic, as EPT doesn't interact
   with CR0.WP.

 - Move the TDX hardware setup code to tdx.c to better co-locate TDX code
   and eliminate a few global symbols.

 - Dynamically allocation the shadow MMU's hashed page list, and defer
   allocating the hashed list until it's actually needed (the TDP MMU doesn't
   use the list).

----------------------------------------------------------------
Sean Christopherson (5):
      KVM: x86/mmu: Exempt nested EPT page tables from !USER, CR0.WP=0 logic
      KVM: TDX: Move TDX hardware setup from main.c to tdx.c
      KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list
      KVM: x86: Use kvzalloc() to allocate VM struct
      KVM: x86/mmu: Defer allocation of shadow MMU's hashed page list

 arch/x86/include/asm/kvm_host.h |  6 ++--
 arch/x86/kvm/mmu/mmu.c          | 75 +++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++--
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/main.c         | 36 ++------------------
 arch/x86/kvm/vmx/tdx.c          | 47 +++++++++++++++++++-------
 arch/x86/kvm/vmx/tdx.h          |  1 +
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 arch/x86/kvm/vmx/x86_ops.h      | 10 ------
 arch/x86/kvm/x86.c              |  5 ++-
 arch/x86/kvm/x86.h              | 22 ++++++++++++
 11 files changed, 145 insertions(+), 69 deletions(-)


Return-Path: <kvm+bounces-53491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC483B12685
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDB7CAE2370
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7AA6267B01;
	Fri, 25 Jul 2025 22:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CcJPAOPg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BC5266B6B
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481260; cv=none; b=UixNZsVJpWqmrO6a33NOeh4irHI0O0OxQaNMujNyQdCV2yUUQ9xrG9gTXgvqKmCpZJt8ykwogR2L6y+/him9/eAt5h3w8FqGZr8BPPYFNM0F4gKfjWhCpF3KKKBeb9lpdXqcNp9p0A1VsWs8kpE1tk/MO9ZDI+S3lSDLZ7LhNGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481260; c=relaxed/simple;
	bh=QtBtvfBTP18jdVYP+tT+BRRVQKRMwScoLI9bYcDp9f0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hDqEwZSGqzREjbIPHIOzlP835MIind+2VD5uOEPxGIyXqHXrkHCGQj5jm55pdSMH/58ifTcfJkrC+RgQ1Ak18X4Sq6zXQXKsBYUmmH6z1STiTCZDEwvaoervFDN/3qcqjonKfefT59FnOJE0zJWxV9on2UIh0+Fa026G4kaTz/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CcJPAOPg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-315af08594fso2358033a91.2
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481259; x=1754086059; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hGNamb6eDhMq0KBZSgWG51/tD3CsLO6bWw7B4/nq10Q=;
        b=CcJPAOPgzgOX23cmVe8oWwxeV2hZGC69f25S1l1A0FRyQk8wFQfrG74X3kAj3NNs0N
         VO5ArHq30wfRH6Ef+3lKu+htEE0oTlUhaXMXwvrJ8NsoT66guDoxaMRReqI4Dd0VQNtu
         +iV42M47rKJi89DFe4ry/2zuCw5c1sWELL/IJI8yArgkUDmFZd94egytfbKUgcyHC3ZP
         B+ZqVsrmq0pp3xOIWFQzbjAXmGfIJ/nfsj6mE+Z0IakU+XeKjG56D0qHCFpAqc9ay7ip
         7HZPLgA9r3phz+ggw3GpROFSYpgzsJi1+7j6vBTG4jy6j/qUIW9VdG7fx63/Wnn9hveh
         gzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481259; x=1754086059;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hGNamb6eDhMq0KBZSgWG51/tD3CsLO6bWw7B4/nq10Q=;
        b=qpbVb1hOb7ddT85f278pGCKKwr6YMLjgddesg9Mo468TDnYUY1ek/J8KCLwuSigLvd
         EP/brRfHMvryoXRybfPbTnqjvFkhjvZQOyW9wU1fIGl49vBAIkDwK6gHcFtc7jLm9AfQ
         Xz8cYY428E9vaX4VdgdgYJ2D431ZvI3fLsI+GS2r1skulHx73ZE7FcNYIVjMyAiLdst8
         SBGZhL9YBnBfdu/6R03sypo98srHunS/3wG8Q1MbQyZi1Yyil5n6rCCb5jiA9H7F8xzj
         PZo2RPti7lCwxq4NHRqP7H78xYgv/+IV7a7eylsn9yi3+vBvzxM+WSWm3JAO3hDMRgZ/
         M5DA==
X-Gm-Message-State: AOJu0YyEwYprB+4IUGxr8hpOOdBeQ1CWsbua28dK7r7/744+zl2UOYC8
	l2O1vSVfQPCdSu5o1/INQzD1rXLfBpomdp/wKCXV8rfFBzJWLw/V5FbxgUguz2VQpLe/iz0g4iM
	fMfoiFA==
X-Google-Smtp-Source: AGHT+IHh3rxuOFbb/W2x7iN5AS6/7XibK86+B4gsoJfk3ZeWbvZFhv2qUZK5Njbmn7ovGNC1uVRrGDYTZjY=
X-Received: from pjbok13.prod.google.com ([2002:a17:90b:1d4d:b0:312:1900:72e2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f49:b0:31c:15b4:8e22
 with SMTP id 98e67ed59e1d1-31e7786e68emr4264830a91.7.1753481258823; Fri, 25
 Jul 2025 15:07:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:12 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-13-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a sub-ioctl to allow getting TDX VMs into TEARDOWN before the last reference
to the VM is put, so that reclaiming the VM's memory doesn't have to jump
through all the hoops needed to reclaim memory from a live TD, which are quite
costly, especially for large VMs.

The following changes since commit 347e9f5043c89695b01e66b3ed111755afcf1911:

  Linux 6.16-rc6 (2025-07-13 14:25:58 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.17

for you to fetch changes up to dcab95e533642d8f733e2562b8bfa5715541e0cf:

  KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM (2025-07-21 16:23:02 -0700)

----------------------------------------------------------------
KVM VMX changes for 6.17

Add a TDX sub-ioctl, KVM_TDX_TERMINATE_VM, to let userspace mark a VM as dead,
and most importantly release its HKID, prior to dropping the last reference to
the VM.  Releasing the HKID moves the VM to TDX's TEARDOWN state, which allows
pages to be reclaimed directly and ultimately reduces total reclaim time by a
factor of 10x or more.

----------------------------------------------------------------
Sean Christopherson (1):
      KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM

 Documentation/virt/kvm/x86/intel-tdx.rst | 22 ++++++++++++++++++-
 arch/x86/include/uapi/asm/kvm.h          |  7 ++++++-
 arch/x86/kvm/vmx/tdx.c                   | 36 +++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 10 deletions(-)


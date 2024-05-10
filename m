Return-Path: <kvm+bounces-17236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7192D8C2DB6
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 01:51:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 129A11F23B7E
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551DC176FC5;
	Fri, 10 May 2024 23:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nWbJbw9D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215CB1779BD
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 23:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715385064; cv=none; b=W0e6NvYpPtIP+PfSfaZElrsTpOKD39OZjnq8DJbGBoWzHMHBSfktMSfyEiAzp/+iur5AHhq+QQmlYYk5AGrfHAVGg0679lpLbhw3H8yjOk2q+02uVedXirNecby8RsE0QaGeZaO3oBM7Idu1clIrCAOD2ns8Q4DR9xHRPmHU6AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715385064; c=relaxed/simple;
	bh=KixVq6DNjnhnxPnJvmKFfyn34jSfKLnUHW1nAJscsSU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AFH2rQ29OJUCuH8V9muiVLL9X8eQyS4gxLjb2UiOoBI55vGjApWWDv7furWh8+tRNteHrum/yEH8ju4pQNsJ2kF2OKibPBVMEupp6gilfQobufkiDZqnETUyL4T6OPL8yd1C/Y+GpOF6tYuo5VcSOFMN/PTo1dEmvynb6QAUCq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nWbJbw9D; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e604136b6dso18715815ad.1
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 16:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715385062; x=1715989862; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M+ZTJuFw4tl+MydOHkluBHm1QKEbKgKxZP6rG7WV+iA=;
        b=nWbJbw9DeB9on/3rJpRuLC4aDRyG/QzF4VckpkHI0BLFQOyVY3BFTrDl+R43EIJN3H
         S7W35uqpDiJQVxdegc5hd+/JzXW2mS4YG88k81lyX8vBWvyyQIEJmNfgcUj/Efq54gaw
         upTqnEQcMcl/y+loG3RCukHbVMShIR+t3p1SCEmEFJynBQ46GHnhPtRXtKLbnqM2gk9O
         6It/Dr8JL8gTTokKgMn11Jim2TrbA3qssJgsHlaY/lfLadwrNySWWDcSPrNrPr/zMLqd
         y+A90Hfq9IWgC0ibndH7yQtDkjfIuftUQRNHmOH/2BhB8lVfzsv+25x6LRTgD3Wru7sm
         zddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715385062; x=1715989862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+ZTJuFw4tl+MydOHkluBHm1QKEbKgKxZP6rG7WV+iA=;
        b=VAlCm8WGBi5C/amU2/KBslKRs44is0L2kA79wUdPrNTlj0G72O86qSAQwTz9ONleMK
         c2y3b/Ryz7VP9KZdvS4+NROtFtgMjE3+OyCGPoy53QoXLqT3NX2YSZShdI67CxuvV0A0
         VXgNVQxCqTCiLMulBkwLgFE67SYS+q2kIfa0dZunuH1i3i3QTsP7sDYJ8nqtzZn0CDoU
         Hl4XkDaR1C5tU/hbMZknNcOopWHnNtO53cz7gxcZwUivb6Rf8mixhaiHMyN3PbOKYByl
         eBU6dPth78qAj/2Cs4Bq072NrY5GrcbHbzNQGPbQfIFQZpBCdrigUEUdLyyQIues2Z8p
         yQdA==
X-Gm-Message-State: AOJu0YzU+TLPUc/PoBxC4xYBhQkmKm29cIsaILvXLrsVKpjaHew2Dave
	wNNHrfoP4sHmqoIYX+ucHseMceSoNnn9gZWjLvrPlUJZKBfeSRojrwEBQuCFPjRO8tBnIgsQxw4
	anw==
X-Google-Smtp-Source: AGHT+IHQCJRZrGrswvBRH8i7P0ISwg1f4DXRy9ANj2VvYQkzJIt29w7iVTytFgjFvrTsjf1X3cgR6YUPKsw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea0d:b0:1db:8ef5:24c1 with SMTP id
 d9443c01a7336-1ef43d0fcc5mr3404785ad.5.1715385062492; Fri, 10 May 2024
 16:51:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 May 2024 16:50:47 -0700
In-Reply-To: <20240510235055.2811352-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510235055.2811352-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510235055.2811352-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.10
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The max mappable GPA changes are the most notable, though unless we really
botched the KVM implementation, they should be old news for you.

The other mildly interesting change is a fix for KVM's handling of userspace
writes to immutable feature MSRs.  The seemingly good idea of simply ignoring
the writes, e.g. to avoid a problematic/useless PMU refresh, neglected to
consider the fact that access to the MSR might be disallowed.  E.g. the VMX
MSRs are off limits if nested support is disabled.

The following changes since commit fec50db7033ea478773b159e0e2efb135270e3b7:

  Linux 6.9-rc3 (2024-04-07 13:22:46 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.10

for you to fetch changes up to 51937f2aae186e335175dde78279aaf0cb5e72ae:

  KVM: x86: Remove VT-d mention in posted interrupt tracepoint (2024-05-02 07:54:14 -0700)

----------------------------------------------------------------
KVM x86 misc changes for 6.10:

 - Advertise the max mappable GPA in the "guest MAXPHYADDR" CPUID field, which
   is unused by hardware, so that KVM can communicate its inability to map GPAs
   that set bits 51:48 due to lack of 5-level paging.  Guest firmware is
   expected to use the information to safely remap BARs in the uppermost GPA
   space, i.e to avoid placing a BAR at a legal, but unmappable, GPA.

 - Use vfree() instead of kvfree() for allocations that always use vcalloc()
   or __vcalloc().

 - Don't completely ignore same-value writes to immutable feature MSRs, as
   doing so results in KVM failing to reject accesses to MSR that aren't
   supposed to exist given the vCPU model and/or KVM configuration.

 - Don't mark APICv as being inhibited due to ABSENT if APICv is disabled
   KVM-wide to avoid confusing debuggers (KVM will never bother clearing the
   ABSENT inhibit, even if userspace enables in-kernel local APIC).

----------------------------------------------------------------
Alejandro Jimenez (2):
      KVM: x86: Only set APICV_INHIBIT_REASON_ABSENT if APICv is enabled
      KVM: x86: Remove VT-d mention in posted interrupt tracepoint

Gerd Hoffmann (2):
      KVM: x86: Don't advertise guest.MAXPHYADDR as host.MAXPHYADDR in CPUID
      KVM: x86: Advertise max mappable GPA in CPUID.0x80000008.GuestPhysBits

Li RongQing (1):
      KVM: Use vfree for memory allocated by vcalloc()/__vcalloc()

Sean Christopherson (1):
      KVM: x86: Allow, don't ignore, same-value writes to immutable MSRs

 arch/x86/kvm/cpuid.c          | 41 +++++++++++++++++++++++++++++++----------
 arch/x86/kvm/mmu.h            |  2 ++
 arch/x86/kvm/mmu/mmu.c        |  5 +++++
 arch/x86/kvm/mmu/page_track.c |  2 +-
 arch/x86/kvm/trace.h          |  4 ++--
 arch/x86/kvm/x86.c            | 28 +++++++++++-----------------
 virt/kvm/kvm_main.c           |  2 +-
 7 files changed, 53 insertions(+), 31 deletions(-)


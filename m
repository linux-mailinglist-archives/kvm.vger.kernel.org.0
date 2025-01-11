Return-Path: <kvm+bounces-35184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A811A09FCD
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D729F188B6F8
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1074179A3;
	Sat, 11 Jan 2025 01:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vo1sehcu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77F4D299
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736557454; cv=none; b=h5Rg+zNXCZ+6dthRhuEV/rO0K2pdEB9/BzIZYoGE6hBi68mDj5zastvtv6iSGA385HmaM1H9nA1v/lP9FXGrvRcIBmSvIEY2PUs6ttS4Z6GWjs7gjBpFWlPnNodnrZCUlzAR+NFLqPJ7eDbXkSxttw6ADWsbJiRC2A5qYFoYwng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736557454; c=relaxed/simple;
	bh=ubvcdQSf49WQPJYtSaiX+LcfWGdLPy/DENwF+zM1XQ0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hbxAuyxaIfbrR3ukCZozRwGh24iztQZzHVQI5IG+QeaLGXiDtGqmD0fej/U6fjQ1B0mzTZJ+TQn3hjyDJvoqiXbtFJiIgVN6pXuK6wx+yNpziCPjiSpwa6eJ0tgV1gedtSqeGtXKxoAkzwKA8Av505zW7m6V9ZL6XabEmSMbGMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vo1sehcu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so6698742a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736557452; x=1737162252; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C1lLvx18ixn32RWbbfHmJOiBZT3jaFF5rEyxan45AIY=;
        b=Vo1sehcue/vQZWzOijTl6YaVm3bSWTdv/vFVGAzOB2Qo7P14AK1nqsuKZ/+97qgDdw
         GfsxjPFI9OSAndpBMgUtTkPiyCxkqmd5zAwN6nFyb29iju0H6YHunB0cRnWJiWz01ij6
         S7sJd9drGCI7MC3iua3mh2UenKjofEOZr6rrxBN73Dh06GzXhVrODTiSv7NIaiTq8lEx
         GTN0Co4GsVPAhmG5/VeXXyo+2qQ+Uwo8ASvCOgY3xP7+O5mGf2pDyzPyxM08fQaxkfMi
         hP0V1Dnqjpr8B5QLLKL6f0zG2IlDJU8A60pbogVmE3haCTKV26NbZHL2zKCu3U1tHBv0
         oEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736557452; x=1737162252;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C1lLvx18ixn32RWbbfHmJOiBZT3jaFF5rEyxan45AIY=;
        b=uvqT5UbwehJ5NPfbHta8oQQC/XWUj+AaeVWJvI7uS2j+FbqWT0md65z8l+6w/VNrVq
         FgjG5qRbYyR0p5sAnefcWmVlXNM/WzxzVIBr7v5vbphqps+kj2/e3pgpMCeUuD/Ufmp4
         l4dg7RYkcRK7livPxAHqPS13Sa9a0wUONKgV+14FQ2rDWGWdA0ze8QnTwW33slwjl9n5
         p3Cu9F+3zliPmoJcjpIJ69brJ4WfaCWsLwjF8sOCu62ieljH6y04TlyIErj1vau9KHSz
         7U1ip3aSVlmITPbbrkid3VVIXABu9G2v9/XxIo0St/G3hByIBAaYKfzv5DgFIadNb7oJ
         6JkA==
X-Gm-Message-State: AOJu0YwvEmtW76phoVzKG6Ut65CTwzqLpGgqX3BNWPurMxCj1N6WsQ3q
	pJk0qwGYOgiKmuhVGLHXw2B3hn5BesNp2/0F5xcTac/cxg3wdhRIopsSo3M1lnZvVkpQpKfs0RF
	jlQ==
X-Google-Smtp-Source: AGHT+IEN/yl96LS/AHIjJRAdcHtlc6tfxCghQ1DGq/QgGNvLdpsPNJljjDsPAiMo435FQIzUODaY2E5ln5M=
X-Received: from pjbok3.prod.google.com ([2002:a17:90b:1d43:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d05:b0:2ea:83a0:47a5
 with SMTP id 98e67ed59e1d1-2f548f17337mr18334065a91.4.1736557451967; Fri, 10
 Jan 2025 17:04:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:04:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111010409.1252942-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: Dirty ring fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Yan's series to fix a flaw where a buggy/malicious userspace could coerce
KVM into corrupting TDX SPTEs got me wondering what other bad things userspace
could do by writing into the dirty ring...

The main issue is that KVM doesn't bound the processing of harvested entries
in any way, which allows userspace to keep KVM in a tight loop indefinitely.

E.g.

        struct kvm_dirty_gfn *dirty_gfns = vcpu_map_dirty_ring(vcpu);

        if (fork()) {
                int r;

                for (;;) {
                        r = kvm_vm_reset_dirty_ring(vcpu->vm);
                        if (r)
                                printf("RESET %d dirty ring entries\n", r);
                }
        } else {
                int i;

                for (i = 0; i < test_dirty_ring_count; i++) {
                        dirty_gfns[i].slot = TEST_MEM_SLOT_INDEX;
                        dirty_gfns[i].offset = (i * 64) % host_num_pages;
                }

                for (;;) {
                        for (i = 0; i < test_dirty_ring_count; i++)
                                WRITE_ONCE(dirty_gfns[i].flags, KVM_DIRTY_GFN_F_RESET);
                }
        }

Patches 1-3 address that class of bugs.  Patches 4 and 5 are cleanups.

[*] https://lore.kernel.org/all/20241220082027.15851-1-yan.y.zhao@intel.com

Sean Christopherson (5):
  KVM: Bound the number of dirty ring entries in a single reset at
    INT_MAX
  KVM: Bail from the dirty ring reset flow if a signal is pending
  KVM: Conditionally reschedule when resetting the dirty ring
  KVM: Check for empty mask of harvested dirty ring entries in caller
  KVM: Use mask of harvested dirty ring entries to coalesce dirty ring
    resets

 include/linux/kvm_dirty_ring.h |  8 ++--
 virt/kvm/dirty_ring.c          | 88 +++++++++++++++++++++-------------
 virt/kvm/kvm_main.c            |  9 ++--
 3 files changed, 66 insertions(+), 39 deletions(-)


base-commit: 10485c4bc3caad3e93a6a4e99003e8ffffcd826a
-- 
2.47.1.613.gc27f4b7a9f-goog



Return-Path: <kvm+bounces-53481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88762B12671
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E4FB1CC45B8
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D3825C6F1;
	Fri, 25 Jul 2025 22:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="03V7FVBs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A5F2571DD
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753481242; cv=none; b=C+3NuAMPJ2ucJ1Qa3FM4QwQyAa/eCEJxSv/JRpyGmlpQUfx7jAnkxtZWRdmoOCtCTwgdU8HBmtMw5Clzk5NMavCFZo31QHr4Om/mXFF/1Pq0e34tr/40pL6coKm0dBPZjW3+JE7Y8pukSvr9fZL2uA8+/pz/HRj9juuCgaAmkxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753481242; c=relaxed/simple;
	bh=dOClt1NwvDVpRU80gTFWcyuWOIvVeKn+ThhysRynZpk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cxyZ6VwNi5kM+28eR7cXaVUQU+1g2YUGtxztzc7j6rgKqlTVvom5+5tUVC+7IB24k9dBhHGfR2iu6e4UoemzcomwXoA8EwEJGUUM1nIdMxLZilXq5p0HiDoKFXcaBTho/qrZdpfjNQpumPFEx5YBgy9xTZ+igzqGBOBHG1YFUZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=03V7FVBs; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3f33295703so3260404a12.1
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753481240; x=1754086040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tBeOKKUu9MDa10fqJN9yMcoaQctbrDlnjx6wVe8w2s4=;
        b=03V7FVBsJuaO+bs4PQNpAHM+QIXNFV77gO80TKvm3fdMqsrubuw7WvOyXLl5PgQqWi
         wUdgbewLu8mllwxvRAzTuT38EBgn4pdQncuYVpRGGvOrC6eZT4zWiUaNjDQ7Y6njw+P9
         gTM4I5/uahtUg19sy+kPDUZfQxSIsJFA7Up8NBqV9amFGtAeMag5Q1HZHHcjgb8R4Zfw
         gCrx2uFadC2MNOgBthCUNaejCENVA1MSuGy6esNBk5uvbJAj4rG7uFq7mCU9nKZO1q2R
         ugwx6AuLYi7CRa2D3Eb0sRCDehqZ7wczIhl8DOexg7AXn988VXhuT50n6/BbvVvJEQAa
         0SbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753481240; x=1754086040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tBeOKKUu9MDa10fqJN9yMcoaQctbrDlnjx6wVe8w2s4=;
        b=ANKo7TWSdNU1qC/XH2CtsfboPmIcINaUZ+KlAK+UKompXjiKAC6z9Y7IZuAXTTpLos
         A8f2Vbu1hjmtETyhtp/FuqcDC0uQX0lxnJ/s7inToMqaj3xp40T/Nvbc+OQk17G4pHcb
         EvuqDnaASOrwGw4gOL6c1hWXpnR1xOh5ljrghwCWGuhIJGqIl8916d/FCvSO+78W4+5i
         B4Qt9SyhCN1JI7fS7dAadmvOdxzrZw7GtcObqKUxbNNipdFrzTvPxa2k6ScvVpzEBbve
         dofeEJMyqawm+uePQWn/dzp8CtkGT1GBLqjmEBYjyuHEeaOs36Hljmsf3PrbT+ugRMxf
         cn6A==
X-Gm-Message-State: AOJu0YyAZPnhxnsLb+Ake/kIk1i0MClQ79Fx2r4HjGePcEAvcCOmeUgi
	9MvY9TQbQtwMjhBa/rXLWgs7XWuqRnYj2CCErb+T1XcFWsZyavzPaqjyYzMNWdgXt2p3vg+ZQjp
	Gfu1M9w==
X-Google-Smtp-Source: AGHT+IFKtV9YCuYm4GMi+ww4GUsiHDRGAnCY76kK5cmeJMRiwgSG/xrwCu5Vp5xBw7Fb5VOjtzhjarlLP1U=
X-Received: from pgmt19.prod.google.com ([2002:a63:2253:0:b0:b3f:3788:ecc1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d19:b0:220:9174:dd5f
 with SMTP id adf61e73a8af0-23d70053439mr6107339637.15.1753481239990; Fri, 25
 Jul 2025 15:07:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Jul 2025 15:07:02 -0700
In-Reply-To: <20250725220713.264711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250725220713.264711-3-seanjc@google.com>
Subject: [GIT PULL] KVM: Dirty Ring changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A set of Dirty Ring changes to fix a flaw where a misbehaving userspace can
induce a soft lockup, along with general hardening and cleanups.

The following changes since commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5:

  KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities (2025-06-20 14:20:20 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-dirty_ring-6.17

for you to fetch changes up to 614fb9d1479b1d90721ca70da8b7c55f69fe9ad2:

  KVM: Assert that slots_lock is held when resetting per-vCPU dirty rings (2025-06-20 13:41:04 -0700)

----------------------------------------------------------------
KVM Dirty Ring changes for 6.17

Fix issues with dirty ring harvesting where KVM doesn't bound the processing
of entries in any way, which allows userspace to keep KVM in a tight loop
indefinitely.  Clean up code and comments along the way.

----------------------------------------------------------------
Sean Christopherson (6):
      KVM: Bound the number of dirty ring entries in a single reset at INT_MAX
      KVM: Bail from the dirty ring reset flow if a signal is pending
      KVM: Conditionally reschedule when resetting the dirty ring
      KVM: Check for empty mask of harvested dirty ring entries in caller
      KVM: Use mask of harvested dirty ring entries to coalesce dirty ring resets
      KVM: Assert that slots_lock is held when resetting per-vCPU dirty rings

 include/linux/kvm_dirty_ring.h |  18 ++-----
 virt/kvm/dirty_ring.c          | 111 +++++++++++++++++++++++++++++------------
 virt/kvm/kvm_main.c            |   9 ++--
 3 files changed, 89 insertions(+), 49 deletions(-)


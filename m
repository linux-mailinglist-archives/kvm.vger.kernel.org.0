Return-Path: <kvm+bounces-23278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99799948613
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E9881F236C6
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EFC16C696;
	Mon,  5 Aug 2024 23:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ih6B4TSd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78219179647
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900680; cv=none; b=rpFNPCt8umRt0jbYHWa2/BL4HHq4XjxsXzilDEmAra0g9y9bqbygmvSxVL5qafWi6LZAftTActDdkrU9JApEBwewEFO6PZVZsHHHS2vc6hGyLQ6jkWqIG8hN2AU3RN2HQyboLrL7G8g0YQ2hyOOzS/I2DlP9S1ePKV2V531VFW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900680; c=relaxed/simple;
	bh=ADcwxpdHTPiaAcfGEiQ3Xvxu+bhWBnQKOSbUAHrn8Eo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bPfhyeOV7TDBk7ZtpOqMPlidjhiyY/LP5jBkbThB5sYcDr/GScU42lkvFox9R3zr8cY1X4BoBeWrwNzSIwCXsi22e45/JU/7L+GDLLkye46MZ7EZT8nA6V8gOrC5zPRyZfaGSbUgiATLL3QsfeENJ/+azJiVIZP+6Nl9NIJwB58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ih6B4TSd; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e035f7b5976so768904276.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722900678; x=1723505478; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YBHnNUZOkKDZEcVLCmg0JSOz3dIcr5wLjIX95iMEkyM=;
        b=Ih6B4TSdhd+41Gp6He//wc3AiglTRi3w2Sdn/ib+vLmn0V4GIqg6Q44SrL5V6yYhjE
         OjkJOJE5rSvWaXG3kyS9jT9v0FLV9T/Va4W3UG3KDwDKGVrR9zr4UyH9hEog+YKnDm9W
         qBEwF78zNACYSJvZNYSvJ8+0qVwG5ziv5mwZbL6/HjvLeTttEdehKEtmNpjawOpqwuJc
         Y5+4yvFr/mIEirc5m72fhtNKELUkOoEiwp3NZ0OAmC3C8ZltSZ4Kjmn2WsGMlPW6u4l2
         pintI6Wd4hoXZisPDZn8I85R6fNaBfEjyJ/3JQN3+KlM56Nn+2CQaJTONcT4EZY85y+m
         hfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900678; x=1723505478;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YBHnNUZOkKDZEcVLCmg0JSOz3dIcr5wLjIX95iMEkyM=;
        b=OCk8XTpY5//MWzTzbXhO1OaCO07UVBi1+cmUfK++0rGZdUFsHM0BTL5YZEQY1A2P5F
         rfjzHxSOrg4uMPcYNJPB3G+QZ/CJc40wxTU5iGGpLfpXD6y/r6HNYn+pHHr7BBuggTB2
         r89j1504EykWmOPEOyOKIKe23i9UbdSL++DGGfgONQMJUkxYXKEpazf1GJ/qoDDi/Fpu
         BE8zYiWknrZeRB3XJ/1plazxxa7TvJZbUQdspBIaRKHgYVgJRIm4AAo7eCi31Sct0gv0
         JrInD6khE4DA0DNBUBiyjIxTSxKMquuFhivXrPGJf6oWG40R12cWofLz7FaW3KxukXNN
         3sZg==
X-Gm-Message-State: AOJu0YyeiO58U8X6rrEBJkFyMm7jGqsOBtaLBkyvSYjU/BxVs1l5vdRd
	++0kdk/HjzGBIj+YtQwHVaoQwJ+6MCYOUw6KknzUmGIxarmeYZhwxqG4MwQmQaMjwZ327vLzsW1
	sR8ySwWMv6w==
X-Google-Smtp-Source: AGHT+IHIHbdKFewNVSvW+Dk7O/L8Q2sW3gBk/kJwdeOuMYfuR0jutmAMqyYI+XPvEEQ0piPWRA1fID3pqpFYDA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:c47:0:b0:e0b:f6aa:8088 with SMTP id
 3f1490d57ef6-e0bf6aa967cmr199623276.1.1722900678439; Mon, 05 Aug 2024
 16:31:18 -0700 (PDT)
Date: Mon,  5 Aug 2024 16:31:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805233114.4060019-1-dmatlack@google.com>
Subject: [PATCH 0/7] KVM: x86/mmu: Optimize TDP MMU huge page recovery during disable-dirty-log
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework the TDP MMU disable-dirty-log path to batch TLB flushes and
recover huge page mappings, rather than zapping and flushing for every
potential huge page mapping.

With this series, dirty_log_perf_test shows a decrease in the time it
takes to disable dirty logging, as well as a decrease in the number of
vCPU faults:

 $ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 64 -e -b 4g

 Before: Disabling dirty logging time: 14.334453428s (131072 flushes)
 After:  Disabling dirty logging time: 4.794969689s  (76 flushes)

 Before: 393,599      kvm:kvm_page_fault
 After:  262,575      kvm:kvm_page_fault

David Matlack (7):
  Revert "KVM: x86/mmu: Don't bottom out on leafs when zapping
    collapsible SPTEs"
  KVM: x86/mmu: Drop @max_level from kvm_mmu_max_mapping_level()
  KVM: x86/mmu: Batch TLB flushes when zapping collapsible TDP MMU SPTEs
  KVM: x86/mmu: Recover TDP MMU huge page mappings in-place instead of
    zapping
  KVM: x86/mmu: Rename make_huge_page_split_spte() to make_small_spte()
  KVM: x86/mmu: WARN if huge page recovery triggered during dirty
    logging
  KVM: x86/mmu: Recheck SPTE points to a PT during huge page recovery

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu/mmu.c          |  16 ++--
 arch/x86/kvm/mmu/mmu_internal.h |   3 +-
 arch/x86/kvm/mmu/spte.c         |  40 ++++++++--
 arch/x86/kvm/mmu/spte.h         |   5 +-
 arch/x86/kvm/mmu/tdp_iter.c     |   9 +++
 arch/x86/kvm/mmu/tdp_iter.h     |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 127 ++++++++++++++------------------
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              |  18 ++---
 10 files changed, 121 insertions(+), 106 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog



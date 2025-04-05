Return-Path: <kvm+bounces-42772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CBBEA7C6D0
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 02:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2E90189F01B
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81120366;
	Sat,  5 Apr 2025 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qbmowckC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C595383
	for <kvm@vger.kernel.org>; Sat,  5 Apr 2025 00:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743811846; cv=none; b=N+VGJUSLDp+/BCWkTA5RYRGT7PLbKqo9wNFbVrKvFsaDIjxg7q3U+PlGjXXy5dx9HG3T8jnLwZsW1DqikPPTOUaToOgjyHKyCHapqOctXMlbT6PFsmPtFMq2a3jKbf3hotmRrtEeRdtxR9MkWM37mzrHR6c/e7+KbZt0okB0lXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743811846; c=relaxed/simple;
	bh=9OLt6CxBIy6kqbClRlpyjmlyZ3nlZBIi/b6vLEkxDsk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kOLmu2rWJ59IeufD0zy8KH+qiT9k8whUYpF/rYGAPePfIROB1kB6TPQa6jjmsvImvyYEZzLixWjj2wlLiqntX1zywy2Lqt/1ZSU0dC8xpW5q9BFC5jPmj+eW3PIIJCNhbP+4HiDDAd9BMf+xxb2L1nhq5Iot01VpV2g4QDAe8MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qbmowckC; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-8610d7ec4d3so468467339f.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 17:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743811844; x=1744416644; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2DNvYO0bTfj7X+8PQ13cmGZGTNT4dkdJknnzMC9cIXk=;
        b=qbmowckCZVnv6vID2Wd1kKSBQ6IxjJUhQ+3TsMqsu5z9LhKAOxiphE/L3+sK3cMqKT
         EVgABvnXzUHDebplvyC4+TnY4WQPG3tGsBkP5lw04hLY2z7BKKkuPTsQGTprqK+R9I16
         lLSLrwqOF4bY0R/DnDin1y3/L/IZyZyLuqQKehM6Wr9jPG7OiHwczmB1sq+l5GipMZkt
         T5coN4Kh6Gn5tyrkhjmJbO9+FRsRpPa1Zzy86TbqmjBafeKGLIMsGqXkNcvP2oq9Tx8r
         Dvh+PAslSaw+sqQPbE70KthqqXQaZ3hNHhGjNMHcRX/azXDcwc2AawB0sIalftLGrnrt
         3coQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743811844; x=1744416644;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2DNvYO0bTfj7X+8PQ13cmGZGTNT4dkdJknnzMC9cIXk=;
        b=EU9cYq1kWwRi7rGd9/CLDzIbKW2lMKFHR5b1YDqYScgPEA5TXc6y6qrt/q/yX6z+3A
         P1vFALIRgeDiLKKRwTB6yi2oaKgPDXk61YTrVSt6qINfsikrpQbwz+vrD7IcNIL1Ojek
         X8trpOwCkU1fcPOzaRurTaBOrTDiv84tq4nuOXP834prHOCfaZRdwiT9RgIo9S5k+Y2L
         V+TWpVwrXM5F4bhsPnw3M33DQMynlxJ/kuNt4jaP+M+mo13E7RoInsRynveMcpa9jjB/
         N2H2hRmZcx9MTpzo6JF7lDOcFV/LN0mIHQ0hKIHNJybQh8cZdKKTjKxiCdue8yt4LzBP
         ArXg==
X-Forwarded-Encrypted: i=1; AJvYcCWzxJmcvfgvZ52hdKnH2pRsmYP9RSQI8Ia0907MOUBevSv6vJcPDZshhmrKWUPvbmvQQAw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMSxmIKUgzf198tbcRgMAy789NoARoY+UO5hYFeV0AjQmT3f6K
	7RZGqpcDqJJAOahV6CplH0DkMAZJ54kqMSu4UHCofFi0g8RBS+/cJcUYq4kUlcj2RTyxy5ILy8R
	NMKcDHg==
X-Google-Smtp-Source: AGHT+IESzYBYMsy8TcNeSXmOCuIMcY0rfkLLxruZnkYbIer8gFLQRo6rMLnXbA8I1jN134maNpjGU7IZC4nb
X-Received: from iobbk9.prod.google.com ([2002:a05:6602:4009:b0:85b:3e10:d317])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3a12:b0:85d:a211:9883
 with SMTP id ca18e2360f4ac-8611c3bae5bmr467620239f.10.1743811844346; Fri, 04
 Apr 2025 17:10:44 -0700 (PDT)
Date: Sat,  5 Apr 2025 00:10:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250405001042.1470552-1-rananta@google.com>
Subject: [PATCH v2 0/2] KVM : selftests: arm64: Explicitly set the page attrs
 to Inner-Shareable
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The series fixes a conflict in memory attributes in some
implementations,
such as Neoverse-N3, that causes a data abort in guest EL1 with FSC
0x35 (IMPLEMENTATION DEFINED fault (Unsupported Exclusive or Atomic
access)).

Patch-1 is a cleanup patch that replaces numbers (and comments) to
using proper macros for hardware configuration, such as registers and
page-table entries.

Patch-2 fixes the actual bug and sets the page attrs to Inner-Shareable
by default for the VMs created in the selftests. More details are
presented in the commit text.

v1: https://lore.kernel.org/all/20250404220659.1312465-1-rananta@google.com/

v1 -> v2: Addressed Oliver's comments (thank you)
 - Moved the TCR_* macros from tools' sysreg.h to selftests' local processor.h
   in patch-1.
 - Adjsted the citations to describe the issue more appropriately in
   patch-2.

Raghavendra Rao Ananta (2):
  KVM: selftests: arm64: Introduce and use hardware-definition macros
  KVM: selftests: arm64: Explicitly set the page attrs to
    Inner-Shareable

 .../selftests/kvm/arm64/page_fault_test.c     |  2 +-
 .../selftests/kvm/include/arm64/processor.h   | 67 +++++++++++++++++--
 .../selftests/kvm/lib/arm64/processor.c       | 60 ++++++++++-------
 3 files changed, 96 insertions(+), 33 deletions(-)


base-commit: 38fec10eb60d687e30c8c6b5420d86e8149f7557
-- 
2.49.0.504.g3bcea36a83-goog



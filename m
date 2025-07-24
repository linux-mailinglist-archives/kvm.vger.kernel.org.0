Return-Path: <kvm+bounces-53405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BD0B11326
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA7411CC7F03
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F598233739;
	Thu, 24 Jul 2025 21:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cLT25Ls+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04711F9E8
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 21:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753392696; cv=none; b=l/PrGjkfp/uiu2z7cCEvhrKOlbkoMUQBQoB57EeYJ6lbwiaaHKYgyUfYESdbkVV7JKVnDnvyEKn5JJAQFfeDSzIq4ZsftNCJjV+p4EzNSTJmKMRjHfy90cUMxj6+v3zxA0IZ6NS++VdLIPoOffn+nmwhinb2uZeIH1Xo7n8cvRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753392696; c=relaxed/simple;
	bh=VwQ1GtFjq8Dpgpvt0rSmdm1agQOX24Q/RazEBlQR47M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QB/81+HeyEiwSYAwXWIdHU9d9a5gRY2f/aZZR1qmklJ/CbbqccWXhiiKAqdsfTh9eUpDhmoRZlGvJE3ZHt3p0GUT1LnG+0KBmskmNwQI2kHG17CZ2HyJEyXmpNbHxuqN2No1sCrAp3QnBolZk/rKjLw6QxzLeq5dndJ9l2DKnkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cLT25Ls+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31bc3128fcso2213040a12.0
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 14:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753392694; x=1753997494; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yoZKgCIOrO9fiaHmGjZ2KQUGK1Rfay/CIlSycJOy6hU=;
        b=cLT25Ls+mQzquHFePVfPMm3vvITy6+129J3WTO4IEQZL86wo3+X0zjrX1gqSsHkZW/
         sQmzrTBsilTnT5lS2/q5xxSNG27PkaBgpTuW9Nezd3Sf40cI2zdB5LGRo44b+emozVFE
         j8TYohofW7wp9skprSRSamm5eP6SO9UtOFxjjRmz7YzXCMJy0uN5gWmnamZdUmE6ur2p
         Yxye2h+IkWar94ZljPnTuUeGzcji7YuRD4+f7/9Op9CdkDwIZ8L8NXq/vwk8mDeMLDjK
         EmDuKCSZWHuv3i/OGJUpFLIG0RgYPpgiQG3jfCTEJaysqCe0IVbhetPCoZ8EDdEPw834
         bI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753392694; x=1753997494;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yoZKgCIOrO9fiaHmGjZ2KQUGK1Rfay/CIlSycJOy6hU=;
        b=Sq/TZ6LDdvg9eB7kPnJlRmx1Q+2HOrt36/gm8bDufAsEtSuIDxQhe7UkPMy3iafBwp
         YROlkq6o+IfOz9ePIhmJom4AsBa3RD5L90WkzbY5xO0wYZAbnMDEU4C3aV3xLNFQQfcd
         W7I5DFEYgV1uDBltuU7eLsIWPgKnstbANysvebCr4oizDnq/jZD/wwMU+t49bPu3sVFi
         Er7rOHfL1ZsXDOMkCdN2m9DC6aRNdlzFpfVyh/xZFZFtwJhSEKAQ9fw4uMaEZA0/ei5a
         pg5rybyDjEAXj+vVXJGUjoFZ2kI8ICbnxlL40bIK8Bd8k6EAt87EIUmlicZuBOMftoqN
         lOZA==
X-Forwarded-Encrypted: i=1; AJvYcCUsOSg4402f+oSzWTNTKtwhhfG50qacGDHmHNFEo/ja30Onrc6Y9C63KlnIFWkVg5tFVdM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqmw+qjEXcRE0g6T94KiUD7HsfSe2p+fgllgbc7mckQct7PSLl
	1ioLZdIJKyixfcgjlkFqcW4wgBSeaSlMeSjtNYcrUtnuHN2u9C0LaOJqfCdxd/sB4+8GXzRoiUS
	WoUxSBx2SeETEUQ==
X-Google-Smtp-Source: AGHT+IGa4HSIvnJk8xlqcYJbo+CMkm2iwXvpM9aLGNVhXmeXjm7wBYtftdzXI2DPlbRHTaPn9OI4bV2dd7uSvA==
X-Received: from pfxa12.prod.google.com ([2002:a05:6a00:1d0c:b0:741:8e1a:2d09])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a125:b0:23d:45b2:8df7 with SMTP id adf61e73a8af0-23d491c0514mr13047162637.34.1753392694322;
 Thu, 24 Jul 2025 14:31:34 -0700 (PDT)
Date: Thu, 24 Jul 2025 21:31:28 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250724213130.3374922-1-dmatlack@google.com>
Subject: [PATCH v2 0/2] KVM: selftests: Use $(SRCARCH) and share definition
 with top-level Makefile
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

This series switches the KVM selftests Makefile to use $(SRCARCH)
instead of $(ARCH) to fix a build issue when ARCH=x86_64 is specified on
the command line.

v1: https://lore.kernel.org/kvm/20250430224720.1882145-1-dmatlack@google.com/
 - Split out the revert of commit 9af04539d474 ("KVM: selftests:
   Override ARCH for x86_64 instead of using ARCH_DIR") from the rename
   to SRCARCH

David Matlack (2):
  Revert "KVM: selftests: Override ARCH for x86_64 instead of using
    ARCH_DIR"
  KVM: selftests: Rename $(ARCH_DIR) to $(SRCARCH)

 tools/testing/selftests/kvm/Makefile     |  8 +++++---
 tools/testing/selftests/kvm/Makefile.kvm | 26 ++++++++++++------------
 2 files changed, 18 insertions(+), 16 deletions(-)


base-commit: 79150772457f4d45e38b842d786240c36bb1f97f
-- 
2.50.1.470.g6ba607880d-goog



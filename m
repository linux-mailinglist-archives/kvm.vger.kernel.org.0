Return-Path: <kvm+bounces-23160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E973A9465EC
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 00:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C7DEB22203
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F17F613A245;
	Fri,  2 Aug 2024 22:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f6aOTMue"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53C913C3E4
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 22:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722638463; cv=none; b=MTZqD3o7HNXJ2Jg8yRL/bM685e3Oww1txNijXBIveDsQ8c1tdUgyE/BSR2xJQTPx9lhlqCViOVTx/1+IVwW0Ai7ZVYfmJRPFXE7Cfr4lyUtShBTirIo3Gg7XKe6tieyVPId4M1r80miZPCtIN+FlJEj9f0vfnhZCL/tys091Ejo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722638463; c=relaxed/simple;
	bh=qr5BTy+0rP4m99VwQ0GuNK/YeJP/WBSk49NkTt1nPdc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=X7Aj2PjVIRT5ZqdWEn2EV3oTtAYuGfSufURS/jJ07niBm+zat52Zz/I791ZzEncqzojmwCzrAN6f5MUX6Qinjy1pkaM4YN0InkKkLPrTQL1gfqgAQtFY+6k57FE+RZtJYgDEmK6eiC9Bg5S0LD/OXnL0L/VWwQjLbGlUz4nqhv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f6aOTMue; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-672bea19dd3so187365587b3.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 15:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722638460; x=1723243260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XoExkem0pI3PQlrsfFLGIInPgK2Os7OnG4xaWi9xIB0=;
        b=f6aOTMueMTSpxOl8NLfQkzBSLRkGt9H5UPo4QClFtuBmvb/+29ne6ShX3w0OZnLCRY
         d5U5K57V63ZOcuWOAg2Op09lFeLGCH0yex5iBF8ZQCHcInb9fIUEvw9geHZZHPyM3DpK
         ZBlou7/eHiS2boPmDeNcE0K54z4SnjrSrh57RJGp//OapS+/MVSjQQ3ek2QOAtGiLryL
         gCeQBSYVEa8fip0aRXlNHYbOz7yo+qFYWNDlz56SEI4XCp0TOpAjGq5k8t8LyngLCv9j
         NKbyaDTeWYbcxZwRVdwlUcfa1cuwzXM3ulsrRJtCl7VdQOws7PFnqqPQ9QCDQiytMcL1
         QaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722638460; x=1723243260;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XoExkem0pI3PQlrsfFLGIInPgK2Os7OnG4xaWi9xIB0=;
        b=p5mkUlPlxH0s4c1RdrcFYh2TPDRIg6gC+kwmPOgX8Mv/oea5xWOKxFXbLfnZZaIKlk
         ZhLQ8DEfwVjfhdbHr0YyLLNwSUobGiS1yysB14rs9/ygglgY/kywQo6RPk8PGeTcZnH6
         wJ/ZHkeEv5nx3XQZh2cbMEI3w5q/VAuyrD4FUFyqEbvhwqSKZ7KstK/VmTtvsPjDzMI7
         7BrakS9SgTRM3mV4b1ini9pQuAZsoCGmXKTbd2dECsm6dFgQQ6fGqTagJoAq8MDE9oTC
         VixoCe+4fMXN9B1QMu9vMqrNZB3DLYEZAQZkkQDMPxG5fuA83IppCF88T8fzMibdetaM
         MS+w==
X-Gm-Message-State: AOJu0YxTMUOQ9yBv59VSh99pWltADhw8e45/6JVqfQnZNX6ddnKEhpkF
	j4BibXlRdhru/JdRwEFpUoErAuBB2UMbadMi6cIMuKtExO3Vj9ROvdq/bbcQYOh+DaRXDy8Fc/9
	eFQnTJRGNGw==
X-Google-Smtp-Source: AGHT+IHWsNULlr0OmaF5l6nZ9yDeq3lPANgbS+u1ex6NibNf4/8aS9SuVg1An9LGCqPy2z4RP/nXzJOyr2/9rQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:690c:86:b0:673:b39a:92ce with SMTP id
 00721157ae682-689601ab898mr265957b3.3.1722638460490; Fri, 02 Aug 2024
 15:41:00 -0700 (PDT)
Date: Fri,  2 Aug 2024 22:40:28 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802224031.154064-1-amoorthy@google.com>
Subject: [PATCH 0/3] Set up KVM_EXIT_MEMORY_FAULTs when arm64/x86 stage-2
 fault handlers fail
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, jthoughton@google.com, 
	amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Memory fault exits were originally conceived for the stage-2 fault
handlers in the first place: it's probably time they were actually added
there :)

Sean and Oliver: you guys were having a discussion on the arm64 patch
the last time I posted it: here's the link in case you need it.
https://lore.kernel.org/kvm/20240215235405.368539-9-amoorthy@google.com/

Anish Moorthy (3):
  KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2 fault handler
    EFAULTs
  KVM: arm64: Declare support for KVM_CAP_MEMORY_FAULT_INFO
  KVM: arm64: Do a KVM_EXIT_MEMORY_FAULT when stage-2 fault handler
    EFAULTs

 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/arm.c           | 1 +
 arch/arm64/kvm/mmu.c           | 5 ++++-
 arch/x86/kvm/mmu/mmu.c         | 1 +
 4 files changed, 7 insertions(+), 2 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog



Return-Path: <kvm+bounces-42328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA9DEA77FAC
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E84303A827D
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 15:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E6820CCD1;
	Tue,  1 Apr 2025 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MwRSWpfI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D18F1A5BB0
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523038; cv=none; b=R10H6itqpubtmpoBbwrcapSbv6wD1k5m6ZE4tQ//AyehsXQ2OAmISDKyYqLLun+8twEidzx3kj0llbHTDEMo9MIzb/GyT8PqwxL9PLvF3hSyu5NEE2ADm4V1EDToxDsai+o70ct8XZEVG+5F7mDzbYnFOKkcuzONPhMD+JnZDF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523038; c=relaxed/simple;
	bh=obqid5OTuUiJ6SyGoQK983caSLzqcVx2n1aei7l+4lY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BG4/rznSYHTsxpSnkw7nEf7zdGF3b+wIfi7v9rU3GQmfvCfGM+F8Ncj2cBR1BNpP1xekZejp2cjAlaTa15iozunHFF93Ov4spiH4G4TE874AKd4GMQV2HFxERKvB5EDOIwuUje2Pns0Cnk4Eevv54YYluS7PN2GvH55DDJYimO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MwRSWpfI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff8119b436so10373506a91.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 08:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743523036; x=1744127836; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RwEJMH/OVdyAVJGbpVaPUjh6MC5dBrEtc6HhlWCyuNE=;
        b=MwRSWpfIeiHD4PS7/U/vfLFOEpmyWfBTkyHYJY+tPJafKsyDR3YdVgZXAHRlL/ZAZ5
         Rzih5x5hJpcLKtyvaYAbGmfgMOhc0WsSMcT1rAJizbKEQce509pwQbopilJKSpx44OpA
         E/xRk9Z48PnDvcLH1a+1pwg7yZ1gWFn43gk7TIY11ba4Uvgg1uJ/cPx5FSllyJlisgxP
         uyDsgoyYB9FYxkAPJtg6oRB2nowz1Dlf0BpVYdw5q3AsgmclZbkgXRMiDe/OrwP2To5y
         nnNkhUOPXZdJ8S9y4g39c85RKsZDYQEpDZ/Vm074KTNBTj/opPXA8ScJa9oVkx46gOY4
         VmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523036; x=1744127836;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RwEJMH/OVdyAVJGbpVaPUjh6MC5dBrEtc6HhlWCyuNE=;
        b=FUNqIuB4ULNIietn130FM/l1H9K4GSvIGlZw5rqk0eCvoESz+SwBAj/iMTJ9eACr+y
         o/UL47oDfhINaXdvR6iRiUoSZK+q5F7zd2JE8RpZN9pqsXtJe/umqBZGsgleYD7J5A8p
         vmaWFGIJv7jStF7bqD8Ct449z9qSbET+XZVyZYG9uPpxjB03uUUZw225KTHvFmYDCKWL
         lgWhBBYt+pO6S7UPIdoOQlUkV4y0Cpwn9IMlXSW4OeGtgD5lSsOp5FkoY1lRCINM0Y4K
         J/cYIR8Vt3gOOaJRX72NrNdRiOx2DqRsWNn2lM9lO4a8qdMXv7amBdRgrGzdxlJ/mRrv
         A0Sg==
X-Gm-Message-State: AOJu0Yw7vabruYNqtqu9OGL/77G9rTCcYcpj7JY3kLxy/UC9KvyH3ZW/
	MgRx2+gr3163OFNSxLHYr8oz9sozofOWmbqdYFoS8UMSRXJsJIsjYl9D8EE5Z0QUY4gq5Uy/ob9
	zHg==
X-Google-Smtp-Source: AGHT+IEEGMrWotPWYH1yWYPkkzZT2YsxQgwxVg1VP5TFnb3c4UoTk9ovqtFpkuDW6Z1KJlTg03ngxZuBS4k=
X-Received: from pjvf3.prod.google.com ([2002:a17:90a:da83:b0:2f9:dc36:b11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f4b:b0:2ee:c2b5:97a0
 with SMTP id 98e67ed59e1d1-3053214596cmr17727293a91.25.1743523036681; Tue, 01
 Apr 2025 08:57:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 08:57:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401155714.838398-1-seanjc@google.com>
Subject: [PATCH v2 0/3] KVM: x86: Dynamically allocate hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Allocate the hashed list of shadow pages dynamically (separate from
struct kvm), and on-demand.  The hashed list is 32KiB, i.e. absolutely
belongs in a separate allocation, and is worth skipping if KVM isn't
shadowing guest PTEs for the VM.

v2:
 - Actually defer allocation when using TDP MMU. [Vipin]
 - Free allocation on MMU teardown. [Vipin]

v1: https://lore.kernel.org/all/20250315024010.2360884-1-seanjc@google.com

Sean Christopherson (3):
  KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list
  KVM: x86: Allocate kvm_vmx/kvm_svm structures using kzalloc()
  KVM: x86/mmu: Defer allocation of shadow MMU's hashed page list

 arch/x86/include/asm/kvm_host.h |  6 ++--
 arch/x86/kvm/mmu/mmu.c          | 53 +++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/vmx/vmx.c          |  1 +
 arch/x86/kvm/x86.c              |  5 +++-
 5 files changed, 56 insertions(+), 10 deletions(-)


base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.472.ge94155a9ec-goog



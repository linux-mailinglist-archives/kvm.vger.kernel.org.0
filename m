Return-Path: <kvm+bounces-47445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C70AC18E3
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 02:11:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D04FA3AEB6F
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 00:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC1224DCE7;
	Fri, 23 May 2025 00:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fAky0Yo2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CE04C62
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 00:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747959103; cv=none; b=kYg/6TOL7d4RD3RN1rA+VP39ixodFb/k0bwxv2C/4JB678S35BBb3dqtCVYB8GTo4LMGkSFO/9GCWtdFxePOhhtLllHqsr7hqqWDF3fa8pvYfrEf5Gn4zD6+qN0wqrKMwpXLP/HwrglsbcnnR5/0Jgor8MQSV4/3XPWwD2NHFTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747959103; c=relaxed/simple;
	bh=sQw+ZBS7btddT1jEyQ0Mw2gQseAOEUbp2G/+0j/KjW4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IaZuffpg4Q/hsaE4YOiwUtXjmpaF2adEnafiMhuGm2wf+6jZBAPkKzUZ0riJxSNLBKnE9y3yebv9nxD3/veAOSwfwhSsGl2b+K6fAgyMUX3N/ZViIonusxqWzhSW/Quq56zCy0HGUl9WaN11dmtu3iku554WZ2/Kmq6IwmzRd6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fAky0Yo2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e8aec4689so7752338a91.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 17:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747959101; x=1748563901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KwOiWiUkW2WRC0f12oP0F8RtFJzWREDgIfvrDaq9yGs=;
        b=fAky0Yo2kTjLoeYgQGklIm0Wf1hvDPZClWzH/9kw/qpgkwAjewvVRhg7FBp3g20QVC
         GMpXOCmUecMHkofEtH+tVW7/s8fEZ1MK/82Srw3nGvdxClf580Ue3kJHpsVhaw5Vesiz
         MsfDJaams/Rgx985H52RbMAaem6ENaTNPBgWuCdvfHQLowGzG1bJYJcj4WRmoJj/ubcO
         NzCkxECUx+q4tfsyY7JK0VHHWhj2HLGBimvVngKh+SI0zZE25tLQ3Arr/8eekV64pNGS
         gW8ChPVrpTEv++jxQskxuLwUZJHzcVRpp7RzGggz78tqadj2uUMQdFJ3bHfd/+MKycLf
         D9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747959101; x=1748563901;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KwOiWiUkW2WRC0f12oP0F8RtFJzWREDgIfvrDaq9yGs=;
        b=EUSToYnrfpqu5weKw3ffWFbDoJaWfwbFuThww4OCT9z/OmaTO5s/c3eY6OzwwGMHiW
         YLEX4dkf9Usz3H73MvKtTq4QdYXG0JY3fVyTcDK9OAAgbfqUR0oDGkIEs3Zk3nOSoV05
         v9BWyc0z9nf5nBvJEGiprexID88AqmSq/Et5PNGoCitaqStrIaAUAXi6IfhoJ6aGry5g
         DtyAzcJUK1j25FjZQHAmFuJObCLPdv5E5UCJBadx0fiHYxS08ssGDfoqVDUK6Vn/675J
         jD1mRMSQVrHOA12rkQ8461EbUUJVT6US0A/p1jUMFgY0rb7E6GVD6wWv+jLAXbcVdMJP
         uzRQ==
X-Gm-Message-State: AOJu0YyYrymvCihHjd/YkxRKvTXQ/0q6D52iK3WsXh1cnd070z4rqota
	Qp+EYh76LJjx5MMkp4Wcf2vSlzJknyRWJbaSggrdr05vmlPvkxS8Cq55WdqaHbftk2Tj6oNd7U8
	yolZNLQ==
X-Google-Smtp-Source: AGHT+IHfJRG6bZqXDGiQR0PkW8vISNvqIJt+BBS5L57W17F1JJXNfuZ6GkBx45/WIbeFHaWld6GcnrXttZg=
X-Received: from pjbqb9.prod.google.com ([2002:a17:90b:2809:b0:308:6685:55e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c90:b0:2f2:a664:df1a
 with SMTP id 98e67ed59e1d1-310e96b5fb7mr1787280a91.2.1747959101663; Thu, 22
 May 2025 17:11:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:11:34 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523001138.3182794-1-seanjc@google.com>
Subject: [PATCH v4 0/4] KVM: x86: Dynamically allocate hashed page list
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Allocate the hashed list of shadow pages dynamically (separate from
struct kvm), and on-demand.  The hashed list is 32KiB, i.e. absolutely
belongs in a separate allocation, and is worth skipping if KVM isn't
shadowing guest PTEs for the VM.

I double checked that padding kvm_arch with a 4KiB array trips the assert,
but padding with 2KiB does not.  So knock on wood, I finally got the assert
right.  Maybe.

v4:
 - Use smp_store_release() and smp_load_acquire() instead of {READ,WRITE}_ONCE,
   and update the comments accordingly. [Paolo, James]
 - Move the kvm_tdx assert to tdx.c. [Paolo]
 - Fix the assertion, again.  [Vipin, in spirit if not in reality]
 - Add a patch to move TDX hardware setup to tdx.c.

v3:
 -  https://lore.kernel.org/all/20250516215422.2550669-1-seanjc@google.com
 - Add comments explaining the {READ,WRITE}_ONCE logic, and why it's safe
   to set the list outside of mmu_lock. [Vipin]
 - Make the assertions actually work. [Vipin]
 - Refine the assertions so they (hopefully) won't fail on kernels with
   a bunch of debug crud added.

v2:
 - https://lore.kernel.org/all/20250401155714.838398-1-seanjc@google.com
 - Actually defer allocation when using TDP MMU. [Vipin]
 - Free allocation on MMU teardown. [Vipin]

v1: https://lore.kernel.org/all/20250315024010.2360884-1-seanjc@google.com

Sean Christopherson (4):
  KVM: TDX: Move TDX hardware setup from main.c to tdx.c
  KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list
  KVM: x86: Use kvzalloc() to allocate VM struct
  KVM: x86/mmu: Defer allocation of shadow MMU's hashed page list

 arch/x86/include/asm/kvm_host.h |  6 +--
 arch/x86/kvm/mmu/mmu.c          | 75 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c          |  2 +
 arch/x86/kvm/vmx/main.c         | 36 +---------------
 arch/x86/kvm/vmx/tdx.c          | 47 +++++++++++++++------
 arch/x86/kvm/vmx/tdx.h          |  1 +
 arch/x86/kvm/vmx/vmx.c          |  2 +
 arch/x86/kvm/vmx/x86_ops.h      | 10 -----
 arch/x86/kvm/x86.c              |  5 ++-
 arch/x86/kvm/x86.h              | 22 ++++++++++
 10 files changed, 139 insertions(+), 67 deletions(-)


base-commit: 3f7b307757ecffc1c18ede9ee3cf9ce8101f3cc9
-- 
2.49.0.1151.ga128411c76-goog



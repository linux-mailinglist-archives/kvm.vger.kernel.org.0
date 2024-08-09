Return-Path: <kvm+bounces-23800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E652794D83D
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 22:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99DEA286109
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500C81684BA;
	Fri,  9 Aug 2024 20:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aw3xbEwm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C47C15E5CF
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 20:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723236726; cv=none; b=B8bIIF0M0WvNAJA3mHB3am6h2W28RZ8VsJ0UqBOtCe1BwsFNpWu/47qvJZFQabRQb0kVerRbdyI3VBAMBlLWsWTCG/oumhVfbnjUpPuAt+3Nk/WRKYbbvxJDClSoI5u1bC6+BctXJV7jsG9gUxXF25zmk+K6h1Eow78NoTsacjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723236726; c=relaxed/simple;
	bh=1anqAy8fT1MGYT3I+PKXHPOtjMAFrcgXwt1RXjcw+Po=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=b3b+CZlwM4bfi+dy9Mu+ETjtecH/bV84YAq93veMC+PLeT3q0iS2d1rxws27ZrH8FV9qNFUT0sr1UvKePjq8LmR+6M0rdG0ueGpxOiifCMUKGGlHpKiDsXQpyZmYTRahFhwFnjip0FcGQa6hvYVQPcKA4oslr/8WdlaIjYH+KXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aw3xbEwm; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e05e9e4dfbeso4434401276.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 13:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723236724; x=1723841524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A4+5TrpZq4HAa4w9PgdpjPk93jtMryZRUO8oHZ/7sY8=;
        b=aw3xbEwmabxYCb7MQCKEguf3k3SCjkTyno9ATnatXih36xdA/OTG75+qc3F4Ha1lw5
         xQQD4Wc0Ke5xwj442n5eKx8KENi9034yWbhN4E4XHNxndI+F41taSx53meu+qFljutAi
         j9UGLLBARjd5uUKSBSaGzbtlumHW4qTsL2ednuVUn18/SBIocH66T2dkwWwqJSMuogyA
         jPYSgntRa34mgnibXK4lrU1DMZxBqvVUTmQXXmj3rTeGbx2y5Xxz/g7c9JK9U721ZobX
         8ef+jZE1kUar5K1NQfII9tAGc/ucWdw4bhm7uD1ww2YVoC852vk1O5YC5SvIafwJKcrc
         J9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723236724; x=1723841524;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A4+5TrpZq4HAa4w9PgdpjPk93jtMryZRUO8oHZ/7sY8=;
        b=PFM+XjcPv2XpvUqOe8+BvvjjbfR2YUiUqnP6OjJb1P8+VJ8c/bZIlqStMV87MpJcNI
         1lOiO3Y2IDvc1TR2ewjHzbaEZrnmdN4aW5ZjcKllvHAtLFcLy7t29KoDjVaYrUAHtoi7
         wba7/H/jHnHBMG0bgjJ60Pdnxu8JEVfuPEsfn6f6NCBHij064XX4iwASSgoT516O7pzt
         VunAcJKtXYj06K9OvaJJG/NEQr4/LDMoXbLrWxdDAIeNh5TmkDchk6nthebWDhY6hmM/
         awzHAAkgAusehPh9DgzsJy6zRz+T0lJcD6+mtRIibiNWidiUeQVY/d+kevBiAfP0sPWc
         VWfg==
X-Forwarded-Encrypted: i=1; AJvYcCX4TulJBZFOPxxOrOTH6xUkJIKxIP4vBmMeV/EnK6uFKP7FROS4sGU3xRN0HLsgmSNjhPG+3jy50PJSKyw5l3pyPnsB
X-Gm-Message-State: AOJu0YzltTkb3kM9psb/ySw63JOmEyvIuSe8jeV2qMLmnsbtJMQQgWqi
	GbndO7K98OwRJOw2qu+jpv2RM77w2NytUl4cz6tARHAm8JJixPuGunNsPKn4KiRMNrdO1R+xeHE
	kP2rqF1zcmA==
X-Google-Smtp-Source: AGHT+IE9n+LsI9d1YYx3M/iz2GdVBTIdsBXN4Gvuxr/50LgDSU5FDsg4j9qGx9xJ04AkL3tGxGnDh3bNCAIxHg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1749:b0:e0e:89e6:aad4 with SMTP
 id 3f1490d57ef6-e0eb977fa58mr18658276.0.1723236723973; Fri, 09 Aug 2024
 13:52:03 -0700 (PDT)
Date: Fri,  9 Aug 2024 20:51:55 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809205158.1340255-1-amoorthy@google.com>
Subject: [PATCH v2 0/3] Set up KVM_EXIT_MEMORY_FAULTs when arm64/x86 stage-2
 fault handlers fail
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: jthoughton@google.com, amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

v2:
  - x86 patch unchanged
  - Arm patches merged [Oliver]
  - Do memory fault exits in *all* EFAULT cases of user_mem_abort()
    [Oliver]
  - Add patch to tweak docs for KVM_CAP_MEMORY_FAULT_INFO

v1: https://lore.kernel.org/kvm/20240215235405.368539-1-amoorthy@google.com/

Anish Moorthy (3):
  KVM: Documentation: Clarify docs for KVM_CAP_MEMORY_FAULT_INFO
  KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2 fault handler
    EFAULTs
  KVM: arm64: Perform memory fault exits when stage-2 handler EFAULTs

 Documentation/virt/kvm/api.rst |  7 ++++---
 arch/arm64/kvm/arm.c           |  1 +
 arch/arm64/kvm/mmu.c           | 11 ++++++++++-
 arch/x86/kvm/mmu/mmu.c         |  1 +
 4 files changed, 16 insertions(+), 4 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.76.ge559c4bf1a-goog



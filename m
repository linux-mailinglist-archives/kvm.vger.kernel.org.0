Return-Path: <kvm+bounces-7890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 003C9847DBA
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:23:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 881FC284231
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E3F136F;
	Sat,  3 Feb 2024 00:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tMXOhuVu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18267622
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706919828; cv=none; b=kBySay8YK9M1DhdbY2XYVIxH9ws4UkIqbUUcVVf+hCglRVw6ewf8xTBvOlrXxo2Ewfbnde/eEbsLW2OyOnkAmxTnsv7Qm+FHbx9+3n3Muuf26qpwoa9nWwuqPQ2pQ/8xVAuPRG6zNfu3Lh6OQfVM3uzyBTl+5xHzp/IamyhkSks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706919828; c=relaxed/simple;
	bh=Ig5QOPcKdALnxA85Z7llLLp9UDM/G3xlM1p/8HzbKgc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lexjZM6BoIKYyCpnmCCT7lHYsKitW+JLUZ81RgAYvxIgZMzYfB1iCYcvxAgRXjMqmAL5wKYoUx417LlOo7fOtBOwGZIe6yYdGjrT2S5SqeIMV8Jzw36qWzMrAiEYb2lRWmlnQxjpRfWwX69QW3CUpj/oWUQivPVVmNtCutThlq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tMXOhuVu; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5efe82b835fso52077097b3.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706919826; x=1707524626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dGotQ4CRNy4fAvOu+oQXTLBsL4Zddq3WhrzF/jyrszE=;
        b=tMXOhuVujC0iClLNkuWDTEV8b2v47TEuTJKjJLYYBYxlGmzh6U0ZoJQmhl0/V3zzqn
         aiIuNXqjIhY/nXNsLLPqyl+AW0vpCLBLhltRLT6gSAUsTNlnv1/IxilXCpCYzNBjzIEq
         BkVeXg8wmTxAv9+RxjUZ0KwcQReQtIrT2reRDWE+/EibHeRBjTQcRdSumDsawK73qz+2
         ZJDl2ln0YjJqdBo/Mq218ND7YeChdE4yQJLdB7DVWVPNsLDnP+93jmnB85/wPbhxDuZW
         TGPqRnqldn6CLsf/DA5wVOfahFFzBD9KhwGtbqQ4QFRpCGYBeTa8VDTKfmYFoM/3Ksjz
         dQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706919826; x=1707524626;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGotQ4CRNy4fAvOu+oQXTLBsL4Zddq3WhrzF/jyrszE=;
        b=ZJnFWGvxQzZxRS2zKZvCrFKBhPYKXnxayCXXAQIu6i+ZsLUGmh9/PoH7HkVUqGYiEa
         HEnAehqUluwa7ngZinKwXHSYLMBb+8P8g+/ytytZb83V3bYU6BbWMBjOHue5BMy0+lJW
         RhJmc3VIqF6xiCgaBfDJgixJbXVK8yD0WL9Y+cuGojRTCD4jD2VE9wMRFjlTDPM+yJ/A
         UrzymZgmSUZcF3jWQDIwm2ccjyMjToSTYMX6qpkPydjkverhQllv9V8crsd/F4D4LR96
         7Or86f0ow8ybDtFb97FVEXRKFnWyP400BRYjOm6HOSvJyMvU03yJ7UcOKgx04XbZ3JlR
         wMOg==
X-Gm-Message-State: AOJu0YzhTgtdbUwFhzk/lUbjZFiWw+/2DkBjOV6rxowEr3n+nzNTWOvW
	RT666W4ZGMgfyR2HT7zwwSIXE2J/bPGNUv6OaUwVug6NVPBvVEjoEGantD2p7akTMMsIiTr6BX/
	t3w==
X-Google-Smtp-Source: AGHT+IHS/GWOABGX4xJG8AHRzxkTf0zb48V+udqrJOGNsWOjkK0E3395IqogMvo4wYjDgX/IQNaZJN6+hjc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2512:b0:dc2:1dd0:c517 with SMTP id
 dt18-20020a056902251200b00dc21dd0c517mr2477010ybb.7.1706919826067; Fri, 02
 Feb 2024 16:23:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:23:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203002343.383056-1-seanjc@google.com>
Subject: [PATCH v2 0/4] KVM: x86/mmu: Clean up indirect_shadow_pages usage
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Resurrect a 6 month old patch from Mingwei, add a few cleanps on top, and
fix a largely theoretical race between emulating writes and write-protecting
shadow pages.  At least, I'm pretty sure there's a race.  Memory ordering
isn't exactly my strong suit.

v2:
 - Drop the unnecessary READ_ONCE(). [Jim]
 - Cleanup more old crud in reexecute_instruction().
 - Fix the aforementioned race.

v1: https://lore.kernel.org/all/20230605004334.1930091-1-mizhang@google.com

Mingwei Zhang (1):
  KVM: x86/mmu: Don't acquire mmu_lock when using indirect_shadow_pages
    as a heuristic

Sean Christopherson (3):
  KVM: x86: Drop dedicated logic for direct MMUs in
    reexecute_instruction()
  KVM: x86: Drop superfluous check on direct MMU vs. WRITE_PF_TO_SP flag
  KVM: x86/mmu: Fix a *very* theoretical race in kvm_mmu_track_write()

 arch/x86/kvm/mmu/mmu.c | 19 ++++++++++++++++---
 arch/x86/kvm/x86.c     | 35 ++++++++++++++---------------------
 2 files changed, 30 insertions(+), 24 deletions(-)


base-commit: 60eedcfceda9db46f1b333e5e1aa9359793f04fb
-- 
2.43.0.594.gd9cf4e227d-goog



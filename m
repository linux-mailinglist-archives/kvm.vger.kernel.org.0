Return-Path: <kvm+bounces-7625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D53DC844D77
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:56:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A35B1F22D09
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CE23B2A8;
	Wed, 31 Jan 2024 23:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZtBJ847A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A34C3987A
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706745374; cv=none; b=s0aRhu41WWD2ZLyGnEcFeK+2J5lrEQgI27n/flB8g01/OADOuJLudzeNWAAOI++A/0N9JzOKcgnBz4r6gk/A/9D1IDNicKGywfXTQWkHkuZT2oUaVUBduLPGG80ZgmcyCGur2XKkLh6VFfVXHhWsOxlLlUsl8g/Wvyq3G+OQSIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706745374; c=relaxed/simple;
	bh=KskMSvoey6KMBFSjef9AcR9PGosR1vFfg/lPVD0dxa4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kWJ+ftsLopM5NAgNBY5fEO7OtbjK3iAZWtREVZvW1lSbqzH5XZSQK56KLvje01mdO5i2oL5gXhYhzTXGDziUa6VE0yawyFHa1bxxVHHBRe1AKEJ7dq0trMJHNNpZ8loYK96m/7x0KxfIKye/siZYjogAAQdE7CS055W0/sH4x+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZtBJ847A; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b9f4a513so503954276.3
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 15:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706745371; x=1707350171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K8FMEPE2YDBac9DHbaO7Tj79lmJ6nt9ZY1wWZ4fnjeI=;
        b=ZtBJ847A4ZeheQYv3IMXOYHZFVfgkFqjss4OZ0BTyaIOjDaKQBhBYnXRHoRdQE1JX3
         1SZBQ+Z3T78WEJaWaY6qytK6DGzSXQbT64E2OvSvApkRG4EuRJz4NwQZUogkhbcCxgF3
         eHIoLYH7Qx8YDyLJFrFdVCzj0BNZEiuOu7uQdX0hXuyoN/XvUOl4QJ3hcMMo1TDz/xNf
         HG88cEsZeNYiizSv9nebxFhhcVCf4kXzSddloUw/vQbLArMym+4XmmJOJRS/TarEMzjH
         znVOLZT/eC6JmgE2IxJ0vUXf2MKRkzF8U4s5Bp1udIdf9pWvlUcyLlRK/OCpvQf0TOPC
         bNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706745371; x=1707350171;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K8FMEPE2YDBac9DHbaO7Tj79lmJ6nt9ZY1wWZ4fnjeI=;
        b=Ic6NlK0B/EK14ZRNbOKkCe8DYIY+xLVDeEdAFHwINVUuyFb0UGsgF8Z9USQ25v6b3U
         q9VUERmAvbBcJa4T+pMwARjHHoE+7jfzhByMqnlnloxQCflIP7kfwUb4CSdVd9cDSXeo
         L5pRQQQ7TAqNHb87Qgetr+xUl4KXw9aeHDBYFFibaKOfBexRRwfRfkWQBYzjf8L5IOlS
         iKCLylZPgBHPNnxfSl9YffpZlUD62ZBvQHVGFX8rVw+vkY0EiOrHlya9Ugk3sCBPlczs
         TmIgu8C8iF3xy1oHknagThQ1A8/9kSWlPQYpUBsY3YkIFaXYPPK9lofJQcTpgLQaMG2d
         m58A==
X-Gm-Message-State: AOJu0YzUEKyFmlk+mj1LYK5nsV0mKzzeJCsEsKfr6IdagSEY9jDGNqnc
	MRljiAfkKijbaZMo1RR2JX3F7rUgBqIL2iIfoEzRsZki1Xh/zsRdzwCY3PGus9JHnL5Ig9psIUN
	uUQ==
X-Google-Smtp-Source: AGHT+IFFiAX1/lqO1KSPikiJTS9h4iInXdK4HQtcltl/d705JE/F82GhE0Mt+ASh+YHZgaMX63qYVo3J6xk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:1c5:0:b0:dc6:d2c8:6e50 with SMTP id
 188-20020a2501c5000000b00dc6d2c86e50mr281905ybb.7.1706745371641; Wed, 31 Jan
 2024 15:56:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 31 Jan 2024 15:56:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240131235609.4161407-1-seanjc@google.com>
Subject: [PATCH v4 0/4] Add support for allowing zero SEV ASIDs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Play nice with systems where SEV and SEV-ES are enabled, but all ASIDs
have been carved out for SEV-eS, i.e. where actually running SEV guests
is impossible.

v4:
 - Convert all ASID usage to unsigned integers.
 - Clean up sev_asid_new() so that it doesn't needlessly overload its
   return value.
 - Split out the -EBUSY=>-EINVAL change to a separate patch.

v3: https://lore.kernel.org/all/20240104190520.62510-1-Ashish.Kalra@amd.com

Ashish Kalra (1):
  KVM: SVM: Add support for allowing zero SEV ASIDs

Sean Christopherson (3):
  KVM: SVM: Set sev->asid in sev_asid_new() instead of overloading the
    return
  KVM: SVM: Use unsigned integers when dealing with ASIDs
  KVM: SVM: Return -EINVAL instead of -EBUSY on attempt to re-init
    SEV/SEV-ES

 arch/x86/kvm/svm/sev.c | 58 +++++++++++++++++++++++++-----------------
 arch/x86/kvm/trace.h   | 10 ++++----
 2 files changed, 39 insertions(+), 29 deletions(-)


base-commit: 41bccc98fb7931d63d03f326a746ac4d429c1dd3
-- 
2.43.0.429.g432eaa2c6b-goog



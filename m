Return-Path: <kvm+bounces-46902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B4CABA59C
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DE2E1B6897F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839CF280310;
	Fri, 16 May 2025 21:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tn+q7tKn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D4D21E097
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747432756; cv=none; b=RRhtVx8IGw7aajVSOqkgEmhFjm0kLO2vbKsD+dUCkmykb9IzLNhghlWzyG5ZO4jlNcMn8EAWNwNIYiwESeea8zBrsZ4x9kfTjAnxOAk85htZo5ILX97/vODzqJiu8X2FeNVgPylktapaw7Pbjem/LEUzYtBO+nLv/f6AYbLF6gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747432756; c=relaxed/simple;
	bh=VFXkWnnhe9NyGtdfRK3voyLeMbbCfmqIvr0JVqkZYyI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sJMjWE6wcINag1HGlyIuNKuOPv5rrOl0pIe6MqxmKilzEz3GNb3GVtiAGrts5iDGi9ODQgs0SVzzKBnqrG1jf3z1PSJd415eDSGMWcRpF95IAzR3Qx4dc65n4exh91Qac3dZjVGIvoxiKrHXRHTpQslGoEJZEAKt/MsBLMfjHIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tn+q7tKn; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7425168cfb9so2259183b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747432754; x=1748037554; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1w99cJyy/iQBhZn/BNRLMF2m1YvAMi87ARmaI5+Tv8=;
        b=Tn+q7tKnTQ+uNyP0h7nNPXW2BjQrtQzNrnFq4Kpg2nFwuyb2lI8q9d+tybZaDaWiDX
         qoHKBDHTx9AwNxIbvP+rTlbL4LbyjwjPPpDIFaHk24DjRIhJHUUbEFR42Sjl8aclqEU+
         2CEZHB6fxqWffV/cFA5LMEvicXaD4H6At/oDdbnPjVlN3RPHDik6J2b01jL31KpXucbO
         i8qf7nPVDGBjnnCRWzSWfj/runMrJOnQgVtaIok+sT+5D84sPJwje1CL/Q9qfx/9LRs5
         2BT/6p/hV3foX4jORPY6HHG44BuZNbD9hBiO7xYMU5Oqv9hwbJsJwdgd/hanDai2v/Cd
         bKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747432754; x=1748037554;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u1w99cJyy/iQBhZn/BNRLMF2m1YvAMi87ARmaI5+Tv8=;
        b=k0xAuCWRyo2WizIYcHTKS52FoC7yMcqj2YkKFSDy8or7ZU5Hct37FGNq/FlAlkkWOh
         UQj7FlfWe8qGOatrzK30yK/Ez2ZoTVUJPcd1jsN3QCeX2qgvV/9s0yY7X8MePs5D+DFi
         cIcv6YPR6zb/IiP5sPngGluZ0VeQAfE+sLXbSooM8ZKU/i8fisf44KHSHlYtzv9rXy5P
         6hESB6pb5moDco1h5fSbXT5lf8u8CaDJFoBxQqtrp83hA+BhEl05c+3CCebp+UiEk16T
         krIg1EU5TXWd+Shc5dJip4lQyYFQfywqPxVRMSkCMdbOdbA7xGAGeVIBv5z2l6BWej5F
         hCkg==
X-Gm-Message-State: AOJu0YywOqzF9mmhR6qr7uHXmMRyQyMKmlSiSTQQLbChimjukwkVpU+u
	+AdtyM8/G8XCdjRELcqJZeV1jVB9cYziktw3sPkTGXcUbQlWVsbSbJh1Er8iaxQTO9CSwFlxEjg
	EHpIcGg==
X-Google-Smtp-Source: AGHT+IHAsZsucPTwyu8/l+gK7VJ5LQ39x2jjsx0K0tg8Ne9SZ+ty0kw+qsADg5C1ynw3A4IxwxbFEK7mPfs=
X-Received: from pfblw5.prod.google.com ([2002:a05:6a00:7505:b0:732:2279:bc82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9144:b0:736:4d05:2e2e
 with SMTP id d2e1a72fcca58-742accc2342mr5199142b3a.6.1747432754653; Fri, 16
 May 2025 14:59:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:59:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516215909.2551628-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: selftests: Improve error handling when opening files
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Improve selftests' error reporting when opening a file fails, e.g. so that
failure to access a module param spits out a message about KVM not being
loaded, instead of a cryptic message about a param not being supported.

Sean Christopherson (4):
  KVM: selftests: Verify KVM is loaded when getting a KVM module param
  KVM: selftests: Add __open_path_or_exit() variant to provide extra
    help info
  KVM: selftests: Play nice with EACCES errors in open_path_or_exit()
  KVM: selftests: Print a more helpful message for EACCESS in access
    tracking test

 .../selftests/kvm/access_tracking_perf_test.c |  7 ++----
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 .../selftests/kvm/include/x86/processor.h     |  6 ++++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++----
 .../testing/selftests/kvm/lib/x86/processor.c | 10 --------
 .../vmx_exception_with_invalid_guest_state.c  |  2 +-
 6 files changed, 28 insertions(+), 21 deletions(-)


base-commit: 7ef51a41466bc846ad794d505e2e34ff97157f7f
-- 
2.49.0.1112.g889b7c5bd8-goog



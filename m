Return-Path: <kvm+bounces-19715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A9ED90935E
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 273D928632C
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01E218FC65;
	Fri, 14 Jun 2024 20:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="aW3fWW5W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101691487F4
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718396946; cv=none; b=SxQpJoOETB5pUTbWsx8eAhPd30/BpfUgH+df47F3vXQI1/JNs2si/eX5EhHH8BeeZ4gaz2boVkaeQy/+ZH9fyOMpiFvkhlQsscXVvTJs/GDlvm/EvQxqiAvZc9M9D7ws6GHCqpC2ruoG1nQwjv8ABM+Akz1jDIG6Fayf8kDPblE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718396946; c=relaxed/simple;
	bh=+QmXIMfVnhYH2U/cPoKOmqVm7/McHFwnUSlQGyQopBs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JkQyKdH4QQp10XrMizORPvuuJQBP71JWLyWolBb5cyggWupgN+tBA5Yj6MPxtZDcrGzTR7KonBTNaY0jgLAp0gOHxBr0ZxRnHKnq/Z+XimZU5wdwuLc7pK6jrQ4uC6rrrzaZbbNRYWzG6mHHeeAwxCI4CiIsW6eyj4wVKr1IZVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=aW3fWW5W; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a6f09eaf420so310818866b.3
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 13:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718396943; x=1719001743; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1+4c1tKCdkBjer44ED8z98n8FL29fxzv6q3bmU9HXRk=;
        b=aW3fWW5WXtfVNEcUTZCOIqkrUywc4W3anSotNyv7vCIDoeUwBeZ7hn8Bn4pfK/l2r/
         pMkSpjjiNZcAyotfwClGe++0QJI0QyvGTTmxSWYH7cVwMxDmPb2+gHUvKQycwUw9LNnY
         vbz56S/E6s9rFmdYJ9MaIREEGlDMeHs/85TmxnjRu8LdeSqDR99JpU7bHHus2thy8Gpg
         l+5R02zLz+q4U0zlYm9iYeiu0gV+hdJgjR7Q4fq/KHPyVTlpe1RiA+3xG8MwqiRNWsiw
         NZJ0/HPQ7xqpQPtPap7tyL9yDj3j43XvyFW003ihlPS9dQkQEwmChujMWOqDUX/tFnnw
         zBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718396943; x=1719001743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1+4c1tKCdkBjer44ED8z98n8FL29fxzv6q3bmU9HXRk=;
        b=IYm1t4TOMXjL/uw0hSXOsjbP44Avbp1zloGZC1kZJBJ3FGThbOlrCOw2jPzikoRk+I
         dh02slG4DdebIqPYA9XiWSE+nJwdSlZZDi3n1fuHTx+Zr+mpnR+cJ9Gpc+KvjvXiU/oR
         /8Fey7VZnhZb3q3AUqBSClJKHOWn1ONm1wtHaXcibik8YXR2E4I+af7IK3zNBhmuhHvr
         13i5caRIuPJd8aouqeSVHU4XClVCZAxaD1f8lja1i1Y7pNvQkj77jzHjZ+pG1UDbe7KH
         fo3Q6unhM7zYbkDP5AJV9GX596Jjwmp/+pUSxz/sLoXMaN5+uo0T2IV1O5Wapyz8vahY
         OhYg==
X-Gm-Message-State: AOJu0Ywrrc7YviRRbMFrAelccKi/jJzP78ASALvUjCNDiZjsZ2BRW50h
	orRHmc+CEwNJQitGY8UlHGVShGdONr0Oua8IhRPGO+D0KRI7t2q5LV4WJhVjO7E=
X-Google-Smtp-Source: AGHT+IGtPrxJnyQsi6VoWlmU9cXoaK/IzMASMSlegFbJWojPuMp40kZauAzjE8e4NFBjG7NymmtMOw==
X-Received: by 2002:a17:907:d410:b0:a6f:6ade:175f with SMTP id a640c23a62f3a-a6f6ade1a39mr193966566b.60.1718396943164;
        Fri, 14 Jun 2024 13:29:03 -0700 (PDT)
Received: from bell.fritz.box (p200300f6af332a00214df27025e50a49.dip0.t-ipconnect.de. [2003:f6:af33:2a00:214d:f270:25e5:a49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed3685sm217474166b.126.2024.06.14.13.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 13:29:02 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v3 0/5] KVM: Reject vCPU IDs above 2^32
Date: Fri, 14 Jun 2024 22:28:54 +0200
Message-Id: <20240614202859.3597745-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This small series evolved from a single vCPU ID limit check to
multiple ones, including sanity checks among them and enhanced
selftests.

Please apply!

Thanks,
Mathias

v2: https://lore.kernel.org/kvm/20240612215415.3450952-1-minipli@grsecurity.net/

changes v2->v3:
- test max_vcpu_ids on bsp_vcpu_id limit check if already set (Sean)
- add patch to check max_vcpu_ids to not exclude bsp_vcpu_id (Sean)
- reorder series to have selftests at the end
- minor commit log cosmetics

changes v1->v2:
- add comment and build bug to make truncation check more obvious (Sean)
- handle KVM_SET_BOOT_CPU_ID similar

Mathias Krause (4):
  KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
  KVM: x86: Limit check IDs for KVM_SET_BOOT_CPU_ID
  KVM: selftests: Test max vCPU IDs corner cases
  KVM: selftests: Test vCPU boot IDs above 2^32

Sean Christopherson (1):
  KVM: x86: Prevent excluding the BSP on setting max_vcpu_ids

 arch/x86/kvm/x86.c                            |  7 +++++-
 .../kvm/x86_64/max_vcpuid_cap_test.c          | 22 +++++++++++++++++--
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    | 11 ++++++++++
 virt/kvm/kvm_main.c                           | 10 ++++++++-
 4 files changed, 46 insertions(+), 4 deletions(-)

-- 
2.30.2



Return-Path: <kvm+bounces-66038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E24D4CBFDC1
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:00:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B58873012DD1
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADAF328B53;
	Mon, 15 Dec 2025 21:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ulHs2lKb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D48D2874ED
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 21:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765832431; cv=none; b=ZLJEDoc9hR6x5OLJeVkKWeQTIvO4PFh6twPtOa3t9S/y7CP1T7JHJrYGQUVWJDKgjRw/0wOJsi1rzpP4434OhxSKXDRQdtzwgOWnW61XjG9wLXGvfaYL5cR6JobJXkJQFUUeHpbidZYg2NcyZqGknA8fQxz8AbGhp1WwE/kHw1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765832431; c=relaxed/simple;
	bh=6jAot4HJxNT056/ldg6ztOnRk6qmRdrLNfAn2mPGF7w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uEV5rCvSmBVBxCBwBTELf9QWNuhSwYSP08/8LsOQ6wzdIm/epZ7q1HVuIbFKCTErr1cQlE4hbjURICT/3iH/xjdvdARQyORtX2aJx3SuKdMW53M4qhNnMRal2w4Fqg58hwELMIAwjqfXa3kEMFqaRq8Tn7Gy66HWl6UUUuG+Uok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ulHs2lKb; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297f587dc2eso83871935ad.2
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 13:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765832429; x=1766437229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0ktcHbcuDlC9wJA8Xf4p9cskx5IQuOoXjrdrWtbZVe8=;
        b=ulHs2lKbTnJaZ5wwsOnAkjnbJM0TKAXKC701qwv5x7PlRJklrr8Uyx6CcyyS7BSCfT
         PO+kIdbJrElRqArrNuE5eLmc1coErE+PQSq+DlTmKB2jyuNnLOfniSD/1rRTmo46J69f
         SPmt3mra/lkfe6PEopdGyRvD/yjWxfyePG/YybSwhpFJp/evFnQlzNw+y+epD63zwXQw
         FHN25gxU1wM+VlaPgjRO7ftl8HjhMzCNpMYT7BwpzUTl8C+MQ7GYrgMtjWbSaVl0dH00
         2wjeIvXsu+9Vw75mjKjxzcoLsc1ixP+WFLZ0UxpFACNhNID8B90zJXfEuDTj2QTHDArR
         GPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765832429; x=1766437229;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ktcHbcuDlC9wJA8Xf4p9cskx5IQuOoXjrdrWtbZVe8=;
        b=Bf3nZHVOhziWvjFisc9XAMvwga8cd4euQiAlHTq0YHEu8DAR7AgWkq+ij3IGoAxJtu
         QAXJJY7PSL52URr2s2enN/hwnvruGAbqIUXLgRA5+0zWBIPZldki6GhzJCGNFuahNZw3
         GoOqW99vEVuph+uMB07xuVXnX9Nv3ie5+SLeN17qGCXP7P2gSwUkD8mKNUWLU5S6byzT
         M43VhsrDTMTFxxP+otBJ4Iw4tv+XavHiT+Oio1zvNpy0LmDEqzuC7T1E6nQRPcQ0JHQN
         CEQ9Fhka3DcjTsp/wLWaoFZ737SirfGvs/GSHKhgWdsE/lVyRwJfvw3dzYPK57K0jgcY
         ArAQ==
X-Gm-Message-State: AOJu0Yz3ObUw2+vgS6T7WNebyWSn14EhaXfrT/QT2bOT+G3biudIsK9F
	A3qilJx0pt1/fhLPGqAZudXdOpuF67aN19SED30k4X5N0Ur4CazZEqKaQugG59lpFtxOtwT4fXb
	hLC4fqspHMz5qbccO/ZB1pzN4oSyKKAUpwYkcCPOf8+zpGGSWPJ9//J40lpyKinTFdrrM8jOrRI
	b0NYkpkqt4JwGWQCzyXgolu002dPwsN7SFE2xLAEobvdE=
X-Google-Smtp-Source: AGHT+IERgd/szqr3ZxovA440BslPeZzNSCuzhpWNgKzGQBKr2RGMVRtT+MPJVMTQc7etgxPqf0p2zcq9BLhjPQ==
X-Received: from plgw4.prod.google.com ([2002:a17:902:e884:b0:2a0:b2aa:9893])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f605:b0:2a0:d46d:f990 with SMTP id d9443c01a7336-2a0d46dfb15mr76744335ad.31.1765832429276;
 Mon, 15 Dec 2025 13:00:29 -0800 (PST)
Date: Mon, 15 Dec 2025 21:00:24 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215210026.2422155-1-chengkev@google.com>
Subject: [kvm-unit-tests PATCH v2 0/2] x86/svm: Add testing for L1 intercept bug
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

If a feature is not advertised to L1, L1 intercepts for instructions
controlled by this feature should be ignored. Currently, the added test
fails due to a bug in nested vm exit handling where vmcb12 intercepts
are checked before vmcb02 intercepts, causing the #UD exception to never
be injected into L2 if the L1 intercept is set. This is fixed in [0]

The first patch just adds the missing intercepts needed for testing and
restructures the vmcb_control_area struct to make adding the missing
intercepts less ugly. The second patch adds the test which disables all
relevant features that have available instruction intercepts, and checks
that the #UD exception is correctly delivered despite the L1 intercept
being set.

[0] https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.com/

v1 -> v2:
  - Added save/restore helpers for all intercepts as suggested by Yosry
  - Reuse invpcid_safe() for added test as suggested by Yosry
  - Include '-skinit' in unittests.cfg for added test target as pointed
    out by Yosry

v1: https://lore.kernel.org/all/20251205081448.4062096-1-chengkev@google.com/

Kevin Cheng (2):
  x86/svm: Add missing svm intercepts
  x86/svm: Add unsupported instruction intercept test

 x86/svm.c         |  18 ++++-
 x86/svm.h         |  89 ++++++++++++++++++---
 x86/svm_tests.c   | 199 ++++++++++++++++++++++++++++++----------------
 x86/unittests.cfg |   9 ++-
 4 files changed, 234 insertions(+), 81 deletions(-)

--
2.52.0.239.gd5f0c6e74e-goog



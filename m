Return-Path: <kvm+bounces-48598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9974AACF7F0
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A57C3AC920
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 017A327D766;
	Thu,  5 Jun 2025 19:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4VvM1tBk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B980127CCF5
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151607; cv=none; b=IMHguDgz9nRmkoVxrggm5NnFGnTtgy0yIJlb7qQYR0QBo4yByfp61vPtptBjqFMfvu65wS7BbDXwVH24X+jSQ5h2PAvrtKXEq9AQc0xP7xcO49vtbLOAa5nyRwAh8M0cUe8Zwa1FcTvAQ4W9MPWDLsAIVXmz0xRJjDnqWX8ZStQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151607; c=relaxed/simple;
	bh=u7hCj0Zxty+jEmIyQI0/oYn7DtAx7Tm0YVc3HTd+pzY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hawGyPNWrNhT3ktK9/9PboNIGOBn//C8pqNy+s4vI6mZzcNPXS9sA7l7J7xf9Y/+bFTd1DJ9iGV4IDkRh3wL3U7nSF+ZHje3PW9WRug6nIrNst/uqW6hBKNv0904TS4oGR/UrCse3R6j55lx6tdwTEk3BCMPZMuUhtDOh/o1eHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4VvM1tBk; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b00e4358a34so790892a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151605; x=1749756405; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RTQSO5yjJUtqaTiMlNvTgVfSwP9oqWi65Q3hRFm8PD8=;
        b=4VvM1tBkNSDUzUOhzsBD0lwNIdlX1FECVB/V/61ExXpFwdMjQLBPxsGB3a20LSNuKX
         DiY5dANfF7SNy4abmoZ+2T+Alyhxp/M4pEe70XrJL024OMZ7fqe9M8bujUblKdFO8Pr0
         Rpz+TndXQu9g56nzZ4BqGrq7ltFKAa6NgsRGET2AbPX0IAmNlMoELUYo/vtIIMbFEx9F
         ml1ftI2vW6So0PWUq0JzsPiL2wkB+eGdHYQlU7uqRQPbUGcTrKP/Kl39JhxhP6rY/ege
         /hFfX3bVX5QhZzbed7Skm+POSZlt4u4JfvA0nAfPCpc9ZUPA5K/RhjFz1n41u/KWXVqp
         KxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151605; x=1749756405;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RTQSO5yjJUtqaTiMlNvTgVfSwP9oqWi65Q3hRFm8PD8=;
        b=ijeUpPJpVgcdHOqVqRx0wIYZ/Q4GzpyutFXnIkgSYDtKEI4AIAJzAWlhfPg+Fmtrup
         lubBHycQnyViFj7B1hGKKGWAJ6DArZlTlFGG7SkQwXcsaQ9S7qiKzSSncyO35EGmK7yx
         rSoWCcSBS3WCnuGdimKZ+9ITIWYNPxYgcH7HCbChFsGcN75hLrSHyLMOA0s43jw+IZMU
         p6bFy/rzHJFsbwV+jeilSCDxOd1YJcVYdwuXCi1AOq4uSuTrwSDeiUq8JetK5ZjCKG+6
         RdC6+t8spErJZMCStqPb47huUyjjfB4nhiHoOUOH/3ktHd5v0xnMqsbVD5tkfusJQ67/
         vsiA==
X-Gm-Message-State: AOJu0Yzn624ZkZa1dnKVUirjNkA/QmvhsXZJ6f69KuhHtkJj3fgUHStr
	Oj5h60p70rgzlE8ImD5VJSXwK9WpFQ7PDQFeGuLFg43UfhhAsJrefJGbZo4U1NrHEGvIkqNbvco
	daJoulA==
X-Google-Smtp-Source: AGHT+IGYfjBg6mYI+HiaRfi6BApY//m0iMQZ4VLUZqUh9HLH0mnW0EDQ62xtgYyqKz17EmNlr/nEtq/Klpo=
X-Received: from pllt20.prod.google.com ([2002:a17:902:dcd4:b0:234:3f28:4851])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d48c:b0:235:f298:cbbd
 with SMTP id d9443c01a7336-23601d019afmr7819915ad.21.1749151605013; Thu, 05
 Jun 2025 12:26:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:26:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192643.533502-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/3] x86/msr: Add SPEC_CTRL coverage
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add test coverage for SPEC_CTRL, which detects the bug pointed by Chao[1]
when running on hosts with V_SPEC_CTRL.

Note, this applies on top of the X86_FEATURE_XXX cleanup[2].

[1] https://lore.kernel.org/all/aEE4BEHAHdhNTGoG@intel.com
[2] https://lore.kernel.org/all/20250529221929.3807680-1-seanjc@google.com

Sean Christopherson (3):
  x86/msr: Treat PRED_CMD as support if CPU has SBPB
  x86/msr: Add a testcase to verify SPEC_CTRL exists (or not) as
    expected
  x86/msr: Add an "msr64" test configuration to validate negative cases

 lib/x86/msr.h       |  8 ++++++--
 lib/x86/processor.h | 10 ++++++++--
 x86/msr.c           | 34 +++++++++++++++++++++++++++++++---
 x86/unittests.cfg   |  7 +++++++
 4 files changed, 52 insertions(+), 7 deletions(-)


base-commit: a93196db8339df0c09d900f9a465820a9d932c1b
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog



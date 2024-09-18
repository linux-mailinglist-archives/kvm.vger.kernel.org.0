Return-Path: <kvm+bounces-27094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07ADE97C107
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 22:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C03A2283B5C
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 20:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03A741CB33A;
	Wed, 18 Sep 2024 20:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4fcEdtn9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A831CA6A1
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 20:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726692841; cv=none; b=RZZTJabDwXsIvuGxzDS52WAPtNtYhTcBN8ekEh2x9QySFCMLxjUjf6JF7w7Fuq+rHx/aVbCX+k6pVJmi8/OTau6K8dcX9sZzMJj5ESZWHcd4tIu5Rvni15/BP54eN1CFCemVXK924Ug8U2VZ8kiX55CZq0ma7wiKt8CZ+TgciRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726692841; c=relaxed/simple;
	bh=I0pmbmvVr6aVjOWkLeghyK73dRYtjeotDrFl5n0BGJg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DgPKBQUVr/7ofKZ24K0Ns8oaX/Cvvl+xGzzA79RVQuXwa8CGH3hB2KsAbNsIi2vxgb4ahTg002TgPtk0r3LoMKO4F+4wzZFuI9UBucbUhv2nFMwijf0ETxgFenBEz/pRY69zFi/RrVCraVsfp3RMNRiIhOtTiWRk9zPKY04tXiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4fcEdtn9; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1cefe6afc4so290340276.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 13:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726692838; x=1727297638; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CA6hUqY6qi77ambz+EsLwuKLN+krduAZlXqGe9OZvKs=;
        b=4fcEdtn9t/wf30vZjSwqTaBEcN4MmOYrd+3GAeAToQBpOnhYqTluCgwEPSH2FlKpzd
         pvcYVE29597ZOUjWqGE8ugh3F3La8ZWbXMVLCfbLKIkDpH1by9ezn4JfisN+m8PKCxCM
         TdDdvkBDZ4l9T9E9CrkbBRIHdzdPyclZmsaESEI8S9lQZn78oXrdU9XFf1k41k9LpiRW
         nptJiX7/gOkiLYBBCSniDONjYRVHyUJAbR8n6GL2M5+aUureTkHaiPJWwUZgpE8gsCoU
         VZWh20T3S3EMn6li8P6aUSD9NtVgZgOzqIOe9l7dQxgkFBFlS1Ddb/VFO590TN/GxHhB
         Jb9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726692838; x=1727297638;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CA6hUqY6qi77ambz+EsLwuKLN+krduAZlXqGe9OZvKs=;
        b=dr9/VtHZkysPG3boCtMAl0hz96GlE4JklRq7WMTi6Usg45CztzFkRDQUi0/KUG82rD
         1cd77EtfHvm0CMIee1lnjFAtCzWmkFGW2r+9ErfpeZssN0NFvFfvxZUg8pbP5msejnAh
         dFWW+PPwtBywjeiunXnEkeLSDd48jv+lsE5zdvkTEO0Fvl+VrtpS/FDcIwzm7otA9at5
         3zOWslLp5+zcrD34mEq3h9QERFV/0mjU7W/TTt386/nG/LdlDqAsuWek2H/cG3McTQbl
         gU7/b5Dbd2wx2Rr5yClwclwjfzNvgrEBNt4iNoUoVyjtfXZdWyw2f+JN+38u4NNNUxMT
         ct+A==
X-Gm-Message-State: AOJu0YzbUw33O0xfwXdAdpV//n5FyNTrk7Yvxe7hpAwpFcepW+uGLQ6e
	i06h8XZwNryw74t/ZHLLDG6oYLqWnDdQ+nFfvu2pSkFd4HfX4bA5GCZsHbA06XebLfbAU5dfcgq
	6e4IfVQooneiQiqki2SvzVm5C+EbYXj+dx7MHp/lFopIakCCO4T123HxIdBJruHGnW+EK1Jd8GE
	+1WaXoBufsrQrjv9unCrN9dvApBtn9SDGlutwUB2kyKd2luywYRhiPhgI=
X-Google-Smtp-Source: AGHT+IFCO0PcuLwNxHuDHXibkKk117xEQMYckf/X/31GvTsVERSFJBaexcoRDcoOq7AGt7ymvntaTnKDNUlLeAcNjw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a25:8051:0:b0:e0b:bd79:3077 with SMTP
 id 3f1490d57ef6-e1db00f4576mr29350276.9.1726692838045; Wed, 18 Sep 2024
 13:53:58 -0700 (PDT)
Date: Wed, 18 Sep 2024 20:53:13 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240918205319.3517569-1-coltonlewis@google.com>
Subject: [PATCH v2 0/6] Extend pmu_counters_test to AMD CPUs
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Mingwei Zhang <mizhang@google.com>, Jinrong Liang <ljr.kernel@gmail.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend pmu_counters_test to AMD CPUs.

As the AMD PMU is quite different from Intel with different events and
feature sets, this series introduces a new code path to test it,
specifically focusing on the core counters including the
PerfCtrExtCore and PerfMonV2 features. Northbridge counters and cache
counters exist, but are not as important and can be deferred to a
later series.

The first patch is a bug fix that could be submitted separately.

The series has been tested on both Intel and AMD machines, but I have
not found an AMD machine old enough to lack PerfCtrExtCore. I have
made efforts that no part of the code has any dependency on its
presence.

I am aware of similar work in this direction done by Jinrong Liang
[1]. He told me he is not working on it currently and I am not
intruding by making my own submission.

[1] https://lore.kernel.org/kvm/20231121115457.76269-1-cloudliang@tencent.com/

v2:
* Test all combinations of VM setup rather than only the maximum
  allowed by hardware
* Add fixes tag to bug fix in patch 1
* Refine some names

v1:
https://lore.kernel.org/kvm/20240813164244.751597-1-coltonlewis@google.com/

Colton Lewis (6):
  KVM: x86: selftests: Fix typos in macro variable use
  KVM: x86: selftests: Define AMD PMU CPUID leaves
  KVM: x86: selftests: Set up AMD VM in pmu_counters_test
  KVM: x86: selftests: Test read/write core counters
  KVM: x86: selftests: Test core events
  KVM: x86: selftests: Test PerfMonV2

 .../selftests/kvm/include/x86_64/processor.h  |   7 +
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 304 ++++++++++++++++--
 2 files changed, 277 insertions(+), 34 deletions(-)


base-commit: da3ea35007d0af457a0afc87e84fddaebc4e0b63
--
2.46.0.662.g92d0881bb0-goog


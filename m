Return-Path: <kvm+bounces-23098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E1C94631D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 865D72833CD
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545AA165F15;
	Fri,  2 Aug 2024 18:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AwDtfzZ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7F0165F11
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722623007; cv=none; b=FR7qhuXuJNF8cjsp5X0kQfLZRzfLRA3niqcfgoOUYYWcEeRttxt2PL3QFNUTvMsG7bbnRrGY/2Iad86x9mr9NO1J7NpHOGspRjvaeMo2FUz7KrlrYTJhuliLVd1ycg47GdqkeT4I2WTiOVw9FD/xw6tueWd2Vqz0zCm+heu5ukE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722623007; c=relaxed/simple;
	bh=n7duDsM65mzHev29g9uDVsLH1yQalJC6szNRoaYmK7U=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=iTLxjR9j71iU45zwJu4K+iKd9FjYcc7FeFhEEzzHkjFPjegVlXssYJCvBpotFd/tDcg7iCWzs0ZV81YVeuI1NthWiNKZ1iqd+cc4RVrU3SlvrX2KClZVLK7XOvNbkCdeh4q9DPf9nWQrIYwEMO6D/a+xMOXL+3QGVuD8NSIOUyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AwDtfzZ6; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e08bc29c584so11789435276.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722623005; x=1723227805; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6oxP+tD4KnlUfKN411qGS5qcktJ3QWZ/pUaaNeI8BVo=;
        b=AwDtfzZ6HylHvQcgn8T813Ezv0er3e65gS7k+ArZHxZongeL6vjhf4FWBCZuxOdOeY
         K66rnekb3bhtkHoy/wRDKQExo/d8HJ6FFI6ktvtSDGCv06g+A+R4dSKQxAoKsfCxhHeI
         3VhTt7S16CKuN1nYJw3umH7xXjuAEgvEoHsUYMjXcvh5q7DuYLSyaDcQQKw6UeVqAuU2
         NqPQkhdjnQEjXDTbriwzpv0mOzshFISxEsiqGg1B57qzcFil1y7789YkN6nknASUEM+p
         WMOYQOn2s4LvgspzoCJqqSrq2qFikhDaeyfSkn+ZZLqkklMxG13DynoGvSezGIRFNgL5
         dWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722623005; x=1723227805;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6oxP+tD4KnlUfKN411qGS5qcktJ3QWZ/pUaaNeI8BVo=;
        b=K7jH8+NYGbdMfq6e9Q1sZZtrWyq+X8ocyiGTdCF8NApATR4RW8v1XuUOuQIXtjH673
         N16NiXJqZ4Ytnhc+MCzCn7dYM9T+fDdgdDBcFt7F7abKQRxjLoWFcAVMbojYJ6Sn43mv
         4oBoQ+q6bxIT9abx64L4m8MIpSxFqb5LglNE816xm5em48qLj3jfj4fdleYCqL6OZmlI
         1EGnOe0qqVilVS2Cz0wWW73apEEDH4imshrFBjLebPxj2fxLqFCA69+ILg1pR1apBRYt
         RtIln3w3BM005xBTt0O2pTavDUBv815VeIEZz1q7hybMbKaB2Ux2iXP5mwMTwMiGzDjK
         8dlw==
X-Gm-Message-State: AOJu0YwI4BzWYvk9Hjr8VYhu1pjSaI9mhoCV8uV2Ss3R3up1m95igh79
	dNzcEVlc6FXSLPS1+LtYD18CB1J+u1ObwwLQmhMWr8nnKrXS/L+BbYWBIX7dnuLBED8hBYznXpL
	Z2sN3G/WfDDklRVOF8ADPzjblIh8moCI7r4/rttP9RFK+hJGG2pam2wnzYkGbqKcYW85dRGxFOT
	rgGqePKM6zohXciFO+tCijbGghpofXY6xxONBsPwrIzhJbpOfTYT1pdBI=
X-Google-Smtp-Source: AGHT+IHhJZUMUJlOwDgUo6lqW8JjwdwUbeftwTJqmLMxmcUdMbOBXHUOM9McHNpi1/8vR8rYt9dKZJnJJNnE2h3m5w==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1241:b0:e03:3cfa:1aa7 with
 SMTP id 3f1490d57ef6-e0bde1e9203mr5468276.1.1722623004394; Fri, 02 Aug 2024
 11:23:24 -0700 (PDT)
Date: Fri,  2 Aug 2024 18:22:34 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802182240.1916675-1-coltonlewis@google.com>
Subject: [PATCH 0/7] Extend pmu_counters_test to AMD CPUs
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

Colton Lewis (6):
  KVM: x86: selftests: Fix typos in macro variable use
  KVM: x86: selftests: Define AMD PMU CPUID leaves
  KVM: x86: selftests: Set up AMD VM in pmu_counters_test
  KVM: x86: selftests: Test read/write core counters
  KVM: x86: selftests: Test core events
  KVM: x86: selftests: Test PerfMonV2

 .../selftests/kvm/include/x86_64/processor.h  |   7 +
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 267 ++++++++++++++++--
 2 files changed, 249 insertions(+), 25 deletions(-)

--
2.46.0.rc2.264.g509ed76dc8-goog


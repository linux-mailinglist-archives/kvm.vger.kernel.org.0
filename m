Return-Path: <kvm+bounces-41727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA17EA6C5B4
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 23:15:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E41107A8430
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 22:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DB123312D;
	Fri, 21 Mar 2025 22:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vJuJtnCx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009CF1519BE
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 22:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742595302; cv=none; b=qxTV1g918WwdL9G8GRswWVvVWdiArADapRBRQdpEcoMgIifzgyPsZpxfFkMxA3+C++oTmVnXRLS0fQcejshdyvqp7QMxZyhy3nInuQeu1IRtLgbOHBE+d18iO8ew50lA9g/sqATLeA/14sRHJ1kXRuz97UhF3vPxcJXUmoJ0iAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742595302; c=relaxed/simple;
	bh=NPx5hgwLn/mzDYrm99FpYVYQnE7Gcf2Lkd9dI+JFYfA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VRjeuxPapU/m6l088uqTA670Esr863YFDl0z7ahCsvSJJqcMO3B9Sy3dtHcrTeK2tsX3X4plR0xNpd1k3bY+gj6AiNy9eL3V/NCxTwVsixFlaVB1ak1kPVXcvlajTDVOaJThUrwwsTmCJiTcIzNW8PcBkQ7oBHI2XTWD/kGc6M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vJuJtnCx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff6167e9ccso5557926a91.1
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 15:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742595300; x=1743200100; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gder4ZBeakmzoOVPhL4CX5O/w/7AtN56Adx2b1zHtms=;
        b=vJuJtnCxqUYXZ/2mT1OG47xJpsbWCQomg2qZ4IGKbu3fTWsLkh5Axw5bcXHMtUvFpM
         8j+xGCwlAWr+TOUV9tKW5S3DcsrXVJxI9rSPmvOSXz5iPBw7EOsKjg6wvmNN6+FxHwmZ
         vMKEKLTEB6B4zOi5Jgx4Jg+vc9CtdfWv24CanHBNL+ozWGxQxqv4yPLmMeVufQ14xt3r
         hWfY13cT4h7q7KXyoRLcjmmu6eokMTguhIwvWKr8UAr26MBqnBgTOQ51KPCv6KqAyv3x
         f+bDfedC/xuEe8BlR2743QgyLWObODXlhIt4hZhoSj+8O7fbD287TJRb3k6pRfjUFErp
         CXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742595300; x=1743200100;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gder4ZBeakmzoOVPhL4CX5O/w/7AtN56Adx2b1zHtms=;
        b=IcJS0GpgmObXwOQT36eUzyiHwKGmOlevg/rz4z49mj/bxwqd+yOm+284QcRtrO/SCP
         yqnFcDWrkjX57BHyBNTdLLX/YkG1LyKR23O3qJgoNRr9YOLmR87vr2s7VUjK+oDCmwYc
         WiXvQACzhsSYIQYpToTthV+JfEeX/AOu/2Lf04yhvgu3ivaPMQKc4nnmLDU+g2m918Kv
         RMavuVB2Bu61d25fPjID6SZ8bDDGWWV2VbCEWNnWT/uFoniLXzzAHMCuSdudK+s3eB5g
         uk1ROkxOEZ0clVqwyyuVL3fMsepcnntI4DK9VEZFuoVkXq+U/MWIHrhk1ZZCRjqgQmlQ
         w2RQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDF9Y068llSeU/AvRPwvocr8h02usg6mYHs9Czp1zRAJl7VWAKp6cL3QosgVrWQKwIZYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYeYiJizxhKZq1AqUwgpWkLfo6usPyDVZITk5yIsqsQbQeWkEn
	TeAFdMi+C2ltwUVOzrzAMtzBr65NVaFPHaFiuZBF0tLTveaIY0V4X7L7Cz5ChMrgl6oly84GE6Q
	N/uZdUIl84g==
X-Google-Smtp-Source: AGHT+IF5w0t2qfhlsv5r6Ydy0x+ymrJUxEI6TT+RPvL+KWo7KyBDAXfDTqZ2P8K5xXqmj3lr2SY2M/S6ki5lzg==
X-Received: from pjbsc4.prod.google.com ([2002:a17:90b:5104:b0:2fc:2e92:6cf])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2747:b0:301:1bce:c258 with SMTP id 98e67ed59e1d1-3030feeb4c6mr6805659a91.22.1742595300337;
 Fri, 21 Mar 2025 15:15:00 -0700 (PDT)
Date: Fri, 21 Mar 2025 15:14:29 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250321221444.2449974-1-jmattson@google.com>
Subject: [PATCH v3 0/2] KVM: x86: Provide a capability to disable APERF/MPERF
 read intercepts
From: Jim Mattson <jmattson@google.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow guest reads of IA32_APERF and IA32_MPERF, so that it can
determine the effective frequency multiplier for the physical LPU.

Commit b51700632e0e ("KVM: X86: Provide a capability to disable cstate
msr read intercepts") allowed the userspace VMM to grant a guest read
access to four core C-state residency MSRs. Do the same for IA32_APERF
and IA32_MPERF.

While this isn't sufficient to claim support for
CPUID.6:ECX.APERFMPERF[bit 0], it may suffice in a sufficiently
restricted environment (i.e. vCPUs pinned to LPUs, no TSC multiplier,
and no suspend/resume).

v1 -> v2: Add {IA32_APERF,IA32_MPERF} to vmx_possible_passthrough_msrs[]
v2 -> v3: Add a selftest

Jim Mattson (2):
  KVM: x86: Provide a capability to disable APERF/MPERF read intercepts
  KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF

 Documentation/virt/kvm/api.rst                |   1 +
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/svm/svm.c                        |   7 +
 arch/x86/kvm/svm/svm.h                        |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |   6 +
 arch/x86/kvm/vmx/vmx.h                        |   2 +-
 arch/x86/kvm/x86.c                            |   8 +-
 arch/x86/kvm/x86.h                            |   5 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/include/uapi/linux/kvm.h                |   4 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/aperfmperf_test.c       | 162 ++++++++++++++++++
 12 files changed, 196 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/aperfmperf_test.c

-- 
2.49.0.395.g12beb8f557-goog



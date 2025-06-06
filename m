Return-Path: <kvm+bounces-48694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA2A2AD0A88
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DE6B1898217
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08686244664;
	Fri,  6 Jun 2025 23:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GOukdYAy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E0E243964
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254217; cv=none; b=owDMfHQVITXoCvu+3kp8lz5M0BEwgwsdgDNknIoRXZtKZLJ5ArA2vIL0sG5MUvT7RQsDywgPd562ALPsxUYg29Z9Z23lHzNvMSJGbNiyOJeBxwhzUnZu6L9citURzRVE5hC7kfUAPhLpp+HXt77cIKzcHJ4KKxnrqRb5ab5yLQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254217; c=relaxed/simple;
	bh=FfZjBFrJnHL5qXqPJ52iFYwiecqXQgGEH17UAzM8jjw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O1EVwJRrTMccdmlF/GKJ4Ctas+pP2LbnfwvxRLVBEYPzPVrjJlhR2LpS2KdQJbxZQ9g/AGu3AlddT4lpN7X8u3jIdGVy/2pWbCZw0re3fR0dvoKp5bAzJWyuI8qmwc8x++wQdg8dT1B6NRd/M/Kfz/rQhdofbXtj/D50G7ehja4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GOukdYAy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7377139d8b1so2154695b3a.0
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254215; x=1749859015; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rQsDpgf8u91vw/WrLSGz0iJXQ6JiA2bq0U/tEH5QJI8=;
        b=GOukdYAyYuoXmnstuT7N1dpHgHC6XQK1rQRzjwwHt47kKFWlwCGoqa1O6RFh48aSP5
         GYDF/FBtwXmQucCsVZLgS+29ezFfHjqGVMialGF/fu0yFjuNFgGe0O2UYuKQC7L43kWc
         kpAoZp6v1F0ccT5T7kKjOgBxwLOwbf+cu8ZkX44fjTkfxUdPhSqg9KFbu+siNvoJTRyi
         a1gh3KhtR5wfl5oBgCVMP6eGG3of8Tvl/4QYV5M8mxG0g0PQod3AhzUZU5JiZUnjC4jO
         4vhpR+YpDLqihAfrQ9dXemNi7vezDaLDwPC05AVb9ck6mQ3KqGjapUO2yVl0AKqVXvKN
         TOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254215; x=1749859015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rQsDpgf8u91vw/WrLSGz0iJXQ6JiA2bq0U/tEH5QJI8=;
        b=aeDY3FxURhx/6pWboz7GVK6pSgYrh9bv0msmcRHYqP0k0bkZJc2IydYf1n/YlZ3bZM
         EDiBWQkQ5+DGw1DgOB8hCschJqmtkH9RXfavEIEdDaq1SzKj3RBDSYjiQ39CFhJ9Yi6e
         HvB+8/Y6WjacTsRYNoNB5Wa7JpFacBFxmqK9NTj4CN2HxHcTMXz9nmNMYRh3JntOpl1X
         e1E0w3XBbQxoxJKw4XCp/le2g1EhqSHvxBaPrUkYX5d7DvAaRw1+0n70J+TYdNkDRt1Q
         B3vyLsI8Nc1VG8Exe+1KH7wYjZ4UpkuJpGcPCRQxB9PZfGZRGZWPNovqCDL53SMiEcrt
         bfCQ==
X-Gm-Message-State: AOJu0YyEHwpY4/Go4c6TGSOPlXrNdZNc5tr7D0XiGoXjVMbRP+z4jWNK
	UyW/rBo6+nvfhCGEjuwPiFBFSpI643iAbwhTW8dW+SY7DqjnuSo3k4aRkReYV9ze0+tR5G0lSJc
	70ici1WvCeaIDrHRLA3dRJyHI9RVDMbuuRgvLUIO/58OOWg4cnqyCfvgM01GAGRLYjKkXWs0ZNV
	6AvcSX2ttVS7NErVJBWsVtM7DfIZod3cl8wSnzGA==
X-Google-Smtp-Source: AGHT+IGyp1ZByaQWclr+E1KDubTeknVJBEMfz1Flqb1492oOI1nXyfJVxjejhM42yZAw1MjGchfJyqOnrrck
X-Received: from pfiu22.prod.google.com ([2002:a05:6a00:1256:b0:747:b608:3d8e])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6009:b0:218:c22:e3e6
 with SMTP id adf61e73a8af0-21ee2555021mr6804011637.12.1749254215203; Fri, 06
 Jun 2025 16:56:55 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:19 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-16-vipinsh@google.com>
Subject: [PATCH v2 15/15] KVM: selftests: Add riscv auto generated test files
 for KVM Selftests Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add auto generated test files for s390 platforms.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test | 1 +
 .../testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test  | 1 +
 2 files changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test

diff --git a/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test b/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
new file mode 100644
index 000000000000..d34b4b9b77ae
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
@@ -0,0 +1 @@
+riscv/ebreak_test
diff --git a/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test b/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
new file mode 100644
index 000000000000..5abb62c51097
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
@@ -0,0 +1 @@
+riscv/sbi_pmu_test
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog



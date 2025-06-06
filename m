Return-Path: <kvm+bounces-48693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A39AD0A87
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 674AA3A030E
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E68A2441AF;
	Fri,  6 Jun 2025 23:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yB002fPd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A70243951
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254216; cv=none; b=O3NE7uUg6eNbSBYhEW0dVncvXgj6vfPiJzL/gJvjaswZEgHSEt614g/HmN23Ys1s11icSMudwYe6lR0yrENnU5VP7h46LHQjAajKll/p5wdPyuSkHYWQ1swH9+hKWFxYukgmvh579HpsAVCQmwjiOY2oWOULHVOQzEDnvkgNnWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254216; c=relaxed/simple;
	bh=X+N5g5XrDuhwGEsVAuvu1akbTIwI2YElq0jJKkUB17c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BfxrOOxo72satkPnKCmb3qlZsWfF1JmooN6hMePndeUEtq/vt3T17ZexPAss71SiTicqwIjvIrzi8hzqKv9SaEHP8gn5DYh5FrHRXd8hMOJC9eQqt/pNIy1hZOqqahvvxCXv9vuS+nn3fgHU3ySq9VBnu3EGC8PPEHPFsAh2wKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yB002fPd; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74620e98ec8so2373281b3a.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254214; x=1749859014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=21lsbUP4Pev7+bZRjEiLUIwgm/TC/un4IRPgZinq0rE=;
        b=yB002fPd3eU4UHb7Wmr/xOOYjO6P9MG5bR6wuXgocUVrHlNEx8VTCeUWbpLbYJZzkV
         2fOOHmPY19lLM63+x0PSRdpno/CW2Gv1r+v1NK77bwcYzHKyzzoxmo48kCRZeiz7WHTR
         59brzsBUufX9kjsHvNpgBMqngNO2iCp8op+Opm+23ViwTynB+8BfAG9wPcHHZ6CKICaO
         +349C+0Rsqzc9CxuvqcTFXlbZ/XBdJICY33tzC/w132WntbvA2KVyLu3M6NJnkHxmDeV
         +Y9IsfQ2Os74xGXVMyKhAUtQEYKzYQTCN7RH3PEDdOkhT7HuKzFiCChVMiD8ajLZzE72
         quuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254214; x=1749859014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=21lsbUP4Pev7+bZRjEiLUIwgm/TC/un4IRPgZinq0rE=;
        b=kYLj0FaUj2GnGX2xSCV8a+0am9+GOqavmb0VU5dIEZ+4ICBNvuTpr2CBbfGNPhD3uu
         Ab40nXM4C3BrqZ1YqJWB+Ce6iEjeL/t3ot8ZJfIXRGdnTkgUpHDAoBP0ovrubHAouVAo
         PNDXOJFFL53lJzYe3tuKCPPgslBma1lFfSHZcuewgcukjQXUkqdEPFDPN3HIWbenzOB6
         bvmusgykbuY2C+9ZYRDsP/tAjV2JamitpKXMZC6scVVDJwemnz8D1HHRHFD+36ggFKYf
         GPCi64XDtTZgqoz4DWZVHhzfVqekURel3OoeBD0Ylid4SIn6mmyeOZziA/N6Csoov5Kw
         fJQA==
X-Gm-Message-State: AOJu0YwGkvXLt1jNC/1J6SNcQNe1hCf55Y9D+NcuE2rmU7Ud+OXtiFZB
	yBzmWiyBZQiIGSCDzp31vVTFlLqvFgyYZ8uBraVkEmmzqPjb9BlDCtlhFDbvKlFYEoZ1qCwtjbZ
	Zpx4Z2r16mYkgDbRahbqM3WyH5O9RHI9hb0StFzg9+kTQY42Kdu4S3JeK9teGcrc6voMEGNFtwl
	DZBCxENq647t4MvCiFoVuAEOXcGle++CnN6GxhOg==
X-Google-Smtp-Source: AGHT+IFawjIwwAf5PF3Wi/OcDWRJ/ksSgwU5Sx+YrDH8kG+RVuMa1d7ri+swcbrCB/2Jc5d9zeGSaoAOQdJ+
X-Received: from pfop3.prod.google.com ([2002:a05:6a00:b43:b0:747:af58:72ca])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8705:b0:746:195b:bf1c
 with SMTP id d2e1a72fcca58-74839e1f2admr529438b3a.10.1749254213601; Fri, 06
 Jun 2025 16:56:53 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:18 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-15-vipinsh@google.com>
Subject: [PATCH v2 14/15] KVM: selftests: Add s390 auto generated test files
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
 tools/testing/selftests/kvm/tests/s390/cmma_test/default.test    | 1 +
 .../selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test | 1 +
 tools/testing/selftests/kvm/tests/s390/debug_test/default.test   | 1 +
 tools/testing/selftests/kvm/tests/s390/memop/default.test        | 1 +
 tools/testing/selftests/kvm/tests/s390/resets/default.test       | 1 +
 .../selftests/kvm/tests/s390/shared_zeropage_test/default.test   | 1 +
 .../testing/selftests/kvm/tests/s390/sync_regs_test/default.test | 1 +
 tools/testing/selftests/kvm/tests/s390/tprot/default.test        | 1 +
 .../testing/selftests/kvm/tests/s390/ucontrol_test/default.test  | 1 +
 9 files changed, 9 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/tests/s390/cmma_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/debug_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/memop/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/resets/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/shared_zeropage_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/sync_regs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/tprot/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/ucontrol_test/default.test

diff --git a/tools/testing/selftests/kvm/tests/s390/cmma_test/default.test b/tools/testing/selftests/kvm/tests/s390/cmma_test/default.test
new file mode 100644
index 000000000000..c6655b3e9472
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/cmma_test/default.test
@@ -0,0 +1 @@
+s390/cmma_test
diff --git a/tools/testing/selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test b/tools/testing/selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test
new file mode 100644
index 000000000000..d02545ae1f3b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test
@@ -0,0 +1 @@
+s390/cpumodel_subfuncs_test
diff --git a/tools/testing/selftests/kvm/tests/s390/debug_test/default.test b/tools/testing/selftests/kvm/tests/s390/debug_test/default.test
new file mode 100644
index 000000000000..bd0a9c8965b2
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/debug_test/default.test
@@ -0,0 +1 @@
+s390/debug_test
diff --git a/tools/testing/selftests/kvm/tests/s390/memop/default.test b/tools/testing/selftests/kvm/tests/s390/memop/default.test
new file mode 100644
index 000000000000..76073a59f58d
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/memop/default.test
@@ -0,0 +1 @@
+s390/memop
diff --git a/tools/testing/selftests/kvm/tests/s390/resets/default.test b/tools/testing/selftests/kvm/tests/s390/resets/default.test
new file mode 100644
index 000000000000..133beeb1260b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/resets/default.test
@@ -0,0 +1 @@
+s390/resets
diff --git a/tools/testing/selftests/kvm/tests/s390/shared_zeropage_test/default.test b/tools/testing/selftests/kvm/tests/s390/shared_zeropage_test/default.test
new file mode 100644
index 000000000000..8ea3ec559fda
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/shared_zeropage_test/default.test
@@ -0,0 +1 @@
+s390/shared_zeropage_test
diff --git a/tools/testing/selftests/kvm/tests/s390/sync_regs_test/default.test b/tools/testing/selftests/kvm/tests/s390/sync_regs_test/default.test
new file mode 100644
index 000000000000..7eacd6f9bd2d
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/sync_regs_test/default.test
@@ -0,0 +1 @@
+s390/sync_regs_test
diff --git a/tools/testing/selftests/kvm/tests/s390/tprot/default.test b/tools/testing/selftests/kvm/tests/s390/tprot/default.test
new file mode 100644
index 000000000000..78e603c3b671
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/tprot/default.test
@@ -0,0 +1 @@
+s390/tprot
diff --git a/tools/testing/selftests/kvm/tests/s390/ucontrol_test/default.test b/tools/testing/selftests/kvm/tests/s390/ucontrol_test/default.test
new file mode 100644
index 000000000000..211cceee1bbd
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/ucontrol_test/default.test
@@ -0,0 +1 @@
+s390/ucontrol_test
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog



Return-Path: <kvm+bounces-13799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA3D289AAD2
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98353B21B19
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22312E64C;
	Sat,  6 Apr 2024 12:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3XdhkVh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D859CBA55;
	Sat,  6 Apr 2024 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407151; cv=none; b=RofETbf9WPE+ZMXX+PzJEhgdkjYSTDIbAxZ4qhnW4Pv7Td7FUpO0MVGbpDJpa1Bq7Xb+j+YN4rhtopOs2kBzP1z1eqz6OcJsduuTDkuCPteN0qUeKuWVPCK/2JfW7n6AOpHwtgFscvMPzyOmLVyWj01eQvvumqN/+42DdmTlB8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407151; c=relaxed/simple;
	bh=ynVkD9kpyp73EWy70emPQEfa+B2E+GzlRMJPQM8F8zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FK3I9J9RKCjlc0h9kqm/pKBDmcXcGctYb7UQodc2baHFfroeb3hbSpSWlo9jTSzdLKHm9uqy/WNvEoCYrDOazSggFRExLtCO34S06F59HVjfdF9ak722SWJ2ZiTdvDGjFzFUEvyjYyfjBWI4+Mh90ZP82nD21FwSBlJtRcyMh58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3XdhkVh; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2a074187a42so2203484a91.0;
        Sat, 06 Apr 2024 05:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407149; x=1713011949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6Ak2eXV9+uxmKDVMVAvdf5h+W+GwHpU0A4GvgnXZ/Y=;
        b=e3XdhkVho12vwtYWGCQZW6/XbOWnbRCQFOG1AneBxpdzMpQaS8yfuvV8sXOFv5nPc6
         tt7mV5hOIQw+GTL2IGffpTvbVOdfcnn5SfTXoPExAsfAU6rGiC9toXXjEcPyd9UWBGLM
         CVnLOkgrVtMNeN1dP1T6n/b2YPb9qaqsKNcUjllyflj2XN8NPMUHEAeg6F9oESrTmJjs
         N5VAtBtP/YhoOocW1Iz66YxgU1v/10Z5qFkF1wLnwSbkneVRBq/72msvg+zPwkvjhjIK
         Ya3xSmlOMJ4pH8S1spVWMkEj9/7SvufgiTM1QAagymrsXPXg7xpQZ0pHBerLRZhYq8AN
         t+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407149; x=1713011949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n6Ak2eXV9+uxmKDVMVAvdf5h+W+GwHpU0A4GvgnXZ/Y=;
        b=MFiT5DSuK6V5p6VDRkXuElk6W7lUSm3gmU6wsQ+yLlbzghd8hrbes+eSu61Dzo6MGV
         o0F+BzWwtFl9L8le/vGW0x/33APxG8FbTu+eXDU0iSiJIYYVuKwSY/axVuwYYIwx0QA7
         oVhyhqyprn3Z3oLpJvOs1URmr3p1E4XYekeiL3/SW8KqekHw5V3jmKQcgHq8QsaLhs2N
         je+RqaI1mMRowjtuKucu7tJVsNFeJVHwcjQMLjYStxLJRRaI1sgkdYWOR6hXTLW0A43E
         oIWr4DIe/h6skOAd5pQjRKOlvXa0Of5IdUitLVl+aodNBT1VZVfBejwsipMXyMVDcRY5
         hItg==
X-Forwarded-Encrypted: i=1; AJvYcCVpa7fIPyOO/GKGCOH2GxiifQa6JhKUlgCaxigYQI1o4s+6jHBM3Cr43yqT86Iu1Icyq9AbsI8k4prYoVlTxx1YlpcwR5AodyNlxbc83WAe5LYB9Hkd7OK6riZyyAYjVQ==
X-Gm-Message-State: AOJu0YzG7SjYkObcwB3sp6BkaFNC35XrBdTB32Qi9pwcr30y7iSpvSmi
	qatLqZtDmJnzhPH/FcnoI4iB16+ODe4Fx01YCxPiqjTJxNdNwxQzzmtJcJV6
X-Google-Smtp-Source: AGHT+IEYhDuK2nSdoxNUh6rlvyThWG0NnDzHTSnNytiX2YBBGS47j7JwgJow8VWW5Xms5PawMFdZFg==
X-Received: by 2002:a17:90a:f413:b0:2a2:8250:b5d5 with SMTP id ch19-20020a17090af41300b002a28250b5d5mr3527170pjb.18.1712407149116;
        Sat, 06 Apr 2024 05:39:09 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:08 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [RFC kvm-unit-tests PATCH v2 02/14] shellcheck: Fix SC2223
Date: Sat,  6 Apr 2024 22:38:11 +1000
Message-ID: <20240406123833.406488-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2223 (info): This default assignment may cause DoS due to globbing.
  Quote it.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh         | 4 ++--
 scripts/runtime.bash | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index bb3024ff9..9067e529e 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -158,8 +158,8 @@ function run_task()
 	fi
 }
 
-: ${unittest_log_dir:=logs}
-: ${unittest_run_queues:=1}
+: "${unittest_log_dir:=logs}"
+: "${unittest_run_queues:=1}"
 config=$TEST_DIR/unittests.cfg
 
 print_testname()
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index e4ad1962f..2d7ff5baa 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -1,6 +1,6 @@
 : "${RUNTIME_arch_run?}"
-: ${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}
-: ${TIMEOUT:=90s}
+: "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
+: "${TIMEOUT:=90s}"
 
 PASS() { echo -ne "\e[32mPASS\e[0m"; }
 SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
-- 
2.43.0



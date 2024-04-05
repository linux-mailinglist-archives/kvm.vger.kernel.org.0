Return-Path: <kvm+bounces-13683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1DA98998D4
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CAFF1F257FC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907D015FCF2;
	Fri,  5 Apr 2024 09:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z/0yGwWp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7941EEE6;
	Fri,  5 Apr 2024 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307723; cv=none; b=Am6KrW9mUMNS98FNjiyRTTU0rk5ZjX/j+Gv5o3JDLvX805/XpAHX9saJmFtQoPkyEXfXvntiqc/ibkmng+Uuy8zjfgm/Q+ktN16ksivgePpxJsBlBHIxeYtJs90udNVhjuPzjcSQC8fgpJ9SLA6WARgnBl+/R8FJL66OsCuuinU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307723; c=relaxed/simple;
	bh=cgOlMFOLTOAhPaG8TMTBDw1poLawKTTj8nPBJ3XWL8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcA7JHT6lcyitByhDQaxFGporFC0UAX/kXWsYxd54wfRmD5hFzMLqXLuE7C9tzxD3O9SqffW2NOXGa5VNcl/2jsTpa4wwttT/3T6JxHssfvVfPtIArrpXjdiEt3t3joA4G0PRSCucmg09Kc+ruQbB8Pkn3kqeDPHaV7N8krqYsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z/0yGwWp; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ecf3f001c5so1250366b3a.1;
        Fri, 05 Apr 2024 02:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307719; x=1712912519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvXYLc0uu+LcIsnEe4bo5tAncaXv58vUX5rvt7kRU2I=;
        b=Z/0yGwWppiUvbTwsDcJ+DEYmgfPnrpBfqPCem0T5ZxZEGeIRimdEFqY3TpI9L9lSQC
         z3KnrZQs2OY22G/q6nW/WM+IA7FaiCUMOydRakfdpdwiehuKnq2NJoJcv0ViiqpzGajB
         u7I0c/5UUXbQGG1wYMLO+k9VIX3jKzL3FrqSGJMRuUgDpVIxDSMjO4Xhltd2p/M7rY/f
         UMR5jUObW0BuXeAO1/gSoUahOxcQHjUJg4pOxmsDLJgAGMFC5DzJMOCK7Jh4kDerQvlJ
         b1Dbt+8S9tvv58046tdvsiKPukwZAfT4sLYM5Ps2Z4BuVbHlTnQyIcbUFnwI0BO1Uc2H
         Douw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307719; x=1712912519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvXYLc0uu+LcIsnEe4bo5tAncaXv58vUX5rvt7kRU2I=;
        b=KidS2eL/xDUMkLmW5KOsqPHqmH0sg0ChyqbbXmvkhqLbO9TbGFmIIL7KFlmA8GTS0V
         dyJMrm7zJ1U3nxe31diA5Itj9y74fm7Crz7y9QYiUVN1wxWDnYhOR+kHDqnLZaW11KOa
         +wVrYW1vO+Wyp4TdCM2bn1XwEPWyzR3iVHhlmoZvO81M0cP6ROYGEMXnnddmo0OG2+ca
         br/YnbVzejzynM7EeKt2WKfmiCRM5o75kMyz4ISq5bTQOpPtLt4A1Yf3Jp0+zuxBEMbp
         i/LEHa8GeQD9wKN9gmipcTSJiS1CR4Mc98g4tWayFGdXbg1WQZFdmLPkQcoauDRFIwKm
         GmZg==
X-Forwarded-Encrypted: i=1; AJvYcCXx48aENW78ECSougpkefHFze6Uvx89Fr+SzveGQojd5JRpKq0SvjvhCWvPBguO4RrGYL9EplrbSNdLLcN4895PUaAgayqZpL0ql5Hk5qGEksVhH2sig1FQFU8hvQ/w3A==
X-Gm-Message-State: AOJu0YySvBaE0vco+ECqHx/wMhVopubfWAxDy9cLxL72afVJcL+EAha8
	Kxd2g2UJvYx48lRaIcEGYOZy3B/CVOBreWoOHdQ92Nf7GZQqOHYN
X-Google-Smtp-Source: AGHT+IFj7I4WRf6mG1Ngr9iOIJklIrAymGwlwsRpKSgckGok7UED5Jz/iGyna+dzLfvclH/dWdFZdw==
X-Received: by 2002:a05:6a00:9296:b0:6ec:ceb4:49b8 with SMTP id jw22-20020a056a00929600b006ecceb449b8mr1142659pfb.0.1712307718798;
        Fri, 05 Apr 2024 02:01:58 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:58 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
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
Subject: [kvm-unit-tests RFC PATCH 06/17] shellcheck: Fix SC2155
Date: Fri,  5 Apr 2024 19:00:38 +1000
Message-ID: <20240405090052.375599-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2155 (warning): Declare and assign separately to avoid masking
  return values.

No bug identified.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 10 +++++++---
 scripts/runtime.bash  |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index f9d1fade9..ae4b06679 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -411,7 +411,8 @@ initrd_cleanup ()
 {
 	rm -f $KVM_UNIT_TESTS_ENV
 	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
-		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+		export KVM_UNIT_TESTS_ENV
+		KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
 	else
 		unset KVM_UNIT_TESTS_ENV
 	fi
@@ -423,7 +424,8 @@ initrd_create ()
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
 		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
-		export KVM_UNIT_TESTS_ENV=$(mktemp)
+		export KVM_UNIT_TESTS_ENV
+		KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
 		env_file
 		env_errata || return $?
@@ -566,7 +568,9 @@ env_generate_errata ()
 
 trap_exit_push ()
 {
-	local old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
+	local old_exit
+
+	old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
 	trap -- "$1; $old_exit" EXIT
 }
 
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f79c4e281..3b76aec9e 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -15,7 +15,9 @@ extract_summary()
 # We assume that QEMU is going to work if it tried to load the kernel
 premature_failure()
 {
-    local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
+    local log
+
+    log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
         grep -q -e "[Cc]ould not \(load\|open\) kernel" \
-- 
2.43.0



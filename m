Return-Path: <kvm+bounces-16332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D138B8938
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 13:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BEC01C21060
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFA8E80BEC;
	Wed,  1 May 2024 11:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QZDtpXPV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D690A6F067;
	Wed,  1 May 2024 11:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563026; cv=none; b=DlcSlxQm6g1jFKuavC2beD/9GqD2a6tEIf+qwhIG4rBWvEBpb5qZqAX406ReAaJM8GNsJPbtmg89rCYFxqFpkN6/2eVIFIxwl1g2QKe9QvImVYdaxKa8zGpSR5K15LQnZ/ja91XyICZ2OiWqbZid94kr9SL6cCdHqN/Rt8CGGG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563026; c=relaxed/simple;
	bh=8rPXa8viuRgylwUaKzJXXgmN4UO7CSiJaIGOKnKmXkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwHl4uYOZqcwipcITWMitWRd+vqP8315Vecqv+vT1+l0H/BipZzssikDCpWtYzqREEDQs0yNWmeIsKc49IQ9IYbI062TZMyco9s2Cslf2k+i7s7WLtnmv7KoR09S3c2l8Mhcnrzf+ZGAJDoBB/Ic6zCJSGA7CWEemzp5VeBsh9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QZDtpXPV; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1ec44cf691aso4785295ad.0;
        Wed, 01 May 2024 04:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714563024; x=1715167824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1mJOZjxszbvpsd8NIswtou8sxuQs1WjsSOCG5FXC6/w=;
        b=QZDtpXPVHCem2S68AxBwrvhwUi4s1E75yh4oXXLKSjI+kD6CfZOFLjSo+zD2waKubd
         GKKFI7Hr30LW/wg4x/vi7VwbfSLU5/EoPDV8HStWV0vx0a7w5/k4sDf+PqqvTgwcggOs
         P0y3e6DuK9qdEemTDgWI+AgzYXGh8WuzNZvVhDHi/W8+Y9ju32N5VPqa5e3NzW24hlgD
         kcGWlF5UEpq+5plQNtQoZLEKb+6Jg7pg66d9036pdrSBnAvMADoVHoIC5gCJoKqIwUtm
         ix+hW9VnsuVnFLrjQ6gedUbSZMrX9/lyAYraucrjkNvo2plUzkvDGrA1+e4S8K0BBT6j
         AriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563024; x=1715167824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1mJOZjxszbvpsd8NIswtou8sxuQs1WjsSOCG5FXC6/w=;
        b=tT9MlcJj44qT5npXGX+bj2k64vIYmgGfGlCVtULPzrsHNuCYXcbjNQBoFOVxR1PPPC
         tKrz2DtOVSH4TCWnjpuZvufMftkg+67yTRc7cIShsv6N06ZRRbKtuYYmsdYqTOmsXBtP
         IoJhQTrsIwVHq3KQs3cT/RtlErfVyTUoL9DcTVl+xaiLLWoALB6TPp7kD8D0cPhoOcmo
         ogvykbklmnDqefLa5wUCSdzeu6O7m5xe1Gh9HqgobQX/lyc/pW9W+Cign9PceWroX+Kh
         tI6bk2j7XfZ9I8aG6n0gwtbeZd4Y29/WGu6zNwpGlNnXi77DJIX6faCNRY/BmVKCDlhO
         Io7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWWV8Zn0NFB5P9OxeD/QBQBk6HCCVBR1MOXvhQjNmah2w0nGq7CUwIbsCuOh0tvPbO1/dgmLJsORrdoA7ffL/lC/p3fNp2t1Ow3/4lkNjoB2pr/W4MjSxX5Q39SxnuObQ==
X-Gm-Message-State: AOJu0YwNfcXNyjiwMT28/yEQo4vmvTEO2i9lRpdcMUTmLyVQ9cRrix7q
	qiPFVWd0jUomY68IVn9ntmlAaJowDrESTWZ6Pw293uVDr+t287MP
X-Google-Smtp-Source: AGHT+IGXK6+KiFLFpugRbIQcKHRuDTSsHf1UqbW1yDelUvCorCI+dmN8AqtsodexPzQQ7lw0BtUoig==
X-Received: by 2002:a17:902:e812:b0:1e8:682b:7f67 with SMTP id u18-20020a170902e81200b001e8682b7f67mr3475208plg.29.1714563024087;
        Wed, 01 May 2024 04:30:24 -0700 (PDT)
Received: from wheely.local0.net ([1.146.40.196])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b001ec64b128dasm2267150pli.129.2024.05.01.04.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 04:30:23 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 2/5] shellcheck: Fix SC2155
Date: Wed,  1 May 2024 21:29:31 +1000
Message-ID: <20240501112938.931452-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240501112938.931452-1-npiggin@gmail.com>
References: <20240501112938.931452-1-npiggin@gmail.com>
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 10 +++++++---
 scripts/runtime.bash  |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 2ac7b0b84..45ec8f57d 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -415,7 +415,8 @@ initrd_cleanup ()
 {
 	rm -f $KVM_UNIT_TESTS_ENV
 	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
-		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+		export KVM_UNIT_TESTS_ENV
+		KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
 	else
 		unset KVM_UNIT_TESTS_ENV
 	fi
@@ -427,7 +428,8 @@ initrd_create ()
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
 		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
-		export KVM_UNIT_TESTS_ENV=$(mktemp)
+		export KVM_UNIT_TESTS_ENV
+		KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
 		env_file
 		env_errata || return $?
@@ -570,7 +572,9 @@ env_generate_errata ()
 
 trap_exit_push ()
 {
-	local old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
+	local old_exit
+
+	old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
 	trap -- "$1; $old_exit" EXIT
 }
 
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index e7af9bda9..597c90991 100644
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
         grep -q -e "could not \(load\|open\) kernel" -e "error loading" -e "failed to load" &&
-- 
2.43.0



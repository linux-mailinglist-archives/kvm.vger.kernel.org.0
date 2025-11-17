Return-Path: <kvm+bounces-63432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FBD5C66969
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:48:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 140534E11AF
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 23:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A06F2F0C6D;
	Mon, 17 Nov 2025 23:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lS8lRFbd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA4E2949E0
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 23:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763423326; cv=none; b=QKcfzd+QY5SEqhOcIeGiNBWOad3Gq0H/1QFONQIDsfp1ZYhfyXHeHIdCJxPi+fUDMFk7eIlOH7J+l+6qA9++NIDjQ7MM6PIv8VH/HF9ipb2gBWaeoW9ve/+KtjI+yzgUpsD839fqNqPHdJUu7OVMH6Ddg0/5fNm/lFCjlKFXLm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763423326; c=relaxed/simple;
	bh=Z4pftTDeBEDs6oxc+DJ2NwBMzDjsNvw3bOKcAn+6JyI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=j9S3nB9bkTBdzESVYAKfuz9Lb8JvOD+p3J9JuqCaOVAssa4tCGa0IE/eJgmI3lEDiABq7aqZqawqDd7nhmy9xBqBmYqTJBrpV7HSZbKITFLALYnQD3DqIPLbBT2Z3VPe2YK3sXi2wkAgV0zUWn0zPL4ZxA6ZpUkUectDJa+a4Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lS8lRFbd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-341aec498fdso7948708a91.2
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 15:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763423324; x=1764028124; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aU3d+3pQJsY3xhzaWn9RYSI+4sS5IDkQEzSm1sbrnqY=;
        b=lS8lRFbdFuXSZ2nvMZDPD2Ag4VFTNWrawqZZR1EayGhOI3U0/khszNS/KDuZJ9a2Ea
         1NkM+LMJNtB2dF9fBLHRmV28C+Yrc4+IVHvdAl01T5SjZ4uDIA+u0CWo/CsB8xii6LYu
         EbLd7NbFbmZUD1zOsRTSNLBo3Cy9rbyAalVawCiXq5sZjAOlm2JlDLubldBEQOU2M2sw
         62K3grAdLfafnZZ5hX6Oluqvmj3vEuilDTOZOo1jdkWYLzSc6QR5KUV4PJCth8Nsxmpl
         leVC5UO8D+1870wvXQjO2b+SEqeGG9QKcF23Hzzp6rrsNmlTYZzGyxeskx8rwGIa4Z9H
         NOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763423324; x=1764028124;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aU3d+3pQJsY3xhzaWn9RYSI+4sS5IDkQEzSm1sbrnqY=;
        b=fFbTAC4pGhuNgji0r0LPB6E0JrSYRlrtfFV8tA3BcNfIm8AOuZePDGTvAMLoYbLBJh
         Ov9ao2p3YUCLwbk2FOXRuYLpM9meJVoQJv6C4cOz4KejBP/9mYgvOKQpn3MREfe+dUDv
         oz34x1lk2vIoNKiuYAIXcIcZYMQCfknDjneKWlBiFUPT0lQpFeYNuo32gMdToDGHVIHd
         FZF1CyJegYwvqr3yUd+Ni3b++efBtLpowVhDso7kvqasWOEUKVNeRNN4FNpT/F+xDlU5
         UyxjT0RcP1XcBocabm822xJS8HVJf4I5QOILHvJUYc4ugIJP8fWYRYhEpT/CAjpCFmqp
         AfKA==
X-Gm-Message-State: AOJu0YzCk8vcgrGYoYS4EHiWrbCcKg8gCFsbKUTyV2qN5GIGZDERrxsJ
	JFgDQuZiMbEUSQdM682zvT/Jko8KSTBLVTxnJr0UXabeO/Jroc00KNuinIqcr37qN57x90sZ1r9
	kpYp452FDe+anVC6fUfAQvbQBl3BepDUfDmI7QFgnPSE436WF2E43jPGL7tF3koEMOqLGKHLqY2
	mPqOT7d7nvSaw7EelK0T2lRebxlImW8et9zhkSvDfLyeY=
X-Google-Smtp-Source: AGHT+IHCaf7q0OpeMitKvBDwHMYPbObEL8lSRqxTylXteVZIfAW4ggB3DgyPG88ktT9QPsezEtp+M6RxE0S6qg==
X-Received: from pjxx4.prod.google.com ([2002:a17:90b:58c4:b0:343:7af9:cef4])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2b48:b0:32c:2cd:4d67 with SMTP id 98e67ed59e1d1-343f9ec8fe5mr14525497a91.13.1763423324117;
 Mon, 17 Nov 2025 15:48:44 -0800 (PST)
Date: Mon, 17 Nov 2025 23:48:35 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117234835.1009938-1-chengkev@google.com>
Subject: [kvm-unit-tests PATCH] scripts/runtime.bash: Fix TIMEOUT env var override
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

According to unittests.txt timeout deinition, the TIMEOUT environment
variable should override the optional timeout specified in
unittests.cfg. Fix this by defaulting the timeout in run() to the
TIMEOUT env var, followed by the timeout in unittests.cfg, and lastly by
the previously defined default of 90s.
---
 scripts/runtime.bash | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 6805e97f90c8f..0704a390bfe1e 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -1,6 +1,5 @@
 : "${RUNTIME_arch_run?}"
 : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
-: "${TIMEOUT:=90s}"
 
 PASS() { echo -ne "\e[32mPASS\e[0m"; }
 SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
@@ -82,7 +81,7 @@ function run()
     local machine="$8"
     local check="${CHECK:-$9}"
     local accel="${10}"
-    local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
+    local timeout="${TIMEOUT:-${11:-90s}}" # TIMEOUT env var overrides unittests.cfg
     local disabled_if="${12}"
 
     if [ "${CONFIG_EFI}" == "y" ]; then
-- 
2.52.0.rc1.455.g30608eb744-goog



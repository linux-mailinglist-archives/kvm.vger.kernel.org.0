Return-Path: <kvm+bounces-56959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14B28B481BF
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 03:06:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00576189BED0
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 01:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7381922FD;
	Mon,  8 Sep 2025 01:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YCYqwKVU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DBB19E967
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 01:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757293602; cv=none; b=GUxLoNnKvZi1pfCGvngdejf22ls47ff1jCMGj2nAtCSp0Lcjpa2EJbHoxgLviHHGOcamVLcJewQJG1bgjcCeAbinuNZMzAFU0LzVg/WdixjuE96WQE32FQH+4wDXk/3YIs7BlS9sO1jNqZTP+ybufhnl+VAM8EEIJ2pFbqds41M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757293602; c=relaxed/simple;
	bh=6//d3s1xRpnqbvqMl9ZqeNlULsuLKhhzPMZTehR5Q2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaMcjRUnfjCzI635P56pc216jrtEmQCV6lJj2lcZG/s+gbZ0f7BlmoTzpFkUG/0jFh61v89s8faiZ8eK07G874Zy7iQvnKywFtNlXrLSXxCYHdGlq1o0zWQnPE+TcA9c70968nXMpKBrR5aCuBY9m00efQbIkeVTb3awtEa93d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YCYqwKVU; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7722c88fc5fso3376832b3a.2
        for <kvm@vger.kernel.org>; Sun, 07 Sep 2025 18:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757293599; x=1757898399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQT9eTMrRmn+OzlzVaTflxL78oSBXuG2K1qxi9R+p9s=;
        b=YCYqwKVUqrlB7vhkBN9ajqqrg0o7eCHc3wo5gkTJDdeklxtWAUqi4hV0xTxhmRb9OE
         MWAuXT+DwQsbopM2l0pNo9ATscLCReoqRbceYCkfc1fDIlnx3m66NlR53mOfWYEn0fMe
         M4M0Ku8iM2dYLtZFoKqxSkk6fgy/sHcU0/1mmnaDTQVGN6NF+8eLpeww2Ey0qlekdUf0
         hWkjfokuaE24bVzC05+4GEB6xNCfC1kOz7bJggvAEVhLSzYp/kNWHw6JRjoE36DVnmcM
         Lhk2sxKbxhpFS/ta0WzSbE/y/KcEw6euzhAIX9Pjve8ro9rEBat5JvOBYOTSrKXadoy8
         D+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757293599; x=1757898399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQT9eTMrRmn+OzlzVaTflxL78oSBXuG2K1qxi9R+p9s=;
        b=aS8qPWrYrWCu9WqSxBJy/aMYGze7HfRScr3HrUFvbDSm9Jo5/6Ot5Qa5nAEbGIh3tz
         cLWvghmryJmK7lqWpHPjTs2IKap3g7JUzPbQXdaikbY47Kq3Swx3qTXgA8nL5nIP2NBw
         R9CCpQ2yHdxULh1HEN0sd0z9lORqxYfC4rlx7dyAj8C9wJroQtoy00Qhu8icUdcPcOLR
         Wcg1cZyY+dpqzCQ+jrPmYoNuRQa6afOFdo/mOSiU3hojohtpmGATMLYuesQqJSGVSp/1
         M77F+93XI3fhuX2cd9YU+Yn1p98ZzyzmpFrs6DRvv+eZde5sWTKGaGHwW1HpIWyxj8IC
         3F9A==
X-Gm-Message-State: AOJu0YzfPageZNRJv8jRF0c2NvFCmVXHWBv6vXKGepjF+2MSprWD2bRH
	RWcQbNqVKtDDFhARrKo2A+K+2/S2YTH2il2Kbe0NB2tV0jOoBZ3sRKFqR0Ft3g==
X-Gm-Gg: ASbGncvTZQTvnuv7EznnZh6+pYZHe5zoOuaJZ2InmRbuxrkuai2/loX66d3psHvdEd8
	BVX8AqK2XNGHCF4r6N3pQKpHOH+CbDo1JUOxQ/GldR39EIUk/2x9B+8zGpUOs17lBBgt97UWnw4
	Lpn4wkt6/zs9ad12nlabS6Te32dErDKS62UlzOVrXq+VOoVjPNoG17rkrw5c9Sbz7CTqzRb8EwL
	hp5TDrecl/zzxGl13izeX54kExvdZ4P37rhToykhvPWVhig4jTyXwcCuMEd2hkfTXEhmcFLupqu
	2TofZ6wPn4iKq/aqM6+SowBeuOORc+Q/ZzyM3XWdXWvY090hXkl9ZDSpKLPad2AMfvmqcj4RUoo
	1f/d0qWoopyF92mSDnP31iJIjhlCxMzDA5YovokRQ76I0QY95eSHo8WeoDKFhv1MJ0LER
X-Google-Smtp-Source: AGHT+IEUmS3BrXw9i7Cn3ipiZgjhoU6JUViEvHDPyCzTOvtgmINnuNl/Vf8OEDtpBL4D4AVqZ74cXg==
X-Received: by 2002:a05:6a20:a11d:b0:24e:84c9:e9b0 with SMTP id adf61e73a8af0-2533f7cc30fmr7913988637.17.1757293599375;
        Sun, 07 Sep 2025 18:06:39 -0700 (PDT)
Received: from lima-default (123.253.189.97.qld.leaptel.network. [123.253.189.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25125d76218sm49507775ad.119.2025.09.07.18.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 18:06:39 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Shaoqin Huang <shahuang@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm-riscv@lists.infradead.org,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 2/2] shellcheck: suppress SC2327,2328 false positives
Date: Mon,  8 Sep 2025 11:06:18 +1000
Message-ID: <20250908010618.440178-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250908010618.440178-1-npiggin@gmail.com>
References: <20250908010618.440178-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Shellcheck warnings SC2327,SC2328 complain that a command substitution
will be empty if the output is redirected, which is a valid warning but
shellcheck is not smart enough to see when output is redirected into a
command that outputs what the command substitution wanted.

Add comments and shellcheck directives to these cases.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 9 +++++++++
 scripts/runtime.bash  | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 58e4f93f..9c089f88 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -9,6 +9,11 @@ run_test ()
 
 	# stdout to {stdout}, stderr to $errors and stderr
 	exec {stdout}>&1
+	# SC complains that redirection without tee takes output way from
+	# command substitution, but that is what we want here (stderr output
+	# does go to command substitution because tee is used, but stdout does
+	# not).
+	# shellcheck disable=SC2327,SC2328
 	errors=$("${@}" $INITRD </dev/null 2> >(tee /dev/stderr) > /dev/fd/$stdout)
 	ret=$?
 	exec {stdout}>&-
@@ -23,6 +28,10 @@ run_test_status ()
 	local stdout ret
 
 	exec {stdout}>&1
+	# SC complains that redirection without tee takes output way from
+	# command substitution, but that is what we want here (tee is used
+	# inside the parenthesis).
+	# shellcheck disable=SC2327,SC2328
 	lines=$(run_test "$@" > >(tee /dev/fd/$stdout))
 	ret=$?
 	exec {stdout}>&-
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 289e52bb..12ac0f38 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -190,6 +190,12 @@ function run()
     # qemu_params/extra_params in the config file may contain backticks that
     # need to be expanded, so use eval to start qemu.  Use "> >(foo)" instead of
     # a pipe to preserve the exit status.
+    #
+    # SC complains that redirection without tee takes output way from command
+    # substitution, but that is what we want here (tee is used inside the
+    # parenthesis and output piped to extract_summary which is captured by
+    # command substitution).
+    # shellcheck disable=SC2327,SC2328
     summary=$(eval "$cmdline" 2> >(RUNTIME_log_stderr $testname) \
                              > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
     ret=$?
-- 
2.51.0



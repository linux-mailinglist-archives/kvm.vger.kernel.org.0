Return-Path: <kvm+bounces-13798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C4A89AAD0
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 14:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 986D62818FB
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 12:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86052E83C;
	Sat,  6 Apr 2024 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4MKjmSe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171892D05E;
	Sat,  6 Apr 2024 12:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407143; cv=none; b=JscMUdPrnVrB0rmyV6NXJI8/bAYZQEw77bPyxrGqwsq8MMmmyOA8hFDABZUJy4u5wk03x3bOem9fBkwzihbip/RkiXBvaT/ZcEM1YnFUG6wKqdlcVKCz4EwU6EfPyiwXX9ly35TOC8uH4BX04vSPHRCksTfYgylNmfITtHjeVoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407143; c=relaxed/simple;
	bh=fQCsq+sZAe6QlgWYF8/YRGqIoB5/+pyiNJbHQETHeX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pRhXt8MoEJFgBS2fgCjcv0+RdVh5q+a9obe2MG2g/iUVRxQz+8sebu0nQ8IIlS4SMHwHH2mxEIvcE3lz/zTn25hc6fuCAdYzEMPueCz//eM2KvhLa/NEdBDiIwBl1YRVKSDw+IervNwMdrkXBSE/edUBrIrG44ube1L/qWvFJUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f4MKjmSe; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2a2c028b8a6so2043613a91.1;
        Sat, 06 Apr 2024 05:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407140; x=1713011940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbXS3mPbclefehTNkJZ/z/tUSWiPiMKoUzf34+kT7OI=;
        b=f4MKjmSegwu6HOdwUYAbrlINzRPvIjBErFWk8EUBp8nn8TIQ0GP/2nTrts7xWGHSUl
         +zMeZK2gyUdsk+uo972Ss2x0Rl9DpZN5H+vm6CPlKu/uKiZU2PKgELtO6P8A0ZEFnM+w
         YQreNjMpD9kO2z5FelH9fCuPZJFo9urSzrUfmfjnHB9ouhY8Ve4TCoADuFi37w2vdDs3
         7Ul3perjciFwC6udsz/GgbuzFm+PJ3WID2UxR1v0AaZGV56X2S/p6Kq8I6jhnq4VQCo9
         U7gTBARfJV9bJzEVk+vqP9Sc6D88C8LmJXNo89DoREvn/QMTgG+1NkrGfK7ZHdlwYt0x
         VNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407140; x=1713011940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IbXS3mPbclefehTNkJZ/z/tUSWiPiMKoUzf34+kT7OI=;
        b=GiA0EUAyG8h0zNWphtS9K/G7RIx9ZWrGkBQuZvVyx/LzhBjke454EFCVMDNCkyZIhZ
         u8J9AqPh+2FxMX+Yewjwmc/Nl5d+BTvra4LSHpaSw1GmB7DuGfSta/Qk8kf2N1OLizKQ
         boOVMfROPmKSddeVmhV3WjF89pBn9H/o+Y6SZBMPBOh4+NIvTzw7J+bcY5qvkibshWgn
         X+DLkDUBeLSZCzOq0OR5FWUstoT3ZhX4c+nvy1rgYrIzLrJKrlECKJyHRth6Bol9K9q4
         JH3/E/q+B9gjrCU9C3caZZWJboN0GDzuL03mK/QIYo3XjuW7INA112NlbnoLXaRc/+yR
         +WKw==
X-Forwarded-Encrypted: i=1; AJvYcCVo8/oMqMjprCZOtUiS0+yfIAjNawYwTJtYSjiCSIiZRk1xvpeNRH+HjkoHCfzsaQOAs1g2uzQoAt2FQIE29IIlrlzvua1jFfbGDfYZawE/pHC9IDgH5qv0M4+b/6hstA==
X-Gm-Message-State: AOJu0Yz6AqKujm6iIH+1AVacpuP1Num6S0kHZeC4FWpJ02jgbIY1JyUg
	uvQTopeMP21bzu9LFkLlcBBQ2JZmcYLv+VP7dpz8St8Y4E+r76lQ
X-Google-Smtp-Source: AGHT+IGZuRmyUSURkYq7nO4hW7JRTEzJugpaiD6OSQX4jAsuLRrinwKGCqQjaKwfezP4e8hM/R6shA==
X-Received: by 2002:a17:90b:3795:b0:2a2:53ee:bd08 with SMTP id mz21-20020a17090b379500b002a253eebd08mr3514004pjb.8.1712407140290;
        Sat, 06 Apr 2024 05:39:00 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:38:59 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 01/14] Add initial shellcheck checking
Date: Sat,  6 Apr 2024 22:38:10 +1000
Message-ID: <20240406123833.406488-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This adds a basic shellcheck sytle file, some directives to help
find scripts, and a make shellcheck target.

When changes settle down this could be made part of the standard
build / CI flow.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .shellcheckrc       | 30 ++++++++++++++++++++++++++++++
 Makefile            |  4 ++++
 README.md           |  3 +++
 scripts/common.bash |  5 ++++-
 4 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 .shellcheckrc

diff --git a/.shellcheckrc b/.shellcheckrc
new file mode 100644
index 000000000..491af18bd
--- /dev/null
+++ b/.shellcheckrc
@@ -0,0 +1,30 @@
+# shellcheck configuration file
+external-sources=true
+
+# Optional extras --  https://www.shellcheck.net/wiki/Optional
+# Possibilities, e.g., -
+# quote‐safe‐variables
+# require-double-brackets
+# require-variable-braces
+# add-default-case
+
+# Disable SC2004 style? I.e.,
+# In run_tests.sh line 67:
+#            if (( $unittest_run_queues <= 0 )); then
+#                  ^------------------^ SC2004 (style): $/${} is unnecessary on arithmetic variables.
+disable=SC2004
+
+# Disable SC2086 for now, double quote to prevent globbing and word
+# splitting. There are lots of places that use it for word splitting
+# (e.g., invoking commands with arguments) that break. Should have a
+# more consistent approach for this (perhaps use arrays for such cases)
+# but for now disable.
+# SC2086 (info): Double quote to prevent globbing and word splitting.
+disable=SC2086
+
+# Disable SC2235.  Most developers are used to seeing expressions
+# like a || (b && c), not a || { b && c ; }. The subshell overhead in
+# kvm-unit-tests is negligible as it's not shell-heavy in the first
+# place (time is dominated by qemu startup/shutdown and test execution)
+# SC2235 (style): Use { ..; } instead of (..) to avoid subshell overhead.
+disable=SC2235
diff --git a/Makefile b/Makefile
index 4e0f54543..4863cfdc6 100644
--- a/Makefile
+++ b/Makefile
@@ -141,6 +141,10 @@ cscope:
 		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
 	cscope -bk
 
+.PHONY: shellcheck
+shellcheck:
+	shellcheck -a run_tests.sh */run */efi/run scripts/mkstandalone.sh
+
 .PHONY: tags
 tags:
 	ctags -R
diff --git a/README.md b/README.md
index 6e82dc225..03ff5994e 100644
--- a/README.md
+++ b/README.md
@@ -193,3 +193,6 @@ with `git config diff.orderFile scripts/git.difforder` enables it.
 
 We strive to follow the Linux kernels coding style so it's recommended
 to run the kernel's ./scripts/checkpatch.pl on new patches.
+
+Also run make shellcheck before submitting a patch which touches bash
+scripts.
diff --git a/scripts/common.bash b/scripts/common.bash
index ee1dd8659..3aa557c8c 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -82,8 +82,11 @@ function arch_cmd()
 }
 
 # The current file has to be the only file sourcing the arch helper
-# file
+# file. Shellcheck can't follow this so help it out. There doesn't appear to be a
+# way to specify multiple alternatives, so we will have to rethink this if things
+# get more complicated.
 ARCH_FUNC=scripts/${ARCH}/func.bash
 if [ -f "${ARCH_FUNC}" ]; then
+# shellcheck source=scripts/s390x/func.bash
 	source "${ARCH_FUNC}"
 fi
-- 
2.43.0



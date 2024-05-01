Return-Path: <kvm+bounces-16331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DCC8B8935
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 13:30:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 875AE284AB5
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 616D679B7E;
	Wed,  1 May 2024 11:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fG7Gkkh2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECBF6518F;
	Wed,  1 May 2024 11:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563017; cv=none; b=sdlM5wCb4Jl50TUdlX8mD15oWok4+NKdoiY3Xha78hdnXIRL+jW2W4DYoC1wvVOOs0gJBZsX2BI5rS2F72lLBOC+VX20y9+RSHWudbsvXWpsaccPCfpOiJnZLGdViiPPb/HjldgdFbQumAySCWMdiFqzFEWZNnKLQZD6MILgrJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563017; c=relaxed/simple;
	bh=aNQlpbX1V+40h70SYPNqIDOQATiZuD+yGYyg//lfbPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZF0xw3SwvufN3NT1gCIAqYJ/XqNcANYBp7WCX+51wfm4ghqpkMaX8Hh3rL4lOgcGiIGY0iBb5p1ZOLt17XY6EKBXTgE9pQptZSY1gpD7qckJGCu2qc1DE9W0VUyEIvlv+bXAisAN2UiBHU7ewD+VNFF9oMv/V4DxXY6M+GYjgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fG7Gkkh2; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1ec69e3dbe5so11248665ad.0;
        Wed, 01 May 2024 04:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714563015; x=1715167815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qEezwiCyGwOZD1+v35KdQzu2KwTw4n21wPX8WyrxUmo=;
        b=fG7Gkkh2MAMKUjzdo0yklZe33C9QuScqB6mTWjdJi9NJJg1/jYRGLpDFs1MnUSsuXO
         rAgqZCgz0zAKXmbgF0yOgeja4TmXYPx/q2NycgXwyrTJaSSo6jQoZFV24VMdiFL9jUKR
         MSFN7VcU+lGRI3qDMOFUUDl+HzubTrlpd4YFomSbg79yLuPbHfbVR2D7atnqJENJvAae
         govlEQU4eQ39/UhJ6vWmNQJokggc7NxmFPtYEFIozSXg1SyoINDTRXAxQo+KlX/QKSH3
         OGyQ7nfIs7AKhPqKharfUMf+uND4BH4/Z9AoViQMMWTHf8vWfzq1Vs2maXiZ9pcrH1S3
         5m7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563015; x=1715167815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qEezwiCyGwOZD1+v35KdQzu2KwTw4n21wPX8WyrxUmo=;
        b=ut6VXJzluqISoXP5gORguqBXpZyWF3q2YJBXuKbsfmohYXfUg4hGBBIaBVoSPjv783
         FRRfp2ZL+pNiURTxvl854AbXI1EixBTE+oUSMlLUjTItJcRMaDf893Y6ZwvODqms8nRS
         yelVnHwxj+TDt6w0QeGQQThQMZySNljZzgxe1qYR0N3BV5s2AZZjTuOLBtoTg+558XSZ
         5DyId+3naBZ6aGUykdganFaK/UWaqaDEpK4RCQED47By1q4SAgYdCZQ1c0OGAOSbXXqA
         zStkJ/kZXbBN18NfDayoQnhSrlc8i5PuPNLfelZTFs+yOF5LZfs1/JFE6Jvruhg/aJPV
         OUZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmeG3LrX/4QOSpwrMStZLKg7C1RNyD1xvyOWR2+xAnRLDFFceg0ZzGt2EooAzt4TTl9XprBFjyhjQ9kYi56aY3697ZAt7GosMJIw+qlAjV5g/ak/UxbUJtNXgpJKcRyw==
X-Gm-Message-State: AOJu0YxtSL1+Stno7ShGMwwNLEuvIR6h4zLF1qDTvr4r3AjvUTb11ENq
	HlShIp7Xl0bKtGK/mPIflNuSH0JJW+3lrff+pdu95+VTZYwyTifZ
X-Google-Smtp-Source: AGHT+IEFPYODr4TyreDdFCG6z01houFeGcrnNZN3iQCpjD0ek1ej4HVV0Wcok3E4Ojsg5zSqMK/UaA==
X-Received: by 2002:a17:902:a383:b0:1e2:96d3:1bc1 with SMTP id x3-20020a170902a38300b001e296d31bc1mr2081748pla.1.1714563014788;
        Wed, 01 May 2024 04:30:14 -0700 (PDT)
Received: from wheely.local0.net ([1.146.40.196])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b001ec64b128dasm2267150pli.129.2024.05.01.04.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 04:30:14 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 1/5] Add initial shellcheck checking
Date: Wed,  1 May 2024 21:29:30 +1000
Message-ID: <20240501112938.931452-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240501112938.931452-1-npiggin@gmail.com>
References: <20240501112938.931452-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This adds a basic shellcheck style file, some directives to help
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
index 4f35fffc6..6240d8dfa 100644
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
index 6e82dc225..2d6f7db56 100644
--- a/README.md
+++ b/README.md
@@ -193,3 +193,6 @@ with `git config diff.orderFile scripts/git.difforder` enables it.
 
 We strive to follow the Linux kernels coding style so it's recommended
 to run the kernel's ./scripts/checkpatch.pl on new patches.
+
+Also run `make shellcheck` before submitting a patch which touches bash
+scripts.
diff --git a/scripts/common.bash b/scripts/common.bash
index b9413d683..5e9ad53e2 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -78,8 +78,11 @@ function arch_cmd()
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



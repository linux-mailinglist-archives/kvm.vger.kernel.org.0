Return-Path: <kvm+bounces-13678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D885D8998B9
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CD62B21B00
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1855715FA99;
	Fri,  5 Apr 2024 09:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgsGGuX3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F48611E;
	Fri,  5 Apr 2024 09:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307677; cv=none; b=onrfeSOnoFuQP4fRr2N1eeES0+sj1TU9b+iNK7MXZYLDn37jrVG1bxWR2JreoPsnMSZL23bu4jc/7Jf7Budst8nCeN79bgvIurrbudserd/GGJBNkgNBkQhJgXXBGKptMOobbhGBiOw99bIBEWWa+JQQ8HXPdmPDrMtPlODrmhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307677; c=relaxed/simple;
	bh=hU5DyQmB+0+LzoAbBVPYnqv0ir777ARq0XXH0tjCyAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fDY8bTjb1+mr2EdJhU7lT/dHV8TOqmZyo6JIAV0cGBz7S7wk7tHkRo/7NPDzjRPoExPsPAidXHq4O89PIFIGos8B8ZrQvWjFOjlQrskvQfJIn+mEHHzeqiPbswvt86udC/dMamdrUJC/m/ijHvGnd9zqL0QQsbqqADD4SecRals=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgsGGuX3; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5d8b887bb0cso1529080a12.2;
        Fri, 05 Apr 2024 02:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307675; x=1712912475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9O2yN202NqTro1AvvJbZu3/0EjKIcT0nZopuJ7bwyA=;
        b=dgsGGuX3vE8lKZ7ioUXcGSqmxyf3ut6eIHHurMdWKmYec6r2AdgO8Lk7B7IrwSdPM7
         oGOdVQvz0MwI9fb+d7w4lxTjcHFilaC41Q7wFe7glh9Fg250Ty4dtB0YbAbCSOxxxZfe
         zdWqrAhHi9sRq4/lgBn65sEwR7x10py+aRPXEeAzQGLCrBIWQELWzMekH0Z8g5OF0iuh
         Jbzq0wyS06/TbZpcQ4eaCkNDDIa1O3eDUL1x7F1HuMyfz9K4eXWoCrvUfTAP02J/FDK5
         KFCt170/mw22ujBhVgCE22QFubgfo/O+ZmF5jAEU6XXBw4diXVtpTRPtb0Ee+JvsVkbr
         R8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307675; x=1712912475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q9O2yN202NqTro1AvvJbZu3/0EjKIcT0nZopuJ7bwyA=;
        b=piD+WqWbLUSawSym19kE9a5v8yEKKC90HFGJssFqN6gzXLp7rKiK3ccv3kZEspj9gM
         R+kLsCKuzqY4UUkfgvnPJX91q5mlc2rkANbC4cm7VKvgSWGSj6vc8S514jdz6QkdOWFg
         A1R/4pTJEYnwnUgQCG0nLeyTzNCy/XpuF7t3gZXE9ylEzoHhMDCYE739CRUmOMuz0n40
         R8L7g0UJ+Az0vc0YXDkCiPj7C9k4eTfV70IcM8pB8ufW28vVZYVWn8v2rqQ5lnXlVbWb
         EUS60wNg7ACBZU0Bcqy7uPzkZVs1D/zZsKq8QYXQ9gApHJ2i0w26NFbjqjWKTijkm/6/
         ttuA==
X-Forwarded-Encrypted: i=1; AJvYcCX6WD21gFcEQ+tLv2QShc6g38EZXqG2u3UaV0Vs+zQePXELwE1nBgrFuMqx9rH0sHHnQvbOazQr5BUzKbPPVwfzTuV64K4u/nowYp41LEMdKYHijyS1yso01yGLGMbdMA==
X-Gm-Message-State: AOJu0YwfPm9aZYUa8CHyV8CyGZqeTOrlbcNUtSxYQ3bzO6LXh7chFdcm
	dw4btpWHHZDchxAcM9NMPki0rhG/T1CByMeAVZgXQL1hz5P1brhN
X-Google-Smtp-Source: AGHT+IG3iGQczT0lBc6+U4GYfzX73yWnuYF+Xus3bRqqURm/CLDRZv9h0qLlh8Hdhn5oQL0ovQ4TZg==
X-Received: by 2002:a05:6a20:9494:b0:1a7:30ce:4261 with SMTP id hs20-20020a056a20949400b001a730ce4261mr906687pzb.24.1712307675161;
        Fri, 05 Apr 2024 02:01:15 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:14 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 01/17] Add initial shellcheck checking
Date: Fri,  5 Apr 2024 19:00:33 +1000
Message-ID: <20240405090052.375599-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
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
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .shellcheckrc       | 32 ++++++++++++++++++++++++++++++++
 Makefile            |  4 ++++
 README.md           |  2 ++
 scripts/common.bash |  5 ++++-
 4 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 .shellcheckrc

diff --git a/.shellcheckrc b/.shellcheckrc
new file mode 100644
index 000000000..2a9a57c42
--- /dev/null
+++ b/.shellcheckrc
@@ -0,0 +1,32 @@
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
+# Disable SC2034 - config.mak contains a lot of these unused variable errors.
+# Maybe we could have a script extract the ones used by shell script and put
+# them in a generated file, to re-enable the warning.
+#
+# In config.mak line 1:
+# SRCDIR=/home/npiggin/src/kvm-unit-tests
+# ^----^ SC2034 (warning): SRCDIR appears unused. Verify use (or export if used externally).
+disable=SC2034
+
+# Disable SC2086 for now, double quote to prevent globbing and word
+# splitting. There are lots of places that use it for word splitting
+# (e.g., invoking commands with arguments) that break. Should have a
+# more consistent approach for this (perhaps use arrays for such cases)
+# but for now disable.
+# SC2086 (info): Double quote to prevent globbing and word splitting.
+disable=SC2086
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
index 6e82dc225..77718675e 100644
--- a/README.md
+++ b/README.md
@@ -193,3 +193,5 @@ with `git config diff.orderFile scripts/git.difforder` enables it.
 
 We strive to follow the Linux kernels coding style so it's recommended
 to run the kernel's ./scripts/checkpatch.pl on new patches.
+
+Also run make shellcheck before submitting a patch.
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



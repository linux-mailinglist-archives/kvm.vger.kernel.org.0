Return-Path: <kvm+bounces-13679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEAD48998BC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 11:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 604EE1F23E5C
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 09:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE13179BD;
	Fri,  5 Apr 2024 09:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nfllIvLg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8257E13D265;
	Fri,  5 Apr 2024 09:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307687; cv=none; b=mzw+vteNoWw3v9CNr9xNkkD18fM0xJoz7JvsyeqXpz5q4d27uqbcw7wZdDt8PCECaXytPiwPUm8M0T7BmARQKcTaEUIosmTC8HZJTZMt1Cj5oZQ3eqZxhUNhjDYxiF3HspzQUIUAyHey0LzbdTaMle/1e030BCgwN9f4oFo69N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307687; c=relaxed/simple;
	bh=JfJMxUdKZR8GL8vEZBI0bBxnPTsZ62D9OnWb7Hg3WEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqTUtt27aYm+YXMFtKxqDa6AmBq1WVLhQj4y0S23mNyyRg42dzp3Rwp8En/VcssC6i6SguEFVS31FZpme7Y4/DBOZzmgT2t9ZJvK3P6R/9b329zaxUOE3ZXpcK7m3IptLQX+8cQu3zd6oHCjq8MBXQgK0l3vD3IOBFfZEof5svU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nfllIvLg; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ea9a60f7f5so1666704b3a.3;
        Fri, 05 Apr 2024 02:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307686; x=1712912486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uu6wGEwM6aIXMj2Zv0exGHWMPbPED90o0LJmrvuij2Q=;
        b=nfllIvLgYg4pROhLN+7RHUMurFtfye2svhzrhITa4tuDXTX/X5kBXV7DSoX8sLZS6b
         XzxWXMmd/yTnt1zAtmaQ8W52tiDDkLtmJWdHwALzpSXLkSdTUi1ELb5KNAjrXJKDLiy+
         9uoChpoYF+tAv12ffFyKtorSAoFLfCTN7znHoBKUUl+F3oaBbVzWIVRd9RZyYgzmK7CX
         G1exeh/B6NpngTeAteSIYZyPZiOsvSzygIkY5n9mwtzjUfWGjEaGZ9Z5oZFckIKctdXA
         GseXe34+uNrpsRpcwwiuctg+wtUI4l75qvXQM5PvB5annJmg4Ktn8iuye8CGuvdYv/72
         gm2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307686; x=1712912486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uu6wGEwM6aIXMj2Zv0exGHWMPbPED90o0LJmrvuij2Q=;
        b=q/a4C5BMbmiraZepl1qVJZ07/oRbnExqrTiYtq7ztmyxXABt1rsKCZ+JMZuFYLA57d
         U7H15vs1Y/H27RHE0/sLkDRbe0GixJm2LiU4NUhsjC/AkqMVCw4wEK3APewInkzDOyFv
         OqQ22vkBQjJSDHveW3kR+uKDz4bS5J+krR2LfuQXiUDpbjaO0RsyJV6ElhhdlN6QoGFn
         MXTI4D+MghqkJucBdpnVQE9eR3WylDpaWnMzC94lqC04PqhpgydkNQ9atFGM5r9z9qO5
         JagJ8lg+Q1cfK00lk+UmWOLtcCkbidv2vc0frC/PrukvzpQvog8iqZ5BMjzMk5gmxLud
         ln3g==
X-Forwarded-Encrypted: i=1; AJvYcCUiDIF88mZtxKPfdXFNwmHMywaMoFjQJIKzBWQKYNoDNQe3yDqHN0N6cxXrZBtGKhryQ8IT2LlRzAyOyNQisNPTaooJ8Vwx7+gjSVaT0PmNnQftQmNFqjZhsirOU7dZHw==
X-Gm-Message-State: AOJu0Yx4lf+6uG/5y0sIY0u70wcoxb61efvLZrMHr7ftzApjsYmsC1g5
	gr/L/jdorqSYBHK6L//4jYTBWxQV6/fsXqElTZS+QsDCXQ3aH0gn
X-Google-Smtp-Source: AGHT+IHzCPSa8orVhvE583R1aVmAhgho8AabCJP5Cs3T+kAcshecv2v+XDz4XgLOLVKXC5dMRzf0KA==
X-Received: by 2002:a05:6a20:a122:b0:1a6:f913:afdf with SMTP id q34-20020a056a20a12200b001a6f913afdfmr991282pzk.46.1712307683777;
        Fri, 05 Apr 2024 02:01:23 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:23 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 02/17] shellcheck: Fix SC2223
Date: Fri,  5 Apr 2024 19:00:34 +1000
Message-ID: <20240405090052.375599-3-npiggin@gmail.com>
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

  SC2223 (info): This default assignment may cause DoS due to globbing.
  Quote it.

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



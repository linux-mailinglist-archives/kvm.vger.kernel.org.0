Return-Path: <kvm+bounces-8934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5170C858C5B
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:04:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75DE61C2165B
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B657D2D05D;
	Sat, 17 Feb 2024 00:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="doTD5fw0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7012D05F
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131537; cv=none; b=XEvYhHlo06b44C13oGCYWDhaXh50WTg1Wpm6oQPxPg01ojcdte3HcSz/IbXPq0rTts4QSPFa5lj+F30RA4L5187ubc9yzA5HSVkSCcoO2TKzI8HblFE3Db4bdgatY+Gv9Nwkz0K5OF9VRNp7C1SdWVK0UmzLkuqqUKaRQZsQ398=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131537; c=relaxed/simple;
	bh=p7r/Fef2L33IhIiGMHD6kN+7Sih7HgKDJIIBtiTNBeQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j9iNOoBmWZvX3xhZkJibM2BNgB7KH8BNB2xYL2N+Utp101k9YBuzYAuu1iPQeslwkSWIoKQwcWdk9naR6ycpRaVC/84d58F6hYrjU62tKJp69Kf1bl8vALyK8BEoeMz/sSjFvn4cph5VftybDJ4Do+w6O/seq3l1QjlZtRpkQM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=doTD5fw0; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-59d7cbf1279so1525076eaf.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131535; x=1708736335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EtMupTUIOKSWIiS3+KSauzncMWOa0iz/fT9+70O+xec=;
        b=doTD5fw0eUiJjyCEadVvwUOLzW3kKyOdzzx0vyjifPicJdim+nu66pwzOsg8vw8cwA
         hgOQyaR8NcW9Skug2tuvO9UtB/fQkYdztiSZDf1nvPltEy4rYtvh5Utex5YWpUQOZ/HR
         t0KeoTeA5nSCOvLaYekDrk7EMt+9IFAAurCkTlBKc4VLhH3NAZ/6hKBWtxGVZm2LIxBD
         zTSE+PqeaUeVWxKMAz0aQHPaZf1IRz1hGUNreI62BsylD5698bPXMBkz4j/9T6V4JyF0
         WJXp8ZqScG5T6z6H8PiLZ9vBWRsuP8TBjOun1+/4iGgf3G63w9cuhl6TJgoTf+5mrDW+
         y0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131535; x=1708736335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtMupTUIOKSWIiS3+KSauzncMWOa0iz/fT9+70O+xec=;
        b=ZR5TEPd6NjIWrmZHg5uU2HoiUhjRjCSuOB1BwDZNujSazIVZiGlM6Pu7uWgSutA3Qh
         lQ9Ch3YtMIwGXij03Vif2OxR8oUITv//cjSu1SG6H3cE3rdQ+oUBwPJGnodvbHjCOMCv
         pp7Z9pKbHRa/G+pfzijU0szzFsD6YLX2I06tCluyIwo6dSQAMTMeIPs7zVRLrl6eD0/N
         mgCmdBTmq6AJAJZj4ky4MkVPs8R4ZYZ6YDgk2r0hVGt6zOo8BoXEQyh7R7g/Fg3cV1+5
         v7kqS5kmUvUw0X1XmqVd7xQoGz3YVP6KCCxl2f2nfGJdPhoPHGmCD8ef9dI4/KiPpkmk
         LXTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc7cQWxTqokANtDVtB26Sm6uRi8bmdGBpVWHg6WA5ONOGtFcBxhLJb5NHNSGee7IdnZnztFfdrhxXg3cc1dSNTO5jI
X-Gm-Message-State: AOJu0YzueGfCIZFdSGV/oUTEuFauTbCFqeHl0KszS5v6bA4wcp8r8yV7
	mmI73yZIGUgiYdaQ44Y697x4do0vLmoqLUbCBDe1n5xJy7B5GFDAKtd7HAGPurg=
X-Google-Smtp-Source: AGHT+IGNbIUzWm0Nd5NFQVXMQHrTszP1TZWkXMNIGjnbL/tst4Vl5kEoxiI6rU6dM0tRW8yXxuE6PQ==
X-Received: by 2002:a05:6358:2913:b0:177:afce:b12 with SMTP id y19-20020a056358291300b00177afce0b12mr6399019rwb.31.1708131533554;
        Fri, 16 Feb 2024 16:58:53 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:53 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Atish Patra <atishp@atishpatra.org>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Conor Dooley <conor@kernel.org>,
	devicetree@vger.kernel.org,
	Evan Green <evan@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	John Garry <john.g.garry@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kan Liang <kan.liang@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	linux-doc@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Will Deacon <will@kernel.org>,
	kaiwenxue1@gmail.com,
	Yang Jihong <yangjihong1@huawei.com>
Subject: [PATCH RFC 15/20] tools/perf: Add arch hooks to override perf standard events
Date: Fri, 16 Feb 2024 16:57:33 -0800
Message-Id: <20240217005738.3744121-16-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240217005738.3744121-1-atishp@rivosinc.com>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RISC-V doesn't have any standard event encoding defined in the
ISA. Cycle/instruction event is defined in the ISA but lack of
event encoding allow vendors to choose their own encoding scheme.
These events directly map to perf cycle/instruction events which
gets decoded as per perf definitions. An arch hooks allows the
RISC-V implementation to override the encodings if a vendor has
specified the encodings via Json file at runtime.

The alternate solution would be define vendor specific encodings in
the driver similar to other architectures. However, these will grow
over time to become unmaintainable as the number of vendors in RISC-V
can be huge.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/perf/arch/riscv/util/Build              |  1 +
 tools/perf/arch/riscv/util/evlist.c           | 59 +++++++++++++++++++
 tools/perf/builtin-record.c                   |  3 +
 tools/perf/builtin-stat.c                     |  2 +
 tools/perf/builtin-top.c                      |  3 +
 .../pmu-events/arch/riscv/arch-standard.json  | 10 ++++
 tools/perf/pmu-events/jevents.py              |  6 ++
 tools/perf/util/evlist.c                      |  6 ++
 tools/perf/util/evlist.h                      |  6 ++
 9 files changed, 96 insertions(+)
 create mode 100644 tools/perf/arch/riscv/util/evlist.c
 create mode 100644 tools/perf/pmu-events/arch/riscv/arch-standard.json

diff --git a/tools/perf/arch/riscv/util/Build b/tools/perf/arch/riscv/util/Build
index 603dbb5ae4dc..b581fb3d8677 100644
--- a/tools/perf/arch/riscv/util/Build
+++ b/tools/perf/arch/riscv/util/Build
@@ -1,5 +1,6 @@
 perf-y += perf_regs.o
 perf-y += header.o
+perf-y += evlist.o
 
 perf-$(CONFIG_DWARF) += dwarf-regs.o
 perf-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o
diff --git a/tools/perf/arch/riscv/util/evlist.c b/tools/perf/arch/riscv/util/evlist.c
new file mode 100644
index 000000000000..9ad287c6f396
--- /dev/null
+++ b/tools/perf/arch/riscv/util/evlist.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include "util/pmu.h"
+#include "util/pmus.h"
+#include "util/evlist.h"
+#include "util/parse-events.h"
+#include "util/event.h"
+#include "evsel.h"
+
+static int pmu_update_cpu_stdevents_callback(const struct pmu_event *pe,
+					     const struct pmu_events_table *table __maybe_unused,
+					     void *vdata)
+{
+	struct evsel *evsel = vdata;
+	struct parse_events_terms terms;
+	int err;
+	struct perf_pmu *pmu = perf_pmus__find("cpu");
+
+	if (pe->event) {
+		parse_events_terms__init(&terms);
+		err = parse_events_terms(&terms, pe->event, NULL);
+		if (err)
+			goto out_free;
+		err = perf_pmu__config_terms(pmu, &evsel->core.attr, &terms,
+					     /*zero=*/true, /*err=*/NULL);
+		if (err)
+			goto out_free;
+	}
+
+out_free:
+	parse_events_terms__exit(&terms);
+	return 0;
+}
+
+int arch_evlist__override_default_attrs(struct evlist *evlist, const char *pmu_name)
+{
+	struct evsel *evsel;
+	struct perf_pmu *pmu = perf_pmus__find(pmu_name);
+	static const char *const overriden_event_arr[] = {"cycles", "instructions",
+							  "dTLB-load-misses", "dTLB-store-misses",
+							  "iTLB-load-misses"};
+	unsigned int i, len = sizeof(overriden_event_arr) / sizeof(char *);
+
+	if (!pmu)
+		return 0;
+
+	for (i = 0; i < len; i++) {
+		if (perf_pmus__have_event(pmu_name, overriden_event_arr[i])) {
+			evsel = evlist__find_evsel_by_str(evlist, overriden_event_arr[i]);
+			if (!evsel)
+				continue;
+			pmu_events_table__find_event(pmu->events_table, pmu,
+						     overriden_event_arr[i],
+						     pmu_update_cpu_stdevents_callback, evsel);
+		}
+	}
+
+	return 0;
+}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 86c910125172..305c2c030208 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -4152,6 +4152,9 @@ int cmd_record(int argc, const char **argv)
 			goto out;
 	}
 
+	if (arch_evlist__override_default_attrs(rec->evlist, "cpu"))
+		goto out;
+
 	if (rec->opts.target.tid && !rec->opts.no_inherit_set)
 		rec->opts.no_inherit = true;
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5fe9abc6a524..a0feafc5be2c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2713,6 +2713,8 @@ int cmd_stat(int argc, const char **argv)
 
 	if (add_default_attributes())
 		goto out;
+	if (arch_evlist__override_default_attrs(evsel_list, "cpu"))
+		goto out;
 
 	if (stat_config.cgroup_list) {
 		if (nr_cgroups > 0) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5301d1badd43..7e268f239df0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1672,6 +1672,9 @@ int cmd_top(int argc, const char **argv)
 			goto out_delete_evlist;
 	}
 
+	if (arch_evlist__override_default_attrs(top.evlist, "cpu"))
+		goto out_delete_evlist;
+
 	status = evswitch__init(&top.evswitch, top.evlist, stderr);
 	if (status)
 		goto out_delete_evlist;
diff --git a/tools/perf/pmu-events/arch/riscv/arch-standard.json b/tools/perf/pmu-events/arch/riscv/arch-standard.json
new file mode 100644
index 000000000000..96e21f088558
--- /dev/null
+++ b/tools/perf/pmu-events/arch/riscv/arch-standard.json
@@ -0,0 +1,10 @@
+[
+  {
+    "EventName": "cycles",
+    "BriefDescription": "cycle executed"
+  },
+  {
+    "EventName": "instructions",
+    "BriefDescription": "instruction retired"
+  }
+]
diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
index 81e465a43c75..30934a490109 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -7,6 +7,7 @@ from functools import lru_cache
 import json
 import metric
 import os
+import re
 import sys
 from typing import (Callable, Dict, Optional, Sequence, Set, Tuple)
 import collections
@@ -388,6 +389,11 @@ class JsonEvent:
     if arch_std:
       if arch_std.lower() in _arch_std_events:
         event = _arch_std_events[arch_std.lower()].event
+        if eventcode:
+          event = re.sub(r'event=\d+', f'event={llx(eventcode)}', event)
+        if configcode:
+          event = re.sub(r'config=\d+', f'event={llx(configcode)}', event)
+
         # Copy from the architecture standard event to self for undefined fields.
         for attr, value in _arch_std_events[arch_std.lower()].__dict__.items():
           if hasattr(self, attr) and not getattr(self, attr):
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 55a300a0977b..f8a5640cf4fa 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -357,6 +357,12 @@ __weak int arch_evlist__add_default_attrs(struct evlist *evlist,
 	return __evlist__add_default_attrs(evlist, attrs, nr_attrs);
 }
 
+__weak int arch_evlist__override_default_attrs(struct evlist *evlist __maybe_unused,
+					       const char *pmu_name __maybe_unused)
+{
+	return 0;
+}
+
 struct evsel *evlist__find_tracepoint_by_id(struct evlist *evlist, int id)
 {
 	struct evsel *evsel;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index cb91dc9117a2..705b6643b558 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -109,9 +109,15 @@ int arch_evlist__add_default_attrs(struct evlist *evlist,
 				   struct perf_event_attr *attrs,
 				   size_t nr_attrs);
 
+
 #define evlist__add_default_attrs(evlist, array) \
 	arch_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
 
+int arch_evlist__override_default_attrs(struct evlist *evlist, const char *pmu_name);
+
+#define evlist__override_default_attrs(evlist, pmu_name) \
+	arch_evlist__override_default_attrs(evlist, pmu_name)
+
 int arch_evlist__cmp(const struct evsel *lhs, const struct evsel *rhs);
 
 int evlist__add_dummy(struct evlist *evlist);
-- 
2.34.1



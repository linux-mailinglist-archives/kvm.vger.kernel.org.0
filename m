Return-Path: <kvm+bounces-8920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD71858C16
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:58:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 793EA1F226A3
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 00:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B7A1B7E1;
	Sat, 17 Feb 2024 00:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="CYSncEmK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F7A4C84
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131499; cv=none; b=CYX1Q8x7lHZ2wfc4L6hoWqB9R+yQjce+HxPN1DxeUnmFk0h8Im8JeNcgB26gBG+jXEeqbMZERfB2oQBqG9pzeNvufq5jNx3+FKgENme9OQP7hZnK6Ko+udECsqIPX7TJQIeyISveNTN9revYGeiweYjHOZSJrNI7VzLCgDhF7dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131499; c=relaxed/simple;
	bh=eC27GkJgH4kDACOma8I+4HOp5ndbhvI+DkBAu8euebk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TOFdq30TTZ2kLaCi54PJI5PBtTqZUTkjOKypXW4dWFfTd5TywPjjHHELOQM8qkDq6opVTap2DQBjKk6NxSZv8tHL14MoHE4ulJxewUiYPmFiAOoE4mUTfRwNEjjqad2oFO7F7ubOZkVl5DXj1tvSP8miGl0JWnOMO1YOIJhKOuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=CYSncEmK; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e10614c276so1830387b3a.3
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131496; x=1708736296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GdfDilW9Nk9gfAD8OoYJZ+QpUc7BOx+f1kYB5V55j2o=;
        b=CYSncEmK7oURLoAn3MpAloClKMs9ZDC2SBTMZwjyxGrWwyERqH2niyi+qzoK4fnmod
         mtjcPe1wb0WQlgwXxSzYhnuUwdYMp/bH2lOZ3k+rQ2b1JEhT5hIK4Pza9I7o2nw6UfGA
         LhtVhyJWhryE14BuJk1WEwxaiVp/XjNtEEH9I+v+LYldO4sZDaKKO6BhH9x6iLHJEGma
         UoUZi1kR84S9zJfyYA39+JjalITuSioMNvNv1TxbRma4dralztTdRAN45QSwYPMA4gHY
         RvB+U5pDAAe68gytRTCIHf4RIIW40aArUJ5BNe//cpUClhbtARqsJAiUetxxxEQ2bCRd
         elFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131496; x=1708736296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GdfDilW9Nk9gfAD8OoYJZ+QpUc7BOx+f1kYB5V55j2o=;
        b=YoPV8dcuGQh1tfo1tLTz2jam0QLcLWi91T1u4wWJqi6Qu/sct1NZfXTS+fvfoEvZZ8
         6sD3BOyfxnd9bTIrJlczTsSFvb9pb37eXN9d/HoYquJtxUS/EmaCIOi5rpEz541keCE7
         rB+aDoLjC2gegQVLMt1UDnicSZSSIBixLB9MOWpwOAiwTG2Cj76k4+FIFqTsvCakojvN
         hgVH8+AvpoeFQY214GG8wILRM2Lw6FoijIyjIB9kAo8zveNxyOWW0bX4fuiDQkleveBf
         exJbNAieEVNGkxBeJtf9wVBBnHwolfe7T2kXD9cEoRxTYnhoDqdcFY98h1x6bBUcGrro
         +ttw==
X-Forwarded-Encrypted: i=1; AJvYcCXoK8VBZmnh0SKTUdlCfNufzVwU6Kqmr0/qprEYYWONphzWmeO5zGgGl9wR5bb6XFCslm+zDFxr0aGiBWAAIuX3ESea
X-Gm-Message-State: AOJu0YxbDo0m/4uzHLByU5AQ8RmfomSWuUbOZwUqB21zDPszmE5eqws3
	IMI8nU/oJbFXXSiQdXBlQsAVx4RhmJpF8Vw9k8tYPrZclcrWZlKD5g97Ufvmg2E=
X-Google-Smtp-Source: AGHT+IEl08bugsJqJeah6DEdUtuymO07lUypuObDizLTwR5dLnoGamWdEPgOUAV2oyVt0BHvppithQ==
X-Received: by 2002:a05:6a00:928c:b0:6e1:4354:ae59 with SMTP id jw12-20020a056a00928c00b006e14354ae59mr3089434pfb.29.1708131496341;
        Fri, 16 Feb 2024 16:58:16 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:15 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
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
Subject: [PATCH RFC 01/20] perf pmu-events: Add functions in jevent.py to parse counter and event info for hardware aware grouping
Date: Fri, 16 Feb 2024 16:57:19 -0800
Message-Id: <20240217005738.3744121-2-atishp@rivosinc.com>
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

From: Weilin Wang <weilin.wang@intel.com>

These functions are added to parse event counter restrictions and counter
availability info from json files so that the metric grouping method could
do grouping based on the counter restriction of events and the counters
that are available on the system.

Signed-off-by: Weilin Wang <weilin.wang@intel.com>
---
 tools/perf/pmu-events/jevents.py   | 171 ++++++++++++++++++++++++++++-
 tools/perf/pmu-events/pmu-events.h |  25 ++++-
 2 files changed, 188 insertions(+), 8 deletions(-)

diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
index 53ab050c8fa4..81e465a43c75 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -23,6 +23,8 @@ _metric_tables = []
 _sys_metric_tables = []
 # Mapping between sys event table names and sys metric table names.
 _sys_event_table_to_metric_table_mapping = {}
+# List of regular PMU counter layout tables.
+_pmu_layouts_tables = []
 # Map from an event name to an architecture standard
 # JsonEvent. Architecture standard events are in json files in the top
 # f'{_args.starting_dir}/{_args.arch}' directory.
@@ -31,6 +33,9 @@ _arch_std_events = {}
 _pending_events = []
 # Name of events table to be written out
 _pending_events_tblname = None
+# PMU counter layout to write out when the table is closed
+_pending_pmu_counts = [] # Name of PMU counter layout table to be written out
+_pending_pmu_counts_tblname = None
 # Metrics to write out when the table is closed
 _pending_metrics = []
 # Name of metrics table to be written out
@@ -47,10 +52,17 @@ _json_event_attributes = [
     'event',
     # Short things in alphabetical order.
     'compat', 'deprecated', 'perpkg', 'unit',
+    # Counter this event could use
+    'counter',
     # Longer things (the last won't be iterated over during decompress).
     'long_desc'
 ]
 
+# Attributes that are in pmu_unit_layout.
+_json_layout_attributes = [
+    'pmu', 'desc', 'size', 'fixed_size'
+]
+
 # Attributes that are in pmu_metric rather than pmu_event.
 _json_metric_attributes = [
     'metric_name', 'metric_group', 'metric_expr', 'metric_threshold',
@@ -58,7 +70,9 @@ _json_metric_attributes = [
     'default_metricgroup_name', 'aggr_mode', 'event_grouping'
 ]
 # Attributes that are bools or enum int values, encoded as '0', '1',...
-_json_enum_attributes = ['aggr_mode', 'deprecated', 'event_grouping', 'perpkg']
+_json_enum_attributes = ['aggr_mode', 'deprecated', 'event_grouping', 'perpkg',
+    'size', 'fixed_size'
+]
 
 def removesuffix(s: str, suffix: str) -> str:
   """Remove the suffix from a string
@@ -317,6 +331,9 @@ class JsonEvent:
     if 'Errata' in jd:
       extra_desc += '  Spec update: ' + jd['Errata']
     self.pmu = unit_to_pmu(jd.get('Unit'))
+    self.counter = jd.get('Counter')
+    self.size = jd.get('Size')
+    self.fixed_size = jd.get('FixedSize')
     filter = jd.get('Filter')
     self.unit = jd.get('ScaleUnit')
     self.perpkg = jd.get('PerPkg')
@@ -388,8 +405,16 @@ class JsonEvent:
         s += f'\t{attr} = {value},\n'
     return s + '}'
 
-  def build_c_string(self, metric: bool) -> str:
+  def build_c_string(self, metric: bool, layout: bool = False) -> str:
     s = ''
+    if layout:
+      for attr in _json_layout_attributes:
+        x = getattr(self, attr)
+        if attr in _json_enum_attributes:
+          s += x if x else '0'
+        else:
+          s += f'{x}\\000' if x else '\\000'
+      return s
     for attr in _json_metric_attributes if metric else _json_event_attributes:
       x = getattr(self, attr)
       if metric and x and attr == 'metric_expr':
@@ -404,10 +429,10 @@ class JsonEvent:
         s += f'{x}\\000' if x else '\\000'
     return s
 
-  def to_c_string(self, metric: bool) -> str:
+  def to_c_string(self, metric: bool, layout: bool = False) -> str:
     """Representation of the event as a C struct initializer."""
 
-    s = self.build_c_string(metric)
+    s = self.build_c_string(metric, layout)
     return f'{{ { _bcs.offsets[s] } }}, /* {s} */\n'
 
 
@@ -444,6 +469,8 @@ def preprocess_arch_std_files(archpath: str) -> None:
           _arch_std_events[event.name.lower()] = event
         if event.metric_name:
           _arch_std_events[event.metric_name.lower()] = event
+        if event.size:
+          _arch_std_events[event.pmu.lower()] = event
 
 
 def add_events_table_entries(item: os.DirEntry, topic: str) -> None:
@@ -453,6 +480,8 @@ def add_events_table_entries(item: os.DirEntry, topic: str) -> None:
       _pending_events.append(e)
     if e.metric_name:
       _pending_metrics.append(e)
+    if e.size:
+      _pending_pmu_counts.append(e)
 
 
 def print_pending_events() -> None:
@@ -566,6 +595,33 @@ const struct pmu_table_entry {_pending_metrics_tblname}[] = {{
 """)
   _args.output_file.write('};\n\n')
 
+def print_pending_pmu_counts() -> None:
+
+  def pmu_counts_cmp_key(j: JsonEvent) -> Tuple[bool, str, str]:
+    def fix_none(s: Optional[str]) -> str:
+      if s is None:
+        return ''
+      return s
+
+    return (j.desc is not None, fix_none(j.pmu), fix_none(j.size))
+
+  global _pending_pmu_counts
+  if not _pending_pmu_counts:
+    return
+
+  global _pending_pmu_counts_tblname
+  global pmu_layouts_tables
+  _pmu_layouts_tables.append(_pending_pmu_counts_tblname)
+
+  _args.output_file.write(
+      f'static const struct compact_pmu_event {_pending_pmu_counts_tblname}[] = {{\n')
+
+  for pmu_layout in sorted(_pending_pmu_counts, key=pmu_counts_cmp_key):
+    _args.output_file.write(pmu_layout.to_c_string(metric=False, layout=True))
+    _pending_pmu_counts = []
+
+  _args.output_file.write('};\n\n')
+
 def get_topic(topic: str) -> str:
   if topic.endswith('metrics.json'):
     return 'metrics'
@@ -606,6 +662,8 @@ def preprocess_one_file(parents: Sequence[str], item: os.DirEntry) -> None:
     if event.metric_name:
       _bcs.add(pmu_name, metric=True)
       _bcs.add(event.build_c_string(metric=True), metric=True)
+    if event.size:
+      _bcs.add(event.build_c_string(metric=False, layout=True), metric=False)
 
 def process_one_file(parents: Sequence[str], item: os.DirEntry) -> None:
   """Process a JSON file during the main walk."""
@@ -619,11 +677,14 @@ def process_one_file(parents: Sequence[str], item: os.DirEntry) -> None:
   if item.is_dir() and is_leaf_dir(item.path):
     print_pending_events()
     print_pending_metrics()
+    print_pending_pmu_counts()
 
     global _pending_events_tblname
     _pending_events_tblname = file_name_to_table_name('pmu_events_', parents, item.name)
     global _pending_metrics_tblname
     _pending_metrics_tblname = file_name_to_table_name('pmu_metrics_', parents, item.name)
+    global _pending_pmu_counts_tblname
+    _pending_pmu_counts_tblname = file_name_to_table_name('pmu_layouts_', parents, item.name)
 
     if item.name == 'sys':
       _sys_event_table_to_metric_table_mapping[_pending_events_tblname] = _pending_metrics_tblname
@@ -657,6 +718,12 @@ struct pmu_metrics_table {
         uint32_t num_pmus;
 };
 
+/* Struct used to make the PMU counter layout table implementation opaque to callers. */
+struct pmu_layouts_table {
+        const struct compact_pmu_event *entries;
+        size_t length;
+};
+
 /*
  * Map a CPU to its table of PMU events. The CPU is identified by the
  * cpuid field, which is an arch-specific identifier for the CPU.
@@ -670,6 +737,7 @@ struct pmu_events_map {
         const char *cpuid;
         struct pmu_events_table event_table;
         struct pmu_metrics_table metric_table;
+        struct pmu_layouts_table layout_table;
 };
 
 /*
@@ -714,6 +782,12 @@ const struct pmu_events_map pmu_events_map[] = {
               metric_size = '0'
             if event_size == '0' and metric_size == '0':
               continue
+            layout_tblname = file_name_to_table_name('pmu_layouts_', [], row[2].replace('/', '_'))
+            if layout_tblname in _pmu_layouts_tables:
+              layout_size = f'ARRAY_SIZE({layout_tblname})'
+            else:
+              layout_tblname = 'NULL'
+              layout_size = '0'
             cpuid = row[0].replace('\\', '\\\\')
             _args.output_file.write(f"""{{
 \t.arch = "{arch}",
@@ -725,6 +799,10 @@ const struct pmu_events_map pmu_events_map[] = {
 \t.metric_table = {{
 \t\t.pmus = {metric_tblname},
 \t\t.num_pmus = {metric_size}
+\t}},
+\t.layout_table = {{
+\t\t.entries = {layout_tblname},
+\t\t.length = {layout_size}
 \t}}
 }},
 """)
@@ -735,6 +813,7 @@ const struct pmu_events_map pmu_events_map[] = {
 \t.cpuid = 0,
 \t.event_table = { 0, 0 },
 \t.metric_table = { 0, 0 },
+\t.layout_table = { 0, 0 },
 }
 };
 """)
@@ -823,6 +902,24 @@ static void decompress_metric(int offset, struct pmu_metric *pm)
       _args.output_file.write('\twhile (*p++);')
   _args.output_file.write("""}
 
+static void decompress_layout(int offset, struct pmu_layout *pm)
+{
+\tconst char *p = &big_c_string[offset];
+""")
+  for attr in _json_layout_attributes:
+    _args.output_file.write(f'\n\tpm->{attr} = ')
+    if attr in _json_enum_attributes:
+      _args.output_file.write("*p - '0';\n")
+    else:
+      _args.output_file.write("(*p == '\\0' ? NULL : p);\n")
+    if attr == _json_layout_attributes[-1]:
+      continue
+    if attr in _json_enum_attributes:
+      _args.output_file.write('\tp++;')
+    else:
+      _args.output_file.write('\twhile (*p++);')
+  _args.output_file.write("""}
+
 static int pmu_events_table__for_each_event_pmu(const struct pmu_events_table *table,
                                                 const struct pmu_table_entry *pmu,
                                                 pmu_event_iter_fn fn,
@@ -978,6 +1075,21 @@ int pmu_metrics_table__for_each_metric(const struct pmu_metrics_table *table,
         return 0;
 }
 
+int pmu_layouts_table__for_each_layout(const struct pmu_layouts_table *table,
+                                     pmu_layout_iter_fn fn,
+                                     void *data) {
+        for (size_t i = 0; i < table->length; i++) {
+                struct pmu_layout pm;
+                int ret;
+
+                decompress_layout(table->entries[i].offset, &pm);
+                ret = fn(&pm, data);
+                if (ret)
+                        return ret;
+        }
+        return 0;
+}
+
 static const struct pmu_events_map *map_for_pmu(struct perf_pmu *pmu)
 {
         static struct {
@@ -1073,6 +1185,33 @@ const struct pmu_metrics_table *perf_pmu__find_metrics_table(struct perf_pmu *pm
         return NULL;
 }
 
+const struct pmu_layouts_table *perf_pmu__find_layouts_table(struct perf_pmu *pmu)
+{
+        const struct pmu_layouts_table *table = NULL;
+        char *cpuid = perf_pmu__getcpuid(pmu);
+        int i;
+
+        /* on some platforms which uses cpus map, cpuid can be NULL for
+         * PMUs other than CORE PMUs.
+         */
+        if (!cpuid)
+                return NULL;
+
+        i = 0;
+        for (;;) {
+                const struct pmu_events_map *map = &pmu_events_map[i++];
+                if (!map->arch)
+                        break;
+
+                if (!strcmp_cpuid_str(map->cpuid, cpuid)) {
+                        table = &map->layout_table;
+                        break;
+                }
+        }
+        free(cpuid);
+        return table;
+}
+
 const struct pmu_events_table *find_core_events_table(const char *arch, const char *cpuid)
 {
         for (const struct pmu_events_map *tables = &pmu_events_map[0];
@@ -1094,6 +1233,16 @@ const struct pmu_metrics_table *find_core_metrics_table(const char *arch, const
         }
         return NULL;
 }
+const struct pmu_layouts_table *find_core_layouts_table(const char *arch, const char *cpuid)
+{
+        for (const struct pmu_events_map *tables = &pmu_events_map[0];
+             tables->arch;
+             tables++) {
+                if (!strcmp(tables->arch, arch) && !strcmp_cpuid_str(tables->cpuid, cpuid))
+                        return &tables->layout_table;
+        }
+        return NULL;
+}
 
 int pmu_for_each_core_event(pmu_event_iter_fn fn, void *data)
 {
@@ -1122,6 +1271,19 @@ int pmu_for_each_core_metric(pmu_metric_iter_fn fn, void *data)
         return 0;
 }
 
+int pmu_for_each_core_layout(pmu_layout_iter_fn fn, void *data)
+{
+        for (const struct pmu_events_map *tables = &pmu_events_map[0];
+             tables->arch;
+             tables++) {
+                int ret = pmu_layouts_table__for_each_layout(&tables->layout_table, fn, data);
+
+                if (ret)
+                        return ret;
+        }
+        return 0;
+}
+
 const struct pmu_events_table *find_sys_events_table(const char *name)
 {
         for (const struct pmu_sys_events *tables = &pmu_sys_event_tables[0];
@@ -1278,6 +1440,7 @@ struct pmu_table_entry {
     ftw(arch_path, [], process_one_file)
     print_pending_events()
     print_pending_metrics()
+    print_pending_pmu_counts()
 
   print_mapping_table(archs)
   print_system_mapping_table()
diff --git a/tools/perf/pmu-events/pmu-events.h b/tools/perf/pmu-events/pmu-events.h
index f5aa96f1685c..65e0c5dd8bb4 100644
--- a/tools/perf/pmu-events/pmu-events.h
+++ b/tools/perf/pmu-events/pmu-events.h
@@ -45,6 +45,7 @@ struct pmu_event {
 	const char *desc;
 	const char *topic;
 	const char *long_desc;
+	const char *counter;
 	const char *pmu;
 	const char *unit;
 	bool perpkg;
@@ -67,8 +68,16 @@ struct pmu_metric {
 	enum metric_event_groups event_grouping;
 };
 
+struct pmu_layout {
+	const char *pmu;
+	const char *desc;
+	int size;
+	int fixed_size;
+};
+
 struct pmu_events_table;
 struct pmu_metrics_table;
+struct pmu_layouts_table;
 
 typedef int (*pmu_event_iter_fn)(const struct pmu_event *pe,
 				 const struct pmu_events_table *table,
@@ -78,15 +87,20 @@ typedef int (*pmu_metric_iter_fn)(const struct pmu_metric *pm,
 				  const struct pmu_metrics_table *table,
 				  void *data);
 
+typedef int (*pmu_layout_iter_fn)(const struct pmu_layout *pm,
+				  void *data);
+
 int pmu_events_table__for_each_event(const struct pmu_events_table *table,
 				    struct perf_pmu *pmu,
 				    pmu_event_iter_fn fn,
 				    void *data);
 int pmu_events_table__find_event(const struct pmu_events_table *table,
-                                 struct perf_pmu *pmu,
-                                 const char *name,
-                                 pmu_event_iter_fn fn,
-				 void *data);
+				struct perf_pmu *pmu,
+				const char *name,
+				pmu_event_iter_fn fn,
+				void *data);
+int pmu_layouts_table__for_each_layout(const struct pmu_layouts_table *table, pmu_layout_iter_fn fn,
+				     void *data);
 size_t pmu_events_table__num_events(const struct pmu_events_table *table,
 				    struct perf_pmu *pmu);
 
@@ -95,10 +109,13 @@ int pmu_metrics_table__for_each_metric(const struct pmu_metrics_table *table, pm
 
 const struct pmu_events_table *perf_pmu__find_events_table(struct perf_pmu *pmu);
 const struct pmu_metrics_table *perf_pmu__find_metrics_table(struct perf_pmu *pmu);
+const struct pmu_layouts_table *perf_pmu__find_layouts_table(struct perf_pmu *pmu);
 const struct pmu_events_table *find_core_events_table(const char *arch, const char *cpuid);
 const struct pmu_metrics_table *find_core_metrics_table(const char *arch, const char *cpuid);
+const struct pmu_layouts_table *find_core_layouts_table(const char *arch, const char *cpuid);
 int pmu_for_each_core_event(pmu_event_iter_fn fn, void *data);
 int pmu_for_each_core_metric(pmu_metric_iter_fn fn, void *data);
+int pmu_for_each_core_layout(pmu_layout_iter_fn fn, void *data);
 
 const struct pmu_events_table *find_sys_events_table(const char *name);
 const struct pmu_metrics_table *find_sys_metrics_table(const char *name);
-- 
2.34.1



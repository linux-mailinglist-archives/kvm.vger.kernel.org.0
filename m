Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 151BC42075
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437226AbfFLJPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:15:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18559 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436777AbfFLJPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:15:01 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 06646C5C9D43BF77E6DD;
        Wed, 12 Jun 2019 17:11:56 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 12 Jun 2019 17:11:46 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC:     <christoffer.dall@arm.com>, <marc.zyngier@arm.com>,
        <acme@redhat.com>, <peterz@infradead.org>, <mingo@redhat.com>,
        <ganapatrao.kulkarni@cavium.com>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <mark.rutland@arm.com>, <acme@kernel.org>,
        <alexander.shishkin@linux.intel.com>, <jolsa@redhat.com>,
        <namhyung@kernel.org>, <wanghaibin.wang@huawei.com>,
        <xiexiangyou@huawei.com>, <linuxarm@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v1 3/5] perf tools arm64: Add support for get_cpuid() function
Date:   Wed, 12 Jun 2019 09:08:44 +0000
Message-ID: <1560330526-15468-4-git-send-email-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
In-Reply-To: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The get_cpuid() function returns the MIDR string of the first CPU.

Cc: Ganapatrao Kulkarni <ganapatrao.kulkarni@cavium.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

---
When recording, perf will write host's cpuid (through get_cpuid()) into
perf.data.guest file:

  __cmd_record
    record__finish_output
      perf_session__write_header
        perf_header__adds_write
          do_write_feat (type == HEADER_CPUID)
            write_cpuid

When reporting, perf will read cpuid from perf.data.guest file:

  read_events
    perf_session__new
      perf_session__open
        perf_session__read_header
          perf_header__process_sections
            perf_file_section__process
              process_cpuid

I'm not familiar with ARM ID register usage, and how does perf code make
use of get_cpuid() function. If we left get_cpuid() unimplemented on
arm64 (we have a default implementation in tools/perf/util/header.c),
'perf kvm stat report' will failed with following error:
        "Failed to look up CPU type"

I will read the code further, and any comments or suggestions from both
sides (arm64 & perf) will be appreciated.

---
 tools/perf/arch/arm64/util/header.c | 74 +++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/tools/perf/arch/arm64/util/header.c b/tools/perf/arch/arm64/util/header.c
index 534cd25..5c17b86 100644
--- a/tools/perf/arch/arm64/util/header.c
+++ b/tools/perf/arch/arm64/util/header.c
@@ -9,17 +9,56 @@
 #define MIDR_VARIANT_SHIFT      20
 #define MIDR_VARIANT_MASK       (0xf << MIDR_VARIANT_SHIFT)
 
-char *get_cpuid_str(struct perf_pmu *pmu)
+/* Return value of midr_el1 if success, else return 0. */
+static int read_midr_el1(char *buf, int cpu_nr)
 {
-	char *buf = NULL;
 	char path[PATH_MAX];
 	const char *sysfs = sysfs__mountpoint();
+	u64 midr = 0;
+	FILE *file;
+
+	if (!sysfs)
+		return 0;
+
+	scnprintf(path, PATH_MAX, "%s/devices/system/cpu/cpu%d"MIDR,
+		  sysfs, cpu_nr);
+
+	file = fopen(path, "r");
+	if (!file) {
+		pr_debug("fopen failed for file %s\n", path);
+		return 0;
+	}
+
+	if (!fgets(buf, MIDR_SIZE, file)) {
+		fclose(file);
+		return 0;
+	}
+	fclose(file);
+
+	/* Ignore/clear Variant[23:20] and Revision[3:0] of MIDR */
+	midr = strtoul(buf, NULL, 16);
+	midr &= (~(MIDR_VARIANT_MASK | MIDR_REVISION_MASK));
+	scnprintf(buf, MIDR_SIZE, "0x%016lx", midr);
+
+	return midr;
+}
+
+int get_cpuid(char *buffer, size_t sz __maybe_unused)
+{
+	if (read_midr_el1(buffer, 0))
+		return 0;
+
+	return -1;
+}
+
+char *get_cpuid_str(struct perf_pmu *pmu)
+{
+	char *buf = NULL;
 	int cpu;
 	u64 midr = 0;
 	struct cpu_map *cpus;
-	FILE *file;
 
-	if (!sysfs || !pmu || !pmu->cpus)
+	if (!pmu || !pmu->cpus)
 		return NULL;
 
 	buf = malloc(MIDR_SIZE);
@@ -29,29 +68,10 @@ char *get_cpuid_str(struct perf_pmu *pmu)
 	/* read midr from list of cpus mapped to this pmu */
 	cpus = cpu_map__get(pmu->cpus);
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		scnprintf(path, PATH_MAX, "%s/devices/system/cpu/cpu%d"MIDR,
-				sysfs, cpus->map[cpu]);
-
-		file = fopen(path, "r");
-		if (!file) {
-			pr_debug("fopen failed for file %s\n", path);
-			continue;
-		}
-
-		if (!fgets(buf, MIDR_SIZE, file)) {
-			fclose(file);
-			continue;
-		}
-		fclose(file);
-
-		/* Ignore/clear Variant[23:20] and
-		 * Revision[3:0] of MIDR
-		 */
-		midr = strtoul(buf, NULL, 16);
-		midr &= (~(MIDR_VARIANT_MASK | MIDR_REVISION_MASK));
-		scnprintf(buf, MIDR_SIZE, "0x%016lx", midr);
-		/* got midr break loop */
-		break;
+		midr = read_midr_el1(buf, cpus->map[cpu]);
+		if (midr)
+			/* got midr break loop */
+			break;
 	}
 
 	if (!midr) {
-- 
1.8.3.1



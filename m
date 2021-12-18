Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81599479CF0
	for <lists+kvm@lfdr.de>; Sat, 18 Dec 2021 22:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhLRVUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Dec 2021 16:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbhLRVUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 16:20:32 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4728EC06173F;
        Sat, 18 Dec 2021 13:20:31 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso7423479otj.11;
        Sat, 18 Dec 2021 13:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QgmvA9Ca2Chm8PCMZATSSpDkFlZwbTnbTlrFcY7ik6k=;
        b=C6vpc1qHIlffelpAYhVIzPenpQcK4OvQdMP2z0Z7Xz1W2JTAv6om7WemWk5/xTc99M
         NbaFuWxCB7RbpOjrMn32iklxGV5pUBXdj7ub6yez7jkOdvFsccE55nkyxFP/A4OLL3Cl
         toEcZGvDV8S1XGi3pPE/98EFxJrC1lvtrMZhyFt3tCynjAyB5HpXb39mkL5gl3Gz+TkC
         XzXzMiUEbVdotX7Ji6U21Z5kXDjcXwN7PlLV8EXH6g97HT30uFqfXCMRMb5PNWJLK0Qt
         G3X7xJCte3xUnIB8/2sbk/ma7JuYfigSDZEO0jYlETC51U7Qv/eLbyNCWrbYfXiH4NiP
         +fmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QgmvA9Ca2Chm8PCMZATSSpDkFlZwbTnbTlrFcY7ik6k=;
        b=mMRBNitCj9MX81Wn+eJ/o25Y4fTR2V5hYBAFHdS9/XT/ovsqCV5BDHR6Rq0Qlt5qmo
         TSZUtmvCVAzC4tnAsP4HWw/5Mk3hcZVQxLFILjGXGq5wKeHRVIat0r997Ss/K+HN6pV2
         WoW8B3H00EXJoW7sZl+ctZP9H6VJjiOsGNp5nMW/bxuhF2pweVqfoWJfEUPq9MV6X7Bp
         UmwHrBvh2/DlPI1iMKuCpwKo6sdtdgFrlJ17WASFRf0RLcNTKJ2dEI0Cs0mVXSJr9/Qy
         eEE0jhmL6XYyWI8NJTREAuBhY6/l0EvDVYr0n3pZmbl9LHHdXZfq9d32tEtOAxox1r4k
         A5OA==
X-Gm-Message-State: AOAM531VSSrmToot5jpnm8YtUBzR99oc6hqIDlX1IrGJtY5fN5sLkfto
        OKh5LNYMKnJAt4ZuVZyg+k2lrrhASAopZg==
X-Google-Smtp-Source: ABdhPJwaw7u3t5/+MQbjC6RuQMCTdkUtGmD/cEHDRk9w0P88I9M7sE6/X3ZHPxaQbcc8tqQ4RIkdtw==
X-Received: by 2002:a9d:7459:: with SMTP id p25mr6379946otk.247.1639862430321;
        Sat, 18 Dec 2021 13:20:30 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id o11sm2484738oiv.10.2021.12.18.13.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 13:20:30 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Klimov <aklimov@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Andy Shevchenko <andy@infradead.org>,
        Anup Patel <anup.patel@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        David Laight <David.Laight@ACULAB.COM>,
        Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jens Axboe <axboe@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Perches <joe@perches.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lee Jones <lee.jones@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Mark Gross <markgross@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>, Tejun Heo <tj@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 04/17] all: replace bitmap_weight with bitmap_empty where appropriate
Date:   Sat, 18 Dec 2021 13:20:00 -0800
Message-Id: <20211218212014.1315894-5-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211218212014.1315894-1-yury.norov@gmail.com>
References: <20211218212014.1315894-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In many cases, kernel code calls bitmap_weight() to check if any bit of
a given bitmap is set. It's better to use bitmap_empty() in that case
because bitmap_empty() stops traversing the bitmap as soon as it finds
first set bit, while bitmap_weight() counts all bits unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/nds32/kernel/perf_event_cpu.c                      | 2 +-
 arch/x86/kvm/hyperv.c                                   | 8 ++++----
 drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c                | 2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c        | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c    | 2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c              | 4 ++--
 drivers/net/ethernet/qlogic/qed/qed_roce.c              | 2 +-
 drivers/perf/arm-cci.c                                  | 2 +-
 drivers/perf/arm_pmu.c                                  | 4 ++--
 drivers/perf/hisilicon/hisi_uncore_pmu.c                | 2 +-
 drivers/perf/xgene_pmu.c                                | 2 +-
 tools/perf/builtin-c2c.c                                | 4 ++--
 13 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/nds32/kernel/perf_event_cpu.c b/arch/nds32/kernel/perf_event_cpu.c
index a78a879e7ef1..ea44e9ecb5c7 100644
--- a/arch/nds32/kernel/perf_event_cpu.c
+++ b/arch/nds32/kernel/perf_event_cpu.c
@@ -695,7 +695,7 @@ static void nds32_pmu_enable(struct pmu *pmu)
 {
 	struct nds32_pmu *nds32_pmu = to_nds32_pmu(pmu);
 	struct pmu_hw_events *hw_events = nds32_pmu->get_hw_events();
-	int enabled = bitmap_weight(hw_events->used_mask,
+	bool enabled = !bitmap_empty(hw_events->used_mask,
 				    nds32_pmu->num_events);
 
 	if (enabled)
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6e38a7d22e97..2c3400dea4b3 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -90,7 +90,7 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 {
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
 	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
-	int auto_eoi_old, auto_eoi_new;
+	bool auto_eoi_old, auto_eoi_new;
 
 	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
 		return;
@@ -100,16 +100,16 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	else
 		__clear_bit(vector, synic->vec_bitmap);
 
-	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
+	auto_eoi_old = bitmap_empty(synic->auto_eoi_bitmap, 256);
 
 	if (synic_has_vector_auto_eoi(synic, vector))
 		__set_bit(vector, synic->auto_eoi_bitmap);
 	else
 		__clear_bit(vector, synic->auto_eoi_bitmap);
 
-	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
+	auto_eoi_new = bitmap_empty(synic->auto_eoi_bitmap, 256);
 
-	if (!!auto_eoi_old == !!auto_eoi_new)
+	if (auto_eoi_old == auto_eoi_new)
 		return;
 
 	down_write(&vcpu->kvm->arch.apicv_update_lock);
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
index d7fa2c49e741..56a3063545ec 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
@@ -68,7 +68,7 @@ static int smp_request_block(struct mdp5_smp *smp,
 	uint8_t reserved;
 
 	/* we shouldn't be requesting blocks for an in-use client: */
-	WARN_ON(bitmap_weight(cs, cnt) > 0);
+	WARN_ON(!bitmap_empty(cs, cnt));
 
 	reserved = smp->reserved[cid];
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 61b2db3342ed..ac0fe04df2e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -267,8 +267,8 @@ ice_set_pfe_link(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
  */
 static bool ice_vf_has_no_qs_ena(struct ice_vf *vf)
 {
-	return (!bitmap_weight(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF) &&
-		!bitmap_weight(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF));
+	return (bitmap_empty(vf->rxq_ena, ICE_MAX_RSS_QS_PER_VF) &&
+		bitmap_empty(vf->txq_ena, ICE_MAX_RSS_QS_PER_VF));
 }
 
 /**
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 77a13fb555fb..80b2d64b4136 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -353,7 +353,7 @@ int otx2_add_macfilter(struct net_device *netdev, const u8 *mac)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 
-	if (bitmap_weight(&pf->flow_cfg->dmacflt_bmap,
+	if (!bitmap_empty(&pf->flow_cfg->dmacflt_bmap,
 			  pf->flow_cfg->dmacflt_max_flows))
 		netdev_warn(netdev,
 			    "Add %pM to CGX/RPM DMAC filters list as well\n",
@@ -436,7 +436,7 @@ int otx2_get_maxflows(struct otx2_flow_config *flow_cfg)
 		return 0;
 
 	if (flow_cfg->nr_flows == flow_cfg->max_flows ||
-	    bitmap_weight(&flow_cfg->dmacflt_bmap,
+	    !bitmap_empty(&flow_cfg->dmacflt_bmap,
 			  flow_cfg->dmacflt_max_flows))
 		return flow_cfg->max_flows + flow_cfg->dmacflt_max_flows;
 	else
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 6080ebd9bd94..3d369ccc7ab9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1115,7 +1115,7 @@ static int otx2_cgx_config_loopback(struct otx2_nic *pf, bool enable)
 	struct msg_req *msg;
 	int err;
 
-	if (enable && bitmap_weight(&pf->flow_cfg->dmacflt_bmap,
+	if (enable && !bitmap_empty(&pf->flow_cfg->dmacflt_bmap,
 				    pf->flow_cfg->dmacflt_max_flows))
 		netdev_warn(pf->netdev,
 			    "CGX/RPM internal loopback might not work as DMAC filters are active\n");
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 23b668de4640..b6e2e17bac04 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -336,7 +336,7 @@ void qed_rdma_bmap_free(struct qed_hwfn *p_hwfn,
 
 	/* print aligned non-zero lines, if any */
 	for (item = 0, line = 0; line < last_line; line++, item += 8)
-		if (bitmap_weight((unsigned long *)&pmap[item], 64 * 8))
+		if (!bitmap_empty((unsigned long *)&pmap[item], 64 * 8))
 			DP_NOTICE(p_hwfn,
 				  "line 0x%04x: 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx\n",
 				  line,
@@ -350,7 +350,7 @@ void qed_rdma_bmap_free(struct qed_hwfn *p_hwfn,
 
 	/* print last unaligned non-zero line, if any */
 	if ((bmap->max_count % (64 * 8)) &&
-	    (bitmap_weight((unsigned long *)&pmap[item],
+	    (!bitmap_empty((unsigned long *)&pmap[item],
 			   bmap->max_count - item * 64))) {
 		offset = sprintf(str_last_line, "line 0x%04x: ", line);
 		for (; item < last_item; item++)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 071b4aeaddf2..134ecfca96a3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -76,7 +76,7 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
 	 * We delay for a short while if an async destroy QP is still expected.
 	 * Beyond the added delay we clear the bitmap anyway.
 	 */
-	while (bitmap_weight(rcid_map->bitmap, rcid_map->max_count)) {
+	while (!bitmap_empty(rcid_map->bitmap, rcid_map->max_count)) {
 		/* If the HW device is during recovery, all resources are
 		 * immediately reset without receiving a per-cid indication
 		 * from HW. In this case we don't expect the cid bitmap to be
diff --git a/drivers/perf/arm-cci.c b/drivers/perf/arm-cci.c
index 54aca3a62814..96e09fa40909 100644
--- a/drivers/perf/arm-cci.c
+++ b/drivers/perf/arm-cci.c
@@ -1096,7 +1096,7 @@ static void cci_pmu_enable(struct pmu *pmu)
 {
 	struct cci_pmu *cci_pmu = to_cci_pmu(pmu);
 	struct cci_pmu_hw_events *hw_events = &cci_pmu->hw_events;
-	int enabled = bitmap_weight(hw_events->used_mask, cci_pmu->num_cntrs);
+	bool enabled = !bitmap_empty(hw_events->used_mask, cci_pmu->num_cntrs);
 	unsigned long flags;
 
 	if (!enabled)
diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 295cc7952d0e..a31b302b0ade 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -524,7 +524,7 @@ static void armpmu_enable(struct pmu *pmu)
 {
 	struct arm_pmu *armpmu = to_arm_pmu(pmu);
 	struct pmu_hw_events *hw_events = this_cpu_ptr(armpmu->hw_events);
-	int enabled = bitmap_weight(hw_events->used_mask, armpmu->num_events);
+	bool enabled = !bitmap_empty(hw_events->used_mask, armpmu->num_events);
 
 	/* For task-bound events we may be called on other CPUs */
 	if (!cpumask_test_cpu(smp_processor_id(), &armpmu->supported_cpus))
@@ -785,7 +785,7 @@ static int cpu_pm_pmu_notify(struct notifier_block *b, unsigned long cmd,
 {
 	struct arm_pmu *armpmu = container_of(b, struct arm_pmu, cpu_pm_nb);
 	struct pmu_hw_events *hw_events = this_cpu_ptr(armpmu->hw_events);
-	int enabled = bitmap_weight(hw_events->used_mask, armpmu->num_events);
+	bool enabled = !bitmap_empty(hw_events->used_mask, armpmu->num_events);
 
 	if (!cpumask_test_cpu(smp_processor_id(), &armpmu->supported_cpus))
 		return NOTIFY_DONE;
diff --git a/drivers/perf/hisilicon/hisi_uncore_pmu.c b/drivers/perf/hisilicon/hisi_uncore_pmu.c
index a738aeab5c04..358e4e284a62 100644
--- a/drivers/perf/hisilicon/hisi_uncore_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_pmu.c
@@ -393,7 +393,7 @@ EXPORT_SYMBOL_GPL(hisi_uncore_pmu_read);
 void hisi_uncore_pmu_enable(struct pmu *pmu)
 {
 	struct hisi_pmu *hisi_pmu = to_hisi_pmu(pmu);
-	int enabled = bitmap_weight(hisi_pmu->pmu_events.used_mask,
+	bool enabled = !bitmap_empty(hisi_pmu->pmu_events.used_mask,
 				    hisi_pmu->num_counters);
 
 	if (!enabled)
diff --git a/drivers/perf/xgene_pmu.c b/drivers/perf/xgene_pmu.c
index 2b6d476bd213..88bd100a9633 100644
--- a/drivers/perf/xgene_pmu.c
+++ b/drivers/perf/xgene_pmu.c
@@ -867,7 +867,7 @@ static void xgene_perf_pmu_enable(struct pmu *pmu)
 {
 	struct xgene_pmu_dev *pmu_dev = to_pmu_dev(pmu);
 	struct xgene_pmu *xgene_pmu = pmu_dev->parent;
-	int enabled = bitmap_weight(pmu_dev->cntr_assign_mask,
+	bool enabled = !bitmap_empty(pmu_dev->cntr_assign_mask,
 			pmu_dev->max_counters);
 
 	if (!enabled)
diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index b5c67ef73862..51997386fb31 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -1080,7 +1080,7 @@ node_entry(struct perf_hpp_fmt *fmt __maybe_unused, struct perf_hpp *hpp,
 		bitmap_zero(set, c2c.cpus_cnt);
 		bitmap_and(set, c2c_he->cpuset, c2c.nodes[node], c2c.cpus_cnt);
 
-		if (!bitmap_weight(set, c2c.cpus_cnt)) {
+		if (bitmap_empty(set, c2c.cpus_cnt)) {
 			if (c2c.node_info == 1) {
 				ret = scnprintf(hpp->buf, hpp->size, "%21s", " ");
 				advance_hpp(hpp, ret);
@@ -1944,7 +1944,7 @@ static int set_nodestr(struct c2c_hist_entry *c2c_he)
 	if (c2c_he->nodestr)
 		return 0;
 
-	if (bitmap_weight(c2c_he->nodeset, c2c.nodes_cnt)) {
+	if (!bitmap_empty(c2c_he->nodeset, c2c.nodes_cnt)) {
 		len = bitmap_scnprintf(c2c_he->nodeset, c2c.nodes_cnt,
 				      buf, sizeof(buf));
 	} else {
-- 
2.30.2


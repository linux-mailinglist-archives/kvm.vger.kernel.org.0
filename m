Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B466B55F0E5
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 00:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiF1WJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 18:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiF1WJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 18:09:46 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844CB344FC
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:09:45 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a71-20020a621a4a000000b005259104d9b2so3641869pfa.3
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 15:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ar/TwF8lq5bFbqZHf9pZvB65YclrhW3IS7sSA1BsQDg=;
        b=pfL22Ng6pzLvqLLBP98qcLfLr68c9UrDTPsuK4SmENqAoH54ekraevxSvAT3Zr2dW4
         8PWtU6KCm2/b8+SVQwc/NjsVuC1N2XRKJPd60HT9TVPAZjlrs5v7NCcCf1SdeIAtOxvn
         Wq4mJs8oRc3S6U/OGFELy/aucVizKhgd2vVUXuoHHaej4XL+gd+0uHk751t5VnPdwPDr
         MTUza4pM4XE/qPXrA/kAlTNHBkzAuPyhewKLo9FVbRFy7fiyRMDtwoBknb53Dnsufu1l
         cB/nwVstbR5Ct9kLsuYh83++YNOAy/uslrdkr313avX3kPT7zmts40/8kHi/gWEGYCB4
         dJ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ar/TwF8lq5bFbqZHf9pZvB65YclrhW3IS7sSA1BsQDg=;
        b=gT2N8jyCWKXrrcFPoRjE++DRTJhcfcsYi5sKuqFtb7DfMS60/mJma0FRudAH6I+zUC
         Y0dAIKYXhGvTtLa34fCIMKWndmK5iElx8+4DHrsyGdlGhGUh3+zZ9JPruJ6p/EBp5f0A
         NeigWX7w4sDZcPNPSnyVarRfUy72J4VL/vEtBIB9OCTMGlejkXeUjSg2zYzUryRYHO78
         NOELtRoS28btBcJz496Y/rKDbuKoparuc5YvaOoDrEu0sIzbmJZu5vNgiqbVqFdt1gea
         WQ8GCxSz3jyrckF/XXOiGwdM0S5aISoq2OqCy2jOAs6zwl3Ba8pTpoDf84boyYfY5v6q
         qLow==
X-Gm-Message-State: AJIora+2LaZQVPRpbsjDRcTaQ24W2mtvQoic32fM6PmnKjgVYuN1oH8C
        vp62IG4nBFcI3k02DZ6SQ9mKYnlftn0ZemR4
X-Google-Smtp-Source: AGRyM1vkRcRJ1tlgIcIQka52LZiOjuQOq+sfYK/G902mhBRAIiM7J/rour3nZbiO5D1W8ZLMVYOcRzoGp2iOTMLH
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:902:e808:b0:16a:75be:2ba with SMTP
 id u8-20020a170902e80800b0016a75be02bamr7025411plg.85.1656454184962; Tue, 28
 Jun 2022 15:09:44 -0700 (PDT)
Date:   Tue, 28 Jun 2022 22:09:35 +0000
In-Reply-To: <20220628220938.3657876-1-yosryahmed@google.com>
Message-Id: <20220628220938.3657876-2-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220628220938.3657876-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary page
 table uses.
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     Huang@google.com, Shaoqin <shaoqin.huang@intel.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We keep track of several kernel memory stats (total kernel memory, page
tables, stack, vmalloc, etc) on multiple levels (global, per-node,
per-memcg, etc). These stats give insights to users to how much memory
is used by the kernel and for what purposes.

Currently, memory used by kvm mmu is not accounted in any of those
kernel memory stats. This patch series accounts the memory pages
used by KVM for page tables in those stats in a new
NR_SECONDARY_PAGETABLE stat. This stat can be later extended to account
for other types of secondary pages tables (e.g. iommu page tables).

KVM has a decent number of large allocations that aren't for page
tables, but for most of them, the number/size of those allocations
scales linearly with either the number of vCPUs or the amount of memory
assigned to the VM. KVM's secondary page table allocations do not scale
linearly, especially when nested virtualization is in use.

From a KVM perspective, NR_SECONDARY_PAGETABLE will scale with KVM's
per-VM pages_{4k,2m,1g} stats unless the guest is doing something
bizarre (e.g. accessing only 4kb chunks of 2mb pages so that KVM is
forced to allocate a large number of page tables even though the guest
isn't accessing that much memory). However, someone would need to either
understand how KVM works to make that connection, or know (or be told) to
go look at KVM's stats if they're running VMs to better decipher the stats.

Furthermore, having NR_PAGETABLE side-by-side with NR_SECONDARY_PAGETABLE
is informative. For example, when backing a VM with THP vs. HugeTLB,
NR_SECONDARY_PAGETABLE is roughly the same, but NR_PAGETABLE is an order
of magnitude higher with THP. So having this stat will at the very least
prove to be useful for understanding tradeoffs between VM backing types,
and likely even steer folks towards potential optimizations.

The original discussion with more details about the rationale:
https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org

This stat will be used by subsequent patches to count KVM mmu
memory usage.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 5 +++++
 Documentation/filesystems/proc.rst      | 4 ++++
 drivers/base/node.c                     | 2 ++
 fs/proc/meminfo.c                       | 2 ++
 include/linux/mmzone.h                  | 1 +
 mm/memcontrol.c                         | 1 +
 mm/page_alloc.c                         | 6 +++++-
 mm/vmstat.c                             | 1 +
 8 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 176298f2f4def..e06db032bdbf3 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1340,6 +1340,11 @@ PAGE_SIZE multiple when read back.
 	  pagetables
                 Amount of memory allocated for page tables.
 
+	  sec_pagetables
+		Amount of memory allocated for secondary page tables,
+		this currently includes KVM mmu allocations on x86
+		and arm64.
+
 	  percpu (npn)
 		Amount of memory used for storing per-cpu kernel
 		data structures.
diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 1bc91fb8c321a..aa2a05b585772 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -977,6 +977,7 @@ Example output. You may not have all of these fields.
     SUnreclaim:       142336 kB
     KernelStack:       11168 kB
     PageTables:        20540 kB
+    SecPageTables:         0 kB
     NFS_Unstable:          0 kB
     Bounce:                0 kB
     WritebackTmp:          0 kB
@@ -1085,6 +1086,9 @@ KernelStack
               Memory consumed by the kernel stacks of all tasks
 PageTables
               Memory consumed by userspace page tables
+SecPageTables
+              Memory consumed by secondary page tables, this currently
+	      currently includes KVM mmu allocations on x86 and arm64.
 NFS_Unstable
               Always zero. Previous counted pages which had been written to
               the server, but has not been committed to stable storage.
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 0ac6376ef7a10..5ad56a0cd5937 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -433,6 +433,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     "Node %d ShadowCallStack:%8lu kB\n"
 #endif
 			     "Node %d PageTables:     %8lu kB\n"
+			     "Node %d SecPageTables:  %8lu kB\n"
 			     "Node %d NFS_Unstable:   %8lu kB\n"
 			     "Node %d Bounce:         %8lu kB\n"
 			     "Node %d WritebackTmp:   %8lu kB\n"
@@ -459,6 +460,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     nid, node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
 			     nid, K(node_page_state(pgdat, NR_PAGETABLE)),
+			     nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 			     nid, 0UL,
 			     nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
 			     nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 6e89f0e2fd20f..208efd4fa52c7 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -115,6 +115,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #endif
 	show_val_kb(m, "PageTables:     ",
 		    global_node_page_state(NR_PAGETABLE));
+	show_val_kb(m, "SecPageTables:	",
+		    global_node_page_state(NR_SECONDARY_PAGETABLE));
 
 	show_val_kb(m, "NFS_Unstable:   ", 0);
 	show_val_kb(m, "Bounce:         ",
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index aab70355d64f3..13190d298c986 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -216,6 +216,7 @@ enum node_stat_item {
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
 #endif
 	NR_PAGETABLE,		/* used for pagetables */
+	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index abec50f31fe64..d8178395215d4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1394,6 +1394,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "kernel",			MEMCG_KMEM			},
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
+	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
 	{ "vmalloc",			MEMCG_VMALLOC			},
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e008a3df0485c..41ba8942ccee6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5950,7 +5950,8 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
 		" unevictable:%lu dirty:%lu writeback:%lu\n"
 		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
-		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+		" mapped:%lu shmem:%lu pagetables:%lu\n"
+		" sec_pagetables:%lu bounce:%lu\n"
 		" kernel_misc_reclaimable:%lu\n"
 		" free:%lu free_pcp:%lu free_cma:%lu\n",
 		global_node_page_state(NR_ACTIVE_ANON),
@@ -5967,6 +5968,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 		global_node_page_state(NR_FILE_MAPPED),
 		global_node_page_state(NR_SHMEM),
 		global_node_page_state(NR_PAGETABLE),
+		global_node_page_state(NR_SECONDARY_PAGETABLE),
 		global_zone_page_state(NR_BOUNCE),
 		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
 		global_zone_page_state(NR_FREE_PAGES),
@@ -6000,6 +6002,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			" shadow_call_stack:%lukB"
 #endif
 			" pagetables:%lukB"
+			" sec_pagetables:%lukB"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -6025,6 +6028,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			node_page_state(pgdat, NR_KERNEL_SCS_KB),
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
+			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
 				"yes" : "no");
 	}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 373d2730fcf21..b937eba681d15 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1240,6 +1240,7 @@ const char * const vmstat_text[] = {
 	"nr_shadow_call_stack",
 #endif
 	"nr_page_table_pages",
+	"nr_sec_page_table_pages",
 #ifdef CONFIG_SWAP
 	"nr_swapcached",
 #endif
-- 
2.37.0.rc0.161.g10f37bed90-goog


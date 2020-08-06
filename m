Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FDC23D47A
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgHFAPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgHFAOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:14:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2286EC0617A5
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 17:14:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v11so51393597ybm.22
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 17:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LfxCPN/4iZPLCZVOVhzdLvyoPvK+axLJbpywb7N3FLc=;
        b=L9FfO0hW7Uu2iVdQvQ/ixa/M4r537CjMlQgMCGXcJ/u6Nu3MLyY86tPRNY5fK2GcDz
         qc4qeFfnS+1YeBs8bIYjcoTBwh4od41NTE8rJi3+xesXOL+ZGTXuJrWz2h5d+Ea8Bx3Y
         3sacGsHAoc+7ZGqNXypsjdaLmioVWtipZe1grKepqd2yzT2r2g5rj/KN7lZkCRhY7xTV
         qaorXEjcJ+EH6zKdt1ftiE/f7nI1Lxo0vog+SeSMhSGB0bSpC3zABgDSpErmpyhiOb9R
         5xCVXLZTEpSgKPIQBJTz6l+kAQ4N4/FXW8ZqISkOmc8HNzo6UN/K68UAKYTuNrR58gAH
         /HmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LfxCPN/4iZPLCZVOVhzdLvyoPvK+axLJbpywb7N3FLc=;
        b=XpBaGNeRVrtahDUTFp6RMCUkRNqlMSW8LkFfU8M+zN1VzoAjdheLjtokNU5A+n3lvT
         GVGq6JIu2vh0Xa39YuQb0LJoe+iNyk31UtGnePL7ouQnM8QwoSchCjCHAWOrpnB/vQcO
         UR/ntJ35gPAz5i2Ha6iLLXltASOfXwE9ara/w3GaqCj77hzk/MXYdeSPDwnZcK/VghmI
         dsYKK8ndOO5UyLJPw4lGQV6rz7skyw25ZTn9jHC3HdblztnPeQN3HX9HMXH5FWtwBFeI
         7rnTs9j64mFe2hvhOgqgXI+2zrstVsFRIXESfw18HU3gdVMAgrwSNvVOM6//4By5ghTo
         h4Lw==
X-Gm-Message-State: AOAM5305zX21GQ+oCmNOIUW/tbj+zAI7JWD14QkpHsBcQIjkaK4neM04
        Th/eJ3POy77fOI0VeIBU26pglf5ouxA=
X-Google-Smtp-Source: ABdhPJyu0aNph15yIZ+H/ugTV4JnQHqAHPHlkEdCVyBRPkoEJwwD4Okkl9Q9vffa6zM20bniVOuBywuwIAc5
X-Received: by 2002:a25:bbd2:: with SMTP id c18mr8387526ybk.495.1596672891370;
 Wed, 05 Aug 2020 17:14:51 -0700 (PDT)
Date:   Wed,  5 Aug 2020 17:14:31 -0700
In-Reply-To: <20200806001431.2072150-1-jwadams@google.com>
Message-Id: <20200806001431.2072150-8-jwadams@google.com>
Mime-Version: 1.0
References: <20200806001431.2072150-1-jwadams@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 7/7] net-metricfs: Export /proc/net/dev via metricfs.
From:   Jonathan Adams <jwadams@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>,
        Laurent Chavey <chavey@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Laurent Chavey <chavey@google.com>

Export /proc/net/dev statistics via metricfs.

The implementation reports all the devices that are in the same
network namespace as the process reading metricfs.

The implementation does not report devices across network namespaces

Signed-off-by: Laurent Chavey <chavey@google.com>
[jwadams@google.com: ported code to 5.8-pre6, cleaned up googleisms ]
Signed-off-by: Jonathan Adams <jwadams@google.com>
---
 net/core/Makefile       |   1 +
 net/core/net_metricfs.c | 194 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+)
 create mode 100644 net/core/net_metricfs.c

diff --git a/net/core/Makefile b/net/core/Makefile
index 3e2c378e5f31..7647380b9679 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_NET_PTP_CLASSIFY) += ptp_classifier.o
 obj-$(CONFIG_CGROUP_NET_PRIO) += netprio_cgroup.o
 obj-$(CONFIG_CGROUP_NET_CLASSID) += netclassid_cgroup.o
 obj-$(CONFIG_LWTUNNEL) += lwtunnel.o
+obj-$(CONFIG_METRICFS) += net_metricfs.o
 obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
 obj-$(CONFIG_BPF_STREAM_PARSER) += sock_map.o
 obj-$(CONFIG_DST_CACHE) += dst_cache.o
diff --git a/net/core/net_metricfs.c b/net/core/net_metricfs.c
new file mode 100644
index 000000000000..82f0f797b0b0
--- /dev/null
+++ b/net/core/net_metricfs.c
@@ -0,0 +1,194 @@
+// SPDX-License-Identifier: GPL-2.0
+/* net_metricfs: Exports network counters using metricfs.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/metricfs.h>
+#include <linux/netdevice.h>
+#include <linux/nsproxy.h>
+#include <linux/rcupdate.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+#include <net/net_namespace.h>
+
+struct metric_def {
+	struct metric *metric;
+	size_t off;
+	char *name;
+	char *desc;
+};
+
+/* If needed, we could export this via a function for other /net users */
+static struct metricfs_subsys *net_root_subsys;
+static struct metricfs_subsys *dev_subsys;
+static struct metricfs_subsys *dev_stats_subsys;
+
+static struct metric_def metric_def[] = {
+	{NULL, offsetof(struct rtnl_link_stats64, rx_bytes),
+	 "rx_bytes", "net device received bytes count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_packets),
+	 "rx_packets", "net device received packets count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_errors),
+	 "rx_errors", "net device received errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_dropped),
+	 "rx_dropped", "net device dropped packets count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_missed_errors),
+	 "rx_missed_errors",  "net device missed errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_fifo_errors),
+	 "rx_fifo_errors", "net device fifo errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_length_errors),
+	 "rx_length_errors", "net device length errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_over_errors),
+	 "rx_over_errors", "net device received overflow errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_crc_errors),
+	 "rx_crc_errors", "net device received crc errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_frame_errors),
+	 "rx_frame_errors", "net device received frame errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, rx_compressed),
+	 "rx_compressed", "net device received compressed packet count"},
+	{NULL, offsetof(struct rtnl_link_stats64, multicast),
+	 "rx_multicast", "net device received multicast packet count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_bytes),
+	 "tx_bytes", "net device transmited bytes count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_packets),
+	 "tx_packets", "net device transmited packets count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_errors),
+	 "tx_errors", "net device transmited errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_dropped),
+	 "tx_dropped", "net device transmited packet drop count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_fifo_errors),
+	 "tx_fifo_errors", "net device transmit fifo errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, collisions),
+	 "tx_collision", "net device transmit collisions count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_carrier_errors),
+	 "tx_carrier_errors", "net device transmit carrier errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_aborted_errors),
+	 "tx_aborted_errors", "net device transmit aborted errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_window_errors),
+	 "tx_window_errors", "net device transmit window errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_heartbeat_errors),
+	 "tx_heartbeat_errors", "net device transmit heartbeat errors count"},
+	{NULL, offsetof(struct rtnl_link_stats64, tx_compressed),
+	 "tx_compressed_errors", "net device transmit compressed count"},
+};
+
+static __init int init_net_subsys(void)
+{
+	net_root_subsys = metricfs_create_subsys("net", NULL);
+	if (!net_root_subsys) {
+		WARN_ONCE(1, "Net metricfs root not created.");
+		return -1;
+	}
+	return 0;
+}
+
+late_initcall(init_net_subsys);
+
+static void dev_stats_emit(struct metric_emitter *e,
+			   struct net_device *dev,
+			   struct metric_def *metricd)
+{
+	struct rtnl_link_stats64 temp;
+	const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
+
+	if (stats) {
+		__u8 *ptr = (((__u8 *)stats) + metricd->off);
+
+		METRIC_EMIT_INT(e, *(__u64 *)ptr, dev->name, NULL);
+	}
+}
+
+/* metricfs export function */
+static void dev_stats_fn(struct metric_emitter *e, void *parm)
+{
+	struct net_device *dev;
+	struct net *net;
+	struct nsproxy *nsproxy = current->nsproxy;
+
+	rcu_read_lock();
+	for_each_net_rcu(net) {
+		/* skip namespaces not associated with the caller */
+		if (nsproxy->net_ns != net)
+			continue;
+		for_each_netdev_rcu(net, dev) {
+			dev_stats_emit(e, dev, (struct metric_def *)parm);
+		}
+	}
+	rcu_read_unlock();
+}
+
+static void clean_dev_stats_subsys(void)
+{
+	int x;
+	int metric_count = sizeof(metric_def) / sizeof(struct metric_def);
+
+	for (x = 0; x < metric_count; x++) {
+		if (metric_def[x].metric) {
+			metric_unregister(metric_def[x].metric);
+			metric_def[x].metric = NULL;
+		}
+	}
+	if (dev_stats_subsys)
+		metricfs_destroy_subsys(dev_stats_subsys);
+	if (dev_subsys)
+		metricfs_destroy_subsys(dev_subsys);
+	dev_stats_subsys = NULL;
+	dev_subsys = NULL;
+}
+
+static int __init init_dev_stats_subsys(void)
+{
+	int x;
+	int metric_count = sizeof(metric_def) / sizeof(struct metric_def);
+
+	dev_subsys = NULL;
+	dev_stats_subsys = NULL;
+	if (!net_root_subsys) {
+		WARN_ONCE(1, "Net metricfs root not initialized.");
+		goto error;
+	}
+	dev_subsys =
+		metricfs_create_subsys("dev", net_root_subsys);
+	if (!dev_subsys) {
+		WARN_ONCE(1, "Net metricfs dev not created.");
+		goto error;
+	}
+	dev_stats_subsys =
+		metricfs_create_subsys("stats", dev_subsys);
+	if (!dev_stats_subsys) {
+		WARN_ONCE(1, "Dev metricfs stats not created.");
+		goto error;
+	}
+
+	/* initialize each of the metrics */
+	for (x = 0; x < metric_count; x++) {
+		metric_def[x].metric =
+			metric_register_parm(metric_def[x].name,
+					     dev_stats_subsys,
+					     metric_def[x].desc,
+					     "interface",
+					     NULL,
+					     dev_stats_fn,
+					     (void *)&metric_def[x],
+					     false,
+					     true,  /* this is a counter */
+					     THIS_MODULE);
+		if (!metric_def[x].metric) {
+			WARN_ONCE(1, "Dev metricfs stats %s not registered.",
+				  metric_def[x].name);
+			goto error;
+		}
+	}
+	return 0;
+error:
+	clean_dev_stats_subsys();
+	return -1;
+}
+
+/* need to wait for metricfs and net metricfs root to be initialized */
+late_initcall_sync(init_dev_stats_subsys);
+
+static void __exit dev_stats_exit(void)
+{
+	clean_dev_stats_subsys();
+}
-- 
2.28.0.236.gb10cc79966-goog


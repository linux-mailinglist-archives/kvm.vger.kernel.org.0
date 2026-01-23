Return-Path: <kvm+bounces-68984-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sLKQKn2Oc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68984-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:06:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DBA77768
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D10CE3007AF5
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB6734FF6C;
	Fri, 23 Jan 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PLedWdvX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199E33506B;
	Fri, 23 Jan 2026 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180426; cv=none; b=Eda+eZ6my95SkgfCiKyUJF6UolEuQ0N0hHeJ5edGrh6EK3bWOnlgVBrcqbuSPI5iwa7ScLINPyI51uBt+D1uPcJrLwaDnUT30iHtGeh2uH4zjUVIRDshFJqyCeYtQPzdGirX747TYO/vPqmbFiIHW9RqsOmsLkr0UbWLGRh2Y+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180426; c=relaxed/simple;
	bh=LmLmoBJLYp1Fw5ImScOvQ6T5aiGshRkqk4yUpZCR5VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U4Xg+vATyYNorwRnGn9MTPs5Fw/e4eZvOk1uiRnFovCe8ZA1a4bRdTakY3Ql33x2oyxM5VPejAEjiOsvLMdIqpERuglY/O7O3NLyre1J3G5EX+JIaky+f1s3a5uaV4RJHwEpVui9/grB7GustCJgoW7G9YnkZrPG1yYaBI+Acsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PLedWdvX; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180422; x=1800716422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LmLmoBJLYp1Fw5ImScOvQ6T5aiGshRkqk4yUpZCR5VE=;
  b=PLedWdvXGHz+41kKF1YH4wlpuZEcl3Qou6VM3g3ZyT+Z73yiuV36oFXb
   8m+LVWjf9ECAFFAw38iKUv46di6Ss5nY2dkHsnrNVNk2foDCwsooH/ZdU
   3OCV88gKW6vsRpC5BF5mO3WJ4+kqL0CEk2UxzlJBPUWlBNwLiFXPz1Y0p
   Ah+lBmc+BKzui8GhNiRGqpvtGGWFTAceqmCmh8vDwn7K9q39Y6ebct5Nn
   MJkRyOgnT07L0twK2hKU65MvIu9yHeAiarSLgzzv4/+bhFeztZ0nL0PYq
   EHUR7Io7nTpHppndxR6byr4FFcflJjWkM0e+HZtIutI3tK0/d/Y3hyire
   A==;
X-CSE-ConnectionGUID: 2EmG0c08RO2o7ihvjZWREQ==
X-CSE-MsgGUID: MPJRTP+ZTWKWj7WnK0xkyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334396"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334396"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:13 -0800
X-CSE-ConnectionGUID: Lh9ZhzXMQMu36ykEEVeoeA==
X-CSE-MsgGUID: 9uN2K5lnT/GK6m5fB1tdeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697115"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:13 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: [PATCH v3 09/26] coco/tdx-host: Expose P-SEAMLDR information via sysfs
Date: Fri, 23 Jan 2026 06:55:17 -0800
Message-ID: <20260123145645.90444-10-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-68984-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:dkim,intel.com:email,intel.com:url,intel.com:mid,linux.dev:email]
X-Rspamd-Queue-Id: C1DBA77768
X-Rspamd-Action: no action

TDX Module updates require userspace to select the appropriate module
to load. Expose necessary information to facilitate this decision. Two
values are needed:

- P-SEAMLDR version: for compatibility checks between TDX Module and
		     P-SEAMLDR
- num_remaining_updates: indicates how many updates can be performed

Expose them as tdx-host device attributes.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
v3:
 - use #ifdef rather than .is_visible() to control P-SEAMLDR sysfs
   visibility [Yilun]
---
 .../ABI/testing/sysfs-devices-faux-tdx-host   | 25 ++++++++
 drivers/virt/coco/tdx-host/tdx-host.c         | 60 ++++++++++++++++++-
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
index 901abbae2e61..a3f155977016 100644
--- a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
+++ b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
@@ -4,3 +4,28 @@ Description:	(RO) Report the version of the loaded TDX Module. The TDX Module
 		version is formatted as x.y.z, where "x" is the major version,
 		"y" is the minor version and "z" is the update version. Versions
 		are used for bug reporting, TDX Module updates and etc.
+
+What:		/sys/devices/faux/tdx_host/seamldr/version
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) Report the version of the loaded SEAM loader. The SEAM
+		loader version is formatted as x.y.z, where "x" is the major
+		version, "y" is the minor version and "z" is the update version.
+		Versions are used for bug reporting and compatibility check.
+
+What:		/sys/devices/faux/tdx_host/seamldr/num_remaining_updates
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) Report the number of remaining updates that can be performed.
+		The CPU keeps track of TCB versions for each TDX Module that
+		has been loaded. Since this tracking database has finite
+		capacity, there's a maximum number of Module updates that can
+		be performed.
+
+		After each successful update, the number reduces by one. Once it
+		reaches zero, further updates will fail until next reboot. The
+		number is always zero if P-SEAMLDR doesn't support updates.
+
+		See Intel® Trust Domain Extensions - SEAM Loader (SEAMLDR)
+		Interface Specification Chapter 3.3 "SEAMLDR_INFO" and Chapter
+		4.2 "SEAMLDR.INSTALL" for more information. The documentation is
+		available at:
+		https://cdrdv2-public.intel.com/739045/intel-tdx-seamldr-interface-specification.pdf
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index 0424933b2560..f4ce89522806 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -11,6 +11,7 @@
 #include <linux/sysfs.h>
 
 #include <asm/cpu_device_id.h>
+#include <asm/seamldr.h>
 #include <asm/tdx.h>
 
 static const struct x86_cpu_id tdx_host_ids[] = {
@@ -40,7 +41,64 @@ static struct attribute *tdx_host_attrs[] = {
 	&dev_attr_version.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(tdx_host);
+
+struct attribute_group tdx_host_group = {
+	.attrs = tdx_host_attrs,
+};
+
+#ifdef CONFIG_INTEL_TDX_MODULE_UPDATE
+static ssize_t seamldr_version_show(struct device *dev, struct device_attribute *attr,
+				    char *buf)
+{
+	const struct seamldr_info *info = seamldr_get_info();
+
+	if (!info)
+		return -ENXIO;
+
+	return sysfs_emit(buf, "%u.%u.%02u\n", info->major_version,
+					       info->minor_version,
+					       info->update_version);
+}
+
+static ssize_t num_remaining_updates_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	const struct seamldr_info *info = seamldr_get_info();
+
+	if (!info)
+		return -ENXIO;
+
+	return sysfs_emit(buf, "%u\n", info->num_remaining_updates);
+}
+
+/*
+ * Open-code DEVICE_ATTR_RO to specify a different 'show' function for
+ * P-SEAMLDR version as version_show() is used for TDX Module version.
+ */
+static struct device_attribute dev_attr_seamldr_version =
+	__ATTR(version, 0444, seamldr_version_show, NULL);
+static DEVICE_ATTR_RO(num_remaining_updates);
+
+static struct attribute *seamldr_attrs[] = {
+	&dev_attr_seamldr_version.attr,
+	&dev_attr_num_remaining_updates.attr,
+	NULL,
+};
+
+static struct attribute_group seamldr_group = {
+	.name = "seamldr",
+	.attrs = seamldr_attrs,
+};
+#endif /* CONFIG_INTEL_TDX_MODULE_UPDATE */
+
+static const struct attribute_group *tdx_host_groups[] = {
+	&tdx_host_group,
+#ifdef CONFIG_INTEL_TDX_MODULE_UPDATE
+	&seamldr_group,
+#endif
+	NULL,
+};
 
 static struct faux_device *fdev;
 
-- 
2.47.3



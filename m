Return-Path: <kvm+bounces-69001-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ILKKAiyPc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-69001-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:09:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 81655777D9
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:09:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0280130298E5
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C7A33D6C7;
	Fri, 23 Jan 2026 15:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E9COFoZA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0409D28FFFB;
	Fri, 23 Jan 2026 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180443; cv=none; b=PpOlFXjBlRZ8/Sq1gwkXEi6akYiJePIHYEoerqJeV8ATAcNEVrHb1M0BARHn7DmA6tZIk6K0RNHP7EbbyY/xTvNhv5tdY3GN9anJWjpccFD/X9mi7X/+p9x5fXKHDRyUSU9O1gRgyX6sUigZdhhUBTn0O2NDUXtUVt37Nt8O1N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180443; c=relaxed/simple;
	bh=TR8Wv5ycc+2AvBtNRmnwUDkwXK3rxb5okVi7Q7pIqzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/ybB9Oy9wfq1G9YNjzGZrPS6QCaf+V69FZ4lkDCF50Xpa1LOe//NVL3sigMIG5HPo9UvlWJwidczrGBYJaxaqb02ENpwAUPtOz6xx1LzbG1Za0DCQRBUEzIhhOj65VbdzpUdC7Q3txTfBLc9oh0lIyfvFFft278+9R5/HTp7Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E9COFoZA; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180441; x=1800716441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TR8Wv5ycc+2AvBtNRmnwUDkwXK3rxb5okVi7Q7pIqzQ=;
  b=E9COFoZAAFrnvNUZvt7HC6muAY1iLwkgLzdaPyLY77L0SjM5W/0PQFVb
   Ueq2XcZX5xVXg841fxTlTmMR3sCPhrDh0YHlwzZ0Ot8eUzIMvTHd3KymW
   HnFhOp1MFgsYk/Ho4ibyghQ8egXAARr1LOmXb7NnXbSjPsPUiJ+66I0ma
   mZy28LatMzfYJ02Pi+wtUCfmAtQwdsp89ue7bA3u/lIyghXyEMU0649Es
   cO/LWUKJA+QlH7s1QQMXZmartq9dJfc3pVwdMicdWBG9d6+AiD6cEuNDi
   C5ZrumDyFiE6Am+M7xqNrjRdecsDEJQPwMz9p7YU+9NJgl/7aHRn4cBR0
   A==;
X-CSE-ConnectionGUID: 1BuCiVt0SKWQPH2sxjABHA==
X-CSE-MsgGUID: KzbSnrSUQXOLCPFnxNESEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334550"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334550"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:22 -0800
X-CSE-ConnectionGUID: rsVdXnvvQZWVc2vCYKRzdw==
X-CSE-MsgGUID: ZAde7awbTDGOUW/OXNJHpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697258"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:22 -0800
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
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v3 26/26] coco/tdx-host: Set and document TDX Module update expectations
Date: Fri, 23 Jan 2026 06:55:34 -0800
Message-ID: <20260123145645.90444-27-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69001-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:url,intel.com:mid,linux.dev:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 81655777D9
X-Rspamd-Action: no action

In rare cases, TDX Module updates may cause TD management operations to
fail if they occur during phases of the TD lifecycle that are sensitive
to update compatibility.

But not all combinations of P-SEAMLDR, kernel, and TDX Module have the
capability to detect and prevent said incompatibilities. Completely
disabling TDX Module updates on platforms without the capability would
be overkill, as these incompatibility cases are rare and can be
addressed by userspace through coordinated scheduling of updates and TD
management operations.

To set clear expectations for TDX Module updates, expose the capability
to detect and prevent these incompatibility cases via sysfs and
document the compatibility criteria and indications when those criteria
are violated.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v3:
 - new, based on a reference patch from Dan Williams
---
 .../ABI/testing/sysfs-devices-faux-tdx-host   | 45 +++++++++++++++++++
 drivers/virt/coco/tdx-host/tdx-host.c         | 13 ++++++
 2 files changed, 58 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
index a3f155977016..81cb13e91f2a 100644
--- a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
+++ b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
@@ -29,3 +29,48 @@ Description:	(RO) Report the number of remaining updates that can be performed.
 		4.2 "SEAMLDR.INSTALL" for more information. The documentation is
 		available at:
 		https://cdrdv2-public.intel.com/739045/intel-tdx-seamldr-interface-specification.pdf
+
+What:		/sys/devices/faux/tdx_host/firmware/seamldr_upload
+Contact:	linux-coco@lists.linux.dev
+Description:	(Directory) The seamldr_upload directory implements the
+		fw_upload sysfs ABI, see
+		Documentation/ABI/testing/sysfs-class-firmware for the general
+		description of the attributes @data, @cancel, @error, @loading,
+		@remaining_size, and @status. This ABI facilitates "Compatible
+		TDX Module Updates". A compatible update is one that meets the
+		following criteria:
+
+		   Does not interrupt or interfere with any current TDX
+		   operation or TD VM.
+
+		   Does not invalidate any previously consumed Module metadata
+		   values outside of the TEE_TCB_SVN_2 field (updated Security
+		   Version Number) in TD Quotes.
+
+		   Does not require validation of new Module metadata fields. By
+		   implication, new Module features and capabilities are only
+		   available by installing the Module at reboot (BIOS or EFI
+		   helper loaded).
+
+		See tdx_host/compat_capable and
+		tdx_host/firmware/seamldr_upload/error. For details.
+
+What:		/sys/devices/faux/tdx_host/compat_capable
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) When present this attribute returns "1" to indicate that
+		the current seamldr, kernel, and TDX Module combination can
+		detect when an update conforms with the "Compatible TDX Module
+		Updates" criteria in the tdx_host/firmware/seamldr_upload description.
+		When this attribute is missing it is indeterminate whether an
+		update will violate the criteria.
+
+What:		/sys/devices/faux/tdx_host/firmware/seamldr_upload/error
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) See Documentation/ABI/testing/sysfs-class-firmware for
+		baseline expectations for this file. Updates that fail
+		compatibility checks end with the "device-busy" error in the
+		<STATUS>:<ERROR> format of this attribute. When this is
+		signalled current TDs and the current TDX Module stay running.
+		Other failures may result in all TDs being lost and further
+		TDX operations becoming impossible. This occurs when
+		/sys/devices/faux/tdx_host/version becomes unreadable.
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index 06487de2ebfe..8cc48e276533 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -45,8 +45,21 @@ static ssize_t version_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(version);
 
+static ssize_t compat_capable_show(struct device *dev, struct device_attribute *attr,
+				   char *buf)
+{
+	const struct tdx_sys_info *tdx_sysinfo = tdx_get_sysinfo();
+
+	if (!tdx_sysinfo)
+		return -ENXIO;
+
+	return sysfs_emit(buf, "%i\n", tdx_supports_update_compatibility(tdx_sysinfo));
+}
+static DEVICE_ATTR_RO(compat_capable);
+
 static struct attribute *tdx_host_attrs[] = {
 	&dev_attr_version.attr,
+	&dev_attr_compat_capable.attr,
 	NULL,
 };
 
-- 
2.47.3



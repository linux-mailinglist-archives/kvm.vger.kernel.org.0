Return-Path: <kvm+bounces-7796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2BB846730
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E64EB1F24E1A
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2D410796;
	Fri,  2 Feb 2024 04:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BW6dVVNj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF400D521;
	Fri,  2 Feb 2024 04:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849849; cv=none; b=VO2QUAlF36Jv4ye7lFf98SHVJJGBY7BC6UqMYN1GOa8O3u5MdL+capowuBqgenrdHhUUZZIWD22GS5sfHVQxKQFhBZOXLuLHsPS4h8nn54v+wZQzJP72qnfXPPywvemVw44N/xEVT2dQOZVnJj4o6l9cccCX4JnL/Mpr1AbDLR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849849; c=relaxed/simple;
	bh=SRyuqWoDw8f/ODrjmB+YtXDl8kO/6S8q7xI8rCGmDRA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZGOs7zrR9nAFlUVynv3fv+eVjns6afjM09h2RyxXU1/qV8ZYnfrwCYgkU+M9JwVn2rI5EtM1sgumbrHvTfYjRtEwW0Rb+HZcU+YD7p7x44kGAt/Ldd2XYdlqLXQ8IUISmrCa8FUCn6DCFu/0zeLpHqogN9xk0aUw7dtR2AkQD5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BW6dVVNj; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849848; x=1738385848;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SRyuqWoDw8f/ODrjmB+YtXDl8kO/6S8q7xI8rCGmDRA=;
  b=BW6dVVNjLZUGEz26OkuVhAvAiR4prWmvehVUbmWtDzh81Vr4YZZOPdo3
   f+vzGbgcs7pn21B6K6NnWe7vsclh48Ectsq8P+0MMJkkAKFz6EVwkXToL
   GcYk3NNhKdCkf2m5xpSV/8m40fbEcoF26/H6nElV1yiFuJQIwLcKbPytn
   +fBUKug3axMxD7TuPC8vgdrVryEhNJGZ09ZtNX2tIgMS6Yx4mYx5tpzJi
   uwxWGgs1bgUIVA0lbNvVeHXmuQlpOmoy6LN935WFO81y8OLm4ip/7m4py
   SBZR7hpWbAj1TjSRqj79vh9HAULvaRU352+YaE8j1fcC4h9OMTL60Zasp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615796"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615796"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339761"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339761"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:24 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	dave.jiang@intel.com,
	ashok.raj@intel.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 02/17] vfio/pci: Remove duplicate check from vfio_pci_set_ctx_trigger_single() wrappers
Date: Thu,  1 Feb 2024 20:56:56 -0800
Message-Id: <1429dd8025b6807e4d6951a18c813b94bbc52c0e.1706849424.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both wrappers of vfio_pci_set_ctx_trigger_single() perform the
same parameter checks before calling vfio_pci_set_ctx_trigger_single().

vfio_pci_set_ctx_trigger_single() only handles a single interrupt that
is expected to start from 0. Move parameter checks into
vfio_pci_set_ctx_trigger_single() instead of duplicated in its callers.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index f9280e32972a..69ab11863282 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -704,9 +704,13 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
+					   unsigned int start,
 					   unsigned int count, uint32_t flags,
 					   void *data)
 {
+	if (start != 0 || count > 1)
+		return -EINVAL;
+
 	/* DATA_NONE/DATA_BOOL enables loopback testing */
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
 		if (*ctx) {
@@ -763,10 +767,10 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
-	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
+	if (index != VFIO_PCI_ERR_IRQ_INDEX)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->err_trigger,
+	return vfio_pci_set_ctx_trigger_single(&vdev->err_trigger, start,
 					       count, flags, data);
 }
 
@@ -775,10 +779,10 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned int count, uint32_t flags,
 				    void *data)
 {
-	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
+	if (index != VFIO_PCI_REQ_IRQ_INDEX)
 		return -EINVAL;
 
-	return vfio_pci_set_ctx_trigger_single(&vdev->req_trigger,
+	return vfio_pci_set_ctx_trigger_single(&vdev->req_trigger, start,
 					       count, flags, data);
 }
 
-- 
2.34.1



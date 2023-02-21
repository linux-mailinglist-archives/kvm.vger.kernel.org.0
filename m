Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E28169D967
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjBUDml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbjBUDmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:42:39 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587F524120
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 19:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676950915; x=1708486915;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zoPReBuZ2NuXmJ6670cNJoY4GmEDXo+vXbP2NcKUldM=;
  b=i8JDPURpTWKdnlnXE/ZPH3ASvVKj4CBJ2ANPZBdQhQXdj0VvaFl8IoW4
   A/zGTEF3It+CTcK/uTFPuOT37MbMAmMzjzmh/39MRqS4RfjUujBaVN4GO
   9gQsjIQKdZYyeyiJYad1LcnyZ7jM/nm/da8azjTegAwMd2JMW7ZhVFhZh
   HRU44RK4P+h+9nPIrk16gOtXJftI0DQnxmewOGI7dACSGPFniz2bM1f8n
   cJlxdzEyy/JPxBlvR/uP9IFj84kUwLFcNtXLQPa+ZPXn6BWW+VrJq+bwr
   3TPf5hDAPk7jIae3jkuOE9lESW7l1xMH6Ee3SGv7n1r5Gq5XxcKRPFrYH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="331198273"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="331198273"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 19:41:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="814339834"
X-IronPort-AV: E=Sophos;i="5.97,314,1669104000"; 
   d="scan'208";a="814339834"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2023 19:41:16 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, pbonzini@redhat.com
Subject: [PATCH] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD before VFIO_GROUP_GET_DEVICE_FD
Date:   Mon, 20 Feb 2023 19:41:14 -0800
Message-Id: <20230221034114.135386-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

as some vfio_device's open_device op requires kvm pointer and kvm pointer
set is part of GROUP_ADD.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 Documentation/virt/kvm/devices/vfio.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
index 2d20dc561069..5722e283f1b5 100644
--- a/Documentation/virt/kvm/devices/vfio.rst
+++ b/Documentation/virt/kvm/devices/vfio.rst
@@ -39,3 +39,8 @@ KVM_DEV_VFIO_GROUP attributes:
 	- @groupfd is a file descriptor for a VFIO group;
 	- @tablefd is a file descriptor for a TCE table allocated via
 	  KVM_CREATE_SPAPR_TCE.
+
+::
+
+The GROUP_ADD operation above should be invoked before vfio_device's
+open_device op which is called in the ioctl VFIO_GROUP_GET_DEVICE_FD.
-- 
2.34.1


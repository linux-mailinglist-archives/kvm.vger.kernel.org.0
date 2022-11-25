Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6A0638CE6
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 16:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiKYPGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 10:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKYPGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 10:06:23 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47572D1C2
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 07:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388782; x=1700924782;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PUaEm/rUny2eMarZqMlMmRul7K0V7EvUBPsD7CJuyYU=;
  b=dbidGUH91xm8r5A4YfITC4wRj8F/TEUp/HsD0HffjCcwkNxWICJFpyq4
   O86fVaStTjP+khQ3iS0mGGuZbSP7CDb9s+mxbgvYxZDWGr3+9kdb9PZNG
   3BCuTUo2gXui78oWls2iQ8a4Iq2ajRY4sbYDFHMWbGu/pwCXzgfOlM1RC
   nrtjAqLvm8eUSBqydR17Q5VUsaM8lu4ven+1k/hlv9As4X5frO/8F7wFv
   dwAaO9gPnlSF+b8h/FLRJ5oMVn9COoMLBUeWprO/mbPBluBgJljAJvfzB
   UY9iGLx6Pc+wCX2X97Zx0HIl42Yh8iC6/rt9jA41aAyvEWMXH9Y+9mSxD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="302069130"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="302069130"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="593240191"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593240191"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:20 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 00/12] ifcvf/vDPA implement features provisioning
Date:   Fri, 25 Nov 2022 22:57:12 +0800
Message-Id: <20221125145724.1129962-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series implements features provisioning for ifcvf.
By applying this series, we allow userspace to create
a vDPA device with selected (management device supported)
feature bits and mask out others.

Examples:
a)The management device supported features:
$ vdpa mgmtdev show pci/0000:01:00.5
pci/0000:01:00.5:
  supported_classes net
  max_supported_vqs 9
  dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM

b)Provision a vDPA device with all supported features:
$ vdpa dev add name vdpa0 mgmtdev pci/0000:01:00.5
$ vdpa/vdpa dev config show vdpa0
vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
  negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM

c)Provision a vDPA device with a subset of the supported features:
$ vdpa dev add name vdpa0 mgmtdev pci/0000:01:00.5 device_features 0x300020020
$ vdpa dev config show vdpa0
mac 00:e8:ca:11:be:05 link up link_announce false
  negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM

Please help review

Thanks

Changes from V1:
split original patch 1 ~ patch 3 to small patches that are less
than 100 lines, so they can be applied to stalbe kernel(Jason)

Zhu Lingshan (12):
  vDPA/ifcvf: decouple hw features manipulators from the adapter
  vDPA/ifcvf: decouple config space ops from the adapter
  vDPA/ifcvf: alloc the mgmt_dev before the adapter
  vDPA/ifcvf: decouple vq IRQ releasers from the adapter
  vDPA/ifcvf: decouple config IRQ releaser from the adapter
  vDPA/ifcvf: decouple vq irq requester from the adapter
  vDPA/ifcvf: decouple config/dev IRQ requester and vectors allocator
    from the adapter
  vDPA/ifcvf: ifcvf_request_irq works on ifcvf_hw
  vDPA/ifcvf: manage ifcvf_hw in the mgmt_dev
  vDPA/ifcvf: allocate the adapter in dev_add()
  vDPA/ifcvf: retire ifcvf_private_to_vf
  vDPA/ifcvf: implement features provisioning

 drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
 drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
 drivers/vdpa/ifcvf/ifcvf_main.c | 162 +++++++++++++++-----------------
 3 files changed, 91 insertions(+), 113 deletions(-)

-- 
2.31.1


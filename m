Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FAD68D6E1
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 13:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbjBGMhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 07:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbjBGMhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 07:37:22 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C681E2B9;
        Tue,  7 Feb 2023 04:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675773438; x=1707309438;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+/E5PcQ0zh/6DggX2arWnQ62RptWMI2UE/7JScGHEGk=;
  b=R46Gz9+RNX+dFwxcDU7GIsbf8MDzgdye1OhZkk2qNBhfobCrBRBSzgUr
   brJyXuLO6QORjCZ5kt52sKmSRB8zuNV6VAeskvS146D/7sxEvSkcn2xmw
   FdPNLH911emnE7PdX+bJFNQYazfhaDeekBRRHUqG81gafN/7CxuJZWtC6
   w+ojYSHAYdLH39P4gBEi5+usgPqyCdzN8FWAmEDj6XfA6UerubUEC727A
   /mZgjKqQljdJWGP+0zA5FOJPOqkK2sQTdTXTe8crMnvjrp7nSt1Ayfu8M
   xLemrDoUCOWdreIa+Zw+d3feAntxU5AJPy2a7fwtEFhXW+H06Azttcrj6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="309140905"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="309140905"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 04:37:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="697267987"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="697267987"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2023 04:37:16 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, mhal@rbox.co
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 0/2] kvm_io_bus_unregister_dev cleanup
Date:   Tue,  7 Feb 2023 20:37:11 +0800
Message-Id: <20230207123713.3905-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset moves kvm io_device destruction into
kvm_io_bus_unregister_dev. This reduces LOCs a bit for users and can 
avoid the leakage of destructing the device explicitly.
Accordingly, below cleanups are included:
- remove the exposure of kvm_iodevice_destructor and the invocation in
  the users as kvm_iodevice_destructor is now invoked in
  kvm_io_bus_unregister_dev;
- Change kvm_deassign_ioeventfd_idx to use list_for_each_entry as the 
  loop ends at the entry that's founded and deleted.

The patches are rebased to
https://github.com/kvm-x86/linux/commit/b1cb1fac22ab

Changelog:
v1->v2:
 - keep kfree(bus) when the new bus is successfully allocated
 - add patch 2

Previous version:
https://lore.kernel.org/lkml/20221229123302.4083-1-wei.w.wang@intel.com/

Wei Wang (2):
  KVM: destruct kvm_io_device while unregistering it from kvm_io_bus
  kvm/eventfd: use list_for_each_entry when deassign ioeventfd

 include/kvm/iodev.h       |  6 ------
 virt/kvm/coalesced_mmio.c |  9 ++-------
 virt/kvm/eventfd.c        |  6 ++----
 virt/kvm/kvm_main.c       | 23 +++++++++++++++--------
 4 files changed, 19 insertions(+), 25 deletions(-)

-- 
2.27.0


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5943E790FA3
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 03:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350326AbjIDBgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Sep 2023 21:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjIDBgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Sep 2023 21:36:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAA5F1
        for <kvm@vger.kernel.org>; Sun,  3 Sep 2023 18:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693791360; x=1725327360;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aPUKhWotjsgm9+g4v1VX4q1XBZ3MGoFFs0LU4SakFLk=;
  b=RuCaZYUK4DQmqzacoMrU+Jjwapz1pSguyHfK9I3/NaaXM2V6dgEUGsJv
   PYPNoDRTdmEeKyld8LlqHynSOUQZpFmmWI2HMHQ0fiTJRCOsF5ZPzeZEM
   IVHolK9zuDtd3RCX1DShJHV7NF6ivF+7Izf8hhiEVluWiC+Z622OqRZEB
   yenj6Z5CmHTI5deCWAM4P8gskSzLzRZ4ESV5CWRRCg6i4zKVpsT6ThoiN
   f4X8GGZsLg7Rznl6SOWVwlmNxWeUWhkIP+11kwQHRpW4ADUOhd1lQAZyF
   ogwKJDGokbEWF6aCaVtQS04meCjUfs0tnCl4//Z3nHYkAQ2J4Vr5Hnf1N
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="407493235"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="407493235"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2023 18:35:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="743764780"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="743764780"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga007.fm.intel.com with ESMTP; 03 Sep 2023 18:35:57 -0700
From:   Tao Su <tao1.su@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com, tao1.su@linux.intel.com
Subject: [PATCH 0/2] KVM: x86: Fix a WARN in kvm_apic_send_ipi()
Date:   Mon,  4 Sep 2023 09:35:53 +0800
Message-Id: <20230904013555.725413-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.

The APIC_ICR_BUSY bit is removed in x2APIC mode, and bit12 of ICR is
changed to UNUSED bit, but kvm_x2apic_icr_write() still uses
APIC_ICR_BUSY, which may cause ambiguity, so introducing
X2APIC_ICR_UNUSED_12 instead.

When X2APIC_ICR_UNUSED_12 is set, how the hardware handles it
determines how the WARN is fixed. However SDM has no detail about it,
we tested on Intel CPU (SRF/GNR) with IPI virtualization and found
X2APIC_ICR_UNUSED_12 was also cleared by hardware without #GP. Therefore,
the clearing of bit12 should be still kept being consistent with the
hardware behavior.

Tao Su (2):
  x86/apic: Introduce X2APIC_ICR_UNUSED_12 for x2APIC mode
  KVM: x86: Clear X2APIC_ICR_UNUSED_12 after APIC-write VM-exit

 arch/x86/include/asm/apicdef.h |  1 +
 arch/x86/kvm/lapic.c           | 27 ++++++++++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)


base-commit: 708283abf896dd4853e673cc8cba70acaf9bf4ea
-- 
2.34.1


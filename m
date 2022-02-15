Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69F54B836D
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 09:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiBPIyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 03:54:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiBPIyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 03:54:16 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9F8FA200
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 00:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645001645; x=1676537645;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bLryyWPt1g3avKzZTxRq/rTUSnwy7iNJ2yHqzo/iFpo=;
  b=c5/i3xCNvu7YQFgZtfAV+Dng64P8rxKuLnS5GwQLuhJuXZscCq5yvOxs
   dpG0nmjEDx+HddRSSXZdaYyrw+kiEvENGE3Wh+2lBVlp9IzT4ZI4lBs2X
   0GUfaMCWXudHTFZkt2oRD1I7cv2eQydglAgWUvh/JtldTMWBgIxmLm7A9
   6A4eoKM8CPKWVr6g9TLK84Z7aXsNvBtKIrWmPkswvR0ka4xnUDGYORyd7
   RTrt6qqstptC+bTa3PzPYLlbe958siP0jZAxogExgXOY1WkR8xD8W6OyL
   Qd/RioRnD99uFazRvj9OxDN8AERWpfCJHsFm32is9fOhRvifZ81fVS1Ef
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="275135769"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="275135769"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="633418259"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:04 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        like.xu.linux@gmail.com, wei.w.wang@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH 0/8] Enable Architectural LBR for guest
Date:   Tue, 15 Feb 2022 14:52:50 -0500
Message-Id: <20220215195258.29149-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Architectural LBR (Arch LBR) is the enhancement for previous
non-Architectural LBR (Legacy LBR). This feature is introduced
in Intel Architecture Instruction Set Extensions and Future
Features Programming Reference[0]. The advantages of Arch LBR
can be referred to in native patch series[1].

Since Arch LBR relies on XSAVES/XRSTORS to boost memory save/
restore, QEMU needs to enable the support for XSS first. Similar
as Legacy LBR, QEMU uses lbr-fmt=0x3f parameter to advertise
Arch LBR feature to guest.

Note, the depth MSR has following side-effects: 1)On write to the
MSR, it'll reset all Arch LBR recording MSRs to 0s. 2) XRSTORS
resets all record MSRs to 0s if the saved depth mismatches
MSR_ARCH_LBR_DEPTH. As the first step, the Arch LBR virtulization
solution only supports guest depth == host depth to simplify the
implementation.

During live migration, before put Arch LBR msrs, it'll check the
depth setting of destination host, the LBR records are written to
destination only if both source and destination host depth MSR
settings match.

This patch series should be built with AMX QEMU patches in order
to set proper xsave area size.

[0]https://software.intel.com/sites/default/files/managed/c5/15/architecture-instruction-set-extensions-programming-reference.pdf
[1]https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/

QEMU base-commit: ad38520bde

patch 1~2: The support patches for legacy LBR.
patch 3:   Add a helper function to clean up code and it'll be 
	   used by Arch LBR patch too.
patch 4~5: Enable XSAVES support for Arch LBR.
patch 6~7: Enable Arch LBR live migration support.
patch 8:   Advertise Arch LBR feature.

Yang Weijiang (8):
  qdev-properties: Add a new macro with bitmask check for uint64_t
    property
  target/i386: Add lbr-fmt vPMU option to support guest LBR
  target/i386: Add kvm_get_one_msr helper
  target/i386: Enable support for XSAVES based features
  target/i386: Add XSAVES support for Arch LBR
  target/i386: Add MSR access interface for Arch LBR
  target/i386: Enable Arch LBR migration states in vmstate
  target/i386: Support Arch LBR in CPUID enumeration

 hw/core/qdev-properties.c    |  19 ++++
 include/hw/qdev-properties.h |  12 +++
 target/i386/cpu.c            | 169 +++++++++++++++++++++++++++++------
 target/i386/cpu.h            |  56 +++++++++++-
 target/i386/kvm/kvm.c        | 115 +++++++++++++++++++-----
 target/i386/machine.c        |  38 ++++++++
 6 files changed, 361 insertions(+), 48 deletions(-)

-- 
2.27.0


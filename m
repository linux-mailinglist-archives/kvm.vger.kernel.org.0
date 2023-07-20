Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E65C75B111
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 16:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjGTOTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 10:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbjGTOTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 10:19:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFC8212C
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 07:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689862788; x=1721398788;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aJKqAgRWdUOMC97LhTdm7nitnjY3ECOh03U/NV5Ta9A=;
  b=kwiVrAe4+lkdXOKQgGFiQ5yEFLL9UzLzc9Yvs/j6rBOVCdarvULk+BWh
   PqJ47rPfWGC6U13VuwzlFpAajv8UD5X3FH3HkLxe3Wp1Mwldp5DYFyUJm
   fzE6mqpRpqujyOYxISvLCuUWC2TJ8AVoeVLqpHXeKBhuHNO/u4VC62H9F
   JKFy0BaD618cLWtMPwp3Bq5Rv6ts2OI9XIAzTinWfbz1XPaPAJLB7miCe
   W/97ZW8KqLicV1k5RlvlzNtgCcUFeiswncLD9NiW0yJ6NIHat4SugJ5f0
   pA7oI5JVv+SM5HLp0IQDkH26Oi1VI7R95v2DlpjEcaMqx+dt5sUv+VXNL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="397629156"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="397629156"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:19:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="898295616"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="898295616"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:19:29 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, weijiang.yang@intel.com
Subject: [PATCH v2 0/4] Enable CET userspace support
Date:   Thu, 20 Jul 2023 07:14:41 -0400
Message-Id: <20230720111445.99509-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET virtualization requires VMM userspace setup for CET feature
bits enumeration, this series enables all related settings.

Guest CET user and kernel mode SHSTK/IBT are both supported.

Changes in v2:
1. Added supervisor CET states support.
2. Consolidated all CET states in a struct of vmstate.

v1 link:
https://lore.kernel.org/all/20230421041227.90915-1-weijiang.yang@intel.com/


Yang Weijiang (4):
  target/i386: Enable XSAVES support for CET states
  target/i386: Add CET MSRs access interface
  target/i386: Add CET states to vmstate
  target/i386: Advertise CET related flags in feature words

 target/i386/cpu.c     | 54 +++++++++++++++++++++++++++++----------
 target/i386/cpu.h     | 41 ++++++++++++++++++++++++++++++
 target/i386/kvm/kvm.c | 59 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/machine.c | 28 ++++++++++++++++++++
 4 files changed, 169 insertions(+), 13 deletions(-)


base-commit: a342ce9dfeed8088c426e5d51d4a7e47f3764b84
-- 
2.27.0


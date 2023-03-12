Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1B86B6478
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCLJ5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjCLJ5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:57:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664D455514
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615001; x=1710151001;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZHx5Q6yGYgYk/5ROGjKEVY6OPl0bbNSn2AwjMGwW8x8=;
  b=V7Fe1oRjQeRdcsn1WhZN+yQBlSbpTNAQ1tNKwBrje33JoFpySmAGS5jG
   b5e7uX08OXvNprHPEI0LXW6E/6S49apjmC1t5johIqPsqn3Yfg6xrwJEu
   hm1EePfTnuXEESYx87+ecnledg5U147Z5rqGMk2cizHXXmcUOF5MXS5j/
   UmkTewQF35wFyv6rsd7eWIPI1k1wACykMfn9dWSn5bcS0wh03xqK9gE2Q
   DK9ovSV6e2aO5Qp6PX+JUdGf+G7CyC+TnEneGmtkY/60ydV7E/GuZf7HN
   9si3nGGp+lQ8e6rUx35TvKU9A5mjU9IpOojykbvcayaZwIPkKgMgqqqAm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998070"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998070"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677526"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677526"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:49 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-4 0/4] Misc
Date:   Mon, 13 Mar 2023 02:02:40 +0800
Message-Id: <20230312180244.1778422-1-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set is part-4 of this RFC patches. It contains patches for
misc functionalities including supporting of VPID, debug and NMI
handling.

Enable VPID for host VM in pKVM if the platform supports it, which
improve VMX transition overhead.

Add tmp debug method for pKVM by allowing access Linux printk.

Add nmi support in pKVM, which will record nmi happened in root mode
then inject to host VM when vmenter. This ensure physical nmi will not
be lost.

Chuanxiao Dong (1):
  pkvm: x86: Handle pending nmi in pKVM runtime

Jason Chen CJ (3):
  pkvm: x86: Enable VPID for host VM
  pkvm: x86: Add pKVM debug support
  pkvm: x86: Support get_pcpu_id

 arch/x86/include/asm/pkvm_image.h         |  2 +-
 arch/x86/include/asm/pkvm_image_vars.h    |  4 ++
 arch/x86/kvm/Kconfig                      |  8 +++
 arch/x86/kvm/vmx/pkvm/hyp/Makefile        | 10 ++-
 arch/x86/kvm/vmx/pkvm/hyp/cpu.h           | 30 ++++++++
 arch/x86/kvm/vmx/pkvm/hyp/debug.h         |  7 ++
 arch/x86/kvm/vmx/pkvm/hyp/idt.S           | 67 ++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c | 28 +++++++-
 arch/x86/kvm/vmx/pkvm/hyp/irq.c           | 60 ++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c           | 21 ++++++
 arch/x86/kvm/vmx/pkvm/hyp/mmu.h           |  6 ++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c        | 26 +++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h           |  5 ++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h      |  6 ++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c         | 83 ++++++++++++++++++++---
 virt/kvm/pkvm/pkvm.c                      |  6 +-
 16 files changed, 352 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/cpu.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/idt.S
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/irq.c

-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137796225AA
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 09:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiKIInD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 03:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiKIInC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 03:43:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B96183A8;
        Wed,  9 Nov 2022 00:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667983381; x=1699519381;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IDum+SM6k0OVKgwCIgzv/T0+eZZYscX/FC4l1QYdbtA=;
  b=fLZKy9C4A/h6fe/S9IIHCfqZIUSpjCUWA7sY59J4QZPaHu14b4tJsNx1
   Beia76wBgzipwpKT2H1D7mBd8CioKZv2yi97cFZYDkWIdDJv/k+q+lb1w
   Vic/jQE/b06akiib3KGDhnJnBh76fmBKMvvH82Dh4JviNVl5+BZAWFIun
   +LqF2oRQmSjARE/mlT/6i82uFJ8RJBNldkQBEonaGv/cqaeLxxKhUixP/
   4QHTlCJFQbABNw6HYUUFgpxVqpkUIXi6XlveaeaA4ymTwOsEDL7F8Bm+s
   yD7qerwjeykkpVrv05hov/x+e22CDbUgxSclX9HqdVCtrdIO3KeJ5ws45
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="308544190"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="308544190"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 00:43:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="631182813"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="631182813"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga007.jf.intel.com with ESMTP; 09 Nov 2022 00:42:58 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Cleanup VMFUNC handling in KVM.
Date:   Wed,  9 Nov 2022 15:54:11 +0800
Message-Id: <20221109075413.1405803-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since VMFUNC is not supported for non-nested guests, and executing VMFUNC
can cause a #UD directly, if the “enable VM functions” VM-execution control
is 0, KVM can just disable it in VM-exectution control, instead of taking
pains to trap it and emulate the #UD for L1 guests.

Also, simplified the process of setting SECONDARY_EXEC_ENABLE_VMFUNC for
nested VMX MSR configurations.

Change log:
==========
v1->v2
- Split the patch into two pieces.
- Use KVM_BUG_ON() for unexpected VM Exits.
- Comments changes.
- Commit message changes, trying to better illustrate the reason.

Yu Zhang (2):
  KVM: VMX: Do not trap VMFUNC instructions for L1 guests.
  KVM: nVMX: Simplify the setting of SECONDARY_EXEC_ENABLE_VMFUNC for
    nested.

 arch/x86/kvm/vmx/nested.c | 26 ++++++++++----------------
 arch/x86/kvm/vmx/vmx.c    |  7 ++++++-
 2 files changed, 16 insertions(+), 17 deletions(-)

-- 
2.17.1


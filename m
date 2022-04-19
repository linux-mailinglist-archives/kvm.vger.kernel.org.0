Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2862950698C
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 13:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350950AbiDSLUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 07:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240937AbiDSLUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 07:20:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59C915813;
        Tue, 19 Apr 2022 04:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650367046; x=1681903046;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DNFtwZIckgL0QZPQuSkrgXsqWRjXbTAPZ5br4vRPNtA=;
  b=Un9vi5Rb7aAHPCqWrPMUUIcsfzzY3KU194H7coyRPvciLZPosXTJJqGa
   rZD688vtoS5PyBJKAjCtXBw7gjUHdkVezUu3W9AiPmOUOgKmOpvv2QlBp
   ckDmWYnzoJVSY4B7LN9k00/00F74FMQQwBo1MVQ0SP4uU69WhCJ73GaWY
   tPmKrZvZ40LFLB9GSvECxyzxXi6QqQEi6rmlkQSdKtFVFWoHfXdZ4gg4F
   pOTxgh+PkexJHCevYyvF6Y6jJk7LgLrL+HE4eRk21d+nToiK8rOwl8bXg
   ZONDuZ/2+qEGwTiXhyCzuDA0qriHQWIV9sVBar+TlDY9+lXh1mwFwCuuw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="350189750"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="350189750"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 04:17:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="554683731"
Received: from csambran-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.58.20])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 04:17:12 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com
Subject: [PATCH 0/3] Include MKTME KeyID bits to MMU shadow_zero_check
Date:   Tue, 19 Apr 2022 23:17:01 +1200
Message-Id: <cover.1650363789.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host kernel never sets any Intel MKTME KeyID bits (including TDX KeyID
bits) in any mapping.  KVM should not set any of them to MMU's SPTE which
maps to guest memory either.  KVM MMU has shadow_zero_check which
contains those bits must be 0 for SPTE.  This series adds MKTME bits to
shadow_zero_check.  The first patch is not directly needed but looks
better to have IMHO.  Patch 02/03 actually do the job.

Sanity tested by creating normal VMs on TDX capable machine (with TDX
turned on).  However this is not tested on AMD machine since I don't have
access to any, though the risk should be very small I suppose.

Kai Huang (3):
  KVM: x86/mmu: Rename reset_rsvds_bits_mask()
  KVM: x86/mmu: Add shadow_me_value and repurpose shadow_me_mask
  KVM: VMX: Include MKTME KeyID bits to shadow_zero_check

 arch/x86/kvm/mmu.h      | 20 ++++++++++++++++++++
 arch/x86/kvm/mmu/mmu.c  | 22 +++++++++++++++-------
 arch/x86/kvm/mmu/spte.c | 40 ++++++++++++++++------------------------
 arch/x86/kvm/mmu/spte.h |  1 +
 arch/x86/kvm/svm/svm.c  |  3 +++
 arch/x86/kvm/vmx/vmx.c  | 31 +++++++++++++++++++++++++++++++
 6 files changed, 86 insertions(+), 31 deletions(-)

-- 
2.35.1


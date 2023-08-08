Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57724773BC7
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 17:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjHHPzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 11:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjHHPxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 11:53:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8850355B8;
        Tue,  8 Aug 2023 08:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691509403; x=1723045403;
  h=from:to:cc:subject:date:message-id;
  bh=OEhSFtz6kSiSx1lq0Y2Sj8F+FGdJpfe5yIutpZ0zmq8=;
  b=YPou47vTNhuZQt8sTW6xip2q3AEkepILUqk34vgbOAhg1n/h7Kd+o0gX
   uRPK3F+6Rd4/E3oYxhPlxawPdg5UUvPTDoUKdb1IkEYoW7hOVSNfxj7dc
   b1A7BaO77HJYcMFNsEiTZznbpn508mLquNlKMvoFttODqQtvktPB5SSJV
   bcAuWxVzjFRFgpC49UbQtCzMwGC9hixo8owAJt4D2Owm4DIq4NITjqlAf
   aPsfdiIiCOM93NPPrYYw6tc+WFB6X6EDFQ91At0GLZX3GWqMgvtd+t8PE
   zD5L7fzkDk6fHqNyC809a3TX/jmzVhnuCI3S20UPEYsi9rfN25hzQrNBc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="457152360"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="457152360"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 02:18:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="796653375"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="796653375"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 02:18:08 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/2] KVM: x86/mmu: .change_pte() optimization in TDP MMU
Date:   Tue,  8 Aug 2023 16:50:56 +0800
Message-Id: <20230808085056.14644-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series optmizes KVM mmu notifier.change_pte() handler in x86 TDP MMU
(i.e. kvm_tdp_mmu_set_spte_gfn()) by removing old dead code and prefetching
notified new PFN into SPTEs directly in the handler.

As in [1], .change_pte() has been dead code on x86 for 10+ years.
Patch 1 drops the dead code in x86 TDP MMU to save cpu cycles and prepare
for optimization in TDP MMU in patch 2.

Patch 2 optimizes TDP MMU's .change_pte() handler to prefetch SPTEs in the
handler directly with PFN info contained in .change_pte() to avoid that
each vCPU write that triggers .change_pte() must undergo twice VMExits and
TDP page faults.

base-commit: fdf0eaf11452 + Sean's patch "KVM: Wrap kvm_{gfn,hva}_range.pte
in a per-action union" [2]

[1]: https://lore.kernel.org/lkml/ZMAO6bhan9l6ybQM@google.com/
[2]:
https://lore.kernel.org/lkml/20230729004144.1054885-1-seanjc@google.com/

Yan Zhao (2):
  KVM: x86/mmu: Remove dead code in .change_pte() handler in x86 TDP MMU
  KVM: x86/mmu: prefetch SPTE directly in x86 TDP MMU's change_pte()
    handler

 arch/x86/kvm/mmu/tdp_mmu.c | 101 +++++++++++++++++++++++++------------
 1 file changed, 68 insertions(+), 33 deletions(-)

-- 
2.17.1


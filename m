Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4808D6258DF
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbiKKKzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbiKKKzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:55:51 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34957A1B8;
        Fri, 11 Nov 2022 02:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668164149; x=1699700149;
  h=from:to:cc:subject:date:message-id;
  bh=O2g9ozphUY908mOhpsa+b7OyhsmdMF5WwXwnWaF1F/o=;
  b=Ykm04UUT+XHMJNapWJWasUgXTrlj+tUUWHgI4w8U1VjBpZYf4sxOCiQ0
   /S9fDsxZHc7mHSJIVHCypksTk2YcFu9HwzSsT1vMKZsVb3IGh4EPnlrEc
   RwCz5iQK55WJ74ZzgYIX7iU7kmHcaSAzQ3weN4oc7+/RFLwkCxQXwgNsR
   cqRZnSvEyf0duzQr/XDz7ht7imjJoNhTfIFKi4JKF5895wCI2RDAiiGKM
   9X6jPZfakdGGv6EfDY8HPINxCq2aWD0Y5Z7fCIijs/pxh/Jt27QOIOEpb
   DOFuBtmq2gl8UtLcSqVMb/CCo89P2ZurnfdkbWsleHx0dxGzFf6JEsoAb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373707862"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="373707862"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 02:55:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="668779140"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="668779140"
Received: from yzhao56-desk.sh.intel.com ([10.238.200.254])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 02:55:46 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/3] add track_remove_slot and remove track_flush_slot
Date:   Fri, 11 Nov 2022 18:32:47 +0800
Message-Id: <20221111103247.22275-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is based on Sean's series
https://lore.kernel.org/all/20221110014821.1548347-1-seanjc@google.com/,
which allows KVM internal user of page track not to rely on the page track
hook .track_flush_slot.

Page track hook track_flush_slot is for notification of slot flush and
is called when a slot DELETE/MOVE is on-going.

Page track hook track_remove_slot is for notification of slot removal
and is called when the slot DELETE/MOVE has been committed.

As KVMGT, the only external user of page track, actually only cares about
when slot removal indeed happens, this series switches KVMGT to use the new
hook .track_remove_slot.
And as there are no users to .track_flush_slot any more, this hook is
removed.

v2:
Corrected wrong email address of Sean. sorry.
 
Yan Zhao (3):
  KVM: x86: add a new page track hook track_remove_slot
  drm/i915/gvt: switch from track_flush_slot to track_remove_slot
  KVM: x86: Remove the unused page track hook track_flush_slot

 arch/x86/include/asm/kvm_page_track.h | 8 ++++----
 arch/x86/kvm/mmu/page_track.c         | 8 ++++----
 arch/x86/kvm/x86.c                    | 5 +++--
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 6 +++---
 4 files changed, 14 insertions(+), 13 deletions(-)

-- 
2.17.1


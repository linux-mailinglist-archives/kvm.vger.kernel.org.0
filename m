Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B9E625757
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 10:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiKKJzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 04:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiKKJzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 04:55:16 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573196712A;
        Fri, 11 Nov 2022 01:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668160515; x=1699696515;
  h=from:to:cc:subject:date:message-id;
  bh=GJYrYNUtpEQsFbSwvNRlRAKIkv76R0GmUW9rcH9SpOA=;
  b=YzOdIChvvlseMqCDnr7cmZIkpuRgmwbiCJm9GvAiPteKTwUKkIX3A4Zp
   KJQeQJqIDBAjUfTad4vTWBhhdqJZUn5WNmDvtUd4GA1nnAaoetjltOilu
   mV0DbZJOGzt4y5C+OM8ksXn6LtxN6QZtdQRwzebVvHavfyw2KV3XqlGyW
   IIRj0Tz51anLfLUs/1qcvYSmYjDVUZKpOfNwhOoIJa41rhPrysOpkXwt9
   3Tr6R3g2VazndeTCsGFlFYDUkQ9hCTV7EYOAJ1w4gFokPCTQv9eteEEc3
   GwTHtuQbY+gHbJCMgiyDHBQyKRZk+u3zZicuLYSFQMOU6GYQERVTYVGz6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="309194747"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="309194747"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 01:55:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="701165687"
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="701165687"
Received: from yzhao56-desk.sh.intel.com ([10.238.200.254])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 01:55:12 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org
Cc:     pbonzini@redhat.com, seanjc@google.com, zhenyuw@linux.intel.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/3] add track_remove_slot and remove track_flush_slot
Date:   Fri, 11 Nov 2022 17:32:22 +0800
Message-Id: <20221111093222.3148-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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


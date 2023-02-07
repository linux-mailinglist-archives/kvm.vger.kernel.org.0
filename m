Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948A468D6E4
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 13:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbjBGMh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 07:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjBGMhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 07:37:25 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78761E2B9;
        Tue,  7 Feb 2023 04:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675773444; x=1707309444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LiSxcagqNB+5kdb9BVVbcrT1QJr/8pqeefoLK3ITSQA=;
  b=Bg6A8O/9PBpkWNomYDrP164OIOQjpvRzyp0WemoXr22Fo9b38t2NBSjQ
   WGkDnVP/Lpl91hxUCxU8KX/Yr0b+ZHMnj9suPYkf27Jw04QCQ3y1XPZhi
   EUmX6Ae2GQlZRY1U83M+6u6quaj69b8ifNUZdTWShGdr7SRrHlStutATr
   CS5iQtcMsOvKOwLP0NpkWkycjYkTIwyDT+x4SDvODSyqEwZSrXGy5WCwg
   BrX1dAo4eZFGwKadKS2Okhzgv7LuuVZ01tIQb6s2zrkiKQvlfJCb+pspA
   EAVO4yKxga2sCnsL775hQxllTK3WB0l0kryXBXsURqH/nMO3C65pVJBpC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="309140933"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="309140933"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 04:37:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="697268000"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="697268000"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2023 04:37:22 -0800
From:   Wei Wang <wei.w.wang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, mhal@rbox.co
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v2 2/2] kvm/eventfd: use list_for_each_entry when deassign ioeventfd
Date:   Tue,  7 Feb 2023 20:37:13 +0800
Message-Id: <20230207123713.3905-3-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230207123713.3905-1-wei.w.wang@intel.com>
References: <20230207123713.3905-1-wei.w.wang@intel.com>
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

Simpify kvm_deassign_ioeventfd_idx to use list_for_each_entry as the
loop just ends at the entry that's founded and deleted.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 virt/kvm/eventfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 1b277afb545b..2b56a3c81957 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -868,7 +868,7 @@ static int
 kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
 			   struct kvm_ioeventfd *args)
 {
-	struct _ioeventfd        *p, *tmp;
+	struct _ioeventfd        *p;
 	struct eventfd_ctx       *eventfd;
 	struct kvm_io_bus	 *bus;
 	int                       ret = -ENOENT;
@@ -882,8 +882,7 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
 
 	mutex_lock(&kvm->slots_lock);
 
-	list_for_each_entry_safe(p, tmp, &kvm->ioeventfds, list) {
-
+	list_for_each_entry(p, &kvm->ioeventfds, list) {
 		if (p->bus_idx != bus_idx ||
 		    p->eventfd != eventfd  ||
 		    p->addr != args->addr  ||
-- 
2.27.0


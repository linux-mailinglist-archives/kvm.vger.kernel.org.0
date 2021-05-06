Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A0E374CED
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhEFBl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:41:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:22915 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhEFBl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:41:58 -0400
IronPort-SDR: E6aK9f+POsUPp/FGVVUf8eh/egqTGRVbNRx04zYjCzd73oWxxGcSaTrRhlV79L/jlQ3CJEWnVb
 8OVSIYq8Wl8w==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="177907508"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="177907508"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:01 -0700
IronPort-SDR: gHpi7Qln+3G46fad71umHSqklKdUAnUOZATJGR5cUpLHIvB9k7Vq5oB08oueKINbpSYtqNJZ6J
 G8XX0TzS1N2w==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220304"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:40:46 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 01/10] Extend the MemTxAttrs to include a 'debug' flag. The flag can be used as general indicator that operation was triggered by the debugger.
Date:   Thu,  6 May 2021 09:40:28 +0800
Message-Id: <20210506014037.11982-2-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

A subsequent patch will set the debug=1 when issuing a memory access
from the gdbstub or HMP commands. This is a prerequisite to support
debugging an encrypted guest. When a request with debug=1 is seen, the
encryption APIs will be used to access the guest memory.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

diff --git a/include/exec/memattrs.h b/include/exec/memattrs.h
index 95f2d20d55..c8b56389d6 100644
--- a/include/exec/memattrs.h
+++ b/include/exec/memattrs.h
@@ -49,6 +49,8 @@ typedef struct MemTxAttrs {
     unsigned int target_tlb_bit0 : 1;
     unsigned int target_tlb_bit1 : 1;
     unsigned int target_tlb_bit2 : 1;
+    /* Memory access request from the debugger */
+    unsigned int debug:1;
 } MemTxAttrs;
 
 /* Bus masters which don't specify any attributes will get this,
-- 
2.20.1


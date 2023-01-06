Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0518365FD8A
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjAFJUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbjAFJUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893E36B5E5;
        Fri,  6 Jan 2023 01:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996817; x=1704532817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HUHrRZTDjkecGuHDXK4PBl+TXz2Ml8+ie04d+kki1CQ=;
  b=Q4udPxw9JOAoaVlnAufzC/a6XcgpzCAUyH4ZQJ05hqJ/E5S/hd3fMn2j
   fYbaQIhR3+/niD9JRw/W5LeAv7t70xKB3zDvgkV3FjhIkIanVL2lBO9Gp
   FH4zDG3WrVEajn7Y2oxrxO3yIDheli2hPYVcnFA7BQ4SLAn6EwgWjBFgA
   mDbpjwoE5Rq6OPGW4x346IB+5unVx3BULsBRdexkc1yiei1zw0juJtMwU
   y3UFcOLYZgacheV0Ody6K4vwsv8Uc5kdt6HE88XfL51LhhJ11bG1WWOTS
   Loh7jjcYFkwzBmZMfrcEs1hmsnieGn8cZuuqZJa7jEHqHwY/bQAGhmhDY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511436"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511436"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139363"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139363"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:12 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 07/32] x86/opcode: add ERETU, ERETS instructions to x86-opcode-map
Date:   Fri,  6 Jan 2023 00:55:52 -0800
Message-Id: <20230106085617.17248-8-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add the instruction opcodes used by FRED: ERETU, ERETS.
Opcode number is per public FRED draft spec v3.0
https://cdrdv2.intel.com/v1/dl/getContent/678938.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/lib/x86-opcode-map.txt       | 2 +-
 tools/arch/x86/lib/x86-opcode-map.txt | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 5168ee0360b2..7a269e269dc0 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -1052,7 +1052,7 @@ EndTable
 
 GrpTable: Grp7
 0: SGDT Ms | VMCALL (001),(11B) | VMLAUNCH (010),(11B) | VMRESUME (011),(11B) | VMXOFF (100),(11B) | PCONFIG (101),(11B) | ENCLV (000),(11B)
-1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B) | ENCLS (111),(11B)
+1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B) | ENCLS (111),(11B) | ERETU (F3),(010),(11B) | ERETS (F2),(010),(11B)
 2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B) | XEND (101)(11B) | XTEST (110)(11B) | ENCLU (111),(11B)
 3: LIDT Ms
 4: SMSW Mw/Rv
diff --git a/tools/arch/x86/lib/x86-opcode-map.txt b/tools/arch/x86/lib/x86-opcode-map.txt
index 5168ee0360b2..7a269e269dc0 100644
--- a/tools/arch/x86/lib/x86-opcode-map.txt
+++ b/tools/arch/x86/lib/x86-opcode-map.txt
@@ -1052,7 +1052,7 @@ EndTable
 
 GrpTable: Grp7
 0: SGDT Ms | VMCALL (001),(11B) | VMLAUNCH (010),(11B) | VMRESUME (011),(11B) | VMXOFF (100),(11B) | PCONFIG (101),(11B) | ENCLV (000),(11B)
-1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B) | ENCLS (111),(11B)
+1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001),(11B) | CLAC (010),(11B) | STAC (011),(11B) | ENCLS (111),(11B) | ERETU (F3),(010),(11B) | ERETS (F2),(010),(11B)
 2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B) | VMFUNC (100),(11B) | XEND (101)(11B) | XTEST (110)(11B) | ENCLU (111),(11B)
 3: LIDT Ms
 4: SMSW Mw/Rv
-- 
2.34.1


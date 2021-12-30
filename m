Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142AA481B43
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 11:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhL3KNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 05:13:53 -0500
Received: from mga05.intel.com ([192.55.52.43]:36324 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234584AbhL3KNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 05:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640859232; x=1672395232;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zsGFdUlg6d2nYyHy5mJ4pGl5XuUxcXlp4uH8nLSgQJg=;
  b=SHUaBXZvo9wnbYiAtL70NVnCoSU0n9GIhCe0LFUMpkKSaXtM+WRwU7Lt
   jZvJuvpgYFHQxV1l/aBpVT5bb76Dr3J98nIMXzEbtqU1VCDBCRXsyNksl
   6NhUlZaUqAKbG4R+Q0BOXN2JBndyHJ6qeN0PIC2eYuQA4GZRIQf1v0jxS
   RMlmSoAPFvoystsxL3qCsZAHTDVM5vC8c92CHzmo1whUitZ9uBLedq7+G
   OQhV8v1kzj2BBIkeqTrruYdaJGoTWV7WD7eE/tklhxXKLQ2w9nhz+oJXd
   EbKYx1Mi8ykWopMfrGnVbZiqDCh7vNcy/hUz8ELY6shIn3a7OUzOXYLBs
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="327982997"
X-IronPort-AV: E=Sophos;i="5.88,248,1635231600"; 
   d="scan'208";a="327982997"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2021 02:13:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,248,1635231600"; 
   d="scan'208";a="524341535"
Received: from duan-client-optiplex-7080.bj.intel.com ([10.238.156.117])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2021 02:13:49 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Assign a canonical address before execute invpcid
Date:   Thu, 30 Dec 2021 18:14:52 +0800
Message-Id: <20211230101452.380581-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Occasionally we see pcid test fail as INVPCID_DESC[127:64] is
uninitialized before execute invpcid.

According to Intel spec: "#GP If INVPCID_TYPE is 0 and the linear
address in INVPCID_DESC[127:64] is not canonical."

Assign desc's address which is guaranteed to be a real memory
address and canonical.

Fixes: b44d84dae10c ("Add PCID/INVPCID test")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
 x86/pcid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/pcid.c b/x86/pcid.c
index 527a4a9..4828bbc 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -75,6 +75,9 @@ static void test_invpcid_enabled(int pcid_enabled)
     struct invpcid_desc desc;
     desc.rsv = 0;
 
+    /* Initialize INVPCID_DESC[127:64] with a canonical address */
+    desc.addr = (u64)&desc;
+
     /* try executing invpcid when CR4.PCIDE=0, desc.pcid=0 and type=0..3
      * no exception expected
      */
-- 
2.25.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCF9B6F54
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 00:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbfIRWYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 18:24:03 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:33521 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfIRWYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 18:24:02 -0400
Received: by mail-pg1-f201.google.com with SMTP id a13so899529pgw.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 15:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qH+qWV7M5iG2j6Q45JOR9JSuN6XQU2iyO+O7k8OW1Ww=;
        b=anjpHJqBn3YEVXzbE3K2uMX3ufxmcDac5XfwfabrWSgGVMlHgtwkEvlAkDksCphd3b
         0NFxnQgwL28QmO2EuaNKs9DOkw41Zdw7Nl01QGhpvISkG4UA0svxpq/24cdIDMxIb21w
         ZZIdonGJOIIODZbLvpCOaNZq0j+8H/Z3v9dQFM5KspN3Xe5dVLwMB9j7WtyMTKUTh6Ps
         Yg6jjKXtVul1CBphfgZ9YSvaJE02AVcYMcry8G4GyN8Vze0CNz9y7sErL6ESeuwnyOFK
         mzH69rcA1S2r393Hr6Gu0iwKC5sRePNsIDZ1QuIz85vBQStJB0bPdGdxjaz27lYSWNji
         4tDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qH+qWV7M5iG2j6Q45JOR9JSuN6XQU2iyO+O7k8OW1Ww=;
        b=bb4DFkf8v1aWtGcNNqjQgHwWqZHmioZIWoMwGmxWFmPFFsTs4qtyl6+r2/VIEz58wx
         hZHq53tl74CC4z1QzHs9auU5EXV/ezlqSpk6r8YTw/hJ5Ynxh6Yc70u0QPfp1fOifCdf
         viGvmM/D0gWbtPzzuPLhpKL5Ubrlh1dxBBjaHJ61rKtveETA5TkBUn6GykDEzUZpLlAh
         wRjPqULrBSAZ9BaM4j6Fby1bPMioi3dPL2Uf2MSlPRjkcYSNH7o/xvQM1J93MC33ZQZE
         wiuA8WGVTfQ0SNBqovG/3u34myE8Pj8lVS4LRcX89YjsK1+wr1E/LpaHL5yxtuuP2/p6
         JO0A==
X-Gm-Message-State: APjAAAWA/fyBoQeOtcZyzWDyJyXw6BeziQIT66LN4leKgKksYbsMiWej
        hJbNi3Gwy9R5Nvt4l4Kpsuw34wYMjvQ2pX/NhOp7wuQyYfmHfu6E+rWRyIZKBVw3BBPj756trAs
        GD5C3C+S6FtZtiiFJuIV0bd3rsX6OYKOEtYHE8uMNVAxN8mxqn9Ore6WkXJ3f
X-Google-Smtp-Source: APXvYqzAn/zuNvnvtbD3oNRIrEIj1jyK+LcaWplwQC4UpH4h4LuaCMSQNxUvnpFcf8ZRqZCesmidVK5uDLN7
X-Received: by 2002:a63:2c44:: with SMTP id s65mr6085828pgs.158.1568845440158;
 Wed, 18 Sep 2019 15:24:00 -0700 (PDT)
Date:   Wed, 18 Sep 2019 15:23:53 -0700
Message-Id: <20190918222354.184162-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [kvm-unit-tests PATCH v5 1/2] x86: nvmx: fix bug in __enter_guest()
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com, krish.sadhukhan@oracle.com
Cc:     Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__enter_guest() should only set the launched flag when a launch has
succeeded. Thus, don't set the launched flag when the VMX_ENTRY_FAILURE,
bit 31, is set in the VMCS exit reason.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Marc Orr <marcorr@google.com>
---
 x86/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 6079420db33a..7313c78f15c2 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1820,7 +1820,7 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
 		abort();
 	}
 
-	if (!failure->early) {
+	if (!failure->early && !(vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
 		launched = 1;
 		check_for_guest_termination();
 	}
-- 
2.23.0.237.gc6a4ce50a0-goog


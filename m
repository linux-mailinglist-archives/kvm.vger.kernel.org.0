Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B75B56C3
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 22:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfIQUQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 16:16:07 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:40233 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfIQUQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 16:16:07 -0400
Received: by mail-qt1-f201.google.com with SMTP id k22so5523135qtm.7
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 13:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mksV2ZBhYV4orXZIdrmZTUy75KtkMwvBQEMRJp8a6+Q=;
        b=wLB+pIE8lHKlsV0I6t9jXUjZHLE+gESWNhrhHH094vlD3DDFsYpw3u/yyBWsSb6eRM
         ghrcablsmLGydlELdxo9TQkdXbQF7Ktd+S0RH/it24pOtq8XC4oEHk0lNVFPygLs7z1O
         C53GkDmtZ8TfDBIKVQfSEe9NyBoTHnB6+3u1a97U9+RkzLk8CnAMtiHCb8W+lZZ6+rTD
         6Dd4bXlNgJRrYyP79U/gRp64jnOuHEUkwByLRdXUyHKgEEVAnOsFxH8nkd6dCiplvWXs
         K8pNC6Aoz38mL4PFKE2dtjKIhtrjWLPrAjZ0iAsb7HLfb8FM4QlnqaBvg7ZQ5+K2P/ZD
         ew7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mksV2ZBhYV4orXZIdrmZTUy75KtkMwvBQEMRJp8a6+Q=;
        b=Q0u29uHbB1EwMSh2I2BX3meXscLWYYBpvvIPCzuelnppMI2ykKRIdvFkVb9zr91qu+
         zBNvVblAYrUBaAHSbBFIKgqJII/vyMIJcHwKEYL462yhuFOKjZchZS6ZeiwD1Ww5x7sO
         IUWZMdUiDRR+Ju34Azo5G6pYLAeQgui9/Uj1gYHGQQ3z4N+qXEK/DS2tilYH8RDU2seR
         Gb6Je2zWqPv4z20uJ3aty8yW9hhPI3RaxH1a7e6LR5peMAqLCJ5eJEpd2LXh5Po6JffW
         4U2GDJbjDpfy938A28QS9rdphQlZDyeU6Wfjncp94W4u8PNiafPNxkehTZGBEJbvSCef
         ZpVQ==
X-Gm-Message-State: APjAAAVg2j5ywjn5NC0W0Ckahw0oDBLJvjJmMUWi8Q+ZzAhqtl9kykfc
        2nq1HiJ4Cc6Oqd4w+6+8ta8uBn1hW/yGlZUeC/pDaHxyP+PSiUnDKce7riV8M0FSJ62E6lfddlJ
        9hgrlrgZoBYRr2cTk87prjifZmUmKfdln7GxfRwY36gEqFPquuq/K+0aebtaL
X-Google-Smtp-Source: APXvYqyHmMwFj12Wr3DKtXac35BiQY8QXELQr9F/vLfC4yxKm19hK36C1XDf4ChOa9fjPiWufWSu7rmmYFKK
X-Received: by 2002:ae9:f113:: with SMTP id k19mr259393qkg.377.1568751366029;
 Tue, 17 Sep 2019 13:16:06 -0700 (PDT)
Date:   Tue, 17 Sep 2019 13:16:01 -0700
Message-Id: <20190917201602.113133-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [kvm-unit-tests PATCH v4 1/2] x86: nvmx: fix bug in __enter_guest()
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A575B55C8
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 20:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfIQS57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 14:57:59 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:54254 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfIQS56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 14:57:58 -0400
Received: by mail-pg1-f202.google.com with SMTP id j9so2563616pgk.20
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 11:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4S7/wfUBRRdORQOL8HzLDNrFII6NZGP9NSs87iEQGJI=;
        b=dgfCsN8cXfYnMLyzDSHD5sRPiVf/J13oZ/+EDolHwLnb6vq/O7xePnl1T8Q6gvgq5c
         eqRoHxCkus+ct8GtS52CofjODKVIv3sq3uVLuOUc0vDG+lYJI6MWUOEbfwJhaaZCc5P2
         EptVTB652w8K9dL5DmNzGb5nhp1K0S3jKvOrI41YmzRhvchfWAqFhpk18jZc7XmUrD8n
         g/K+nJWkhjwcD6qHNEktWt0XpZM9oF8nJVecEGP9pSXz+6sSp7bawYJdLG/mC+RxxDS3
         obQzEzx1wex1SPKeVDBIPAz5aY5Yx8I4kSnz0yvI1Cvk3WS1iwTFAJh+qHGNmj9u5Q4U
         odYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4S7/wfUBRRdORQOL8HzLDNrFII6NZGP9NSs87iEQGJI=;
        b=phhEJWAmcYzSdmX0pW82ZimdBWNpNL/uoeSqPAKiiYtqLLYepeH08TrT1XteHvnvwa
         PoHnj/lbuUhZnUu2Hnw7vp5ngXYNdlX4JIfpxT+OtEvIOqsoSHydFc5sArAOyJ/H/gQW
         v4x1hNUhotE29Msun1taM2p1/RGDsyHirKOV1cXyKouE8d9EASXzqw3hgbXd4J6jDpl3
         ekqYzipFPu/Y0gkY5cXwnkYUr9Q7I8Bo87qQorJP/swxSQgUZfARK99jXbKOWksV0GNf
         raAv4jWEYSHKeQbxU3WsWNyWzv9PVULpVmkt9Nv9N7twTcUDYte7QAWCfR27aleenNLP
         gmSQ==
X-Gm-Message-State: APjAAAUA+opERjhYNj17/uIIMihg4oHpLjfm1uKvR9UtyEe2b68+hMPS
        nWEb0GDE1SVYJI97r90vzveQ2VTDCWpXE0elM7DOCVOav0XYAivn1N6ZSsVhdOX+c0v3Mw+E+Cd
        gOfL9/DT+2/mSkNxZN8tV29PaSvtynhpbfuSq3gUff7MEn4pfp0Js7qoKy8CD
X-Google-Smtp-Source: APXvYqzKuoJV5x6zfHavf5YI3H7e/wI8+fl8XKqlyhyLaY4M3D44ha3MNDbzFoqUNiDLE6YRU0JgT7QP17Mx
X-Received: by 2002:a65:6294:: with SMTP id f20mr285699pgv.349.1568746677809;
 Tue, 17 Sep 2019 11:57:57 -0700 (PDT)
Date:   Tue, 17 Sep 2019 11:57:52 -0700
Message-Id: <20190917185753.256039-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [kvm-unit-tests PATCH v3 1/2] x86: nvmx: fix bug in __enter_guest()
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


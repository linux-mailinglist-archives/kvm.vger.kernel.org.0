Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28193BD60A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 03:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391004AbfIYBS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 21:18:26 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:55999 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390869AbfIYBS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 21:18:26 -0400
Received: by mail-pg1-f202.google.com with SMTP id k18so2464298pgh.22
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 18:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=G+PDXpZG3j8czW7fuE3YoYmyuQA+E6Wkrr/SlRmWll8=;
        b=LwfQYnvKBnFVa6RdgLaG3dNs3BVIqhmSmhBEPFNZNht/GBAI/oOzIHE3lwd9yveTQR
         FVhY2GLDTse8J2dHJFlWKs3BE8AqhmISHsO24UF4jJ2yI3zlo+ucaBb7fX3/WgVtcOJM
         uGCMazcpNGRM0lKRchlIY1T8n3zM5evMwH36WJwzyuupfsQiR68Zq8fRfxu5GPnX5UE1
         ZvmJ47H3NxcyD6ChOq5McK7IAC5wV4VYSlxA7EmvDRsEfCO6FPPweOKICqZzpUhFtn7D
         jYpNYTW11Zzsk4dBQdizRokAb22NmRRNPhtFacP+FbFSHtgPI+cXXbKwZ5lnwsB/sXmH
         Ugsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=G+PDXpZG3j8czW7fuE3YoYmyuQA+E6Wkrr/SlRmWll8=;
        b=TqOKOSV1CX2CaW1d4EZgWYOv7qqx3AzHL/jKGkMYil8KXed+Q3AvBUm6ODEr5l2RkB
         uLttdrsEmcpT59zn+UN0wB8swuLr3n22mmGLv1HIYxvnqLaWfl32hYND6Xt5V2oDxqat
         nBdoimcNA4m5nfmKciCSnjAV57E2gaX3+kq99p55zhtSaFehCjIEeXJAcmhsjg2KQUBr
         j17FgkfIHPtGKJ55yCcRdrZAUoItIfqy4ENlNrkhgngwrRbm3JydTfX4v0xWzb1Uv1ow
         awWlTiCkf72wIrHNbHmZF50Z6uzLX3pYMbAgIba+VX2wJx4Mic4S/BUBJedwonbgZviY
         yfLw==
X-Gm-Message-State: APjAAAVexLOiyAKd8W5hF4rh8Tl4RUN66MvbhF7CZGXOBNGpd+jatYLR
        AaC0pH0MgsutcQ4kuizVuQxGenw7KM2y7NNidshh6a5FLhC9M1hGRxQD6JN/3q2EPj61yrx4sd6
        ZkprxFQN/4aec6FgzRsWRdJ9DImR20+wL8IlwzaYCj9hUEisUsgCkc/ZG9rz9
X-Google-Smtp-Source: APXvYqwbddeU/C4Il3t9efyQP67aQJdyo77z9C9M7F86uv2+Kn7SDtl5FFQbx3W9tZuKfkNmE9PSvmFMfhlY
X-Received: by 2002:a65:628f:: with SMTP id f15mr6218457pgv.215.1569374305517;
 Tue, 24 Sep 2019 18:18:25 -0700 (PDT)
Date:   Tue, 24 Sep 2019 18:18:20 -0700
Message-Id: <20190925011821.24523-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [kvm-unit-tests PATCH v7 1/2] x86: nvmx: fix bug in __enter_guest()
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com, krish.sadhukhan@oracle.com,
        pbonzini@redhat.com, rkrcmar@redhat.com, dinechin@redhat.com
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
2.23.0.444.g18eeb5a265-goog


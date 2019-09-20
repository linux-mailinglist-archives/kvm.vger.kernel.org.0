Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C31AB99AB
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2019 00:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404299AbfITW3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 18:29:49 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:46954 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393819AbfITW3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 18:29:49 -0400
Received: by mail-pl1-f202.google.com with SMTP id k9so5331670pls.13
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 15:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0CqcLhT+oLR+DR0w+CJZZE5EZQRtfGXdhud+TXHnaZ0=;
        b=tB0gVAh4bcuHLG1fKCO4616SZbwq0b9sNdILRB3GDxhxDBL7jsWQlfEUmRfxq8aS//
         biMBUZdD9xE3b2rPCoZxkx68eGJcQoCc5SSQ4hWxjqyjzwYC2vb73GVlj5iU+21FnTMh
         3hLphxqAj32XncZGUDv1Pb1aIXDnKsN48eptcqtXjxcibdS2EMSCqewizDEex/Utbl6p
         OA3+SZygoKeCRSfpk8xxb11V3VVURRKl6DFudPf6qC3vMW/I+2Nf9WmQQIJYMtfQRZ9j
         E0BQOzEr6Ri6VCK4z0ZSS3hcweE7ioACstnRvp0yQ4yJN44LLaaQ9K9YUSWkJSWv4dqM
         5B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0CqcLhT+oLR+DR0w+CJZZE5EZQRtfGXdhud+TXHnaZ0=;
        b=iIiSt4ouKVkrd/H2N1sy465Q+NPgcMtSubnJXGdAieQH46HQ0CYezAeqr04ocJxl/W
         y7+7dfqabVX8VwtK9JT+lIrKOmY5tW8Y/bl+FNceIGfyQji9qMkslBZUKwpsXpXavZWX
         dl9Yc4Bb34sUl/k14w+3AKwLjc7Jy//AHxJYwVLn8W2Ov389hFI6syKYX8PcfezXaMoM
         CfQJL4RVA0M2JuGQbJWtiZvxwHVyptrPDMDp/7pPIMIyN6XxHbd3ck1R82tkofRDZl6L
         xHyajQz8igyxs1UabTl2J8OygdH24tPYmfYawD7YMIlQZMP905xHICwFnpafoszCuUeF
         QTJw==
X-Gm-Message-State: APjAAAURMhE8t4bb20Qd5I5SzmQP6zEb4zu0hiynE9i7YCBPqOopSaeU
        ubAdDYdCFs4saBQQTnarI6u+3sgH+VkkZhSoa52SVEQplL7B9IsBwKzVd0WVfzmHNNzaiHPNn7L
        iEBWNlx8qwR+4vIyka8dlSdcmHXG/Hqmg0LT7iWq9Ws0S2F2HG/PGrQ67D7zK
X-Google-Smtp-Source: APXvYqyrpgx0g8Tl3W83GbmPvW4SN4TMLPl8YKx8uo67vB5nZkRZw/MpGbhrr2SuBWz2ZHFUWqf1DoZUjwAX
X-Received: by 2002:a63:b70a:: with SMTP id t10mr18152759pgf.25.1569018588397;
 Fri, 20 Sep 2019 15:29:48 -0700 (PDT)
Date:   Fri, 20 Sep 2019 15:29:44 -0700
Message-Id: <20190920222945.235480-1-marcorr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [kvm-unit-tests PATCH v6 1/2] x86: nvmx: fix bug in __enter_guest()
From:   Marc Orr <marcorr@google.com>
To:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com, krish.sadhukhan@oracle.com,
        pbonzini@redhat.com, rkrcmar@redhat.com
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
v5 -> v6
* No changes.

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
2.23.0.351.gc4317032e6-goog


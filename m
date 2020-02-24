Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFF016B0F8
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 21:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgBXU2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 15:28:52 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:34871 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgBXU2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 15:28:52 -0500
Received: by mail-pg1-f201.google.com with SMTP id b25so5205331pgn.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 12:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7Fee0MJe75CVUNxUnX//8PMYb8v5cLgBeoeqeunSi1E=;
        b=FK/RPxPLKSX4XeteJoTIxSFPcOExcYrHvgIDSswypm3cFViRFGMTDjhCjEvqMWbO8l
         Ll2mEE7p11jz1HQE+JkReYGVvvKis5XlxJGLE5g5zCiLabZ83AucY7in813h5ySUyBM/
         A31XQejjUYNAeEMvR6/8RNXJw1wxY6T2KA0bd4QZoF+CaZgzYd3EfxLVgqGOP4W6uD4p
         c2uxRnCbvmHsjWyXhIQfKQnUmzNMJ9QWq1TI1hg9ajJHY54RyH8K3WmefbM50W0j0fcS
         QUAWk3hGYbdvUZfn5gAQRAJQE7RjVHJjQjiYa8JQLuaUuDW9F/lsEebts102z/OFsNCG
         01kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7Fee0MJe75CVUNxUnX//8PMYb8v5cLgBeoeqeunSi1E=;
        b=M1KMRpImJXnH1T4DxA1vI72bK9HDzdtsziI51iP3J/LuhAZ7A8ifhM30bfDSXJ//u0
         PEHfeQr59ABnztahLgBnBQqthC2dDZI7pCtdXe5AMM87Y22FX7xEQBpn6IhUUtafA1wJ
         T1JFco0TjRe2ZLX2vnFjtrKxhjmxOa2wfjI0uyGK0gbP7YZV6mJwkW231PERJszfrvjS
         HWJn4gVA1Rtc7eQiOQbSJSsc11Gzt1msgFVP46bhHklLjey9BR4lYu445Gj7ugryAspT
         OWY3jYAr3wc4/VSa5CDy0DlXo8947gebAZdD3sfl0Sa4MQg149Ng4p6FrRko9b+omsAq
         Lhog==
X-Gm-Message-State: APjAAAVlDh26UGqpKdJvmcdCqsOyCrX5AP+cXTtlcQTQEbRxn7Cur+Sh
        6fx4QJHbpQRaQOus6mN96T9+OBCkKD7XreS5Cj49C5wiUiF+0fPlRmquDPuVPphrqgWbUClosZy
        AU48o+TtaWaYbX36ZEA6JvBthFwqo+eQVBsIUlHMVqXFp824SG0ovWpQgNg==
X-Google-Smtp-Source: APXvYqznFg0G2Ryxr2LBw29a8dzFYY15AHH4Op3ch4qh7QgD8dhynrPwBa+6vGk86OCjP41zTRhG65wiMCI=
X-Received: by 2002:a63:8c12:: with SMTP id m18mr54300231pgd.192.1582576129988;
 Mon, 24 Feb 2020 12:28:49 -0800 (PST)
Date:   Mon, 24 Feb 2020 12:27:44 -0800
Message-Id: <20200224202744.221487-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH] KVM: nVMX: Consolidate nested MTF checks to helper function
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing
instruction emulation") introduced a helper to check the MTF
VM-execution control in vmcs12. Change pre-existing check in
nested_vmx_exit_reflected() to instead use the helper.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e920d7834d73..b9caad70ac7c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5627,7 +5627,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_MWAIT_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
 	case EXIT_REASON_MONITOR_TRAP_FLAG:
-		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
+		return nested_cpu_has_mtf(vmcs12);
 	case EXIT_REASON_MONITOR_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
 	case EXIT_REASON_PAUSE_INSTRUCTION:
-- 
2.25.0.265.gbab2e86ba0-goog


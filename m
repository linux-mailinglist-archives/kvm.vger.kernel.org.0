Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEE6228E98
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 05:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731966AbgGVD0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 23:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731972AbgGVD0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 23:26:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E57C0619DB
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i62so872580ybc.15
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z39UGLiwUBksk1towyRmeqgzcjsEShuupZsYnYVL+Us=;
        b=ak7cDqyBfwtum7YirsSYcXMi/XXBpW1wv4pViVn8uB+dL/zi55gVorj1IfVvBrmsqj
         t+xRloRGPoLsVRRTZWGeGqrGbyJRvt4Jr9cKM0LfGPmlqpEYpY1BLhll7MYwqMUUGNZ1
         1j2kGxeYe079zRExA6oBHfDfGEkbdqCiu5rUpb3xd8MFMePIw/07HlwtiWnn8TPzZiNI
         ehFJCUJ0BXhBra/6GYC12hYDFxlG67VBlfsuf0EnqKO7EEKX2MM9nYzkP6FLmVL94kJJ
         le8mW2AANdHvioCR5UdYv0ftbxHFb5eeRpEmhQAbmQKIMTegq0NfpZgLxp/9nF8FLWf4
         99zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z39UGLiwUBksk1towyRmeqgzcjsEShuupZsYnYVL+Us=;
        b=ji1gCXq157LP98G8gadfV07Y0Rn4k/FbL2M9lbeiVJ9v/B4Z9H0WWKIAdLP2WJ94jM
         8PMvqu4UpfYusnJxAyAbl5VwZifdbwVtnIhImf2JwYRJ4Uj9z4agW3JWEOFfXbRhpOsh
         Whs4sEtBC5y3yO9hqJHgj9QQ0ZslTVz+NTt3HdACXAeQfY9GKVVmcERzO62mZ5OegzBN
         h3Bk3sazEasOaMH7CtW/1M5DTRL+r8grDh6aBbXSm7ZJ6v9BKOUYZqs9BCpJ5sND5xk4
         NhRZJK0j5pK1AW0auJOUlsfyxXNYRepXZ0YEHdVpxQItrlipQxXzyI2s6cnaU46jnZ3U
         KXyA==
X-Gm-Message-State: AOAM532a9Lpi496XUkjytXmqo0vtYVatsiwnhH+Go6Fx/XhCgFL7Uuiy
        2Afk3VIaIfmHs6QT4CD6Aqoks/yIYVlH/vPOa+VZklbkpbjk5tu/qDTj3djDqlCPqQoK9/5Dbw7
        ezsCdh7mjEZuXwgFupKhsLOFGt2Z/HPyXMzvyEEr6Yaygds2HsDJQZ3zv2g==
X-Google-Smtp-Source: ABdhPJz418EnyI6rSWC9v/Q7M6CD8RP1CCUoyml75oEEA+PNGaO17glyQEPMbNWpwP0wvBwfUccYi9ObS/c=
X-Received: by 2002:a25:abc5:: with SMTP id v63mr46300513ybi.148.1595388407009;
 Tue, 21 Jul 2020 20:26:47 -0700 (PDT)
Date:   Wed, 22 Jul 2020 03:26:27 +0000
In-Reply-To: <20200722032629.3687068-1-oupton@google.com>
Message-Id: <20200722032629.3687068-4-oupton@google.com>
Mime-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v3 3/5] kvm: vmx: check tsc offsetting with nested_cpu_has()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2b41d987b101..fa201010dbe0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1775,7 +1775,7 @@ static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	 * to the newly set TSC to get L2's TSC.
 	 */
 	if (is_guest_mode(vcpu) &&
-	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
+	    nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING))
 		g_tsc_offset = vmcs12->tsc_offset;
 
 	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
-- 
2.28.0.rc0.142.g3c755180ce-goog


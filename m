Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290D2300DB6
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 21:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbhAVU25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 15:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbhAVU0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 15:26:17 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BDCC06121C
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:10 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k7so6582274ybm.13
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 12:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/ZkAZInrp/HESo6Je3L3thhbbn73G+oj93gKTic8EAM=;
        b=JSL5W7nZXPziV3zGpE/mSde9BrCmdj9Rm9RRUxVfwJV6nSes7XQJaRD5B+ukF9Gscj
         QGUuhyPUwbks7K2GPKJ3P9aFjDeeZj+AV9dCr2jLc2TbbgpY4vd4oheClqgtpPDxqXPV
         kzKsHeRUlqONGMlDzuTCvUrdRkuEhHYrT4/cmZnGtDPdsK+rF7tufCo2L7FU9gcTlQe5
         AmxEh7XZnMkwpzKVBvO6he6ncfS7DtDMXbmKfivYQvtvZHs5ALbCe8QnPrwEhnV8aIg7
         x/cbrNA4sk/0nLJvGK3+ZGbEdMJsqhmJRLwuZU5hDlxLnbzG3t/YVpF/wRXOj+1yxURi
         x2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/ZkAZInrp/HESo6Je3L3thhbbn73G+oj93gKTic8EAM=;
        b=mxhBbsiq5Ht49u/jZGHe99zrwCO9QaLzL5xqJXG0DVq+l3In9qY7IpDoWN7apS24f/
         VS6YiEfdUj5Cmdbm8ZQptQYITmTFA8IPyq1FC4A8ZQaC/pyj3Bg9qUeDOQGq+jCtWJZ0
         ijlD0ANKgvSyucA/oA2RFVZvpP45BWzzscyA3dN9CfK7oCKMk9mLtQrDj2m/KzZKsIA7
         EBAzbwPlB+IQfrqJ9de26mIRM+yqUeqg6TlD7Z5Rcbi2tJVxsCNMxN5d3gvsN+5ry6Yc
         d0JGrL2JLz/xz8dAzjI7ih+2v4vaI114WYreyvM2q65A4oD9aAM4SR7tSb4cmEQLIHLH
         8U1Q==
X-Gm-Message-State: AOAM531xP2klVOZ4m5aFxqtKMabUfjewUK9XkaD22QqUiIr5nkv0ITS8
        2RDrTt7nayLDQhAvDjQm06tWZSXtMlQ=
X-Google-Smtp-Source: ABdhPJzgl7GPOXMzWGgsV6KXAVBkpwgalvxlDoM3x732SF/RmPW0nbBAQOY6pDUrLTJEX+LArERlFTSD5t8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:5407:: with SMTP id i7mr9425875ybb.50.1611346929385;
 Fri, 22 Jan 2021 12:22:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 12:21:38 -0800
In-Reply-To: <20210122202144.2756381-1-seanjc@google.com>
Message-Id: <20210122202144.2756381-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210122202144.2756381-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v3 07/13] KVM: SVM: Enable SEV/SEV-ES functionality by default
 (when supported)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable the 'sev' and 'sev_es' module params by default instead of having
them conditioned on CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT.  The extra
Kconfig is pointless as KVM SEV/SEV-ES support is already controlled via
CONFIG_KVM_AMD_SEV, and CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT has the
unfortunate side effect of enabling all the SEV-ES _guest_ code due to
it being dependent on CONFIG_AMD_MEM_ENCRYPT=y.

Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2b8ebe2f1caf..75a83e2a8a89 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -29,11 +29,11 @@
 
 #ifdef CONFIG_KVM_AMD_SEV
 /* enable/disable SEV support */
-static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
 
 /* enable/disable SEV-ES support */
-static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 #else
 #define sev_enabled false
-- 
2.30.0.280.ga3ce27912f-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC00367736
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhDVCMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbhDVCMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E590DC06138D
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l6-20020a5b05860000b02904e88b568042so18220329ybp.6
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JHbuQrNkzeI4uiSZh8d5FcAVg1KlkglBUSOXfqeZhfc=;
        b=RnV4nf0LiQL9TsSTqL5iIWZhIEMKV0vCEiMQfxGopn+W1EJau7WDNvSYw531Bjir+5
         kF71VBrI1n5wZyA6QKlLy8+an8OhPh0ds04k0pCehyJ3QpOfjBMyVsut/xrv3FFtJxlC
         JEGfU5FBlBbEsLRzkChZmZbyIR8VFgOC4rlqIw/tIdqi52GvqrG8RbytSab/j19fEXBk
         B+6FmGM0L9/CExENZLIQ0ufNCtBLmouoPpu2S+rn4C9ufdMJOtCNHRR+PNdsIBy9JXDM
         D/CRJ8NO0D70Vo7Nc9bH4JqX6/hTvOERAFq0lIkNj5HvVAg3xB8AEfHoXmhGn5+DPRDU
         6ReA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JHbuQrNkzeI4uiSZh8d5FcAVg1KlkglBUSOXfqeZhfc=;
        b=nOiyBqzSfvCjL2i36c8tQ2IFnJFSPSQoXWvDjUSPqx6c69qjj7w1SY5ucY5h0CL1yk
         2dsrkRy90FS6/DYHstd080cSnJN3pc81OT9KCJaodco4645HknQQZvLwyfHd9C12otsd
         DyVESAPteH70NQ1q+x/m06ot8EFEee6/7t1aJrpT1QgwnvOK209Zf7qm/2PcypspD5At
         og07ybfRr4hA3vO6iAR4MMMF+hNF5/+KUR3bi7GpUi0xJ64UaFKFULEE/duqsH9w+6Wf
         w/jtdrnyeVhmkCQ9u6Rn9YN9UhssC1dkQGaUnNDXl5xpx1NECGSUUKC6qlcWYRMN8msX
         4L0Q==
X-Gm-Message-State: AOAM533gEeeMJ75S8SduWyhuypD8ZdNh4BE1Ms8SlCaDv1nv97B+0fuz
        po/S0oTJh/yNiRY55Zgs1pitBZFtcPw=
X-Google-Smtp-Source: ABdhPJw7AZDdGW1eVxKGQQDJ8spbCCOdp1UZp8R/ZFYEgoh+V9CQXsrVtgmY1rjouW2qNG6twxb0bQ12b8g=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:d44d:: with SMTP id m74mr1360567ybf.389.1619057508142;
 Wed, 21 Apr 2021 19:11:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:19 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 09/15] KVM: SVM: Enable SEV/SEV-ES functionality by default
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
index 2fe545102d12..bd26e564549c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -30,11 +30,11 @@
 
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
2.31.1.498.g6c1eba8ee3d-goog


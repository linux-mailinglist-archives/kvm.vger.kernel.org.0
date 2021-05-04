Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1C8372E9E
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhEDRSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhEDRSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:18:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C7FC061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:17:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so12566066ybn.21
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GQeYPNBasLogl534ND9Q7MqGb65bHRch8YH0hNcQgdE=;
        b=Ojd4yjrIuWqLjcbV/Te/47XOZv/fcPnbpUUqoPh30f3y+iIiXxDPItFNyUrNyDYDh9
         0iNgVWksjbSECQHZUKcdEhJPFncNrqDVrdGJwBXHUia2e34lFnP5Ip4hsPAmdJvd+RA+
         2i9yloFDGIZVo10i5Pp3hn/Z7G8jh/W6zNmh3+bco+SFOrOYqegQ3BQirXlgUSWXaW+X
         KitiQ0UW+swuGRkFbepxHXx2yzzXEaGvPsnRuUKF/cZqVWvSVD+ezisiIXbDPLDLVDjB
         r0t5vcEHZhRSGqZJja1qf7r11kzkptlCj6VgLav0iBk8LHrDVhmu54dicOvxlqKCstL5
         /Vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GQeYPNBasLogl534ND9Q7MqGb65bHRch8YH0hNcQgdE=;
        b=JdQk4Oz1itdNfI36NJXoYVWRvL2HywpUjKaipFHdWvGnwFIfTnJztnI/jjeAgYlGNE
         cSRSqcnElxcfp+Z3MU5wonRh1MXf6StIsyU0qmFmgjkyU7mtAg4YRo4Tvd5LCxDz0D+R
         e1s7LbdFhqIbaKopwdaEeOq2lJEC/7HfJf26eqWEdFFoN7qZ4R/6PRBGvdjQ26gZpNBD
         xXtz38n6DoUt7M4OiRhfrLcetZ8ycHMGJPvt16bTAWTlZFNnrACImKhn7t+YMjSJnVC3
         iW+VCfA2+hAiWYwDynFBQPg8GoDXvlNNICATmolrROl04sh8yQU8m3LLaR7mlyEXVo5Y
         HH0w==
X-Gm-Message-State: AOAM53153Q0RWdWOVfCQF6V17uwB4sFaSUEIao+P5iQX3t8pZyJsxMGL
        WfFXLMvGPDih92xwnWKUrPKAklddk0Q=
X-Google-Smtp-Source: ABdhPJxlSOlcX5fvKMS9Z8Y/32xdFNS3BueN6Hhz6HUJ3ejXJluoaat8wBgsB528Ps/FO0WpSewliWx1IYg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a5b:c52:: with SMTP id d18mr34112608ybr.401.1620148664836;
 Tue, 04 May 2021 10:17:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:20 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 01/15] KVM: VMX: Do not adverise RDPID if ENABLE_RDTSCP
 control is unsupported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clear KVM's RDPID capability if the ENABLE_RDTSCP secondary exec control is
unsupported.  Despite being enumerated in a separate CPUID flag, RDPID is
bundled under the same VMCS control as RDTSCP and will #UD in VMX non-root
if ENABLE_RDTSCP is not enabled.

Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 10b610fc7bbc..82404ee2520e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7377,9 +7377,11 @@ static __init void vmx_set_cpu_caps(void)
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
-	/* CPUID 0x80000001 */
-	if (!cpu_has_vmx_rdtscp())
+	/* CPUID 0x80000001 and 0x7 (RDPID) */
+	if (!cpu_has_vmx_rdtscp()) {
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
+		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
+	}
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
-- 
2.31.1.527.g47e6f16901-goog


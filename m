Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735F23A86CD
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhFOQrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 12:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbhFOQrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 12:47:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C841C061767
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:45:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 67-20020a2514460000b029053a9edba2a6so20813794ybu.7
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 09:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5J+F1+gxQZha6L7jPzTwe/D+QNbp9yn6LLcrwr/XuqM=;
        b=drwfA8kcFaRzbrcWSZiMY53wogCp0r4cbuqwGSVyDmm62d4DzVvu2oDlPCJThquOdh
         NAG28hDmlngWDfKSQjq/MqIJdwRKhii0+Fv1pqrzzxOJO/k4yThVQTWP/NGmAf5mY2fa
         CCMFRPY5xiXgsooBfHcQ/rI9jeI0YoONIg7x2t0p7zVX89yKBT4YnMjFwS19jrKAmP6+
         d1YBMcOowFVURwo11HbqVqu3BYzrSSUAMK7bOQZwKE15RqpCgALT1vOkuatGynv5dJK7
         vr4Qon0FqMAFC/zdR0k11kiyu5BsG1s9ugQ8amuR7PdODZHf9TM2G8rt/LRYVEDTkvMb
         9wEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5J+F1+gxQZha6L7jPzTwe/D+QNbp9yn6LLcrwr/XuqM=;
        b=dGsUgihda0647nANC+P5rYkfvbVybvCx3iYxk27T4Rx0r+RUfjoTF0z+lJmsp5IlP9
         NHL46Zd9xXgPlJuSFgp+ehfLk9K7L1+E4SkcfTRJ1dtsOQZYBJI7/S3zSQp1Wfm16TE7
         nNQUPKYhP1/E8ZKQySQM/9ZXdXZipptCNV44+9cC3mUrmMulBigFmSXBiLrXj4HaNP/X
         OCuKxO+60rqWghFgWuJuQBNkLwDp/bSRPQfMEEE9Uz+dekCTdpXqtWLNq7F0Ph7blup4
         m8M8pqpw184nrCsoCK64w01umfjg95kgC/YuHEF1DJben5TK8/yb9sDGryfFt4jQRUkE
         m6rQ==
X-Gm-Message-State: AOAM532T5jwScSHNK3YkHajr8KbOOfjbUb+r0MPnLndgoUk7ciKwgR5C
        QyUEMieUQfIbUAUs+LYj1/Z03RciAtE=
X-Google-Smtp-Source: ABdhPJyPNtVwD2fc2tl8zW5dgtxkBBd9ee5zBmohB9oc608IOyvT20yNJ0ZB8WAfwcAokCrjmIEJumna1f8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:13fc:a8bd:9d6b:e5])
 (user=seanjc job=sendgmr) by 2002:a25:b983:: with SMTP id r3mr104378ybg.238.1623775545321;
 Tue, 15 Jun 2021 09:45:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 15 Jun 2021 09:45:34 -0700
In-Reply-To: <20210615164535.2146172-1-seanjc@google.com>
Message-Id: <20210615164535.2146172-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210615164535.2146172-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 3/4] KVM: x86: WARN and reject loading KVM if NX is supported
 but not enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if NX is reported as supported but not enabled in EFER.  All flavors
of the kernel, including non-PAE 32-bit kernels, set EFER.NX=1 if NX is
supported, even if NX usage is disable via kernel command line.  KVM relies
on NX being enabled if it's supported, e.g. KVM will generate illegal NPT
entries if nx_huge_pages is enabled and NX is supported but not enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index acc28473dec7..1f6595df45de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10981,6 +10981,9 @@ int kvm_arch_hardware_setup(void *opaque)
 	int r;
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
+	if (WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_NX) &&
+			 !(host_efer & EFER_NX)))
+		return -EIO;
 
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
-- 
2.32.0.272.g935e593368-goog


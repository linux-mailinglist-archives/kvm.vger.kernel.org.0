Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F649BE951
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 02:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387510AbfIZAEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 20:04:34 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:48109 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387446AbfIZAEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 20:04:34 -0400
Received: by mail-pf1-f202.google.com with SMTP id t65so408173pfd.14
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 17:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=49oCgRcdkWxb62ErfpRG4ZnwP7arNC1z90JtyhRPLsg=;
        b=M8nvVr/rT4GKajhGPDgGHNuJtemvyDQKyIgEflDTM9r5posDFPDAhDgqpqPmihdqg4
         n0v0AKe+7pCECMeL8WhKLztY7R+N2SPr2w5iHeOyOgJVdSj9Idkyndq3sPrTLf9+n5Ua
         HOKIwJPj4dxaG+ROw6u/TCLs+4r5DlW4Fvbb2vn0NM4Ic6s04SKFOTQB8BmiiRmuGSGF
         AaFXHGBau+tT2OxvifB5YFmUOaHMbrQ3Rp5XNesrpKu5z2PIS0SdNnfLLlOmgSOdDaX8
         /6I+AX9EUc5KuIlTNkNYOYmYDaRx2Hy+M1PdhcPj6ihMTFAmxpjnYV7oSVYKxunvfPQp
         virg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=49oCgRcdkWxb62ErfpRG4ZnwP7arNC1z90JtyhRPLsg=;
        b=tGIcAhV+ZLJ+FMx5lAFBI5XQvUKsgyO1K8cstSHP5WNqRCg38ZQv9xDPCouuFtOqTb
         9FdhZUD6jbG5IVJYCvDsRm7QSFHeprK2ns/NTehXsPMadOqHgpl0jSQqv8DLoLja3RRV
         8zgrxjsP4xIfQa1b96tC1jm16b4cSiR218jNM0jBcwUnnfhEini45Tr4pRoW58b7c0tH
         MbCytopbYIXtCP0PAx+gG674W63Jds7pHN0OcGh8erK4ZZ3Taq/IfeA8T760TVHAEYr1
         yprKOxRyah+bQl4HT+tk841cDWx3BeWxVW3M5vrOXDekyUNPZXsS5iW5Oe7SbJIX1Uet
         9VjQ==
X-Gm-Message-State: APjAAAWu7ZzSzs53n401hcUqrmMbrUT6RfWSNrEOmNafrQvxl+/Pblfq
        FPFiefQzOjcKUcl1vdLyNZVq5T9elBavP1Z8p1MQvpLWnxmC+HsdmLy1DnWkL0MdcELuu/d7c93
        pvwqvrl2nnMwUVw1nWspIn9CExn0rBwg30BjBZ3uoHY3oHH3GSR7gBuc0tXYdT8c=
X-Google-Smtp-Source: APXvYqzHMXeXk+R4MexKTqekddc0zs/gRpisGmWPGWubNFmwXSBkPGfHS1rCFcmQEvovkGPBsmrcNMKmjVa46g==
X-Received: by 2002:a63:66c4:: with SMTP id a187mr521466pgc.85.1569456272991;
 Wed, 25 Sep 2019 17:04:32 -0700 (PDT)
Date:   Wed, 25 Sep 2019 17:04:18 -0700
In-Reply-To: <20190926000418.115956-1-jmattson@google.com>
Message-Id: <20190926000418.115956-2-jmattson@google.com>
Mime-Version: 1.0
References: <20190926000418.115956-1-jmattson@google.com>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH 2/2] kvm: x86: Use AMD CPUID semantics for AMD vCPUs
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the guest CPUID information represents an AMD vCPU, return all
zeroes for queries of undefined CPUID leaves, whether or not they are
in range.

Signed-off-by: Jim Mattson <jmattson@google.com>
Fixes: bd22f5cfcfe8f6 ("KVM: move and fix substitue search for missing CPUID entries")
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 35e2f930a4b79..0377d2820a7aa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -988,9 +988,11 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	/*
 	 * Intel CPUID semantics treats any query for an out-of-range
 	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
-	 * requested.
+	 * requested. AMD CPUID semantics returns all zeroes for any
+	 * undefined leaf, whether or not the leaf is in range.
 	 */
-	if (!entry && check_limit && !cpuid_function_in_range(vcpu, function)) {
+	if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
+	    !cpuid_function_in_range(vcpu, function)) {
 		max = kvm_find_cpuid_entry(vcpu, 0, 0);
 		if (max) {
 			function = max->eax;
-- 
2.23.0.351.gc4317032e6-goog


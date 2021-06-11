Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1103A392A
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 03:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhFKBMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 21:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhFKBMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 21:12:40 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244BAC0617AD
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 18:10:28 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id b9-20020ac86bc90000b029024a9c2c55b2so977541qtt.15
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 18:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=g2jclRA9lTw/W97XJiMf53LRm15IYPw+1SChqYyccDA=;
        b=aLM0Vaaz+cyTp51TN8IDMX95LliI5Z426gW5UybIuMeG9DDvhdCPohwjwrhyx3S8/1
         7FG/7DB3hYJ16PkBgqsjpp07ivB3cYL24UPNZwRe0Z3Otz+ZZlym2BxyJ1yLfpaEnYET
         /GtXpFNEH1nyvf7pScc1prfSlHF04N5cTN9ojF1F2eLacZ2w/3bAIr4D/uUbCVkeEKOS
         a1DvdIk/xS0CHavMi7D8VON+bJzAAFJQWgX9DWB+FCSE4F09/NbsGNUXBHSxsCRdbt62
         Iv8E6Z0YvxCWQQTxjs/y1IHD+Bf9P1SrrZpqfba24eR9wlZAnB3z3iiFsMgeoOvkhoRM
         e+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g2jclRA9lTw/W97XJiMf53LRm15IYPw+1SChqYyccDA=;
        b=kbW8Oi6Usj4ZNX1+9JeCnTyuCrAsS9ckvK1xR4d1FwYSoxnuRsHNu4cleEpUURQK6g
         XDoZ+XByczhr/CQ+0KV3CRaYX35JCegCVcKJ90qCCr8HuAQ2C6L4JlGOjpXJqfYhOF86
         HUGWCy4nO4Hed8ygC5hJQG/juvfytlApvAGDr377HKCIyntEf9aVy2i6DYp9MNlbZEWi
         ahPZtj+Rs8DgvTrr0JMak+8+ToD837QBrIWHfxJBQj01fb7MaiNiLR1HM3iSdgCGnvDU
         00nGK+NCsgHUcsT43G1ByA5q6x7hERTW8114JBePqRg3omS6tRYrb4i+S4eyUS/5z8MS
         pw1w==
X-Gm-Message-State: AOAM531vfRaqbWTbeZJV8yVmUFKkR0rwPbjlpnrzEj2VKS3+HQTsg7fu
        khnyzpQKZ7940FIEVx8NqYbIOASBdc/TNkO4qteYsEZEJmFWUVdTInyV1vMSbIttfvAQdXZH2tm
        wJFU5Ycv8XcXCpbGOz2ZIzGu2BBE/NEgw0eMrqYu212ua86OrdLV79nrnGx1yjL8=
X-Google-Smtp-Source: ABdhPJwS2FaokvitUzUEJhjnFOTvGpUM0p0dmA7rKoXpD9NblRj9EjqQzR8QSlMKVNeHfOQpz47kYBdAtVFv4Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a0c:e047:: with SMTP id
 y7mr2400895qvk.46.1623373827053; Thu, 10 Jun 2021 18:10:27 -0700 (PDT)
Date:   Thu, 10 Jun 2021 18:10:16 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 2/6] KVM: selftests: Complete x86_64/sync_regs_test ucall
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com, vkuznets@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest in sync_regs_test does raw ucalls by directly accessing the
ucall IO port. It makes these ucalls without setting %rdi to a `struct
ucall`, which is what a ucall uses to pass messages.  The issue is that
if the host did a get_ucall (the receiver side), it would try to access
the `struct ucall` at %rdi=0 which would lead to an error ("No mapping
for vm virtual address, gva: 0x0").

This issue is currently benign as there is no get_ucall in
sync_regs_test; however, that will change in the next commit as it
changes the unhandled exception reporting mechanism to use ucalls.  In
that case, every vcpu_run is followed by a get_ucall to check if the
guest is trying to report an unhandled exception.

Fix this in advance by setting %rdi to a UCALL_NONE struct ucall for the
sync_regs_test guest.

Tested with gcc-[8,9,10], and clang-[9,11].

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/x86_64/sync_regs_test.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
index d672f0a473f8..fc03a150278d 100644
--- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
@@ -24,6 +24,10 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
+struct ucall uc_none = {
+	.cmd = UCALL_NONE,
+};
+
 /*
  * ucall is embedded here to protect against compiler reshuffling registers
  * before calling a function. In this test we only need to get KVM_EXIT_IO
@@ -34,7 +38,8 @@ void guest_code(void)
 	asm volatile("1: in %[port], %%al\n"
 		     "add $0x1, %%rbx\n"
 		     "jmp 1b"
-		     : : [port] "d" (UCALL_PIO_PORT) : "rax", "rbx");
+		     : : [port] "d" (UCALL_PIO_PORT), "D" (&uc_none)
+		     : "rax", "rbx");
 }
 
 static void compare_regs(struct kvm_regs *left, struct kvm_regs *right)
-- 
2.32.0.272.g935e593368-goog


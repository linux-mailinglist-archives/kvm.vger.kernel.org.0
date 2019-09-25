Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F6CBE481
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 20:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408531AbfIYSRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 14:17:25 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:35916 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408520AbfIYSRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 14:17:25 -0400
Received: by mail-pg1-f201.google.com with SMTP id h36so284574pgb.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 11:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SyIb+l6pQGF3TyBgzUjcF2mQipF7L2LaiCzGb8rB5Aw=;
        b=FA5uQ8Sg5EGdUz9kmzCTzZLwXWJQct8nVaYWVQFIlVIJ9T4jSoxgJLMK6e/EsJhfcU
         GF17PMNBNZdypDUxDjBPh1ube6c44x9WHDDv7jFdx4ZHRIPLw0QK7nUA9/AHHpzgsxXm
         xciHcx2U0fmzDq1HGt8CWC/j/s/upgNVmZ9wWCvu8RgZYNVrWTx055rQZJbke+PtPaAH
         VUzEHQ2XHX73sqO4aTG+S/8EZvqpbYGVgNloCp3onAWN+zPPxj4j7iN/QxZxzj7Csk3i
         z3/WD6nJ1Hg+CVv/4F3Qw1ljbruaKfGWFRKU3VrItgC+lg2flirIHgP/GdX/9NAPnm38
         qC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SyIb+l6pQGF3TyBgzUjcF2mQipF7L2LaiCzGb8rB5Aw=;
        b=KsMdEYddDOtwuq75zNnfSsFlKBWXhAbbhnJ6gpA0ybe/tnZbklhNlPgi51NRp0hrxq
         Ihpp+p6DhXQHkHw9jS4CoH6710Vb5CKK/6QpgDcjSFNSqXniU9LxjlglGhXt7XtPNwEW
         jEBcLxCCYmYOY/CBQdGWN36ur1zMPL1v9xnzdF1udcAI/23q9VOGGIEoG9Tq9xiqrraF
         DSwDM1DtjkFXu5Hsr+iwNCJ6h+S1MKYNW5kIV2lF6caGB8WGpfMZl8JCuom039+UzrU8
         t6Nqkn568JBGQ5oGwt1s4COfLWy07bg8FqmIXlB76UVZ7q+LXGNVapJgc+X01PaWeJh3
         7fFA==
X-Gm-Message-State: APjAAAWgzo21O5C03u6Yyv9SGDHnq/pF9Q0EBF5s9W7Zp8ow5c7rp9II
        UKkTW+SOxxjtEeMbTNdUcOszgzJE9Cgg4BV/VlOWpfuVuST4S8EenMuAwkrQc6a1a9bbxkRbwOm
        P2KwPmthJXoJPqrZysUBmjS7scQngiLbyXCqD+IoSiN1p6AnSTqr5p9w5U1BeE5g=
X-Google-Smtp-Source: APXvYqzSsNtFCy3OhX0L6neA3KUUrNJUSqy6n0WIUCe68IEbtZ2iHW9rBPgtZV49tk0GqvzqWUnVmQMKAWFM3g==
X-Received: by 2002:a63:fc60:: with SMTP id r32mr697346pgk.160.1569435443997;
 Wed, 25 Sep 2019 11:17:23 -0700 (PDT)
Date:   Wed, 25 Sep 2019 11:17:14 -0700
Message-Id: <20190925181714.176229-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH] kvm: x86: Fix a spurious -E2BIG in __do_cpuid_func
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't return -E2BIG from __do_cpuid_func when processing function 0BH
or 1FH and the last interesting subleaf occupies the last allocated
entry in the result array.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Fixes: 831bf664e9c1fc ("KVM: Refactor and simplify kvm_dev_ioctl_get_supported_cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/cpuid.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dd5985eb61b4c..a3ee9e110ba82 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -612,16 +612,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	 */
 	case 0x1f:
 	case 0xb: {
-		int i, level_type;
+		int i;
 
-		/* read more entries until level_type is zero */
-		for (i = 1; ; ++i) {
+		/*
+		 * We filled in entry[0] for CPUID(EAX=<function>,
+		 * ECX=00H) above.  If its level type (ECX[15:8]) is
+		 * zero, then the leaf is unimplemented, and we're
+		 * done.  Otherwise, continue to populate entries
+		 * until the level type (ECX[15:8]) of the previously
+		 * added entry is zero.
+		 */
+		for (i = 1; entry[i - 1].ecx & 0xff00; ++i) {
 			if (*nent >= maxnent)
 				goto out;
 
-			level_type = entry[i - 1].ecx & 0xff00;
-			if (!level_type)
-				break;
 			do_host_cpuid(&entry[i], function, i);
 			++*nent;
 		}
-- 
2.23.0.351.gc4317032e6-goog


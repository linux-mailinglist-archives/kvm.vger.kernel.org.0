Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C51EA51D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 22:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfJ3VEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 17:04:42 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:49380 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfJ3VEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 17:04:42 -0400
Received: by mail-pf1-f201.google.com with SMTP id r187so2678555pfc.16
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 14:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R5YsaR9bKKV9fNP9YXtzeLSXtxZmX8iRMZjNRdp+oWI=;
        b=m+cB/6qw1KFnvVJTUAVjF63cRK+2BS5naiUQ/mPU3UB1puPunOF7RogUGah/bOmqKf
         mWgFO/3eVEQatwHCUdsyAph8CD7LNxR9mzp/mKaMYe+z3OPNsGY2fH1TVXgDLrvVrMGa
         DG6SSaVzJ06IV8bv+CJ2ETTHsF/Zqo6FqNNt22gY4ZbV76mXon4sADKkjBtsWOlt9gZd
         Ygzh3o9zPwmOiMULDbxDS+2W5CHoSZAZqLrWKJOKR8/u9kq258EN6Vaa/4mASV5xsQhN
         yBfVUifHg5qHH/17yIO7Rq5SbEDsYBegSbxRty0yAHDlS39gXtKqiUPeF896BKbPO79Q
         EahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R5YsaR9bKKV9fNP9YXtzeLSXtxZmX8iRMZjNRdp+oWI=;
        b=XErjjI+qJnt/Eo6IyAz4cX1UQ5a9FMrE3wE6GtG6/DKxrImJvmB9zJhQ9RVpsRV+yw
         RJOal53HLlkdpkHXMd+Qs9T/blURE9FHWsfuKmvjScZudWZdpDmGayN2tHef9dDsVugL
         DS7c9FNBumLHFrzFRPU6Id5AnXvAlQGHe8AtiDPAlaAW3q3Zcev+DsqlakokgnkJZLdM
         KXcj6Voe6U6R/wwjHzT6P8zHyX/QrWcj/6Fi2wc27NQ7QfzUf8ACe5RAHOp7qdzESs/7
         omU9EzZ6zhx8/ofVkTEO8TJ7Cz6sJKbSI7YPx/f0yVjUiwW0TGeH0M7LPX6HGQQ+Cdsh
         6VXA==
X-Gm-Message-State: APjAAAVkiC1v+S8k+pVkzEJnvr+fQmaDX0H1rE8RwThRAswbWync27oN
        +bYxp5QtHfY3CYvMsfyWcCTF8LMtY/jPbcR3TuULv0zql1MMLONotQ9iZS0Rfw1ojV5tgPg+KrJ
        P716VgSJgMwR3RnfTDP+4MSfTU7eXOHFa4eM4Y7cuDRDgqjkBiuFr7g==
X-Google-Smtp-Source: APXvYqyF447WabAiYT/xTJmpjQsFAKB55cNNHE+8uaKTOBhkKbYeg72WGZF+ig55ZS5vp8vO+JQW4J5+gA==
X-Received: by 2002:a63:234c:: with SMTP id u12mr1562056pgm.384.1572469479458;
 Wed, 30 Oct 2019 14:04:39 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:04:18 -0700
In-Reply-To: <20191030210419.213407-1-morbo@google.com>
Message-Id: <20191030210419.213407-6-morbo@google.com>
Mime-Version: 1.0
References: <20191015000411.59740-1-morbo@google.com> <20191030210419.213407-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v3 5/6] x86: use a non-negative number in shift
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shifting a negative number is undefined. Clang complains about it:

x86/svm.c:1131:38: error: shifting a negative signed value is undefined [-Werror,-Wshift-negative-value]
    test->vmcb->control.tsc_offset = TSC_OFFSET_VALUE;

Using "~0ull" results in identical asm code:

	before: movabsq $-281474976710656, %rsi
	after:  movabsq $-281474976710656, %rsi

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index 4ddfaa4..cef43d5 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -1122,7 +1122,7 @@ static bool npt_rw_l1mmio_check(struct test *test)
 }
 
 #define TSC_ADJUST_VALUE    (1ll << 32)
-#define TSC_OFFSET_VALUE    (-1ll << 48)
+#define TSC_OFFSET_VALUE    (~0ull << 48)
 static bool ok;
 
 static void tsc_adjust_prepare(struct test *test)
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog


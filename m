Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BBDD6A0C
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388698AbfJNTYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:24:41 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:32784 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388526AbfJNTYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:24:41 -0400
Received: by mail-pf1-f202.google.com with SMTP id z4so14060799pfn.0
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 12:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XTuI7th3+9dwO3nKtBiY4qgOMbcjEb2zppHYOAbpHRc=;
        b=pKZBHc1sL0Aihc9J58KstqL1tdK75TYWZt7T71dQgixvTRjPWy9eR23YCkK01QQJPB
         R5KoV9l0kqeqeBua/Z4Qdf+BuSOSU14p/a7aMs2abKFLIbttKmOY5UwaSPSPgrGpfIp3
         d/cnBJgGdm+w47On2ZNxE5ANbC2gVOKM8Huh3JlTMV+34cpcn1OCVZcd+ggU5cmA5xjs
         vGDi3M1x6uv53yUXXqSOQhl4yC6QSQOqeHSHJBTElArrpVa5p82ru3AtNpjdB3EYbCzN
         cPLrQnUuTD68SaxxmPD8FrfmhyQIlbSDPO6WZrbcVLRX6x6DpEPNsfxE3XQCd9Z++jpE
         w9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XTuI7th3+9dwO3nKtBiY4qgOMbcjEb2zppHYOAbpHRc=;
        b=WOjSIWoAIDloPSjXReMQ4eNm9KyYnXD8rFgtAEcEOvDyfux4P8DEsDUzdCPOIyhPiT
         KAqjT2kf1T7s9X2+jC31t1258Fn/s3fDQbHYPDp0FUvVOTT/T6iPinlb9jblu+r1ddYp
         W1FB25V17WIxC1p+eN27QjBvCUjmBjIocMkems7pYrkpjfBNYoNEeo5u0giCh33y2kSf
         DdXO/KjWepVa6d/6Jou68dE5lM4KFeM73GfkbK3y+Zi/CaBtKQp7GVZ8ESc2uoKx39Dx
         CZRiyxxKS32+48O+OCh3ucZXk4FswYXtJX6JGUwEQSVEPxVaekL6vsgjFtbFP/wpRJgA
         FVbQ==
X-Gm-Message-State: APjAAAXWFocgWlVM7g184AESWNOTryMa8Pa4zNcbfkGOnIOk//hmWe7x
        qq3h/N2AqUH1mYZ8dD4pQJky8cphIzvvUiFHFYXn3jXWzEdCAtbw2P6+i/Cr6qGWwvWpxk2wjhC
        8qLgNIR9OD5Czym6TyuLyqhiKe03kAjXpR6CuvJKoIfSOtLwScm6ncA==
X-Google-Smtp-Source: APXvYqxCB2n5bex1Ri2jT7GzX+W5F0ZSg6NXeJUsVz8u3rrbkJVfjA+XO97PtqaauyILz5uDxV2w/LEHCA==
X-Received: by 2002:a65:4c03:: with SMTP id u3mr34809021pgq.440.1571081080141;
 Mon, 14 Oct 2019 12:24:40 -0700 (PDT)
Date:   Mon, 14 Oct 2019 12:24:28 -0700
In-Reply-To: <20191014192431.137719-1-morbo@google.com>
Message-Id: <20191014192431.137719-2-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191014192431.137719-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 1/4] x86: emulator: use "SSE2" for the target
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The movdqu and movapd instructions are SSE2 instructions. Clang
interprets the __attribute__((target("sse"))) as allowing SSE only
instructions. Using SSE2 instructions cause an error.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/emulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 621caf9..bec0154 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -657,7 +657,7 @@ static bool sseeq(sse_union *v1, sse_union *v2)
     return ok;
 }
 
-static __attribute__((target("sse"))) void test_sse(sse_union *mem)
+static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
 {
     sse_union v;
 
-- 
2.23.0.700.g56cf767bdb-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1EAEA518
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 22:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfJ3VEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 17:04:30 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:39253 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfJ3VEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 17:04:30 -0400
Received: by mail-pf1-f201.google.com with SMTP id l20so2696506pff.6
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 14:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=upjAEuFJdt1TLpNgpgQupJ9CCvCrQ2wU04Vj0IjMAHs=;
        b=gXb60jE9rGGecCIJUp0YW459p0D2wHyP/rhiOgFm1XwVu9qHHVDofMQ3kAvjwZGojt
         133ZLoNs5EhAuq7l3t9SumssAKOLIBkUNTjsplliseIog+g5BAF7/oJfQy1uDiBVyI6V
         53tEBdpjDOFEsH5qvu/EyW2lXtWWaedAX8wqDwZPbjQsKhFIlw7M/kby5cyTcr4VC0Wy
         KFUShzJVp3GdRkOKpGgzgl3jha8A7Jtr8fAN5LVrHu+VEZWXn5+yT3V1tdrGkR2wykCd
         22Zm13a8sSTpzLoYSrTYkXNPmoISoY5jtIn9GCb3aBfM4cU3N8KW0GJ6BqWgLffIunVK
         yO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=upjAEuFJdt1TLpNgpgQupJ9CCvCrQ2wU04Vj0IjMAHs=;
        b=luPHG9HHe/zX5DogU3Mh6H9cHUpe5Ph2w6PRFEFeEY98lAfKVjTqNGxvasBuQBXLyt
         +FM5E2aRX0oMfRoF6QJkOBlnixyInwgDCjENZ/ltExd2kAmsvqvH5rzDFBfhQP0I5gmf
         R5O46V+NHOSw9HFNdvqw7Tk8mMjQcyA+qGrFO1wyroPM4jc+zsAQFc8otOkkyVZVgvjj
         T8yOWTTHzZBWUW4CFr/ptoX1ocNEw/qiD2VTaI3N2pnYARmMVv7QeI0V5W2KqxFIQId7
         gJIOHYwtRsWR+5SACQTm5SqkOXZfQx22XR743CjGMTJyDVDNqJdiMBYUo9MYHkTWmvEi
         leHQ==
X-Gm-Message-State: APjAAAVxjR+G1iAcyKtfwJhhkFen4Gj93cp0P122FQzGlY3Nbf9lrdGo
        hVf5EZ0O1n/aEONrf3bjk78DrSR1gRQtY55HC7i+vvsXN3obNkUZK3XI1RjmhlEgaBWdhKVzJxT
        gcHoGiaH2WsX7gbah2AgCBbf+qjeCiC6MQ6lcSOBk8Mk9gbRdrm8jXQ==
X-Google-Smtp-Source: APXvYqz6psyX3VnEaTeKsc1C9it70gfs7BJaF/5WPERV1ZPXP7aD1wIeieT5JBHtPkGK8fDvKQMfwM3QkA==
X-Received: by 2002:a65:554e:: with SMTP id t14mr1606165pgr.370.1572469468375;
 Wed, 30 Oct 2019 14:04:28 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:04:14 -0700
In-Reply-To: <20191030210419.213407-1-morbo@google.com>
Message-Id: <20191030210419.213407-2-morbo@google.com>
Mime-Version: 1.0
References: <20191015000411.59740-1-morbo@google.com> <20191030210419.213407-1-morbo@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v3 1/6] x86: emulator: use "SSE2" for the target
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
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
2.24.0.rc1.363.gb1bccd3e3d-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B27E5AE02C
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 23:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbfIIVJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 17:09:58 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:41554 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfIIVJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 17:09:58 -0400
Received: by mail-vk1-f195.google.com with SMTP id 70so2171492vkz.8
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 14:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IUKaCUxjYc5VcvRzjcVT6xODxoxaXR4KZGQsmHyhhiM=;
        b=WSu0jxdmORs+9mSLcb4D2+ZNSYtAfNfVY2E0+MTf60v37RGn//6Ojef19CC5H+LXD/
         YCvcLCrFai/KBaddWH0F4VXzEyN1BD0dxBN+y0KLiNp2knRSjYsnGC7KOJ940zAXoqv3
         hylYyO32YaX2Y3zlxz/DgNlX1FmjiAKj62KCAmwSd5MB6y9MaAaVvG1W6xW6Hw5wvPqb
         NZITi4gsbfnyK3XKvyd8spyV1zMb3Jufpmtd343wvjXppLGFMHnOtCYO4Wifaqx3XA8b
         h7mMrP0FKPelCVKa94rKfP5xJb+kMCUbBR2oZleOhs/l9dBWg7jqbGj9bQd1zB7WIq9K
         QbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IUKaCUxjYc5VcvRzjcVT6xODxoxaXR4KZGQsmHyhhiM=;
        b=ZekU4hKbGGdhB2ePUFkzaitmSPFzt5o0/R9vcAUpjVQGRQICVV7fXb/kxq0dl42nn1
         fn1xc1iS4ObNVxDZKxiMPmepynwrIYo1Dnz18neKcTHQuOaKeylnIVGgcPhGbdT8QODQ
         4N6bvTTQMeRR17zu+m8kePeMKNvgeCUkuFoYFDb5fbu9nBSc4moCzdpKPODqx3OJsau1
         2vtLB0oFljm4Uqg04qhRwx2fcmgz+VIDu+ppc3+zc1LR4p3fQEvmKdMJjlOU99FM3zw1
         T9xlKnWobrAo+JNOlAmorIl9Nis5gTaIH5XZ18ccIGePdyQo3JcDJMzfeTPL/j8jvAgn
         3jpg==
X-Gm-Message-State: APjAAAVpgpwc9LUKTOVReZPHo8NosTHYv3y0PxlMJ6ZcxlyMqMPedxEj
        /1WoaNehKG21ndqisrSi2OhRkIISw2Nj9BK4KY71lzr+CDqY
X-Google-Smtp-Source: APXvYqz6iuI0gHDPymXkyuF36GFsOXPnaOj7f1ySw5rN2X+wZ5DTN7ubaQKok7I1pyA5NGOVo9nWeAI0aFDOt6z2Agg=
X-Received: by 2002:a1f:3cc9:: with SMTP id j192mr12284618vka.58.1568063394809;
 Mon, 09 Sep 2019 14:09:54 -0700 (PDT)
MIME-Version: 1.0
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 9 Sep 2019 14:09:43 -0700
Message-ID: <CAGG=3QWNQKejpwhbgDy-WSV1C2sw9Ms0TUGwVk8fgEbg9n0ryg@mail.gmail.com>
Subject: [kvm-unit-tests PATCH] x86: setjmp: ignore clang's
 "-Wsomtimes-uninitialized" flag
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang complains that "i" might be uninitialized in the "printf"
statement. This is a false negative, because it's set in the "if"
statement and then incremented in the loop created by the "longjmp".

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/setjmp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/x86/setjmp.c b/x86/setjmp.c
index 976a632..cf9adcb 100644
--- a/x86/setjmp.c
+++ b/x86/setjmp.c
@@ -1,6 +1,10 @@
 #include "libcflat.h"
 #include "setjmp.h"

+#ifdef __clang__
+#pragma clang diagnostic ignored "-Wsometimes-uninitialized"
+#endif
+
 int main(void)
 {
     volatile int i;

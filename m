Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04580D6C59
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 02:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfJOAEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 20:04:21 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:35913 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfJOAEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 20:04:21 -0400
Received: by mail-pg1-f202.google.com with SMTP id h36so13764800pgb.3
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 17:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XTuI7th3+9dwO3nKtBiY4qgOMbcjEb2zppHYOAbpHRc=;
        b=AfQKpBPqVxVR2G3jH4Mlo8pegG6UJSeiv7z9GCBcry/fq3zmZ8zQUloTMGWfrhsl3M
         cvnYmJrwRmhPxuar7QmF+nJE3I5oOtjaFeecMtaxJ62DPuDf7Zwqt9uNt/7A9H2jPjf6
         nQjCJsGuHzjBav5o0KrOaHl0rGV+Lp67Teo+MFmDXyUx0vZ9+LeD5tqkUYZiEcrUfa/C
         YQQMEhutnU8ooSmScr5P+4i1cuusbZHvol3BCw59inHo9xRIw04ltsY8JBPmqPgRSwOP
         Mg5ILit4LQhUmWWa3tfxLunohk+AICIwV63bi5Y/grf7gjtQ7hyV73Rwt/OYZ/q53LBW
         QhiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XTuI7th3+9dwO3nKtBiY4qgOMbcjEb2zppHYOAbpHRc=;
        b=A4dsUSQI/X7gMuFCMinZV7TulIv6evYZAanpDugJOLpmY/RtJFAv4VS+wC46X0AJqw
         124RZkCejdHUXtzy3daSb4MFGrSFOTKNEE3sP3B4+3Tx384A7nDO0YfTlFFRLho/cccT
         1j5h6fI0XfXPvwm1/fmH8nXeLH+exjxduCqG9eGwzzi6EVUTrRm13y3VX5+O7iIy8Mqw
         wRbzGxacIDsSgrsFo26nIDRQxAZe4FdZdxm3szs5gnaXu2R+07SlRhaE7WvULnr7lM+E
         vhiWEFuNtU/+O9igZlwQwXEEppt3qWXHjDnvmsZU/G1yy90jEbXB2i8i7ye4dLMhvcVu
         kXWg==
X-Gm-Message-State: APjAAAUGEAxWJhsDainhDQtfYrwyi5vx+0P90FsZLIhTYJ8j2A+P1Pve
        3udQEMwTuC7lUwJjz9AW+XM3J2HBJMxwkzBcZp3mNnk787qKUafqpQvrU8j1rd/zU9aBtovjpv0
        bpw5w/v0EEh11qrDPa0QcRvn70S02mJnYAIL361gaxT+afTY7tqu07w==
X-Google-Smtp-Source: APXvYqx8bfPydciDwflNH+VlBKlpBk07ttlrWJioJiuXHGiOlvJmY2hYSiXQ88lZT4UBRGS6Tcy4f64yRw==
X-Received: by 2002:a63:1e59:: with SMTP id p25mr35134433pgm.361.1571097858628;
 Mon, 14 Oct 2019 17:04:18 -0700 (PDT)
Date:   Mon, 14 Oct 2019 17:04:08 -0700
In-Reply-To: <20191015000411.59740-1-morbo@google.com>
Message-Id: <20191015000411.59740-2-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191015000411.59740-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH v2 1/4] x86: emulator: use "SSE2" for the target
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


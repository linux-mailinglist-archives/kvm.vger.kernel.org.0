Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE480BD362
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 22:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfIXUPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 16:15:01 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44549 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732269AbfIXUPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 16:15:01 -0400
Received: by mail-io1-f65.google.com with SMTP id j4so7604831iog.11
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DI0egddMaTlmXPpI6j4ITK90qBcGxWnZ/Lc990IvF2Y=;
        b=JTMndQ+nYpdyNF5MJOGWUHZv+QevSaM0HzuyG4IdtM+xtvoSK1XA6X5CBcgkwcsFmA
         3GUTDUHSWAunyQPQX5jfxq+rvzj+h6POMg142essaWiGeLpd6xri8wEzS2VNPNctGHcg
         +xxXg9XTK7XRkzjGWbajAgkQlVoz2vQx7NuKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DI0egddMaTlmXPpI6j4ITK90qBcGxWnZ/Lc990IvF2Y=;
        b=a8VSIe7inf0shLOtOBtLKnAtiSFBpTJDwvO5ue0sxm2mi5dDWu/lcaZp4YryScK5gM
         b8Pn6whRr9dLxSipcTZY2YuAoCnK41mTukMbMO4875NiPzzt5x/cUaWo67Q1hk6VUln1
         ArSVF6uERgbFqilYxKB9c0Aez95ovJaTxfvmoogFufgZcmetHvRjucl7QRN+cwdqQigC
         CncsE6pr3fVde7+Y3I1/dXCXOmchzsrEp2JKhvRgATQbLhfb5Z7Vtwe7s336jYPKc2C2
         2SEowzH64meC7s/SD9vE43HVzCfENYtgKRy/oeCUbDDx6NRiKKspyoniAGworMbjfM+W
         bWwg==
X-Gm-Message-State: APjAAAVKopMId+pA6RZsIpVzfX/fKyQK/lLQ8HTWcYM9/x9YS/GYyLbj
        qes+bM5lOJNqiGYd3Beu/YmI2w==
X-Google-Smtp-Source: APXvYqxn6tRAr9RxU9eibq7Mfj2KW3OBHKsrpfR/gHKH+DusHXd6HU+er1lZb6yRz3aWg8YmGuURRw==
X-Received: by 2002:a02:cd8d:: with SMTP id l13mr744030jap.138.1569356100138;
        Tue, 24 Sep 2019 13:15:00 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b24sm2007733iob.2.2019.09.24.13.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 13:14:59 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, shuah@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: kvm: Fix libkvm build error
Date:   Tue, 24 Sep 2019 14:14:51 -0600
Message-Id: <20190924201451.31977-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following build error:

libkvm.a(assert.o): relocation R_X86_64_32 against `.rodata.str1.1' can not be used when making a PIE object; recompile with -fPIC

Add -fPIC to CFLAGS to fix it.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/kvm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 62c591f87dab..b4a55d300e75 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -44,7 +44,7 @@ INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
-	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
+	-fno-stack-protector -fPIC -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
 	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(UNAME_M) -I..
 
 no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
-- 
2.20.1


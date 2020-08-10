Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958DD240662
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 15:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgHJNGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 09:06:40 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:47984 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726815AbgHJNGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 09:06:39 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id EDBE24C8B0;
        Mon, 10 Aug 2020 13:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1597064795; x=1598879196; bh=kSkMdcaH4hQa0Ft6KVr0aTYUxYzVR0vbo2H
        XLiHtojI=; b=lOZ+Lxr0UWvNC4I0L5hbYSFvFTI0mlylVoCOzg3Oiym0DYELp4P
        FSEv0Tg0oAwKZsNxugJz9hDxioNKokyhhTu2WWbYlngL3sKRidn5I3eh1A6+0Jrl
        nuI/+GchJhoqERp0CLfcEEcjQqM65e2eu5DCJNc0KkygHPD1gvbnIOJs=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pSd5SjL05hRX; Mon, 10 Aug 2020 16:06:35 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 301A24C8A2;
        Mon, 10 Aug 2020 16:06:35 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 10
 Aug 2020 16:06:35 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [kvm-unit-tests PATCH 3/7] x86: Makefile: Fix linkage of realmode on x86_64-elf binutils
Date:   Mon, 10 Aug 2020 16:06:14 +0300
Message-ID: <20200810130618.16066-4-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200810130618.16066-1-r.bolshakov@yadro.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

link spec [1][2] is empty on x86_64-elf-gcc, i.e. -m32 is not propogated
to the linker as "-m elf_i386" and that causes the error:

  /usr/local/opt/x86_64-elf-binutils/bin/x86_64-elf-ld: i386 architecture
  of input file `x86/realmode.o' is incompatible with i386:x86-64 output

1. https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html
2. https://gcc.gnu.org/onlinedocs/gccint/Driver.html

Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 x86/Makefile.common | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 2ea9c9f..8230ac0 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -66,7 +66,8 @@ test_cases: $(tests-common) $(tests)
 $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
 
 $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
-	$(CC) -m32 -nostdlib -o $@ -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
+	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
+	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
 $(TEST_DIR)/realmode.o: bits = 32
 
-- 
2.26.1


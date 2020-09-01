Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4CA258ABF
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 10:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgIAIvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 04:51:16 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55028 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727884AbgIAIvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 04:51:09 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7333057315;
        Tue,  1 Sep 2020 08:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1598950266; x=1600764667; bh=PlSUgFRbJ9yRAz8gWhFmmI1rwJfRoe0zbIY
        vZ0vfBZk=; b=ba6s41vqfVbtIsVjfiGF+ZAjRAdDhfOAOum6B3CerRNgVxEYr87
        FtB0HSFAld91mnSUtJ1KTKvV5oh4Y7fYOG613UaKB5EXs65iFgNf0I2Bp1AGLVaE
        vMjTQYLP+/W5kL9+UW2Xvj6ZVDogfxtVOWoVOMpzaTab5ZUBK1Gn/g3Y=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1Poy6571b0eB; Tue,  1 Sep 2020 11:51:06 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8892F5141E;
        Tue,  1 Sep 2020 11:51:05 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 1 Sep
 2020 11:51:05 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [kvm-unit-tests PATCH v2 03/10] x86: Makefile: Fix linkage of realmode on x86_64-elf binutils
Date:   Tue, 1 Sep 2020 11:50:49 +0300
Message-ID: <20200901085056.33391-4-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901085056.33391-1-r.bolshakov@yadro.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 x86/Makefile.common | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index c3f7dc4..090ce22 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -69,7 +69,8 @@ test_cases: $(tests-common) $(tests)
 $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
 
 $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
-	$(CC) -m32 -nostdlib -o $@ -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
+	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
+	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
 $(TEST_DIR)/realmode.o: bits = 32
 
-- 
2.28.0


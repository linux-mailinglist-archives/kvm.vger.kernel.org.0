Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE4F240661
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 15:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgHJNGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 09:06:38 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:47970 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726582AbgHJNGh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 09:06:37 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 616844C8A9;
        Mon, 10 Aug 2020 13:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1597064793; x=1598879194; bh=wUN5jHU/zBYZJQjo7ncYgKjE4TFXDiYyECm
        cEyGlvTw=; b=S6AqCDnVKm+zYVsyyqJIeaCXl+mnCRs4tJMlAa+x9VBIB2IqoEd
        gtGocw6qsdK8gyU9F2MjD2aGcUoXFSev6pPm8F621ybMmIHH2tnVzYVJEBsvxb0C
        ywX2st9IT5AoKCRPs6Q49lBDkb7nMhZc7Ywq5e0Lm+0PhhqAkzCh+y38=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id X6ktgHB82ZA5; Mon, 10 Aug 2020 16:06:33 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E45D54C890;
        Mon, 10 Aug 2020 16:06:33 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 10
 Aug 2020 16:06:33 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [kvm-unit-tests PATCH 1/7] x86: Makefile: Allow division on x86_64-elf binutils
Date:   Mon, 10 Aug 2020 16:06:12 +0300
Message-ID: <20200810130618.16066-2-r.bolshakov@yadro.com>
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

For compatibility with other SVR4 assemblers, '/' starts a comment on
*-elf binutils target and thus division operator is not allowed [1][2].
That breaks cstart64.S build:

  x86/cstart64.S: Assembler messages:
  x86/cstart64.S:294: Error: unbalanced parenthesis in operand 1.

The option is ignored on the Linux target of GNU binutils.

1. https://sourceware.org/binutils/docs/as/i386_002dChars.html
2. https://sourceware.org/binutils/docs/as/i386_002dOptions.html#index-_002d_002ddivide-option_002c-i386

Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 x86/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/Makefile b/x86/Makefile
index 8a007ab..22afbb9 100644
--- a/x86/Makefile
+++ b/x86/Makefile
@@ -1 +1,3 @@
 include $(SRCDIR)/$(TEST_DIR)/Makefile.$(ARCH)
+
+COMMON_CFLAGS += -Wa,--divide
-- 
2.26.1


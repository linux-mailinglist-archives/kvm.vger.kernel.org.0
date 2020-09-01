Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B78258ABE
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 10:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgIAIvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 04:51:17 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55048 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727930AbgIAIvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 04:51:11 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B2DDC52215;
        Tue,  1 Sep 2020 08:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1598950267; x=1600764668; bh=ZmM9ZWKttDorIzOM/FDHNNVOBMf5H7JT8Wp
        NGiTYJnQ=; b=i0YD9MXbb4jANEeie5XRcA4BnH1vbqREY1VGWTgIvczgg6yu/MG
        FN6qa4ezeBOiymLL5erKQeijhiaXuJFzdhS4DQOa5ydJ3RoxeFr1DlsVR7zNb6As
        o8k7UKiXzgrEushzPSCSjbxzlY7mV3HjW6mwpFd5u2HYU9JI82MKi8DI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pJ1UgbhxzZ6c; Tue,  1 Sep 2020 11:51:07 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8CA425725D;
        Tue,  1 Sep 2020 11:51:06 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 1 Sep
 2020 11:51:06 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Andrew Jones <drjones@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [kvm-unit-tests PATCH v2 05/10] lib: x86: Use portable format macros for uint32_t
Date:   Tue, 1 Sep 2020 11:50:51 +0300
Message-ID: <20200901085056.33391-6-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901085056.33391-1-r.bolshakov@yadro.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compilation of the files fails on ARCH=i386 with i686-elf gcc because
they use "%x" or "%d" format specifier that does not match the actual
size of uint32_t:

x86/s3.c: In function ‘main’:
x86/s3.c:53:35: error: format ‘%x’ expects argument of type ‘unsigned int’, but argument 2 has type ‘u32’ {aka ‘long unsigned int’}
[-Werror=format=]
   53 |  printf("PM1a event registers at %x\n", fadt->pm1a_evt_blk);
      |                                  ~^     ~~~~~~~~~~~~~~~~~~
      |                                   |         |
      |                                   |         u32 {aka long unsigned int}
      |                                   unsigned int
      |                                  %lx

Use PRIx32 instead of "x" and PRId32 instead of "d" to take into account
u32_long case.

Cc: Alex Bennée <alex.bennee@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Cameron Esfahani <dirty@apple.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 lib/pci.c     | 2 +-
 x86/asyncpf.c | 2 +-
 x86/msr.c     | 3 ++-
 x86/s3.c      | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/pci.c b/lib/pci.c
index daa33e1..175caf0 100644
--- a/lib/pci.c
+++ b/lib/pci.c
@@ -248,7 +248,7 @@ void pci_bar_print(struct pci_dev *dev, int bar_num)
 		printf("BAR#%d,%d [%" PRIx64 "-%" PRIx64 " ",
 		       bar_num, bar_num + 1, start, end);
 	} else {
-		printf("BAR#%d [%02x-%02x ",
+		printf("BAR#%d [%02" PRIx32 "-%02" PRIx32 " ",
 		       bar_num, (uint32_t)start, (uint32_t)end);
 	}
 
diff --git a/x86/asyncpf.c b/x86/asyncpf.c
index 305a923..8239e16 100644
--- a/x86/asyncpf.c
+++ b/x86/asyncpf.c
@@ -78,7 +78,7 @@ static void pf_isr(struct ex_regs *r)
 			phys = 0;
 			break;
 		default:
-			report(false, "unexpected async pf reason %d", reason);
+			report(false, "unexpected async pf reason %" PRId32, reason);
 			break;
 	}
 }
diff --git a/x86/msr.c b/x86/msr.c
index f7539c3..ce5dabe 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -89,7 +89,8 @@ static void test_msr_rw(int msr_index, unsigned long long input, unsigned long l
     wrmsr(msr_index, input);
     r = rdmsr(msr_index);
     if (expected != r) {
-        printf("testing %s: output = %#x:%#x expected = %#x:%#x\n", sptr,
+        printf("testing %s: output = %#" PRIx32 ":%#" PRIx32
+	       " expected = %#" PRIx32 ":%#" PRIx32 "\n", sptr,
                (u32)(r >> 32), (u32)r, (u32)(expected >> 32), (u32)expected);
     }
     report(expected == r, "%s", sptr);
diff --git a/x86/s3.c b/x86/s3.c
index da2d00c..6e41d0c 100644
--- a/x86/s3.c
+++ b/x86/s3.c
@@ -50,7 +50,7 @@ int main(int argc, char **argv)
 		*resume_vec++ = *addr;
 	printf("copy resume code from %p\n", &resume_start);
 
-	printf("PM1a event registers at %x\n", fadt->pm1a_evt_blk);
+	printf("PM1a event registers at %" PRIx32 "\n", fadt->pm1a_evt_blk);
 	outw(0x400, fadt->pm1a_evt_blk + 2);
 
 	/* Setup RTC alarm to wake up on the next second.  */
-- 
2.28.0


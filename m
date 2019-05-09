Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A119E196F8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 05:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfEJDK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 23:10:27 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44726 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfEJDK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 23:10:26 -0400
Received: by mail-pl1-f194.google.com with SMTP id d3so2097259plj.11
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 20:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/t5j75iro/GTkRNvb56vHzY7kUX0cvtwivQC6BmF3k8=;
        b=DPFpzO5+Vy2cV8dmz+mvMEvfj3gn9VWYkEv/bP3IetEZVolW3GnlKMYUx2kst1dOzf
         QuRmM14KN3H1hzSx1bZUrUknPCMygzhopmoGmqyMf8yx6CTeTtbDo0PuX2cf4vi084+8
         UDvfPe3u77h09UV0eJpofbd7ZefUHMWZ2HwJ14pqyqe7J23rHWSIG5w/N96jwnUqR6mF
         tDbXlnkrVk2wSRG0Bj5JuCDMgc7PHcxjc/8VMdqySVAxe6gnz2tM5JQBB93ViHUS97qX
         nhL5LHPXtqsYWUQePCuJ0orOW4wL1Ry/aFwpFQUWsxk57RHgk7y+tfbEMx0SN/5vtFlF
         1IEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/t5j75iro/GTkRNvb56vHzY7kUX0cvtwivQC6BmF3k8=;
        b=rDwYMaU1xEwqOnsAR5zIwt4i80ZJIGqparg82IIE39mz82B1hXScSU8KQaRIkVgtMQ
         eXKmAz/PUJNP4roSnjQR0I+u04vjLRRn6Z1TXaQTlnperMwAIHy5381kdlDqJuEnEpwA
         TlosFtHW1Nzav7DhMDXGkN3O/jXhfvpwBXUlkUYB/D5QLAJyLOwofCmyVNqKT+yV34Ao
         TwJIayIX5GPR226iRF8u8gGugCJuFuu492G9+Nq0tcOBoHmj+mtXc/RGYhSP94+a4Prl
         x7cAl0n3dQNsijgAbPKPs1zGFcxv7cEzMPufxzGIp20sQMWPD6r5fZkcMv/z/j+jydb9
         h4CA==
X-Gm-Message-State: APjAAAW+l77xriVpT6JShsrExhAv21BcejOqqNKhR/kjUx05MGtzonQM
        n/tvSJEOtn51giqrZ3aIuuw=
X-Google-Smtp-Source: APXvYqwwPOwoLMdFYeBKV0FK6fMLshceKCNVuE1H9Fray1m1gTnZvqQW5hn1ql2/fUL9FsHT2LocIg==
X-Received: by 2002:a17:902:f215:: with SMTP id gn21mr10021500plb.194.1557457825623;
        Thu, 09 May 2019 20:10:25 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id h27sm6314203pfd.53.2019.05.09.20.10.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 20:10:24 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH] x86: Halt on exit
Date:   Thu,  9 May 2019 12:50:23 -0700
Message-Id: <20190509195023.11933-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some cases, shutdown through the test device and Bochs might fail.
Just hang in a loop that executes halt in such cases.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/x86/io.c b/lib/x86/io.c
index f3e01f7..e6372c6 100644
--- a/lib/x86/io.c
+++ b/lib/x86/io.c
@@ -99,6 +99,10 @@ void exit(int code)
 #else
         asm volatile("out %0, %1" : : "a"(code), "d"((short)0xf4));
 #endif
+	/* Fallback */
+	while (1) {
+		asm volatile ("hlt" ::: "memory");
+	}
 	__builtin_unreachable();
 }
 
-- 
2.17.1


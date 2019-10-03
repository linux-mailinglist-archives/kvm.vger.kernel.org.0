Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13D1CA11F
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 17:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbfJCPYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 11:24:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46518 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfJCPYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 11:24:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so3204295wrv.13
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 08:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=ZRM8UhcRohD7Bt53XpU0TqsliASuoqYedkYx4gqC86I=;
        b=g/32q7fJLjKwlwfjz4nMIB0KVXyrrysPfeZ5AGpTovt0yRYceiR5zcjmIX7EkucxLG
         I1RRojWp8jfKwqdKp7yobSaXlSuMRvHOg30M1D+3EX8JsyorPRyHkjinnK+SD+PyZE/c
         XmQL2TDcSJgunD6XirGGYf3CkNl8VUOq+VylzCKz4wFbHFgvkVrIPpkoFRIn88UEUaOq
         C41YQJ1SGXIY6xUillzqoBD789LhgqsnEpwMLc7i9NpiZvBZK+/gecY/ngnKgnYP3kh5
         34QR7pwFTZvJF9kUhQpJzdJLHnGF/vrb1T3wsH4kqoVTDnY76GaOzsSXNX3nsjEGQxDl
         Tnxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=ZRM8UhcRohD7Bt53XpU0TqsliASuoqYedkYx4gqC86I=;
        b=HMjDS0/P35ioTrvZnQdEvCd+ReGOyFa1oLrALJstWN/oR0j4vbsdhNdUZFKJzA0R5w
         Mu0dJjKZzvTwXwiYQhQHQqfErcJCNVZ9voyDXfYHuJLpvGtriB+GfGiskz0FENHJ5tKu
         Mp5N+1FQniaUwhpQzsMWfgRYJnbFTWR+bitw8LyCOZa2i9vfyIo7Td+MWpnGUnJF9RVq
         G6WAK8VXpORBsMbB1Ca5pt+h/sgi2gtc0NookATAngDO0Ia0NwTajpapKcvGEaF6699f
         lte3nd6IUB16Wu7kzcocW5D+S27IDmjVf3ZTsaetki3WisfyGHJn2x8giu9fxF6dxHn+
         8U6g==
X-Gm-Message-State: APjAAAWFBHci4pUKvdsXHxyIzpH1EE6B3mDgVHKSTLEgZE0y7Yp33Ufi
        3HrFVrFPCiViJdCgnEAIlWEarWVX
X-Google-Smtp-Source: APXvYqzONuhyqR/NtrlUFzAdknQaYxBfLzty3tUjBuNFUYrBT4vRRtectyb2qjTb6oAccmEIFjHwTw==
X-Received: by 2002:adf:d1a8:: with SMTP id w8mr3145322wrc.271.1570116276027;
        Thu, 03 Oct 2019 08:24:36 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id n1sm5407670wrg.67.2019.10.03.08.24.34
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 08:24:35 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] vmexit: measure IPI and EOI cost
Date:   Thu,  3 Oct 2019 17:24:31 +0200
Message-Id: <1570116271-8038-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmexit.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/x86/vmexit.c b/x86/vmexit.c
index 66d3458..81b743b 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -65,22 +65,30 @@ static void nop(void *junk)
 }
 
 volatile int x = 0;
+volatile uint64_t tsc_eoi = 0;
+volatile uint64_t tsc_ipi = 0;
 
 static void self_ipi_isr(isr_regs_t *regs)
 {
 	x++;
+	uint64_t start = rdtsc();
 	eoi();
+	tsc_eoi += rdtsc() - start;
 }
 
 static void x2apic_self_ipi(int vec)
 {
+	uint64_t start = rdtsc();
 	wrmsr(0x83f, vec);
+	tsc_ipi += rdtsc() - start;
 }
 
 static void apic_self_ipi(int vec)
 {
+	uint64_t start = rdtsc();
         apic_icr_write(APIC_INT_ASSERT | APIC_DEST_SELF | APIC_DEST_PHYSICAL |
 		       APIC_DM_FIXED | IPI_TEST_VECTOR, vec);
+	tsc_ipi += rdtsc() - start;
 }
 
 static void self_ipi_sti_nop(void)
@@ -180,7 +188,9 @@ static void x2apic_self_ipi_tpr_sti_hlt(void)
 
 static void ipi(void)
 {
+	uint64_t start = rdtsc();
 	on_cpu(1, nop, 0);
+	tsc_ipi += rdtsc() - start;
 }
 
 static void ipi_halt(void)
@@ -511,6 +521,7 @@ static bool do_test(struct test *test)
 	}
 
 	do {
+		tsc_eoi = tsc_ipi = 0;
 		iterations *= 2;
 		t1 = rdtsc();
 
@@ -523,6 +534,11 @@ static bool do_test(struct test *test)
 		t2 = rdtsc();
 	} while ((t2 - t1) < GOAL);
 	printf("%s %d\n", test->name, (int)((t2 - t1) / iterations));
+	if (tsc_ipi)
+		printf("  ipi %s %d\n", test->name, (int)(tsc_ipi / iterations));
+	if (tsc_eoi)
+		printf("  eoi %s %d\n", test->name, (int)(tsc_eoi / iterations));
+
 	return test->next;
 }
 
-- 
1.8.3.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEF623DAF
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 18:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392680AbfETQjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 12:39:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33755 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392674AbfETQjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 12:39:32 -0400
Received: by mail-pf1-f195.google.com with SMTP id z28so7517340pfk.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 09:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f+A8ag4YLav+vPppsJY/NVVk9kuuwpxIHjnghkZpcHo=;
        b=BqR00efKFw3q5NzR2CbaGVEAd+hKOxzPF7q9ZlETtZU2JgBifdC2thaOREZWJ6TMe5
         p/tBORy1PK5liI4P7GPoHclq+fE3qTg5l59LIejL0ZRZkxtv8ZsJRR5fOQ8BIBz0AZOa
         MDWXLPqwVCoOe2ozh4OBRmFuikGkWUd/GKYQDpn5//rqlXpFCHwlN2TgwYGAjgok3zks
         eJKyXGOJUrqlTUn4TmzAYPmZbdGnwHVjAv+MGoWB44VuNoPxL2uOH4nluZlqzIKcY02C
         CN2TkuOD2iuRhJP1Ir2JQuBGYg7hKZLxrwSJPn1NLm/NsGLwyC5QJUKK0kmLDgP13icB
         l3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f+A8ag4YLav+vPppsJY/NVVk9kuuwpxIHjnghkZpcHo=;
        b=KF2AAYWLL12zCHGYPwd4wne6dLlMGRb9L3v0T5wRT3RbewFHiYMmkBJzeg3keaIxqm
         oPjPqYl4hhmpPNmwLXTlA5TZ0Y9Q6t5OqT6S/J8EBmZFfrnageVo2Mb/ogVwLWJ1lB6M
         cbmN8ls61WvXJ/L7SB6bo5l0xVEtYj4AgN5+5TX/FdRBkbYFbC298rKFbMQ3158PweOw
         HeZWCBzUaiEgrd6csPt08ibb5Q2YZ2pI5FKr9HGi3fGWSk93WLFZQ8bPN6T7jEgasBV7
         1KHVf0LFHMZHnvOPq4LBaItPprOw/HPs5zOrDA7Vy03CPFiK4OBGW++c2/q1CTJdrkE+
         v6uQ==
X-Gm-Message-State: APjAAAW6amu8ltpovFEzJAB7Xizj2ivLLivCaFJZRwe0kXpNLLgLCp5+
        5uzWgcqhM8GEMpnvz5XWdpU=
X-Google-Smtp-Source: APXvYqxlwThgglsQlqnCZDP2rD7A5gcNNvbP+e+pdiZPkEPt+l8Q7mCE3nfMvWrSN70edPvMBv/Y2g==
X-Received: by 2002:a63:6fce:: with SMTP id k197mr77381106pgc.140.1558370371438;
        Mon, 20 May 2019 09:39:31 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id a66sm25101076pfa.89.2019.05.20.09.39.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 09:39:30 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: Fix SMP stacks
Date:   Mon, 20 May 2019 02:17:30 -0700
Message-Id: <20190520091730.15536-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid smashing the SMP stacks during boot as currently happens by
allocating sufficient space for them.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/cstart64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index a4b55c5..71c3153 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -19,7 +19,7 @@ max_cpus = MAX_TEST_CPUS
 	.align 16
 stacktop:
 
-	. = . + 4096
+	. = . + 4096 * max_cpus
 	.align 16
 ring0stacktop:
 
@@ -170,7 +170,7 @@ efer = 0xc0000080
 	mov %eax, %cr0
 	ret
 
-smp_stacktop:	.long 0xa0000
+smp_stacktop:	.long stacktop - 4096
 
 .align 16
 
-- 
2.17.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E107A4202
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2019 06:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbfHaEBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Aug 2019 00:01:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36191 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfHaEBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Aug 2019 00:01:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id p13so9363279wmh.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 21:01:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=w+95+WjAN0K6CXfamZriaVlxGVr5jfuNDPza814XqZQ=;
        b=AsmQY63eTDxmq3DrXHmvY77bvkuISoBkV7VkJVpXgxLzStMgWbLCJvkcc0T3X4k7cO
         CRQDdYuawX5dorEMWGtRKJzsxW0MkGgSbdDDJuzYbnJModSz8azXDmB/6sBNjeRZGR17
         Z28vXA3iSre8zIQwR4RVz9ki93uzogtWsUsRYZc1dDewd27gAf0QdEeNYBVKIzUChadq
         0e9HhmJ5u1nubtGM6iTKkyO+Cd7pZ8AcrhWnxA+bPPRVe7npCatZO16Wf+ETh53yNlkK
         6aqIUhDaBC1uEE65s7MSlqlbs9fdLHgoRPWXV2z5nsw5Nso/6zQBSdODXJWYwakPyKZX
         Lp3g==
X-Gm-Message-State: APjAAAXjc9D2znOEGBAGSsbe9N8zONXaL/ceSyfW21yT/WZMZCtEkRrh
        vyquOTqBCDcI5DyOuwcK8rY=
X-Google-Smtp-Source: APXvYqw+n0LzjMqWRWckMdUShFUMfRbdcGvoGkx2tqK9H4wvBR4SC81kXivYX8EPXLjJHihu2DDQgA==
X-Received: by 2002:a7b:c758:: with SMTP id w24mr11722472wmk.143.1567224069029;
        Fri, 30 Aug 2019 21:01:09 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id e4sm4656470wro.21.2019.08.30.21.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 21:01:08 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [kvm-unit-tests PATCH 1/2] x86: nVMX: Do not use test_skip() when multiple tests are run
Date:   Fri, 30 Aug 2019 13:40:30 -0700
Message-Id: <20190830204031.3100-2-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830204031.3100-1-namit@vmware.com>
References: <20190830204031.3100-1-namit@vmware.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using test_skip() when multiple tests are run causes all the following
tests to be skipped. Instead, just print a message and return.

Fixes: 47cc3d85c2fe ("nVMX x86: Check PML and EPT on vmentry of L2 guests")
Fixes: 7fd449f2ed2e ("nVMX x86: Check VPID value on vmentry of L2 guests")
Fixes: 181219bfd76b ("x86: Add test for checking NMI controls on vmentry of L2 guests")
Fixes: 1d70eb823e12 ("nVMX x86: Check EPTP on vmentry of L2 guests")
Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/vmx_tests.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f035f24..4ff1570 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4040,7 +4040,7 @@ static void test_vpid(void)
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_VPID))) {
-		test_skip("Secondary controls and/or VPID not supported");
+		printf("Secondary controls and/or VPID not supported\n");
 		return;
 	}
 
@@ -4544,7 +4544,7 @@ static void test_nmi_ctrls(void)
 
 	if ((ctrl_pin_rev.clr & (PIN_NMI | PIN_VIRT_NMI)) !=
 	    (PIN_NMI | PIN_VIRT_NMI)) {
-		test_skip("NMI exiting and Virtual NMIs are not supported !");
+		printf("NMI exiting and Virtual NMIs are not supported !\n");
 		return;
 	}
 
@@ -4657,7 +4657,7 @@ static void test_ept_eptp(void)
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT))) {
-		test_skip("\"CPU secondary\" and/or \"enable EPT\" execution controls are not supported !");
+		printf("\"CPU secondary\" and/or \"enable EPT\" execution controls are not supported !\n");
 		return;
 	}
 
@@ -4844,7 +4844,7 @@ static void test_pml(void)
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT) && (ctrl_cpu_rev[1].clr & CPU_PML))) {
-		test_skip("\"Secondary execution\" control or \"enable EPT\" control or \"enable PML\" control is not supported !");
+		printf("\"Secondary execution\" control or \"enable EPT\" control or \"enable PML\" control is not supported !\n");
 		return;
 	}
 
-- 
2.17.1


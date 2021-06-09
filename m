Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267B73A1CCC
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFISdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:33:00 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:46804 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhFISc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:32:59 -0400
Received: by mail-pj1-f43.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso1969232pjb.5
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0fyLamNbc74wavKVj/zbjloyua4AURdiLjTROhG9DcM=;
        b=OGj3Gje8zi/F4dEvGmXih0pwkDngC37UP2K9eaUK9iAjz4O4XJ41yz/HYyPPYDrh/7
         nGe/QvAGuoikGJJyXOSbI3PICISesNxBwtebcZqqOcI811VpIXYyawQZDVAi4Qy/uwNj
         gsKcAha9+3HsW0SOBaAWXpZ4DOcW7rdFaEi63g0uwaMr09OqaSpkjSSqr4gU2r/vgNf+
         5MnsaYzJznfpN5Ly44maymqCiaWlZdd20awunKS/U1jD967JybgfVzFYDWCHicb93OQI
         iApWJaQflVFSE94zy88/Q9ODT0ML5n+jSO4jBH6I94fA3mqc3iIOlM3dqKBkIJ/YmICD
         Nd+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0fyLamNbc74wavKVj/zbjloyua4AURdiLjTROhG9DcM=;
        b=aURyZCfMU+IJNjptYaieyc2IixGAMViJFEBh9jto/6tAkdf42YlJpNNrmr4PdOsJQp
         FJQ13FqnGSMEUAq00aoysfYwlyrXHPF5Gc3n/hIj1JiDEL3MVN57s9Px5Siy23RjRaRo
         +m0NQdiI/1bxn2zQh+kQ7rvI2SFJ3PtKoc2YwofD88cm/9bT1S+OaLcNLhZlUUaGywAH
         e1v35H6Ljq+hS3vFYSaL+kdzVJd+iL2OYfodNB5/f/fFWyzVTY7TkXer3V/i61mqxJ+B
         8npe5NIT7V+nR2KLMD3FzZutVZMsEqbvkynpTAH8b9wbbjhtMdWSWwfNeMjDKSGgoc5w
         hO8A==
X-Gm-Message-State: AOAM530v/+DxjfTRbTqpC10bvp8H7Bna943qayxXIkCx2P1Ge3KxPY7b
        jsdeadnLioDsoLxM99hePo0=
X-Google-Smtp-Source: ABdhPJzjqognyBIJXf0ZdudFf8DSmVxSAK+lUqm9KQuh5nNxm/C+UW2c/ZekRj90oQVRLILAKxDgog==
X-Received: by 2002:a17:90a:288:: with SMTP id w8mr880256pja.111.1623263404177;
        Wed, 09 Jun 2021 11:30:04 -0700 (PDT)
Received: from ubuntu-server-2004.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y34sm249092pfa.181.2021.06.09.11.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:30:03 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 6/8] x86/syscall: skip TF-test if running neither on KVM nor AMD
Date:   Wed,  9 Jun 2021 18:29:43 +0000
Message-Id: <20210609182945.36849-7-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609182945.36849-1-nadav.amit@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

The syscall TF-test runs syscall on 32-bit mode, which is unsupported by
Intel. As a result, if the test is executed on non-KVM environment and
the system does not have AMD CPU, the test crashes. Skip the test in
such case.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/syscall.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/x86/syscall.c b/x86/syscall.c
index 8cef860..a8045cb 100644
--- a/x86/syscall.c
+++ b/x86/syscall.c
@@ -4,6 +4,7 @@
 #include "processor.h"
 #include "msr.h"
 #include "desc.h"
+#include "fwcfg.h"
 
 static void test_syscall_lazy_load(void)
 {
@@ -101,7 +102,11 @@ static void test_syscall_tf(void)
 int main(int ac, char **av)
 {
     test_syscall_lazy_load();
-    test_syscall_tf();
+
+    if (!no_test_device || !is_intel())
+        test_syscall_tf();
+    else
+        report_skip("syscall TF handling");
 
     return report_summary();
 }
-- 
2.25.1


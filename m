Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1341B18DDED
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 06:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgCUFIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 01:08:07 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50180 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgCUFIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 01:08:07 -0400
Received: by mail-pj1-f66.google.com with SMTP id v13so3432359pjb.0
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 22:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8T9VA2UuKy0j0X4+DGwUzC/m9/KOGf3YA0PhfRdA/9s=;
        b=acNtUwjDAwimQVHMks/LR4xNke99CYUdsjIo7dXW5893xfL/voNh9DTCuBb9S3RlNA
         Rp/8nVGng0aDVCNAT1UH6t+b2pxPXSMTjPIYB3BeD706F15z/4esucRccFw7Zr6bPGBt
         s8e8IwAiKqohUHPgYzmRw2GgKhneLQKoR1qPV7wKYm/TKf8pelFWOa4TgOgaINa0IoU3
         T9gylz7r+LGcusAL7+Zhp+3axfbTz403qpRkA2xG4+tZKCeV1eJuhV7/bpV6ZJedyEe8
         hdpqBKvcaMVHxVONBkvoL/Mjl8DL47D15C0u+OZe/Nnz1Y04Dj3STNk45oDB1umFRBQ6
         UPKQ==
X-Gm-Message-State: ANhLgQ2ZbOjYqcGmD9i3ceqe277Ie+3THhwPEXgCD7Cg+Rdyk9QKxp/S
        9azUFparMu8bHH3xXIVFdzo=
X-Google-Smtp-Source: ADFU+vt6bJv1ff3Wn9YyPuBApQUkLsg+akjcds7MRl+dN8mVXEco1G/4AzVZ65dTZJfReIvM7CUc9A==
X-Received: by 2002:a17:90a:dd42:: with SMTP id u2mr13247435pjv.10.1584767286510;
        Fri, 20 Mar 2020 22:08:06 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id h132sm7148179pfe.118.2020.03.20.22.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 22:08:05 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Marc Orr <marcorr@google.com>
Subject: [PATCH] x86: vmx: skip atomic_switch_overflow_msrs_test on bare metal
Date:   Fri, 20 Mar 2020 22:06:16 -0700
Message-Id: <20200321050616.4272-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test atomic_switch_overflow_msrs_test is only expected to pass on
KVM. Skip the test when the debug device is not supported to avoid
failures on bare-metal.

Cc: Marc Orr <marcorr@google.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/vmx_tests.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2014e54..be5c952 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9546,7 +9546,10 @@ static void atomic_switch_max_msrs_test(void)
 
 static void atomic_switch_overflow_msrs_test(void)
 {
-	atomic_switch_msrs_test(max_msr_list_size() + 1);
+	if (test_device_enabled())
+		atomic_switch_msrs_test(max_msr_list_size() + 1);
+	else
+		test_skip("Test is only supported on KVM");
 }
 
 #define TEST(name) { #name, .v2 = name }
-- 
2.17.1


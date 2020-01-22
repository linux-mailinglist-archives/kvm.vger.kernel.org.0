Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C64E145205
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 11:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgAVKEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 05:04:01 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:42126 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgAVKEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 05:04:01 -0500
Received: by mail-pl1-f202.google.com with SMTP id b4so3236614plr.9
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 02:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WPWlBAFrYfOfqMEgSjQJiZF1KWEAEaOIklSy0CoEty4=;
        b=XRmzJa+u7iTLj4vDydOb/0VgZ2k7pIvxKNX21eeFetfNMwNyBjHbvsaUhXSVOb4jaj
         02V62CPs8nv84vAV+37mF1kdGd16b/A56MhcBZV0VrzGvN+f2T6ne61bSBo0n2wOSsnh
         7SP/hY3IWRVtmVO3i4PmpFTMNi5HHSpj9Ocvy7GsP4u6sNY0rOU/aMMhmsbBGBr87iVc
         p4mBPJBhu0jsLABy6OmlL1COSnh+wf8IxeM2nf0j0NiN/Lsbc1ROaOsmQHeESad2Vc30
         p8top+p/Eey8cw/wIvMRhOQK7y2TB9Y8BnTT5ePBSt+pct4vAkBDS0UvHSFNqtMPumhM
         Y8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WPWlBAFrYfOfqMEgSjQJiZF1KWEAEaOIklSy0CoEty4=;
        b=KZNqsgxIenNXRYij6K0Oj/RtlvE9NCHSNKhgBtg8w+rq49qy1f6mrQo+FnpGCPZi4U
         lHeNUSpDLLwHostVMhg7Cwfqnd96xPMUWso0EuKi25O/TM/0iUm3Vq6L7ypVxgLLrs1y
         dYNF217gUipufmjvX1s03j7l36zzlKjxKKbr68Ca67O6Ul82WXipHOXWjo766K8LMaFm
         ATJRBuE73iqZaIqbfpGMS88AGbbOtMqfPXLJDGmeFxBwHQidB73Zve6+MnBhHyN7Uw20
         eU1xb9dmiqiae/rLjZZNV6HfI2Y/Im72j3wH/IbZhTPE5RDDCw5TpY1Aw1fXlm9a0Hrm
         S59A==
X-Gm-Message-State: APjAAAULA4dPysEQGRoN+Zqr0JeUatF4yGmt5Y764yFQwVINqzTSnHWi
        pxOI1TjZRhM4tcX2IbH6C6M7585CJkRmqfHmLcEeoup8D1Dnb8gOLZ176pGnh7ey0uXXSPqiz5X
        8OAUJPZWpAMAStozSpiv0Iy8vY0HOW0bjv77jHCAE/habXJM9iz0mngsyPg==
X-Google-Smtp-Source: APXvYqyM/XfUJWsVszHM6os7VYA/SIo8fnSxv45hZNk4AA+i3kSV1KUioTUKFsz+wL6EWSPV25PM5myg1NE=
X-Received: by 2002:a63:4f1b:: with SMTP id d27mr9989509pgb.102.1579687440408;
 Wed, 22 Jan 2020 02:04:00 -0800 (PST)
Date:   Wed, 22 Jan 2020 02:03:56 -0800
Message-Id: <20200122100356.240412-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [kvm-unit-tests PATCH v2] x86: VMX: Check precondition for RDTSC test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RDTSC VM-exit test requires the 'use TSC offsetting' processor-based
VM-execution control be allowed on the host. Check this precondition
before running the test rather than asserting it later on to avoid
erroneous failures on a host without TSC offsetting.

Cc: Aaron Lewis <aaronlewis@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/vmx_tests.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3b150323b325..b31c360c5f3c 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9161,9 +9161,6 @@ static void vmx_vmcs_shadow_test(void)
  */
 static void reset_guest_tsc_to_zero(void)
 {
-	TEST_ASSERT_MSG(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET,
-			"Expected support for 'use TSC offsetting'");
-
 	vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
 	vmcs_write(TSC_OFFSET, -rdtsc());
 }
@@ -9210,6 +9207,9 @@ static void rdtsc_vmexit_diff_test(void)
 	int fail = 0;
 	int i;
 
+	if (!(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET))
+		test_skip("CPU doesn't support the 'use TSC offsetting' processor-based VM-execution control.\n");
+
 	test_set_guest(rdtsc_vmexit_diff_test_guest);
 
 	reset_guest_tsc_to_zero();
-- 
2.25.0.341.g760bfbb309-goog


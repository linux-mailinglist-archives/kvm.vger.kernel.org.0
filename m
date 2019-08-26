Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE969CB1B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 09:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbfHZH5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 03:57:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730061AbfHZH5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 03:57:41 -0400
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6BB181F0E
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 07:57:40 +0000 (UTC)
Received: by mail-pf1-f199.google.com with SMTP id 191so5584800pfz.8
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 00:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nx/uKVsNPrj4sLskCBDR38LskLWX/kbZNssKjw3uHhE=;
        b=lLgAhINwLFKpGAFK3YtNF6PLdunYE4SB9T7G023iS6y7b17tj247Y4QjMD4wApDCKl
         e4T+XWVe8i1THdxfNWg5RTb+FMeM+AzXUeMdQbeb3x1jgwuHeA7Aqo04Q08f0QBojOze
         rNtBAC7gh7+EVbVpiJ70l7/BLqv8w0wtae75YIrXQdoZyLe8LFdcqAZegJ07K/R8g0r9
         VEElSX9eb3nWhVI9v55LF0ReMdzhZyLFrnp1pWFCyo4CMvqP0oNAKqMJFMvp4rP1G/F1
         l3V5IdU5hmSmf68dtOZaGlGd83JqQvno5CPzPidH4FbDksAk7tluSnir/f7uaWOQy61G
         ZYnQ==
X-Gm-Message-State: APjAAAVud4y0fHSlhxOFXyu1QdLI9pfftLPELf1mesgtg74+LceWSl35
        9j6XLOUJTeeZfwuD1RrpbCoipaLn7mgRILqjNcxuCh9ZrjFaTdysqCL4aXPr58Z7TOrTDlQ/eoU
        4HTk3sMTV5Zld
X-Received: by 2002:a63:2807:: with SMTP id o7mr15459232pgo.131.1566806260339;
        Mon, 26 Aug 2019 00:57:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqziiG4ZLc+6KzG9IuAf9INJzIEZAmrquQXKtVmCmpvt5i2FFNbVKwAktGcQe/Gl3lvc7Tl0FA==
X-Received: by 2002:a63:2807:: with SMTP id o7mr15459215pgo.131.1566806259994;
        Mon, 26 Aug 2019 00:57:39 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r137sm12038058pfc.145.2019.08.26.00.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 00:57:39 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH] KVM: selftests: Detect max PA width from cpuid
Date:   Mon, 26 Aug 2019 15:57:28 +0800
Message-Id: <20190826075728.21646-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The dirty_log_test is failing on some old machines like Xeon E3-1220
with tripple faults when writting to the tracked memory region:

  Test iterations: 32, interval: 10 (ms)
  Testing guest mode: PA-bits:52, VA-bits:48, 4K pages
  guest physical test memory offset: 0x7fbffef000
  ==== Test Assertion Failure ====
  dirty_log_test.c:138: false
  pid=6137 tid=6139 - Success
     1  0x0000000000401ca1: vcpu_worker at dirty_log_test.c:138
     2  0x00007f3dd9e392dd: ?? ??:0
     3  0x00007f3dd9b6a132: ?? ??:0
  Invalid guest sync status: exit_reason=SHUTDOWN

It's because previously we moved the testing memory region from a
static place (1G) to the top of the system's physical address space,
meanwhile we stick to 39 bits PA for all the x86_64 machines.  That's
not true for machines like Xeon E3-1220 where it only supports 36.

Let's unbreak this test by dynamically detect PA width from CPUID
0x80000008.  Meanwhile, even allow kvm_get_supported_cpuid_index() to
fail.  I don't know whether that could be useful because I think
0x80000008 should be there for all x86_64 hosts, but I also think it's
not really helpful to assert in the kvm_get_supported_cpuid_index().

Fixes: b442324b581556e
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Andrew Jones <drjones@redhat.com>
CC: Radim Krčmář <rkrcmar@redhat.com>
CC: Thomas Huth <thuth@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 22 +++++++++++++------
 .../selftests/kvm/lib/x86_64/processor.c      |  3 ---
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index ceb52b952637..111592f3a1d7 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -274,18 +274,26 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
 #ifdef __x86_64__
-	/*
-	 * FIXME
-	 * The x86_64 kvm selftests framework currently only supports a
-	 * single PML4 which restricts the number of physical address
-	 * bits we can change to 39.
-	 */
-	guest_pa_bits = 39;
+	{
+		struct kvm_cpuid_entry2 *entry;
+
+		entry = kvm_get_supported_cpuid_entry(0x80000008);
+		/*
+		 * Supported PA width can be smaller than 52 even if
+		 * we're with VM_MODE_P52V48_4K mode.  Fetch it from
+		 * the host to update the default value (SDM 4.1.4).
+		 */
+		if (entry)
+			guest_pa_bits = entry->eax & 0xff;
+		else
+			guest_pa_bits = 32;
+	}
 #endif
 #ifdef __aarch64__
 	if (guest_pa_bits != 40)
 		type = KVM_VM_TYPE_ARM_IPA_SIZE(guest_pa_bits);
 #endif
+	printf("Supported guest physical address width: %d\n", guest_pa_bits);
 	max_gfn = (1ul << (guest_pa_bits - guest_page_shift)) - 1;
 	guest_page_size = (1ul << guest_page_shift);
 	/*
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 6cb34a0fa200..9de2fd310ac8 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -760,9 +760,6 @@ kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
 			break;
 		}
 	}
-
-	TEST_ASSERT(entry, "Guest CPUID entry not found: (EAX=%x, ECX=%x).",
-		    function, index);
 	return entry;
 }
 
-- 
2.21.0


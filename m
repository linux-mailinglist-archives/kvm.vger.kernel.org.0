Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42537258AC1
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 10:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgIAIvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 04:51:18 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55068 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727943AbgIAIvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 04:51:12 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DFE9C5732F;
        Tue,  1 Sep 2020 08:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1598950269; x=1600764670; bh=R9U4A4Al/SFgblTs20VQHVUr7X1m/ISsT6o
        3qGFtoAQ=; b=SJlNy+nHYcbHDINbw1i0YdP8PCdK3cdQ88hVUL+bHlInn7FU0tw
        z4SJbKgU/RRnQb4f+0R4nL7WhkUTsG+02Q07zMZ/hA6Hz1BP0ESd0cWsw73mN7yc
        NwHoVu9dkeAXnfSRgY/j9uBcASY/b2RzCzVmuwP2iSsekCIi71lpASbw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LF4wWVIQ4ygM; Tue,  1 Sep 2020 11:51:09 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3E286574F3;
        Tue,  1 Sep 2020 11:51:08 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 1 Sep
 2020 11:51:08 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH v2 08/10] travis.yml: Add CI for macOS
Date:   Tue, 1 Sep 2020 11:50:54 +0300
Message-ID: <20200901085056.33391-9-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901085056.33391-1-r.bolshakov@yadro.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
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

Build the tests on macOS and test TCG. HVF doesn't work in travis.

sieve tests pass but they might timeout in travis, they were left out
because of that.

Suggested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 .travis.yml | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/.travis.yml b/.travis.yml
index f0cfc82..7bd0205 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -108,6 +108,48 @@ matrix:
       - TESTS="sieve"
       - ACCEL="tcg,firmware=s390x/run"
 
+    - os: osx
+      osx_image: xcode11.6
+      addons:
+        homebrew:
+          packages:
+            - bash
+            - coreutils
+            - gnu-getopt
+            - qemu
+            - x86_64-elf-gcc
+      env:
+      - CONFIG="--cross-prefix=x86_64-elf-
+                --getopt=/usr/local/opt/gnu-getopt/bin/getopt"
+      - BUILD_DIR="build"
+      - TESTS="ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
+               vmexit_mov_to_cr8 vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
+               vmexit_ple_round_robin vmexit_tscdeadline
+               vmexit_tscdeadline_immed eventinj msr port80 setjmp
+               syscall tsc rmap_chain umip intel_iommu"
+      - ACCEL="tcg"
+
+    - os: osx
+      osx_image: xcode11.6
+      addons:
+        homebrew:
+          packages:
+            - bash
+            - coreutils
+            - gnu-getopt
+            - qemu
+            - i686-elf-gcc
+      env:
+      - CONFIG="--arch=i386 --cross-prefix=i686-elf-
+                --getopt=/usr/local/opt/gnu-getopt/bin/getopt"
+      - BUILD_DIR="build"
+      - TESTS="cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
+               vmexit_inl_pmtimer vmexit_ipi vmexit_ipi_halt
+               vmexit_ple_round_robin vmexit_tscdeadline
+               vmexit_tscdeadline_immed eventinj port80 setjmp tsc
+               taskswitch umip"
+      - ACCEL="tcg"
+
 before_script:
   - if [ "$ACCEL" = "kvm" ]; then
       sudo chgrp kvm /usr/bin/qemu-system-* ;
-- 
2.28.0


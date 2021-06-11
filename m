Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039FD3A446D
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhFKO4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbhFKO4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 10:56:45 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68230C061574
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 07:54:38 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z8so6389948wrp.12
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 07:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MGUVPJfPcrRisFFUokakWBxPC4k6rY2BKbKi4l7lAL4=;
        b=fc4L6LGiSdFBxBObWYUT6vG1YNJvqpIAEXVotwV4/7hT9V0h/H393j8V6DpERhIgAs
         FulrDhq51N7pxJP65Ykx5vYH1yEwWlKRT2KKYNggE3mjcSfMgeaR7MLvAkeFsCuaxyo+
         Cesmdv+xYLU864z/FjEvhA282j4U7oyjn83WSjPU1LL2HQgwxBS8TdTPNSMrE+AOQa7W
         YkWOxqgxzedesnpf+QcnjptrOV7+684cOruXzFR/mqKGEepAHNZ6Wvk0nWsxBOO5ynoX
         5+pIGy1yHwlWHolU3IGXSJfsRQlNTHpDHFm/u0sKm1LfuHlv0u7BF9/clfy6ElH9tTCT
         7a4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=MGUVPJfPcrRisFFUokakWBxPC4k6rY2BKbKi4l7lAL4=;
        b=SzIID3hft/Uw0J1fUWvxncX7PzNY/+QcejZ6XNxc5vub1n93iZ2ATjY5gYSx/R6zZJ
         a+WG9ODY7QZiGcpHOBR5l9io/8gU4AyLyLcVoRVQE7V6MCayg1+i1OGd4X5dPK5dkG9a
         h8yPEVtpajAGCxwSTOlutrjVzki+WXnB746eCNgsPwCMOuYmrABFuXvIL0It3UAvYd4z
         otrlsDT69HwD8Kqb3HOeSYJQyQ+Vcj8vskrTVRcy9oCzR8riq+tAMdKk7sEDp9Tfn2aC
         2WvuT/0L1pFbqfffxenV/OnikSY+k3eTjEYXLAuSAkZBHjFj15j8GEJSoAzxhKeRVA6n
         fdNw==
X-Gm-Message-State: AOAM533PiHwhlExyKNtmfMqqqJdeal+WBfOXvjspnl/VX7Yh+c8JVdGM
        lWoQDscbEEOsjle0T6mkQ5MxWqofvoEjgQ==
X-Google-Smtp-Source: ABdhPJyYNy7SE5GQtLLmpVdFVpsUmHy6FtOclOovNkXU/qJYPoTvHludxwLSHBLKbBUBCSAsYT7NbQ==
X-Received: by 2002:adf:e0c7:: with SMTP id m7mr4757608wri.409.1623423276100;
        Fri, 11 Jun 2021 07:54:36 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m23sm10599319wms.2.2021.06.11.07.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 07:54:35 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Lara Lazier <laramglazier@gmail.com>
Subject: [PATCH kvm-unit-tests] svm: remove bogus MSRPM test
Date:   Fri, 11 Jun 2021 16:54:34 +0200
Message-Id: <20210611145434.671684-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MSR permission bitmap is two pages long.  Therefore, the first test
in test_msrpm_iopm_bitmap_addrs should actually pass.  The problem is
that KVM tries to merge the L1 MSR permission bitmap with its own at
VMRUN time, fails to map the address of the L1 MSR permission bitmap,
and fails.

Thus remove the bogus test, which is failing on QEMU.

Reported-by: Lara Lazier <laramglazier@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm_tests.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8387bea..3937b80 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2456,9 +2456,6 @@ static void test_msrpm_iopm_bitmap_addrs(void)
 	u64 addr_beyond_limit = 1ull << cpuid_maxphyaddr();
 	u64 addr = virt_to_phys(msr_bitmap) & (~((1ull << 12) - 1));
 
-	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
-			addr_beyond_limit - 3 * PAGE_SIZE, SVM_EXIT_ERR,
-			"MSRPM");
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
 			addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
 			"MSRPM");
-- 
2.31.1


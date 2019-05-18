Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDEBC22590
	for <lists+kvm@lfdr.de>; Sun, 19 May 2019 01:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfERX5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 May 2019 19:57:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32841 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfERX5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 May 2019 19:57:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id c66so11675558wme.0
        for <kvm@vger.kernel.org>; Sat, 18 May 2019 16:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kMhJTbBXNYl+EEeGppCh58hWksRuJnkaLKf4QKNC9xk=;
        b=HQ348BuALhWqhy18k5onxFPurpgRZqouVFSmEawMu+nWhSApcK07R7ku3ZnRw6Tn2I
         wD+ovcGy/VXZQXQ0J48ts63nzXAyyEmgxuuD3kpQhLPDS5ChP5t9V4nv+HFK8g2PDx4E
         yHYLDLJ5hj4D+EwiOqc38t1yMH3k+Z/E7NKYPOuFg9yDggGr+QZK3ydY4h2SRmq2yuE7
         octcyxT4AGpwL91XU0dNURkO8WjUsJ5VDgPvqwlt/1AH/wbfF8ldQmA6kpYEB8jWLsTS
         8pNW9J7hR0F8mLYdkAVGZOSXim+c2yLLSFQobWl67Hr+899d3RWsLtBKMWC8JGyjLPl1
         yuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kMhJTbBXNYl+EEeGppCh58hWksRuJnkaLKf4QKNC9xk=;
        b=Dm00YzA2uBBacDeQTpyBKDUOxq6b1lKIsIPPIsN+9YWoH9Q5WrX3szBFpi85zdVff8
         I+YwFmBUeNww9PYxE67jxYfYxPxE+NCyPoTFVAggCDlFgoIsBCNPH8kXhgkyPeewlnh4
         cgIlY3/z5bQBN8BeT4g5h3u/3xNNL5+6Kcd3JzMl89+WgxY+eVAcyxvXzGfEtSPvc7xr
         eaetOUxX/X+guamL+NkGnkj9xwPnqCXjT/cBbnNXzZHhWOUqTMj7vSsNx9Q+IMNGwgqd
         25Utqy1JZ7HrChEazHh7ufnhkFPcLZxFFFgeKUcVS1vcE6NxKa1IrkiyBUYq+vrC3pcb
         ijhg==
X-Gm-Message-State: APjAAAViis4yUeXdF4TLBe9N/p4H+v9KxepcZ7de17W7PdIUxcBW0HJW
        ERmTYwBGAnw4dwodMoEq72U=
X-Google-Smtp-Source: APXvYqy3ATtU3/D6ii6x8xERvjAiC3crB+Z6EGy5aDtTBCKHa+nKnoOTeA+sjQm2Nsr66GCAfLL06Q==
X-Received: by 2002:a1c:a7cc:: with SMTP id q195mr7124551wme.53.1558223871939;
        Sat, 18 May 2019 16:57:51 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id 7sm14364880wro.85.2019.05.18.16.57.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 16:57:51 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Fix max VMCS field encoding index check
Date:   Sat, 18 May 2019 09:37:43 -0700
Message-Id: <20190518163743.5396-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test that checks the maximum VMCS field encoding does not probe all
possible VMCS fields. As a result it might fail since the actual
IA32_VMX_VMCS_ENUM.MAX_INDEX would be higher than the expected value.

Change the test to check that the maximum of the supported probed
VMCS fields is lower/equal than the actual reported
IA32_VMX_VMCS_ENUM.MAX_INDEX.

This test might still fail on bare-metal due to errata (e.g., BDX30).

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 962ec0f..f540e15 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -361,8 +361,8 @@ static void test_vmwrite_vmread(void)
 	report("VMWRITE/VMREAD", __check_all_vmcs_fields(0x42, &max_index));
 
 	vmcs_enum_max = rdmsr(MSR_IA32_VMX_VMCS_ENUM) & VMCS_FIELD_INDEX_MASK;
-	report("VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x",
-		vmcs_enum_max == max_index, max_index, vmcs_enum_max);
+	report("VMX_VMCS_ENUM.MAX_INDEX expected at least: %x, actual: %x",
+		vmcs_enum_max >= max_index, max_index, vmcs_enum_max);
 
 	assert(!vmcs_clear(vmcs));
 	free_page(vmcs);
-- 
2.17.1


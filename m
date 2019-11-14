Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FB3FBCF1
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfKNARs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:17:48 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:43427 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfKNARs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:17:48 -0500
Received: by mail-pg1-f202.google.com with SMTP id k7so3133207pgq.10
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8J/MPbbyVLx+eRo/IQtIwrRQH9YlY/Av6MONKgQvwHs=;
        b=F6iMFFH0RwNb51PBITF0M94+XRB55GnbElZ53B7LT96UnY0Sp2v9XpBIMAWk7SBmsy
         vlSVyqNOil9RuBLF1I4p5fyp5e6UvnpAeSyfvPlwy8Nr6XTnzMExHfNph7XXRnJBSFEd
         wLJaStgpdEYzefukpsjGECI6dPSdmpUsP91tWFLWUUzMZb3/+aVM88x8WBvWa1kq+3mu
         duI1BAYuXxBVU1ISxRatVkR10Bd5WpqBYnYWh6FRdtZUMEtNlu9Wq8r8fKv0aCXowRcO
         puaFQ05pgjXOXQfXIGIZJwR3pJCxk6j5YgNoODG5w7rD+yxQkoPd7Zet5nsIyLb3Ul7E
         FuZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8J/MPbbyVLx+eRo/IQtIwrRQH9YlY/Av6MONKgQvwHs=;
        b=FUpbYPRSaDDYljU7El+GE4UuyCiSmMzDOg5v0v2dbf4mmqNp/AZtV8KWj8Jf/PZiY5
         9NTm6dqbjP9YRgwKUzywDLmm1U5pzRJI6eX7xZFs45eU9w+cXb1mb1st63b18wCb+oyl
         oiukHPyf6QO+d/uWMePhWIQbRDJqJTWPnWZF4j7rvaX7c46CLP47CVa63e8wrqt+x5vM
         2lBrvfRBQ2l2dzvRfC/e76ImIWaifpxHP7lvAOtrifoTRFh0LqBPZTKeNh5h0FasdB7i
         3d6ka6meP0Upv4Kez7m69WgtGF9IyLTX9jWZY40KRWEjY4ypIiF56V+pxqrcst33THsv
         hI4Q==
X-Gm-Message-State: APjAAAUCCk+2FYnApZTWyw9O7VDvpwRTNaBUY8u59AQQS9+072HPly5U
        sHTa93zz4/Lqa3pS1iZsHwIq/tPDCtYwjbgvNBrqbz0A3HGt2tzbCN+Kadq8hOZ/0zfrdpuVRG+
        1wZd0mMGEk1Ezk930hnlRyRp4JTchdZZvnpRWtHvDkgt9dj2jPXgyjzvowg==
X-Google-Smtp-Source: APXvYqwfBORSEE39TFTfpLW+BWwuWNudEqSNY41I0PVPSMm9KyIkVnLo8eiwq9V09O7AM+hfT+/JzOT9Gaw=
X-Received: by 2002:a63:7887:: with SMTP id t129mr5450835pgc.144.1573690667195;
 Wed, 13 Nov 2019 16:17:47 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:17:21 -0800
In-Reply-To: <20191114001722.173836-1-oupton@google.com>
Message-Id: <20191114001722.173836-8-oupton@google.com>
Mime-Version: 1.0
References: <20191114001722.173836-1-oupton@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH v5 7/8] x86: VMX: Make guest_state_test_main()
 check state from nested VM
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the vmx_state_area_test_data struct for sharing test
expectation data with the nested VM.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1d8932fad12b..95c1c01d2966 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5023,13 +5023,28 @@ static void test_entry_msr_load(void)
 	test_vmx_valid_controls();
 }
 
+static struct vmx_state_area_test_data {
+	u32 msr;
+	u64 exp;
+	bool enabled;
+} vmx_state_area_test_data;
+
 static void guest_state_test_main(void)
 {
+	u64 obs;
+	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
+
 	while (1) {
-		if (vmx_get_test_stage() != 2)
-			vmcall();
-		else
+		if (vmx_get_test_stage() == 2)
 			break;
+
+		if (data->enabled) {
+			obs = rdmsr(data->msr);
+			report("Guest state is 0x%lx (expected 0x%lx)",
+			       data->exp == obs, obs, data->exp);
+		}
+
+		vmcall();
 	}
 
 	asm volatile("fnop");
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog


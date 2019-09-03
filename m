Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3978A76A0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfICV6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:58:22 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:55505 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbfICV6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:58:21 -0400
Received: by mail-pf1-f201.google.com with SMTP id 22so15035424pfn.22
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Y+YeQZi5mcxxZPAH6LOqx4TkYPjX+MzvVXG9HRuQLX0=;
        b=jrwzcDhSi+Kn57jb5fcgRBII8ptVPeqbtY9s9mNA3JnARgDHuWgSW4H1+xTvMHaF0p
         p0R/NiWk65sywAxqRKUPvh1c42XSyBjIwQHOu0y3GEKl0ugKLQ+8YKk3iuwX0nvRCFbP
         FgMkWkpIvpixCmJaEQYwr/KHlbSoWWWq7J8bi7mKNfk4Vpc0BDyhBL6oOTFKqibezj8C
         DhGUHj00UApD7w6uj8oQzUrHheFDPel8EvO1ixiVgDWvoFNVTnLZntYfp/rPY10xqyvu
         JD0eoCaDdzytVDXuwfysm3DLkmwWJHbp0LvqiXGwpPujGOzbBoS4BvGutIKqZ8qNYSyc
         HjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Y+YeQZi5mcxxZPAH6LOqx4TkYPjX+MzvVXG9HRuQLX0=;
        b=PT10eOe6609PYoVM4uYdtLjf/sVp78sA5W29KXLS72hl6MEGJooeGukJtLT1kzglcO
         69k9aWyZ9/np1Ij2Wa9l5UeA4RnJ19jWgT9yp5ByqYuoC1PvRB7rz9Cac+rLRHC9Vynh
         Wgn8bARxysnkZqArqntgK8mqGGDOFcJVuLMfa0ckLmDkykukKTcQkO2OUCVbb97npkvR
         jE3aXyesMPp4AZsx97mWF6mP9pm9pttZ0biMH2R9luIW7qdaOo2UFdAQcjjjpvbGjLDg
         dEW5j6Qt0ISpr971Yj6Y6k3p4b8DBDfiQwMEMlOgnBb7xjKabozdzvMGmklsGUpmGmlr
         k2Gg==
X-Gm-Message-State: APjAAAUT+dgGqIwhsAKcFlo5hKqL8pX/i3UvO1GK5PomOmqS3uKSMLui
        rTbnJ8TFfqIaJsV5u/uH/SRvFxWSh2wED7erZu0t7OiYmDh0T4JjROuuIEYA4rgi1/ZSrCExewo
        /4Vgj5aP35V37acw1GxefJdApkFBCOUx4UVRxcqlHPp1ucVJS9xxvlMQn0Q==
X-Google-Smtp-Source: APXvYqyT7x9CC748hxWJH94iZ9tL1B5OV7TpcEGhFHzE6JflqJqzMdxkySilUxNXSK2A0nyzVNjZwGn7ZC0=
X-Received: by 2002:a63:e213:: with SMTP id q19mr31863978pgh.180.1567547900457;
 Tue, 03 Sep 2019 14:58:20 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:58:00 -0700
In-Reply-To: <20190903215801.183193-1-oupton@google.com>
Message-Id: <20190903215801.183193-8-oupton@google.com>
Mime-Version: 1.0
References: <20190903215801.183193-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [kvm-unit-tests PATCH v3 7/8] x86: VMX: Make guest_state_test_main()
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

The current tests for guest state do not yet check the validity of
loaded state from within the nested VM. Introduce the
load_state_test_data struct to share data with the nested VM.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/vmx_tests.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f035f24a771a..b72a27583793 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5017,13 +5017,28 @@ static void test_entry_msr_load(void)
 	test_vmx_valid_controls(false);
 }
 
+static struct load_state_test_data {
+	u32 msr;
+	u64 exp;
+	bool enabled;
+} load_state_test_data;
+
 static void guest_state_test_main(void)
 {
+	u64 obs;
+	struct load_state_test_data *data = &load_state_test_data;
+
 	while (1) {
-		if (vmx_get_test_stage() != 2)
-			vmcall();
-		else
+		if (vmx_get_test_stage() == 2)
 			break;
+
+		if (data->enabled) {
+			obs = rdmsr(obs);
+			report("Guest state is 0x%lx (expected 0x%lx)",
+			       data->exp == obs, obs, data->exp);
+		}
+
+		vmcall();
 	}
 
 	asm volatile("fnop");
@@ -6854,7 +6869,9 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 	u64 i, val;
 	u32 j;
 	int error;
+	struct load_state_test_data *data = &load_state_test_data;
 
+	data->enabled = false;
 	vmcs_clear_bits(ctrl_field, ctrl_bit);
 	if (field == GUEST_PAT) {
 		vmx_set_test_stage(1);
-- 
2.23.0.187.g17f5b7556c-goog


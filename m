Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B966115B172
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 20:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgBLT7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 14:59:20 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37571 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgBLT7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 14:59:20 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so1762202pfn.4
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 11:59:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=p0SPbfa2Y7Qjre1HXMZotEAJFpGDpcsy75Vtxrhu+pg=;
        b=D4vwvqUEWlQetxCUSRb+rHPnyzUo/wNwKfgnSMDQ9nBC0377HqKU4OMZaOB+zflKSp
         Gez3l6GjOTGDmcpY0Bx8GNJuUOUnaDnPAnnfsfwSwGmB9Hv6mMntKEtxnEURn3gom+Sw
         coPSk4gRFrvTGsFhYtcE12ywoU8C0nSU2SkMmz/kldnKMUQa6mwH4p7T6OrFPG1FvmDo
         t4Jv7F/zkjgfQj0d+xiRzpJEOOFNXkAAw44tglsdPfosqVABAvoEFNp5tcU91fYRK/EN
         +1bMi6XeeWwFJ0XP25hhoSFHqmZqseHb87DQ96XKDuUduRaO9O/n9KESs6AqtvkxTdwm
         eJ6A==
X-Gm-Message-State: APjAAAXeae7ptAfCBd6v5B60VYA6YZxu4SLOSUafaXt/bEnLE/tI+m0K
        bxagcOz63oqUE7PD961rpLqhOj7mxPI=
X-Google-Smtp-Source: APXvYqyLK2tWsG6OAJ9QSbA6dy4C0tjVObokuwy8wlqpQHSx1OPMaEe3cTivD+gg4Magf7iO7gEu7A==
X-Received: by 2002:a62:f247:: with SMTP id y7mr9944572pfl.5.1581537559410;
        Wed, 12 Feb 2020 11:59:19 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id l73sm1354822pge.44.2020.02.12.11.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 11:59:18 -0800 (PST)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Nadav Amit <namit@vmware.com>
Subject: [PATCH kvm-unit-tests] x86: vmx: Expect multiple error codes on HOST_EFER corruption
Date:   Wed, 12 Feb 2020 11:57:36 -0800
Message-Id: <20200212195736.39540-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extended HOST_EFER tests can fail with a different error code than the
expected one, since the host address size bit is checked against
EFER.LMA. This causes kvm-unit-tests to fail on bare metal. According
to the SDM the errors are not ordered.

Expect either "invalid control" or "invalid host state" error-codes to
allow the tests to pass. The fix somewhat relaxes the tests, as there
are cases when only "invalid host state" is a valid instruction error,
but doing the fix in this manner prevents intrusive changes.

Fixes: a22d7b5534c2 ("x86: vmx_tests: extend HOST_EFER tests")
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/vmx_tests.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 69429e5..e69c361 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3407,6 +3407,27 @@ static void test_vmx_vmlaunch(u32 xerror)
 	}
 }
 
+/*
+ * Try to launch the current VMCS, and expect one of two possible
+ * errors (or success) codes.
+ */
+static void test_vmx_vmlaunch2(u32 xerror1, u32 xerror2)
+{
+	bool success = vmlaunch_succeeds();
+	u32 vmx_inst_err;
+
+	if (!xerror1 == !xerror2)
+		report(success == !xerror1, "vmlaunch %s",
+		       !xerror1 ? "succeeds" : "fails");
+
+	if (!success && (xerror1 || xerror2)) {
+		vmx_inst_err = vmcs_read(VMX_INST_ERROR);
+		report(vmx_inst_err == xerror1 || vmx_inst_err == xerror2,
+		       "VMX inst error is %d or %d (actual %d)", xerror1,
+		       xerror2, vmx_inst_err);
+	}
+}
+
 static void test_vmx_invalid_controls(void)
 {
 	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_CONTROL_FIELD);
@@ -6764,7 +6785,8 @@ static void test_efer_vmlaunch(u32 fld, bool ok)
 		if (ok)
 			test_vmx_vmlaunch(0);
 		else
-			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+			test_vmx_vmlaunch2(VMXERR_ENTRY_INVALID_CONTROL_FIELD,
+					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	} else {
 		if (ok) {
 			enter_guest();
-- 
2.20.1


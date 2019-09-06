Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C1DAC1D3
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390659AbfIFVDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:40 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:41204 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389992AbfIFVDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:40 -0400
Received: by mail-vs1-f74.google.com with SMTP id z10so1171524vsq.8
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MtHBm0pGseMAAYkSQEaTbeZbYbnsK4eOlFYiZZOX+dQ=;
        b=fcK+aAHkR8sBJUMKcFcUGxb5l/t/wotm+PdMsX6pjKWKUENJH7O6FBUb/x2xeXW1Li
         ylEC3mjSzM2NUuqPs0E15sx58drIaa6mKwPaclC7usEzctYAysZ+XuLiDRHMdEgOQo6y
         DO95QL10aMbnAOh3o+r8clHCPc5YzCvVW2PM4mW85Ru3rdKekHo8YDomDuxk4cON3r5k
         hVD5yNqU+xoh7ov+DzRRyEor+VJNHJf6PadPoFmo9dUIXyyQc+x1pjBKTm8dMEmuHKSM
         6ypHd4ZkGq8oPdYN/7WpcFrwqMPMxHdMHFvdNqgjd3bsQIkiavSjT36ZnN4/RHTV+hEn
         No+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MtHBm0pGseMAAYkSQEaTbeZbYbnsK4eOlFYiZZOX+dQ=;
        b=bQd4oC1a5fYRCvQLCnSysTdo0jLC7Asy3lv2WQoTegDveWqX4vPQ45hm403VjwgU2p
         i4JlHDlhrVNKBfPc8yF9atUO1uBlASVb7giHd8PZRr/R91HsROxsvWiscugOT3ac6znm
         HLa5KusdSJxmr/ariqocsH7uZL4mXsZnukuQDm8xYrVYysag5yvxgtWEvIspvFTaCBCd
         yUtrBU5TL4i2uqiFye7pOGYJt4vYWUTmxMWkYXT3DnSFhEylgl/IACCyQzce1RCXxJ17
         2AS68/nIsTiwpQy5WUm7unw6mfVfW8LT6PSl7y02bxRmd1iE0KT/E9Yt2Pf/IUnrNVbT
         OWKQ==
X-Gm-Message-State: APjAAAVCiur44dE9wNBrY1BalF/J3aoMrOKJotH9YdEW+MWcwQEnOatZ
        KMMO4tJRDSpDxhJ754GQ5KfcUGtQxmCfZ21U7rMt5obDizST+yibARvr9QDz/gHemFNQaf08SKV
        qlcg7wLgndFN06E7wLrhYxThDQXu5/hlvG+C/pNkYQV+oNuYGfixv0id7yw==
X-Google-Smtp-Source: APXvYqz35UE0/DzWxqG58PNyj1ppHDgRP4IXzFvWX9mKn3mnpCfx3cSr1tqEujxcCsZ31+9Hh+quXjixcwg=
X-Received: by 2002:a1f:d1c3:: with SMTP id i186mr5548587vkg.26.1567803819036;
 Fri, 06 Sep 2019 14:03:39 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:12 -0700
In-Reply-To: <20190906210313.128316-1-oupton@google.com>
Message-Id: <20190906210313.128316-9-oupton@google.com>
Mime-Version: 1.0
References: <20190906210313.128316-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [kvm-unit-tests PATCH v4 8/9] x86: VMX: Make guest_state_test_main()
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
index 6f46c7759c85..84e1a7935aa1 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5017,13 +5017,28 @@ static void test_entry_msr_load(void)
 	test_vmx_valid_controls(false);
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
@@ -6854,7 +6869,9 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 	u64 i, val;
 	u32 j;
 	int error;
+	struct vmx_state_area_test_data *data = &vmx_state_area_test_data;
 
+	data->enabled = false;
 	vmcs_clear_bits(ctrl_field, ctrl_bit);
 	if (field == GUEST_PAT) {
 		vmx_set_test_stage(1);
-- 
2.23.0.187.g17f5b7556c-goog


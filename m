Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF49A763A
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfICVbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:31:22 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:48528 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbfICVbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:31:21 -0400
Received: by mail-pg1-f202.google.com with SMTP id k20so11783497pgg.15
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Y+YeQZi5mcxxZPAH6LOqx4TkYPjX+MzvVXG9HRuQLX0=;
        b=rAy1eAWKq0aLSeOOjD6OjOj0FmfXJ4uHN+5mSDmOAPFcW1HAWUADL0BeV7/Qu2Xq4v
         F1nT1nG1zsXBdrEFs/WWVQ5zFrrinB/8J8uFtwhBkEWaTewBj4f+cSVRzFyvHsPIGKmy
         0tU+TDz+XmQbzGUlr4/Mys9te1H+bslth3UyZSQFaZJgpPCeUiXXpxxl0VMQm0NnhpJ+
         kv1LoLdWUjbyJ/tAEq6zYalQffQM0jm1rjUj0b6Fg93tqncrFkZgMhx8u8Wv654Oq97N
         iI3MZd97OFjT6usQ1FDZ+zzlt6MnE2tB3Y4jORJ52WnIpt2v7eYQ7JIAmppSWcmZYeUo
         xEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Y+YeQZi5mcxxZPAH6LOqx4TkYPjX+MzvVXG9HRuQLX0=;
        b=gfIMXFJqT8/sUoeuLs+9+w8T4C/UatcPo3iYhAd0f79opgy6TCWO5Tsx68kXHJsnnp
         q02lT2yQD+7zeB7vO4XUxImHp+CvGQHdAeXK6+3mPWcgRM1aOnBHCyaW4QVPpw0p6ytl
         C77etcOBGOwsnAIbgPd683sAUMRMS9Wezz7yDAAvMb+BVz4yQhc6YTLw7ADYX3sFfhOT
         VB+3Iy2qTa41G0IbApbFG8JATgY4GKeAv79awNVuIm3dpeEF2B0ze8T1PLHozS9LeFPA
         zU5wY1SMDxtiDXReQkuXFQ6tTATUn0ktIzv1pw3bLUg8Z2G/kO9irC4WcNH3qZeRJYt8
         DpgA==
X-Gm-Message-State: APjAAAVVN4zkWnQxduozRzS8u9OognaSZvMmUh10lPx1uyZGP7Yrw2kc
        4HloH/oxTY4hXywRb+pKgkmkUE5rlSz+fq37uYG2t7Onu6mXp9NNgygZMxvOtZD0kB7fvghN6Ml
        /GEI0p6ncya6SPVK9zUUimlyeJEyvgTpioU3LaPq0rO47H0VcjyDRN3ByFA==
X-Google-Smtp-Source: APXvYqwxirMwjILwugaK1HtOqimOH2GK4iLJQWKTrQ4/30g3/uPCjJ8GbYK/74IInTX2kBUR/B21vq++RVs=
X-Received: by 2002:a65:5584:: with SMTP id j4mr31951850pgs.258.1567546279825;
 Tue, 03 Sep 2019 14:31:19 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:30:43 -0700
In-Reply-To: <20190903213044.168494-1-oupton@google.com>
Message-Id: <20190903213044.168494-8-oupton@google.com>
Mime-Version: 1.0
References: <20190903213044.168494-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [kvm-unit-tests PATCH v2 7/8] x86: VMX: Make guest_state_test_main()
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


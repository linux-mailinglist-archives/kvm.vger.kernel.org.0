Return-Path: <kvm+bounces-21987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3A6937E2A
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77A631F21FEC
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014BF14A0AA;
	Fri, 19 Jul 2024 23:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="flYsAvdj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37DC14A086
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433080; cv=none; b=tavHpfvjbh08eHit9gOjoTEOj8E3VfMdpJJKyGwChC8ZAA7BNnkjPBieWXXNOB1ckEWQxJsStJgk/f2H2k3r8uVpD6FSy1s2P0sQpDygxwxqODKBJhUMfJboAu/320MkBtiovlyifevLiVe1lOtQviuMPj8UwDAg01WJoVF5xZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433080; c=relaxed/simple;
	bh=L5K4LhEvErOvub+DyS3BuApRHh5XgLwLfLGmErCpdIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eJlR9rsipOTh52R/DIIcKS/JdNBHCQEB3PlecKLrDKGjE29uGODdFxDVFOjALOQIso5Cqj/sgbeTP9NbJ75HhOhlyNACHZ4QEO82hSe4vsdLcoiaapTtQjc8KaeSbiFEMXevUt1E8XE6W0Q9CR3Zg/0i4IwZ94i+rtsknq/UgQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=flYsAvdj; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e035949cc4eso5682483276.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433077; x=1722037877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=szsmqea3Ly+/pHf0iLcDxQ8R3kri7Zn2BloJwbPXzbQ=;
        b=flYsAvdjZTwuhmxBu59ntx1ZwFjQitc6jnnLtYYl+YyKVEqYqB7IX1H7eqjJ5SgaGS
         fJ38h7aamBCwQEOys03wXDBoIdmsJwVuxi/u1MSo9CgNxsxkmwxrNENtVLJHQx04GbiJ
         uvG0DgV7LByW+/KRKru68mSKbDjFqbrkJMzeaNJVTJ4IruAh7UF4t7AVy3doqVsDA3WI
         QxXGKXW0tMQiYdMzqHh0Q0vJVtomrfktf7eIUwYbp5VogoZKQ+kirvWg+vRqmcyOde/p
         2cQxvVrelQce2ivSrSmId0v+TReJng20MFK6M7JYaNtBOnCgFnZg4sqMcqAhzQcsAwL4
         nEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433077; x=1722037877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=szsmqea3Ly+/pHf0iLcDxQ8R3kri7Zn2BloJwbPXzbQ=;
        b=kfOSAk6f2zvjAGEaPTg67ma/nch6sol2UwRqO8VFK/TSBAqY48YxqawOWQcD19baQ1
         j1O89mvrVyhhmXVrMyd4BmjRsaesfIfGNL9ikeRPMiE5VuQ8mFj06HCPq16ephKFvRFW
         fLIIIt1ya7nyu7ik4xhlEBZMVN8kqjWRik+oiXvOebSIt50A+VyJagitJMIkJjTrMKA7
         BPoxDUofDwC24SfcCHfLyJ0yZh1wSiSWzApBIcPsf4zTgFhaPh0mIrRh3cFOZz30AgbQ
         +IyTsNXadMPviwYMWvKeQVxnrgzBgIr7zl0sT1veeg7cBtCxGWUNfBsBFmbO+0PEyDsM
         V2Eg==
X-Gm-Message-State: AOJu0Yy75cGhbFEal7gDSaq6HYAGu/Dk6tN6/CQaYfccXUJX4yF1FbQ4
	8YRa1Qt27nP/On36pw2DoV6T62NhXxGQl9tNSP1DKXGv0fPxMJOt+5mZ1+HSlVlNbdhHGiuUOqb
	Z6w==
X-Google-Smtp-Source: AGHT+IG+Kf34xxLKIMRA93LE8zHki7PaXFwYp13mgJqswzo6PchKoevDMqejbvrPRDDVtschS9qg6QN+O5I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1509:b0:e03:5a51:382f with SMTP id
 3f1490d57ef6-e087042262bmr9466276.8.1721433077656; Fri, 19 Jul 2024 16:51:17
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:51:01 -0700
In-Reply-To: <20240719235107.3023592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719235107.3023592-5-seanjc@google.com>
Subject: [PATCH v2 04/10] KVM: selftests: Open code vcpu_run() equivalent in
 guest_printf test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Open code a version of vcpu_run() in the guest_printf test in anticipation
of adding UCALL_ABORT handling to _vcpu_run().  The guest_printf test
intentionally generates asserts to verify the output, and thus needs to
bypass common assert handling.

Open code a helper in the guest_printf test, as it's not expected that any
other test would want to skip _only_ the UCALL_ABORT handling.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_print_test.c  | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
index 8092c2d0f5d6..bcf582852db9 100644
--- a/tools/testing/selftests/kvm/guest_print_test.c
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -107,6 +107,21 @@ static void ucall_abort(const char *assert_msg, const char *expected_assert_msg)
 		    expected_assert_msg, &assert_msg[offset]);
 }
 
+/*
+ * Open code vcpu_run(), sans the UCALL_ABORT handling, so that intentional
+ * guest asserts guest can be verified instead of being reported as failures.
+ */
+static void do_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	int r;
+
+	do {
+		r = __vcpu_run(vcpu);
+	} while (r == -1 && errno == EINTR);
+
+	TEST_ASSERT(!r, KVM_IOCTL_ERROR(KVM_RUN, r));
+}
+
 static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
 		     const char *expected_assert)
 {
@@ -114,7 +129,7 @@ static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
 	struct ucall uc;
 
 	while (1) {
-		vcpu_run(vcpu);
+		do_vcpu_run(vcpu);
 
 		TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
 			    "Unexpected exit reason: %u (%s),",
@@ -159,7 +174,7 @@ static void test_limits(void)
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code_limits);
 	run = vcpu->run;
-	vcpu_run(vcpu);
+	do_vcpu_run(vcpu);
 
 	TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
 		    "Unexpected exit reason: %u (%s),",
-- 
2.45.2.1089.g2a221341d9-goog



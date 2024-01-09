Return-Path: <kvm+bounces-5910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 765B4828F60
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F6BF288A3E
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 22:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2F33DBA9;
	Tue,  9 Jan 2024 22:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SDICOrhM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF543D99D
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 22:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5f874219ff9so29145197b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 14:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704837785; x=1705442585; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HrVZv+MUJLeYZ11n86dHXoyW3l+lTS8ohIoWXN+hW7A=;
        b=SDICOrhMl+22khoF//KHqgyhBpS19odsoddjkYXAn9nDZqPz1qqSvh2Bg6gKYRp8gd
         2BS/BhTtgeSM5lBgi9m6D71CzBWAgHOtIXeDgc6HteRAXGseGsMTyYjfmDLdWJs8yFtX
         p5J3ZZEhJXskiMSpCPpZ1esZsWgySJKPixs4hipQkfq+XkO+wBMD76ejd1hIgkHuqKpS
         Qn30BnwgtxFFI6zUHnxxoc+e754dgNTNXD+HiaIvE2JSqTpeYk6hEcLovxuHNunbCasl
         eOkF/0ovk90EpbpGB5gGj/KvHnnWxLCIC+QVAihT8olFODKHrBkxgOPmhgM4iW/huINR
         q3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704837785; x=1705442585;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HrVZv+MUJLeYZ11n86dHXoyW3l+lTS8ohIoWXN+hW7A=;
        b=WPXXlrvesq4jvJfJM+DHegBn6Q02+gvm54zAqtx17KFNsHavfctd5/1xQuPYG+6Aki
         dZyi6PghQwJfDfU6Hw1tBCvz0GBJ6brF6ovJs4nDPKcksoUcsX8q562QHq8sm2LM13Ba
         sIveYxJN4NZiBNF+QYz2/I58CW3ADbYvhBqbbUBKNWqB7gs6IuujbztsWVPXW+zJpkXb
         AeSLiODX0o9SaDXKzyjumZhy4ONo3CDzT0FX/cXujB07sxzq84+2TwnEvz3jyFeOR86h
         fKmmqyzpZPq0DqRP3+oOadU9/qS/342Lh8u+yfXJwflVPqvwxN4/r6xHVa1Hsccqn3iR
         onTQ==
X-Gm-Message-State: AOJu0YyaD6pDLGfGjKrs05S/9tdGK5Rp5UXcm420paSJD4sxcSCUtVRY
	Ku08/iQ8TJ0gXtVGbcMCA5nWXIccWSUwk1MCBg==
X-Google-Smtp-Source: AGHT+IGQ6JSiSvkBHs+zj9h5i2g6UpszdWvJQeKMwoZF0FHD3plsI1CEe7cxVkt/AMMKZi6/6Ei4tRUeoXk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4483:b0:5e5:ff2b:3945 with SMTP id
 gr3-20020a05690c448300b005e5ff2b3945mr84393ywb.1.1704837784802; Tue, 09 Jan
 2024 14:03:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 14:03:02 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109220302.399296-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Delete superfluous, unused "stage" variable
 in AMX test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Delete the AMX's tests "stage" counter, as the counter is no longer used,
which makes clang unhappy:

  x86_64/amx_test.c:224:6: error: variable 'stage' set but not used
          int stage, ret;
              ^
  1 error generated.

Note, "stage" was never really used, it just happened to be dumped out by
a (failed) assertion on run->exit_reason, i.e. the AMX test has no concept
of stages, the code was likely copy+pasted from a different test.

Fixes: c96f57b08012 ("KVM: selftests: Make vCPU exit reason test assertion common")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 11329e5ff945..309ee5c72b46 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -221,7 +221,7 @@ int main(int argc, char *argv[])
 	vm_vaddr_t amx_cfg, tiledata, xstate;
 	struct ucall uc;
 	u32 amx_offset;
-	int stage, ret;
+	int ret;
 
 	/*
 	 * Note, all off-by-default features must be enabled before anything
@@ -263,7 +263,7 @@ int main(int argc, char *argv[])
 	memset(addr_gva2hva(vm, xstate), 0, PAGE_SIZE * DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
 	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
 
-	for (stage = 1; ; stage++) {
+	for (;;) {
 		vcpu_run(vcpu);
 		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 

base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0.472.g3155946c3a-goog



Return-Path: <kvm+bounces-2819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76AF47FE39C
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 23:49:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F9C91F20EE6
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B2047A5D;
	Wed, 29 Nov 2023 22:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j01pUN2F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C737E193
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:49:25 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5caf61210e3so4589437b3.0
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701298165; x=1701902965; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=obqRJwrAc0R30oE9DQOo5RZu0y3Es0pUF6guVfZd4RE=;
        b=j01pUN2FfrLsdIdVuWQONS6o2QYDAtPibP9zZIe4jIeN5cS2kUhvpbzr7BF3hZjSet
         2ZkCXkWYDDb3LbvsCg6MNGp/uI3ZwWjvG3tB/NpKbth1cXF9xjFCY4IOkWXkyNsTMzdF
         cM44Fg6edusAbgN+/1twVIToLEu87QMLKubFhD3TyKwsu4VEiK9Be/rc25ZbGe7boCMG
         L7S3pTyB7sD3/nbhc26aKpXgbKsbslKIwSW3f69MdMyR/aGKMoK54MEgW+idjIXrMdv7
         +DCabK675yKPbgf1InOA1Ocogyl1FPlGVwNWmlKBUtG/uY4NvG+dMkkd18VNkfQdQSlJ
         aPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701298165; x=1701902965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=obqRJwrAc0R30oE9DQOo5RZu0y3Es0pUF6guVfZd4RE=;
        b=l3OVVJZzrXnP/EbD3GGx3B7YlHfYPb2p7a5C/FuIY6CiUS+ToN1lc0C9UFirg0ujXd
         2GxhYbaaec/0BR+SYwpna9m+2gU5hGY/ROA0qQA9hjXuEOL3VUL/XUXWPGpZzrAK4nCN
         RcBp5xTHkleLMn4SgTSdW+PdJPG5yEH5aED3kEdCyAMz+MCYXBI6myTi+dJq+xKw8mvv
         xN3f2xs1oQ9wA2iXCX4TSKrMElYBGkmg184KeFc7kHPbT5Wp6HYLqY7okJPm7oYEvdlY
         kwBH0D1VyJHhi+XRxURaNG/e91g1LKc+VhTXM2YggqHpfLYYA/XR+6Hy8DwSvZxW1ab9
         4BZw==
X-Gm-Message-State: AOJu0Yx2rXgKanLp93Cyx08A7M9DsI2RnZlb0kfr5YOloxhqD/eW9jyG
	HNgfGxWWO8i5WB+t8PVM7Raqzyenm70=
X-Google-Smtp-Source: AGHT+IFiO/2Aj0FYANjdTLdz18AsCY+hgJd7gw2a7Qpd4J7gUjOl+TCyJnqhI0rjeJ5wx0LkoWDUuMe+l24=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:e19:b0:5ca:724d:9256 with SMTP id
 cp25-20020a05690c0e1900b005ca724d9256mr709697ywb.7.1701298165115; Wed, 29 Nov
 2023 14:49:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 29 Nov 2023 14:49:15 -0800
In-Reply-To: <20231129224916.532431-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231129224916.532431-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231129224916.532431-4-seanjc@google.com>
Subject: [PATCH v2 3/4] KVM: selftests: Fix broken assert messages in Hyper-V
 features test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Swap the ordering of parameters to guest asserts related to {RD,WR}MSR
success/failure in the Hyper-V features test.  As is, the output will
be mangled and broken due to passing an integer as a string and vice
versa.

Opportunistically fix a benign %u vs. %lu issue as well.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 4bb63b6ee4a0..29f6bdbce817 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -55,11 +55,11 @@ static void guest_msr(struct msr_data *msr)
 	if (msr->fault_expected)
 		__GUEST_ASSERT(vector == GP_VECTOR,
 			       "Expected #GP on %sMSR(0x%x), got vector '0x%x'",
-			       msr->idx, msr->write ? "WR" : "RD", vector);
+			       msr->write ? "WR" : "RD", msr->idx, vector);
 	else
 		__GUEST_ASSERT(!vector,
 			       "Expected success on %sMSR(0x%x), got vector '0x%x'",
-			       msr->idx, msr->write ? "WR" : "RD", vector);
+			       msr->write ? "WR" : "RD", msr->idx, vector);
 
 	if (vector || is_write_only_msr(msr->idx))
 		goto done;
@@ -102,11 +102,11 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 	vector = __hyperv_hypercall(hcall->control, input, output, &res);
 	if (hcall->ud_expected) {
 		__GUEST_ASSERT(vector == UD_VECTOR,
-			       "Expected #UD for control '%u', got vector '0x%x'",
+			       "Expected #UD for control '%lu', got vector '0x%x'",
 			       hcall->control, vector);
 	} else {
 		__GUEST_ASSERT(!vector,
-			       "Expected no exception for control '%u', got vector '0x%x'",
+			       "Expected no exception for control '%lu', got vector '0x%x'",
 			       hcall->control, vector);
 		GUEST_ASSERT_EQ(res, hcall->expect);
 	}
-- 
2.43.0.rc1.413.gea7ed67945-goog



Return-Path: <kvm+bounces-32667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EC59DB0E5
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F06B7162755
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C08196C7C;
	Thu, 28 Nov 2024 01:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y3ASrgPh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64A919067C
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757702; cv=none; b=fXkq2UXtMzTOJPHGdnVVOSDmFoTU/7M11cpKT6e7O3TM+nMy7Mhzrt4SMZeYdBKpJHVa+XD+xzmkfFtrBX0MZFPk4cSc4pI2fPpuWrU4KoeaTgRch/OayxyWg6q50zhV3wC4uOVQ0lDOcOsBiOpwCFXi+IP+bfQox2rS6LHfdGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757702; c=relaxed/simple;
	bh=cbbs+IW/NbNg8bOD1ExLdSHyieLi+4CBsRm7uNwsQy8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d1MTqTED8HCZ/wJZrLN26heNvQL47FDpymYRGnn0QxZAXldubHCU1owVsFduDLJei1+oZ8Eoxf2xV1J+xZQYx3959GFcHQhNTReu+bzj/Wf8X/dhxnwh9VIKlsEUYNSnyReo5oOLlXwKZIL6+YhhoqXA8rVeGvpIpI3XW+2JoPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y3ASrgPh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea2bf5b5fbso330929a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757700; x=1733362500; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tkIRJi9hWBp1lddY87MgHAVSYrJKfSqjaHK6jf7PQL8=;
        b=y3ASrgPhyGBZqGT11pGYHcTavzPxvP/+RxcvCCpUZG5JSvIpBXrjy1llnSLzHnVx0k
         8n4C/44pxBlSC3wr4jyrkeJWURApGJR+5dnDY3QopB49TRpnXIuK1H/UDDE73PFt0tXi
         zbGCOPO55e9vhU705cF/BSy2o3+HHtMz4+aJYZWMAu5+7uw6uThP6PSWpgK8wwcTH/oU
         AClydoJ95H4LCFYa6aaEGcKIg+CpXk35fvvhS5Bbaz+WcLdoUlWfYTmcRRUYgYb/URkd
         FivY0ybGIl3VuuT/2gBhkWHK2h13tNjGtNNBoZp4ouWAKMi0ldomO4QUPglJsMLlFA1x
         lrkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757700; x=1733362500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tkIRJi9hWBp1lddY87MgHAVSYrJKfSqjaHK6jf7PQL8=;
        b=iEtLFGKlGVDiYoBpZ7qZZJ0MlzTe2nRiokAha4DalT8MnalvKDZly/18gV3gDlUgHc
         SrUMUtgpnx+RbUGptdZr30dT2EQxT9oAmt8s/ytrLHQwhC2Rq7N1T9vxXyNSielFqSxM
         S5OpAnRjrcyYLMe7R1YPEOUaCfYXSTXKmFoGRgCYc+YaMTMtS0v2isfvdrPHei7IJewW
         qjsrqBoZe4/j4CFA2OmDLfbfqABEHSaAHagd0XZzfV9NZRkLePThNfRA2VdYzTPWdS1a
         KKdtM6TNyNXB/a4cv3hmMFNRIhanv+cjuJWCVFwHPsrJhceIAimjvE7HhM2hxbl5DCiH
         b+1Q==
X-Gm-Message-State: AOJu0Yx/hQeRu6wEcpM+9BOx0B5Vd9yts4cb7R49J5o3Vz4vcB2BTRGH
	gdEEJzLbqNPkl0rul4rxC2JqWVlOS3MPWNrEWOnfqtQ25cChdKzzIWaecOp8WEAMQ3b6U2PQS13
	BVA==
X-Google-Smtp-Source: AGHT+IHj7bunZqsrMJqyJ0DOJh4l8WYWBGi8wZuUkIl5BQnppNnhNxCcsaMgndMNUNsLOrxgCJY9E8zR6MQ=
X-Received: from pjbmf12.prod.google.com ([2002:a17:90b:184c:b0:2d8:8d32:2ea3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b91:b0:2ea:3d61:1848
 with SMTP id 98e67ed59e1d1-2ee097e33d4mr5931840a91.34.1732757700100; Wed, 27
 Nov 2024 17:35:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:43 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-17-seanjc@google.com>
Subject: [PATCH v3 16/57] KVM: selftests: Fix a bad TEST_REQUIRE() in x86's
 KVM PV test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Actually check for KVM support for disabling HLT-exiting instead of
effectively checking that KVM_CAP_X86_DISABLE_EXITS is #defined to a
non-zero value, and convert the TEST_REQUIRE() to a simple return so
that only the sub-test is skipped if HLT-exiting is mandatory.

The goof has likely gone unnoticed because all x86 CPUs support disabling
HLT-exiting, only systems with the opt-in mitigate_smt_rsb KVM module
param disallow HLT-exiting.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 78878b3a2725..2aee93108a54 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -140,10 +140,11 @@ static void test_pv_unhalt(void)
 	struct kvm_cpuid_entry2 *ent;
 	u32 kvm_sig_old;
 
+	if (!(kvm_check_cap(KVM_CAP_X86_DISABLE_EXITS) & KVM_X86_DISABLE_EXITS_HLT))
+		return;
+
 	pr_info("testing KVM_FEATURE_PV_UNHALT\n");
 
-	TEST_REQUIRE(KVM_CAP_X86_DISABLE_EXITS);
-
 	/* KVM_PV_UNHALT test */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_KVM_PV_UNHALT);
-- 
2.47.0.338.g60cca15819-goog



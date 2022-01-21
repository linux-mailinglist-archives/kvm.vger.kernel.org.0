Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D8B496719
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 22:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiAUVHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 16:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiAUVHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 16:07:32 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26841C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 13:07:32 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y2-20020aa78042000000b004c5f182c0b4so4546360pfm.14
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 13:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eSs0sFAIlBdAFYfp8PjLyYXRbLmiGYwAIhICb2W7riI=;
        b=Xfv65O/BDaq4XVqL5GO1IOzFoNMQCM3N0wzD5/EZg3FVkHTmGdG73485IyjdW/4Lm9
         aZy+CdXs6k1EOS4QUzDDEE1V3ojKdRCf17gm+VwlXgUN8i2v6zhUThlDoQTlDPr0VP2f
         JHJY25WkBuvFxQwiHyTqpzR8mR59jzdYJKWiReTm9A6gyrrgsS1v1Fj7BfER8C9EMPzI
         jyTVKHUkfFr7+v0HJj5IDaGitQiOntsXkB9aZmPXlcYVZTI/h3vSgYyPV1Iz5VTIjeej
         a9E1xvGltzKq5NSOE7WHWvnJ58EK+ssrXMeKF5ZOv/Aki2z3AA/6EIrrDh8J0S7ZqIaU
         PYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eSs0sFAIlBdAFYfp8PjLyYXRbLmiGYwAIhICb2W7riI=;
        b=TKYdxXyK16A79Z5fIhruc+zv+lPiRYz155vbTglSjknTyQhutMXFSqtFQpFYd9vQXy
         Etd0r5b/n1JexPZQe2C/yn+1qMJGSlaYdJussp/i0DS+zPpyDparaHRZF4Qz7onQ5MOJ
         hVbWAgabopJKPSFZn81+llA8UZEUPncsGDNvRizs+eOh9fJN1ZAvhEsyEEzeWAXl8qdH
         sfXXEIGrBsx2TH60HKpE/JAWcgXCEbdhyIiTnA6+fUjsJVXnTkZeQk8ZX+NAMKH9CseI
         72PW1nnzf14MIpLp3cytu02fm8U27xpoCOahiZIA148LC2LzpBxhypOR+pIIlDAJ6M30
         cN+Q==
X-Gm-Message-State: AOAM533T1kFS1PVDCXIPGyRZX9L2zENqt6ubnm3zO5mXVmGx+8UWIFaP
        K8WRqE0KQoHxsIiCoC4eg4MRf+dyHois/iHHHudg64XvjIYLP6XHid4WlZ2OF53yKyP6hfzDTif
        RuqIN3UAyXo0oYKKJ11ORW1L6u7YN8ciy02vZBrlq4sM5GWiN3pUm8mBTrDpoEJcStA==
X-Google-Smtp-Source: ABdhPJxzCwt/sNfvczU2hcGqIClDYCLTTqRmXKTsH+eZbfW7k8sGG8oha39tDu+unRKKoSUx/QIF187mP1HLJJM=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:903:18d:b0:14b:fa3:ad7d with SMTP id
 z13-20020a170903018d00b0014b0fa3ad7dmr5336766plg.48.1642799251583; Fri, 21
 Jan 2022 13:07:31 -0800 (PST)
Date:   Fri, 21 Jan 2022 21:07:02 +0000
In-Reply-To: <20220121210702.635477-1-daviddunn@google.com>
Message-Id: <20220121210702.635477-4-daviddunn@google.com>
Mime-Version: 1.0
References: <20220121210702.635477-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v3 3/3] KVM: selftests: Verify disabling PMU virtualization
 via KVM_CAP_CONFIG_PMU
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com, seanjc@google.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a VM with PMU disabled via KVM_CAP_PMU_CONFIG, the PMU will not be
usable by the guest.  On Intel, this causes a #GP.  And on AMD, the
counters no longer increment.

KVM_CAP_PMU_CONFIG must be invoked on a VM prior to creating VCPUs.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index c715adcbd487..9e38730d6f87 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -325,6 +325,39 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
 	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
 }
 
+/*
+ * Verify KVM_CAP_PMU_DISABLE prevents the use of the PMU.
+ *
+ * Note that KVM_CAP_PMU_CAPABILITY must be invoked prior to creating VCPUs.
+ */
+static void test_pmu_config_disable(void (*guest_code)(void))
+{
+	int r;
+	struct kvm_vm *vm;
+	struct kvm_enable_cap cap = { 0 };
+	bool sane;
+
+	r = kvm_check_cap(KVM_CAP_PMU_CAPABILITY);
+	if ((r & KVM_CAP_PMU_DISABLE) == 0)
+		return;
+
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+
+	cap.cap = KVM_CAP_PMU_CAPABILITY;
+	cap.args[0] = KVM_CAP_PMU_DISABLE;
+	r = vm_enable_cap(vm, &cap);
+	TEST_ASSERT(r == 0, "Failed KVM_CAP_PMU_DISABLE.");
+
+	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	sane = sanity_check_pmu(vm);
+	TEST_ASSERT(!sane, "Guest should not see PMU when disabled.");
+
+	kvm_vm_free(vm);
+}
+
 /*
  * Check for a non-zero PMU version, at least one general-purpose
  * counter per logical processor, an EBX bit vector of length greater
@@ -430,5 +463,7 @@ int main(int argc, char *argv[])
 
 	kvm_vm_free(vm);
 
+	test_pmu_config_disable(guest_code);
+
 	return 0;
 }
-- 
2.35.0.rc0.227.g00780c9af4-goog


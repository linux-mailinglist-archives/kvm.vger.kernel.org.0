Return-Path: <kvm+bounces-2069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B8527F134B
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24918B21A1C
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854AA1A71B;
	Mon, 20 Nov 2023 12:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UV9G9u7G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A12F7
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:47 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5bde80aad05so3414597a12.2
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700483387; x=1701088187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgx8LkV8H82w8tImzphDtH1iEDRz4SAPPUMfGtDicEM=;
        b=UV9G9u7G3uQ/ta/vTHdo7fAak5P8r0tSEcHFF00TgvxrRJ12MBShX9xoShTf+DERQM
         i1b9xOkoz4XGvzs7WnYV87T2BrbAKIDQQ/ffVSeleZ8zlYCYiB80pVzNzVjXET0217D3
         liIoBvMx6uXsioehgjmk9rYI13WBb5YKueYZ75bJ4VeW2voboH3n07i7lTN6katEkyO9
         d1eXYEYnlK337Xoj+IZsL3GrjtU6KBuiPZoLUn9NIlUYDpbfv8LiLJTaj44rl70HFHUd
         Pla3xHXYZ/yxTgl7DX5UzCRjdC0P28hE3/B9scPq/+pjfhsv48Ig0VOx3Tw74nT0fZ0z
         9XtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700483387; x=1701088187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rgx8LkV8H82w8tImzphDtH1iEDRz4SAPPUMfGtDicEM=;
        b=RtzOSvGHdTdGlppnU09xD3Y4ylSU8dD3WLWhdCnQycdCKIRttey54wxeTDNRNlTGHr
         jQghx/mRM82GzcredUmOuIHIAkS4aUqIwHzAIikwx2zU6FB7a1JPkySMRO+tl1S8gpXc
         /xVLNxJFGWikb7+RNorOAGW4G7s/BrnLT+fkTvj8upN0LDwBUHKFoQKAwhIWBemEE/Aj
         uoVShNUJiumEaUdORaQXEf3YqZew4T69nT3WcJP2K8HSfopZIb5VRaozATEm0naym4eh
         1t+CQMyzBYDP9LR9EL+m5GjDkeKRWVTYbXrQJQLUuaDK5uLK8FOQKR5qmzVUzUsslUaV
         n1bA==
X-Gm-Message-State: AOJu0Yyf9/gvGmkZRceZ+eYWYmcVFY7waS9dKXFQuDJlpUaFbDjZvZ4v
	E0G2Y0y8bJ9daYrJGMqt6lru1wKlDJw=
X-Google-Smtp-Source: AGHT+IEibB6+6VzrAmexQ6L9y13uR22ZWYNVN8FC5GZHCDTfmSbEJdroHwYxybkyfCXhWzRBWtMSrQ==
X-Received: by 2002:a05:6a20:8f27:b0:186:8dc1:f4a with SMTP id b39-20020a056a208f2700b001868dc10f4amr9984281pzk.0.1700483386805;
        Mon, 20 Nov 2023 04:29:46 -0800 (PST)
Received: from wheely.local0.net (203-219-179-16.tpgi.com.au. [203.219.179.16])
        by smtp.gmail.com with ESMTPSA id d13-20020a056a00244d00b00690fe1c928csm6047477pfj.147.2023.11.20.04.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 04:29:46 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	Sean Christopherson <seanjc@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v4 4/4] KVM: PPC: selftests: powerpc enable kvm_create_max_vcpus test
Date: Mon, 20 Nov 2023 22:29:20 +1000
Message-ID: <20231120122920.293076-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231120122920.293076-1-npiggin@gmail.com>
References: <20231120122920.293076-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

powerpc's maximum permitted vCPU ID depends on the VM's SMT mode, and
the maximum reported by KVM_CAP_MAX_VCPU_ID exceeds a simple non-SMT
VM's limit.

The powerpc KVM selftest port uses non-SMT VMs, so add a workaround
to the kvm_create_max_vcpus test case to limit vCPU IDs to
KVM_CAP_MAX_VCPUS on powerpc. And enable the test case.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 tools/testing/selftests/kvm/Makefile               | 1 +
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a198fe6136c8..1e904d8871d7 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -211,6 +211,7 @@ TEST_GEN_PROGS_powerpc += dirty_log_test
 TEST_GEN_PROGS_powerpc += dirty_log_perf_test
 TEST_GEN_PROGS_powerpc += guest_print_test
 TEST_GEN_PROGS_powerpc += hardware_disable_test
+TEST_GEN_PROGS_powerpc += kvm_create_max_vcpus
 TEST_GEN_PROGS_powerpc += kvm_page_table_test
 TEST_GEN_PROGS_powerpc += max_guest_memory_test
 TEST_GEN_PROGS_powerpc += memslot_modification_stress_test
diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index 31b3cb24b9a7..330ede73c147 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -51,6 +51,15 @@ int main(int argc, char *argv[])
 	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
 	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
 
+#ifdef __powerpc64__
+	/*
+	 * powerpc has a particular format for the vcpu ID that depends on
+	 * the guest SMT mode, and the max ID cap is too large for non-SMT
+	 * modes, where the maximum ID is the same as the maximum vCPUs.
+	 */
+	kvm_max_vcpu_id = kvm_max_vcpus;
+#endif
+
 	/*
 	 * Check that we're allowed to open nr_fds_wanted file descriptors and
 	 * try raising the limits if needed.
-- 
2.42.0



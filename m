Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7809D3DFD6A
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbhHDI65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbhHDI64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:58:56 -0400
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A81BC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:44 -0700 (PDT)
Received: by mail-oi1-x24a.google.com with SMTP id o5-20020a0568080bc5b029025cbda427bbso833837oik.5
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gCg0AznWgA4f1SrJgUwp//MIUEfrq8bP1cnOz9mraho=;
        b=MTCyPCTw0RZ+dPZ2ozrA+5wli9Ay+UMDLegw4vajpPfpUxDPSiKLc0KjPDr4t1VbV+
         J5VC+2D7LilUe7K9hJUgzZnIgERsJnXnBOOJYtyh6k6G9qjp7rB8PeWklTOaYdZpRZBf
         Adib//0K6WdMcr9nPQKZ/DWsF8taEaq+gazsww/VYX1ooxIuECdYs3LHF/RsUdd5IJOD
         XsBqzD2xkkZt2+J8vZhLXIt8kNwajcSPkONGtG2CEIG2seo6FgP/ztuUH/GpEm5NJjZA
         C8Buw2XEUbP1aCptyDiqWmQAmJ9h3TUzJU2weTZs6VSF8YzfckKutAH1jJXm2v8olilU
         PR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gCg0AznWgA4f1SrJgUwp//MIUEfrq8bP1cnOz9mraho=;
        b=iuPDeA3hGZgEPlmmQfyAJhuDdh0++vYSU0HVgyRWAXXGWQ/squ9gsLq3XLJs/wWAtm
         E0qGv1YhVSK1RJhfJGRJvb7svMe+RgiVyTTkqzaJdwjffOfStvCOVxvkvxEq7z3uFLme
         EnQSdRahUtZ5TYpuYaRSJZOse35BFM4pFyQTwu4wlnHgRSIK2dwn9Y95DOGGPfTadjhj
         XE29j/T8HJon0f+NjNiVWUp+lNjdWus7BwF+E4xDSvk0O48daDouowSTNtmIt4vRnpyn
         AvAL7NC62YuTGcYMSO5mkTiGO4x4q23MpW48U/omnJA6iwpzXMLY7ZUcSVpNsH238EQT
         1RXQ==
X-Gm-Message-State: AOAM532gdh/ZK3VVf2neh7Y9gpHnVTx1Uurpsx/arwMqLofVQGaJNp4O
        V7LxzeVJe24PB/rOC3WjOksp0L6H/5C+V3wzCqXkgueqBZhxeTrageC1XJNsERlXiTxwMjZYcPY
        3zRFCnY5mKzL0z7H5PKb61gTsLB0VMD0cmTwjYDldfTAYZ40ZUNHcqATzrA==
X-Google-Smtp-Source: ABdhPJyrF6Z/oAvVMCwq6Zwnl1O8bPPs3vKcjVomi62Qv2JKaBWWKXDpL2ITIDF27NgJQLbzg5F4wv4SoZ4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:68d:: with SMTP id
 k13mr17591632oig.83.1628067523355; Wed, 04 Aug 2021 01:58:43 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:06 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-9-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 08/21] selftests: KVM: Fix kvm device helper ioctl assertions
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_CREATE_DEVICE and KVM_{GET,SET}_DEVICE_ATTR ioctls are defined
to return a value of zero on success. As such, tighten the assertions in
the helper functions to only pass if the return code is zero.

Suggested-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..0ffc2d39c80d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1984,7 +1984,7 @@ int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
 {
 	int ret = _kvm_device_check_attr(dev_fd, group, attr);
 
-	TEST_ASSERT(ret >= 0, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
@@ -2008,7 +2008,7 @@ int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
 	ret = _kvm_create_device(vm, type, test, &fd);
 
 	if (!test) {
-		TEST_ASSERT(ret >= 0,
+		TEST_ASSERT(!ret,
 			    "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
 		return fd;
 	}
@@ -2036,7 +2036,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 {
 	int ret = _kvm_device_access(dev_fd, group, attr, val, write);
 
-	TEST_ASSERT(ret >= 0, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
-- 
2.32.0.605.g8dce9f2422-goog


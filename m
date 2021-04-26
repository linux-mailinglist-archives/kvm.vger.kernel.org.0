Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A67536B049
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhDZJK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhDZJJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 05:09:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2A1C061763
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:26 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s15so177053plg.6
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V50YyMbdbg4kQSCC5l/2b7FBtbZFhZcyEXS5Kc3/Kqk=;
        b=Za4K1kqevYO48etJVHFvsJSz5Lpt2B7otONeFbwl8U91tfs2k0ZWOgpaTPJvoqt87r
         GnZRGMhsbds1i7v30bAxXk5gcYXkOtmC8hBem5xAO+Hi8iW5e62iU0AlU5brTo4SNSyn
         JDC40NZFnx4VaEdPeYrHKVQeMEDa1Q9y1dXiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V50YyMbdbg4kQSCC5l/2b7FBtbZFhZcyEXS5Kc3/Kqk=;
        b=jJ5u9cT1w4/L2svZYb8KFvgFIkkbWUX7piJ0xeIUBRkiXvo63gjRVJFb30DKZctpIo
         RrE7o2Fp3/5kCWIXJ+EJiZz2sLuahm08Pfrz+hBPh2AypgkpO2oqc6wJ3WjRLIPxLmPz
         H82zhDO40FyemdKkpdrMUmFXZ1EVz4xbnO0f9i/OHcdsaLcblaHk4DgNTIcXe0NpPxsg
         bc3TI3vU2hIgLD324QjbwwF36xsiROimAq2CoPZ4FWcUKSHc+iv0xOKssl8DJDl/eDKH
         Nm1YFrJCTUqnNJKZRBC6nLz4q4QxdA44lj1NhQXLJ9zNaRZSFFF3pj+dAv2kkbMzrPQz
         kWJw==
X-Gm-Message-State: AOAM532oBPv1JH7IFCMWJyry90tpDgNeenK61mSG3A3V+31XpCkoX5Bo
        avfq7hg4L7JsEt0iClxAG/VxNDomxTtyvQ==
X-Google-Smtp-Source: ABdhPJyQGYzq+3+Y2biONIrwkE7niPYsewV7PhLNOyYleKr/TJht+Nwnjq940Dao4JQSvBYmyTDSFQ==
X-Received: by 2002:a17:902:d2c3:b029:ec:b1ce:c488 with SMTP id n3-20020a170902d2c3b02900ecb1cec488mr17905356plc.4.1619428106144;
        Mon, 26 Apr 2021 02:08:26 -0700 (PDT)
Received: from localhost (160.131.236.35.bc.googleusercontent.com. [35.236.131.160])
        by smtp.gmail.com with UTF8SMTPSA id m2sm10679322pgv.87.2021.04.26.02.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 02:08:25 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     kvm@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/6] x86/kvm: Reserve KVM_FEATURE_HOST_SUSPEND_TIME and MSR_KVM_HOST_SUSPEND_TIME
Date:   Mon, 26 Apr 2021 18:06:40 +0900
Message-Id: <20210426090644.2218834-2-hikalium@chromium.org>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
In-Reply-To: <20210426090644.2218834-1-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change; just add documentation for
KVM_FEATURE_HOST_SUSPEND_TIME and its corresponding
MSR_KVM_HOST_SUSPEND_TIME to support virtual suspend timing injection in
later patches.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

 Documentation/virt/kvm/cpuid.rst |  3 +++
 Documentation/virt/kvm/msr.rst   | 29 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index cf62162d4be2..c7cb581b9a9b 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -96,6 +96,9 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
                                                before using extended destination
                                                ID bits in MSI address bits 11-5.
 
+KVM_FEATURE_HOST_SUSPEND_TIME      16          host suspend time information
+                                               is available at msr 0x4b564d08.
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..de96743245c9 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,32 @@ data:
 	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
 	and check if there are more notifications pending. The MSR is available
 	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_HOST_SUSPEND_TIME:
+	0x4b564d08
+
+data:
+	8-byte alignment physical address of a memory area which must be
+	in guest RAM, plus an enable bit in bit 0. This memory is expected to
+	hold a copy of the following structure::
+
+	 struct kvm_host_suspend_time {
+		__u64   suspend_time_ns;
+	 };
+
+	whose data will be filled in by the hypervisor.
+	If the guest register this structure through the MSR write, the host
+	will stop all the clocks including TSCs observed by the guest during
+	the host's suspension and report the duration of suspend through this
+	structure. Fields have the following meanings:
+
+	host_suspend_time_ns:
+		Total number of nanoseconds passed during the host's suspend
+		while the VM is running. This value will be increasing
+		monotonically.
+
+	Note that although MSRs are per-CPU entities, the effect of this
+	particular MSR is global.
+
+	Availability of this MSR must be checked via bit 16 in 0x4000001 cpuid
+	leaf prior to usage.
-- 
2.31.1.498.g6c1eba8ee3d-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0332141B6A5
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242321AbhI1SuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242273AbhI1SuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 14:50:02 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D589C061753
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q8-20020a056902150800b005b640f67812so19315052ybu.8
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZhEmB78EvpVTOsANLrCosu8pC98ZcmeaZO8tz0FwGlI=;
        b=YNSS8yS/z8jbHApl7mmywh0W1TLkLd6JZW49ibxi38G0CqByei3gUhtbVVxcFCqznL
         +eSsAuKpRCII6ctpAJcMLK326hVO9wf6Qjvb1e9jXGnbGH/7gyzCelwLv33aSk7XkPyY
         WIuuK9d2jFhVnU6d9niPepKKA3DMV2pipGQ7dclPi7UGDZIu+GrbJt8UKsgcUF26H9b6
         o3vAZSIUZAcmLp2DDQk0w3bzO+VAD1+87XkH6BnUlPEXFWJCVeYmz60YJEBqrfk7/1qm
         AhEpJU+tSBBYGt+qBlpBNkVNzMtzmgVuViMRfT69EWX3K5xUUyVAZr6wQz0mUQVP5O5b
         3lDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZhEmB78EvpVTOsANLrCosu8pC98ZcmeaZO8tz0FwGlI=;
        b=jC6QmlfulEqWjRRAL8LQdYNa/oMANAsEn7d1Iw7TzFX42QrIcgWQMZkzzqFWdPdQ0m
         ZQWOqgUW4ILjCVDrF9oGDMx7DfuPwTkL6y2ZC4MBUUGLmGy9Wi6hlUo8i+wubaJfFtW4
         KADQuxA7ktZzlvpVDlaauEReWH5q7Q1OWV3JihmthP7T1kvg4Q+Oam8FpBRtJv+WzJ9J
         +6vGeOj/RQzUnGWKoMIzm3KQpxjsknMtUh4ZIQyKN4S82IGwOMddHh15+8tb2CNzEvbX
         5BtEMBArWkwZXTlxflusup3bULjtT7tL2zvSjAwlZFXx+6PbkHEk5RWBgCWdTO9v6gvd
         RBQg==
X-Gm-Message-State: AOAM532C7WEM/2Xdj5wMu8wlHQLo58vOC7zYXs+xBNdmIPRNCeWS9sjT
        RGeoX9DJPdBg2pqq7+9sEu3Gsu6oXJ1WZtCy1juwV+50in/r2fHYZA3E4S13Wz/tWaxh4tk8Mvv
        Y+k0zx2BeKu9J+UHBnMrLHJj/7HM+1y+ubRWViiI/imtpl0bUnDWWWg/ZzIYqgug=
X-Google-Smtp-Source: ABdhPJzDRwtz5/PIS4rEfzA7iNdd+2JLcH0fuSM5FcZ6MjFSl3lzeEEHGCn8BGM6vv2p+Afxprn6T8QiiqVT3w==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:22d7:: with SMTP id
 i206mr9011325ybi.355.1632854901316; Tue, 28 Sep 2021 11:48:21 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:48:03 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-10-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 09/10] KVM: arm64: selftests: Add test for legacy GICv3
 REDIST base partially above IPA range
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new test into vgic_init which checks that the first vcpu fails to
run if there is not sufficient REDIST space below the addressable IPA
range.  This only applies to the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API
as the required REDIST space is not know when setting the DIST region.

Note that using the REDIST_REGION API results in a different check at
first vcpu run: that the number of redist regions is enough for all
vcpus. And there is already a test for that case in, the first step of
test_v3_new_redist_regions.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 77a1941e61fa..417a9a515cad 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -570,6 +570,39 @@ static void test_v3_last_bit_single_rdist(void)
 	vm_gic_destroy(&v);
 }
 
+/* Uses the legacy REDIST region API. */
+static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
+{
+	struct vm_gic v;
+	int ret, i;
+	uint64_t addr;
+
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1);
+
+	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
+	addr = max_phys_size - (3 * 2 * 0x10000);
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+
+	addr = 0x00000;
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+
+	/* Add the rest of the VCPUs */
+	for (i = 1; i < NR_VCPUS; ++i)
+		vm_vcpu_add_default(v.vm, i, guest_code);
+
+	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
+	/* Attempt to run a vcpu without enough redist space. */
+	ret = run_vcpu(v.vm, 2);
+	TEST_ASSERT(ret && errno == EINVAL,
+		"redist base+size above PA range detected on 1st vcpu run");
+
+	vm_gic_destroy(&v);
+}
+
 /*
  * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
  */
@@ -621,6 +654,7 @@ void run_tests(uint32_t gic_dev_type)
 		test_v3_typer_accesses();
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
+		test_v3_redist_ipa_range_check_at_vcpu_run();
 	}
 }
 
-- 
2.33.0.685.g46640cef36-goog


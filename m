Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46507A6603
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 16:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjISOAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 10:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbjISOAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 10:00:23 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915C983;
        Tue, 19 Sep 2023 07:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=RGkl3s+m6QQ803Sq5zfxO05XwCR0rwq9bcU2qbCs9YA=; b=EYVPA7eaxhETNlYAlnnDPkvS6M
        F6wO5TM2a2ZkN9CFQRcNB+hQDiYP0Do8pm/rB1LIHxcDh7NzyJ90ruokn3hM21KckydiyvajJ5tps
        IhSvoyJwONuSI/qIJxtFgSZw261HrqkdngMNd4DdiEdA4ZU8e5kIJ/LuH28ETolZor9U=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qibGy-0004Yy-GM; Tue, 19 Sep 2023 14:00:16 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiazT-0005jy-Sj; Tue, 19 Sep 2023 13:42:12 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v4 12/13] KVM: selftests / xen: don't explicitly set the vcpu_info address
Date:   Tue, 19 Sep 2023 13:41:48 +0000
Message-Id: <20230919134149.6091-13-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230919134149.6091-1-paul@xen.org>
References: <20230919134149.6091-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

If the vCPU id is set and the shared_info is mapped using HVA then we can
infer that KVM has the ability to use a default vcpu_info mapping. Hence
we can stop setting the address of the vcpu_info structure.

NOTE: We still explicitly set vcpu_info half way through testing (to point
      at exactly the place it already is) to make sure that setting the
      attribute does not fail.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>

v3:
 - Add a guest sync point to set the vcpu_info attribute

v2:
 - New in this version.
---
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index e786fa370140..7e74b3063437 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -68,6 +68,7 @@ enum {
 	TEST_POLL_TIMEOUT,
 	TEST_POLL_MASKED,
 	TEST_POLL_WAKE,
+	SET_VCPU_INFO,
 	TEST_TIMER_PAST,
 	TEST_LOCKING_SEND_RACE,
 	TEST_LOCKING_POLL_RACE,
@@ -327,6 +328,10 @@ static void guest_code(void)
 
 	GUEST_SYNC(TEST_POLL_WAKE);
 
+	/* Set the vcpu_info to point at exactly the place it already is to
+	 * make sure the attribute is functional. */
+	GUEST_SYNC(SET_VCPU_INFO);
+
 	/* A timer wake an *unmasked* port which should wake us with an
 	 * actual interrupt, while we're polling on a different port. */
 	ports[0]++;
@@ -549,7 +554,10 @@ int main(int argc, char *argv[])
 		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO,
 		.u.gpa = VCPU_INFO_ADDR,
 	};
-	vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &vi);
+
+	if (!has_vcpu_id || !has_shinfo_hva) {
+		vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &vi);
+	}
 
 	struct kvm_xen_vcpu_attr pvclock = {
 		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO,
@@ -903,6 +911,10 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
+			case SET_VCPU_INFO:
+				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &vi);
+				break;
+
 			case TEST_TIMER_PAST:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
-- 
2.39.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAFE7A48A9
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 13:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241721AbjIRLnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 07:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbjIRLnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 07:43:03 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EF7E7;
        Mon, 18 Sep 2023 04:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=eOXlTdKLTa3rMbpImKuxJFenfTeNgDL5ucB7IcBcqTs=; b=Q8NK4k4O+l9/v/t+fmfVpyecZ7
        nC47sQZgLUC7BINw39TMVvaz4u7IWDLoyAikoorf2O5a8Pv+q2Tz2/eDRwdrnKTEcQrqNrDb7gFzS
        nGQSwKapViQHipY4nwnN1XwHoCPHiGU85i+ya1ip7dXKkv0G3heLShlekgYK/r2jN0+0=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiCeV-0007dB-GO; Mon, 18 Sep 2023 11:42:55 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiCKZ-0005f3-He; Mon, 18 Sep 2023 11:22:19 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v2 11/12] KVM: selftests / xen: don't explicitly set the vcpu_info address
Date:   Mon, 18 Sep 2023 11:21:47 +0000
Message-Id: <20230918112148.28855-12-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230918112148.28855-1-paul@xen.org>
References: <20230918112148.28855-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

If the vCPU id is set and the shared_info is mapped using HVA then we can
infer that KVM has the ability to use a default vcpu_info mapping. Hence
we can stop setting the address of the vcpu_info structure.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>

v2:
 - New in this version.
---
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index fa829d6e0848..d1c88deec0b2 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -550,11 +550,13 @@ int main(int argc, char *argv[])
 		vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &vid);
 	}
 
-	struct kvm_xen_vcpu_attr vi = {
-		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO,
-		.u.gpa = VCPU_INFO_ADDR,
-	};
-	vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &vi);
+	if (!has_vcpu_id || !has_shinfo_hva) {
+		struct kvm_xen_vcpu_attr vi = {
+			.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO,
+			.u.gpa = VCPU_INFO_ADDR,
+		};
+		vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &vi);
+	}
 
 	struct kvm_xen_vcpu_attr pvclock = {
 		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO,
-- 
2.39.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947B65B2DB2
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 06:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiIIErO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 00:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiIIErL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 00:47:11 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D68FD208
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 21:47:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p12-20020a259e8c000000b006958480b858so740806ybq.12
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 21:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=cdmIqcLKbdujO9E0CyTHIQ8voTZsLtjL+NYg8vJd0vA=;
        b=cF3DR/sd0Wgsk/iGGH2d2gEDKFgjIg01OYfZMpnzvPrEAkaGz8AIJvL4s5mw+Nc0M8
         TN57/dyFDmY7Mih5VeJg2n7zTILQr7Z60pR9Ad3OqdHVl6hLeq4jjI0iOKLLBff2mbH2
         zuJaPOzq5hFBBbanpuK3JTsDOf12MxffmatefGt7Jv4VRIFMUQy949BHMEBXFg9eP0Rw
         K1Q8Pt4W4dkbazK+4K8UpIm0x3H+grQxr7mwcrTKI9WAaftcEl/JNJVJFuy/SEFGLs6P
         C25YPwSvZwjJCbFh3uRod4ipWKvVsBizabkX5Hwnit3V6MbbDvuvAPQ5a5pWGA4S7CwE
         hCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=cdmIqcLKbdujO9E0CyTHIQ8voTZsLtjL+NYg8vJd0vA=;
        b=ylHtgbd6U5f+Vk/REjLwXppc8cU+9qT75sNCxyaxCSkkimWrCf2tI2ZogsHLPqcl5y
         6b0E5KSTQVwxUsIUh4alVFxNj5XpYHkeLZHRbl134UUqJCMirpywhKeasoCRiSzAI9yE
         n2xIMXUB188YvlHn87HC23Tvf/szfRfFpwbA2NgROU9ETxrahAao5atSi5KUQjQuYJD1
         jc5CcFK3xfOQrApb6EzHUN91mSU0l6l4r3gwDye6IpkFqLvmo4lULPA435lJcssk4GU6
         fEcdU58ooJUO9GmvXb/1HDI2l7mwSUWhmvz/WrytsSWymZeRM3IMZTE5Llhs3t8cZb5I
         yNhg==
X-Gm-Message-State: ACgBeo1kODo3ZfzU36o8kF8fXNpSs5lExLym/0nAHfI2iaL935x2lyhP
        pcS+xI8rMmq/m42euknDTiII4QgW/f0=
X-Google-Smtp-Source: AA6agR6fFEzordzXyp1eqlP2xn60Bj2CFzQfdITIpFijrIWoJ+bbNsN9lfrixj3WQl3w9vPwLiX971lXrz4=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:a0d:0:b0:689:9eee:348f with SMTP id
 k13-20020a5b0a0d000000b006899eee348fmr10500385ybq.111.1662698828939; Thu, 08
 Sep 2022 21:47:08 -0700 (PDT)
Date:   Thu,  8 Sep 2022 21:46:35 -0700
In-Reply-To: <20220909044636.1997755-1-reijiw@google.com>
Mime-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909044636.1997755-3-reijiw@google.com>
Subject: [PATCH 2/3] KVM: arm64: selftests: Refactor debug-exceptions to make
 it amenable to new test cases
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split up the current test into a helper, but leave the debug version
checking in main(), to make it convenient to add a new debug exception
test case in a subsequent patch.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c   | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 2ee35cf9801e..e6e83b895fd5 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -246,7 +246,7 @@ static int debug_version(struct kvm_vcpu *vcpu)
 	return id_aa64dfr0 & 0xf;
 }
 
-int main(int argc, char *argv[])
+static void test_guest_debug_exceptions(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -259,9 +259,6 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	__TEST_REQUIRE(debug_version(vcpu) >= 6,
-		       "Armv8 debug architecture not supported.");
-
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_BRK_INS, guest_sw_bp_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
@@ -294,5 +291,18 @@ int main(int argc, char *argv[])
 
 done:
 	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	__TEST_REQUIRE(debug_version(vcpu) >= 6,
+		       "Armv8 debug architecture not supported.");
+	kvm_vm_free(vm);
+	test_guest_debug_exceptions();
+
 	return 0;
 }
-- 
2.37.2.789.g6183377224-goog


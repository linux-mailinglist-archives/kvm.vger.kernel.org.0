Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4407B4FAA62
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243113AbiDISsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241600AbiDISsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:11 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63DE22B25
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:03 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id q137-20020a6b8e8f000000b006495204b061so7616950iod.14
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Jf/XMEAggTsJuRalDXg2pQgOXNV7XNpBSuo5Apmz4Aw=;
        b=lEIcMr9UB+V2bpTOF8EQ+5KiBkTiHljW9KBJ+syKK2UZL9ii5LwlJjVuKAfSz5WeEG
         kyawmh0g5aofmsREkqHPn5huvgnhS47w8v/nDJIZU7+UvbvTIEORc5l8e/uSAP0yM9LH
         9KGVzOzulx7xyqxGFVVfp1C0c2XLLoGP/dsFCHDZ13QpYaNa3O5D9pYCW6lII1Tzge6l
         0SJ2qoTARMT3w3UI+r//DlEGmrsEW24wtzkoL/NQlMy/qJhwCLI0KaMghN6iLFSJY4Hl
         XnuVNhxOslVqYyJFhVNNKz8Mdrlp1qsQlEL/+6IiF3YirJBoNhkFz0U+lFdcxA7RBOJM
         0BLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Jf/XMEAggTsJuRalDXg2pQgOXNV7XNpBSuo5Apmz4Aw=;
        b=hsdCto2y74+J7l6f1NZghjvCc0FhrUS3J5yLgF6padGZGQpiey9JhTrQXsq+l4BIBw
         g95xGkon/7XPDwROz1uMk8OsANTuuMI4snS7NNQRYW6Te541b36RmJcGd76sRTZLHLt9
         1B+kAAI09KIl9fdfv/I1yQNeSPQdxUr7T4U20LjrfESKBsNNLDNGwK8diiVpX7TWvsXT
         ZdNyeCZg4lWPRm/PbiwU/HLFnhGVDtRN0+YLd1gK+mAqTdQt2QbO9ZZiEnkkk+0wQhto
         aIz7E3Huf9gznEGQchBTu91VA2E0gGfSDODXYzlx+DgSLBC0O1JJjb0MeUOF9eYndUja
         XpLg==
X-Gm-Message-State: AOAM531WFb3EbX/z+yFGam8P235znggDPS2YuF6eERurKDzsQv0YmMtI
        aZqSAwG17CxEZSIZaYK65qhqmyb2o94=
X-Google-Smtp-Source: ABdhPJzJYn0CBfHqpbPKvsa8E7anxVCn5cEcl/xGZyo6ANeP6L2odlV4tB+CsnkIAte6yP8lp/XGUTRqlN8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:160d:b0:2c9:eef2:3a28 with SMTP id
 t13-20020a056e02160d00b002c9eef23a28mr10295558ilu.306.1649529963316; Sat, 09
 Apr 2022 11:46:03 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:40 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-5-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 04/13] KVM: arm64: Rename the KVM_REQ_SLEEP handler
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
        Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>
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

The naming of the kvm_req_sleep function is confusing: the function
itself sleeps the vCPU, it does not request such an event. Rename the
function to make its purpose more clear.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 29e107457c4d..77b8b870c0fc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -594,7 +594,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
-static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
@@ -652,7 +652,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
-			vcpu_req_sleep(vcpu);
+			kvm_vcpu_sleep(vcpu);
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
-- 
2.35.1.1178.g4f1659d476-goog


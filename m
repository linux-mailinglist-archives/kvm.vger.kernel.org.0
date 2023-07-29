Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218AF7679E9
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbjG2Ak5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236420AbjG2AkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:40:18 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C12144AF
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb98659f3cso18213165ad.3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591069; x=1691195869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AB4nCzcJxxTKK97GCB6DmZjI2HiP51XBzwyfTirQyrI=;
        b=IdcimLldL6SdT439oCWu8rz2dmrkYjv8ox3SUKWomnMiyiiFRRjDs66qRRW+FVKqrx
         0i8l7UCEvYEgFtND3T2gbsKATBAqjj6umb2vG/JNBL0Mq5nZet9Wids8j4AWdk/JSW9/
         JKTRfK4mCIXSn2n+AVw/lB8MDG+6y8r1BWFbxAHaWz3sWgeN3tc3CLBlVVmcA590V/pB
         y4wgwQpigybr8lpsL1JOF+Q3E+fGX3fNVqw4rlA7l6EtvrlD5hrwC3UZnR0P48gEV9XH
         gNkCLnErK0Q0pLqgIRTVaGjlOFf6bZIf8BVat9k7OjIOviPSk4Q4BvHQlNGefnt2lLFt
         laWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591069; x=1691195869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AB4nCzcJxxTKK97GCB6DmZjI2HiP51XBzwyfTirQyrI=;
        b=VOMXIZAyNTXYKKfcOSJwQxV/sAMBOattIMw9Z7som3ixvsMn3v/Dg4kQSWwkJ9Y5rd
         n6sEpw39Aqic1MpSI5UAsPnZW2+7y29TaBXoE+EB6xQwfv0zpFiKrYHBMkKLJ0CZsc7f
         Rxz0gwQTRn6GkIb2fOCVXsxWAcuSLj0dpHtTX1neglVyNn+ynjOXyzu+V8nvwgCWi6en
         qaQ5IlkrQTbaVdKo/2YVwhYQsO1UUKNlL2oBSehNbhno2SokkghyEh4MPQS97Q2i1O0i
         Nht8dKjIsz08yUHCSOWP68DiV4jy0lpPzS4IuOSLvIJbWjXRdGwfQfTW8KdJnp8XvFDT
         iYzA==
X-Gm-Message-State: ABy/qLZSlSznOdAKgSl3AP4X+UEznHz+O/hSxsxy59vNKrzD3Jh/XGHv
        sfa8TWjc/NtPstKNTblXKOxFwdPiQ9I=
X-Google-Smtp-Source: APBJJlFqj3KGHz4ib/ws4V7ET96W9C6pQj8d9T5XgR4iicuixEf78OTjjLiyoxpq5Vayxs/ASyydtJHhDL0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec92:b0:1b8:929f:199b with SMTP id
 x18-20020a170902ec9200b001b8929f199bmr12494plg.11.1690591069741; Fri, 28 Jul
 2023 17:37:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:36:42 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-34-seanjc@google.com>
Subject: [PATCH v4 33/34] KVM: selftests: Print out guest RIP on unhandled exception
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the newfanged printf-based guest assert framework to spit out the
guest RIP when an unhandled exception is detected, which makes debugging
such failures *much* easier.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c       | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d4a0b504b1e0..d8288374078e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1074,11 +1074,6 @@ static bool kvm_fixup_exception(struct ex_regs *regs)
 	return true;
 }
 
-void kvm_exit_unexpected_vector(uint32_t value)
-{
-	ucall(UCALL_UNHANDLED, 1, value);
-}
-
 void route_exception(struct ex_regs *regs)
 {
 	typedef void(*handler)(struct ex_regs *);
@@ -1092,7 +1087,10 @@ void route_exception(struct ex_regs *regs)
 	if (kvm_fixup_exception(regs))
 		return;
 
-	kvm_exit_unexpected_vector(regs->vector);
+	ucall_assert(UCALL_UNHANDLED,
+		     "Unhandled exception in guest", __FILE__, __LINE__,
+		     "Unhandled exception '0x%lx' at guest RIP '0x%lx'",
+		     regs->vector, regs->rip);
 }
 
 void vm_init_descriptor_tables(struct kvm_vm *vm)
@@ -1135,12 +1133,8 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
-	if (get_ucall(vcpu, &uc) == UCALL_UNHANDLED) {
-		uint64_t vector = uc.args[0];
-
-		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
-			  vector);
-	}
+	if (get_ucall(vcpu, &uc) == UCALL_UNHANDLED)
+		REPORT_GUEST_ASSERT(uc);
 }
 
 const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
-- 
2.41.0.487.g6d72f3e995-goog


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0586853D484
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350177AbiFDBXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350144AbiFDBXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:23:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83917275C1
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id z18-20020a656112000000b003fa0ac4b723so4571678pgu.5
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fAl1+AuHRM9inCO8bRlxx9BHvcQGIGb60nHLb6rOfdI=;
        b=G1C+j7bRUj2zJxrGM0uz9nSZIJwVQUZJ2ZreDG6HFN1c50gYaREsj+ZgmmvuJjZKvO
         /2AFssTQ8QdzVP10q3z8X/jNeZAqEt/c+zCI61LcB3Hb4FYuur0QD3ZEYXntFBuTH+Wz
         B6scCPE7L/Q9zl9U8eRrhJubx/wiWaYKs4Sj9IblKZIvhjQxUThCELe1suaCxqAdqWt8
         5miF88IXno9bvSZwjvz2RfmAP5FraDQ7OFu/lkjXJ5d2QvQvs+KWd7o2XZYFZUM+ocnn
         xeb8VBDnQCX2vGtoW4GFLAceWSRpBDV4AZ9q7QzSITPBqYpiQhLpMetbAD3eyA6u8rcA
         Pq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fAl1+AuHRM9inCO8bRlxx9BHvcQGIGb60nHLb6rOfdI=;
        b=MI1u6PANf3HP0vD82FzIhhuevczKgmg/CL85bwDmXwrmVlZB6v0NZaNfwwvQezLhdw
         Y7R9asfG15ruL1/9ElsslrJmr6vD3S3E9UjPFWtfrlBGv25ehmQa3J8TcoXzK6BP4zqP
         4FUkrv9Dpjd7m4cxS6YEkDo//bNbbJWYmML7fznypPxXVrhSefkxdjpFuWpi8zqqFYq3
         58Jh6hUrUWckI2zfqPxgioUsZn4NrnBGc+BmtaffmxgAg2PzBphUdVrI0DfHt9q1Bsfi
         sDTZenmxiiTHD13F5jTm+O4hk0P9UBTSQ47PPcYiBP4HtAdyLrNU3lpBb2TgpD3n0/Zr
         HOTw==
X-Gm-Message-State: AOAM531yQRIZFMXEatwB0ymgcBvKy3dn4rmn78MgSzqQq1Fv/cGFvTW1
        Xv3O8arAd/tvuHZcqS/uO9nQtlzn6cg=
X-Google-Smtp-Source: ABdhPJy0AA4cGpnkOR3s7vtIiLqzfou/9QDn663AHoOR2ivfp3NvHHxbzwhcTkdih4e+DXXcNRXmZJrZACE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:114b:b0:4f7:915:3ec3 with SMTP id
 b11-20020a056a00114b00b004f709153ec3mr12963470pfm.8.1654305711604; Fri, 03
 Jun 2022 18:21:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:45 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-30-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 29/42] KVM: selftests: Use vcpu_clear_cpuid_feature() to clear x2APIC
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Add X86_FEATURE_X2APIC and use vcpu_clear_cpuid_feature() to clear x2APIC
support in the xAPIC state test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h |  1 +
 tools/testing/selftests/kvm/x86_64/xapic_state_test.c  | 10 +---------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a1cac0b7d8b2..c2e3ea55b697 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -81,6 +81,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_SMX			KVM_X86_CPU_FEATURE(0x1, 0, ECX, 6)
 #define	X86_FEATURE_PDCM		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 15)
 #define	X86_FEATURE_PCID		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 17)
+#define X86_FEATURE_X2APIC		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 21)
 #define	X86_FEATURE_MOVBE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 22)
 #define	X86_FEATURE_TSC_DEADLINE_TIMER	KVM_X86_CPU_FEATURE(0x1, 0, ECX, 24)
 #define	X86_FEATURE_XSAVE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 26)
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index 7728730c2dda..1bc091f3b58b 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -122,9 +122,7 @@ int main(int argc, char *argv[])
 		.vcpu = NULL,
 		.is_x2apic = true,
 	};
-	struct kvm_cpuid2 *cpuid;
 	struct kvm_vm *vm;
-	int i;
 
 	vm = vm_create_with_one_vcpu(&x.vcpu, x2apic_guest_code);
 	test_icr(&x);
@@ -138,13 +136,7 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&x.vcpu, xapic_guest_code);
 	x.is_x2apic = false;
 
-	cpuid = x.vcpu->cpuid;
-	for (i = 0; i < cpuid->nent; i++) {
-		if (cpuid->entries[i].function == 1)
-			break;
-	}
-	cpuid->entries[i].ecx &= ~BIT(21);
-	vcpu_set_cpuid(x.vcpu);
+	vcpu_clear_cpuid_feature(x.vcpu, X86_FEATURE_X2APIC);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 	test_icr(&x);
-- 
2.36.1.255.ge46751e96f-goog


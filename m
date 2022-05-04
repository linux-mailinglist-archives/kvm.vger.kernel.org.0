Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AE651B292
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381942AbiEDXFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376312AbiEDXBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 19:01:12 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD3459BB3
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q14-20020a17090a178e00b001dc970bf587so1945692pja.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gLfv5SLMJcSQPQ/Ju5zaAkWd2HIOB4z3HRnHNL4SQDI=;
        b=WHNG80cfO6Tcty1emt0cr2ZRfola+mwo3Xx7vEmfo/M08fDw7RKpCZo2ciCaodmNRB
         l1KZtURFo+tUKrso6qkLkun3Y8U6L0WKSEGiniIYxYLRVgLw8TLtzp639C/oGejrt51a
         XSeyGK9WJMhMcmIzhJuEqPCrF91myLXOcw8ON851YzKaers7haXqum41vyTzytm/p+/t
         a1tEqd3oSpXOYqvVqQJlq4R1h8/pBxp8gSnslxC5rCzxbC//TZWvNb/3mVbmQQgCTBuq
         szX1+7oz8V14TbyCDuy/IstASVOqPEduFPfUmh1yufwgK7PPvv973HqKefcdfbPhk/RZ
         TD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gLfv5SLMJcSQPQ/Ju5zaAkWd2HIOB4z3HRnHNL4SQDI=;
        b=O7VkB38b0QSDUP0L/23AXeB6Mcvwo0AhbLD02g/GmvgQ2x2GXdwX9LSZAJvlAYypZW
         GBzoctfxb0drdddD/oG54h2Ef76HQTzBuR/VKMIt1rl1VL5nOTaZJ0RRQP75ywTV2Doe
         LZ60Lohw4HXRZ/gUr4FCcJA4s3qfkESJQeT0YIxRZy/OVde2IeVER7yeC7jBz+x8GApr
         nIrfD8WvEe0NrLE96YEheKt9BavOXQGDv6inozsRUuN+V0vaX04LaaiPOiCvRvg1tvA7
         5T2QyxEhn0jPKO37q2HWTOO7TDS2s+tfMQE1RwH0ROfm1Nbpp3rBdzMfKC70CfoEALO0
         wQQQ==
X-Gm-Message-State: AOAM532XOIdxrkt+FoHQTzsDmq8IbskHgHG8bvCUMV6vnWxz1sjf8m7L
        /Amd5AG571JA1vUY8d0NDCvg117vRnU=
X-Google-Smtp-Source: ABdhPJwiqUWSlwjB4cPjqFgJiVLVDwoP4qOmo5KEo17lpHxloA+ZHrsQaErPHoJ7IxDiZXmG2ApfCJEZDDA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2408:b0:4f7:a8cb:9b63 with SMTP id
 z8-20020a056a00240800b004f7a8cb9b63mr23382390pfh.33.1651704789825; Wed, 04
 May 2022 15:53:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:49:13 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-128-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 127/128] KVM: selftests: Trust that MAXPHYADDR > memslot0 in vmx_apic_access_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Use vm->max_gfn to compute the highest gpa in vmx_apic_access_test, and
blindly trust that the highest gfn/gpa will be well above the memory
carved out for memslot0.  The existing check is beyond paranoid; KVM
doesn't support CPUs with host.MAXPHYADDR < 32, and the selftests are all
kinds of hosed if memslot0 overlaps the local xAPIC, which resides above
"lower" (below 4gb) DRAM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86_64/vmx_apic_access_test.c  | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
index ef7514376b1e..ccb05ef7234e 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_apic_access_test.c
@@ -72,8 +72,6 @@ static void l1_guest_code(struct vmx_pages *vmx_pages, unsigned long high_gpa)
 int main(int argc, char *argv[])
 {
 	unsigned long apic_access_addr = ~0ul;
-	unsigned int paddr_width;
-	unsigned int vaddr_width;
 	vm_vaddr_t vmx_pages_gva;
 	unsigned long high_gpa;
 	struct vmx_pages *vmx;
@@ -86,12 +84,7 @@ int main(int argc, char *argv[])
 
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
-	kvm_get_cpu_address_width(&paddr_width, &vaddr_width);
-	high_gpa = (1ul << paddr_width) - getpagesize();
-	if ((unsigned long)DEFAULT_GUEST_PHY_PAGES * getpagesize() > high_gpa) {
-		print_skip("No unbacked physical page available");
-		exit(KSFT_SKIP);
-	}
+	high_gpa = (vm->max_gfn - 1) << vm->page_shift;
 
 	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	prepare_virtualize_apic_accesses(vmx, vm);
-- 
2.36.0.464.gb9c8b46e94-goog


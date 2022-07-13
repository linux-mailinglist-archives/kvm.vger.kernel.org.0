Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E961A5739AD
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 17:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiGMPGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 11:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236833AbiGMPGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 11:06:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2E404AD41
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657724750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WX0Zqi0xUxVp8zTi28bICda0L6pWifs8rIVsxOec86g=;
        b=XzuBN5S5+8o8FGSjzjTxiSVcwSX82/pOjPDXStvToBo/Ut8hByHbs9gRSiEjOo/VdQ5rT8
        91Yy9uYSyM/ny6rALHzhHgeW2jSl507AFyZ3Bg9Sek3FZjDjuj/VArS4kF2KHA1PqjERzo
        mjjejGUUikWizCmdsR+ULGFQFYaL1H4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-119ThXtWNaaQJ_KlwFigdg-1; Wed, 13 Jul 2022 11:05:47 -0400
X-MC-Unique: 119ThXtWNaaQJ_KlwFigdg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01C0A3C11E88;
        Wed, 13 Jul 2022 15:05:38 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86305492C3B;
        Wed, 13 Jul 2022 15:05:36 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: selftests: Fix wrmsr_safe()
Date:   Wed, 13 Jul 2022 17:05:31 +0200
Message-Id: <20220713150532.1012466-3-vkuznets@redhat.com>
In-Reply-To: <20220713150532.1012466-1-vkuznets@redhat.com>
References: <20220713150532.1012466-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It seems to be a misconception that "A" places an u64 operand to
EAX:EDX, at least with GCC11.

While writing a new test, I've noticed that wrmsr_safe() tries putting
garbage to the upper bits of the MSR, e.g.:

  kvm_exit:             reason MSR_WRITE rip 0x402919 info 0 0
  kvm_msr:              msr_write 40000118 = 0x60000000001 (#GP)
...
when it was supposed to write '1'. Apparently, "A" works the same as
"a" and not as EAX/EDX. Here's the relevant disassembled part:

With "A":

	48 8b 43 08          	mov    0x8(%rbx),%rax
	49 b9 ba da ca ba 0a 	movabs $0xabacadaba,%r9
	00 00 00
	4c 8d 15 07 00 00 00 	lea    0x7(%rip),%r10        # 402f44 <guest_msr+0x34>
	4c 8d 1d 06 00 00 00 	lea    0x6(%rip),%r11        # 402f4a <guest_msr+0x3a>
	0f 30                	wrmsr

With "a"/"d":

	48 8b 43 08          	mov    0x8(%rbx),%rax
	48 89 c2             	mov    %rax,%rdx
	48 c1 ea 20          	shr    $0x20,%rdx
	49 b9 ba da ca ba 0a 	movabs $0xabacadaba,%r9
	00 00 00
	4c 8d 15 07 00 00 00 	lea    0x7(%rip),%r10        # 402fc3 <guest_msr+0xb3>
	4c 8d 1d 06 00 00 00 	lea    0x6(%rip),%r11        # 402fc9 <guest_msr+0xb9>
	0f 30                	wrmsr

I was only able to find one online reference that "A" gives "eax and
edx combined into a 64-bit integer", other places don't mention it at
all.

Fixes: 3b23054cd3f5 ("KVM: selftests: Add x86-64 support for exception fixup")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 79dcf6be1b47..3d412c578e78 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -612,7 +612,7 @@ static inline uint8_t rdmsr_safe(uint32_t msr, uint64_t *val)
 
 static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 {
-	return kvm_asm_safe("wrmsr", "A"(val), "c"(msr));
+	return kvm_asm_safe("wrmsr", "a"((u32)val), "d"(val >> 32), "c"(msr));
 }
 
 uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-- 
2.35.3


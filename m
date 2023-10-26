Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3987D87EB
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 19:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbjJZR7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 13:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjJZR7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 13:59:15 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F55F192
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 10:59:13 -0700 (PDT)
Received: from [192.168.7.187] ([76.103.185.250])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 39QHx77R220440
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 26 Oct 2023 10:59:08 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 39QHx77R220440
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023101201; t=1698343148;
        bh=HP+1mqB0YWwcMW/7Ln17eOABmufO82xjLAmr7mutzpM=;
        h=Date:To:Cc:From:Subject:From;
        b=iR3WjvOSLI1WTUusui7N+EIW/gnpwAry4rC3zR9GcD15+0bOyf4gei9k7VTTotmJu
         VNUZAK0F9QN8FhliPiZdzkvw7ajq0orbruydApRGADJrRfqUzVvq+8JUyhgcZKYtED
         TFheLNeuxUYiaCZrC1R9HbkO9DuWeiG2cQp2/aXZo4gRGUWYfcoW9N6JXFJCena53J
         vXKdO0ao4XLQhH7m/cjKNZnNPwbvz6bNYG1Helabnk0w7gNA6f6k9bbOta7ntmXTEG
         h+1YqTTzT42moH1tuDjiDyZuDAfi7Vef8P16awKx1KY6knsZbFPtzhd2Iak+HROU2t
         9TqxaHJCtvwiw==
Message-ID: <a65e6d23-791b-4866-8cb8-543d8f1942a6@zytor.com>
Date:   Thu, 26 Oct 2023 10:59:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
From:   Xin Li <xin@zytor.com>
Subject: Run user level code in guest in a new KVM selftest
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

I'm adding a nested exception selftest for FRED, which needs to run
user level code in guest.  I have to add the following hack for that:

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c 
b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d8288374078e..72928c07ccbe 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -159,6 +159,7 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm 
*vm,

         if (!(*pte & PTE_PRESENT_MASK)) {
                 *pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
+               *pte |= PTE_USER_MASK;
                 if (current_level == target_level)
                         *pte |= PTE_LARGE_MASK | (paddr & 
PHYSICAL_PAGE_MASK);
                 else
@@ -222,6 +223,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t 
vaddr, uint64_t paddr, int level)
         TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
                     "PTE already present for 4k page at vaddr: 
0x%lx\n", vaddr);
         *pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & 
PHYSICAL_PAGE_MASK);
+       *pte |= PTE_USER_MASK;
  }

  void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)


Is there an exiting selftest running user level code in guest?

It seems there is none as the USER bit in PTEs is never set, what have I
missed?

If such a facility doesn't exist, we probably need to find a
clean solution to add the USER bit in user level page table mappings
(which seems not yet clearly defined yet).

Thanks!
     Xin

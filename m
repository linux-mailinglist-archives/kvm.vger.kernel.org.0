Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0BF77074F
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjHDRvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjHDRvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:51:21 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4EF4C02
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:51:17 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qRyxG-00453B-Pc; Fri, 04 Aug 2023 19:51:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=oEhuic+LhTwu1WfgezOVRiYoq1EH3VkPBEg8lBEUgA4=; b=ofkFlB7o83fBAtbHUOhuaOHJQM
        hQ9Ycye3xpzU/k00aaM/0TNc4wOFRZO/Uou/tbVoJgiuagpYp6TkBA4zqkTKOHSJfFmEy6fYZ9Wqq
        W+kCOX7VD0AyK1coVtXmSsvnLBTgTjadm3wokpgLa3mgB/4j1X5LoCsaIqOqPeFzX02Uy5sS5GJIX
        ROWMdVD6wkWnAtd5orOLBadmGPk/0jBD+tI5sa8MZLStPMUSRglUA28JMpQ/1jeDm3bXWfOOw529p
        KszrrNxE0CpflR/ojHQ9/tdA9hDu84Siff47YyAAvGOTBXg6hBb/pPznB71PK9lXf5wQqJGLHUimy
        AmZAKQew==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qRyxG-0006Mg-DC; Fri, 04 Aug 2023 19:51:14 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qRywz-00059y-Ky; Fri, 04 Aug 2023 19:50:57 +0200
Message-ID: <4a8a5851-5f04-deef-32b2-4f5392ceb54a@rbox.co>
Date:   Fri, 4 Aug 2023 19:50:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU
 issues
Content-Language: pl-PL, en-GB
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <20230728001606.2275586-2-mhal@rbox.co> <ZMhIlj+nUAXeL91B@google.com>
 <7e24e0b1-d265-2ac0-d411-4d6f4f0c1383@rbox.co> <ZMqr/A1O4PPbKfFz@google.com>
 <38f69410-d794-6eae-387a-481417c6b323@rbox.co>
 <e55656be-2752-a317-80eb-ad40e474b62f@redhat.com>
 <8adb2f2b-df9c-3e49-3bdd-7970d918a1d0@rbox.co>
 <e578173b-8edf-dd89-494e-ecbec5b7cba8@redhat.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <e578173b-8edf-dd89-494e-ecbec5b7cba8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 11:53, Paolo Bonzini wrote:
> On 8/3/23 23:15, Michal Luczaj wrote:
>>>           *mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
>>>
>>> with a call to the function just before __set_sregs_common returns.
>> What about kvm_post_set_cr4() then? Should it be introduced to
>> __set_sregs_common() as well?
> 
> Yes, indeed, but it starts getting a bit unwieldy.
> 
> If we decide not to particularly optimize KVM_SYNC_X86_SREGS, however, 
> we can just chuck a KVM_REQ_TLB_FLUSH_GUEST request after __set_sregs 
> and __set_sregs2 call kvm_mmu_reset_context().

Something like this?

@@ -11562,8 +11562,10 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
        if (ret)
                return ret;

-       if (mmu_reset_needed)
+       if (mmu_reset_needed) {
                kvm_mmu_reset_context(vcpu);
+               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+       }

        max_bits = KVM_NR_INTERRUPTS;
        pending_vec = find_first_bit(
@@ -11604,8 +11606,10 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
                mmu_reset_needed = 1;
                vcpu->arch.pdptrs_from_userspace = true;
        }
-       if (mmu_reset_needed)
+       if (mmu_reset_needed) {
                kvm_mmu_reset_context(vcpu);
+               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+       }
        return 0;
 }


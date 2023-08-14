Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD94277C379
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 00:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjHNWbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 18:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbjHNWav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 18:30:51 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CAA19B1
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 15:30:20 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qVg4n-00FTWG-H3; Tue, 15 Aug 2023 00:30:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID;
        bh=rc46lOMOIFEThV6G+f4maBvqYHq5xN38Vs26ZOW0sd4=; b=NaqyOA1qBGp4DQWoz5g4nrDmmm
        xOjLhTLyc4s/3JpAbTIf0O5dwFGWl85sZtGGgzP3KFVSc5U0R9dODmS8JBpUtqXGyL0WIJaRWd3eg
        F1I53dN1BgMyPWRtv07dAvddh57VFC5wK0Lplh8LdqUK9V063bIrMDsopKGAUZz79DlS9VudsTer0
        5B434mkBPKTUpazVQSJy4ig+Vibe3TqwhOBDF9bCb3YZa8QXOIos7p0G1cXMZnLeMT/bld0l336mJ
        HUF10Ym6P0hS2U/v4EXC2HtPPlbZdkHIn6N5i0p9gA6VBIdJeQeHzpyMYC20dEzlGuGUh85Ko//Yf
        29orv+Qg==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qVg4n-0004Lb-40; Tue, 15 Aug 2023 00:30:17 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qVg4T-0006u8-OJ; Tue, 15 Aug 2023 00:29:57 +0200
Message-ID: <27323477-3c4b-4af9-a60e-8e7d25be6fa3@rbox.co>
Date:   Tue, 15 Aug 2023 00:29:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU
 issues
Content-Language: pl-PL, en-GB
From:   Michal Luczaj <mhal@rbox.co>
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
 <4a8a5851-5f04-deef-32b2-4f5392ceb54a@rbox.co>
In-Reply-To: <4a8a5851-5f04-deef-32b2-4f5392ceb54a@rbox.co>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/23 19:50, Michal Luczaj wrote:
> On 8/4/23 11:53, Paolo Bonzini wrote:
>> On 8/3/23 23:15, Michal Luczaj wrote:
>>>>           *mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
>>>>
>>>> with a call to the function just before __set_sregs_common returns.
>>> What about kvm_post_set_cr4() then? Should it be introduced to
>>> __set_sregs_common() as well?
>>
>> Yes, indeed, but it starts getting a bit unwieldy.
>>
>> If we decide not to particularly optimize KVM_SYNC_X86_SREGS, however, 
>> we can just chuck a KVM_REQ_TLB_FLUSH_GUEST request after __set_sregs 
>> and __set_sregs2 call kvm_mmu_reset_context().
> 
> Something like this?
> 
> @@ -11562,8 +11562,10 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>         if (ret)
>                 return ret;
> 
> -       if (mmu_reset_needed)
> +       if (mmu_reset_needed) {
>                 kvm_mmu_reset_context(vcpu);
> +               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> +       }
> 
>         max_bits = KVM_NR_INTERRUPTS;
>         pending_vec = find_first_bit(
> @@ -11604,8 +11606,10 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
>                 mmu_reset_needed = 1;
>                 vcpu->arch.pdptrs_from_userspace = true;
>         }
> -       if (mmu_reset_needed)
> +       if (mmu_reset_needed) {
>                 kvm_mmu_reset_context(vcpu);
> +               kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> +       }
>         return 0;
>  }

I guess I'll just post a patch then. There it is:
https://lore.kernel.org/kvm/20230814222358.707877-1-mhal@rbox.co/

thanks,
Michal


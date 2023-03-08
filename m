Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8046B101E
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 18:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCHRXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 12:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjCHRW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 12:22:59 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C70EDC9A71;
        Wed,  8 Mar 2023 09:22:45 -0800 (PST)
Received: from [192.168.2.24] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0592E20BBF92;
        Wed,  8 Mar 2023 09:22:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0592E20BBF92
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678296165;
        bh=GG+PelP8AQ54ZBePHp9RZ5D1xl2++VKtMFjPHdoldd0=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=UW/M7hYnWnIk9E2g9xqHxHNW602WHfV1UZCkV4SyaOJnN34BzC55Lnoq6yQhY8xu8
         igJvLB7rC+gMQsz5oLTIU5+bvCt+MJRGKZGCb6tWyJOj0B3zwAoshYbVxlxoNvM6zx
         3fXY9AeEEyaH1/M2bnYOGc99/Hd8GZX4+TkSJF2A=
Message-ID: <c940389f-c086-9d0e-7150-f57b3866ae82@linux.microsoft.com>
Date:   Wed, 8 Mar 2023 18:22:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
Content-Language: en-US
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com>
 <CABgObfa1578yKuw3sqnCeLXpyyKmMPgNaftP9HCdgHNM9Tztjw@mail.gmail.com>
 <ZAfZPA5Ed7STUT2B@google.com>
 <fb088e26-8c9c-bcac-6083-5945d2d9c16e@linux.microsoft.com>
In-Reply-To: <fb088e26-8c9c-bcac-6083-5945d2d9c16e@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/03/2023 16:55, Jeremi Piotrowski wrote:
> 
> 
> On 08/03/2023 01:39, Sean Christopherson wrote:
>> On Wed, Mar 08, 2023, Paolo Bonzini wrote:
>>> On Tue, Mar 7, 2023 at 6:36 PM Sean Christopherson <seanjc@google.com> wrote:
>>>> Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
>>>> hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
>>>> doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
>>>> happens to get lucky and not run afoul of the underlying bugs.
>>>
>>> I don't think it's about luck---the legacy MMU's zapping/invalidation
>>> seems to invoke the flush hypercall correctly:
>>
>> ...for the paths that Jeremi has exercised, and for which a stale TLB entry is
>> fatal to L2.  E.g. kvm_unmap_gfn_range() does not have a range-based TLB flush
>> in its path and fully relies on the buggy kvm_flush_remote_tlbs().
>>
> 
> Why do you say "buggy kvm_flush_remote_tlbs"? kvm_flush_remote_tlbs calls the hypercall
> that is needed, I don't see how this might be an issue of a missing "range-based TLB flush".
> 
> kvm_unmap_gfn_range is called from kvm_mmu_notifier_invalidate_range_start and 'flush_on_ret=true'
> is set, so it is followed by kvm_flush_remote_tlbs which calls hv_remote_flush_tlb.
> 
>> In other words, KVM is getting lucky :-)
>>
>>> Jeremi, did you ever track the call stack where
>>> hyperv_nested_flush_guest_mapping is triggered?
>>
>> I don't think it matters.  As above, it only takes one path where KVM is fully
>> relying on kvm_flush_remote_tlbs() for the whole thing to fall apart

Slowly I'm starting to understand what we've been talking about, thank you :)

Paolo/Sean, what do you think about smth like the following, except I would make
it SVM only, and I'd need to think about what to do with the return.
I believe this accurately reflects what the optimization is about. hv_track_root_tdp
is called from kvm_mmu_load_pgd, which covers both kvm_mmu_load and kvm_mmu_new_pgd
(which requests KVM_REQ_LOAD_MMU_PGD).

diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index 482d6639ef88..6a5bd3cbace8 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -29,6 +29,18 @@ static inline int hv_remote_flush_root_tdp(hpa_t root_tdp,
 		return hyperv_flush_guest_mapping(root_tdp);
 }
 
+static int hv_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
+	hpa_t root_tdp = vcpu->arch.hv_root_tdp;
+	int ret;
+
+	ret = hyperv_flush_guest_mapping(root_tdp);
+	if (!ret)
+		kvm_arch->hv_root_tdp = root_tdp;
+	return ret;
+}
+
 int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range)
 {
@@ -101,8 +113,10 @@ void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
 		spin_lock(&kvm_arch->hv_root_tdp_lock);
 		vcpu->arch.hv_root_tdp = root_tdp;
-		if (root_tdp != kvm_arch->hv_root_tdp)
+		if (root_tdp != kvm_arch->hv_root_tdp) {
 			kvm_arch->hv_root_tdp = INVALID_PAGE;
+			hv_vcpu_flush_tlb_current(vcpu);
+		}
 		spin_unlock(&kvm_arch->hv_root_tdp_lock);
 	}
 }


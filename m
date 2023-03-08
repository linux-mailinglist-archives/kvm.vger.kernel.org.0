Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D596B0E30
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 17:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjCHQIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 11:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbjCHQIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 11:08:00 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 582FDC9A4F;
        Wed,  8 Mar 2023 08:07:27 -0800 (PST)
Received: from [192.168.2.24] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id B382220C14D5;
        Wed,  8 Mar 2023 07:56:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B382220C14D5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678290961;
        bh=MgPwgzC0WMmGPJu2I/oJbf7rkt1c8sSjq/NZ1BV+tKc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Fm4uvXD0PsDfillhlW+cL97HF4REWgZEARVNi4DDFewE3/kPRqM4NyuiURHNp23ue
         0Sk+bcrtT3ULaVKXCrFgvTk/fjkJXOFj00bXI4EKYnklrLUHSbjSjHP0qo5TPUwe4R
         OG3Cpizr83Kc6awaVK+DiKimJ/Vnfg3likxuGwtY=
Message-ID: <fb088e26-8c9c-bcac-6083-5945d2d9c16e@linux.microsoft.com>
Date:   Wed, 8 Mar 2023 16:55:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
Content-Language: en-US
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
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <ZAfZPA5Ed7STUT2B@google.com>
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



On 08/03/2023 01:39, Sean Christopherson wrote:
> On Wed, Mar 08, 2023, Paolo Bonzini wrote:
>> On Tue, Mar 7, 2023 at 6:36 PM Sean Christopherson <seanjc@google.com> wrote:
>>> Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
>>> hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
>>> doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
>>> happens to get lucky and not run afoul of the underlying bugs.
>>
>> I don't think it's about luck---the legacy MMU's zapping/invalidation
>> seems to invoke the flush hypercall correctly:
> 
> ...for the paths that Jeremi has exercised, and for which a stale TLB entry is
> fatal to L2.  E.g. kvm_unmap_gfn_range() does not have a range-based TLB flush
> in its path and fully relies on the buggy kvm_flush_remote_tlbs().
>

Why do you say "buggy kvm_flush_remote_tlbs"? kvm_flush_remote_tlbs calls the hypercall
that is needed, I don't see how this might be an issue of a missing "range-based TLB flush".

kvm_unmap_gfn_range is called from kvm_mmu_notifier_invalidate_range_start and 'flush_on_ret=true'
is set, so it is followed by kvm_flush_remote_tlbs which calls hv_remote_flush_tlb.

> In other words, KVM is getting lucky :-)
> 
>> Jeremi, did you ever track the call stack where
>> hyperv_nested_flush_guest_mapping is triggered?
> 
> I don't think it matters.  As above, it only takes one path where KVM is fully
> relying on kvm_flush_remote_tlbs() for the whole thing to fall apart

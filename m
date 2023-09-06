Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3EE794136
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 18:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241329AbjIFQJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 12:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242751AbjIFQJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 12:09:49 -0400
X-Greylist: delayed 565 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Sep 2023 09:09:19 PDT
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710D91998
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 09:09:19 -0700 (PDT)
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id E9E6742937;
        Wed,  6 Sep 2023 17:59:52 +0200 (CEST)
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 06 Sep 2023 17:59:51 +0200
From:   "Stefan Sterz" <s.sterz@proxmox.com>
To:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Krish Sadhukhan" <krish.sadhukhan@oracle.com>,
        <kvm@vger.kernel.org>
Cc:     <jmattson@google.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <joro@8bytes.org>
Subject: Re: [PATCH 2/5] nSVM: Check for optional commands and reserved
 encodings of TLB_CONTROL in nested VMCB
Message-ID: <b9915c9c-4cf6-051a-2d91-44cc6380f455@proxmox.com>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
References: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
 <20210920235134.101970-3-krish.sadhukhan@oracle.com>
 <f7c2d5f5-3560-8666-90be-3605220cb93c@redhat.com>
Content-Language: en-US
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; DSN=0; uuencode=0;
 attachmentreminder=0; deliveryformat=0
X-Identity-Key: id1
Fcc:    imap://s.sterz%40proxmox.com@webmail.proxmox.com/Sent
In-Reply-To: <f7c2d5f5-3560-8666-90be-3605220cb93c@redhat.com>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.09.21 18:55, Paolo Bonzini wrote:
> On 21/09/21 01:51, Krish Sadhukhan wrote:
>> According to section "TLB Flush" in APM vol 2,
>>
>>      "Support for TLB_CONTROL commands other than the first two, is
>>       optional and is indicated by CPUID Fn8000_000A_EDX[FlushByAsid].
>>
>>       All encodings of TLB_CONTROL not defined in the APM are reserved."
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/kvm/svm/nested.c | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 5e13357da21e..028cc2a1f028 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -235,6 +235,22 @@ static bool nested_svm_check_bitmap_pa(struct
>> kvm_vcpu *vcpu, u64 pa, u32 size)
>>           kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
>>   }
>>   +static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu
, u8
>> tlb_ctl)
>> +{
>> +    switch(tlb_ctl) {
>> +        case TLB_CONTROL_DO_NOTHING:
>> +        case TLB_CONTROL_FLUSH_ALL_ASID:
>> +            return true;
>> +        case TLB_CONTROL_FLUSH_ASID:
>> +        case TLB_CONTROL_FLUSH_ASID_LOCAL:
>> +            if (guest_cpuid_has(vcpu, X86_FEATURE_FLUSHBYASID))
>> +                return true;
>> +            fallthrough;
>
> Since nested FLUSHBYASID is not supported yet, this second set of case
> labels can go away.
>
> Queued with that change, thanks.
>
> Paolo
>

Are there any plans to support FLUSHBYASID in the future? It seems
VMWare Workstation and ESXi require this feature to run on top of KVM
[1]. This means that after the introduction of this check these VMs fail
to boot and report missing features. Hence, upgrading to a newer kernel
version is not an option for some users.

Sorry if I misunderstood something or if 
this is not the right place to
ask.

[1]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2008583


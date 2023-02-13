Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03430694EEE
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 19:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjBMSL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 13:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjBMSL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 13:11:57 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7992B117;
        Mon, 13 Feb 2023 10:11:24 -0800 (PST)
Received: from [192.168.2.1] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 30F6C20CEAA2;
        Mon, 13 Feb 2023 10:05:14 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 30F6C20CEAA2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1676311515;
        bh=g2sXOJcYBH6Oc9c82Iqdn7FrnECej31LP7qAuLdPq0U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=M/y65pxMQl6pH/X1UpUIfm/f4tfy/NhCYdUowNlj4klFeMpJBuoWi6DGayg37dYwY
         lIMyQknaQEbXLw4bzcgTTWH2ch2Brrxw75C+4TRpLOU9YW0kgHZ3annZ7ycdmmWAkb
         RZFOalWttZUaFRe9yQNf9N6DcufABnvCDogvE8Ww=
Message-ID: <21b1ee26-dfd4-923d-72da-d8ded3dd819c@linux.microsoft.com>
Date:   Mon, 13 Feb 2023 19:05:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
 <Y+aQyFJt9Tn2PJnC@google.com>
 <9a046de1-8085-3df4-94cd-39bb893c8c9a@linux.microsoft.com>
 <88a89319-a71e-fa90-0dbb-00cf8a549380@redhat.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <88a89319-a71e-fa90-0dbb-00cf8a549380@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-20.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/02/2023 13:50, Paolo Bonzini wrote:
> 
> On 2/13/23 13:44, Jeremi Piotrowski wrote:
>> Just built a kernel from that tree, and it displays the same behavior. The problem
>> is not that the addresses are wrong, but that the flushes are issued at the wrong
>> time now. At least for what "enlightened NPT TLB flush" requires.
> 
> It is not clear to me why HvCallFluyshGuestPhysicalAddressSpace or HvCallFlushGuestPhysicalAddressList would have stricter requirements than a "regular" TLB shootdown using INVEPT.
> 
> Can you clarify what you mean by wrong time, preferrably with some kind of sequence of events?
> 
> That is, something like
> 
> CPU 0    Modify EPT from ... to ...
> CPU 0    call_rcu() to free page table
> CPU 1    ... which is invalid because ...
> CPU 0    HvCallFlushGuestPhysicalAddressSpace
> 
> Paolo

So I looked at the ftrace (all kvm&kvmmu events + hyperv_nested_* events) I see the following:
With tdp_mmu=0:
kvm_exit
sequence of kvm_mmu_prepare_zap_page
hyperv_nested_flush_guest_mapping (always follows every sequence of kvm_mmu_prepare_zap_page)
kvm_entry

With tdp_mmu=1 I see:
kvm_mmu_prepare_zap_page and kvm_tdp_mmu_spte_changed events from a kworker context, but
they are not followed by hyperv_nested_flush_guest_mapping. The only hyperv_nested_flush_guest_mapping
events I see happen from the qemu process context.

Also the number of flush hypercalls is significantly lower: a 7second sequence through OVMF with
tdp_mmu=0 produces ~270 flush hypercalls. In the traces with tdp_mmu=1 I now see max 3.

So this might be easier to diagnose than I thought: the HvCallFlushGuestPhysicalAddressSpace calls
are missing now.

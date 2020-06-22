Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D029203226
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 10:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgFVIfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 04:35:15 -0400
Received: from foss.arm.com ([217.140.110.172]:56616 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgFVIfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 04:35:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E5851FB;
        Mon, 22 Jun 2020 01:35:13 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 55C233F6CF;
        Mon, 22 Jun 2020 01:35:12 -0700 (PDT)
Subject: Re: [PATCH 2/4] arm64/x86: KVM: Introduce steal time cap
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
References: <20200619184629.58653-1-drjones@redhat.com>
 <20200619184629.58653-3-drjones@redhat.com>
 <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
From:   Steven Price <steven.price@arm.com>
Message-ID: <b11baec8-10f2-f389-ab8d-16224e9525a4@arm.com>
Date:   Mon, 22 Jun 2020 09:35:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/2020 09:20, Marc Zyngier wrote:
> Hi Andrew,
> 
> On 2020-06-19 19:46, Andrew Jones wrote:
[...]
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 4fdf30316582..121fb29ac004 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_PPC_SECURE_GUEST 181
>>  #define KVM_CAP_HALT_POLL 182
>>  #define KVM_CAP_ASYNC_PF_INT 183
>> +#define KVM_CAP_STEAL_TIME 184
>>
>>  #ifdef KVM_CAP_IRQ_ROUTING
> 
> Shouldn't you also add the same check of sched_info_on() to
> the various pvtime attribute handling functions? It feels odd
> that the capability can say "no", and yet we'd accept userspace
> messing with the steal time parameters...

My thought was that to some extent the two are separate. 
KVM_CAP_STEAL_TIME is "we have stolen time _AND_ it returns meaningful 
numbers", KVM_HAS_DEVICE_ATTR(KVM_ARM_VCPU_PVTIME_IPA) is 
(unfortunately) "we have the stolen interface, but it might not show how 
much time is stolen". Restoring a VM on a host with VCPU_PVTIME_IPA but 
without KVM_CAP_STEAL_TIME is possible just won't provide any stolen 
time data (the SMC calls will still work and the data format is valid).

Obviously with hindsight I would have done this differently...

Steve

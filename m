Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A886A88D4
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 20:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCBTCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 14:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjCBTCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 14:02:47 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9740553290;
        Thu,  2 Mar 2023 11:02:42 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 432622F4;
        Thu,  2 Mar 2023 11:03:25 -0800 (PST)
Received: from [10.57.90.27] (unknown [10.57.90.27])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0142C3F587;
        Thu,  2 Mar 2023 11:02:37 -0800 (PST)
Message-ID: <c1d9b82d-94a4-f2a2-fb39-6ae6b0729dc0@arm.com>
Date:   Thu, 2 Mar 2023 19:02:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        kvmarm@lists.cs.columbia.edu,
        Gareth Stockwell <Gareth.Stockwell@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y+vBHXbxPBgHxzGY@work-vm> <fa49dcf2-00a0-660d-cdcd-bbb6db02bcd0@arm.com>
 <ZADS5qMWoTy/uC6r@work-vm>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZADS5qMWoTy/uC6r@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/2023 16:46, Dr. David Alan Gilbert wrote:
> * Suzuki K Poulose (suzuki.poulose@arm.com) wrote:
>> Hi Dave
>>
>> Thanks for your response, and apologies for the delay. Response, in line.
>>
>> On 14/02/2023 17:13, Dr. David Alan Gilbert wrote:
>>> * Suzuki K Poulose (suzuki.poulose@arm.com) wrote:
>>>> We are happy to announce the early RFC version of the Arm
>>>> Confidential Compute Architecture (CCA) support for the Linux
>>>> stack. The intention is to seek early feedback in the following areas:
>>>>    * KVM integration of the Arm CCA
>>>>    * KVM UABI for managing the Realms, seeking to generalise the operations
>>>>      wherever possible with other Confidential Compute solutions.
>>>>      Note: This version doesn't support Guest Private memory, which will be added
>>>>      later (see below).
>>>>    * Linux Guest support for Realms
>>>>
>>>> Arm CCA Introduction
>>>> =====================
>>>>
>>>> The Arm CCA is a reference software architecture and implementation that builds
>>>> on the Realm Management Extension (RME), enabling the execution of Virtual
>>>> machines, while preventing access by more privileged software, such as hypervisor.
>>>> The Arm CCA allows the hypervisor to control the VM, but removes the right for
>>>> access to the code, register state or data that is used by VM.
>>>> More information on the architecture is available here[0].
>>>>
>>>>       Arm CCA Reference Software Architecture
>>>>
>>>>           Realm World    ||    Normal World   ||  Secure World  ||
>>>>                          ||        |          ||                ||
>>>>    EL0 x-------x         || x----x | x------x ||                ||
>>>>        | Realm |         || |    | | |      | ||                ||
>>>>        |       |         || | VM | | |      | ||                ||
>>>>    ----|  VM*  |---------||-|    |---|      |-||----------------||
>>>>        |       |         || |    | | |  H   | ||                ||
>>>>    EL1 x-------x         || x----x | |      | ||                ||
>>>>            ^             ||        | |  o   | ||                ||
>>>>            |             ||        | |      | ||                ||
>>>>    ------- R*------------------------|  s  -|---------------------
>>>>            S             ||          |      | ||                ||
>>>>            I             ||          |  t   | ||                ||
>>>>            |             ||          |      | ||                ||
>>>>            v             ||          x------x ||                ||
>>>>    EL2    RMM*           ||              ^    ||                ||
>>>>            ^             ||              |    ||                ||
>>>>    ========|=============================|========================
>>>>            |                             | SMC
>>>>            x--------- *RMI* -------------x
>>>>
>>>>    EL3                   Root World
>>>>                          EL3 Firmware
>>>>    ===============================================================
>>>> Where :
>>>>    RMM - Realm Management Monitor
>>>>    RMI - Realm Management Interface
>>>>    RSI - Realm Service Interface
>>>>    SMC - Secure Monitor Call
>>>
>>> Hi,
>>>     It's nice to see this full stack posted - thanks!
>>>
>>> Are there any pointers to information on attestation and similar
>>> measurement things?  In particular, are there any plans for a vTPM
>>
>> The RMM v1.0 provides attestation and measurement services to the Realm,
>> via Realm Service Interface (RSI) calls.
> 
> Can you point me at some docs for that?
> 

It is part of the RMM specification [1], linked below.
Please see "Chapter A7. Realm Measurement and Attestation"

[1] https://developer.arm.com/documentation/den0137/latest

>> However, there is no support
>> for partitioning the Realm VM with v1.0. This is currently under
>> development and should be available in the near future.
>>
>> With that in place, a vTPM could reside in a partition of the Realm VM along
>> side the OS in another. Does that answer your question ?
> 
> Possibly; it would be great to be able to use a standard vTPM interface
> here rather than have to do anything special.  People already have this
> working on AMD SEV-SNP.

Ok.

> 
> Dave

...

>>>>
>>>> [1] RMM Specification Latest
>>>>       https://developer.arm.com/documentation/den0137/latest


Suzuki



>>>>
>>>> [2] RMM v1.0-Beta0 specification
>>>>       https://developer.arm.com/documentation/den0137/1-0bet0/
>>>>
>>>> [3] Trusted Firmware RMM - TF-RMM
>>>>       https://www.trustedfirmware.org/projects/tf-rmm/
>>>>       GIT: https://git.trustedfirmware.org/TF-RMM/tf-rmm.git
>>>>
>>>> [4] FVP Base RevC AEM Model (available on x86_64 / Arm64 Linux)
>>>>       https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms
>>>>
>>>> [5] Trusted Firmware for A class
>>>>       https://www.trustedfirmware.org/projects/tf-a/
>>>>
>>>> [6] Linux kernel support for Arm-CCA
>>>>       https://gitlab.arm.com/linux-arm/linux-cca
>>>>       Host Support branch:	cca-host/rfc-v1
>>>>       Guest Support branch:	cca-guest/rfc-v1
>>>>
>>>> [7] kvmtool support for Arm CCA
>>>>       https://gitlab.arm.com/linux-arm/kvmtool-cca cca/rfc-v1
>>>>
>>>> [8] kvm-unit-tests support for Arm CCA
>>>>       https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca  cca/rfc-v1
>>>>
>>>> [9] Instructions for Building Firmware components and running the model, see
>>>>       section 4.19.2 "Building and running TF-A with RME"
>>>>       https://trustedfirmware-a.readthedocs.io/en/latest/components/realm-management-extension.html#building-and-running-tf-a-with-rme
>>>>
>>>> [10] fd based Guest Private memory for KVM
>>>>      https://lkml.kernel.org/r/20221202061347.1070246-1-chao.p.peng@linux.intel.com
>>>>
>>>> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
>>>> Cc: Andrew Jones <andrew.jones@linux.dev>
>>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>>> Cc: Chao Peng <chao.p.peng@linux.intel.com>
>>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>>> Cc: Fuad Tabba <tabba@google.com>
>>>> Cc: James Morse <james.morse@arm.com>
>>>> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>> Cc: Joey Gouly <Joey.Gouly@arm.com>
>>>> Cc: Marc Zyngier <maz@kernel.org>
>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>> Cc: Oliver Upton <oliver.upton@linux.dev>
>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>> Cc: Quentin Perret <qperret@google.com>
>>>> Cc: Sean Christopherson <seanjc@google.com>
>>>> Cc: Steven Price <steven.price@arm.com>
>>>> Cc: Thomas Huth <thuth@redhat.com>
>>>> Cc: Will Deacon <will@kernel.org>
>>>> Cc: Zenghui Yu <yuzenghui@huawei.com>
>>>> To: linux-coco@lists.linux.dev
>>>> To: kvmarm@lists.linux.dev
>>>> Cc: kvmarm@lists.cs.columbia.edu
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> To: linux-kernel@vger.kernel.org
>>>> To: kvm@vger.kernel.org
>>>>
>>


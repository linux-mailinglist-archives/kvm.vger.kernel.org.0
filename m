Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC26875FC09
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 18:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjGXQ1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 12:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjGXQ1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 12:27:22 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B36910F5;
        Mon, 24 Jul 2023 09:27:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14C73FEC;
        Mon, 24 Jul 2023 09:28:02 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 11E4F3F5A1;
        Mon, 24 Jul 2023 09:27:15 -0700 (PDT)
Message-ID: <0d268afa-c04b-7a4e-be5e-2362d3dfa64d@arm.com>
Date:   Mon, 24 Jul 2023 17:27:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [Question - ARM CCA] vCPU Hotplug Support in ARM Realm world
 might require ARM spec change?
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     Salil Mehta <salil.mehta@huawei.com>,
        "steven.price@arm.com" <steven.price@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Salil Mehta <salil.mehta@opnsrc.net>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        yuzenghui <yuzenghui@huawei.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gareth Stockwell <Gareth.Stockwell@arm.com>
References: <9cb24131a09a48e9a622e92bf8346c9d@huawei.com>
 <7da93c6e-1cbf-8840-282e-f115197b80c4@arm.com>
Content-Language: en-US
In-Reply-To: <7da93c6e-1cbf-8840-282e-f115197b80c4@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Salil

On 19/07/2023 10:28, Suzuki K Poulose wrote:
> Hi Salil
> 
> Thanks for raising this.
> 
> On 19/07/2023 03:35, Salil Mehta wrote:
>> [Reposting it here from Linaro Open Discussion List for more eyes to 
>> look at]
>>
>> Hello,
>> I have recently started to dabble with ARM CCA stuff and check if our
>> recent changes to support vCPU Hotplug in ARM64 can work in the realm
>> world. I have realized that in the RMM specification[1] PSCI_CPU_ON
>> command(B5.3.3) does not handles the PSCI_DENIED return code(B5.4.2),
>> from the host. This might be required to support vCPU Hotplug feature
>> in the realm world in future. vCPU Hotplug is an important feature to
>> support kata-containers in realm world as it reduces the VM boot time
>> and facilitates dynamic adjustment of vCPUs (which I think should be
>> true even with Realm world as current implementation only makes use
>> of the PSCI_ON/OFF to realize the Hotplug look-like effect?)
>>
>>
>> As per our recent changes [2], [3] related to support vCPU Hotplug on
>> ARM64, we handle the guest exits due to SMC/HVC Hypercall in the
>> user-space i.e. VMM/Qemu. In realm world, REC Exits to host due to
>> PSCI_CPU_ON should undergo similar policy checks and I think,
>>
>> 1. Host should *deny* to online the target vCPUs which are NOT plugged
>> 2. This means target REC should be denied by host. Can host call
>>     RMI_PSCI_COMPETE in such s case?
>> 3. The *return* value (B5.3.3.1.3 Output values) should be PSCI_DENIED
> 
> The Realm exit with EXIT_PSCI already provides the parameters passed
> onto the PSCI request. This happens for all PSCI calls except
> (PSCI_VERSION and PSCI_FEAUTRES). The hyp could forward these exits to
> the VMM and could invoke the RMI_PSCI_COMPLETE only when the VMM blesses 
> the request (wherever applicable).
> 
> However, the RMM spec currently doesn't allow denying the request.
> i.e., without RMI_PSCI_COMPLETE, the REC cannot be scheduled back in.
> We will address this in the RMM spec and get back to you.

This is now resolved in RMMv1.0-eac3 spec, available here [0].

This allows the host to DENY a PSCI_CPU_ON request. The RMM ensures that
the response doesn't violate the security guarantees by checking the
state of the target REC.

[0] https://developer.arm.com/documentation/den0137/latest/

Kind regards
Suzuki




> 
> Kind regards
> Suzuki
> 
> 
>> 4. Failure condition (B5.3.3.2) should be amended with
>>     runnable pre: target_rec.flags.runnable == NOT_RUNNABLE (?)
>>              post: result == PSCI_DENIED (?)
>> 5. Change would also be required in the flow (D1.4 PSCI flows) depicting
>>     PSCI_CPU_ON flow (D1.4.1)
>>
>> I do understand that ARM CCA support is in its infancy stage and
>> discussing about vCPU Hotplug in realm world seem to be a far-fetched
>> idea right now. But specification changes require lot of time and if
>> this change is really required then it should be further discussed
>> within ARM.
>>
>> Many thanks!
>>
>>
>> Bes regards
>> Salil
>>
>>
>> References:
>>
>> [1] https://developer.arm.com/documentation/den0137/latest/
>> [2] https://github.com/salil-mehta/qemu.git 
>> virt-cpuhp-armv8/rfc-v1-port11052023.dev-1
>> [3] https://git.gitlab.arm.com/linux-arm/linux-jm.git 
>> virtual_cpu_hotplug/rfc/v2
>>
> 


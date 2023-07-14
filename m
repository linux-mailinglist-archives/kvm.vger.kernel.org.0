Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357F8753E58
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 17:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbjGNPDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 11:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbjGNPDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 11:03:45 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 266A02702;
        Fri, 14 Jul 2023 08:03:43 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAAED1570;
        Fri, 14 Jul 2023 08:04:24 -0700 (PDT)
Received: from [10.57.36.153] (unknown [10.57.36.153])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AE2C3F740;
        Fri, 14 Jul 2023 08:03:39 -0700 (PDT)
Message-ID: <42cbffac-05a8-a279-9bdb-f76354c1a1b1@arm.com>
Date:   Fri, 14 Jul 2023 16:03:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
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
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230714144657.000064ef@Huawei.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230714144657.000064ef@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jonathan

On 14/07/2023 14:46, Jonathan Cameron wrote:
> On Fri, 27 Jan 2023 11:22:48 +0000
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
> 
> Hi Suzuki,
> 
> Looking at this has been on the backlog for a while from our side and we are finally
> getting to it.  So before we dive in and given it's been 6 months, I wanted to check
> if you expect to post a new version shortly or if there is a rebased tree available?

Thanks for your interest. We have been updating our trees to the latest
RMM specification (v1.0-eac2 now) and also rebasing Linux/KVM on top of
v6.5-rc1. We will post this as soon as we have all the components ready
(and the TF-RMM). At the earliest, this would be around early September.

That said, the revised version will have the following changes :
  - Changes to the Stage2 management
  - Changes to RMM memory management for Realm
  - PMU/SVE support

Otherwise, most of the changes remain the same (e.g., UABI). Happy to
hear feedback on those areas.


Kind regards
Suzuki

> 
> Jonathan
>    
>> We are happy to announce the early RFC version of the Arm
>> Confidential Compute Architecture (CCA) support for the Linux
>> stack. The intention is to seek early feedback in the following areas:
>>   * KVM integration of the Arm CCA
>>   * KVM UABI for managing the Realms, seeking to generalise the operations
>>     wherever possible with other Confidential Compute solutions.
>>     Note: This version doesn't support Guest Private memory, which will be added
>>     later (see below).
>>   * Linux Guest support for Realms
>>
>> Arm CCA Introduction
>> =====================
>>
>> The Arm CCA is a reference software architecture and implementation that builds
>> on the Realm Management Extension (RME), enabling the execution of Virtual
>> machines, while preventing access by more privileged software, such as hypervisor.
>> The Arm CCA allows the hypervisor to control the VM, but removes the right for
>> access to the code, register state or data that is used by VM.
>> More information on the architecture is available here[0].
>>
>>      Arm CCA Reference Software Architecture
>>
>>          Realm World    ||    Normal World   ||  Secure World  ||
>>                         ||        |          ||                ||
>>   EL0 x-------x         || x----x | x------x ||                ||
>>       | Realm |         || |    | | |      | ||                ||
>>       |       |         || | VM | | |      | ||                ||
>>   ----|  VM*  |---------||-|    |---|      |-||----------------||
>>       |       |         || |    | | |  H   | ||                ||
>>   EL1 x-------x         || x----x | |      | ||                ||
>>           ^             ||        | |  o   | ||                ||
>>           |             ||        | |      | ||                ||
>>   ------- R*------------------------|  s  -|---------------------
>>           S             ||          |      | ||                ||
>>           I             ||          |  t   | ||                ||
>>           |             ||          |      | ||                ||
>>           v             ||          x------x ||                ||
>>   EL2    RMM*           ||              ^    ||                ||
>>           ^             ||              |    ||                ||
>>   ========|=============================|========================
>>           |                             | SMC
>>           x--------- *RMI* -------------x
>>
>>   EL3                   Root World
>>                         EL3 Firmware
>>   ===============================================================
>> Where :
>>   RMM - Realm Management Monitor
>>   RMI - Realm Management Interface
>>   RSI - Realm Service Interface
>>   SMC - Secure Monitor Call
>>
>> RME introduces a new security state "Realm world", in addition to the
>> traditional Secure and Non-Secure states. The Arm CCA defines a new component,
>> Realm Management Monitor (RMM) that runs at R-EL2. This is a standard piece of
>> firmware, verified, installed and loaded by the EL3 firmware (e.g, TF-A), at
>> system boot.
>>
>> The RMM provides standard interfaces - Realm Management Interface (RMI) - to the
>> Normal world hypervisor to manage the VMs running in the Realm world (also called
>> Realms in short). These are exposed via SMC and are routed through the EL3
>> firmwre.
>> The RMI interface includes:
>>    - Move a physical page from the Normal world to the Realm world
>>    - Creating a Realm with requested parameters, tracked via Realm Descriptor (RD)
>>    - Creating VCPUs aka Realm Execution Context (REC), with initial register state.
>>    - Create stage2 translation table at any level.
>>    - Load initial images into Realm Memory from normal world memory
>>    - Schedule RECs (vCPUs) and handle exits
>>    - Inject virtual interrupts into the Realm
>>    - Service stage2 runtime faults with pages (provided by host, scrubbed by RMM).
>>    - Create "shared" mappings that can be accessed by VMM/Hyp.
>>    - Reclaim the memory allocated for the RAM and RTTs (Realm Translation Tables)
>>
>> However v1.0 of RMM specifications doesn't support:
>>   - Paging protected memory of a Realm VM. Thus the pages backing the protected
>>     memory region must be pinned.
>>   - Live migration of Realms.
>>   - Trusted Device assignment.
>>   - Physical interrupt backed Virtual interrupts for Realms
>>
>> RMM also provides certain services to the Realms via SMC, called Realm Service
>> Interface (RSI). These include:
>>   - Realm Guest Configuration.
>>   - Attestation & Measurement services
>>   - Managing the state of an Intermediate Physical Address (IPA aka GPA) page.
>>   - Host Call service (Communication with the Normal world Hypervisor)
>>
>> The specifications for the RMM software is currently at *v1.0-Beta2* and the
>> latest version is available here [1].
>>
>> The Trusted Firmware foundation has an implementation of the RMM - TF-RMM -
>> available here [3].
>>
>> Implementation
>> =================
>>
>> This version of the stack is based on the RMM specification v1.0-Beta0[2], with
>> following exceptions :
>>    - TF-RMM/KVM currently doesn't support the optional features of PMU,
>>       SVE and Self-hosted debug (coming soon).
>>    - The RSI_HOST_CALL structure alignment requirement is reduced to match
>>       RMM v1.0 Beta1
>>    - RMI/RSI version numbers do not match the RMM spec. This will be
>>      resolved once the spec/implementation is complete, across TF-RMM+Linux stack.
>>
>> We plan to update the stack to support the latest version of the RMMv1.0 spec
>> in the coming revisions.
>>
>> This release includes the following components :
>>
>>   a) Linux Kernel
>>       i) Host / KVM support - Support for driving the Realms via RMI. This is
>>       dependent on running in the Kernel at EL2 (aka VHE mode). Also provides
>>       UABI for VMMs to manage the Realm VMs. The support is restricted to 4K page
>>       size, matching the Stage2 granule supported by RMM. The VMM is responsible
>>       for making sure the guest memory is locked.
>>
>>         TODO: Guest Private memory[10] integration - We have been following the
>>         series and support will be added once it is merged upstream.
>>       
>>       ii) Guest support - Support for a Linux Kernel to run in the Realm VM at
>>       Realm-EL1, using RSI services. This includes virtio support (virtio-v1.0
>>       only). All I/O are treated as non-secure/shared.
>>   
>>   c) kvmtool - VMM changes required to manage Realm VMs. No guest private memory
>>      as mentioned above.
>>   d) kvm-unit-tests - Support for running in Realms along with additional tests
>>      for RSI ABI.
>>
>> Running the stack
>> ====================
>>
>> To run/test the stack, you would need the following components :
>>
>> 1) FVP Base AEM RevC model with FEAT_RME support [4]
>> 2) TF-A firmware for EL3 [5]
>> 3) TF-A RMM for R-EL2 [3]
>> 4) Linux Kernel [6]
>> 5) kvmtool [7]
>> 6) kvm-unit-tests [8]
>>
>> Instructions for building the firmware components and running the model are
>> available here [9]. Once, the host kernel is booted, a Realm can be launched by
>> invoking the `lkvm` commad as follows:
>>
>>   $ lkvm run --realm 				 \
>> 	 --measurement-algo=["sha256", "sha512"] \
>> 	 --disable-sve				 \
>> 	 <normal-vm-options>
>>
>> Where:
>>   * --measurement-algo (Optional) specifies the algorithm selected for creating the
>>     initial measurements by the RMM for this Realm (defaults to sha256).
>>   * GICv3 is mandatory for the Realms.
>>   * SVE is not yet supported in the TF-RMM, and thus must be disabled using
>>     --disable-sve
>>
>> You may also run the kvm-unit-tests inside the Realm world, using the similar
>> options as above.
>>
>>
>> Links
>> ============
>>
>> [0] Arm CCA Landing page (See Key Resources section for various documentations)
>>      https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
>>
>> [1] RMM Specification Latest
>>      https://developer.arm.com/documentation/den0137/latest
>>
>> [2] RMM v1.0-Beta0 specification
>>      https://developer.arm.com/documentation/den0137/1-0bet0/
>>
>> [3] Trusted Firmware RMM - TF-RMM
>>      https://www.trustedfirmware.org/projects/tf-rmm/
>>      GIT: https://git.trustedfirmware.org/TF-RMM/tf-rmm.git
>>
>> [4] FVP Base RevC AEM Model (available on x86_64 / Arm64 Linux)
>>      https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms
>>
>> [5] Trusted Firmware for A class
>>      https://www.trustedfirmware.org/projects/tf-a/
>>
>> [6] Linux kernel support for Arm-CCA
>>      https://gitlab.arm.com/linux-arm/linux-cca
>>      Host Support branch:	cca-host/rfc-v1
>>      Guest Support branch:	cca-guest/rfc-v1
>>
>> [7] kvmtool support for Arm CCA
>>      https://gitlab.arm.com/linux-arm/kvmtool-cca cca/rfc-v1
>>
>> [8] kvm-unit-tests support for Arm CCA
>>      https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca  cca/rfc-v1
>>
>> [9] Instructions for Building Firmware components and running the model, see
>>      section 4.19.2 "Building and running TF-A with RME"
>>      https://trustedfirmware-a.readthedocs.io/en/latest/components/realm-management-extension.html#building-and-running-tf-a-with-rme
>>
>> [10] fd based Guest Private memory for KVM
>>     https://lkml.kernel.org/r/20221202061347.1070246-1-chao.p.peng@linux.intel.com
>>
>> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
>> Cc: Andrew Jones <andrew.jones@linux.dev>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Chao Peng <chao.p.peng@linux.intel.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Fuad Tabba <tabba@google.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Cc: Joey Gouly <Joey.Gouly@arm.com>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Quentin Perret <qperret@google.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Steven Price <steven.price@arm.com>
>> Cc: Thomas Huth <thuth@redhat.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Zenghui Yu <yuzenghui@huawei.com>
>> To: linux-coco@lists.linux.dev
>> To: kvmarm@lists.linux.dev
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: linux-arm-kernel@lists.infradead.org
>> To: linux-kernel@vger.kernel.org
>> To: kvm@vger.kernel.org
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


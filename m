Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D818F540262
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 17:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344062AbiFGP1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 11:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344053AbiFGP1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 11:27:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C100212A9E
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 08:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654615656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oCDKw5s2Zx258kyF9u/hUeOr+nS4TJiXeg+i1OLkhtc=;
        b=SckD12fZKAN4ZK+M7DM4N5dz73DRtCVPOnCYJ+ozuWcU7uGHFG2zFgr7eC0s7Z+Hm8VzWR
        mB/FFf5WJ7fWhvtEk3MN5Iz337O0EbMxunWOr3U5OhDENUW2tiQyYrIjRGzoHuTMuPBTOi
        VrNW/17aqd0ZV1sHIElVpv6ZdQ3BKx4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-gB4FPjNPPhG1x-lW0u3PYw-1; Tue, 07 Jun 2022 11:27:35 -0400
X-MC-Unique: gB4FPjNPPhG1x-lW0u3PYw-1
Received: by mail-wr1-f69.google.com with SMTP id ay4-20020a5d6f04000000b002183e363f9bso1883451wrb.22
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 08:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oCDKw5s2Zx258kyF9u/hUeOr+nS4TJiXeg+i1OLkhtc=;
        b=YqYp49EtFrz4C88R/p2hx3g62Y3swhHU4bD+c24q1fHRxu/v/rFxVzTV0zaUe2K+0E
         NZmDyXXCoGkOJ3/+c/jLtZfP/TaEXfZ5xczmNmJd21xwBtJIdl4Aylg0Dc3jqzZ+6b1m
         eaUS80Qlc7Mj4vY8eA1NVIXmB8dGp+y7jFBtWKDV54GseAkhnbQYiP52/ZL4tsE1/vbz
         0UGjqGLfKEftLHGuOvDD+HyiJ4g4bhbJMnE9O3PMxUB8fPcjHFlmHNEiKuB/iJeUcy+4
         Dv90sSgexyYUAAR13WCVAm1OBsc34qw0uDs5229kDwJlaeoFjCwcN3T2fLREMCQLcgYs
         k3qw==
X-Gm-Message-State: AOAM530fzyHH5axijYlYELi/HJERslGlsz2RFJv385lg8cIPpkK6K9xB
        iq8CalxcUcRzCfVB2yGF1rYZ8PTeNHKDr6/gXAVyGr8Y9iEQdIwAcxSHJlA5Ai2KAJdUZx+d785
        YDaOpMQFTVWfN
X-Received: by 2002:a5d:660e:0:b0:210:3140:ea11 with SMTP id n14-20020a5d660e000000b002103140ea11mr28442348wru.326.1654615654199;
        Tue, 07 Jun 2022 08:27:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwk3872GBPwsDVt6SfG5DIbMGPaRaINCO2FOvVH7a20eDdfPlXTwRBdPIjZEzXR2SCQ5LT9oA==
X-Received: by 2002:a5d:660e:0:b0:210:3140:ea11 with SMTP id n14-20020a5d660e000000b002103140ea11mr28442313wru.326.1654615653881;
        Tue, 07 Jun 2022 08:27:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id y4-20020a5d4704000000b0020c5253d907sm17778788wrq.83.2022.06.07.08.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 08:27:33 -0700 (PDT)
Message-ID: <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
Date:   Tue, 7 Jun 2022 17:27:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "anup@brainfault.org" <anup@brainfault.org>
References: <20220603004331.1523888-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc, Christian, Anup, can you please give this a go?

Paolo

On 6/3/22 02:41, Sean Christopherson wrote:
> Overhaul KVM's selftest APIs to get selftests to a state where adding new
> features and writing tests is less painful/disgusting.
> 
> Patches 1 fixes a goof in kvm/queue and should be squashed.
> 
> I would really, really, really like to get this queued up sooner than
> later, or maybe just thrown into a separate selftests-specific branch that
> folks can develop against.  Rebasing is tedious, frustrating, and time
> consuming.  And spoiler alert, there's another 42 x86-centric patches
> inbound that builds on this series to clean up CPUID related crud...
> 
> The primary theme is to stop treating tests like second class citizens.
> Stop hiding vcpu, kvm_vm, etc...  There's no sensitive data/constructs, and
> the encapsulation has led to really, really bad and difficult to maintain
> code.  E.g. having to pass around the VM just to call a vCPU ioctl(),
> arbitrary non-zero vCPU IDs, tests having to care about the vCPU ID in the
> first place, etc...
> 
> The other theme in the rework is to deduplicate code and try to set us
> up for success in the future.  E.g. provide macros/helpers instead of
> spamming CTRL-C => CTRL-V (see the -1k LoC), structure the VM creation
> APIs to build on one another, etc...
> 
> The absurd patch count (as opposed to just ridiculous) is due to converting
> each test away from using hardcoded vCPU IDs in a separate patch.  The vast
> majority of those patches probably aren't worth reviewing in depth, the
> changes are mostly mechanical in nature.
> 
> However, _running_ non-x86 tests (or tests that have unique non-x86
> behavior) would be extremely valuable.  All patches have been compile tested
> on x86, arm, risc-v, and s390, but I've only run the tests on x86.  Based on
> my track record for the x86+common tests, I will be very, very surprised if
> I didn't break any of the non-x86 tests, e.g. pthread_create()'s 'void *'
> param tripped me up multiple times.
> 
> I have not run x86's amx_test due to lack of hardware.  I also haven't run
> sev_migration; something is wonky in either the upstream support for INIT_EX
> or in our test machines and I can't get SEV to initialize.
> 
> v2:
>    - Drop the forced -Werror patch. [Vitaly]
>    - Add TEST_REQUIRE to reduce KSFT_SKIP boilerplate.
>    - Rebase to kvm/queue, commit 55371f1d0c01.
>    - Clean up even more bad copy+paste code (x86 was hiding a lot of crud).
>    - Assert that the input to an ioctl() is (likely) the correct struct.
> 
> v1: https://lore.kernel.org/all/20220504224914.1654036-1-seanjc@google.com
> 
> Sean Christopherson (144):
>    KVM: Fix references to non-existent KVM_CAP_TRIPLE_FAULT_EVENT
>    KVM: selftests: Fix buggy-but-benign check in
>      test_v3_new_redist_regions()
>    KVM: selftests: Fix typo in vgic_init test
>    KVM: selftests: Drop stale declarations from kvm_util_base.h
>    KVM: selftests: Always open VM file descriptors with O_RDWR
>    KVM: selftests: Add another underscore to inner ioctl() helpers
>    KVM: selftests: Make vcpu_ioctl() a wrapper to pretty print ioctl name
>    KVM: selftests: Drop @mode from common vm_create() helper
>    KVM: selftests: Split vcpu_set_nested_state() into two helpers
>    KVM: sefltests: Use vcpu_ioctl() and __vcpu_ioctl() helpers
>    KVM: selftests: Add __vcpu_run() helper
>    KVM: selftests: Use vcpu_access_device_attr() in arm64 code
>    KVM: selftests: Remove vcpu_get_fd()
>    KVM: selftests: Add vcpu_get() to retrieve and assert on vCPU
>      existence
>    KVM: selftests: Make vm_ioctl() a wrapper to pretty print ioctl name
>    KVM: sefltests: Use vm_ioctl() and __vm_ioctl() helpers
>    KVM: selftests: Make kvm_ioctl() a wrapper to pretty print ioctl name
>    KVM: selftests: Use kvm_ioctl() helpers
>    KVM: selftests: Use __KVM_SYSCALL_ERROR() to handle non-KVM syscall
>      errors
>    KVM: selftests: Make x86-64's register dump helpers static
>    KVM: selftests: Get rid of kvm_util_internal.h
>    KVM: selftests: Use KVM_IOCTL_ERROR() for one-off arm64 ioctls
>    KVM: selftests: Drop @test param from kvm_create_device()
>    KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to separate helper
>    KVM: selftests: Multiplex return code and fd in __kvm_create_device()
>    KVM: selftests: Rename KVM_HAS_DEVICE_ATTR helpers for consistency
>    KVM: selftests: Drop 'int' return from asserting *_has_device_attr()
>    KVM: selftests: Split get/set device_attr helpers
>    KVM: selftests: Add a VM backpointer to 'struct vcpu'
>    KVM: selftests: Consolidate KVM_ENABLE_CAP usage
>    KVM: selftests: Simplify KVM_ENABLE_CAP helper APIs
>    KVM: selftests: Cache list of MSRs to save/restore
>    KVM: selftests: Harden and comment XSS / KVM_SET_MSRS interaction
>    KVM: selftests: Dedup MSR index list helpers, simplify dedicated test
>    KVM: selftests: Rename MP_STATE and GUEST_DEBUG helpers for
>      consistency
>    KVM: selftest: Add proper helpers for x86-specific save/restore ioctls
>    KVM: selftests: Add vm_create_*() variants to expose/return 'struct
>      vcpu'
>    KVM: selftests: Push vm_adjust_num_guest_pages() into "w/o vCPUs"
>      helper
>    KVM: selftests: Use vm_create_without_vcpus() in set_boot_cpu_id
>    KVM: selftests: Use vm_create_without_vcpus() in dirty_log_test
>    KVM: selftests: Use vm_create_without_vcpus() in hardware_disable_test
>    KVM: selftests: Use vm_create_without_vcpus() in psci_test
>    KVM: selftests: Rename vm_create() => vm_create_barebones(), drop
>      param
>    KVM: selftests: Rename vm_create_without_vcpus() => vm_create()
>    KVM: selftests: Make vm_create() a wrapper that specifies
>      VM_MODE_DEFAULT
>    KVM: selftests: Rename xAPIC state test's vcpu struct
>    KVM: selftests: Rename vcpu.state => vcpu.run
>    KVM: selftests: Rename 'struct vcpu' to 'struct kvm_vcpu'
>    KVM: selftests: Return the created vCPU from vm_vcpu_add()
>    KVM: selftests: Convert memslot_perf_test away from VCPU_ID
>    KVM: selftests: Convert rseq_test away from VCPU_ID
>    KVM: selftests: Convert xss_msr_test away from VCPU_ID
>    KVM: selftests: Convert vmx_preemption_timer_test away from VCPU_ID
>    KVM: selftests: Convert vmx_pmu_msrs_test away from VCPU_ID
>    KVM: selftests: Convert vmx_set_nested_state_test away from VCPU_ID
>    KVM: selftests: Convert vmx_tsc_adjust_test away from VCPU_ID
>    KVM: selftests: Convert mmu_role_test away from VCPU_ID
>    KVM: selftests: Convert pmu_event_filter_test away from VCPU_ID
>    KVM: selftests: Convert smm_test away from VCPU_ID
>    KVM: selftests: Convert state_test away from VCPU_ID
>    KVM: selftests: Convert svm_int_ctl_test away from VCPU_ID
>    KVM: selftests: Convert svm_vmcall_test away from VCPU_ID
>    KVM: selftests: Convert sync_regs_test away from VCPU_ID
>    KVM: selftests: Convert hyperv_cpuid away from VCPU_ID
>    KVM: selftests: Convert kvm_pv_test away from VCPU_ID
>    KVM: selftests: Convert platform_info_test away from VCPU_ID
>    KVM: selftests: Convert vmx_nested_tsc_scaling_test away from VCPU_ID
>    KVM: selftests: Convert set_sregs_test away from VCPU_ID
>    KVM: selftests: Convert vmx_dirty_log_test away from VCPU_ID
>    KVM: selftests: Convert vmx_close_while_nested_test away from VCPU_ID
>    KVM: selftests: Convert vmx_apic_access_test away from VCPU_ID
>    KVM: selftests: Convert userspace_msr_exit_test away from VCPU_ID
>    KVM: selftests: Convert vmx_exception_with_invalid_guest_state away
>      from VCPU_ID
>    KVM: selftests: Convert tsc_msrs_test away from VCPU_ID
>    KVM: selftests: Convert kvm_clock_test away from VCPU_ID
>    KVM: selftests: Convert hyperv_svm_test away from VCPU_ID
>    KVM: selftests: Convert hyperv_features away from VCPU_ID
>    KVM: selftests: Convert hyperv_clock away from VCPU_ID
>    KVM: selftests: Convert evmcs_test away from VCPU_ID
>    KVM: selftests: Convert emulator_error_test away from VCPU_ID
>    KVM: selftests: Convert debug_regs away from VCPU_ID
>    KVM: selftests: Add proper helper for advancing RIP in debug_regs
>    KVM: selftests: Convert amx_test away from VCPU_ID
>    KVM: selftests: Convert cr4_cpuid_sync_test away from VCPU_ID
>    KVM: selftests: Convert cpuid_test away from VCPU_ID
>    KVM: selftests: Convert userspace_io_test away from VCPU_ID
>    KVM: selftests: Convert vmx_invalid_nested_guest_state away from
>      VCPU_ID
>    KVM: selftests: Convert xen_vmcall_test away from VCPU_ID
>    KVM: selftests: Convert xen_shinfo_test away from VCPU_ID
>    KVM: selftests: Convert dirty_log_test away from VCPU_ID
>    KVM: selftests: Convert set_memory_region_test away from VCPU_ID
>    KVM: selftests: Convert system_counter_offset_test away from VCPU_ID
>    KVM: selftests: Track kvm_vcpu object in tsc_scaling_sync
>    KVM: selftests: Convert xapic_state_test away from hardcoded vCPU ID
>    KVM: selftests: Convert debug-exceptions away from VCPU_ID
>    KVM: selftests: Convert fix_hypercall_test away from VCPU_ID
>    KVM: selftests: Convert vgic_irq away from VCPU_ID
>    KVM: selftests: Make arm64's guest_get_vcpuid() declaration arm64-only
>    KVM: selftests: Move vm_is_unrestricted_guest() to x86-64
>    KVM: selftests: Add "arch" to common utils that have arch
>      implementations
>    KVM: selftests: Return created vcpu from vm_vcpu_add_default()
>    KVM: selftests: Rename vm_vcpu_add* helpers to better show
>      relationships
>    KVM: selftests: Convert set_boot_cpu_id away from global VCPU_IDs
>    KVM: selftests: Convert psci_test away from VCPU_ID
>    KVM: selftests: Convert hardware_disable_test to pass around vCPU
>      objects
>    KVM: selftests: Add VM creation helper that "returns" vCPUs
>    KVM: selftests: Convert steal_time away from VCPU_ID
>    KVM: selftests: Convert arch_timer away from VCPU_ID
>    KVM: selftests: Convert svm_nested_soft_inject_test away from VCPU_ID
>    KVM: selftests: Convert triple_fault_event_test away from VCPU_ID
>    KVM: selftests: Convert vgic_init away from
>      vm_create_default_with_vcpus()
>    KVM: selftests: Consolidate KVM_{G,S}ET_ONE_REG helpers
>    KVM: selftests: Sync stage before VM is freed in hypercalls test
>    KVM: selftests: Convert hypercalls test away from vm_create_default()
>    KVM: selftests: Convert xapic_ipi_test away from *_VCPU_ID
>    KVM: selftests: Convert sync_regs_test away from VCPU_ID
>    KVM: selftests: Convert s390's "resets" test away from VCPU_ID
>    KVM: selftests: Convert memop away from VCPU_ID
>    KVM: selftests: Convert s390x/diag318_test_handler away from VCPU_ID
>    KVM: selftests: Convert tprot away from VCPU_ID
>    KVM: selftests: Use vm_create() in tsc_scaling_sync
>    KVM: selftests: Use vm_create_with_vcpus() in max_guest_memory_test
>    KVM: selftests: Drop vm_create_default* helpers
>    KVM: selftests: Drop @vcpuids param from VM creators
>    KVM: selftests: Convert kvm_page_table_test away from reliance on
>      vcpu_id
>    KVM: selftests: Convert kvm_binary_stats_test away from vCPU IDs
>    KVM: selftests: Convert get-reg-list away from its "VCPU_ID"
>    KVM: selftests: Stop hardcoding vCPU IDs in vcpu_width_config
>    KVM: selftests: Stop conflating vCPU index and ID in perf tests
>    KVM: selftests: Remove vcpu_get() usage from dirty_log_test
>    KVM: selftests: Require vCPU output array when creating VM with vCPUs
>    KVM: selftests: Purge vm+vcpu_id == vcpu silliness
>    KVM: selftests: Drop vcpu_get(), rename vcpu_find() => vcpu_exists()
>    KVM: selftests: Remove vcpu_state() helper
>    KVM: selftests: Open code and drop 'struct kvm_vm' accessors
>    KVM: selftests: Drop @slot0_mem_pages from __vm_create_with_vcpus()
>    KVM: selftests: Drop @num_percpu_pages from __vm_create_with_vcpus()
>    KVM: selftests: Move per-VM/per-vCPU nr pages calculation to
>      __vm_create()
>    KVM: selftests: Trust that MAXPHYADDR > memslot0 in
>      vmx_apic_access_test
>    KVM: selftests: Drop DEFAULT_GUEST_PHY_PAGES, open code the magic
>      number
>    KVM: selftests: Return an 'unsigned int' from kvm_check_cap()
>    KVM: selftests: Add kvm_has_cap() to provide syntactic sugar
>    KVM: selftests: Add TEST_REQUIRE macros to reduce skipping copy+paste
>    KVM: selftests: Sanity check input to ioctls() at build time
> 
>   Documentation/virt/kvm/api.rst                |    4 +-
>   .../selftests/kvm/aarch64/arch_timer.c        |   79 +-
>   .../selftests/kvm/aarch64/debug-exceptions.c  |   22 +-
>   .../selftests/kvm/aarch64/get-reg-list.c      |   29 +-
>   .../selftests/kvm/aarch64/hypercalls.c        |   90 +-
>   .../testing/selftests/kvm/aarch64/psci_test.c |   69 +-
>   .../selftests/kvm/aarch64/vcpu_width_config.c |   71 +-
>   .../testing/selftests/kvm/aarch64/vgic_init.c |  379 +++---
>   .../testing/selftests/kvm/aarch64/vgic_irq.c  |   40 +-
>   .../selftests/kvm/access_tracking_perf_test.c |   92 +-
>   .../selftests/kvm/demand_paging_test.c        |   49 +-
>   .../selftests/kvm/dirty_log_perf_test.c       |   51 +-
>   tools/testing/selftests/kvm/dirty_log_test.c  |   95 +-
>   .../selftests/kvm/hardware_disable_test.c     |   29 +-
>   .../selftests/kvm/include/aarch64/processor.h |   28 +-
>   .../selftests/kvm/include/aarch64/vgic.h      |    6 +-
>   .../selftests/kvm/include/kvm_util_base.h     |  743 ++++++++---
>   .../selftests/kvm/include/perf_test_util.h    |    5 +-
>   .../selftests/kvm/include/riscv/processor.h   |   20 -
>   .../testing/selftests/kvm/include/test_util.h |    9 +
>   .../selftests/kvm/include/ucall_common.h      |    2 +-
>   .../selftests/kvm/include/x86_64/evmcs.h      |    2 +-
>   .../selftests/kvm/include/x86_64/processor.h  |  109 +-
>   .../selftests/kvm/kvm_binary_stats_test.c     |   31 +-
>   .../selftests/kvm/kvm_create_max_vcpus.c      |   10 +-
>   .../selftests/kvm/kvm_page_table_test.c       |   66 +-
>   .../selftests/kvm/lib/aarch64/processor.c     |   81 +-
>   .../testing/selftests/kvm/lib/aarch64/ucall.c |    9 +-
>   .../testing/selftests/kvm/lib/aarch64/vgic.c  |   54 +-
>   tools/testing/selftests/kvm/lib/elf.c         |    1 -
>   tools/testing/selftests/kvm/lib/guest_modes.c |    6 +-
>   tools/testing/selftests/kvm/lib/kvm_util.c    | 1104 +++--------------
>   .../selftests/kvm/lib/kvm_util_internal.h     |  128 --
>   .../selftests/kvm/lib/perf_test_util.c        |   84 +-
>   .../selftests/kvm/lib/riscv/processor.c       |  111 +-
>   tools/testing/selftests/kvm/lib/riscv/ucall.c |   14 +-
>   .../kvm/lib/s390x/diag318_test_handler.c      |   11 +-
>   .../selftests/kvm/lib/s390x/processor.c       |   44 +-
>   tools/testing/selftests/kvm/lib/s390x/ucall.c |    8 +-
>   .../selftests/kvm/lib/x86_64/processor.c      |  533 +++-----
>   tools/testing/selftests/kvm/lib/x86_64/svm.c  |    6 +-
>   .../testing/selftests/kvm/lib/x86_64/ucall.c  |   10 +-
>   tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   16 +-
>   .../selftests/kvm/max_guest_memory_test.c     |   53 +-
>   .../kvm/memslot_modification_stress_test.c    |   13 +-
>   .../testing/selftests/kvm/memslot_perf_test.c |   28 +-
>   tools/testing/selftests/kvm/rseq_test.c       |   22 +-
>   tools/testing/selftests/kvm/s390x/memop.c     |   93 +-
>   tools/testing/selftests/kvm/s390x/resets.c    |  140 ++-
>   .../selftests/kvm/s390x/sync_regs_test.c      |   45 +-
>   tools/testing/selftests/kvm/s390x/tprot.c     |   25 +-
>   .../selftests/kvm/set_memory_region_test.c    |   43 +-
>   tools/testing/selftests/kvm/steal_time.c      |  120 +-
>   .../kvm/system_counter_offset_test.c          |   35 +-
>   tools/testing/selftests/kvm/x86_64/amx_test.c |   56 +-
>   .../testing/selftests/kvm/x86_64/cpuid_test.c |   29 +-
>   .../kvm/x86_64/cr4_cpuid_sync_test.c          |   22 +-
>   .../testing/selftests/kvm/x86_64/debug_regs.c |   77 +-
>   .../kvm/x86_64/emulator_error_test.c          |   74 +-
>   .../testing/selftests/kvm/x86_64/evmcs_test.c |   61 +-
>   .../selftests/kvm/x86_64/fix_hypercall_test.c |   45 +-
>   .../kvm/x86_64/get_msr_index_features.c       |  117 +-
>   .../selftests/kvm/x86_64/hyperv_clock.c       |   25 +-
>   .../selftests/kvm/x86_64/hyperv_cpuid.c       |   34 +-
>   .../selftests/kvm/x86_64/hyperv_features.c    |   61 +-
>   .../selftests/kvm/x86_64/hyperv_svm_test.c    |   20 +-
>   .../selftests/kvm/x86_64/kvm_clock_test.c     |   29 +-
>   .../selftests/kvm/x86_64/kvm_pv_test.c        |   33 +-
>   .../kvm/x86_64/max_vcpuid_cap_test.c          |   28 +-
>   .../selftests/kvm/x86_64/mmio_warning_test.c  |   16 +-
>   .../selftests/kvm/x86_64/mmu_role_test.c      |   30 +-
>   .../selftests/kvm/x86_64/platform_info_test.c |   51 +-
>   .../kvm/x86_64/pmu_event_filter_test.c        |   97 +-
>   .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   91 +-
>   .../selftests/kvm/x86_64/set_sregs_test.c     |   47 +-
>   .../selftests/kvm/x86_64/sev_migrate_tests.c  |  120 +-
>   tools/testing/selftests/kvm/x86_64/smm_test.c |   37 +-
>   .../testing/selftests/kvm/x86_64/state_test.c |   29 +-
>   .../selftests/kvm/x86_64/svm_int_ctl_test.c   |   21 +-
>   .../kvm/x86_64/svm_nested_soft_inject_test.c  |   17 +-
>   .../selftests/kvm/x86_64/svm_vmcall_test.c    |   16 +-
>   .../selftests/kvm/x86_64/sync_regs_test.c     |   62 +-
>   .../kvm/x86_64/triple_fault_event_test.c      |   39 +-
>   .../selftests/kvm/x86_64/tsc_msrs_test.c      |   35 +-
>   .../selftests/kvm/x86_64/tsc_scaling_sync.c   |   25 +-
>   .../selftests/kvm/x86_64/userspace_io_test.c  |   18 +-
>   .../kvm/x86_64/userspace_msr_exit_test.c      |  187 ++-
>   .../kvm/x86_64/vmx_apic_access_test.c         |   27 +-
>   .../kvm/x86_64/vmx_close_while_nested_test.c  |   17 +-
>   .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   13 +-
>   .../vmx_exception_with_invalid_guest_state.c  |   68 +-
>   .../x86_64/vmx_invalid_nested_guest_state.c   |   18 +-
>   .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |   29 +-
>   .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |   48 +-
>   .../kvm/x86_64/vmx_preemption_timer_test.c    |   35 +-
>   .../kvm/x86_64/vmx_set_nested_state_test.c    |   91 +-
>   .../kvm/x86_64/vmx_tsc_adjust_test.c          |   13 +-
>   .../selftests/kvm/x86_64/xapic_ipi_test.c     |   48 +-
>   .../selftests/kvm/x86_64/xapic_state_test.c   |   60 +-
>   .../selftests/kvm/x86_64/xen_shinfo_test.c    |   73 +-
>   .../selftests/kvm/x86_64/xen_vmcall_test.c    |   25 +-
>   .../selftests/kvm/x86_64/xss_msr_test.c       |   56 +-
>   102 files changed, 3059 insertions(+), 4178 deletions(-)
>   delete mode 100644 tools/testing/selftests/kvm/lib/kvm_util_internal.h
> 
> 
> base-commit: 55371f1d0c01357f29da613f7525c3f252320bbf


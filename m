Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A8F4D7F03
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 10:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbiCNJwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 05:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238075AbiCNJwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 05:52:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7E03381A1
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 02:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647251460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NdZjZsY5HTzFedb2yDi2Hsox7E+TnnFf4fwg9DTWOQU=;
        b=VODB0rNOZb83t4fln1MFIMXBWkBWo2eKUsLz91+Yzgr2QO/OnWN6geqWdupYxwu0lSYzaK
        IRDejnSl0+RAqOUswAiJwJqYo57gvtjfj890PFHjNHImmASApQMv+oZPJFEo5Yl06ZwIo7
        PoLJKoReukuglZDdDxkQIMwWZyAQPNs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-WOmb4Pp_OJa4tUqiE3Xw6g-1; Mon, 14 Mar 2022 05:49:25 -0400
X-MC-Unique: WOmb4Pp_OJa4tUqiE3Xw6g-1
Received: by mail-ed1-f70.google.com with SMTP id s7-20020a508dc7000000b0040f29ccd65aso8390636edh.1
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 02:49:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NdZjZsY5HTzFedb2yDi2Hsox7E+TnnFf4fwg9DTWOQU=;
        b=xg/rfOmkFpfJQkTr7u9TViwnl4F/sLRnoKsXuG3dPHUIe0QQXpc/rCgdt3mAjqtURb
         B0jzVKC/4mWWRokww+Q3u206nCmtXVw7qhjtvKTSOAsN3l/ypKKIRrdb2wJG6gtCpTjQ
         I4gFibGy0IKhct1oNlF+SZ7MimPBfhhRM6o2UJ6v+BToT1W+ENczGL2MZXacqe08P6LC
         yGKJxQO+PRIRte/9CYUcSUQIxjB4cczjKvcjpYxgFmePL42R7GJlbTTR4AT3eN0iyBDA
         FJFsLYRmi/83w4w4/spMdaSYNMbY8Ha3oXEHEp563TqEyteDsiaOfJPtCEliSQb2oHDh
         6raA==
X-Gm-Message-State: AOAM533oTbQMfFUhIawnK5jQGSqbCWyKq/YZLdj7KpVYIZjkW9IpgFkQ
        tvNE4c9VHD9pKM4vYRgZ//E5dQ5dcm9uf58gzgZKTMAoc81APO0cv38HZs6fN0ayle95rIHRGE8
        XQmhN5vBjBX2l
X-Received: by 2002:a17:907:c1d:b0:6db:67b:a3cc with SMTP id ga29-20020a1709070c1d00b006db067ba3ccmr17367035ejc.356.1647251363743;
        Mon, 14 Mar 2022 02:49:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8XHRIBgxXPq9yuV4Zo8Oa/8PE8SgnLhzo7XF10frHWF8SB4Um9lqhRn7Wcev+klD4VA+Meg==
X-Received: by 2002:a17:907:c1d:b0:6db:67b:a3cc with SMTP id ga29-20020a1709070c1d00b006db067ba3ccmr17367010ejc.356.1647251363455;
        Mon, 14 Mar 2022 02:49:23 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z7-20020a05640240c700b00416cee953dasm5471936edb.24.2022.03.14.02.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 02:49:22 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 000/105] KVM: selftests: Overhaul APIs, purge VCPU_ID
In-Reply-To: <20220311055056.57265-1-seanjc@google.com>
References: <20220311055056.57265-1-seanjc@google.com>
Date:   Mon, 14 Mar 2022 10:49:21 +0100
Message-ID: <87ilsg984e.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> First off, hopefully I didn't just spam you with 106 emails.  In theory,
> unless you're subscribed to LKML, you should see only the cover letter
> and everything else should be on lore if you want to pull down the mbox
> (instead of saying "LOL, 105 patches!?!?", or maybe after you say
> that).

I would not complain at all if next time you cc kvm@ mailing list on all
patches too, it would simplify my routine a bit (or just Cc: me if
others object).

>
> This is a (very) early RFC for overhauling KVM's selftests APIs.  It's
> compile tested only (maybe), there are no changelogs, etc...
>
> My end goal with an overhaul is to get to a state where adding new
> features and writing tests is less painful/disgusting (I feel dirty every
> time I copy+paste VCPU_ID).  I opted to directly send only the cover
> letter because most of the individual patches aren't all that interesting,
> there's still 46 patches even if the per-test conversions are omitted, and
> it's the final state that I really care about and want to discuss.
>
> The overarching theme of my take on where to go with selftests is to stop
> treating tests like second class citizens.  Stop hiding vcpu, kvm_vm, etc...
> There's no sensitive data/constructs, and the encapsulation has led to
> really, really bad and difficult to maintain code.  E.g. Want to call a
> vCPU ioctl()?  Hope you have the VM...

Initially, there was an attempt to make some sort of separation between
'internal' and 'external' APIs in KVM selftests but every new selftest I
write proves this separation wrong and I have to either hack-around
something or export some previously-internal APIs. My suggestion would
be to eliminate this separation and just make everything available to
tests.

Another thing is TEST_ASSERT()s inside library routines. Generally,
these are helpful as one doesn't need to check the return value. In some
cases, however, we'd like to check that something fails and then the
usual way seems to be creating a pair of functions like:

int __do_something()
{
   int r = try_doing_something();

   return r;
}

void do_something()
{
    int r = __do_something() 
    TEST_ASSERT(r == 0, "Doing something failed! %d", r);
}

This works but maybe there's a better way? 

FWIW, I've looked at some of the tests which are more familiar to me
(evmcs_test, hyperv_features, ...) and the end result looks much better
indeed, thanks! I have a couple more new tests in the queue (Hyper-V IPI
and TLB flush, see "KVM: x86: hyper-v: Fine-grained TLB flush + Direct
TLB flush feature"), we'll have to syncronize one way or another.

>
> The other theme in the rework is to deduplicate code and try to set us
> up for success in the future.  E.g. provide macros/helpers instead of
> spamming CTRL-C => CTRL-V (see the -700 LoC).

You'll have to check with test authors that none of them get paid for
LoC by their respective employers :-)

>
> I was hoping to get this into a less shabby state before posting, but I'm
> I'm going to be OOO for the next few weeks and want to get the ball rolling
> instead of waiting another month or so.
>
> Based on an older version of kvm/queue.  The full thing is also on github:
>
>   https://github.com/sean-jc/linux.git x86/selftests_overhaul
>
> Cc: kvm@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Oliver Upton <oupton@google.com>
>
> Sean Christopherson (105):
>   KVM: selftests: Fix buggy check in test_v3_new_redist_regions()
>   KVM: selftests: Always open VM file descriptors with O_RDWR
>   KVM: selftest: Add another underscore to inner ioctl helpers
>   KVM: selftests: Make vcpu_ioctl() a wrapper to pretty print ioctl name
>   KVM: selftests: Drop @mode from common vm_create() helper
>   KVM: selftests: Split vcpu_set_nested_state() into two helpers
>   KVM: selftests: Add hyperv_svm_test test binary to .gitignore
>   KVM: sefltests: Use vcpu_ioctl() and __vcpu_ioctl() helpers
>   KVM: selftests: Add __vcpu_run() helper
>   KVM: selftests: Use vcpu_access_device_attr() in arm64 code
>   KVM: selftests: Remove vcpu_get_fd()
>   KVM: selftests: Add vcpu_get() to retrieve and assert on vCPU
>     existence
>   KVM: selftests: Make vm_ioctl() a wrapper to pretty print ioctl name
>   KVM: sefltests: Use vm_ioctl() and __vm_ioctl() helpers
>   KVM: selftests: Make kvm_ioctl() a wrapper to pretty print ioctl name
>   KVM: selftests: Use kvm_ioctl() helpers
>   KVM: selftests: Make x86-64's register dump helpers static
>   KVM: selftests: Get rid of kvm_util_internal.h
>   KVM: selftests: Use KVM_IOCTL_ERROR() for one-off arm64 ioctls
>   KVM: selftests: Drop @test param from kvm_create_device()
>   KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to separate helper
>   KVM: selftests: Multiplex return code and fd in __kvm_create_device()
>   KVM: selftests: Rename KVM_HAS_DEVICE_ATTR helpers for consistency
>   KVM: selftests: Drop 'int' return from asserting *_device_has_attr()
>   KVM: selftests: Split get/set device_attr helpers
>   KVM: selftests: Add a VM backpointer to 'struct vcpu'
>   KVM: selftests: Add vm_create_*() variants to expose/return 'struct
>     vcpu'
>   KVM: selftests: Rename vcpu.state => vcpu.run
>   KVM: selftests: Rename 'struct vcpu' to 'struct kvm_vcpu'
>   KVM: selftests: Return the created vCPU from vm_vcpu_add()
>   KVM: selftests: Convert memslot_perf_test away from VCPU_ID
>   KVM: selftests: Convert rseq_test away from VCPU_ID
>   KVM: selftests: Convert xss_msr_test away from VCPU_ID
>   KVM: selftests: Convert vmx_preemption_timer_test away from VCPU_ID
>   KVM: selftests: Convert vmx_pmu_msrs_test away from VCPU_ID
>   KVM: selftests: Convert vmx_set_nested_state_test away from VCPU_ID
>   KVM: selftests: Convert vmx_tsc_adjust_test away from VCPU_ID
>   KVM: selftests: Convert mmu_role_test away from VCPU_ID
>   KVM: selftests: Convert pmu_event_filter_test away from VCPU_ID
>   KVM: selftests: Convert smm_test away from VCPU_ID
>   KVM: selftests: Convert state_test away from VCPU_ID
>   KVM: selftests: Convert svm_int_ctl_test away from VCPU_ID
>   KVM: selftests: Convert svm_vmcall_test away from VCPU_ID
>   KVM: selftests: Convert sync_regs_test away from VCPU_ID
>   KVM: selftests: Convert hyperv_cpuid away from VCPU_ID
>   KVM: selftests: Convert kvm_pv_test away from VCPU_ID
>   KVM: selftests: Convert platform_info_test away from VCPU_ID
>   KVM: selftests: Convert vmx_nested_tsc_scaling_test away from VCPU_ID
>   KVM: selftests: Convert set_sregs_test away from VCPU_ID
>   KVM: selftests: Convert vmx_dirty_log_test away from VCPU_ID
>   KVM: selftests: Convert vmx_close_while_nested_test away from VCPU_ID
>   KVM: selftests: Convert vmx_apic_access_test away from VCPU_ID
>   KVM: selftests: Convert userspace_msr_exit_test away from VCPU_ID
>   KVM: selftests: Convert vmx_exception_with_invalid_guest_state away
>     from VCPU_ID
>   KVM: selftests: Convert tsc_msrs_test away from VCPU_ID
>   KVM: selftests: Convert kvm_clock_test away from VCPU_ID
>   KVM: selftests: Convert hyperv_svm_test away from VCPU_ID
>   KVM: selftests: Convert hyperv_features away from VCPU_ID
>   KVM: selftests: Convert hyperv_clock away from VCPU_ID
>   KVM: selftests: Convert evmcs_test away from VCPU_ID
>   KVM: selftests: Convert emulator_error_test away from VCPU_ID
>   KVM: selftests: Convert debug_regs away from VCPU_ID
>   KVM: selftests: Add proper helper for advancing RIP in debug_regs
>   KVM: selftests: Convert amx_test away from VCPU_ID
>   KVM: selftests: Convert cr4_cpuid_sync_test away from VCPU_ID
>   KVM: selftests: Convert cpuid_test away from VCPU_ID
>   KVM: selftests: Convert userspace_io_test away from VCPU_ID
>   KVM: selftests: Convert vmx_invalid_nested_guest_state away from
>     VCPU_ID
>   KVM: selftests: Convert xen_vmcall_test away from VCPU_ID
>   KVM: selftests: Convert xen_shinfo_test away from VCPU_ID
>   KVM: selftests: Convert dirty_log_test away from VCPU_ID
>   KVM: selftests: Convert set_memory_region_test away from VCPU_ID
>   KVM: selftests: Convert system_counter_offset_test away from VCPU_ID
>   KVM: selftests: Convert debug-exceptions away from VCPU_ID
>   KVM: selftests: Convert vgic_irq.c include/aarch64/vgic.h
>     lib/aarch64/vgic away from VCPU_ID
>   KVM: selftests: Make arm64's guest_get_vcpuid() declaration arm64-only
>   KVM: selftests: Move vm_is_unrestricted_guest() to x86-64
>   KVM: selftests: Add "arch" to common utils that have arch
>     implementations
>   KVM: selftests: Return created vcpu from vm_vcpu_add_default()
>   KVM: selftests: Rename vm_vcpu_add* helpers to better show
>     relationships
>   KVM: selftests: Convert set_boot_cpu_id away from VCPU_ID
>   KVM: selftests: Convert psci_cpu_on_test away from VCPU_ID
>   KVM: selftests: Convert hardware_disable_test away from VCPU_ID
>   KVM: selftests: Add VM creation helper that "returns" vCPUs
>   KVM: selftests: Convert steal_time away from VCPU_ID
>   KVM: selftests: Convert arch_timer away from VCPU_ID
>   KVM: selftests: Fix typo in vgic_init test
>   KVM: selftests: Convert vgic_init away from
>     vm_create_default_with_vcpus()
>   KVM: selftests: Convert xapic_ipi_test away from *_VCPU_ID
>   KVM: selftests: Convert sync_regs_test away from VCPU_ID
>   KVM: selftests: Convert resets away from VCPU_ID
>   KVM: selftests: Convert memop away from VCPU_ID
>   KVM: selftests: Convert s390x/diag318_test_handler away from VCPU_ID
>   KVM: selftests: Drop vm_create_default* helpers
>   KVM: selftests: Drop vcpuids param from VM creators
>   KVM: selftests: Convert kvm_page_table_test away from reliance on
>     vcpu_id
>   KVM: selftests: Convert kvm_binary_stats_test away from VCPU_ID
>   KVM: selftests: Convert get-reg-list away from VCPU_ID
>   KVM: selftests: Stop conflating vCPU index and ID in perf tests
>   KVM: selftests: Remove vcpu_get() usage from dirty_log_test
>   KVM: selftests: Require vCPU output array when creating VM with vCPUs
>   KVM: selftest: Purge vm+vcpu_id == vcpu silliness
>   KVM: selftests: Drop vcpu_get(), rename vcpu_find() => vcpu_exists()
>   KVM: selftests: Remove vcpu_state() helper
>   KVM: selftests: Open code and drop kvm_vm accessors
>
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  .../selftests/kvm/aarch64/arch_timer.c        |  68 +-
>  .../selftests/kvm/aarch64/debug-exceptions.c  |  17 +-
>  .../selftests/kvm/aarch64/get-reg-list.c      |  19 +-
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c  |  22 +-
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 369 +++----
>  .../testing/selftests/kvm/aarch64/vgic_irq.c  |  30 +-
>  .../selftests/kvm/access_tracking_perf_test.c |  81 +-
>  .../selftests/kvm/demand_paging_test.c        |  39 +-
>  .../selftests/kvm/dirty_log_perf_test.c       |  42 +-
>  tools/testing/selftests/kvm/dirty_log_test.c  |  80 +-
>  .../selftests/kvm/hardware_disable_test.c     |  27 +-
>  .../selftests/kvm/include/aarch64/processor.h |  20 +-
>  .../selftests/kvm/include/aarch64/vgic.h      |   6 +-
>  .../selftests/kvm/include/kvm_util_base.h     | 677 ++++++++----
>  .../selftests/kvm/include/perf_test_util.h    |   5 +-
>  .../selftests/kvm/include/riscv/processor.h   |   8 +-
>  .../selftests/kvm/include/ucall_common.h      |   2 +-
>  .../selftests/kvm/include/x86_64/evmcs.h      |   2 +-
>  .../selftests/kvm/include/x86_64/processor.h  |  52 +-
>  .../selftests/kvm/kvm_binary_stats_test.c     |  27 +-
>  .../selftests/kvm/kvm_create_max_vcpus.c      |   4 +-
>  .../selftests/kvm/kvm_page_table_test.c       |  66 +-
>  .../selftests/kvm/lib/aarch64/processor.c     |  79 +-
>  .../testing/selftests/kvm/lib/aarch64/ucall.c |   9 +-
>  .../testing/selftests/kvm/lib/aarch64/vgic.c  |  44 +-
>  tools/testing/selftests/kvm/lib/elf.c         |   1 -
>  tools/testing/selftests/kvm/lib/guest_modes.c |   6 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 981 +++---------------
>  .../selftests/kvm/lib/kvm_util_internal.h     | 128 ---
>  .../selftests/kvm/lib/perf_test_util.c        |  84 +-
>  .../selftests/kvm/lib/riscv/processor.c       | 110 +-
>  tools/testing/selftests/kvm/lib/riscv/ucall.c |   7 +-
>  .../kvm/lib/s390x/diag318_test_handler.c      |   9 +-
>  .../selftests/kvm/lib/s390x/processor.c       |  44 +-
>  tools/testing/selftests/kvm/lib/s390x/ucall.c |   8 +-
>  .../selftests/kvm/lib/x86_64/processor.c      | 311 ++----
>  tools/testing/selftests/kvm/lib/x86_64/svm.c  |   1 -
>  .../testing/selftests/kvm/lib/x86_64/ucall.c  |  10 +-
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   5 +-
>  .../kvm/memslot_modification_stress_test.c    |  13 +-
>  .../testing/selftests/kvm/memslot_perf_test.c |  28 +-
>  tools/testing/selftests/kvm/rseq_test.c       |   9 +-
>  tools/testing/selftests/kvm/s390x/memop.c     |  31 +-
>  tools/testing/selftests/kvm/s390x/resets.c    | 137 +--
>  .../selftests/kvm/s390x/sync_regs_test.c      |  37 +-
>  .../selftests/kvm/set_memory_region_test.c    |  45 +-
>  tools/testing/selftests/kvm/steal_time.c      | 120 +--
>  .../kvm/system_counter_offset_test.c          |  29 +-
>  tools/testing/selftests/kvm/x86_64/amx_test.c |  33 +-
>  .../testing/selftests/kvm/x86_64/cpuid_test.c |  29 +-
>  .../kvm/x86_64/cr4_cpuid_sync_test.c          |  17 +-
>  .../testing/selftests/kvm/x86_64/debug_regs.c |  72 +-
>  .../kvm/x86_64/emulator_error_test.c          |  65 +-
>  .../testing/selftests/kvm/x86_64/evmcs_test.c |  51 +-
>  .../kvm/x86_64/get_msr_index_features.c       |  16 +-
>  .../selftests/kvm/x86_64/hyperv_clock.c       |  25 +-
>  .../selftests/kvm/x86_64/hyperv_cpuid.c       |  25 +-
>  .../selftests/kvm/x86_64/hyperv_features.c    |  51 +-
>  .../selftests/kvm/x86_64/hyperv_svm_test.c    |  14 +-
>  .../selftests/kvm/x86_64/kvm_clock_test.c     |  23 +-
>  .../selftests/kvm/x86_64/kvm_pv_test.c        |  25 +-
>  .../selftests/kvm/x86_64/mmio_warning_test.c  |   6 +-
>  .../selftests/kvm/x86_64/mmu_role_test.c      |  20 +-
>  .../selftests/kvm/x86_64/platform_info_test.c |  34 +-
>  .../kvm/x86_64/pmu_event_filter_test.c        |  60 +-
>  .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  87 +-
>  .../selftests/kvm/x86_64/set_sregs_test.c     |  47 +-
>  .../selftests/kvm/x86_64/sev_migrate_tests.c  |  17 +-
>  tools/testing/selftests/kvm/x86_64/smm_test.c |  37 +-
>  .../testing/selftests/kvm/x86_64/state_test.c |  29 +-
>  .../selftests/kvm/x86_64/svm_int_ctl_test.c   |  21 +-
>  .../selftests/kvm/x86_64/svm_vmcall_test.c    |  16 +-
>  .../selftests/kvm/x86_64/sync_regs_test.c     |  52 +-
>  .../selftests/kvm/x86_64/tsc_msrs_test.c      |  35 +-
>  .../selftests/kvm/x86_64/userspace_io_test.c  |  18 +-
>  .../kvm/x86_64/userspace_msr_exit_test.c      | 165 ++-
>  .../kvm/x86_64/vmx_apic_access_test.c         |  18 +-
>  .../kvm/x86_64/vmx_close_while_nested_test.c  |  17 +-
>  .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  13 +-
>  .../vmx_exception_with_invalid_guest_state.c  |  62 +-
>  .../x86_64/vmx_invalid_nested_guest_state.c   |  18 +-
>  .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |  19 +-
>  .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c  |  25 +-
>  .../kvm/x86_64/vmx_preemption_timer_test.c    |  30 +-
>  .../kvm/x86_64/vmx_set_nested_state_test.c    |  86 +-
>  .../kvm/x86_64/vmx_tsc_adjust_test.c          |  12 +-
>  .../selftests/kvm/x86_64/xapic_ipi_test.c     |  48 +-
>  .../selftests/kvm/x86_64/xen_shinfo_test.c    |  35 +-
>  .../selftests/kvm/x86_64/xen_vmcall_test.c    |  17 +-
>  .../selftests/kvm/x86_64/xss_msr_test.c       |  10 +-
>  91 files changed, 2363 insertions(+), 3087 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/lib/kvm_util_internal.h
>
>
> base-commit: f6ae04ddb347f526b4620d1053690ecf1f87d77f

-- 
Vitaly


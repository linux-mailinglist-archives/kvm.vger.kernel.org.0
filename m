Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB61502E36
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 19:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245250AbiDORIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 13:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356144AbiDORIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 13:08:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B95708BF0E
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 10:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650042340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GgpOObAAkQxQuZEn5beKYQb7AJUCDdiDbHCZKwURP34=;
        b=ZupQDviPjMqsKEFh+UCdWIYF6xi2IFXs9rwwXxa6+HBzYU6zpXFJGfFXUD1w+/oGNVuX6a
        XqYfBMVSYTy+CTiIUzw6d9dR/ZkoPZy1lxWvFjwFbmAeKYEN9pEDPhD5Xr7h8FffgHvb1E
        g2VGJyFYbAK+Hk518MZftUfgJtJF6bE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-XZr4e23AMTKouXBqbZ0vLg-1; Fri, 15 Apr 2022 13:05:39 -0400
X-MC-Unique: XZr4e23AMTKouXBqbZ0vLg-1
Received: by mail-wm1-f71.google.com with SMTP id b12-20020a05600c4e0c00b003914432b970so1350608wmq.8
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 10:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=GgpOObAAkQxQuZEn5beKYQb7AJUCDdiDbHCZKwURP34=;
        b=nYemizaUfsioN0mHtTpAUZn2xdffsFuaf3xADOSdtycJTp6gDKgC6O45G1yYrr1t9w
         V9b6B5CUWiPUcIoKRhhApJ5ugtg285hhEOAw9XLXqrTgf7QWq02oDRnAubiXAvA/RoBX
         Z5Y3f6y7uvxlzAxw6bNbe0Nh4FzHZYHgjntGWaMBw608/5Iy7iOG115YcILu+O1FUQns
         akcfVH6tre1ocRngpTCse8H17CH3b5KpzwGgtc1rvvhF+5JYPk38M4TtUen5dOa6Rfna
         BXLKNn0sMWd1p4L6N4BdObE/6pjG/4N/Q8xSUNkOfakWk58GGGMm78+OEYi8Z1u13D72
         ohtA==
X-Gm-Message-State: AOAM533bdAFBP6yHyVr06n3wByJ6KyQzRSNXUK4EKvl9J37FAOfqp/k5
        C6uYQj5Iyxr03+mb2sXZIHPxJEfXdgoxBxn/msk31n/xUQ685ic8iywc1y/gJyykv1CsXpIY6uk
        pdPOeTvMiDBO6
X-Received: by 2002:a7b:c341:0:b0:37b:c619:c9f4 with SMTP id l1-20020a7bc341000000b0037bc619c9f4mr4118820wmj.38.1650042336777;
        Fri, 15 Apr 2022 10:05:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWHAs8Cn41z5Kkclb2/88stXqdjOzFUKdOa6ZD806AyWa8rEFyAT1tnUHojxnV5dM2s40mKQ==
X-Received: by 2002:a7b:c341:0:b0:37b:c619:c9f4 with SMTP id l1-20020a7bc341000000b0037bc619c9f4mr4118787wmj.38.1650042336199;
        Fri, 15 Apr 2022 10:05:36 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id l28-20020a05600c1d1c00b0038ece66f1b0sm5890931wms.8.2022.04.15.10.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 10:05:35 -0700 (PDT)
Message-ID: <a4e06dad-499e-b0a7-f005-7f9800ed6b94@redhat.com>
Date:   Fri, 15 Apr 2022 19:05:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 000/104] KVM TDX basic feature support
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Eduardo Lima <elima@redhat.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <4a508ded-8554-2e54-8b61-50481e536854@redhat.com>
In-Reply-To: <4a508ded-8554-2e54-8b61-50481e536854@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/15/22 17:18, Paolo Bonzini wrote:
> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Hi.  Now TDX host kernel patch series was posted, I've rebased this patch
>> series to it and make it work.
>>
>>    https://lore.kernel.org/lkml/cover.1646007267.git.kai.huang@intel.com/
>>
>> Changes from v4:
>> - rebased to TDX host kernel patch series.
>> - include all the patches to make this patch series working.
>> - add [MARKER] patches to mark the patch layer clear.
> 
> I think I have reviewed everything except the TDP MMU parts (48, 54-57). 
>   I will do those next week, but in the meanwhile feel free to send v6 
> if you have it ready.  A lot of the requests have been cosmetic.
> 
> If you would like to use something like Trello to track all the changes, 
> and submit before you have done all of them, that's fine by me.

Also, I have now pushed what (I think) should be all that's needed to 
run TDX guests at branch kvm-tdx-5.17 of 
https://git.kernel.org/pub/scm/virt/kvm/kvm.git.  It's only 
compile-tested for now, but if I missed something please report so that 
it can be used by people doing other work (including QEMU, TDVF and guest).

Thanks,

Paolo

> Paolo
> 
>> Thanks,
>>
>>
>> * What's TDX?
>> TDX stands for Trust Domain Extensions, which extends Intel Virtual 
>> Machines
>> Extensions (VMX) to introduce a kind of virtual machine guest called a 
>> Trust
>> Domain (TD) for confidential computing.
>>
>> A TD runs in a CPU mode that is designed to protect the 
>> confidentiality of its
>> memory contents and its CPU state from any other software, including 
>> the hosting
>> Virtual Machine Monitor (VMM), unless explicitly shared by the TD itself.
>>
>> We have more detailed explanations below (***).
>> We have the high-level design of TDX KVM below (****).
>>
>> In this patch series, we use "TD" or "guest TD" to differentiate it 
>> from the
>> current "VM" (Virtual Machine), which is supported by KVM today.
>>
>>
>> * The organization of this patch series
>> This patch series is on top of the patches series "TDX host kernel 
>> support":
>> https://lore.kernel.org/lkml/cover.1646007267.git.kai.huang@intel.com/
>>
>> this patch series is available at
>> https://github.com/intel/tdx/releases/tag/kvm-upstream
>> The corresponding patches to qemu are available at
>> https://github.com/intel/qemu-tdx/commits/tdx-upstream
>>
>> The relations of the layers are depicted as follows.
>> The arrows below show the order of patch reviews we would like to have.
>>
>> The below layers are chosen so that the device model, for example, 
>> qemu can
>> exercise each layering step by step.  Check if TDX is supported, 
>> create TD VM,
>> create TD vcpu, allow vcpu running, populate TD guest private memory, 
>> and handle
>> vcpu exits/hypercalls/interrupts to run TD fully.
>>
>>    TDX vcpu
>>    interrupt/exits/hypercall<------------\
>>          ^                               |
>>          |                               |
>>    TD finalization                       |
>>          ^                               |
>>          |                               |
>>    TDX EPT violation<------------\       |
>>          ^                       |       |
>>          |                       |       |
>>    TD vcpu enter/exit            |       |
>>          ^                       |       |
>>          |                       |       |
>>    TD vcpu creation/destruction  |       \-------KVM TDP MMU MapGPA
>>          ^                       |                       ^
>>          |                       |                       |
>>    TD VM creation/destruction    \---------------KVM TDP MMU hooks
>>          ^                                               ^
>>          |                                               |
>>    TDX architectural definitions                 KVM TDP refactoring 
>> for TDX
>>          ^                                               ^
>>          |                                               |
>>     TDX, VMX    <--------TDX host kernel         KVM MMU GPA stolen bits
>>     coexistence          support
>>
>>
>> The followings are explanations of each layer.  Each layer has a dummy 
>> commit
>> that starts with [MARKER] in subject.  It is intended to help to 
>> identify where
>> each layer starts.
>>
>> TDX host kernel support:
>>          
>> https://lore.kernel.org/lkml/cover.1646007267.git.kai.huang@intel.com/
>>          The guts of system-wide initialization of TDX module.  There 
>> is an
>>          independent patch series for host x86.  TDX KVM patches call 
>> functions
>>          this patch series provides to initialize the TDX module.
>>
>> TDX, VMX coexistence:
>>          Infrastructure to allow TDX to coexist with VMX and trigger the
>>          initialization of the TDX module.
>>          This layer starts with
>>          "KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX"
>> TDX architectural definitions:
>>          Add TDX architectural definitions and helper functions
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: TDX 
>> architectural definitions".
>> TD VM creation/destruction:
>>          Guest TD creation/destroy allocation and releasing of TDX 
>> specific vm
>>          and vcpu structure.  Create an initial guest memory image 
>> with TDX
>>          measurement.
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: TD VM 
>> creation/destruction".
>> TD vcpu creation/destruction:
>>          guest TD creation/destroy Allocation and releasing of TDX 
>> specific vm
>>          and vcpu structure.  Create an initial guest memory image 
>> with TDX
>>          measurement.
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: TD vcpu 
>> creation/destruction"
>> TDX EPT violation:
>>          Create an initial guest memory image with TDX measurement.  
>> Handle
>>          secure EPT violations to populate guest pages with TDX 
>> SEAMCALLs.
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: TDX EPT violation"
>> TD vcpu enter/exit:
>>          Allow TDX vcpu to enter into TD and exit from TD.  Save CPU 
>> state before
>>          entering into TD.  Restore CPU state after exiting from TD.
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: TD vcpu enter/exit"
>> TD vcpu interrupts/exit/hypercall:
>>          Handle various exits/hypercalls and allow interrupts to be 
>> injected so
>>          that TD vcpu can continue running.
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: TD vcpu 
>> exits/interrupts/hypercalls"
>>
>> KVM MMU GPA stolen bits:
>>          Introduce framework to handle stolen repurposed bit of GPA TDX
>>          repurposed a bit of GPA to indicate shared or private. If 
>> it's shared,
>>          it's the same as the conventional VMX EPT case.  VMM can 
>> access shared
>>          guest pages.  If it's private, it's handled by Secure-EPT and 
>> the guest
>>          page is encrypted.
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: KVM MMU GPA 
>> stolen bits"
>> KVM TDP refactoring for TDX:
>>          TDX Secure EPT requires different constants. e.g. initial 
>> value EPT
>>          entry value etc. Various refactoring for those differences.
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: KVM TDP 
>> refactoring for TDX"
>> KVM TDP MMU hooks:
>>          Introduce framework to TDP MMU to add hooks in addition to 
>> direct EPT
>>          access TDX added Secure EPT which is an enhancement to VMX 
>> EPT.  Unlike
>>          conventional VMX EPT, CPU can't directly read/write Secure 
>> EPT. Instead,
>>          use TDX SEAMCALLs to operate on Secure EPT.
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks"
>> KVM TDP MMU MapGPA:
>>          Introduce framework to handle switching guest pages from 
>> private/shared
>>          to shared/private.  For a given GPA, a guest page can be 
>> assigned to a
>>          private GPA or a shared GPA exclusively.  With TDX MapGPA 
>> hypercall,
>>          guest TD converts GPA assignments from private (or shared) to 
>> shared (or
>>          private).
>>          This layer starts with
>>          "[MARKER] The start of TDX KVM patch series: KVM TDP MMU 
>> MapGPA "
>>
>> KVM guest private memory: (not shown in the above diagram)
>> [PATCH v4 00/12] KVM: mm: fd-based approach for supporting KVM guest 
>> private
>> memory: https://lkml.org/lkml/2022/1/18/395
>>          Guest private memory requires different memory management in 
>> KVM.  The
>>          patch proposes a way for it.  Integration with TDX KVM.
>>
>> (***)
>> * TDX module
>> A CPU-attested software module called the "TDX module" is designed to 
>> implement
>> the TDX architecture, and it is loaded by the UEFI firmware today. It 
>> can be
>> loaded by the kernel or driver at runtime, but in this patch series we 
>> assume
>> that the TDX module is already loaded and initialized.
>>
>> The TDX module provides two main new logical modes of operation built 
>> upon the
>> new SEAM (Secure Arbitration Mode) root and non-root CPU modes added 
>> to the VMX
>> architecture. TDX root mode is mostly identical to the VMX root 
>> operation mode,
>> and the TDX functions (described later) are triggered by the new SEAMCALL
>> instruction with the desired interface function selected by an input 
>> operand
>> (leaf number, in RAX). TDX non-root mode is used for TD guest 
>> operation.  TDX
>> non-root operation (i.e. "guest TD" mode) is similar to the VMX non-root
>> operation (i.e. guest VM), with changes and restrictions to better 
>> assure that
>> no other software or hardware has direct visibility of the TD memory 
>> and state.
>>
>> TDX transitions between TDX root operation and TDX non-root operation 
>> include TD
>> Entries, from TDX root to TDX non-root mode, and TD Exits from TDX 
>> non-root to
>> TDX root mode.  A TD Exit might be asynchronous, triggered by some 
>> external
>> event (e.g., external interrupt or SMI) or an exception, or it might be
>> synchronous, triggered by a TDCALL (TDG.VP.VMCALL) function.
>>
>> TD VCPUs can be entered using SEAMCALL(TDH.VP.ENTER) by KVM. 
>> TDH.VP.ENTER is one
>> of the TDX interface functions as mentioned above, and "TDH" stands 
>> for Trust
>> Domain Host. Those host-side TDX interface functions are categorized into
>> various areas just for better organization, such as SYS (TDX module 
>> management),
>> MNG (TD management), VP (VCPU), PHYSMEM (physical memory), MEM 
>> (private memory),
>> etc. For example, SEAMCALL(TDH.SYS.INFO) returns the TDX module 
>> information.
>>
>> TDCS (Trust Domain Control Structure) is the main control structure of 
>> a guest
>> TD, and encrypted (using the guest TD's ephemeral private key).  At a 
>> high
>> level, TDCS holds information for controlling TD operation as a whole,
>> execution, EPTP, MSR bitmaps, etc that KVM needs to set it up.  Note 
>> that MSR
>> bitmaps are held as part of TDCS (unlike VMX) because they are meant 
>> to have the
>> same value for all VCPUs of the same TD.
>>
>> Trust Domain Virtual Processor State (TDVPS) is the root control 
>> structure of a
>> TD VCPU.  It helps the TDX module control the operation of the VCPU, 
>> and holds
>> the VCPU state while the VCPU is not running. TDVPS is opaque to 
>> software and
>> DMA access, accessible only by using the TDX module interface 
>> functions (such as
>> TDH.VP.RD, TDH.VP.WR). TDVPS includes TD VMCS, and TD VMCS auxiliary 
>> structures,
>> such as virtual APIC page, virtualization exception information, etc.
>>
>> Several VMX control structures (such as Shared EPT and Posted interrupt
>> descriptor) are directly managed and accessed by the host VMM.  These 
>> control
>> structures are pointed to by fields in the TD VMCS.
>>
>> The above means that 1) KVM needs to allocate different data 
>> structures for TDs,
>> 2) KVM can reuse the existing code for TDs for some operations, 3) it 
>> needs to
>> define TD-specific handling for others.  3) Redirect operations to .  3)
>> Redirect operations to the TDX specific callbacks, like "if 
>> (is_td_vcpu(vcpu))
>> tdx_callback() else vmx_callback();".
>>
>> *TD Private Memory
>> TD private memory is designed to hold TD private content, encrypted by 
>> the CPU
>> using the TD ephemeral key. An encryption engine holds a table of 
>> encryption
>> keys, and an encryption key is selected for each memory transaction 
>> based on a
>> Host Key Identifier (HKID). By design, the host VMM does not have 
>> access to the
>> encryption keys.
>>
>> In the first generation of MKTME, HKID is "stolen" from the physical 
>> address by
>> allocating a configurable number of bits from the top of the physical
>> address. The HKID space is partitioned into shared HKIDs for legacy MKTME
>> accesses and private HKIDs for SEAM-mode-only accesses. We use 0 for 
>> the shared
>> HKID on the host so that MKTME can be opaque or bypassed on the host.
>>
>> During TDX non-root operation (i.e. guest TD), memory accesses can be 
>> qualified
>> as either shared or private, based on the value of a new SHARED bit in 
>> the Guest
>> Physical Address (GPA).  The CPU translates shared GPAs using the 
>> usual VMX EPT
>> (Extended Page Table) or "Shared EPT" (in this document), which 
>> resides in host
>> VMM memory. The Shared EPT is directly managed by the host VMM - the 
>> same as
>> with the current VMX. Since guest TDs usually require I/O, and the 
>> data exchange
>> needs to be done via shared memory, thus KVM needs to use the current EPT
>> functionality even for TDs.
>>
>> * Secure EPT and Minoring using the TDP code
>> The CPU translates private GPAs using a separate Secure EPT.  The 
>> Secure EPT
>> pages are encrypted and integrity-protected with the TD's ephemeral 
>> private
>> key.  Secure EPT can be managed _indirectly_ by the host VMM, using 
>> the TDX
>> interface functions, and thus conceptually Secure EPT is a subset of 
>> EPT (why
>> "subset"). Since execution of such interface functions takes much 
>> longer time
>> than accessing memory directly, in KVM we use the existing TDP code to 
>> minor the
>> Secure EPT for the TD.
>>
>> This way, we can effectively walk Secure EPT without using the TDX 
>> interface
>> functions.
>>
>> * VM life cycle and TDX specific operations
>> The userspace VMM, such as QEMU, needs to build and treat TDs 
>> differently.  For
>> example, a TD needs to boot in private memory, and the host software 
>> cannot copy
>> the initial image to private memory.
>>
>> * TSC Virtualization
>> The TDX module helps TDs maintain reliable TSC (Time Stamp Counter) 
>> values
>> (e.g. consistent among the TD VCPUs) and the virtual TSC frequency is 
>> determined
>> by TD configuration, i.e. when the TD is created, not per VCPU.  The 
>> current KVM
>> owns TSC virtualization for VMs, but the TDX module does for TDs.
>>
>> * MCE support for TDs
>> The TDX module doesn't allow VMM to inject MCE.  Instead PV way is 
>> needed for TD
>> to communicate with VMM.  For now, KVM silently ignores MCE request by 
>> VMM.  MSRs
>> related to MCE (e.g, MCE bank registers) can be naturally emulated by
>> paravirtualizing MSR access.
>>
>> [1] For details, the specifications, [2], [3], [4], [5], [6], [7], are
>> available.
>>
>> * Restrictions or future work
>> Some features are not included to reduce patch size.  Those features are
>> addressed as future independent patch series.
>> - large page (2M, 1G)
>> - qemu gdb stub
>> - guest PMU
>> - and more
>>
>> * Prerequisites
>> It's required to load the TDX module and initialize it.  It's out of 
>> the scope
>> of this patch series.  Another independent patch for the common x86 
>> code is
>> planned.  It defines CONFIG_INTEL_TDX_HOST and this patch series uses
>> CONFIG_INTEL_TDX_HOST.  It's assumed that With 
>> CONFIG_INTEL_TDX_HOST=y, the TDX
>> module is initialized and ready for KVM to use the TDX module APIs for 
>> TDX guest
>> life cycle like tdh.mng.init are ready to use.
>>
>> Concretely Global initialization, LP (Logical Processor) 
>> initialization, global
>> configuration, the key configuration, and TDMR and PAMT initialization 
>> are done.
>> The state of the TDX module is SYS_READY.  Please refer to the TDX module
>> specification, the chapter Intel TDX Module Lifecycle State Machine
>>
>> ** Detecting the TDX module readiness.
>> TDX host patch series implements the detection of the TDX module 
>> availability
>> and its initialization so that KVM can use it.  Also it manages Host 
>> KeyID
>> (HKID) assigned to guest TD.
>> The assumed APIs the TDX host patch series provides are
>> - int seamrr_enabled()
>>    Check if required cpu feature (SEAM mode) is available. This only 
>> check CPU
>>    feature availability.  At this point, the TDX module may not be 
>> ready for KVM
>>    to use.
>> - int init_tdx(void);
>>    Initialization of TDX module so that the TDX module is ready for 
>> KVM to use.
>> - const struct tdsysinfo_struct *tdx_get_sysinfo(void);
>>    Return the system wide information about the TDX module.  NULL if 
>> the TDX
>>    isn't initialized.
>> - u32 tdx_get_global_keyid(void);
>>    Return global key id that is used for the TDX module itself.
>> - int tdx_keyid_alloc(void);
>>    Allocate HKID for guest TD.
>> - void tdx_keyid_free(int keyid);
>>    Free HKID for guest TD.
>>
>> (****)
>> * TDX KVM high-level design
>> - Host key ID management
>> Host Key ID (HKID) needs to be assigned to each TDX guest for memory 
>> encryption.
>> It is assumed The TDX host patch series implements necessary functions,
>> u32 tdx_get_global_keyid(void), int tdx_keyid_alloc(void) and,
>> void tdx_keyid_free(int keyid).
>>
>> - Data structures and VM type
>> Because TDX is different from VMX, define its own VM/VCPU structures, 
>> struct
>> kvm_tdx and struct vcpu_tdx instead of struct kvm_vmx and struct 
>> vcpu_vmx.  To
>> identify the VM, introduce VM-type to specify which VM type, VMX 
>> (default) or
>> TDX, is used.
>>
>> - VM life cycle and TDX specific operations
>> Re-purpose the existing KVM_MEMORY_ENCRYPT_OP to add TDX specific 
>> operations.
>> New commands are used to get the TDX system parameters, set TDX 
>> specific VM/VCPU
>> parameters, set initial guest memory and measurement.
>>
>> The creation of TDX VM requires five additional operations in addition 
>> to the
>> conventional VM creation.
>>    - Get KVM system capability to check if TDX VM type is supported
>>    - VM creation (KVM_CREATE_VM)
>>    - New: Get the TDX specific system parameters.  
>> KVM_TDX_GET_CAPABILITY.
>>    - New: Set TDX specific VM parameters.  KVM_TDX_INIT_VM.
>>    - VCPU creation (KVM_CREATE_VCPU)
>>    - New: Set TDX specific VCPU parameters.  KVM_TDX_INIT_VCPU.
>>    - New: Initialize guest memory as boot state and extend the 
>> measurement with
>>      the memory.  KVM_TDX_INIT_MEM_REGION.
>>    - New: Finalize VM. KVM_TDX_FINALIZE. Complete measurement of the 
>> initial
>>      TDX VM contents.
>>    - VCPU RUN (KVM_VCPU_RUN)
>>
>> - Protected guest state
>> Because the guest state (CPU state and guest memory) is protected, the 
>> KVM VMM
>> can't operate on them.  For example, accessing CPU registers, injecting
>> exceptions, and accessing guest memory.  Those operations are handled as
>> silently ignored, returning zero or initial reset value when it's 
>> requested via
>> KVM API ioctls.
>>
>>      VM/VCPU state and callbacks for TDX specific operations.
>>      Define tdx specific VM state and VCPU state instead of VMX ones.  
>> Redirect
>>      operations to TDX specific callbacks.  "if (tdx) tdx_op() else 
>> vmx_op()".
>>
>>      Operations on the CPU state
>>      silently ignore operations on the guest state.  For example, the 
>> write to
>>      CPU registers is ignored and the read from CPU registers returns 0.
>>
>>      . ignore access to CPU registers except for allowed ones.
>>      . TSC: add a check if tsc is immutable and return an error.  
>> Because the KVM
>>        implementation updates the internal tsc state and it's 
>> difficult to back
>>        out those changes.  Instead, skip the logic.
>>      . dirty logging: add check if dirty logging is supported.
>>      . exceptions/SMI/MCE/SIPI/INIT: silently ignore
>>
>>      Note: virtual external interrupt and NMI can be injected into TDX 
>> guests.
>>
>> - KVM MMU integration
>> One bit of the guest physical address (bit 51 or 47) is repurposed to 
>> indicate if
>> the guest physical address is private (the bit is cleared) or shared 
>> (the bit is
>> set).  The bits are called stolen bits.
>>
>>    - Stolen bits framework
>>      systematically tracks which guest physical address, shared or 
>> private, is
>>      used.
>>
>>    - Shared EPT and secure EPT
>>      There are two EPTs. Shared EPT (the conventional one) and Secure
>>      EPT(the new one). Shared EPT is handled the same for the stolen
>>      bit set.  Secure EPT points to private guest pages.  To resolve
>>      EPT violation, KVM walks one of two EPTs based on faulted GPA.
>>      Because it's costly to access secure EPT during walking EPTs with
>>      SEAMCALLs for the private guest physical address, another private
>>      EPT is used as a shadow of Secure-EPT with the existing logic at
>>      the cost of extra memory.
>>
>> The following depicts the relationship.
>>
>>                      KVM                             |       TDX module
>>                       |                              |           |
>>          -------------+----------                    |           |
>>          |                      |                    |           |
>>          V                      V                    |           |
>>       shared GPA           private GPA               |           |
>>    CPU shared EPT pointer  KVM private EPT pointer   |  CPU secure EPT 
>> pointer
>>          |                      |                    |           |
>>          |                      |                    |           |
>>          V                      V                    |           V
>>    shared EPT                private EPT<-------mirror----->Secure EPT
>>          |                      |                    |           |
>>          |                      \--------------------+------\    |
>>          |                                           |      |    |
>>          V                                           |      V    V
>>    shared guest page                                 |    private 
>> guest page
>>                                                      |
>>                                                      |
>>                                non-encrypted memory  |    encrypted 
>> memory
>>                                                      |
>>
>>    - Operating on Secure EPT
>>      Use the TDX module APIs to operate on Secure EPT.  To call the 
>> TDX API
>>      during resolving EPT violation, add hooks to additional operation 
>> and wiring
>>      it to TDX backend.
>>
>> * References
>>
>> [1] TDX specification
>>     
>> https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html 
>>
>> [2] Intel Trust Domain Extensions (Intel TDX)
>>     
>> https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-whitepaper-final9-17.pdf 
>>
>> [3] Intel CPU Architectural Extensions Specification
>>     
>> https://software.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-cpu-architectural-specification.pdf 
>>
>> [4] Intel TDX Module 1.0 EAS
>>     
>> https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1eas-v0.85.039.pdf 
>>
>> [5] Intel TDX Loader Interface Specification
>>    
>> https://software.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-seamldr-interface-specification.pdf 
>>
>> [6] Intel TDX Guest-Hypervisor Communication Interface
>>     
>> https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf 
>>
>> [7] Intel TDX Virtual Firmware Design Guide
>>     
>> https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf 
>>
>> [8] intel public github
>>     kvm TDX branch: https://github.com/intel/tdx/tree/kvm
>>     TDX guest branch: https://github.com/intel/tdx/tree/guest
>>     qemu TDX https://github.com/intel/qemu-tdx
>> [9] TDVF
>>      https://github.com/tianocore/edk2-staging/tree/TDVF
>>
>>
>> Chao Gao (1):
>>    KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o
>>      wrmsr
>>
>> Isaku Yamahata (73):
>>    x86/virt/tdx: export platform_has_tdx
>>    KVM: TDX: Detect CPU feature on kernel module initialization
>>    KVM: x86: Refactor KVM VMX module init/exit functions
>>    KVM: TDX: Add placeholders for TDX VM/vcpu structure
>>    x86/virt/tdx: Add a helper function to return system wide info about
>>      TDX module
>>    KVM: TDX: Add a function to initialize TDX module
>>    KVM: TDX: Make TDX VM type supported
>>    [MARKER] The start of TDX KVM patch series: TDX architectural
>>      definitions
>>    KVM: TDX: Define TDX architectural definitions
>>    KVM: TDX: Add a function for KVM to invoke SEAMCALL
>>    KVM: TDX: add a helper function for KVM to issue SEAMCALL
>>    KVM: TDX: Add helper functions to print TDX SEAMCALL error
>>    [MARKER] The start of TDX KVM patch series: TD VM creation/destruction
>>    KVM: TDX: allocate per-package mutex
>>    x86/cpu: Add helper functions to allocate/free MKTME keyid
>>    KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
>>    KVM: TDX: x86: Add vm ioctl to get TDX systemwide parameters
>>    [MARKER] The start of TDX KVM patch series: TD vcpu
>>      creation/destruction
>>    KVM: TDX: allocate/free TDX vcpu structure
>>    [MARKER] The start of TDX KVM patch series: KVM MMU GPA stolen bits
>>    KVM: x86/mmu: introduce config for PRIVATE KVM MMU
>>    [MARKER] The start of TDX KVM patch series: KVM TDP refactoring for
>>      TDX
>>    KVM: x86/mmu: Disallow fast page fault on private GPA
>>    [MARKER] The start of TDX KVM patch series: KVM TDP MMU hooks
>>    KVM: x86/tdp_mmu: make REMOVED_SPTE include shadow_initial value
>>    KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
>>    KVM: x86/mmu: add a private pointer to struct kvm_mmu_page
>>    KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU
>>    KVM: x86/tdp_mmu: Ignore unsupported mmu operation on private GFNs
>>    [MARKER] The start of TDX KVM patch series: TDX EPT violation
>>    KVM: TDX: TDP MMU TDX support
>>    [MARKER] The start of TDX KVM patch series: KVM TDP MMU MapGPA
>>    KVM: x86/mmu: steal software usable bit for EPT to represent shared
>>      page
>>    KVM: x86/tdp_mmu: Keep PRIVATE_PROHIBIT bit when zapping
>>    KVM: x86/tdp_mmu: prevent private/shared map based on PRIVATE_PROHIBIT
>>    KVM: x86/tdp_mmu: implement MapGPA hypercall for TDX
>>    KVM: x86/mmu: Focibly use TDP MMU for TDX
>>    [MARKER] The start of TDX KVM patch series: TD finalization
>>    KVM: TDX: Create initial guest memory
>>    KVM: TDX: Finalize VM initialization
>>    [MARKER] The start of TDX KVM patch series: TD vcpu enter/exit
>>    KVM: TDX: Add helper assembly function to TDX vcpu
>>    KVM: TDX: Implement TDX vcpu enter/exit path
>>    KVM: TDX: vcpu_run: save/restore host state(host kernel gs)
>>    KVM: TDX: restore host xsave state when exit from the guest TD
>>    KVM: TDX: restore user ret MSRs
>>    [MARKER] The start of TDX KVM patch series: TD vcpu
>>      exits/interrupts/hypercalls
>>    KVM: TDX: complete interrupts after tdexit
>>    KVM: TDX: restore debug store when TD exit
>>    KVM: TDX: handle vcpu migration over logical processor
>>    KVM: TDX: track LP tdx vcpu run and teardown vcpus on descroing the
>>      guest TD
>>    KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched
>>      behavior
>>    KVM: TDX: Implement interrupt injection
>>    KVM: TDX: Implements vcpu request_immediate_exit
>>    KVM: TDX: Implement methods to inject NMI
>>    KVM: TDX: Add a place holder to handle TDX VM exit
>>    KVM: TDX: handle EXIT_REASON_OTHER_SMI
>>    KVM: TDX: handle ept violation/misconfig exit
>>    KVM: TDX: handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
>>    KVM: TDX: Add TDG.VP.VMCALL accessors to access guest vcpu registers
>>    KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL
>>    KVM: TDX: Handle TDX PV CPUID hypercall
>>    KVM: TDX: Handle TDX PV HLT hypercall
>>    KVM: TDX: Handle TDX PV port io hypercall
>>    KVM: TDX: Implement callbacks for MSR operations for TDX
>>    KVM: TDX: Handle TDX PV rdmsr hypercall
>>    KVM: TDX: Handle TDX PV wrmsr hypercall
>>    KVM: TDX: Handle TDX PV report fatal error hypercall
>>    KVM: TDX: Handle TDX PV map_gpa hypercall
>>    KVM: TDX: Silently discard SMI request
>>    KVM: TDX: Silently ignore INIT/SIPI
>>    Documentation/virtual/kvm: Document on Trust Domain Extensions(TDX)
>>    KVM: x86: design documentation on TDX support of x86 KVM TDP MMU
>>
>> Kai Huang (1):
>>    KVM: x86: Introduce hooks to free VM callback prezap and vm_free
>>
>> Rick Edgecombe (1):
>>    KVM: x86: Add infrastructure for stolen GPA bits
>>
>> Sean Christopherson (26):
>>    KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX
>>    KVM: Enable hardware before doing arch VM initialization
>>    KVM: x86: Introduce vm_type to differentiate default VMs from
>>      confidential VMs
>>    KVM: TDX: Add TDX "architectural" error codes
>>    KVM: TDX: Add C wrapper functions for SEAMCALLs to the TDX module
>>    KVM: TDX: Stub in tdx.h with structs, accessors, and VMCS helpers
>>    KVM: Add max_vcpus field in common 'struct kvm'
>>    KVM: TDX: create/destroy VM structure
>>    KVM: TDX: Do TDX specific vcpu initialization
>>    KVM: x86/mmu: Disallow dirty logging for x86 TDX
>>    KVM: x86/mmu: Explicitly check for MMIO spte in fast page fault
>>    KVM: x86/mmu: Allow non-zero init value for shadow PTE
>>    KVM: x86/mmu: Allow per-VM override of the TDP max page level
>>    KVM: VMX: Split out guts of EPT violation to common/exposed function
>>    KVM: VMX: Move setting of EPT MMU masks to common VT-x code
>>    KVM: x86/mmu: Track shadow MMIO value/mask on a per-VM basis
>>    KVM: TDX: Add load_mmu_pgd method for TDX
>>    KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
>>    KVM: x86: Check for pending APICv interrupt in kvm_vcpu_has_events()
>>    KVM: x86: Add option to force LAPIC expiration wait
>>    KVM: VMX: Modify NMI and INTR handlers to take intr_info as function
>>      argument
>>    KVM: VMX: Move NMI/exception handler to common helper
>>    KVM: x86: Split core of hypercall emulation to helper function
>>    KVM: TDX: Add a placeholder for handler of TDX hypercalls
>>      (TDG.VP.VMCALL)
>>    KVM: TDX: Handle TDX PV MMIO hypercall
>>    KVM: TDX: Add methods to ignore accesses to CPU state
>>
>> Xiaoyao Li (1):
>>    KVM: TDX: initialize VM with TDX specific parameters
>>
>> Yuan Yao (1):
>>    KVM: TDX: Use vcpu_to_pi_desc() uniformly in posted_intr.c
>>
>>   Documentation/virt/kvm/api.rst                |   24 +-
>>   .../virt/kvm/intel-tdx-layer-status.rst       |   33 +
>>   Documentation/virt/kvm/intel-tdx.rst          |  360 +++
>>   Documentation/virt/kvm/tdx-tdp-mmu.rst        |  466 ++++
>>   arch/arm64/include/asm/kvm_host.h             |    3 -
>>   arch/arm64/kvm/arm.c                          |    6 +-
>>   arch/arm64/kvm/vgic/vgic-init.c               |    6 +-
>>   arch/x86/events/intel/ds.c                    |    1 +
>>   arch/x86/include/asm/kvm-x86-ops.h            |    5 +
>>   arch/x86/include/asm/kvm_host.h               |   38 +-
>>   arch/x86/include/asm/tdx.h                    |   61 +
>>   arch/x86/include/asm/vmx.h                    |    2 +
>>   arch/x86/include/uapi/asm/kvm.h               |   59 +
>>   arch/x86/include/uapi/asm/vmx.h               |    5 +-
>>   arch/x86/kvm/Kconfig                          |    4 +
>>   arch/x86/kvm/Makefile                         |    3 +-
>>   arch/x86/kvm/lapic.c                          |   25 +-
>>   arch/x86/kvm/lapic.h                          |    2 +-
>>   arch/x86/kvm/mmu.h                            |   65 +-
>>   arch/x86/kvm/mmu/mmu.c                        |  232 +-
>>   arch/x86/kvm/mmu/mmu_internal.h               |   84 +
>>   arch/x86/kvm/mmu/paging_tmpl.h                |   25 +-
>>   arch/x86/kvm/mmu/spte.c                       |   48 +-
>>   arch/x86/kvm/mmu/spte.h                       |   40 +-
>>   arch/x86/kvm/mmu/tdp_iter.h                   |    2 +-
>>   arch/x86/kvm/mmu/tdp_mmu.c                    |  642 ++++-
>>   arch/x86/kvm/mmu/tdp_mmu.h                    |   16 +-
>>   arch/x86/kvm/svm/svm.c                        |   10 +-
>>   arch/x86/kvm/vmx/common.h                     |  155 ++
>>   arch/x86/kvm/vmx/main.c                       | 1026 ++++++++
>>   arch/x86/kvm/vmx/posted_intr.c                |    8 +-
>>   arch/x86/kvm/vmx/seamcall.S                   |   55 +
>>   arch/x86/kvm/vmx/seamcall.h                   |   25 +
>>   arch/x86/kvm/vmx/tdx.c                        | 2337 +++++++++++++++++
>>   arch/x86/kvm/vmx/tdx.h                        |  253 ++
>>   arch/x86/kvm/vmx/tdx_arch.h                   |  158 ++
>>   arch/x86/kvm/vmx/tdx_errno.h                  |   29 +
>>   arch/x86/kvm/vmx/tdx_error.c                  |   22 +
>>   arch/x86/kvm/vmx/tdx_ops.h                    |  174 ++
>>   arch/x86/kvm/vmx/vmenter.S                    |  146 +
>>   arch/x86/kvm/vmx/vmx.c                        |  619 ++---
>>   arch/x86/kvm/vmx/x86_ops.h                    |  235 ++
>>   arch/x86/kvm/x86.c                            |  123 +-
>>   arch/x86/kvm/x86.h                            |    8 +
>>   arch/x86/virt/tdxcall.S                       |    8 +-
>>   arch/x86/virt/vmx/tdx.c                       |   50 +-
>>   arch/x86/virt/vmx/tdx.h                       |   52 -
>>   include/linux/kvm_host.h                      |    2 +
>>   include/uapi/linux/kvm.h                      |    1 +
>>   tools/arch/x86/include/uapi/asm/kvm.h         |   59 +
>>   tools/include/uapi/linux/kvm.h                |    1 +
>>   virt/kvm/kvm_main.c                           |   35 +-
>>   52 files changed, 7142 insertions(+), 706 deletions(-)
>>   create mode 100644 Documentation/virt/kvm/intel-tdx-layer-status.rst
>>   create mode 100644 Documentation/virt/kvm/intel-tdx.rst
>>   create mode 100644 Documentation/virt/kvm/tdx-tdp-mmu.rst
>>   create mode 100644 arch/x86/kvm/vmx/common.h
>>   create mode 100644 arch/x86/kvm/vmx/main.c
>>   create mode 100644 arch/x86/kvm/vmx/seamcall.S
>>   create mode 100644 arch/x86/kvm/vmx/seamcall.h
>>   create mode 100644 arch/x86/kvm/vmx/tdx.c
>>   create mode 100644 arch/x86/kvm/vmx/tdx.h
>>   create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
>>   create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
>>   create mode 100644 arch/x86/kvm/vmx/tdx_error.c
>>   create mode 100644 arch/x86/kvm/vmx/tdx_ops.h
>>   create mode 100644 arch/x86/kvm/vmx/x86_ops.h
>>
> 


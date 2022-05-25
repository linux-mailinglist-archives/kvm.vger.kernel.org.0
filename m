Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B590E533B8F
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 13:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbiEYLQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 07:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238103AbiEYLQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 07:16:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC9FF9D4F9
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 04:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653477361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x35TpqIWxnP9k2RqiW6fvOQFiknbnpud5G23xflyaNY=;
        b=Z3BGRj5jAqSJdlzSHGoEOLteGfCVnXgkDJgGbKIQdv77c0ff3aq9di2Cw8GAscB9pgvyxa
        45jAY7TSz3u4nIuMDmGgl8xaNj6KeHbYPEFToFJ+LH8TAd3apB1UXzB53B8eC+8Ccamwuf
        NQmQxLUHkL9EoruLCZE04nCBCpfqJKA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-caPi7xf4PteZYaM5Z7Cz3w-1; Wed, 25 May 2022 07:16:00 -0400
X-MC-Unique: caPi7xf4PteZYaM5Z7Cz3w-1
Received: by mail-ej1-f72.google.com with SMTP id r13-20020a170906c28d00b006fec5bcd396so4565966ejz.22
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 04:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:references:subject:in-reply-to
         :content-transfer-encoding;
        bh=x35TpqIWxnP9k2RqiW6fvOQFiknbnpud5G23xflyaNY=;
        b=XlZHMS7yq4rN/8lG6fOg8I0Tb1Zn6XpqzXHRhCUj6Jk7lGLgIm0FA6vR/3p6os1Puo
         kFYTmeDGirVCO4D/CVWHjoX0t448V4ncrAmT640mI40UPzlJqNmXkb1CaI49mpNj0m1Q
         D3R3gc35jNpON7UzyA/6IfeGiW7VX9dQCG8S8VeWKpXwvRffb8ahiWRc0jQ6gj5S5Zcm
         244kbJOSPR+nSfDHCNAo9hz3Kr9UYulvmUwmBGzZ+bis2mH1TA42v3CV9itqSUtrDn8x
         nQE32p30+kTFfzwgFIbBPkDNUKWe+vbIM2RHO8DSHhUIz1NCWQuir80LLY3tzkza8qM5
         j4VA==
X-Gm-Message-State: AOAM530gH2peQIwFhYGESbiYzgA3ujUIkZV9wUnciG3E5S0oBXztklQ5
        7NFRaZ04Hvpsm0WIE/Mk4mxKiXAK6/SJq9Cm3j8w+sl+zOxUjmDZSEUnODNIndjAa4zXu7ImRmS
        HcCx1Oa5n0WzKXMzB04rCs6HHO1V6iTBla+OiB5XkJfUJTgbXxT72ii9N1KYwSFim
X-Received: by 2002:aa7:d0d3:0:b0:42b:b1b9:726e with SMTP id u19-20020aa7d0d3000000b0042bb1b9726emr4822002edo.268.1653477358627;
        Wed, 25 May 2022 04:15:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4nBFuwPD7JuHMcAG4ny9sI/X1iuBjgzfIitIDy8C7+QrYpHsoxsj86gWIV+m6sJqF030cLw==
X-Received: by 2002:aa7:d0d3:0:b0:42b:b1b9:726e with SMTP id u19-20020aa7d0d3000000b0042bb1b9726emr4821961edo.268.1653477358132;
        Wed, 25 May 2022 04:15:58 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id dn10-20020a05640222ea00b0042aad9edc9bsm10825709edb.71.2022.05.25.04.15.57
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 04:15:57 -0700 (PDT)
Message-ID: <11487287-b5b3-4576-0c20-5901f055008d@redhat.com>
Date:   Wed, 25 May 2022 13:15:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm <kvm@vger.kernel.org>
References: <CABgObfYhg1ZttC=mcpHkJV6QuA1CimCJwYckS86sZz+vQDC4XA@mail.gmail.com>
Subject: Re: Status for 5.19 merge window
In-Reply-To: <CABgObfYhg1ZttC=mcpHkJV6QuA1CimCJwYckS86sZz+vQDC4XA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/22 10:51, Paolo Bonzini wrote:
> * Guest performance monitoring improvements:
> ** Support for PEBS
> ** Support for architectural LBR

These were broken so I had to revert everything and rebase. :/

I also dropped IPI virtualization.

You can check out the delta with:

$ git range-diff tags/v5.18 kvm/kvm-next-pre-20220525-rebase tags/kvm-5.18-1

The following patches were also incidental casualties of the issue:

255:  7daffe14fd0d <   -:  ------------ KVM: powerpc: remove extraneous asterisk from rm_host_ipi_action comment

will be merged through ppc tree

257:  9fd169b02731 <   -:  ------------ KVM: Drop unused @gpa param from gfn=>pfn cache's __release_gpc() helper
258:  2517f9b0f189 <   -:  ------------ KVM: Put the extra pfn reference when reusing a pfn in the gpc cache
259:  3c980f9c0ef8 <   -:  ------------ KVM: Do not incorporate page offset into gfn=>pfn cache user address
260:  8ba88973477a <   -:  ------------ KVM: Fully serialize gfn=>pfn cache refresh via mutex
261:  3b7f9dace96f <   -:  ------------ KVM: Fix multiple races in gfn=>pfn cache refresh
262:  6aaeaad98fb2 <   -:  ------------ KVM: Do not pin pages tracked by gfn=>pfn caches
298:  82f0f434fca0 <   -:  ------------ KVM: VMX: Print VM-instruction error when it may be helpful
299:  f30c7aaeda6f <   -:  ------------ KVM: VMX: Print VM-instruction error as unsigned
300:  7e345a215d35 <   -:  ------------ KVM: set_msr_mce: Permit guests to ignore single-bit ECC errors

will be merged later in 5.19

188:  121383d0107e <   -:  ------------ x86/cpu: Add new VMX feature, Tertiary VM-Execution control
189:  9fbf31ba29b0 <   -:  ------------ KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit variation
190:  fd351c52963a <   -:  ------------ KVM: VMX: Detect Tertiary VM-Execution control when setup VMCS config
191:  9402278c24c0 <   -:  ------------ KVM: VMX: Report tertiary_exec_control field in dump_vmcs()
192:  3fadd6b78db0 <   -:  ------------ KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode
193:  8236723e797c <   -:  ------------ KVM: VMX: Clean up vmx_refresh_apicv_exec_ctrl()
194:  b113d61e1d1b <   -:  ------------ KVM: Move kvm_arch_vcpu_precreate() under kvm->lock
195:  a7747898a7c6 <   -:  ------------ KVM: x86: Allow userspace to set maximum VCPU id for VM
196:  b77b7e13f827 <   -:  ------------ kvm: selftests: Add KVM_CAP_MAX_VCPU_ID cap test
197:  694599c8267d <   -:  ------------ KVM: VMX: enable IPI virtualization

200:  2c8beb526ce9 <   -:  ------------ perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
201:  35a6bdffbf21 <   -:  ------------ perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
202:  907508f75964 <   -:  ------------ perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
203:  0dc19fcc2471 <   -:  ------------ KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
204:  4282743c110a <   -:  ------------ KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
205:  db2265f3a9ed <   -:  ------------ x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value
206:  34e028092173 <   -:  ------------ KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
207:  44d47de274d5 <   -:  ------------ KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
208:  a095df2c5f48 <   -:  ------------ KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
209:  f32db9822ccb <   -:  ------------ KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
210:  c873e000e103 <   -:  ------------ KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
211:  aa03a92de13a <   -:  ------------ KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
212:  a10cabf6815c <   -:  ------------ KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
213:  e1f82aee2e45 <   -:  ------------ KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
214:  8eeac7e999e8 <   -:  ------------ KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
215:  1672f447172a <   -:  ------------ KVM: x86/cpuid: Refactor host/guest CPU model consistency check
216:  a3808d884612 <   -:  ------------ KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64

217:  d73829dd797b <   -:  ------------ selftests: kvm: replace ternary operator with min()

246:  47604014f4b2 <   -:  ------------ KVM: x86/pmu: Move the vmx_icl_pebs_cpu[] definition out of the header file

248:  43e88ad5462d <   -:  ------------ KVM: x86/pmu: Update global enable_pmu when PMU is undetected
249:  f9e5edb2e20c <   -:  ------------ KVM: x86/pmu: remove useless prototype

250:  3c13551aca1e <   -:  ------------ KVM: x86/mmu: Drop RWX=0 SPTEs during ept_sync_page()
251:  c84f90442518 <   -:  ------------ KVM: x86/mmu: Comment FNAME(sync_page) to document TLB flushing logic

254:  1ae8c8cc506f <   -:  ------------ KVM: x86/pmu: Don't overwrite the pmu->global_ctrl when refreshing
256:  24045beb918e <   -:  ------------ KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesn't support global_ctrl

263:  8b5bb6866d73 <   -:  ------------ KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
264:  18e7b090afa3 <   -:  ------------ KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0
265:  c7b62aed6b63 <   -:  ------------ KVM: SVM: Unwind "speculative" RIP advancement if INTn injection "fails"
266:  e395d5155d5f <   -:  ------------ KVM: SVM: Stuff next_rip on emulated INT3 injection if NRIPS is supported
267:  5f04b27c5e6a <   -:  ------------ KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction
268:  1808e98b3243 <   -:  ------------ KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"
269:  78f035193a5d <   -:  ------------ KVM: x86: Trace re-injected exceptions
270:  6f03e4af9d88 <   -:  ------------ KVM: x86: Print error code in exception injection tracepoint iff valid
271:  87c326c9d672 <   -:  ------------ KVM: x86: Differentiate Soft vs. Hard IRQs vs. reinjected in tracepoint
272:  f1360dfcca6e <   -:  ------------ KVM: nSVM: Transparently handle L1 -> L2 NMI re-injection
273:  fcbad3abe1b0 <   -:  ------------ KVM: selftests: nSVM: Add svm_nested_soft_inject_test

274:  ecf97ee1ec70 <   -:  ------------ perf/x86/intel: Fix the comment about guest LBR support on KVM
275:  0090251780f2 <   -:  ------------ perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
276:  ca0c1c2b764f <   -:  ------------ KVM: x86: Report XSS as an MSR to be saved if there are supported features
277:  8bcfee39b078 <   -:  ------------ KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
278:  168f789aaf0d <   -:  ------------ KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
279:  e648e5300017 <   -:  ------------ KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
280:  7876f994c671 <   -:  ------------ KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest Arch LBR
281:  1cb63133254c <   -:  ------------ KVM: x86/pmu: Refactor code to support guest Arch LBR
282:  cd71edf727a2 <   -:  ------------ KVM: x86: Refine the matching and clearing logic for supported_xss
283:  3289eaad9d28 <   -:  ------------ KVM: x86/vmx: Check Arch LBR config when return perf capabilities
284:  2c9c5610c397 <   -:  ------------ KVM: x86: Add XSAVE Support for Architectural LBR
285:  a62bb9cd4734 <   -:  ------------ KVM: nVMX: Add necessary Arch LBR settings for nested VM
286:  706408701309 <   -:  ------------ KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
287:  f9dccecb1e86 <   -:  ------------ KVM: x86/vmx: Flip Arch LBREn bit on guest state change
288:  a94e5937c786 <   -:  ------------ KVM: x86: Add Arch LBR data MSR access interface
289:  a80ffe249095 <   -:  ------------ KVM: x86/cpuid: Advertise Arch LBR feature in CPUID

290:  944503434b67 <   -:  ------------ KVM: x86/pmu: Update comments for AMD gp counters
291:  10b3f260a9ba <   -:  ------------ KVM: x86/pmu: Extract check_pmu_event_filter() handling both GP and fixed counters
292:  b1070b1cc80e <   -:  ------------ KVM: x86/pmu: Pass only "struct kvm_pmc *pmc" to reprogram_counter()
293:  2fe380c3736e <   -:  ------------ KVM: x86/pmu: Drop "u64 eventsel" for reprogram_gp_counter()
294:  8f348136b61e <   -:  ------------ KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()
295:  a6717fc663bd <   -:  ------------ KVM: x86/pmu: Use only the uniform interface reprogram_counter()
296:  7d271cd6af1d <   -:  ------------ KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp,fixed}counter()
306:  d0baf34e4f58 <   -:  ------------ perf: x86/core: Add interface to query perfmon_event_map[] directly
307:  fcfe10b4dfa6 <   -:  ------------ KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
308:  0356ff9b1093 <   -:  ------------ KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context

will be delayed to 5.20.

Paolo

> Will be in 5.19 merge window:
> * dirty quota
> * nested dirty-log selftest
> 
> After merge window:
> * APICv inhibition on APIC id change
> 
> Delayed to 5.20:
> * eager page splitting
> * CMCI support
> * Hyper-V TLB
> * pfn functions cleanup
> * x2AVIC
> * nested AVIC
> 


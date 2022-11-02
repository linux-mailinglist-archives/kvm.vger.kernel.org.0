Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F95616A7A
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbiKBRTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiKBRTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:19:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262B65586
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667409523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6bHZ6RhzwZqcFqy+ASS3SxP9gnDv328z5/6b9PXyycI=;
        b=i4hidTrLTXQb6FOpsg+sb/t9hnmCnpYu4phNnZJZvf0+izGeZ9P7Fjyh76eCEdcLEoRgji
        Ly5SEuSKGgHeNPpulGTT7+t6TXHzp/KbG4sQPwe/kRTc7RnhuaHYv0ufBfqfoulBNqfD4b
        tvBFQbwShMNVdfRkyS2QSqhL64u3ngE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-290-JlW1VnviN5K1imnV27OvdQ-1; Wed, 02 Nov 2022 13:18:42 -0400
X-MC-Unique: JlW1VnviN5K1imnV27OvdQ-1
Received: by mail-ej1-f70.google.com with SMTP id nc4-20020a1709071c0400b0078a5ceb571bso10252073ejc.4
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6bHZ6RhzwZqcFqy+ASS3SxP9gnDv328z5/6b9PXyycI=;
        b=wGLeiUxH7A9boPV3YtyDKc7WGLB8ZTJKQdtuhcCYk4FshjarBWjwls4EBUmmMO4LFf
         vCBJi/VFQfKg+spaON18mrzEDu887qVimWIc28NH2VDqVRka9Yv7Kw5ehh3QsdLS+Z4Y
         uuTUG1453h2AZMkE5JKurRaav0ap3S7QZjJkpeWlB4ubHOJSO0/7zERiRmI4GhwR4Fy5
         WMZca8I2U9JZLt/NDwZH567wd0n6bfslIZPWR3+5Nre/SpKTSdbDi5G/bst68y2525qR
         3cPbyzTXM6Y1CFTNBtPbgB6+yhg1vtaRbi4IWbTMTa9mMt2mrY5D6CxiJb3LHtH+YwnY
         5k9Q==
X-Gm-Message-State: ACrzQf2ZdY1j0lZpNcUcXoBNke2DjUcU5nJDuF8/xTRVhoz8/0lYqzu6
        +hrKJWayr4sOZPYBcjKDy3Y3c+i64s+WGIIDsI5Wij7RtwbiGrb+hmIMgYpV4Dv9Ox+Hrx/3VCk
        XIqEVUkmwx4OL
X-Received: by 2002:aa7:ce8d:0:b0:461:50fd:e358 with SMTP id y13-20020aa7ce8d000000b0046150fde358mr25568799edv.194.1667409518908;
        Wed, 02 Nov 2022 10:18:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4/x6PwTbAurOsVP1zVclwSL+Yxg9TvaRFUydU5orfswpNxKcJmxdeZGEr7BJDb268QdsewlQ==
X-Received: by 2002:aa7:ce8d:0:b0:461:50fd:e358 with SMTP id y13-20020aa7ce8d000000b0046150fde358mr25568766edv.194.1667409518634;
        Wed, 02 Nov 2022 10:18:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id d7-20020aa7ce07000000b004589da5e5cesm6056704edv.41.2022.11.02.10.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:18:37 -0700 (PDT)
Message-ID: <a817ec49-adae-50b5-6c3e-8e4e91d91e93@redhat.com>
Date:   Wed, 2 Nov 2022 18:18:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v5 0/8] KVM: x86: Intel LBR related perf cleanups
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
References: <20221006000314.73240-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221006000314.73240-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/22 02:03, Sean Christopherson wrote:
> PeterZ, I dropped your ACK from v4 because the perf patches were completely
> broken.
> 
> Fix a bug where KVM incorrectly advertises PMU_CAP_LBR_FMT to userspace if
> perf has disabled LBRs, e.g. because probing one or more LBR MSRs during
> setup hit a #GP.
> 
> The non-KVM patch cleans up a KVM-specific perf API to fix a benign bug
> where KVM ignores the error return from the API.
> 
> The remaining patches clean up KVM's PERF_CAPABILITIES mess, which makes
> everything far more complex than it needs to be by
> 
> v5:
>   - Drop perf patches that removed stubs.  The stubs are sadly necessary
>     when CPU_SUP_INTEL=n && KVM_INTEL={m,y}, which is possible due to
>     KVM_INTEL effectively depending on INTEL || CENTAUR || ZHAOXIN.
>     [hint provided by kernel test robot].
>   - Add a patch to ignore guest CPUID on host userspace MSR writes.
>   - Add supported PERF_CAPABILITIES to kvm_caps to simplify code for all
>     parties.
> 
> v4
>   - https://lore.kernel.org/all/20220901173258.925729-1-seanjc@google.com:
>   - Make vmx_get_perf_capabilities() non-inline to avoid references to
>     x86_perf_get_lbr() when CPU_SUP_INTEL=n. [kernel test robot]
> 
> v3:
>   - https://lore.kernel.org/all/20220831000051.4015031-1-seanjc@google.com
>   - Drop patches for bug #1 (already merged).
>   - Drop misguided "clean up the capability check" patch. [Like]
> 
> v2:
>   - https://lore.kernel.org/all/20220803192658.860033-1-seanjc@google.com
>   - Add patches to fix bug #2. [Like]
>   - Add a patch to clean up the capability check.
>   - Tweak the changelog for the PMU refresh bug fix to call out that
>     KVM should disallow changing feature MSRs after KVM_RUN. [Like]
> 
> v1: https://lore.kernel.org/all/20220727233424.2968356-1-seanjc@google.com
> 
> Sean Christopherson (8):
>    perf/x86/core: Zero @lbr instead of returning -1 in x86_perf_get_lbr()
>      stub
>    KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs
>    KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()
>    KVM: VMX: Ignore guest CPUID for host userspace writes to DEBUGCTL
>    KVM: x86: Track supported PERF_CAPABILITIES in kvm_caps
>    KVM: x86: Init vcpu->arch.perf_capabilities in common x86 code
>    KVM: x86: Handle PERF_CAPABILITIES in common x86's
>      kvm_get_msr_feature()
>    KVM: x86: Directly query supported PERF_CAPABILITIES for WRMSR checks
> 
>   arch/x86/events/intel/lbr.c       |  6 +---
>   arch/x86/include/asm/perf_event.h |  6 ++--
>   arch/x86/kvm/svm/svm.c            |  3 +-
>   arch/x86/kvm/vmx/capabilities.h   | 37 ----------------------
>   arch/x86/kvm/vmx/pmu_intel.c      |  1 -
>   arch/x86/kvm/vmx/vmx.c            | 51 +++++++++++++++++++++++--------
>   arch/x86/kvm/x86.c                | 14 ++++-----
>   arch/x86/kvm/x86.h                |  1 +
>   8 files changed, 52 insertions(+), 67 deletions(-)
> 
> 
> base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354

Queued, with patches 2-4 destined to kvm/master.

Paolo


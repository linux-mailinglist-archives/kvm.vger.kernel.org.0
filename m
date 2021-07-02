Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0F53BA0B9
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 14:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhGBMx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 08:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbhGBMx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 08:53:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAB9C061762;
        Fri,  2 Jul 2021 05:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C8ALLQj/bOQJND57AVrY9VNxlPJQTTW9AA8AzYQ5NxU=; b=npcZ+/lbkQ+/yyKCwUUxiXMQMY
        YgLdG8qPNWfUZ96ibW6F6AbGR0haTE7CzFzoguJltWprAFRC9T+HlxlLzs42+2pbIJYYkw0OeuZB2
        Obta5/jxWr7OTVq6Py6JeeJBH0W+4fdxUGeabPenJdca+yAxeFovXI8nWjEhe2pkurVu7mlr4x9vw
        MTXd11Q5dH4YfkZtDC6VFqgxW3Tq10/lQCVn7gmET+fYOvvmKWru6sIMzZlVEXLKqiTTd5KNGai1N
        f9+hCgFLoq3dEIC3xMonHsNujuqVI9UDC3mvDyEUdEwfqeU5bNQhomnGpeLm+tbwyL/Otbu/KB1px
        ZpCLK3sQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzIc8-007hrE-VV; Fri, 02 Jul 2021 12:49:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E847C300091;
        Fri,  2 Jul 2021 14:49:47 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D37EC299AFBF7; Fri,  2 Jul 2021 14:49:47 +0200 (CEST)
Date:   Fri, 2 Jul 2021 14:49:47 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, weijiang.yang@intel.com,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com
Subject: Re: [PATCH V7 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
Message-ID: <YN8La215i8i9T97s@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622094306.8336-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 05:42:48PM +0800, Zhu Lingshan wrote:
> Like Xu (17):
>   perf/core: Use static_call to optimize perf_guest_info_callbacks
>   perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
>   perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
>   perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
>   KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
>   KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
>   KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
>   KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
>   KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
>   KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
>   KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
>   KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
>   KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
>   KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
>   KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
>   KVM: x86/cpuid: Refactor host/guest CPU model consistency check
>   KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64

Overall pretty decent, I send a couple of nits in reply to the
individual patches.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5622635674F
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 10:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhDGI4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 04:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhDGI4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 04:56:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01E7C06174A;
        Wed,  7 Apr 2021 01:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aa/JEl56eeC1x4TtC4IUSell2kbzIuGu7iI2MeJkm6k=; b=CzdVm45xcZXiYz8c/yqutOYj6j
        E/hCUJ8ibAd7ODtbibm8cvhZLjHvMXzblvCMK7NdpeBPx1RIdJU1hvV7umtKhEg6GmKRRN31dVg3p
        t/641iVANp0rMwjvzWh7LZC/mN1dZs876qWun/OTJtLWtDV15ktNjQDUtpr7u0D85H26VzWUauKrE
        CVIP82iG9CD1njccFjlB8kF9gHlcFk3ZoQQC0lmMzbN7OBvoOawf+UpdvGOHdOLJyicIvJ8KgyZbM
        y7RiEhq9Q6LCEH+2jstdwh/WbNnATWtzf+b1xsgTk2P8N9sbeJO/F8WiGpDhz66bWHr4me1yJBVai
        /XBG6Kaw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lU3yn-004XKm-Gz; Wed, 07 Apr 2021 08:56:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1E23830005A;
        Wed,  7 Apr 2021 10:56:04 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 08AE424403D8F; Wed,  7 Apr 2021 10:56:04 +0200 (CEST)
Date:   Wed, 7 Apr 2021 10:56:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Luwei Kang <luwei.kang@intel.com>
Subject: Re: [PATCH v4 07/16] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR
 emulation for extended PEBS
Message-ID: <YG1zo2DApRdonUVQ@hirez.programming.kicks-ass.net>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-8-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329054137.120994-8-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 29, 2021 at 01:41:28PM +0800, Like Xu wrote:
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 546d6ecf0a35..9afcad882f4f 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -186,6 +186,12 @@
>  #define MSR_IA32_DS_AREA		0x00000600
>  #define MSR_IA32_PERF_CAPABILITIES	0x00000345
>  #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
> +#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
> +#define PERF_CAP_ARCH_REG              BIT_ULL(7)
> +#define PERF_CAP_PEBS_FORMAT           0xf00
> +#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
> +#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
> +	PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)

broken indentation

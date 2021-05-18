Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2409E387A44
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 15:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbhERNoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 09:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbhERNoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 09:44:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04588C061573;
        Tue, 18 May 2021 06:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=FEdlQoyD3PDtpLtM4yznKXxGHpEaCgn204cnBtbvYCk=; b=W7luStfFr08ol2+PUA4kGF3wxR
        xQee1C6GuP75GOHIjB5LXSPSlSVqpPbZsu6ajL2a2B434rMEjUzbB6Bm/VYR9uZ+HIa/af5LukwPG
        nfniSH+OKQjLQSEY8PMlGN/4uqZ/IS8BEq4lJNWOcIzRIxvNji+awzd5xIEIXSMDdCZl6isrMiUTF
        hWxGAbAPES/tU0woQbQLMxeyFHjyQ1NETMPo39QZqefYcG8NK/zz30A4mUhz7Ecb33eBhP/ril9YB
        jBeq+8KmcO0De0DVQ4O61feEreSVPD2tSFqABqu84vuIrwzR30+mityUvmN3brmPdTkRWY3U3KK29
        HHvWouIA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lizzX-000tpt-Gj; Tue, 18 May 2021 13:42:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D892A30022C;
        Tue, 18 May 2021 15:42:34 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C11663011B372; Tue, 18 May 2021 15:42:34 +0200 (CEST)
Date:   Tue, 18 May 2021 15:42:34 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v6 06/16] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR
 emulation for extended PEBS
Message-ID: <YKPESkRdCqZEze3x@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-7-like.xu@linux.intel.com>
 <YKIqJTe/StbBrrUy@hirez.programming.kicks-ass.net>
 <bc6d19ec-7ceb-0414-da68-e271466b9b8b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc6d19ec-7ceb-0414-da68-e271466b9b8b@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021 at 04:44:13PM +0800, Xu, Like wrote:
> Will adding the following comments help you ?
> 
> +/*
> + * Currently, the only caller of this function is the atomic_switch_perf_msrs().
> + * The host perf conext helps to prepare the values of the real hardware for
> + * a set of msrs that need to be switched atomically in a vmx transaction.
> + *
> + * For example, the pseudocode needed to add a new msr should look like:
> + *
> + * arr[(*nr)++] = (struct perf_guest_switch_msr){
> + *     .msr = the hardware msr address,
> + *     .host = the value the hardware has when it doesn't run a guest,
> + *     .guest = the value the hardware has when it runs a guest,

So personally I think the .host and .guest naming is terrible here,
because both values are host values. But I don't know enough about virt
to know if there's accepted nomencature for this.

> + * };
> + *
> + * These values have nothing to do with the emulated values the guest sees
> + * when it uses {RD,WR}MSR, which should be handled in the KVM context.
> + */
>  static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)

Yes, now at least one can understand wth this function does, even though
the actual naming is still horrible. Thanks!

Additionally, would it make sense to add a pointer to the KVM code that
does the emulation for each MSR listed in this function?

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC67382731
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 10:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbhEQIlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 04:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbhEQIlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 04:41:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30B6C061573;
        Mon, 17 May 2021 01:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=229IDtmq+Z8rEfJbRIPfNQwRGXcrW7sSmIFvvDMKEaI=; b=EV1ZxjmUqmj4jeBhsHifycK+tg
        yLQIF2TXWcKLygFEzwkN8ndU7T6Yf4+1kIQRFEv83+/tR/FD8NC5iY2wHSHA+iX+zyXUkH/A7oJ7P
        iC8cDxdVHbXEf0VCXsEBjmHzTg0vSFfeJzg+LbtMiPIjbAC1c6eNtIUTA/CwWPhb/WAcEVqzxBbSd
        zZzVIiLW3SqrbPjMcyVQ7MXcl0Vg+513smtbxppu9WDxi+o8RvsRvg4n0Wa4TLTIqhX3Rdjuv80JS
        lpqYzucgsiUPUJk8DIW8fZ8+sGLEtKuomEn5ROMJHm+H7fDfQuHhmT2+arJrPmGeeuaAQaXn1RYKH
        P82xu/bA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1liYmV-00EHr2-SZ; Mon, 17 May 2021 08:39:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 884E130022C;
        Mon, 17 May 2021 10:39:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7088C2D3FBA07; Mon, 17 May 2021 10:39:17 +0200 (CEST)
Date:   Mon, 17 May 2021 10:39:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 07/16] KVM: x86/pmu: Reprogram PEBS event to emulate
 guest PEBS counter
Message-ID: <YKIrtdbXRcZSiohg@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-8-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511024214.280733-8-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 10:42:05AM +0800, Like Xu wrote:
> +	if (pebs) {
> +		/*
> +		 * The non-zero precision level of guest event makes the ordinary
> +		 * guest event becomes a guest PEBS event and triggers the host
> +		 * PEBS PMI handler to determine whether the PEBS overflow PMI
> +		 * comes from the host counters or the guest.
> +		 *
> +		 * For most PEBS hardware events, the difference in the software
> +		 * precision levels of guest and host PEBS events will not affect
> +		 * the accuracy of the PEBS profiling result, because the "event IP"
> +		 * in the PEBS record is calibrated on the guest side.
> +		 */
> +		attr.precise_ip = 1;
> +	}

You've just destroyed precdist, no?

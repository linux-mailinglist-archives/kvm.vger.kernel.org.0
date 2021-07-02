Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3A73B9FC2
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhGBLZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbhGBLZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:25:25 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A051C061762;
        Fri,  2 Jul 2021 04:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O5Uqso+ww5amQ01DKigcD3vJJ7N3bwtD7LxAeQZ8NGo=; b=JYJbKRCaTtVjDzb/7N8Vg5ALJK
        Z9z+lgf5/nby+DFt32t6/4uiGrBJeKjTLVqqlBekOg4CgVhfQqk4bd+I/0DRjmpHrmNI77IlDRhYn
        JTJlDJI2+gb1fvdiaPk1sAjttTyO6N8hHeBFR/6wiUzGir5xO+zjr18vT2GDa7ueMv3jA0DvapxgS
        sORLkZ7+5aVcnyqMrOOh2sxuewdQjUzEt/H8Pa02qexOzNdz5irUkHr2OVQIQ7TUGNBbfjA6/qU55
        KLYzKy4dbIvNoL9okqBh6IPngAIxJ8W8lD+1vYchcUWAbhBempd1bUMgvDJN85yD8fulHZbpEdfXJ
        Z5/MAk+w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzHFD-00DqNT-HJ; Fri, 02 Jul 2021 11:22:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 43862300091;
        Fri,  2 Jul 2021 13:22:00 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D797A20244CE2; Fri,  2 Jul 2021 13:22:00 +0200 (CEST)
Date:   Fri, 2 Jul 2021 13:22:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, weijiang.yang@intel.com,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, Like Xu <like.xu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-2-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622094306.8336-2-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 05:42:49PM +0800, Zhu Lingshan wrote:
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 8f71dd72ef95..c71af4cfba9b 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -90,6 +90,27 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
>   */
>  DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs);
>  
> +DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
> +DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
> +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
> +
> +void arch_perf_update_guest_cbs(void)
> +{
> +	static_call_update(x86_guest_state, (void *)&__static_call_return0);
> +	static_call_update(x86_guest_get_ip, (void *)&__static_call_return0);
> +	static_call_update(x86_guest_handle_intel_pt_intr, (void *)&__static_call_return0);
> +
> +	if (perf_guest_cbs && perf_guest_cbs->state)
> +		static_call_update(x86_guest_state, perf_guest_cbs->state);
> +
> +	if (perf_guest_cbs && perf_guest_cbs->get_ip)
> +		static_call_update(x86_guest_get_ip, perf_guest_cbs->get_ip);
> +
> +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
> +		static_call_update(x86_guest_handle_intel_pt_intr,
> +				   perf_guest_cbs->handle_intel_pt_intr);
> +}

Coding style wants { } on that last if().

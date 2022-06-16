Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE3754DFA9
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 13:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359791AbiFPLFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 07:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiFPLFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 07:05:40 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950845B3DE;
        Thu, 16 Jun 2022 04:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6u5Zic0ktJmKoPubjatstZm1j2ROKci3uAw/8I/shys=; b=UaMD5Anh85BY233j9btxzLcd+6
        gctil/gy57ili0px3nUJMjO0DwY3Sc7VOziJsT++T1hq/xiyHRRzRrDMwpJBILchLoeipAVrHj5b4
        rbLX/HX9p7vgRzEq5BU4DZz+qEVUHRrKE8r8yb9xioZW63ryJgo6qZqyiP0LgRNQxZDFoAhnMjcwH
        m6xmTyZIVuEzL8eDSOHd/p/mkL9Fhrc9cps9GSp5K0vmMJ/y2FBnIzgT7cPSg6ehTitCyAj7wdRSf
        Dn6pk9MeIQA4JH935u5kpX6YP3N+W63OQW0jwF8CwG4JU5p3F8Hf+3Z5Po2LUneRvEgDp5UFbpDzK
        uAvOeslw==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1nJS-008Om8-H8; Thu, 16 Jun 2022 11:05:24 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id ED0D0980DD0; Thu, 16 Jun 2022 13:05:21 +0200 (CEST)
Date:   Thu, 16 Jun 2022 13:05:21 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Subject: Re: [PATCH 19/19] KVM: x86: Enable supervisor IBT support for guest
Message-ID: <YqsOcSWRuuigIY6N@worktop.programming.kicks-ass.net>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <20220616084643.19564-20-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616084643.19564-20-weijiang.yang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 04:46:43AM -0400, Yang Weijiang wrote:
> Mainline kernel now supports supervisor IBT for kernel code,
> to make s-IBT work in guest(nested guest), pass through
> MSR_IA32_S_CET to guest(nested guest) if host kernel and KVM
> enabled IBT. Note, s-IBT can work independent to host xsaves
> support because guest MSR_IA32_S_CET can be stored/loaded from
> specific VMCS field.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/cpuid.h      |  5 +++++
>  arch/x86/kvm/vmx/nested.c |  3 +++
>  arch/x86/kvm/vmx/vmx.c    | 27 ++++++++++++++++++++++++---
>  arch/x86/kvm/x86.c        | 13 ++++++++++++-
>  4 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index ac72aabba981..c67c1e2fc11a 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -230,4 +230,9 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
>  	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
>  }
>  
> +static __always_inline bool cet_kernel_ibt_supported(void)
> +{
> +	return HAS_KERNEL_IBT && kvm_cpu_cap_has(X86_FEATURE_IBT);
> +}

As stated before; I would much rather it expose S_CET unconditional of
host kernel config.

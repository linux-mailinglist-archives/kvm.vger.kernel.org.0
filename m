Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5383037B70C
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 09:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhELHrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 03:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhELHrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 03:47:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68189C061574;
        Wed, 12 May 2021 00:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qTeWQyqg90a0gIju1FCIhB4SaC06XxqkOWQ6xtTm4Es=; b=NlsjsMvDDgO0IMtnHraRetZsIk
        6ryqjmPMmdqeCkRL7AJ5FHt0wrPbFlgAchZDkGSmgrVMivTdfDOYQhW1pSRx6CvNn8F53ygREJrAu
        uwjs+ea5rLshMzfYJWcpNhTVFdQkWkFajqojNth2n9xexlBh0KFLb8AAIB/mHp0bC87m1b6NAZxLs
        zel+3z4tBGHdYv+Dccd/5lpE18seXHJ2msM6jBB5s1Xm2Z+/wNf0K3IzMGuGPuB28Lo5ybl5llAKl
        GuUnQYg+iWLsWUQ+HsMWRIie6NsaB7NFYUaicWNG9g5Q9kQN1fAd/8epnob9zzKP8OLuwqFBoXMZ4
        1iOJlHoA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgjUe-00847E-Uf; Wed, 12 May 2021 07:41:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A9B3E300242;
        Wed, 12 May 2021 09:41:14 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B9CBE20237F69; Wed, 12 May 2021 09:41:14 +0200 (CEST)
Date:   Wed, 12 May 2021 09:41:14 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Dave Jiang <dave.jiang@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3] KVM: x86: use wrpkru directly in
 kvm_load_{guest|host}_xsave_state
Message-ID: <YJuGms6UnRVpP7U/@hirez.programming.kicks-ass.net>
References: <20210511170508.40034-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511170508.40034-1-jon@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 01:05:02PM -0400, Jon Kohler wrote:
> diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
> index 8d33ad80704f..5bc4df3a4c27 100644
> --- a/arch/x86/include/asm/fpu/internal.h
> +++ b/arch/x86/include/asm/fpu/internal.h
> @@ -583,7 +583,13 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
>  		if (pk)
>  			pkru_val = pk->pkru;
>  	}
> -	__write_pkru(pkru_val);
> +
> +	/*
> +	 * WRPKRU is relatively expensive compared to RDPKRU.
> +	 * Avoid WRPKRU when it would not change the value.
> +	 */
> +	if (pkru_val != rdpkru())
> +		wrpkru(pkru_val);

Just wondering; why aren't we having that in a per-cpu variable? The
usual per-cpu MSR shadow approach avoids issuing any 'special' ops
entirely.

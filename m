Return-Path: <kvm+bounces-47783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC39BAC4CB4
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 13:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8706D17BDD6
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AC6258CCB;
	Tue, 27 May 2025 11:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Oaq7NnMg"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95309253F3C;
	Tue, 27 May 2025 11:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748344042; cv=none; b=NLB72w5DYI2JFsNd0V+LVfQ/uqftr12jDSjwzeNuQlPxjcvMwfPUJIQiYsvgN31bpZRGbHc9RJ5aWdFz6EIqbxYR1uLNu2rxxVc6YwhFkG0MZrmJ4UBIhoOewqosA5FfPdMhTvLoEzdH6YU+aLRmPotXryRc0Ee9ORVmrtVTcSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748344042; c=relaxed/simple;
	bh=BEzAHVd4mDG4MDT3KcgNgsleTLGagcNbfs7ULeTM6lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVOj7ypljxUyVqqiyLxr2o7TAkH+mVHuD0rRx+mQyoG18H7CSQiB//Ba154kNlLaJwqS3HLYGIooka64KLMXdGP878zKyByG/cEu8zJnUVKqHzSGq+jgyHMK15KjjMoQJBozrB8udjqwrDrNBVPfoBdh4+ySkQI6Iff6z2cFGjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Oaq7NnMg; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/9LAIkZZfGUI2kuU1V9Jq8TPjsmQcV2tOD/YSymag7w=; b=Oaq7NnMg8hJ85qzJh7VKV4rS1N
	barp+c2ktLb6vSLwadTJe+8fIdsCiUd98eRzAEbIpyXscQZkNYlkmKdr4UyIKr1ZPy38QJL1YTdDR
	+cSmMZw85a79jDDBxjb2dkBmu6OJd/Dh41H41yISODtrNIKl//CDkTsqO94dd/SA7zbYAPhcOk/ej
	9jmX/mUCNUO45Qgs62wuligWvl0sxLLAx5O2gLPgwiiPjaY6X5JW+3IuEcwK2q7yXvev5Q5dMcoLt
	h3PFVcZCV6uFS4m9otw0h/pKx/8dA06q77VAvjIo1cYTE9fX+l0T/zU73GWkpydDAu+7743GgOWMS
	XScmmFOQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJs9D-000000022l3-1GXC;
	Tue, 27 May 2025 11:07:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B0ADB30057C; Tue, 27 May 2025 13:07:06 +0200 (CEST)
Date: Tue, 27 May 2025 13:07:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	binbin.wu@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] KVM: VMX: add noinstr for is_td_vcpu and is_td
Message-ID: <20250527110706.GA20019@noisy.programming.kicks-ass.net>
References: <tencent_27A451976AF76E66DF1379C3604976A3A505@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_27A451976AF76E66DF1379C3604976A3A505@qq.com>

On Tue, May 27, 2025 at 11:45:16AM +0800, Edward Adam Davis wrote:
> is_td() and is_td_vcpu() run in no instrumentation, so they are need
> noinstr.
> 
> [1]
> vmlinux.o: error: objtool: vmx_handle_nmi+0x47:
>         call to is_td_vcpu.isra.0() leaves .noinstr.text section
> 
> Fixes: 7172c753c26a ("KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct")
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  arch/x86/kvm/vmx/common.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 8f46a06e2c44..70e0879c58f6 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -59,20 +59,20 @@ struct vcpu_vt {
>  
>  #ifdef CONFIG_KVM_INTEL_TDX
>  
> -static __always_inline bool is_td(struct kvm *kvm)
> +static noinstr __always_inline bool is_td(struct kvm *kvm)

noinstr and __always_inline are not compatible. Specifically noinstr
implies noinline.

>  {
>  	return kvm->arch.vm_type == KVM_X86_TDX_VM;
>  }
>  
> -static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
> +static noinstr __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	return is_td(vcpu->kvm);
>  }
>  
>  #else
>  
> -static inline bool is_td(struct kvm *kvm) { return false; }
> -static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
> +static noinstr bool is_td(struct kvm *kvm) { return false; }
> +static noinstr bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }

The problem is likely your compiler is silly and managed to out-of-line
these; make these __always_inline and try again.

>  
>  #endif
>  
> -- 
> 2.43.0
> 


Return-Path: <kvm+bounces-34005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7484E9F5A57
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A344618840B9
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 23:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0EF11FA267;
	Tue, 17 Dec 2024 23:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M5VFXZHn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA221E2617
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 23:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734478147; cv=none; b=YCCjZuNAgdqLCYsl3l3L7pVjMLjGkeVTo6K6T1R96/t/hAZrHKjukto5qjzOTtmqQKuEknKmFGe952n9hj0NNhANtKlvOCcaaiZkxILfZ3OJo/wejQWWRpecALIYeOj2L5/2oxoH2djZwNX3nluWBxgUS2GbQQvbTk/OH8n+F3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734478147; c=relaxed/simple;
	bh=ZRW9FS615meeB4cuY9IjMkURWSn1efg/QVqSg7hTwV4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ij9cuG3s+aWQN/Ln9e0gcPNUD63+3AKHKqKCpnQilfwOJecyrQjDOPgo4LDF0b/INF+O1JBPD+NC28uTxNg64DRIBZJNpowiBjZ+G/3SvGdwSyTDrPGVoJPfNIJTXV1mM/xYO6Ri/9aRysNGSs+tKkJdpHa8kgCE1Q3l2I49WUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M5VFXZHn; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7fd481e3c0bso3651211a12.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 15:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734478145; x=1735082945; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u+A6OwJrNT6drsvdva0NABswVAfUoqi998cBEN+7hSg=;
        b=M5VFXZHnLEIygd9ShXtl2BXWk9om7wd7gjd+ykYt6gix1an+05ww8yQMUcMiq5LK9A
         HPcLp05MES775ftKNpxrM/dVFivcLBIgQTvHKj4H9bue/x5r1TaQROq2pJ8EOOIag/kw
         JsUYqwPb3cQkF1OImMvKkpswd6DO6gkEx1rUryYMGf3aViVeNnNjG0bXDAZ5oVv8BXwC
         wtGMv3XvZ2nvdK8/XPZEtYSOPRbEC06lxfnYzseKkkHFi8+u0OCVG5lmlKLxdcAxry5r
         LNlQnnNMrN48rZASE984q9YNl/Z4QoXym7d3W2134EI6poP68xGaDqk4k9K8SYRaYmp9
         R1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734478145; x=1735082945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u+A6OwJrNT6drsvdva0NABswVAfUoqi998cBEN+7hSg=;
        b=c1RZt96x1Q/gC2tcifRfJ7iDLL194GNpb0IG37OwXADHQ9YikNS9wkaZQIdJKOzRaV
         dl33VYzJ8QCI3gwzxQ35pNsNoh5MqqEkbjwQbRPInGqNsLHDJPkaV2k8EIsKV1yh/MyU
         OqurUOjVrzm6Cmp+l/RxYjYieZKI2c4ep4HW1LYvi2BIiWrurt7ZMUzhnENPdZZ/nYco
         Y5y5pIKmgvuEJsWsecFyGtIb216EfuQf/mzbUOmjnDLf31wgY45xGsqS9jbssO/WGEZA
         0qeOjSNbEB6XK/P+YQQYwL1R6IBVJRp2y0J6aXf/4h7zURSVO/TOjMsB69wq2VrrcBKP
         qdOA==
X-Forwarded-Encrypted: i=1; AJvYcCXV2g15G+wfLbUtplpk33wUZvj25qVluYi3cYeXUV6sTFB/LqTpHq/kFCxMrlAJ5wwqmO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKmQelhISM/V3fiIMJWY/vXfeyJW+CCPZp9S7OfZI+7bjIFuQG
	wejYJvgYVIihuCIDDwj6ZIaUCIjQ5+9Zk97daTTeUpQv79Et4wd88SMsGS/aD4/kXQpTKZ449Um
	5LA==
X-Google-Smtp-Source: AGHT+IG7TM/pjY8G3lM3v4H9HOi2EaCWcjYv/dvMySdb5lytqyhMmiicErLdBSptdE7JNyD0h6ESexhOLvY=
X-Received: from pjbqn14.prod.google.com ([2002:a17:90b:3d4e:b0:2ef:82c0:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d10:b0:2ee:a583:e616
 with SMTP id 98e67ed59e1d1-2f2e91d93bdmr1138831a91.9.1734478144886; Tue, 17
 Dec 2024 15:29:04 -0800 (PST)
Date: Tue, 17 Dec 2024 15:29:03 -0800
In-Reply-To: <20241121115703.26381-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121115139.26338-1-yan.y.zhao@intel.com> <20241121115703.26381-1-yan.y.zhao@intel.com>
Message-ID: <Z2IJP-T8NVsanjNd@google.com>
Subject: Re: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com, 
	binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	isaku.yamahata@gmail.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 21, 2024, Yan Zhao wrote:
> For tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove(),
> 
> - Upon detection of TDX_OPERAND_BUSY, retry each SEAMCALL only once.
> - During the retry, kick off all vCPUs and prevent any vCPU from entering
>   to avoid potential contentions.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/vmx/tdx.c          | 49 +++++++++++++++++++++++++--------
>  2 files changed, 40 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 521c7cf725bc..bb7592110337 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -123,6 +123,8 @@
>  #define KVM_REQ_HV_TLB_FLUSH \
>  	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
> +#define KVM_REQ_NO_VCPU_ENTER_INPROGRESS \
> +	KVM_ARCH_REQ_FLAGS(33, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  
>  #define CR0_RESERVED_BITS                                               \
>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 60d9e9d050ad..ed6b41bbcec6 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -311,6 +311,20 @@ static void tdx_clear_page(unsigned long page_pa)
>  	__mb();
>  }
>  
> +static void tdx_no_vcpus_enter_start(struct kvm *kvm)
> +{
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_NO_VCPU_ENTER_INPROGRESS);

I vote for making this a common request with a more succient name, e.g. KVM_REQ_PAUSE.
And with appropriate helpers in common code.  I could have sworn I floated this
idea in the past for something else, but apparently not.  The only thing I can
find is an old arm64 version for pausing vCPUs to emulated.  Hmm, maybe I was
thinking of KVM_REQ_OUTSIDE_GUEST_MODE?

Anyways, I don't see any reason to make this an arch specific request.


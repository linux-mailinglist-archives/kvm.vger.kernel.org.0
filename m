Return-Path: <kvm+bounces-37930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE7FFA319CE
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 00:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C46961644C4
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 23:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E170E26A0F2;
	Tue, 11 Feb 2025 23:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mOA426pG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81263268FEE
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 23:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739317730; cv=none; b=s8ZHWH2GySAssiN9FLrZcNUu2BqPVxuH0IUgBLeRNGFrL4obkPrufNEzr05UlW18IO08+POrnaH6c1+busHgeqd++fZ0V1bicU2cJVmGAl3k/Goc0SpU86A6ggKjR4sBcoFu6l2hEir+oSelTCtAF7x3RXYrZSkSHnAW05xMydY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739317730; c=relaxed/simple;
	bh=cDnsalRb7YufpPDDPgfmjmAXw6jDSFsrdCQyPthOmCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tH1xHHdIomlFrD/qaLKiTAluYbhFI2QtH9FN7mifw0b3cFoHAhg0Rtwm0LX3s+0Ov9u6sYUiHsGw4AkCNMiHjKu28TJsWCWTV+PJOkZqJo6JTFvda/mjS1yNDu6CAPXnNlI9Q6szqbxWd91i+E7unVrN51o9nYRK9QpT9Mw84UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mOA426pG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa32e4044bso9174719a91.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 15:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739317728; x=1739922528; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UGu/cNgqZkYuEVNIGjHmdyKZOLkegFa4UYLEoSBig7Y=;
        b=mOA426pGaYIz961rpdl1YmxZQ4bu2Wo5yTjgw7I1fH7Roz//tamqeWqfJx6sOppHGH
         WWHNhfvcJfocTrShWBMZYBR7Bd8WkNGyAq56ERlODeHwYAnqIcFeh74d1+PLYzTxxDXJ
         dJXjj2KBEcIQTLGsArHvG99qEXVr8ahyiMM0lVgo7GViiGSp2oaNErUDyUF9wDioOZuq
         t9ifeWIJSN/BloNPPqbZI0MOkTl5ut6zauykimriXYrSGUmRfRSagruwmL4tCcEFarGg
         oORILajK5IqiQg9/CjnqVYspan9zzI+fkyWNPLK7TvBAqJkLJGlz2zFC05aU/hYimNiH
         U2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739317728; x=1739922528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UGu/cNgqZkYuEVNIGjHmdyKZOLkegFa4UYLEoSBig7Y=;
        b=TUsOCTIppVIAohtx4cBYDJGvT8AqiRPUbnobq/4q4NA0f3tN+Boro6sGbL0pQocziM
         h2f1vGZG/KRqI0lyyrVkfcOHjwYC/8QkXEGgVdivQrGVKoqaygyzo2NhyQ8GCto41Rmm
         GbubgVzhLZd2b5S4V34qrwT8OwNIYhtcUvfUESPtkHXZYrrdFb5kGJU4A9FR4BFAn+iq
         pphCN/zN0Evcko93Qgaekx/PCnCT3B97EYQUWM/Kv8wIBW8f+mNW0zyAxtEH/eWWPZsC
         mcjMBAGEOrY6DSzFApnAslDqVARsSpjRDCjnSz9XoS6LF8H6nSK7L98MyXnUxFwXasn0
         mLaA==
X-Forwarded-Encrypted: i=1; AJvYcCXz/b1po8GQj1XhRweHnG0EKw+QjqASlnb7rVD8CMhKGfj58Tjs2tqnLQIBwQGXQEmsl2I=@vger.kernel.org
X-Gm-Message-State: AOJu0YweI280/n5N6GXiQEYLhDTFKOb3Q1yz638lc39viS2gkgoS6AOU
	2jt1Lml3VI/U70nyXIUJA9pppZ7FfroN4gZwx6Ts2CdmtLstP10PMrYm69xoD6CRtuDpoBL1Jq4
	K3A==
X-Google-Smtp-Source: AGHT+IEc79RumyTWGFr0CkEmyy8mfvo7xYFKyN74swX+mC0k9PkA/d+lnmtjNfhMKlCCsGK17ol8aORl4zk=
X-Received: from pjbnb7.prod.google.com ([2002:a17:90b:35c7:b0:2fa:24c5:36e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51cd:b0:2ea:3f34:f194
 with SMTP id 98e67ed59e1d1-2fbf5bf4afamr1801039a91.10.1739317727869; Tue, 11
 Feb 2025 15:48:47 -0800 (PST)
Date: Tue, 11 Feb 2025 15:48:46 -0800
In-Reply-To: <20250211025442.3071607-5-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com> <20250211025442.3071607-5-binbin.wu@linux.intel.com>
Message-ID: <Z6vh3ih37Xrmv4TJ@google.com>
Subject: Re: [PATCH v2 4/8] KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 11, 2025, Binbin Wu wrote:
> ---
>  arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 420ee492e919..daa49f2ee2b3 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -964,6 +964,23 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  	return tdx_exit_handlers_fastpath(vcpu);
>  }
>  
> +static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
> +{
> +	tdvmcall_set_return_code(vcpu, vcpu->run->hypercall.ret);
> +	return 1;
> +}
> +
> +static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
> +{
> +	kvm_rax_write(vcpu, to_tdx(vcpu)->vp_enter_args.r10);
> +	kvm_rbx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r11);
> +	kvm_rcx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r12);
> +	kvm_rdx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r13);
> +	kvm_rsi_write(vcpu, to_tdx(vcpu)->vp_enter_args.r14);
> +
> +	return __kvm_emulate_hypercall(vcpu, 0, complete_hypercall_exit);

Thanks for persevering through all the ideas and churn, I like how this turned
out!


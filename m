Return-Path: <kvm+bounces-11922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5AF287D2F9
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:41:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03B7B1C21AFE
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5B44CB38;
	Fri, 15 Mar 2024 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WW6KjNCZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E77487AE
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710524491; cv=none; b=hnJ1EW/Sb9XUOvBt7y2yuQ0JfpZ9UbMzekxZwTEbKMvGJBcSxAYzw2h/BBwlJswBjV9FB3kcjIb6zBFPwrqi0pH/C8p0R+2qYiDIK7z+vtLB2Va2Ax5zO68bQBlsogP8Hacjr0Ppfh3vSaEnMgrk7eHHbxcmADD9C7XNgH3gXl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710524491; c=relaxed/simple;
	bh=yuuPNY4/s5/UlcbR6wILOPm6AltS6irnsHBo9y9VNzw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F3TzJ7p2Dc5q+3mjO/JBYE/A9NURezKIb1fGeYGD7+oWEAEs6v5GWfrUiNvsQjt70UTDu0f7ZYfBukIHD6KduX6Tjx8Chm1exo7PnhuswOP7Bg8QieAsqEuQV0IEADqijPHaNApR1q7XD+v9CJ6W+NQPyOQALO6F8NWi8ovM+hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WW6KjNCZ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a629e2121so42101737b3.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 10:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710524489; x=1711129289; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yefYGzkLN0A6uHHWqrU5PePod4vCRl9tPQamL29vI5o=;
        b=WW6KjNCZqIONCPJxOFr6+3bmtM/i5qNwM976qcs7Xa+hau2yals5cXOYVqJlbPyBuK
         sGcWHiCmBiXNXG2Jih9qGEm/HYiUMUOUjTICT26zE17AVnkAx3sHk8Mn65ePZadyUZTu
         tjgW0nFmDjd47cKK0+NFdFQ8n6a15oJA8z1ya3iuKhWJPjB6rVle5jA6sVRD9IgorSWE
         6VBjPYCx5YlTZxq9ZxTH+ScU7qr7U0rwQwxnmhIvoIVorKO+kQDFBwl12WMzSKiQp4Sf
         8c0ZBuVThH9hVoRcAFow8Yd4tjSTAi/7SwgoqWBo8WOAzaaogdn9iDqPkPrcHXC0OB5c
         Q+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710524489; x=1711129289;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yefYGzkLN0A6uHHWqrU5PePod4vCRl9tPQamL29vI5o=;
        b=PyVmxiInf8pI3tfGZ2qn40OLK/GL7fqI8sEB2MNl8HKZ7UMZSZvZ/Qhjyo1JrmY28/
         lQwIr2ygLYlrvszMDs3qevBrP+Ire0oW7MXWQpEtHAfNx3ie5IBPGZXC8SdCj3fT6OOP
         ulAIR/2LxCNS8oZNFDoQjDF+3uE8f3HHQmuQMylOg0vx7pLnHKTCj23fXK9dvVL7oLgm
         mvEefSWKenW/B/7kF6z6P6Gh4lH7eWYWqT9e+tbl7axiNWd5pQFjQIZHnaEfX22TxrLU
         bLiMufArZTRMdTygfB142aZAwm6k57b65CxvwWuaE8zFWHbJ6q6qFivGO0Kb63/WdZXg
         Y8mg==
X-Gm-Message-State: AOJu0YwhM3ovCtu9KLnn5zG1b2yjgYK/volU0ideyzSwTv2RDVlcPXsh
	QB0tZMrk6B0pNooxVXUai/7pV2+lXUji2UhZBbHyGahFYrXYeu/5I5mNfWrz5zUaQzHkyDo+YmU
	8aw==
X-Google-Smtp-Source: AGHT+IGFNK6aMYj8wIgRXznNcv7zdvGKfDM/WM0H+Hn5MQtbuke4kTTMx0h39Ab8ATUVYsX7cJfzU9+m4IU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:910f:0:b0:60a:25ce:c165 with SMTP id
 i15-20020a81910f000000b0060a25cec165mr1314650ywg.6.1710524489411; Fri, 15 Mar
 2024 10:41:29 -0700 (PDT)
Date: Fri, 15 Mar 2024 10:41:28 -0700
In-Reply-To: <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com> <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
Message-ID: <ZfSISAC0sIYXewqG@google.com>
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> +static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
> +			       struct tdx_module_args *out)
> +{
> +	u64 ret;
> +
> +	if (out) {
> +		*out = *in;
> +		ret = seamcall_ret(op, out);
> +	} else
> +		ret = seamcall(op, in);
> +
> +	if (unlikely(ret == TDX_SEAMCALL_UD)) {
> +		/*
> +		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
> +		 * This can happen when the host gets rebooted or live
> +		 * updated. In this case, the instruction execution is ignored
> +		 * as KVM is shut down, so the error code is suppressed. Other
> +		 * than this, the error is unexpected and the execution can't
> +		 * continue as the TDX features reply on VMX to be on.
> +		 */
> +		kvm_spurious_fault();
> +		return 0;

This is nonsensical.  The reason KVM liberally uses BUG_ON(!kvm_rebooting) is
because it *greatly* simpifies the overall code by obviating the need for KVM to
check for errors that should never happen in practice.  On, and 

But KVM quite obviously needs to check the return code for all SEAMCALLs, and
the SEAMCALLs are (a) wrapped in functions and (b) preserve host state, i.e. we
don't need to worry about KVM consuming garbage or running with unknown hardware
state because something like INVVPID or INVEPT faulted.

Oh, and the other critical aspect of all of this is that unlike VMREAD, VMWRITE,
etc., SEAMCALLs almost always require a TDR or TDVPR, i.e. need a VM or vCPU.
Now that we've abandoned the macro shenanigans that allowed things like
tdh_mem_page_add() to be pure translators to their respective SEAMCALL, I don't
see any reason to take the physical addresses of the TDR/TDVPR in the helpers.

I.e.  if we do:

	u64 tdh_mng_addcx(struct kvm *kvm, hpa_t addr)

then the intermediate wrapper to the SEAMCALL assembly has the vCPU or VM and
thus can precisely terminate the one problematic VM.

So unless I'm missing something, I think that kvm_spurious_fault() should be
persona non grata for TDX, and that KVM should instead use KVM_BUG_ON().


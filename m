Return-Path: <kvm+bounces-43690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12026A940BE
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 03:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30CCB7A801E
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 01:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCFA78F3A;
	Sat, 19 Apr 2025 01:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B8NlNWB9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F702EAF7
	for <kvm@vger.kernel.org>; Sat, 19 Apr 2025 01:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745025145; cv=none; b=MN3Tg65veigUr6jxw7MqhPbSIAZYBjNrqZoH4LyrUPcLKHXctQa0R3dY10KHiW9H/fM6piM5RH3glccFjydAPJUEH3pDmP2Yf3K1Rk0KMit1x7gN+eS3wUciRW3YiibkaO9D+vqiz+zG7uaVrw/95+iHKg+0/cKLQJcoxxrsYbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745025145; c=relaxed/simple;
	bh=GBLqjUBIYKLE1OiCMwpLkALClRqsAbp12xJDCFy7CyM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KO19nI3X1joF9decqTNPAZE47poi3op6ec/5jXjzNLiRGhtnFEbJYjbZ7scJr32T8GpR/AuujdHfXzgV6egBI9rox1lDBuBSj66LjdjXCZc3NJq9PWUZ7mUwcNL+3K+NONNT67LeBUYao055Hmc/7gRPdD9HnIyZJgT1OtTqanw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B8NlNWB9; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-afd1e7f52f7so1412722a12.1
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 18:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745025143; x=1745629943; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bAssG5fQ67XkPLJgYAAQI+PG7StKquP6G71qrzqZJ2M=;
        b=B8NlNWB9phPpWgL7/BxpPv4URlLClC8a0BEX+08PszdC9jUUFs1fQ1Fk/tsLb6l0t2
         YoxZ4nxsO60XwxQ4HhC7KKBjTAax118XmJ+zOCGNDc1bk6W/2PK1x60ipv5zZ7rGRSnN
         HayPgA5I56VdRi2WxZ0A+U0i+I8+TvuQI1rDHd9ljGX4GqhX3qMCk4oMR6tGrNLz23Wj
         cpTJXWBPjm8+NQk3R2ttmv9Q+WJ7EIlTPw0nxrVmNH4n3jHu9Oj1QmFSJaIGckXMDVQz
         O2BQsOmRhd4pUeLp0C5O/UYrIfEs/lHPJb5lTZwjj3ErEwanO1j8zc33Vd/aaVbG+R21
         +FSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745025143; x=1745629943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bAssG5fQ67XkPLJgYAAQI+PG7StKquP6G71qrzqZJ2M=;
        b=TANoKUUNjSRb7SpbIfBaHScUNmM2zj1yUmg8OIgEUJ+/CV7bRfJml27W4xu4maaZmn
         5BW72yaBOHzIy3nbOJ/stRkOCv8n7H4H5iqxkTTc6MwQKHQ2W2760aHvfNzBel9RMfgE
         8NvFajm5WPaKWyejoH/x733vVbyYg4BQ4XUgu4oxLpaPN5ozdUMNZqFDnzc623WCpLds
         09Y7xLupdSt861010UmjOWaC5X9jMMnkR9z0hkTQszpoyfi3nwjdYLY2W4803WX/Vj5X
         EwFkax58BAAPWHwivRPRU/f/xU4DVrPw6hHKkViBFKFm4BD+UH9GfJ5hievgJ6mux3nw
         mfYg==
X-Forwarded-Encrypted: i=1; AJvYcCUdalWHXHNeK63Qsw3TU1wXJ2oohFzZBmoN/8XBiVQONU1SO6VXEm/9JnoSOOCBE2RBQLk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr6Qq8D59G4Ybjq7AoHgo/CcC3okJQrfYuJ+Lcyuq8QKz4vqnu
	zX+vEdutpnOzUXLuQiiS4AL/7mPXPHNplu4uOc0WLqSI94bkeFaFfMKxmdGl5comTxSkvmI1+1o
	m7w==
X-Google-Smtp-Source: AGHT+IEwiOscwRryNbV5HEkDLR/QSN5uMa5G6pQrJMGE0vv7idD4Yujycc133PfZgsKp3+f0KyatWMvuqqA=
X-Received: from pjwx11.prod.google.com ([2002:a17:90a:c2cb:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef11:b0:224:2384:5b40
 with SMTP id d9443c01a7336-22c535a7e46mr72675585ad.24.1745025143192; Fri, 18
 Apr 2025 18:12:23 -0700 (PDT)
Date: Fri, 18 Apr 2025 18:12:21 -0700
In-Reply-To: <20250417131945.109053-2-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250417131945.109053-1-adrian.hunter@intel.com> <20250417131945.109053-2-adrian.hunter@intel.com>
Message-ID: <aAL4dT1pWG5dDDeo@google.com>
Subject: Re: [PATCH V2 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, mlevitsk@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 17, 2025, Adrian Hunter wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
> which enables more efficient reclaim of private memory.
> 
> Private memory is removed from MMU/TDP when guest_memfds are closed. If
> the HKID has not been released, the TDX VM is still in RUNNABLE state,
> so pages must be removed using "Dynamic Page Removal" procedure (refer
> TDX Module Base spec) which involves a number of steps:
> 	Block further address translation
> 	Exit each VCPU
> 	Clear Secure EPT entry
> 	Flush/write-back/invalidate relevant caches
> 
> However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state
> where all TDX VM pages are effectively unmapped, so pages can be reclaimed
> directly.
> 
> Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
> reclaim time.  For example:
> 
> 	VCPUs	Size (GB)	Before (secs)	After (secs)
> 	 4	 18		  72		 24
> 	32	107		 517		134
> 	64	400		5539		467
> 
> [Adrian: wrote commit message, added KVM_TDX_TERMINATE_VM documentation,
>  and moved cpus_read_lock() inside kvm->lock for consistency as reported
>  by lockdep]

/facepalm

I over-thought this.  We've had an long-standing battle with kvm_lock vs.
cpus_read_lock(), but this is kvm->lock, not kvm_lock.  /sigh

> +static int tdx_terminate_vm(struct kvm *kvm)
> +{
> +	int r = 0;
> +
> +	guard(mutex)(&kvm->lock);

With kvm->lock taken outside cpus_read_lock(), just handle KVM_TDX_TERMINATE_VM
in the switch statement, i.e. let tdx_vm_ioctl() deal with kvm->lock.

> +	cpus_read_lock();
> +
> +	if (!kvm_trylock_all_vcpus(kvm)) {
> +		r = -EBUSY;
> +		goto out;
> +	}
> +
> +	kvm_vm_dead(kvm);
> +	kvm_unlock_all_vcpus(kvm);
> +
> +	__tdx_release_hkid(kvm, true);
> +out:
> +	cpus_read_unlock();
> +	return r;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -2805,6 +2827,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	if (tdx_cmd.hw_error)
>  		return -EINVAL;
>  
> +	if (tdx_cmd.id == KVM_TDX_TERMINATE_VM)
> +		return tdx_terminate_vm(kvm);
> +
>  	mutex_lock(&kvm->lock);
>  
>  	switch (tdx_cmd.id) {
> -- 
> 2.43.0
> 


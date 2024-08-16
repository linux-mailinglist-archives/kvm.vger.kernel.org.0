Return-Path: <kvm+bounces-24401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE1B954DAB
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 17:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41134B22452
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 15:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A68221BDA9D;
	Fri, 16 Aug 2024 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a51nZEd0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A26F1BDA95
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 15:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723822234; cv=none; b=SecF6BKCIDhyw/9lBE/POxm18iBYLX3wAGnGQBT8opA8+xXLa15kHWAoGVO+duuJ9aIGai0ZcfiH8/4bJjdlMa+0ujX8YkGCB2LCpNOcvphybXSSjh/UNUY4DWyFqkYABHzpUb9IVeTBnoyxe8efzZSu3P+znYD7/0gdaeE8S+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723822234; c=relaxed/simple;
	bh=z5ATbgW/5LMgDDgTlNnUOVOABQ26loeKbRHOmoueNJI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jZIOjohPHg2t4AeMa1VMLghKzDgr94pYrcz7+gMzVKKuFW/hc/ix46YJQriqZ5BsJFl9XTqfFgWrQv3OZ/fKS26gc3mSk4/vWJ7/pB7Od/QLbMlG+0dCioOhF1i3GmkNhQX8qKrYwvWHlUHBwrVzkaB374JUHPq7L0CSSKYPWx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a51nZEd0; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1676060a12.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 08:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723822233; x=1724427033; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4+81pDhLGIHQkEcVg7Sm2NkkqyHauxzf0JjWdA/TkGw=;
        b=a51nZEd0CJX4wFbZsmEdPfImBIeKIAJbgqT7h/N3/bcuMBlzVVlJt0ELiLuhow4FAd
         8bn2l9VKMK4ELzQE5JLu8ucpwAPgKTaP8IJ1EBISCGhzVI6Gss/YRJ8utkgGf+BUhIjZ
         9SuDSNqqy2KSZM3pbrdEZxS/wz+gku+PX1mtmCxGzxV2xXyI4gpyax1BaIMfE4TZGQ0b
         CTz1C5+M/9TIEXJuqxd1Y0qDiFSHYU0MMUdniJh9GrmTOjIvP/kXybbldVZnrYMH3Olg
         OwnUso5QrfaSa4SX9vB364vp6EZumSVirng5LuNw1g5wVNBZDuAdU5U9CgtMrbBYQMWf
         kVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723822233; x=1724427033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4+81pDhLGIHQkEcVg7Sm2NkkqyHauxzf0JjWdA/TkGw=;
        b=MwUqmgNp2wLmjrn8205gm2R0hgHUJyTpTKI4eqALgzgEWZZ62eOyWalk+A7EOMiSVB
         GmnQredPUByfSkgP8usVWI7xxf0jXi99OU52/Mw8xAptS7Tnuh2Py1ZPUyLe+wovZua5
         duE0k+6fWrInn4lCcWtu/3VjPeO2H5S9FO3LZWbrX4HI3XRN0SlW5g1DfY2UMaXQlaaQ
         klR8kjZagwwIGN6kB0V/K7/1cHz0bMVvUFCYqUM4szFTr/VzM5hS9mWVKD5Dcd5G1Hr6
         6QYzwTaLT9Woowqck5T7btp/eEozRWvAtjOZ9fV4oNR0VkdpsvMBIFcHOWb2ZKPIR4FV
         u94w==
X-Gm-Message-State: AOJu0YyoJzy9AK76T264ONYEkA0fqCyLL263WLqIICBJ5dP1zWcyWsJX
	mF1jRd0CBzrCgCi1f1hKrm0kkOG5MAiTcbQicOo2zeCqrio/J07H3mp+9WgcwHjoZp8VDg4BwPK
	ZNA==
X-Google-Smtp-Source: AGHT+IHMP2EULpQy3kRqIMWCo3R3hZfjuGO0qczwWYdFXPJZ/k0bKRM2eUlmlyawlbcnwG9PKXD7yI2Fyqg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4e46:0:b0:7a0:b292:47cb with SMTP id
 41be03b00d2f7-7c6b2a69f5emr51372a12.0.1723822232602; Fri, 16 Aug 2024
 08:30:32 -0700 (PDT)
Date: Fri, 16 Aug 2024 08:30:31 -0700
In-Reply-To: <20240715225654.32614-1-kishen.maloor@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240715225654.32614-1-kishen.maloor@intel.com>
Message-ID: <Zr9wlwcwcNNm77iU@google.com>
Subject: Re: [PATCH] KVM: nVMX: Simplify SMM entry/exit flows in nested guest mode
From: Sean Christopherson <seanjc@google.com>
To: Kishen Maloor <kishen.maloor@intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, lprosek@redhat.com, 
	mlevitsk@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 15, 2024, Kishen Maloor wrote:
> This change aims to resolve a TODO documented in commit 5d76b1f8c793
> ("KVM: nVMX: Rename nested.vmcs01_* fields to nested.pre_vmenter_*"):
> 
> /*
>  * TODO: Implement custom flows for forcing the vCPU out/in of L2 on
>  * SMI and RSM.  Using the common VM-Exit + VM-Enter routines is wrong
>  * SMI and RSM only modify state that is saved and restored via SMRAM.

Sorry, but this does not implement what the TODO suggest.  Specifically, it touches
_far_ more state than what is saved/restored in SMRAM.  Implementing custom SMI+RSM
handling will require an annoying amount of coding, which is why it hasn't been
done yet.

>  * E.g. most MSRs are left untouched, but many are modified by VM-Exit
>  * and VM-Enter, and thus L2's values may be corrupted on SMI+RSM.
>  */
> 

...

> +int nested_vmx_leave_smm(struct kvm_vcpu *vcpu)
> +{
> +	enum vm_entry_failure_code entry_failure_code;
> +	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	kvm_service_local_tlb_flush_requests(vcpu);
> +
> +	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
> +
> +	prepare_vmcs02_early(vmx, &vmx->vmcs01, vmcs12);
> +
> +	if (prepare_vmcs02(vcpu, vmcs12, false, &entry_failure_code)) {
> +		vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> +		nested_vmx_restore_host_state(vcpu);

This is blatantly wrong, a failure during RSM results in shutdown.  And I'm 99%
certain that restoring "critical VMX state" can't fail, i.e. this path shouldn't
exist at all.

Per the SDM, critical state is saved in a uarch-specific location, i.e. it can't
be accessed by software and thus isn't validated on RSM.  And interestingly,
CR0/4 fixed bits are _forced_, not validated:

  set to their fixed values any bits in CR0 and CR4 whose values must be fixed
  in VMX operation (see Section 24.8);

Ditto for CS/SS RPL vs. DPL.


Return-Path: <kvm+bounces-15552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAAA58AD503
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 21:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89A841F226B8
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 19:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FCB15535D;
	Mon, 22 Apr 2024 19:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IbmlU1jN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF07153837
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 19:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713815015; cv=none; b=ikBeDuRl0wThq8tNkz4XL+7zUMRW/DPVs4F3x+y1pnb8BrLUjHHlEhibeN84qI4fB5CoapRyfxHMS/pCnz2oMgLlsVcLFI5fsUXk1TdMhXbIp6zwb7FhR8Yjk54jymY/uNMXuxMqNB7Nu//sqf/WC7O3Ackthj25eTNEPdHZVD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713815015; c=relaxed/simple;
	bh=rqo5kZsuhsjRzcG6r7op5qGRZLLQPYMPvIRMLhlGAEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cTn6UsC6t26rvvN2D+50O8St5UK6yJgGvD6d2TM/b2P5tm55uVzk76JxURn72AWFU/kyD4RzDLu6qA8ExLF8U/J1M6zKMudHDCF05wRaaIWRH15ogicA5lkDblQoZdo+azzYQvY45uer+Ug32GyrJP+u6KwuplI69vpUq1/Gh8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IbmlU1jN; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61ab7fc5651so84700507b3.2
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 12:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713815012; x=1714419812; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JyzTdSdQlZjPTKTajFwL+PTG8n8RFsaCQ17y36xG4qs=;
        b=IbmlU1jNa25HgJG7LFHg/CU7wk5LcFKccUL8gSqZqnW2DNdF4xak+i8F/DGBy9cYqC
         inskTDcvuoqCG9pSqB2uIxlXoCLUr7xUSFHNANlviS44qAeYK9vWiDR6Fnr6RSlBNyjV
         HmzGCppHmz+wIObLpAAt+QnbfzKev3q3eioqNkHGTyjp9L8bmo4PGSNeiC47XxATdEqA
         XfncL4Lywu9+NlWPykewxxVJnBRKKpmSfSJrH6K4bNTkF1ABFSbIjZjTGqw352RsUDtj
         BfA6iD73ZtGCF5Qlo4lKmKWxnhYGpPm6glk+8POwC/vKmgZEbwMRYDKTATB2WgGJC+5D
         Fi5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713815012; x=1714419812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JyzTdSdQlZjPTKTajFwL+PTG8n8RFsaCQ17y36xG4qs=;
        b=kQrjGziNrL9qHxzIEwjPSj8yCwF+Ws6DSVvxP2mTt7mL4mQTlelSl2iE60bWikPiID
         bwJryNYoBkNKAxobDkGZL97D0kJCp1WsZPMc5ksjtolhvX0pGXAugjnkDU2ufAPAJn8k
         f8I8bagwp9oHKJym/l5Q+TDhJFcPCbaEK9qnGF438qBJWe+xeMlfY+pbYYmVk4LNu7eB
         2aBT59ovxQ0NEBpaXBmoltemOkFGrJxc4yACANi9uc+RD3dePNuvZvm8Cb1FRla+Zrxr
         TlJnLOfXHLtZ7wewrdoUfiM/bnDoAZukWxekZ/LoStxF5aAYBsXEVoS8Vx0FKh/UKWEc
         lIhg==
X-Forwarded-Encrypted: i=1; AJvYcCVH/3VIAkLO2+5ioLzClUxg/NH6f9pbvMEo0wGHIqtryEojD+AQ/nm1bbJ3d10nmj4JSAn3QEw13vxzzSp885IVQRBb
X-Gm-Message-State: AOJu0Yy2Odlvte1NEX562QmMxioq5groEYE0yTN89KtqzwcowqNlFr8h
	pebcrx+gY34By3MhWcU7tB8JvQ5b26jwwbx3iFNzoWHdLVm3siO22Qcys5dpjc64qlzI4sDMqTK
	ITg==
X-Google-Smtp-Source: AGHT+IEBAZmsWiF9Oef4bJqyhQc/VsZSMs3v5FKxK9dwBp2DXeyyqSS3hoEpcVGzDdsfeq32Lj2jvxWrGM8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c3:b0:de5:2325:72a1 with SMTP id
 w3-20020a05690210c300b00de5232572a1mr1265614ybu.4.1713815011856; Mon, 22 Apr
 2024 12:43:31 -0700 (PDT)
Date: Mon, 22 Apr 2024 12:43:30 -0700
In-Reply-To: <20240422130558.86965-1-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240422130558.86965-1-wei.w.wang@intel.com>
Message-ID: <Zia94vbLD-DF1GEw@google.com>
Subject: Re: [PATCH v1] KVM: x86: Validate values set to guest's MSR_IA32_ARCH_CAPABILITIES
From: Sean Christopherson <seanjc@google.com>
To: Wei Wang <wei.w.wang@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 22, 2024, Wei Wang wrote:
> If the bits set by userspace to the guest's MSR_IA32_ARCH_CAPABILITIES
> are not supported by KVM, fails the write. This safeguards against the
> launch of a guest with a feature set, enumerated via
> MSR_IA32_ARCH_CAPABILITIES, that surpasses the capabilities supported by
> KVM.

I'm not entirely certain KVM cares.  Similar to guest CPUID, advertising features
to the guest that are unbeknownst may actually make sense in some scenarios, e.g.
if userspace learns of yet another "NO" bit that says a CPU isn't vulnerable to
some flaw.

ARCH_CAPABILITIES is read-only, i.e. KVM _can't_ shove it into hardware.  So as
long as KVM treats the value as "untrusted", like KVM does for guest CPUID, I
think the current behavior is actually ok.

> Fixes: 0cf9135b773b ("KVM: x86: Emulate MSR_IA32_ARCH_CAPABILITIES on AMD hosts")

This goes all the way back to:

  28c1c9fabf48 ("KVM/VMX: Emulate MSR_IA32_ARCH_CAPABILITIES")

the above just moved the logic from vmx.c to x86.c.

> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ebcc12d1e1de..21d476e8e4b0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3808,6 +3808,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_ARCH_CAPABILITIES:
>  		if (!msr_info->host_initiated)
>  			return 1;
> +		if (data & ~kvm_get_arch_capabilities())
> +			return 1;
> +
>  		vcpu->arch.arch_capabilities = data;
>  		break;
>  	case MSR_IA32_PERF_CAPABILITIES:


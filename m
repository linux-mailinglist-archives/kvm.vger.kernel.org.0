Return-Path: <kvm+bounces-60694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D461EBF7C53
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0AEC189756D
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42135346D88;
	Tue, 21 Oct 2025 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dc/cVxzw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D537B3431E9
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761065196; cv=none; b=sA8HEHwaS2S23mQ4iQsjoNyLnOJKt4k/VDNfVWWLj8NIe1Or7F0xCTQcJ2HjeFwXGXSNT92V3vDphlroxeF325iOTZYCUXSs4ASTTWxQGJ7Xk42OJVOcxTNgawgSRRvaWgRI2C0YgUtMRfw9K3ctQy9F4DHH+ft4FFYxT6yCxbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761065196; c=relaxed/simple;
	bh=MzCSlF7JPYH2kOHDFsTdRATR2yhvHJ8O9b6vUSpv794=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dpCtZIgu3V8c8DPB+YHOK4LoGesluG+fxQPmQ0Be0nebG4iNx3D7Vxfgm1ad9aA8rQlS/BOnHYW7vWRa8F+V/BXFfflFlqCr79lczpYYZlHI9jyZZZ17nByckU2O/HCDrsO9oTSPLm0oQuU/iQrMZgM4qrNJwJSu1mO0oWkAGG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dc/cVxzw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bcb779733so5037788a91.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 09:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761065194; x=1761669994; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ILJtTbb3p1RSJdwFph32qlzFNqhYFB7y760KFco4Owo=;
        b=Dc/cVxzwuupDTZOD1m0/l7YoyzamyY1dDl+GPk1FpQ95P8bJ2+5PbrYth35NFWyZeu
         4QZN1QVfzGaseoJdvuT4C5waAk/s/zsTL4l4VwXzGp8f0KgbJiYxIGcsrxJBy/SBk2Js
         0UbXz3LNUAIuR15Cd4h5eJW1dwCWH9M4olPTC/uCTj5k7+kWqxnbAa+uj17wxIc4bp0i
         pv6Wai70Gv3dw9pG2tFnbuYYAqGt/PPl/7tWnnL/4KMU0Ao0usPlet7JeFSYP/Agw2Wu
         117XjbCHcyhAZuccCLVI9Zbs5/bAUXdQd+9MfKGQeTbh7kXqUhIwVkk7v0wT1u3vWRKW
         l2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761065194; x=1761669994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ILJtTbb3p1RSJdwFph32qlzFNqhYFB7y760KFco4Owo=;
        b=OBvNPnUU3pDikzJbFG8+9ItGv/quBle1foOg3EeZ9FDCFo4kjXR6lZ+dJAhE2AvNsm
         FXsFr682d5AvgoYoBytyBgo/S63sl3CeCi7u3y3CVK86po8yBYAReivpL2OyvZBTZ1vw
         HhWDSGh53My4h/vUBiyxBgVh8EQexUmSscbMM5p0PmKvWZ4+vct40qRD62I5NTsBYFf4
         MTayNrWM9PipgG10otMdVZlPAf4n1T51iekbdHw0PgLvwEn+K8i7+EImyXw3tp9tX3a3
         KAzrwg04y2+7g9MDc6pIplKT8/C6W8yF9nZQcWY/aFTv2wntKj80GOhhnYsofyl8nxXL
         Av4g==
X-Forwarded-Encrypted: i=1; AJvYcCVfhSeMN0wjBmDPzET16TMOWtYDOLCkW2c4kpzJ8tN8hJwsCNm3GQ9wK5Pms4fDEqDquQs=@vger.kernel.org
X-Gm-Message-State: AOJu0YycnuWzg+dOer3KpkjCtlnm1lvAWoZtt9xluOiI84w7NopLx3RS
	9ObsdjzGfi2Jk0n5pRtKv+8OZH3yraM884N4bTvfwR10sceJxOfWu87/XeTc1LFmbo2uryuLAeP
	ERs1Cmw==
X-Google-Smtp-Source: AGHT+IHQC8FnTeE31bDovIZahN02vzwA1aMcIa7ISNfuievKsucJKLKlotq+V3A/k5eE93pnT90GbMf/PEo=
X-Received: from pjbtd12.prod.google.com ([2002:a17:90b:544c:b0:330:b9e9:7acc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17cb:b0:32a:34d8:33d3
 with SMTP id 98e67ed59e1d1-33bcec1abbfmr19826042a91.0.1761065194119; Tue, 21
 Oct 2025 09:46:34 -0700 (PDT)
Date: Tue, 21 Oct 2025 09:46:32 -0700
In-Reply-To: <4841c40b-47b0-4b1b-985f-d1a16cbe81fa@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016222816.141523-1-seanjc@google.com> <20251016222816.141523-2-seanjc@google.com>
 <e16f198e6af0b03fb0f9cfcc5fd4e7a9047aeee1.camel@intel.com>
 <d1628f0e-bbe9-48b0-8881-ad451d4ce9c5@intel.com> <aPehbDzbMHZTEtMa@google.com>
 <4841c40b-47b0-4b1b-985f-d1a16cbe81fa@intel.com>
Message-ID: <aPe46Ev0wWks6Hz2@google.com>
Subject: Re: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs immediately
 after VP.ENTER
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kas@kernel.org" <kas@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, wenlong hou <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Adrian Hunter wrote:
> On 21/10/2025 18:06, Sean Christopherson wrote:
> > On Tue, Oct 21, 2025, Adrian Hunter wrote:
> >> On 21/10/2025 01:55, Edgecombe, Rick P wrote:
> >>>> +	 * Several of KVM's user-return MSRs are clobbered by the TDX-Module if
> >>>> +	 * VP.ENTER succeeds, i.e. on TD-Exit.  Mark those MSRs as needing an
> >>>> +	 * update to synchronize the "current" value in KVM's cache with the
> >>>> +	 * value in hardware (loaded by the TDX-Module).
> >>>> +	 */
> >>>
> >>> I think we should be synchronizing only after a successful VP.ENTER with a real
> >>> TD exit, but today instead we synchronize after any attempt to VP.ENTER.
> > 
> > Well this is all completely @#($*#.  Looking at the TDX-Module source, if the
> > TDX-Module synthesizes an exit, e.g. because it suspects a zero-step attack, it
> > will signal a "normal" exit but not "restore" VMM state.
> > 
> >> If the MSR's do not get clobbered, does it matter whether or not they get
> >> restored.
> > 
> > It matters because KVM needs to know the actual value in hardware.  If KVM thinks
> > an MSR is 'X', but it's actually 'Y', then KVM could fail to write the correct
> > value into hardware when returning to userspace and/or when running a different
> > vCPU.
> 
> I don't quite follow:  if an MSR does not get clobbered, where does the
> incorrect value come from?

kvm_set_user_return_msr() elides the WRMSR if the current value in hardware matches
the new, desired value.  If KVM thinks the MSR is 'X', and KVM wants to set the MSR
to 'X', then KVM will skip the WRMSR and continue on with the wrong value.

Using MSR_TSC_AUX as an example, let's say the vCPU task is running on CPU1, and
that there's a non-TDX vCPU (with guest-side CPU=0) also scheduled on CPU1.  Before
VP.ENTER, MSR_TSC_AUX=user_return_msrs[slot].curr=1 (the host's CPU1 value).  After
a *failed* VP.ENTER, MSR_TSC_AUX will still be '1', but it's "curr" value in
user_return_msrs will be '0' due to kvm_user_return_msr_update_cache() incorrectly
thinking the TDX-Module clobbered the MSR to '0'

When KVM runs the non-TDX vCPU, which wants to run with MSR_TSC_AUX=0, then
kvm_set_user_return_msr() will see msrs->values[slot].curr==value==0 and not do
the WRMSR.  KVM will then run the non-TDX vCPU with MSR_TSC_AUX=1 and corrupt the
guest.


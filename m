Return-Path: <kvm+bounces-24559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04ABD957765
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 00:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0D9028385E
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 22:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058B71DD39D;
	Mon, 19 Aug 2024 22:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fzy06zf9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C7B1DB452
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724106224; cv=none; b=Qf5S8gQFnuMqC+4XOs//baVpmeqgYc4NH7Iq+lpzUDoujlP0AtXR1acnc+fNX8JYaS2/OEEhmAKXtWZFyK+SXnWR8U2jCR1//sMP6DRPrJPuLmMqZu45lR+Wrl59d+4Uqycft+l1qR0S3ZJy4M2sStV+OjLDWmohGp4Ghrj88gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724106224; c=relaxed/simple;
	bh=/dWuuqJx6//alwTKkRAoRjouRCsQ6n8uwYXDiZcr204=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DuKTdm0udOnPfJtv+YGquIfNrqc54X29iTKJyib8kxBUh7F/TLJHrjYvxd4a9v6bbtAnbeuVzmdx93W4gZhZQIEEO8dLJiqsA7yW3q26WY0P776E7TktGnFNRPv70SSUUkXoL9IhIIQIP1NOaLRpGFz4G1liDGk78Mwqqz4aCbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fzy06zf9; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a134fd9261so4383209a12.3
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 15:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724106222; x=1724711022; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QraVn1YFVIm9p1pLoG75UmtSb9Y9IZMVlgQbMonr5gA=;
        b=fzy06zf9cYR8tcH4kf9W0+Vfyo3xas3O6/fw/S60MDN7QrhZpQevdPxOsXtR1gnPdf
         QNa4QovaLsz7xZbyjj/KuLjNAqU00jTWCZGZXMIYKHrJO3l56Dk4yQqqO5X1IJIDSjyu
         frYs45ObiG0yLvZooLQx6Z6bZClsSLTK7P8XX8prsWZ0wurSUWh1INhJfNWmCkZ+8YZU
         hhhg2AjmOL89WRGZhxjljvvHUT1XO7FuZS2khXi2sa3qHpIjf3lB9mbbz38nsR7Zh3f7
         dGBfEwY+cxFy6MjS02eCEZ+gqPkHncxvT6BRfs7CQnhURgPtnr0qI0zw5ROkd5nKBKpW
         qppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724106222; x=1724711022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QraVn1YFVIm9p1pLoG75UmtSb9Y9IZMVlgQbMonr5gA=;
        b=TKtFg7UO8NqVZmRYHfQ/+RuxhWJqPNGMlKnseU1NPKnC23ougw9Bc/OPyy6mxDw8wm
         Wb0D1ylVwEuuPBO3VCj0vlJNc9nvoy3mR6TnUw3IK+zLkyGcIDWGaP1v/3gvaAYraOnw
         htPB1RH+ns+tE/gFrfOmBVQijVB2ZsqduuewJk4Uke0Wa0YCpOPOAzbjwyNDiLIsLN8Y
         e2G+jYx8kb7WP58iu39gG10XnNZF9riHuDczvEHQcI+bSjRlo8BqDO3zzihJX9uy0u0D
         VrmWeeYUhhI2q0xMbtuEYnvj1064emJgURkNIDA68Rh5lTf4v/XMgp8kaDScu4uoT2ql
         jUQw==
X-Gm-Message-State: AOJu0YyBy+H/zELx/bAZ5mPBrX5uGnuDURIhLcG4UNID9JLNH3e2HUlP
	1U6UFaJPmiuZrmoxz5ZLhy+Slqar6YV0kBeX4BL4FdjQH6xU3yGuHF8gmb4QBLceYqz6n/iib+g
	xCQ==
X-Google-Smtp-Source: AGHT+IEfTz4hLw2X3jgxGkXc0FGTTTxdn8/F6SltD4DQ4SjqMZIhumVipiAYqbvYgJdjDnEqJaAA6kOzbm8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5ec5:0:b0:760:76b9:ade9 with SMTP id
 41be03b00d2f7-7c9791e4e77mr24563a12.1.1724106221794; Mon, 19 Aug 2024
 15:23:41 -0700 (PDT)
Date: Mon, 19 Aug 2024 15:23:40 -0700
In-Reply-To: <7208a5ac-282c-4ff5-9df2-87af6bcbcc8a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802015732.3192877-1-kim.phillips@amd.com>
 <20240802015732.3192877-3-kim.phillips@amd.com> <Zr_ZwLsqqOTlxGl2@google.com> <7208a5ac-282c-4ff5-9df2-87af6bcbcc8a@amd.com>
Message-ID: <ZsPF7FYl3xYwpJiZ@google.com>
Subject: Re: [PATCH 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
From: Sean Christopherson <seanjc@google.com>
To: Kim Phillips <kim.phillips@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Kishon Vijay Abraham I <kvijayab@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 19, 2024, Kim Phillips wrote:
> On 8/16/24 5:59 PM, Sean Christopherson wrote:
> > On Thu, Aug 01, 2024, Kim Phillips wrote:
> > > From: Kishon Vijay Abraham I <kvijayab@amd.com>
> > > 
> > > AMD EPYC 5th generation processors have introduced a feature that allows
> > > the hypervisor to control the SEV_FEATURES that are set for or by a
> > > guest [1]. The ALLOWED_SEV_FEATURES feature can be used by the hypervisor
> > > to enforce that SEV-ES and SEV-SNP guests cannot enable features that the
> > > hypervisor does not want to be enabled.
> > 
> > How does the host communicate to the guest which features are allowed?
> 
> I'm not familiar with any future plans to negotiate with the guest directly,

I feel like I'm missing something.  What happens if the guest wants to enable
PmcVirtualization and it's unexpectedly disallowed?  Does the guest simply panic?

> but since commit ac5c48027bac ("KVM: SEV: publish supported VMSA features"),
> userspace can retrieve sev_supported_vmsa_features via an ioctl.
> 
> > And based on this blurb:
> > 
> >    Some SEV features can only be used if the Allowed SEV Features Mask is enabled,
> >    and the mask is configured to permit the corresponding feature. If the Allowed
> >    SEV Features Mask is not enabled, these features are not available (see SEV_FEATURES
> >    in Appendix B, Table B-4).
> > 
> > and the appendix, this only applies to PmcVirtualization and SecureAvic.  Adding
> > that info in the changelog would be *very* helpful.
> 
> Ok, how about adding:
> 
> "The PmcVirtualization and SecureAvic features explicitly require
> ALLOWED_SEV_FEATURES to enable them before they can be used."
> 
> > And I see that SVM_SEV_FEAT_DEBUG_SWAP, a.k.a. DebugVirtualization, is a guest
> > controlled feature and doesn't honor ALLOWED_SEV_FEATURES.  Doesn't that mean
> > sev_vcpu_has_debug_swap() is broken, i.e. that KVM must assume the guest can
> > DebugVirtualization on and off at will?  Or am I missing something?
> 
> My understanding is that users control KVM's DEBUG_SWAP setting
> with a module parameter since commit 4dd5ecacb9a4 ("KVM: SEV: allow
> SEV-ES DebugSwap again").  If the module parameter is not set, with
> this patch, VMRUN will fail since the host doesn't allow DEBUG_SWAP.

But that's just KVM's view of vmsa_features.  With SNP's wonderful
SVM_VMGEXIT_AP_CREATE, can't the guest create a VMSA with whatever sev_features
it wants, so long as they aren't host-controllable, i.e. aren't PmcVirtualization
or SecureAvic?


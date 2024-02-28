Return-Path: <kvm+bounces-10287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E989386B4C8
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 17:25:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6332B2BF06
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 16:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BB53FB92;
	Wed, 28 Feb 2024 16:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKxY6qT0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01FB3FB84
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 16:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709137374; cv=none; b=RVsI2XQ34X1S/YqySZLsUiOwEYgUtSbluFBtHKcj6quZdmbbgHUA7hv38gXl3C7RH/DcMXdEiEMBStzlSyKvLjUMCjkqnURhEUPkGxg5Ir9//c2FrtO7cabrzYxjCU2QT10ZUhCkLQvC+EC7R6KYhej8VQLDQjwglwA05U9fkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709137374; c=relaxed/simple;
	bh=AZtli4Ue/PpvWMofqUA1KwJ8G1q3Xq+ZA8rm+RkDid0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LPPkX0oKymvf1sfxbHgL3eBWvbh7OM1mrKXMLkTd8HiOpcoB3P2Am+gXrrvLkiGkwrMmmVETY56b0UzOlCGZEpvoc4E3a1F2AJmtQ4NTbk9LirJWg4VT96vUOYKDcemIplFRsxdp4Y0y1Fcwp6CFSnXjXjj1bZtE3mCq/iq6XNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKxY6qT0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608852fc324so92261837b3.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 08:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709137371; x=1709742171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EgTRs3gBzwFgs+8ahOL08VjadrSfP5/zA+WOBgwRs50=;
        b=sKxY6qT0fvz7nKDKm5/pWTX61Ss3wSNGlSJQp8dYwq7hei4ME/CbEM5AB0uYHCY7Wq
         d98VYoNldRGwsHU9WI2y6nrqGuotn7KxmAnox/rGB51kb4dnKth0YETX+NXXmbG7cgfI
         q0o8YBSGrvPaz5TXUdwp+An42YoU0F1jSHY7QXBwGgTGc93GfWolaKxc3zUkHCJulId7
         KSZkqwKOxSkgXoxzJoWI/2Rx3f53j6OG7MiaLsXkwKm1NZXgR4AIS3GFJa1BO3OgpY5D
         OY9JJ14RP54SGj9jphKAzQSAAprmYfP8q9Q3A5moG8cx1o2W+5GL40pnBHZvxGmmVGCg
         Nv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709137371; x=1709742171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EgTRs3gBzwFgs+8ahOL08VjadrSfP5/zA+WOBgwRs50=;
        b=Cd1k9vKeqyKJGLjCAt4+OmGspumNh1DTY9756z8jDQ9TbwcP/uPTuXRsGSeOEIdU0O
         YYRLZp0TXSoNKHUZGmmbgAvjJfKMO2dYol5ydyhGBcrYuZcvoEtrNvku4tt7Te47DbYb
         9yKFCq307TV2pfusbjs0pbRhGE8eRAVe2aTaWC3wt5Sg6BCFSGOviXtYP/AOtKKy+ifw
         AMXr1huIv3uXWQXzmbI6XNjagdLcBawcqfLRCcg50xaR3sSgCbTlPoclifDBRhHYNgme
         DI1J4mOpzEDgtIXnv9x5eXD9wnX+snpnog2HOw87kAwG8u4WPt5cGfQR83M/74VWPlGN
         2TiA==
X-Forwarded-Encrypted: i=1; AJvYcCU4AKhY0JXLHMpHA3sSt/8ITXxZcoItS+7MDBKRTO07oCZqi0u7oxQjo85rJtsSpCgSD3+Zp69aTcSLyBpXZ+dFu/PH
X-Gm-Message-State: AOJu0YxiqzDbNBs41cGYR2Fhsfp0M8uJ2pNIeOF8BcaEtdY+kZPsvPzZ
	vn5Acj7JEqLqggnPH1iYLbH+lee9VlOQ3+xFUQDOgiwNEXHd5+9rEYLSv1jOHQmJqwXmnPzPaDt
	yaw==
X-Google-Smtp-Source: AGHT+IHu08WDGsGzi3/h+E6zWeMDAUXwKh3h5g4CsmmDMvrRnHRhYOeB1F8aqwaFBlV2xjlGSdQQvDg7kXo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1507:b0:dc6:e1ed:bd1a with SMTP id
 q7-20020a056902150700b00dc6e1edbd1amr823087ybu.2.1709137371681; Wed, 28 Feb
 2024 08:22:51 -0800 (PST)
Date: Wed, 28 Feb 2024 08:22:50 -0800
In-Reply-To: <6c10e17a-b1f2-c587-fbdd-85d15256b507@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-5-seanjc@google.com>
 <6c10e17a-b1f2-c587-fbdd-85d15256b507@oracle.com>
Message-ID: <Zd9d2n3k8c5pTJto@google.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Pass full 64-bit error code when
 handling page faults
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, Dongli Zhang wrote:
> 
> 
> On 2/27/24 18:41, Sean Christopherson wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Plumb the full 64-bit error code throughout the page fault handling code
> > so that KVM can use the upper 32 bits, e.g. SNP's PFERR_GUEST_ENC_MASK
> > will be used to determine whether or not a fault is private vs. shared.
> > 
> > Note, passing the 64-bit error code to FNAME(walk_addr)() does NOT change
> > the behavior of permission_fault() when invoked in the page fault path, as
> > KVM explicitly clears PFERR_IMPLICIT_ACCESS in kvm_mmu_page_fault().
> 
> May this lead to a WARN_ON_ONCE?
> 
> 5843 int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> u64 error_code,
> 5844                        void *insn, int insn_len)
> 5845 {
> ... ...
> 5856          */
> 5857         if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
> 5858                 error_code &= ~PFERR_IMPLICIT_ACCESS;

Nope, it shouldn't.  PFERR_IMPLICIT_ACCESS is a synthetic, KVM-defined flag, and
should never be in the error code passed to kvm_mmu_page_fault().  If the WARN
fires, it means hardware (specifically, AMD CPUs for #NPF) has started using the
bit for something, and that we need to update KVM to use a different bit.

> > Continue passing '0' from the async #PF worker, as guest_memfd() and thus
> 
> :s/guest_memfd()/guest_memfd/ ?

I've been styling it as guest_memfd() to make it look like a syscall, e.g. like
memfd_create(), when I'm talking about a file that was created by userspace, as
opposed to GUEST_MEMFD when I'm talking about the ioctl() itself.


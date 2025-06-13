Return-Path: <kvm+bounces-49514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 172C5AD9622
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 643151BC1C2A
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0525A257429;
	Fri, 13 Jun 2025 20:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="00ugCWC1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2A224A06A
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749845802; cv=none; b=FBfWwWDewFISK6TV2ILP09qWlxokOTCTK6KJY59szD6hxFXOE3vgwXw/2jVY/dons0mMD4JxR7s3vCu/8f2KtMu0IMwTC0BZyYSYHw4nmt/TUldB1jr0Dg6Ck9DJIHeq0pY63ek2uJ6O2Sq9Yg4nb2uttPGbaQgZHrJ2E7/F0Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749845802; c=relaxed/simple;
	bh=gTVV+suu80KdrU+ps4JrdTsQfs2Hxb28mx4LhYC0YzQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AQ6QU3xl3oei7CM/vD14K2bS0l3eWtJP2UxBR2RlNIvnVH3t2NL1R+7ss506bllVtS0iAJJJPoK747OgvWyh1QfZnzmPD/ZUp6949JXaL7LKUji5vzjLwfVIXxj9cQj5zLO/LwbEvRhGffWPr3WwH1xCmqwGZRIH4YssOx5Sbvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=00ugCWC1; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c36d3f884so1745581a12.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749845800; x=1750450600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j8crcznM3ZaoYwyfolgyowPDywStqZX/ibW9wOaZqL8=;
        b=00ugCWC1fpA2Ul4ARDGjOUed634VE0k0+51HQsI9zW+DYBPEG33789xxWhBqxjKJTS
         1e5/6H0qdBkcK7C60+oyD/8Pfzds1bqWAG+xetGahT+q1GNvFcZzEGq/mgGw7pSsRmXB
         u20WcfNI7aJ3w5a6gNMwwx5rl0Ica6jQUspJnlK26AAvsnyFJlTs43+c0EmjHuoiu5ee
         rkoANT7OZXP7f7KzdC6keg4kTvgub8NJhYXdoz5nwEOkCVhbxGG8740EZjeatfDlUoVn
         x/98iwA9a0XUTVWu3V585AhP6F9o4N0SEkLN8GG5dxAc6WHp78oa8MTRt1mGIjitovzV
         ay9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749845800; x=1750450600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j8crcznM3ZaoYwyfolgyowPDywStqZX/ibW9wOaZqL8=;
        b=Tseka+0NUzJv984KmJJjoLUPPmn8B2vukfOhheJyn43L0g29/FnufgLlZSl8FJfZHb
         bIO6OLMYG19eZX6uzfMdokpmKQEb43NohH5wGhX4zqC5LexCe+/Kk5aO5J2yOoUkGqEv
         u8NaSjJqR+aglS2T5emAsvEmDzTLcKM8tO/3VDlBwBCsLuxAvmnOLIPNM4rKmhNy21Rl
         v6aHdNtnqKcveLQkrzOrZceSJDuu7mRgI8+aFx4+AGbKOKoN+bGITA0O+RUbQgdo3Oll
         xVme3E90+imXlAIkSgv0LGtKGe5AR6483Bldd0chDde81Gi15C8jmml02MFIliSpjkmq
         vqpw==
X-Forwarded-Encrypted: i=1; AJvYcCW/9olT9nLvPdTJBKzsK2iRSx73X9FIMtoSOMYn+mueT4XNKX1Crs/l3DHNJuJyUIUowhc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsJol/Wrw0FEuP4nbKOslKm8aCh2wWD1+x9Q/H9g1u+pch0Cji
	CfXaAzbGaDTEUXYNtJAohnEjveYVEUYoxM9ZanhalRmsM8OXPuB1IbIGDw+iO8fyth0wgcb2RqL
	9YGM+OA==
X-Google-Smtp-Source: AGHT+IEiAetaI+89aihaa4gzEoo2ZAl9jtG5VdIpcIRh8HZt4Cs8pqUG+YboDBBirpw/HkYzrzcdv9vN4Q4=
X-Received: from pgbct9.prod.google.com ([2002:a05:6a02:2109:b0:b20:93aa:6141])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1512:b0:21e:eb3a:dc04
 with SMTP id adf61e73a8af0-21fbd495d28mr946071637.3.1749845800007; Fri, 13
 Jun 2025 13:16:40 -0700 (PDT)
Date: Fri, 13 Jun 2025 13:16:38 -0700
In-Reply-To: <aEuURZ1sBmSYtX9P@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612044943.151258-1-pbonzini@redhat.com> <aEuURZ1sBmSYtX9P@yzhao56-desk.sh.intel.com>
Message-ID: <aEyHJuxo4aPUlmgV@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Reject direct bits in gpa passed to KVM_PRE_FAULT_MEMORY
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 13, 2025, Yan Zhao wrote:
> On Thu, Jun 12, 2025 at 12:49:43AM -0400, Paolo Bonzini wrote:
> > Only let userspace pass the same addresses that were used in KVM_SET_USER_MEMORY_REGION
> > (or KVM_SET_USER_MEMORY_REGION2); gpas in the the upper half of the address space
> > are an implementation detail of TDX and KVM.
> > 
> > Extracted from a patch by Sean Christopherson <seanjc@google.com>.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a4040578b537..4e06e2e89a8f 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4903,6 +4903,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >  	if (!vcpu->kvm->arch.pre_fault_allowed)
> >  		return -EOPNOTSUPP;
> >  
> > +	if (kvm_is_gfn_alias(vcpu->kvm, gpa_to_gfn(range->gpa)))
> > +		return -EINVAL;
> > +
> Do we need the same check in kvm_vm_ioctl_set_mem_attributes()?

Yeah, we probably should disallow aliases there.  It should be benign?  Because
memslots disallow aliases, and so the aliased gfn entries in the xarray will never
actually be consumed.


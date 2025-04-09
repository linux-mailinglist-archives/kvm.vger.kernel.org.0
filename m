Return-Path: <kvm+bounces-43017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71647A826A9
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 15:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D25A94403B1
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 13:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E7B263C71;
	Wed,  9 Apr 2025 13:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a/ieZLP2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C715248888
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 13:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206553; cv=none; b=eZbxU9PP3ar/7nqOhAsmipgecpSr2CAinchl6bEGLfAHrw/zAq8FqiYsveh5Lszsi/RyIF4vUsC5Uqkz92Qf52pJjXi38Tgb9o3iH2B55n7xx1GmW5HfFyoGKEsSj4jiwHWzfZLHMoCwRvMahjqPOft4P0gWzBIGYMUAgL9XksA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206553; c=relaxed/simple;
	bh=qazo7pIcfpNl+Sm7ZFsywYC/dbBgkDLaEHB4F2bqny4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fgoqtgaP5pa7ZjDc//M3fYRP6uLdWae8Dngx9mtJy1b9yTySq6+Wl3WzaIDxYFF7WR9kElxQNiaunq6Oa8f/7gcdk8RtebxuV16gLjZB4pcBeeBwWGk0RajT4zPiXdF9UUBYRRYpuzgndtqO75L645SAITHPzernTEtQBWFp2jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a/ieZLP2; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af9564001cbso4494075a12.3
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 06:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744206551; x=1744811351; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y73w31igBWLsQE77UitAErwv5VKNvNqUriamUlq9OdQ=;
        b=a/ieZLP2/K6W4o7MTqPaF+hqcXd4oLA3832BPpOXzGOcMueFmDqB3o9rqLb3UaTJYC
         A7BL6PaHdAcRSyYivawISoVPVAkrMV+UYYy4mkMu9jL+5wPap+Id+wqE/cpIGRPIU5Ax
         vSFM5uO22wVEkcKugzKDzNRn/PC5B/TqswbSiBiCT1ztzs1TV5HDMJCxvwcdbrejyEDl
         kbZViogaFxV1a4QgW1XSzl3rpj2sXO9Dai7tW1S6JJA35EORBvrKBzqYIcwoNiLp3f0m
         yHpg0MoFh1j0ehtRwDjoWhHQntehn+FdkWZnmbpu2YpbqFGf2Lp079QS4VuW1X4kCE8n
         TdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744206551; x=1744811351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y73w31igBWLsQE77UitAErwv5VKNvNqUriamUlq9OdQ=;
        b=bEwlydNsRG5/yDYTZa1KozPqe60un9fkgWEJYZYh2rw0LHkCibFNBSHmmJGMBpGP86
         61KrROHIBH1Dv1Mde25urKntZ/9rvAypGY74A05jHQyIyXDHfVELtByPPd9qneVd6vJx
         Z6xNQweWZR7BvP+vRqnFuetTh8pH5FtSffme97+qy0CChzA6CJRendQwXBNJUnplW7y5
         QHVY6UyRu5axZLRi1SPk1Y8Jjg7UXhJjGu5JEYSYOIC9ZIPI8+4OFU9S/FGv6nCyIer3
         rGduUs+wEy23celI4yVYZ2m38d/ZJSga9UT9sgQYk2sjQmEOlkP8XWj+Jnbqst9e2T+X
         oPUg==
X-Forwarded-Encrypted: i=1; AJvYcCUhO1FDNsmZdfs0iZ0kBSyTlEqcF/k5eRVZWzt0vr/3ZzE32oLvoKiw35I3V48dnneBkSI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL1D7+lZK5KWlXdhxJbwjNteZxxzeILjeBz0iy0ZkObf6iOdOd
	KjzaL5LQhEjCXdVKhqYIVugl17xQlYyOh1ndbdqkFk/VlgJo1/AEin7eS6LJ3EwRYtn2l5u2J0h
	Xdg==
X-Google-Smtp-Source: AGHT+IE1olvuaLq50nGKQrjOpbHUBUDesPetDQk8Ddyx/FU4wlnq3LPxsqnE/CiEUPfY3sWR2RK3WNzBKwk=
X-Received: from plbkx11.prod.google.com ([2002:a17:902:f94b:b0:21f:56e1:c515])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc8:b0:224:c46:d162
 with SMTP id d9443c01a7336-22ac2992075mr42310655ad.20.1744206550496; Wed, 09
 Apr 2025 06:49:10 -0700 (PDT)
Date: Wed, 9 Apr 2025 06:49:09 -0700
In-Reply-To: <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
 <20250402001557.173586-2-binbin.wu@linux.intel.com> <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
 <112c4cdb-4757-4625-ad18-9402340cd47e@linux.intel.com>
Message-ID: <Z_Z61UlNM1vlEdW1@google.com>
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Tony Lindgren <tony.lindgren@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 02, 2025, Binbin Wu wrote:
> On 4/2/2025 8:53 AM, Huang, Kai wrote:
> > > +static int tdx_get_quote(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > +
> > > +	u64 gpa = tdx->vp_enter_args.r12;
> > > +	u64 size = tdx->vp_enter_args.r13;
> > > +
> > > +	/* The buffer must be shared memory. */
> > > +	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa) || size == 0) {
> > > +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> > > +		return 1;
> > > +	}
> > It is a little bit confusing about the shared buffer check here.  There are two
> > perspectives here:
> > 
> > 1) the buffer has already been converted to shared, i.e., the attributes are
> > stored in the Xarray.
> > 2) the GPA passed in the GetQuote must have the shared bit set.
> > 
> > The key is we need 1) here.  From the spec, we need the 2) as well because it
> > *seems* that the spec requires GetQuote to provide the GPA with shared bit set,
> > as it says "Shared GPA as input".
> > 
> > The above check only does 2).  I think we need to check 1) as well, because once
> > you forward this GetQuote to userspace, userspace is able to access it freely.

(1) is inherently racy.  By the time KVM exits to userspace, the page could have
already been converted to private in the memory attributes.  KVM doesn't control
shared<=>private conversions, so ultimately it's userspace's responsibility to
handle this check.  E.g. userspace needs to take its lock on conversions across
the check+access on the buffer.  Or if userpsace unmaps its shared mappings when
a gfn is private, userspace could blindly access the region and handle the
resulting SIGBUS (or whatever error manifests).

For (2), the driving motiviation for doing the checks (or not) is KVM's ABI.
I.e. whether nor KVM should handle the check depends on what KVM does for
similar exits to userspace.  Helping userspace is nice-to-have, but not mandatory
(and helping userspace can also create undesirable ABI).

My preference would be that KVM doesn't bleed the SHARED bit into its exit ABI.
And at a glance, that's exactly what KVM does for KVM_HC_MAP_GPA_RANGE.  In
__tdx_map_gpa(), the so called "direct" bits are dropped (OMG, who's brilliant
idea was it to add more use of "direct" in the MMU code):

	tdx->vcpu.run->hypercall.args[0] = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
	tdx->vcpu.run->hypercall.args[1] = size / PAGE_SIZE;
	tdx->vcpu.run->hypercall.args[2] = vt_is_tdx_private_gpa(tdx->vcpu.kvm, gpa) ?
					   KVM_MAP_GPA_RANGE_ENCRYPTED :
					   KVM_MAP_GPA_RANGE_DECRYPTED;

So, KVM should keep the vt_is_tdx_private_gpa(), but KVM also needs to strip the
SHARED bit from the GPA reported to userspace.


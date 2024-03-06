Return-Path: <kvm+bounces-11148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E49873997
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0A6AB23BA5
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1381339B1;
	Wed,  6 Mar 2024 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fO4eZYii"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CB480605
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736336; cv=none; b=SsMxSuZ4oYDXaRdt0tRLD/nlUzUExSEnet5Joy4NSt9IvvaEc/AlIrTTdnT8jq689omtoB9udoYARmg96QKiKa2fnLOXf+CouxK9m84pWK8cbATJQ/P+B5bBt8/thON5ELEGrkAsbdzspNCRl4nII1Y0RBzuJURBIj6Fw8lywX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736336; c=relaxed/simple;
	bh=4qDDeM2GJDKd/s57z1lZPEZLMCakZLt6IBfNNHqraZo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uaxT5g+2Qxe67G3aABVNxyXnwA/Tt+REYFCRLocC8X6co1dBdiZT9q4E6Hy7Pii3O636zZwhfHiKyfLeY41dZhbNVZcKf0ComO98I1iShgAVmgG+wybW/N/T5gtrAmubtK2Bzfun/ssLpnF2xfUDfTKskBQJ5IEOCQ7PUadpROo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fO4eZYii; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-608dc99b401so118502367b3.0
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 06:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709736333; x=1710341133; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uXZjsUmARj2Dgx8DrIwjJBZxc3BuQgEpxgkrz4sv/pc=;
        b=fO4eZYiiZbLb+jgFcDnOpzCS7LRKR0TVitfQpVWuX74/rmiylbXs5M3dpAyTJHjHlB
         Oml5abGBKoVLTcZVtWgakc6aexABidmWoEaqHK+3i2VcUntamIv/uiF+mnT7rO5E8IDN
         cGJUODWg/WP0Z0Z/wldHdQjrxO+ke+y4PkdDduPeUamkN+ZTqUgzXWZFQAKCv2it1T06
         fbZQ+Jm3yjXidiu+7mWWaMACsu5BI5H0x3lfIRUO78PQmhYbuEzcCdngEiksXBq3yGX4
         daUu7ueg0hND1CC/3kCfR0I1XujXM7z1Bk1fTYK94y1D8tihpCLPdwBK5gYu2iM5U8rk
         mSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709736333; x=1710341133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uXZjsUmARj2Dgx8DrIwjJBZxc3BuQgEpxgkrz4sv/pc=;
        b=ObSCOtEQJ97Yk0sPU2HVlHX6H9sj2PEOT+HLqNXBHvcdlBXXlzJIJa5nbbX0UcFm/N
         n/L/pbNa+UI8RM7vS2yzLBCUCoY/qL6Llg5qMhN7L/BzH/rVTC/Hpb0H//R5AkBONdtJ
         /BiS6Hnwl/8CLoA2jnreWFyzRnOw/wud492x3YxPVfLocTH/ytgtI9KGKAiBnBHopw7j
         CTgQ8FX5YX+ZB1GzTpznWbhUzFUUE7MLkND1Vzb97ueM8JZFkl3/ifImmms2pICQYr4u
         O4yX6xnJXlfDKpvEq/HY4i47+jDFWxfK5u80gL7f/dkCYoXv1YgdxwQ6o3ZW5BCayOPS
         ypuw==
X-Forwarded-Encrypted: i=1; AJvYcCXsaRhmq5KJ7uYHAWTBFXHCTOLC4TqX29rmlNq5eWhM+uFN+u2vtHfZpjyBGBDV8+fVrUdr0k4FzLZnY14Y5oJtpss1
X-Gm-Message-State: AOJu0YyGRlRbG89F29BlOiYG5vQpZ7J8+zcDeNj6hau4qdzWhuDueHcf
	fa9SldK0b0Z3pJhwYEkE2Vi8gsdoqUKzLJccan8Bp/lZAs2MinQn6DbTxIO5EQ4SuN7x05X/L50
	p5w==
X-Google-Smtp-Source: AGHT+IFag51vL/UvoYhlWt+cP5hn/hFVKq6JWZ8TC7/r3Y68GfcXp0uRyzr/BSVM0D4aSJiRiUKQoyXIzXc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3507:b0:609:3c79:dbf1 with SMTP id
 fq7-20020a05690c350700b006093c79dbf1mr4263672ywb.8.1709736332428; Wed, 06 Mar
 2024 06:45:32 -0800 (PST)
Date: Wed, 6 Mar 2024 06:45:30 -0800
In-Reply-To: <Zeg6tKA0zNQ+dUpn@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-6-seanjc@google.com>
 <Zeg6tKA0zNQ+dUpn@yilunxu-OptiPlex-7050>
Message-ID: <ZeiBLjzDsEN0UsaW@google.com>
Subject: Re: [PATCH 05/16] KVM: x86/mmu: Use synthetic page fault error code
 to indicate private faults
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 06, 2024, Xu Yilun wrote:
> On Tue, Feb 27, 2024 at 06:41:36PM -0800, Sean Christopherson wrote:
> > Add and use a synthetic, KVM-defined page fault error code to indicate
> > whether a fault is to private vs. shared memory.  TDX and SNP have
> > different mechanisms for reporting private vs. shared, and KVM's
> > software-protected VMs have no mechanism at all.  Usurp an error code
> > flag to avoid having to plumb another parameter to kvm_mmu_page_fault()
> > and friends.
> > 
> > Alternatively, KVM could borrow AMD's PFERR_GUEST_ENC_MASK, i.e. set it
> > for TDX and software-protected VMs as appropriate, but that would require
> > *clearing* the flag for SEV and SEV-ES VMs, which support encrypted
> > memory at the hardware layer, but don't utilize private memory at the
> > KVM layer.
> 
> I see this alternative in other patchset.  And I still don't understand why
> synthetic way is better after reading patch #5-7.  I assume for SEV(-ES) if
> there is spurious PFERR_GUEST_ENC flag set in error code when private memory
> is not used in KVM, then it is a HW issue or SW bug that needs to be caught
> and warned, and by the way cleared.

The conundrum is that SEV(-ES) support _encrypted_ memory, but cannot support
what KVM calls "private" memory.  In quotes because SEV(-ES) memory encryption
does provide confidentially/privacy, but in KVM they don't support memslots that
can be switched between private and shared, e.g. will return false for
kvm_arch_has_private_mem().

And KVM _can't_ sanely use private/shared memslots for SEV(-ES), because it's
impossible to intercept implicit conversions by the guest, i.e. KVM can't prevent
the guest from encrypting a page that KVM thinks is private, and vice versa.

But from hardware's perspective, while the APM is a bit misleading and I don't
love the behavior, I can't really argue that it's a hardware bug if the CPU sets
PFERR_GUEST_ENC on a fault where the guest access had C-bit=1, because the access
_was_ indeed to encrypted memory.

Which is a long-winded way of saying the unwanted PFERR_GUEST_ENC faults aren't
really spurious, nor are they hardware or software bugs, just another unfortunate
side effect of the fact that the hypervisor can't intercept shared<->encrypted
conversions for SEV(-ES) guests.  And that means that KVM can't WARN, because
literally every SNP-capable CPU would yell when running SEV(-ES) guests.

I also don't like the idea of usurping PFERR_GUEST_ENC to have it mean something
different in KVM as compared to how hardware defines/uses the flag.

Lastly, the approach in Paolo's series to propagate PFERR_GUEST_ENC to .is_private
iff the VM has private memory is brittle, in that it would be too easy for KVM
code that has access to the error code to do the wrong thing and interpret
PFERR_GUEST_ENC has meaning "private".


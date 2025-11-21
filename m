Return-Path: <kvm+bounces-64236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C57C7B6BD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 755A73A6059
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC9F2F659C;
	Fri, 21 Nov 2025 18:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PwbL58KM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107622EFD9E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751542; cv=none; b=KUbbbBf0r0DC35RlNSY/fcAhcRvADcHxIejhzk4Fvmvju1iG6wq4bkSdzDBkKIUZ1VznK3JsrE9pDPF9xYx2Z2dmGCrj1BvnAZemcc7Poc3Mw/rlBdMLla07pPdGE4767B6c3i4b6fuEtJoWNfyga+VRjpxFY8F8Y1jsvRim+Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751542; c=relaxed/simple;
	bh=SU9bNEdaDKh7mOM+mVSGarP0ZpJC5sbY8V/e3Pee0U0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HEkapi9ahFDUU8h5HsEx3mifA0Gkig14JS+NNBLM1Huo+uYWcIcRVvuknYWxOoRQ0+Amvi9qD+NmKZ6n2nL8+nwvtjux/VrW//bHqGDMyYeNxTp53b1yqE6XWXGfT98xIcwyd4kUADKAL4icU0QLY42J5jemQuVSYpWEQqnRH9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PwbL58KM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436e9e3569so5058007a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751540; x=1764356340; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=//TKb8hymvAxEf/QRG4A4e2YWKP48bUzqXRB3PNbsfE=;
        b=PwbL58KMYcqa48l9vd1H4Eobul/hxn/vNrn82Fei9sUZXGxikKdZWmganSwI8q2oIb
         F0H/exCd7gnuPJoJR/mUMSIZmUPBWj1jCyfuts43vkCAVnzr4G7mK/9Mh+4uDWLuSDSO
         Eb7GI6fqDqlL787DhOTI4eeQ7ixwx/esZ5dVTyeWRY+2Ym9QEQIkpCdb0lWmeypvZE7D
         araBo0fh3U7fTIQz4cBkeLEd94kamVBNoxC2OZErOJC7Wq1S4PobDWrflucbZgPjwr2O
         gXQ5WL6DjmuegKcQn3aLeLoCuuZZPdsBgDz8BkqonPw0ciHuEjKZtXgoZHUTUd+sZeKV
         SKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751540; x=1764356340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=//TKb8hymvAxEf/QRG4A4e2YWKP48bUzqXRB3PNbsfE=;
        b=TM7kTgyuvtBov1pOaop+XxXGURY/Ucc9kFmlhk9lTPqShyt/fLtuSk1Xeu6RV4quT2
         D5ovTES8tOgKStLqq3xa/H32VS7j9K/PR9aX9/2iXtwSiuuFTjx2fFEZS0CnMoXbUYLa
         xLzGaNqPcaZI7hAhILY9FHt4bk5iojFf5rIEQqcPQbsK86omPGOSq3akX3iPulc7I+iQ
         ftfbBvaxduhr1n/hsfs1JUTNBExIVz3UiGl7/GvtwPn05uSrO1QukYlKxgOERFv8diwA
         uDQBcHhJmcgI9cVEinT6U0ezPiA6bcgye1wUAKuMaqByz4J/rhMiOU6ZoiAYSJJ8pqHS
         6PKw==
X-Forwarded-Encrypted: i=1; AJvYcCUv3tdWd6L8lYI+24DLHM3yugJSKeEXBv8ccAfP+6v2q5YSDJH2fS543CBORaLeVQvzjbc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIvdnZnUs11wYF7UmEFawgloQlTnADlimaxwZFmD19Rjoe056l
	079tHEvC/P0EIsS7gX3kNG7iT3foJlAH+2PZOUO7KjwHL7c71qXJTqKZ0wB8GjboFHLNaE90Exo
	xR8q9EA==
X-Google-Smtp-Source: AGHT+IEBvBp8jh0vOplCCD1S1V2MlG3rW1W9lkVPvmTObu/2p/kVSWbhD330IykVz/Yn0SKN5rKC88D+4vs=
X-Received: from pjbgg24.prod.google.com ([2002:a17:90b:a18:b0:343:4a54:8435])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fc8:b0:340:776d:f4ca
 with SMTP id 98e67ed59e1d1-34733f34cfamr4082112a91.26.1763751540452; Fri, 21
 Nov 2025 10:59:00 -0800 (PST)
Date: Fri, 21 Nov 2025 10:58:59 -0800
In-Reply-To: <9098c603-70c0-4a22-a27b-4917ec0601d9@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251118222328.2265758-1-seanjc@google.com> <20251118222328.2265758-3-seanjc@google.com>
 <9098c603-70c0-4a22-a27b-4917ec0601d9@linux.intel.com>
Message-ID: <aSC2czXKanvvtcLJ@google.com>
Subject: Re: [PATCH v2 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside
 of the fastpath
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Jon Kohler <jon@nutanix.com>, 
	Tony Lindgren <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 21, 2025, Binbin Wu wrote:
> On 11/19/2025 6:23 AM, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index fdcc519348cd..f369c499b2c3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7062,10 +7062,19 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> 
> I think the bug in v1 is because the fact that the function is the common path
> for both VMX and TDX is overlooked. Do you think it is worth a comment to
> tell the function is the common path for both VMX and TDX?

Probably not?  Addressing that quirk crossed my mind as well, but there are so
many dependencies and so much interaction between VMX and TDX code that I think
we just need get used to things and not assuming TDX is isolated.  I.e. trying
to add comments and/or tweak names will probably be a game of whack-a-mole, and
will likely cause confusion, e.g. due to some flows being commented and others
not.


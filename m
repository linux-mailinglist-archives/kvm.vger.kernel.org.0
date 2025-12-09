Return-Path: <kvm+bounces-65591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E00ECCB0E86
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 20:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE31330D21C4
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 19:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879D03043AD;
	Tue,  9 Dec 2025 19:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gesjMQDC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DD53009D2
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 19:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765307369; cv=none; b=g1XDQQqGirBdxuuj7yDhNEIYKgcJ9Gly9/C+eDzDYDJfyBCN4d6qMVNTHVwINiRngMivJhM51CzC4gck2W+wIKhmMk+2TBCSCczdunk42czBH2s7fwoTxmJIV/InKt7C8HqDslyByqG63HgfpSgtmEZyv1bmUzZ//14fztFWzl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765307369; c=relaxed/simple;
	bh=AKRCK10httPUpsfIsozNrU8rIgFvEI8pGNv58sPqFH8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nU1YUC5rlt3JBXb0xRBcpheUuZ+0/fyKmNA/Jz6m/igsSV911y8ChU9GThUh6orMXM/3mxM6iCtkfKoSCsaFcOnoQ0wZ2HAaY+EiTNyR2O+R4ZTpYtOzt/YOqSTPgCsDkCoCn6ddDfHYJ+x0PkbdJCc2W5xIEQneZ8WAr63dT2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gesjMQDC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297df52c960so118591585ad.1
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 11:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765307368; x=1765912168; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+giF8mL26uEbtfneOyr+J5vU3y99exuZf5m0Ub2EEio=;
        b=gesjMQDCxVwzw8XNyTWdvD1xNrbRuicnhXlQmbzBmbxIIhC4xmC/iJ361zffTOhmSw
         rLLOQ0rwA9CtJbo29u3rMt+xHpiSyoIGUVZcCbys3rTC8YJCofywQPcWiwP/dcoaklf0
         lKhYHhH/KIf7fw8l+Nl8NsV7qsBvOIN2Z1yD76+MhpcTZ38TngAukM0El4N4TIgzB9CB
         52SMnueLdLhNI6YRTDm/Cd+eqmhFRNAAg3aIg9oITvML8stleiZbCsBLOXwmpVrGqJGl
         9bJi9yQB3t6Fekb3F8XEG58BgdkTTIcghyE1fB4Z95jbUjBSN2J7TzvKRaPa8OnLYtia
         itjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765307368; x=1765912168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+giF8mL26uEbtfneOyr+J5vU3y99exuZf5m0Ub2EEio=;
        b=ubIM5LqvqXaO6QW+IODf1442wsq6CxuvAUJuwjppZjNetOpXv9hWOYKkJyO0Rtu3PA
         sFWgyV1ytpfJqLxLsCPjZADa3BW+YYxH9FisP1HFAveW3Z+3/gaFPmWcOPKJwLFdOj3R
         i2+3wYKruRo186dzhLZwynB2WZ6GThO063VzA5XUbV5AL09P8xphr2ihgzrVTFcLwP9c
         SpB6UcBlZPJ/0ZgzKXOxHXP7fxSrH0sK+5EZAU7Qtscpv4t31BBnPGpxten+v+BU1vHg
         jS4+Uozi+XrLUBLNNEqX7SBWkCgVEYy2ts9EPVxv1QTxwPJDIwCG2OE9F2w6j3GscvyA
         zPpA==
X-Forwarded-Encrypted: i=1; AJvYcCXAGzBka/AOkQA5H8FeZaPjPAtJHTdncN5qXCN9sVVyaRS3LgMC4BpXA/5UvC6lj6sXtPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA7Y2qCptdVVbYuf4PAz8fYvi3VpQGgV0sB6zHnbttoNmv5hqO
	wVpvmYjY/KkU4AKIHL7zyobL9H/EsZ5whC1rAz+KprNLMUUQObx2YvmUoNtou9gLoqAoFGfy+m6
	Wciui8A==
X-Google-Smtp-Source: AGHT+IGQxCsti82tEY6F0MhGhWkC5Srn/YOIFGdNF2lWWCBwYchQdRKew0UCHcFTlSgWpkeJ0BHpC6M8dgc=
X-Received: from pjbcl7.prod.google.com ([2002:a17:90a:f687:b0:343:4a54:8435])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce09:b0:295:21ac:352b
 with SMTP id d9443c01a7336-29df5791a6dmr111946315ad.15.1765307367683; Tue, 09
 Dec 2025 11:09:27 -0800 (PST)
Date: Tue, 9 Dec 2025 11:09:26 -0800
In-Reply-To: <ttlhqevbe7rq5ns4vyk6e2dtlflbrkcfdabwr63jfnszshhiqs@z7ixbtq6zsla>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-12-yosry.ahmed@linux.dev> <aThKPT9ItrrDZdSd@google.com>
 <ttlhqevbe7rq5ns4vyk6e2dtlflbrkcfdabwr63jfnszshhiqs@z7ixbtq6zsla>
Message-ID: <aThz5p655rk8D1KS@google.com>
Subject: Re: [PATCH v2 11/13] KVM: nSVM: Simplify nested_svm_vmrun()
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> On Tue, Dec 09, 2025 at 08:11:41AM -0800, Sean Christopherson wrote:
> > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > > Call nested_svm_merge_msrpm() from enter_svm_guest_mode() if called from
> > > the VMRUN path, instead of making the call in nested_svm_vmrun(). This
> > > simplifies the flow of nested_svm_vmrun() and removes all jumps to
> > > cleanup labels.
> > > 
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/kvm/svm/nested.c | 28 +++++++++++++---------------
> > >  1 file changed, 13 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index a48668c36a191..89830380cebc5 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -1020,6 +1020,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> > >  
> > >  	nested_svm_hv_update_vm_vp_ids(vcpu);
> > >  
> > > +	if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
> > 
> > This is silly, just do:
> 
> Ack. Any objections to just dropping from_vmrun and moving
> kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES) to svm_leave_smm()? I
> like the consistency of completely relying on from_vmrun or not at all

Zero objections.  When I was initially going through this, I actually thought you
were _adding_ the flag and was going to yell at you :-)


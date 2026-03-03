Return-Path: <kvm+bounces-72482-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aG83AK8upmkrLwAAu9opvQ
	(envelope-from <kvm+bounces-72482-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:43:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 920CD1E74FA
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:43:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 91B0C3120634
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72322213E9C;
	Tue,  3 Mar 2026 00:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zEKK1Sv2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A6D191F84
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498101; cv=none; b=KuFkQXMM+HNTovRoPoYc8eh+tVGXLLYdec8/XopJeu8bwt+85ByLZYZ2t/wRi0H50BEU6yVb85j1SwY7DkI2Aq1i4SXgyVuInQcirlaE9o0rdPYJE2RTIPt/KBVOGfP/AJvltXvykswl+3k0/Xg3f0ZM+5/8Wi5AKQnzHdMBVlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498101; c=relaxed/simple;
	bh=2SXId4ZTQ02esREDxKS8Gi63uX+2hOVPZ9qKUmge0Ng=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g/yDJy4MuK4nK5jsB9Ii2PBhYay5Ow3VU9HtH5jW7nXIUthYG0ayojAcha99w5DjXXF0JO3jR1frTtBTY+1HQ2YTbk8rIOapt2afJmYKFnarvDPpakdzO8i5Pz6EQOsaCVB4GL4j/PISGyGDmyCE51/ko6Se9Wyw/QmcG0kehGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zEKK1Sv2; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae48a21d12so13573375ad.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 16:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772498100; x=1773102900; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1OhjXzoDILwKrg8TJ6fjwsIjTmjTK8ClLKwqFV0gNH4=;
        b=zEKK1Sv2rktGdlq5tojWwSV5OnAJRfXfEo9T+UUNTlxyieR6tICnX5EfKzaGTdCWAM
         noyqx8SbSod/mKPDOVPanPx1F5R0y+mw4jVjUnzR7hyFYXDXNiizx3GnNxw9+B0EnO3t
         sHx9LOSi62+qeqgMm025JiKqYdsluIwolu0YvsPjMIA55Aa3Vn183TR6eWhSSwhZuDw3
         AxTbhMtSRejB1xNkPwuhJV3HbaVe3AECC+PqO6gGo4tbB6skdMGgE0rYzraDucuPh+Lh
         jGNKk+c9j6y8kPGDKtq5HnywHT10+vlZE8rIHX0hZqzmSmgyhgX6i2xZrk2NpetZMyIV
         r6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772498100; x=1773102900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1OhjXzoDILwKrg8TJ6fjwsIjTmjTK8ClLKwqFV0gNH4=;
        b=BebDEwFzlb/lcdWfbHYIK1gTUN/dher9TWBghHr60kOOqW7tIS8SBA4ar83DIG/mFw
         V1D64NZ3D1NHHbs4Gmex5qZ58FEGRkeNu/FdGUqUq3z/jV/T52HnVkYFBt/cQ6CTSJN5
         5/6By0ZE+iZcNbqJvwHq8bumWCqBII1ZH5HDTQONKxxZ4sBn+vtcexF0g8KvJJHWkjmr
         +Ag5jjK47ze7xzWVZ/RObM2VsgNB63g8G6Xj3OqGwZkIMNzi0qVN0LD7s3ei4lH/pho6
         +U4XL3u5yjAqxlwizFa/6dDlzuQ7PZGvq7yXYopDyylUAo5Pk/HPUWi+y4aK246wl5EF
         xy/A==
X-Forwarded-Encrypted: i=1; AJvYcCXsMSyyMImVbuq9pK88HiB63r7GDBJzZC+3tJD7L/M7GMdOgPA+c5gqAh32iCoQORluUAo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsE3zz9eDwizD4L1pz9MK1ZbnTn2yXM4QRzkR7tSRQqPffqIap
	3w4pjYe3lZtF3ckEVMReyBQZw0uFhH+Rn8qfZSj93T2LK2cL3+5JC3bcmRYOwZg9ngFbop9KZEe
	5nfNNvA==
X-Received: from plgd14.prod.google.com ([2002:a17:902:cece:b0:2ae:3b07:ebc4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d591:b0:29f:2b8a:d3d
 with SMTP id d9443c01a7336-2ae2e3ce596mr127608505ad.4.1772498099794; Mon, 02
 Mar 2026 16:34:59 -0800 (PST)
Date: Mon, 2 Mar 2026 16:34:58 -0800
In-Reply-To: <aaYanA9WBSZWjQ8Y@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com> <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
 <aaXXs4ubgmxf_E1O@google.com> <aaYanA9WBSZWjQ8Y@google.com>
Message-ID: <aaYssiNf7YrprstZ@google.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 920CD1E74FA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72482-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026, Sean Christopherson wrote:
> On Mon, Mar 02, 2026, Sean Christopherson wrote:
> > On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> > > Also taking a step back, I am not really sure what's the right thing
> > > to do for Intel-compatible guests here. It also seems like even if we
> > > set the intercept, svm_set_gif() will clear the STGI intercept, even
> > > on Intel-compatible guests.
> > > 
> > > Maybe we should leave that can of worms alone, go back to removing
> > > initializing the CLGI/STGI intercepts in init_vmcb(), and in
> > > svm_recalc_instruction_intercepts() set/clear these intercepts based
> > > on EFER.SVME alone, irrespective of Intel-compatibility?
> > 
> > Ya, guest_cpuid_is_intel_compatible() should only be applied to VMLOAD/VMSAVE.
> > KVM intercepts VMLOAD/VMSAVE to fixup SYSENTER MSRs, not to inject #UD.  I.e. KVM
> > is handling (the absoutely absurd) case that FMS reports an Intel CPU, but the
> > guest enables and uses SVM.
> > 
> > 	/*
> > 	 * Intercept VMLOAD if the vCPU model is Intel in order to emulate that
> > 	 * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact that exposing
> > 	 * SVM on Intel is bonkers and extremely unlikely to work).
> > 	 */
> > 	if (guest_cpuid_is_intel_compatible(vcpu))
> > 		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
> > 
> > Sorry for not catching this in previous versions.
> 
> Because I got all kinds of confused trying to recall what was different between
> v3 and v4, I went ahead and spliced them together.
> 
> Does the below look right?  If so, I'll formally post just patches 1 and 3 as v5.
> I'll take 2 and 4 directly from here; I want to switch the ordering anyways so
> that the vgif movement immediately precedes the Recalc "instructions" patch.

Actually, I partially take that back.  I'm going to send a separate v5 for patch
4, as there are additional cleanups that can be done related to Hyper-V stubs.

P.S. This is a good example of why bundling unrelated patches into series is
discouraged. 



Return-Path: <kvm+bounces-21227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7508492C349
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 20:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18FEEB22B6B
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 18:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C44180047;
	Tue,  9 Jul 2024 18:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fW3bsjdC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBFE17B037
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 18:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720549850; cv=none; b=qohb9/pjNlRJDmAHQ/nTiOE/ES/IyC4fSf2tT2NCIR8MepDz8Kgy0RQGNMn2gBb42A7185IXaXwdprznFCJpryW1gulfdb/uJ+kbHAULE9Q3CbpgDr8LPOayNlk4P3hFzBbmNVz/rghpAuR2VXPNqcKqYGV325xqlhMQzq0mGgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720549850; c=relaxed/simple;
	bh=N4+viih2gma9QcmquIKlbRwl7nIzoZsM5L48/0q2Cpg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r8RxGhnMRnx+tpfRdQaHc2PvEYwAePxHfM4gwQpFRm5TFRkjF556j+z+klSAJiJjn8mpEecumiFNaY93TeecX92MGhYRPJ3DcxyIJ9IyTi5/nTjxHhAN5D9+foScTcte3kG+qW8V0p4Xe91h51njNFUDspCJ7UD4VNBlKohCCq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fW3bsjdC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c95c80c6f7so4289096a91.1
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 11:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720549848; x=1721154648; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FAqEpWZEgwuYrU89utPks/w7kr7U7FSan9CR+x/bpmM=;
        b=fW3bsjdChHV/TH3nr5VH+Bsi6cC19yxG2/wfgH5wxbjwTN6SjZtblk4u9nXU5zzGDE
         3kCGWHXweU2BOQ01fmfxRyrmDr/tjW1BXduf4JXL1jzN7Zb14PN90ixqIq0t1UZ2bGRd
         5ap6g4NB8myFTlTP/DKjG1Xdzeo2zxV6SCg48Fs+jAt9+aZuoTxWGm2daKz8kWVMgwXq
         Mp8R0OpDugDwa4kFAKd5OavmgTkRjoP20OG9dB0dwVH3gwrRATBLuXNJzlvlfO6gilyU
         4DmRE3wOQHvG0NxEEDAN0KfiHGVvq6iM8Bp2aiIDmrJUBwe20NE3vnXgfRa/bK7P614+
         I/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720549848; x=1721154648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FAqEpWZEgwuYrU89utPks/w7kr7U7FSan9CR+x/bpmM=;
        b=FtUCJ0P6b3Nq6CNVnpBW7VZgBhP1QnUF2fHo+rDTlcfrTupvoWWIMMleUJvwMIhx4q
         /gqg12kBkHeR5RvOvBheSU97fqSpkCjnwttKyQ9FqOt37f0atunlSPHoi2jcdAFJ1fkT
         +MvMz21dhjjVFH3nrlDtuo/iVHUAabkvfg16yDOOMBegKI2Oe8Fwh/yVxyphGbJmt7Lr
         F7u9Nsv1oD055nDapcqTlUol6iABXYUfjbdZNVQILO+4JpFh9viOntjoya82+NFME6Qw
         hF/jgw4YD1YOWt1jptJSDVvPNsCA/Q6WF/bzd0/oq+aQCsvk/BJugpVsprTcOjtmumoo
         5g3A==
X-Forwarded-Encrypted: i=1; AJvYcCVDIpkOoYAaCbz8s777hFZUmZ/2AggXlffrJRwUN06sqDzuLz5XqA/bFjEcC0Jha9c5Y5zFxIG/stA46wIbrG9x4imF
X-Gm-Message-State: AOJu0Ywi4tHG3HfIv+1z+vWIIimxgeyc8jVW/lu5p/NItHFa6zzLaTWo
	dfjHyuaZfSUoVfpPbhLGJnP2P/G9xJBnuqJWVN2X3V69vAPZJbqEoZV7Okz7cpUN5j3RfaAXmBC
	Xmg==
X-Google-Smtp-Source: AGHT+IHdTEkU/YN0RkgCbuOH3sRmHxgFkvoSBnHbktYi5EH1tE+yrdrqGPbDR7Q+CN9Q6JhSoNiOJDFalgQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4c88:b0:2c9:9b67:9c41 with SMTP id
 98e67ed59e1d1-2ca35d8b869mr9260a91.8.1720549848435; Tue, 09 Jul 2024 11:30:48
 -0700 (PDT)
Date: Tue, 9 Jul 2024 11:30:42 -0700
In-Reply-To: <34d209d318111677c1cd47ff321cc361bf06bd60.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-38-seanjc@google.com>
 <34d209d318111677c1cd47ff321cc361bf06bd60.camel@redhat.com>
Message-ID: <Zo2B0jDjufR4EdTx@google.com>
Subject: Re: [PATCH v2 37/49] KVM: x86: Replace guts of "governed" features
 with comprehensive cpu_caps
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > @@ -861,23 +877,20 @@ struct kvm_vcpu_arch {
> >  	bool is_amd_compatible;
> >  
> >  	/*
> > -	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
> > -	 * when "struct kvm_vcpu_arch" is no longer defined in an
> > -	 * arch/x86/include/asm header.  The max is mostly arbitrary, i.e.
> > -	 * can be increased as necessary.
> > +	 * cpu_caps holds the effective guest capabilities, i.e. the features
> > +	 * the vCPU is allowed to use.  Typically, but not always, features can
> > +	 * be used by the guest if and only if both KVM and userspace want to
> > +	 * expose the feature to the guest.
> 
> Nitpick: Since even the comment mentions this, wouldn't it be better to call this
> cpu_effective_caps? or at least cpu_eff_caps, to emphasize that these are indeed
> effective capabilities, e.g these that both kvm and userspace support?

I strongly prefer cpu_caps, in part to match kvm_cpu_caps, but also because adding
"effective" to the name incorrectly suggests that there are other guest capabilities
that aren't effective.  These are the _only_ per-vCPU capabilities as far as KVM
is concerned, i.e. they are the single source of truth.  kvm_cpu_caps holds KVM's
capabilities, boot_cpu_data holds kernel capabilities, and bare metal holds its
capabilities somewhere in silicion.

E.g. being pedantic, kvm_cpu_caps are also KVM's effective capabilities, as they
are a reflection of KVM-the-module's capabilities, module params, kernel capabilities,
and CPU capabilities.


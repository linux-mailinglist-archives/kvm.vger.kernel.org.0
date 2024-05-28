Return-Path: <kvm+bounces-18236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA7B48D2391
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 20:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16F471C23280
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 18:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0614B174EC6;
	Tue, 28 May 2024 18:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BvKLadwi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FF816F916
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 18:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716922607; cv=none; b=Mxs5x7Fbt6NnbzbUE64SR8kiWLY4LeOo8yJWYrhidydxe4D0HD+nfAxDpdikxH8VCqEOunU5GY6nZajK9GBpWVyP8AbW5fbkkJjNLwuq7Ywg61IWJLPWdHTbCrwI0yDM7BWDqp3Eoh0zZToHjvEaleSYVJiXZim3vRAzi3d+1Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716922607; c=relaxed/simple;
	bh=7VzGZDtBSooFkxUd9OAZGtectfy+uwG4/bUmSmiL7y4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hqIWXWJQfI1HjOGrlzIc2AAKx6+A0cX9WuwLChiBTvE1cuaH9GHMv7D2aNaEM1+KKVkknB+Coy4FqAYWcGEjy5Xa/U9fREgFByT85xrAq0vhhNd7hrnf4XXQjuBRKXBoyonFev6PT4ykG2TKSVvV5K8wAlbxMTELFSxyLrzyWwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BvKLadwi; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6819568d854so1039181a12.2
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 11:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716922605; x=1717527405; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S4Hp5OPdGF5QAC5ejV2ec7ZNjyRf7XQzcBDRWuz3U2Q=;
        b=BvKLadwiu1EUp6B/W7QzDf0vC1qmVA4xA9GlGAhJTIYmUKR4aXx37KdHJfazVVcYXD
         LLY9oCg8xuQPAia6vvNwmi1CCDxqQJSO1yTVcISCtOoGx9SDFcCC/IP48sK3kwIWB5d2
         DgdKyyPXggomEr1PFGIzaciu026AyQHfCJvMeigaEaxyk3QadlQnJD4B32EX5d+6Otxx
         tzwLKy0NSNrGJ+3tkXscX7t3VocrA/StXLCGgiqbAerBwXMNqGREOfD/GX+pGSr4jRQm
         5z8kyuogd933XlZzGOAeuaAf7Y76xitBVzPHskHuqoJ8rksyBLfnOwwVb23u7//VuZbo
         4Aew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716922605; x=1717527405;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S4Hp5OPdGF5QAC5ejV2ec7ZNjyRf7XQzcBDRWuz3U2Q=;
        b=u/add3KIAH2l1osCf17NYAOboZCEIg1LbPnlVOQgsvEWKOqS4LyAtCljInZPbCKFrQ
         Q/ZQa08VGP7WPgz4e0f1Iu5PCy3F1rFo/TQ5xwBxPFSt9TajsTCEQmVUQod2CV2aPai1
         8EQ8MUug9I+tId4GXGvT4xTpaU6lglEzeVPeqdcy7o+G1kin21NTycD/tMhD9Sq6fntb
         mhDiZ2qpqBF2rprzuR1VN27B7SkLT43x0NhRT7yVFKzbVT1Gn/cMOixGM/bQ4hAOhD/S
         vibeBdNRbZttXctbnVmcX9z5JGisivq8zujx+KgojN8Z0DndqJbE7TcdHKtMDECE8uTJ
         9GZQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6plMSlcK3BiYlCT03LbmhcE6132+ZMMAOGCJXD1zrtxUDiiKBYwo5/ZTRX7ZOnkejj6Kw3vXb+yauQhgz0uq0vZmF
X-Gm-Message-State: AOJu0YwpwAQ02mc32OkX0FELoXN9Uej6UP7MTG8qaI9/vUm3Ilmk0JRb
	cuG+CsOdZ15lPx09T4IvWBgSfhiYA/gRu/YbzwqpMxsej9zoSdxICcO74dbm4/9tXe7dp3gAMKC
	QfQ==
X-Google-Smtp-Source: AGHT+IHoqr+ISQcH8/FCagbfJ2nL98ZUcD/8qvK2Uon7Hq2ULc+/vLDNTGE1sbxP/IfziOZcYq1e9FeGTCM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:19ce:b0:2bd:6abb:e9f7 with SMTP id
 98e67ed59e1d1-2bf5e09d490mr35783a91.0.1716922605104; Tue, 28 May 2024
 11:56:45 -0700 (PDT)
Date: Tue, 28 May 2024 11:56:43 -0700
In-Reply-To: <18f52be4-6449-4761-a178-1ca87124c28d@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-13-seanjc@google.com>
 <18f52be4-6449-4761-a178-1ca87124c28d@linux.intel.com>
Message-ID: <ZlYo67vO5JJ6aCAK@google.com>
Subject: Re: [PATCH v2 12/49] KVM: x86: Reject disabling of MWAIT/HLT
 interception when not allowed
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, Binbin Wu wrote:
> On 5/18/2024 1:38 AM, Sean Christopherson wrote:
> > @@ -4726,15 +4740,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >   		r = KVM_CLOCK_VALID_FLAGS;
> >   		break;
> >   	case KVM_CAP_X86_DISABLE_EXITS:
> > -		r = KVM_X86_DISABLE_EXITS_PAUSE;
> > -
> > -		if (!mitigate_smt_rsb) {
> > -			r |= KVM_X86_DISABLE_EXITS_HLT |
> > -			     KVM_X86_DISABLE_EXITS_CSTATE;
> > -
> > -			if (kvm_can_mwait_in_guest())
> > -				r |= KVM_X86_DISABLE_EXITS_MWAIT;
> > -		}
> > +		r |= kvm_get_allowed_disable_exits();
> 
> Nit: Just use "=".

Yowsers, that's more than a nit, that's downright bad code, it just happens to be
functionally ok.  Thanks again for the reviews!


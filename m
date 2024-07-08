Return-Path: <kvm+bounces-21134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E50A92AB5C
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 23:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 085B9B21F6B
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 21:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648E214F131;
	Mon,  8 Jul 2024 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gHIXglAE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A71145B06
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 21:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720474664; cv=none; b=Raka1Ac7v8Gdk12hsd2EsMDR/ZgAgCNIDqOL4IYzL400WrslXzejJg68ZyoMmrvPrGPOAhhQaQ44i7BPsWGt2zXz79VhMHbzmfVQScfS96YqIPGONmIhSliZil9Pq1LAXea0brdbTnsPpbHu1jCYeoZbmk+EJ/vNVGygw46stHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720474664; c=relaxed/simple;
	bh=rnKDQudiRYboIXIxW3KZilr/F8Ck6nastO1izzGWj/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F6AG3HBrjYlJ/sJd7Hhjopa+A4I3CvFAw6mgv/uEQxLuq6+gP7Y0Gijt/siG6MRqBVEPHlDMVENH3WyGlWduVFiH+i0XmJjOCVIVBF4NyE8tkPW1R2g5lKEhJJFIdUqHCAjSifDOWFbdX2RgBCn1a97RVs9/fns/8Fs9L5msg70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gHIXglAE; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e03a3aafc6eso7083966276.3
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 14:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720474661; x=1721079461; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LJZVptd3IywbKFK+zEIhadT/eRgCc6sBTUUHcoA5IF8=;
        b=gHIXglAE0PyjP2VCsUOxxnr4yTeYLTzy6xZ9S6jAITr32vArbNeHHLciO9f4D767jZ
         PVkvoDHHjB5QiSRqmz7kKtGAHNL4zIdi7o/sf9iwj5gRriib5TE6iNsnCfJeJM300/g+
         FAEV+gGEMsEt+zzIGyFmtaKCelOQBqgSkE+XcjTdaJDr67tZQTaMWw3mw7v2x2NX2S8F
         hzNcqxTtvcJAc8ZHcjait6ji5+y2Z8PIFU4xt/m06Y4vAIYgm4cDA+1mQtfO38v9CewQ
         qia7l8bqB+xPKxb8tJon6Jc0HidrX16iIUel6s05PYcEq9b8if5R3qoBawp20eS0xw/m
         e8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720474661; x=1721079461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LJZVptd3IywbKFK+zEIhadT/eRgCc6sBTUUHcoA5IF8=;
        b=YhXJqRN+Tp0I1xxua0RGbW7jGSlZ/FT+Q2JtMcD1+J6qHQ7guNx3JbTyX6plXW23nX
         eQxrBc2DsKGSPmd/nH6TsZ+AdiLozpF7sxaBrnb44AD81ZpkDWyws14OEweOF90XBgZ9
         XhVSwZKva2AdVRNDYjOY1cLJjmy8iSCYIEoFwO6r4HbVVsihjLtzM5SrNKe/7SMK4Xrd
         Y/A2vD2R6eEbhVQ2CVy1JKngT9HI3JAGpRsfyry6sPZMxPWrMIDoWv4yf2NzCNj8cLXe
         iM4E5Q+Am5z5YHGRn21qnVYmcBbPuKuSqUD3UpY8fJ4bGVpBUASXOuerwqYQxFaGfExk
         fqHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWauGWjm4yx3AMYYQvqgrGwqkw7AWs8nE58WIpy0DG3SwGIh6/23t6hpT0NKwaXQJLiKdOk4PqyY3OZMN4j18ZUgSqV
X-Gm-Message-State: AOJu0YzelotaxKtfMoYgOJkZ+ryFbrN3QXtYLWUYHD4JbZ8GIqsGW46H
	cgVQ6EIKjBOK8GZ6fAapUFW71qTIZzvQddb0Iagjxdh27usQMGRmzj0sTgTmEJeGGqJSR/KbFbr
	xeg==
X-Google-Smtp-Source: AGHT+IHpHAbji4+XsjpJzrAKQm1/NN0P8TYfGMGYe8qxwfqywzn3eDHBR7+4BIezFnN3h8T5PCxdcbjKowM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1706:b0:e03:a875:f827 with SMTP id
 3f1490d57ef6-e041b143389mr2036276.13.1720474661535; Mon, 08 Jul 2024 14:37:41
 -0700 (PDT)
Date: Mon, 8 Jul 2024 14:37:40 -0700
In-Reply-To: <376d0c37d0cf4d578fe13be6f2b3599a694040af.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-28-seanjc@google.com>
 <376d0c37d0cf4d578fe13be6f2b3599a694040af.camel@redhat.com>
Message-ID: <ZoxcJP6AA5sUZBjs@google.com>
Subject: Re: [PATCH v2 27/49] KVM: x86: Swap incoming guest CPUID into vCPU
 before massaging in KVM_SET_CPUID2
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
> > @@ -529,7 +533,14 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
> >  #endif
> >  	kvm_vcpu_after_set_cpuid(vcpu);
> >  
> > +success:
> > +	kvfree(e2);
> >  	return 0;
> > +
> > +err:
> > +	swap(vcpu->arch.cpuid_entries, e2);
> > +	swap(vcpu->arch.cpuid_nent, nent);
> > +	return r;
> >  }
> >  
> >  /* when an old userspace process fills a new kernel module */
> 
> Hi,
> 
> This IMHO is a good idea. You might consider moving this patch to the
> beginning of the patch series though, it will make more sense with the rest
> of the patches there.

I'll double check, but IIRC, there were dependencies that prevented moving this
patch earlier.


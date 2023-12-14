Return-Path: <kvm+bounces-4524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1233C813688
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 17:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70D7AB20DC6
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B928360BA2;
	Thu, 14 Dec 2023 16:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ludcU88/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA60511A
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:41:45 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5ca4ee5b97aso1104561a12.1
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702572105; x=1703176905; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yuDIlHPXc3h0xC5YU4/ai6dB8VlmCAB/+AvZ2ucJ1/U=;
        b=ludcU88/lGdmhVEW+b4J9KNQCqOjUyJndxHEHxyFA2tyw7xi4lao+CAXJmt7bQ5Uhd
         lOGxVGx2ooC/5GZcFYE1Zs3FrouwdoKxnxRe/uTE36XXzmQYvF8QRGMhtQbIRp5Xazb0
         N2JzsbsAoXCydVGACzQ+plMn11/u6Jpbm5xgKqZ2n6FiRzcuJydQ6drjFmaLCxXVDt9b
         pPsBiPmXZvfFw9bg2VyS1O2RBMtKgZnMrXq3TIl4bldw3TMG1lxLaXFtYWkae+wgb99G
         CwItHcYy7RNJ+BdGNBtrmO9C19xpJOUEzpELBiIoON/yqwZTcftbsl9I9oKsIXKtsCVF
         ysaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702572105; x=1703176905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuDIlHPXc3h0xC5YU4/ai6dB8VlmCAB/+AvZ2ucJ1/U=;
        b=qFeRShhiPNdBopu+E/PGIvrGb4r5ZUVtdkeXuHIM/cOQYXDLhEEGYCTk+ahNiPTgCI
         xvW4vlDhD+pw3dGE+DBjGPkx3PNDuJnV4QL3d3wLYfU94QUDbhBk2TGTGZyLPYksDoXB
         u9WAbdjV4077Ij0JZY+e+ga+ONsOR3pX6SwvyUWRVw/uFlLPnen6LLCuGnzJegY1EaNk
         kDtjoMHwuZuPChU/yducQ9YboD6xf+qipv3MbMUcsbw5LrpjL+CNo7lqRXsUfa62OJ08
         V7xAS9gzTgJA1utsgavsTU+HJnp3SK0HLHM0SycjUtRnGDlbmdL0u6VkHhzEb+pwTtln
         U3sQ==
X-Gm-Message-State: AOJu0YzeZxPqThuyEQSbeen6kOH2rnDgE2FTSvuWLAL7tva58OJwtBBu
	jflO9ZE0ogwSB8HNhPyo0gk9+fh9bsg=
X-Google-Smtp-Source: AGHT+IEprhiATuTdUWMrDqAwIvYwY4NpyGfKixHgWQGjoC7m8JjaRWItR9a08wY6L5ZSGKdGQrSv392O7Xo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:418a:0:b0:5ca:4357:347f with SMTP id
 a10-20020a65418a000000b005ca4357347fmr567734pgq.7.1702572105188; Thu, 14 Dec
 2023 08:41:45 -0800 (PST)
Date: Thu, 14 Dec 2023 08:41:43 -0800
In-Reply-To: <aa7aa5ea5b112a0ec70c6276beb281e19c052f0e.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1699936040.git.isaku.yamahata@intel.com>
 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
 <ZXo54VNuIqbMsYv-@google.com> <aa7aa5ea5b112a0ec70c6276beb281e19c052f0e.camel@redhat.com>
Message-ID: <ZXswR04H9Tl7xlyj@google.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency vm variable
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Vishal Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 14, 2023, Maxim Levitsky wrote:
> On Wed, 2023-12-13 at 15:10 -0800, Sean Christopherson wrote:
> > Upstream KVM's non-TDX behavior is fine, because KVM doesn't advertise support
> > for CPUID 0x15, i.e. doesn't announce to host userspace that it's safe to expose
> > CPUID 0x15 to the guest.  Because TDX makes exposing CPUID 0x15 mandatory, KVM
> > needs to be taught to correctly emulate the guest's APIC bus frequency, a.k.a.
> > the TDX guest core crystal frequency of 25Mhz.
> 
> I assume that TDX doesn't allow to change the CPUID 0x15 leaf.

Correct.  I meant to call that out below, but left my sentence half-finished.  It
was supposed to say:

  I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
  use 1Ghz as the base frequency or to allow configuring the base frequency
  advertised to the guest.

> > I halfheartedly floated the idea of "fixing" the TDX module/architecture to either
> > use 1Ghz as the base frequency (off list), but it definitely isn't a hill worth
> > dying on since the KVM changes are relatively simple.
> > 
> > https://lore.kernel.org/all/ZSnIKQ4bUavAtBz6@google.com
> > 
> 
> Best regards,
> 	Maxim Levitsky
> 


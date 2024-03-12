Return-Path: <kvm+bounces-11669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 277178795F3
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 15:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D594C285AD8
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 14:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDFC87B3FC;
	Tue, 12 Mar 2024 14:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H0zhra1t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C3E7AE59
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710253210; cv=none; b=Hb93ql8yWabLjbhnbyTwGt3hKssy5yVjVt8PReUHT41eJv2VhDTStNOw4VM+bLTjXJCwdxjsCQ7CBVqOnk2pmkQFRCFkfIR7etC83x3q6uOqXETqhcBhgssHC9F0tvY2zcrvcxI5Gmf6bcFGOahdMaRFb6s6+jmlfm1fDJft2gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710253210; c=relaxed/simple;
	bh=Cyv31l3V93wJczzZuVe6h3HTL/aj20Zlxrvzm4Sh8lE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X9y0/hEb2hlzoIesUlQqXLaQIvmRCROKj5z+PsMHGyGEageoCAYKatMQT927ix0e/YPOAK0q+FZCj0+txA1A93DVY11vBklVaLG0q5hRY73jy54lDsGQ76oP7+SGXh7GsEL3HfcYVQp+O1+ld47AVl+NGUWPaqZ6Q3oOgsMp05Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H0zhra1t; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609fb4fc058so77926637b3.3
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 07:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710253207; x=1710858007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Jjb/PAOgGaN7lAsVIUO9NyizSvHp4sC3GUTaZ0PNJs=;
        b=H0zhra1tbF2BHsVDBkI/e5ByzJ1FKwfcZbWw1ikPhXbAFRTByAcXlwfuKBTUfpKuGg
         CByuuIJnmYSODXsQSDj/P/i9r+sVyopD8lUmj1ePR5mDX5eIpY/ZB2mKnp55rjFf0wjk
         oVZPp+PviACFX0D75LmUIcGshgNM5+TcJcGTgUNI5mOmsu5h4/kJVMIr1yywq2GXdJRF
         E9yMg6dSYc+i1Qv9To6d+ZRoVT0EIHa57RdXGeJIaBAoBGQFHlWnr361WFwXF3E3DAo7
         TdHkMpx4rh55d9XxCwwWnzmnNnZfmIOLZR4pqy55TIzMJAsOONvd0+7aPxTnartrDA+c
         GLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710253207; x=1710858007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Jjb/PAOgGaN7lAsVIUO9NyizSvHp4sC3GUTaZ0PNJs=;
        b=hf2Qe4BnEz9qVd0/ZOM25iZEFG7303Deq8bPQropa5Klafx+MemlqBpdnlorK88Eka
         QpCv3DDnv5rNwLtjn0BpBOXY6TTP8S3Y8+Mu5i7LtMY2gThzhCYy4RFo4qtnWITbGRH5
         NxFcQPMiEzi+oYb7rub08yjO5OZj5sNWNAjYfjQkMBrw+s6+MXi/fQ79H4l9Qpx7TEBD
         OzbtsyaCiklgSWjsqGRHRktdkfPFuo9UBUxiFmNsX+Z+f9Wkc6XxM2/lN+/24T6r3K/v
         x5nQ6vpzlaG4DF+TShwzayWiptWTTDEFWxOa7EjGfaTFuy9g2YBHwvdzFcweHwB5bB/T
         AN7w==
X-Forwarded-Encrypted: i=1; AJvYcCXi+oWzrnX7RDC+AivxJ1lfMEakh9/Tcmes4Mwi0+qfUYx6eQZSIk47rM2tCdfl3dz7gYYHKklOuB/KZhvAwTNhBoAp
X-Gm-Message-State: AOJu0YzNqNP5+x6RrVtPdkxXI8DyLGhZdFwSg9uBI8y2zY/b1R/m/z3O
	YH0lKKn1z6ze6ROIT3ux/wtKI9fNlPMKj90/nYTYnvts+GmOZ5z4j1E6wIU3yVx5iWmxkJghZIi
	ruQ==
X-Google-Smtp-Source: AGHT+IF2G7mI6BP+EmptPVIitfTTiB7haHK5wPTRnTR7LM1v/cn/RH1kQsYUCQo17zt2GU1GfGk8M1szpTU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:be49:0:b0:dc6:44d4:bee0 with SMTP id
 d9-20020a25be49000000b00dc644d4bee0mr512108ybm.7.1710253207502; Tue, 12 Mar
 2024 07:20:07 -0700 (PDT)
Date: Tue, 12 Mar 2024 07:20:05 -0700
In-Reply-To: <6b38d1ea3073cdda0f106313d9f0e032345b8b75.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
 <Ze-TJh0BBOWm9spT@google.com> <6b38d1ea3073cdda0f106313d9f0e032345b8b75.camel@intel.com>
Message-ID: <ZfBkle1eZFfjPI8l@google.com>
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{, pre_}vcpu_map_memory()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"federico.parola@polito.it" <federico.parola@polito.it>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"dmatlack@google.com" <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 12, 2024, Kai Huang wrote:
> > Wait. KVM doesn't *need* to do PAGE.ADD from deep in the MMU.  The only inputs to
> > PAGE.ADD are the gfn, pfn, tdr (vm), and source.  The S-EPT structures need to be
> > pre-built, but when they are built is irrelevant, so long as they are in place
> > before PAGE.ADD.
> > 
> > Crazy idea.  For TDX S-EPT, what if KVM_MAP_MEMORY does all of the SEPT.ADD stuff,
> > which doesn't affect the measurement, and even fills in KVM's copy of the leaf EPTE, 
> > but tdx_sept_set_private_spte() doesn't do anything if the TD isn't finalized?
> > 
> > Then KVM provides a dedicated TDX ioctl(), i.e. what is/was KVM_TDX_INIT_MEM_REGION,
> > to do PAGE.ADD.  KVM_TDX_INIT_MEM_REGION wouldn't need to map anything, it would
> > simply need to verify that the pfn from guest_memfd() is the same as what's in
> > the TDP MMU.
> 
> One small question:
> 
> What if the memory region passed to KVM_TDX_INIT_MEM_REGION hasn't been pre-
> populated?  If we want to make KVM_TDX_INIT_MEM_REGION work with these regions,
> then we still need to do the real map.  Or we can make KVM_TDX_INIT_MEM_REGION
> return error when it finds the region hasn't been pre-populated?

Return an error.  I don't love the idea of bleeding so many TDX details into
userspace, but I'm pretty sure that ship sailed a long, long time ago.


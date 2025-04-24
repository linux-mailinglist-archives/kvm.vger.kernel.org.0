Return-Path: <kvm+bounces-44223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2CDCA9B65D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 20:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0016F4C1998
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 18:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AABD28F539;
	Thu, 24 Apr 2025 18:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HSKhT/qM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3044128BAAC
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 18:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745519466; cv=none; b=mLVP3YAH3hjnMx4Xycywn2KV/6TtC6HsoXNJ33G+PdCsYklvvZsGbnKuTJxA44j6JXxxfETKaP4dV5OHw8llmt1z1weQpo8NJxmoOZA6QqpK9iruIxg+HCLkxR18IawUj2M6TNTzpdYIGiYUACdpzHz6bmp6hlnY9Uy/CIGInuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745519466; c=relaxed/simple;
	bh=ILO6X+1wiyDvLyAnEXEjTaFYqL7NPgBpZuWysDMt9H8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DRFEI3yM+u95HU7k20v8T4lV/2kBUreNibha3D3Wu2laD40ER5MQmKLNicRrmrtYvyqcWvkRxAig2KuCxtn+66szFCGA+ZwysUG1/6qtcqZ5rY7lZr+8Pqm43B3GobwJEQWpgutg1HoBRtt4kMNbgjzlRPgLphL+kbVn6DDzdMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HSKhT/qM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3086107d023so1236871a91.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 11:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745519464; x=1746124264; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7NvzMjAWmU9Cpw2or2VLdADfSZF81SFARJPL22fxjvs=;
        b=HSKhT/qMwIflLKpLl7Uikl7nfuj5Yx78nMcEdb+n1+NpjNT5uySa9aVEY7LpNaZZum
         QQH0NLeMFgP41rSq/NrqUk0nGuehfbf3TJYg7UfH874YJ4F5EiQLy5Ga7pQf6v1kYZbs
         fqztgVt6p5bVt+YzQ98/7jLc7frWawM7wX1EQGgyN6yE2KNAgMZ1ujX4Hf/w2o5ZARKL
         d5HOZGcUOIK7jT0Hn2BMYTuyrTCLv3t5L7QVAzUyHQ6AcsYP59nVFFVFkzUdsUTR4CZp
         k2S7ihXTZh6oYceIk1lHfVsHYq7fwWUGdASvbElB7ZUw8k2KpaDuZ/EjjDw4tWlcOkpT
         CzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745519464; x=1746124264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7NvzMjAWmU9Cpw2or2VLdADfSZF81SFARJPL22fxjvs=;
        b=hc025ZTnIKVCXVSK/VOfvNJZIVlQ1HcCRvz6GGKBbwKfx5lKwGl8yKL8GGscUSkqEE
         Ww/CB7kj1MM+UBcCc1POGxc7KzGzAQ2fqu9bdqP61byGHFE6DhBkGI3fb9wVjxEVqRY8
         jLOw6lkbl0TWQNWMAf7cvsc/4mV0mGGZpPY+zccZbv5U1dyp4PH356ULNgdQ1HJi8dFr
         /XKXCk+ClAwgVihaTClWPJBgE5kTKH8o3AMMcYHnm7O0wa8BkJ454Kyo3+OkvQdaBZlj
         wCZbKFHUN/fdRdYVw1/CJvYaJpgEq18m/KwcnStMZntBVqHcnBxljx1z94Bm/KZb0hq8
         F3fg==
X-Forwarded-Encrypted: i=1; AJvYcCWg2shdifH6ofvFiZsfudw3bg4fzy4xzm8r62gNfWqz4BeBLMFzh8lekpnnESdnWTyiZzA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbKqI3c6pqZES/gV42NbweArNtAdith1b+HQOuj4wqg6BMwLBt
	nTn6nGg/vpZZ/aqDV1HgevUzZCa9XgHvszjnzCQ9joI0w0Qt0bKp8tcMt+Sj+mvqSr/lvoIBdYJ
	/Lw==
X-Google-Smtp-Source: AGHT+IGoy6DhJxUoH6FDRKSyq3AQdea4Kw42YmjfNZkFG4FtsKkwbaGCGgFBD1GHa/VUFQIinHAYyEUu8bI=
X-Received: from pjbdy5.prod.google.com ([2002:a17:90b:6c5:b0:303:248f:d6db])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56d0:b0:2fe:b77a:2eab
 with SMTP id 98e67ed59e1d1-309ed36f928mr4603235a91.32.1745519464375; Thu, 24
 Apr 2025 11:31:04 -0700 (PDT)
Date: Thu, 24 Apr 2025 11:31:03 -0700
In-Reply-To: <8e64fb0f97479ea237d2dba459b095b1c7281006.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401155714.838398-1-seanjc@google.com> <20250401155714.838398-3-seanjc@google.com>
 <20250416182437.GA963080.vipinsh@google.com> <20250416190630.GA1037529.vipinsh@google.com>
 <aAALoMbz0IZcKZk4@google.com> <8a58261a0cc5f7927177178d65b0f0b3fa1f173c.camel@intel.com>
 <aAkeZ5-TCx8q6T6y@google.com> <8e64fb0f97479ea237d2dba459b095b1c7281006.camel@intel.com>
Message-ID: <aAqDZ_QEdL5RhAOz@google.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures
 using kzalloc()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "vipinsh@google.com" <vipinsh@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 23, 2025, Kai Huang wrote:
> On Wed, 2025-04-23 at 10:07 -0700, Sean Christopherson wrote:
> > On Tue, Apr 22, 2025, Kai Huang wrote:
> > > On Wed, 2025-04-16 at 12:57 -0700, Sean Christopherson wrote:
> > > > On Wed, Apr 16, 2025, Vipin Sharma wrote:
> > > > > Checked via pahole, sizes of struct have reduced but still not under 4k.
> > > > > After applying the patch:
> > > > > 
> > > > > struct kvm{} - 4104
> > > > > struct kvm_svm{} - 4320
> > > > > struct kvm_vmx{} - 4128
> > > > > 
> > > > > Also, this BUILD_BUG_ON() might not be reliable unless all of the ifdefs
> > > > > under kvm_[vmx|svm] and its children are enabled. Won't that be an
> > > > > issue?
> > > > 
> > > > That's what build bots (and to a lesser extent, maintainers) are for.  An individual
> > > > developer might miss a particular config, but the build bots that run allyesconfig
> > > > will very quickly detect the issue, and then we fix it.
> > > > 
> > > > I also build what is effectively an "allkvmconfig" before officially applying
> > > > anything, so in general things like this shouldn't even make it to the bots.
> > > > 
> > > 
> > > Just want to understand the intention here:
> > > 
> > > What if someday a developer really needs to add some new field(s) to, lets say
> > > 'struct kvm_vmx', and that makes the size exceed 4K?
> > 
> > If it helps, here's the changelog I plan on posting for v3:
> >     
> >     Allocate VM structs via kvzalloc(), i.e. try to use a contiguous physical
> >     allocation before falling back to __vmalloc(), to avoid the overhead of
> >     establishing the virtual mappings.  The SVM and VMX (and TDX) structures
> >     are now just above 4096 bytes, i.e. are order-1 allocations, and will
> >     likely remain that way for quite some time.
> >     
> >     Add compile-time assertions in vendor code to ensure the size is an
> >     order-0 or order-1 allocation, i.e. to prevent unknowingly letting the
> >     size balloon in the future.  There's nothing fundamentally wrong with a
> >     larger kvm_{svm,vmx,tdx} size, but given that the size is barely above
> >     4096 after 18+ years of existence, exceeding exceed 8192 bytes would be
> >     quite notable.
> 
> Yeah looks reasonable.
> 
> Nit: I am not quite following "falling back to __vmalloc()" part.  We are
> replacing __vmalloc() with kzalloc() AFAICT, therefore there should be no
> "falling back"?

Correct, not in this version.  In the next version, my plan is to use kvzalloc()
(though honestly, I'm not sure that's worth doing; it'll be an order-1 allocation,
and if that fails...).


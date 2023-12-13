Return-Path: <kvm+bounces-4382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33708811C15
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 19:15:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC8801C21152
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BCFA59553;
	Wed, 13 Dec 2023 18:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g+yrA8Mf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B205BAF
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 10:15:15 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-dbcdf587bd6so211863276.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 10:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702491315; x=1703096115; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=blvS/vSMP5wGXcIzzo9Bxe4pmP25PsC7/K8dybntrXg=;
        b=g+yrA8Mfg6goxn3eK0IeQIAef/SB81WKRvOAU9basbrL3SvJfGjR9Hh+PZj1lfg/1a
         +nEXbap7dAoDFVI3VIL9MBY7/SIFSfdZ2HoBNujd6dNFghHPI9f/+ZsMJZTZ39aslPHp
         AA+UAxijsA96WJXJ4lFn5DXS+DvAVTs5RsuL8deviqj8Vt1ezltOChUJ8BDO3WzzTlTW
         UXYik3PIsqVuxgqJYuYqSv1UB5/e8vORnVUZ2bkm5QpIPe2vgqbU2JcGokAVMLvXMD7I
         C+B+S1xcmfb8DepfK4ehxXgjwn9w2+MfNZjD5kV2POa+432AXdY9MVcyBa71U79sTCD4
         GKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702491315; x=1703096115;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=blvS/vSMP5wGXcIzzo9Bxe4pmP25PsC7/K8dybntrXg=;
        b=AYHTLzC0wEz8TKTnhSXzHr1EoFObcvrs8U1UlzdS2zKk3LUXl8Z3YkZ6gFgRYVN8aO
         t9GbfycuLa8gGDbEiIcekqxfNoyfD7jJsbQI4otJej0U4PzPJK8ymCJq3w93Lrwuwuwy
         b0jKTU4PkcSvdT2maRvajn9f/C+Li0H4zgBuGfJIbZvNCQYNYNfymnPMGzIsxhd3RcIn
         EkC5Ik6Pg7D6AvOoi5NwoStIj044O9t7Mkt7AdcFT46NiNw/XbC+Ze29zzPc3XXktJPm
         j3DbBv6etQ7pUm9ZcvcITEogEQcx7GJfPLfEllj/0ZCxc+wj+DYC3k0njEOl+Y2LX4Ah
         tIaQ==
X-Gm-Message-State: AOJu0YxGNNxguMvc3Jsa/kHuvgM4cfN/A216+zyt7HsopT+eyeOJi5xj
	wSKCiks/26TC6u7oGhGQKN7b3S8lvNg=
X-Google-Smtp-Source: AGHT+IGFZeUrJrNyb9PFJw/6+D7tjY6iEaOBrvsPZLWtjmp8gFpRySGHdxgk85AyIfxdxLa5ETqGrWwR6y4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:1e46:0:b0:db5:4a39:feb8 with SMTP id
 e67-20020a251e46000000b00db54a39feb8mr64580ybe.8.1702491314920; Wed, 13 Dec
 2023 10:15:14 -0800 (PST)
Date: Wed, 13 Dec 2023 10:15:13 -0800
In-Reply-To: <84ad3082-794b-443f-874a-d304934a395b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208184628.2297994-1-pbonzini@redhat.com> <ZXPRGzgWFqFdI_ep@google.com>
 <184e253d-06c4-419e-b2b4-7cce1f875ba5@redhat.com> <ZXnoCadq2J3cPz2r@google.com>
 <84ad3082-794b-443f-874a-d304934a395b@redhat.com>
Message-ID: <ZXn0sR6IyzLzVHW-@google.com>
Subject: Re: [PATCH] KVM: selftests: fix supported_flags for aarch64
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 13, 2023, Paolo Bonzini wrote:
> On 12/13/23 18:21, Sean Christopherson wrote:
> > On Tue, Dec 12, 2023, Paolo Bonzini wrote:
> > > On 12/9/23 03:29, Sean Christopherson wrote:
> > > > On Fri, Dec 08, 2023, Paolo Bonzini wrote:
> > > > > KVM/Arm supports readonly memslots; fix the calculation of
> > > > > supported_flags in set_memory_region_test.c, otherwise the
> > > > > test fails.
> > > > 
> > > > You got beat by a few hours, and by a better solution ;-)
> > > > 
> > > > https://lore.kernel.org/all/20231208033505.2930064-1-shahuang@redhat.com
> > > 
> > > Better but also wrong---and my patch has the debatable merit of more
> > > clearly exposing the wrongness.  Testing individual architectures is bad,
> > > but testing __KVM_HAVE_READONLY_MEM makes the test fail when running a new
> > > test on an old kernel.
> > 
> > But we already crossed that bridge and burned it for good measure by switching
> > to KVM_SET_USER_MEMORY_REGION2, i.e. as of commit
> > 
> >    8d99e347c097 ("KVM: selftests: Convert lib's mem regions to KVM_SET_USER_MEMORY_REGION2")
> > 
> > selftests built against a new kernel can't run on an old kernel.  Building KVM
> > selftests requires kernel headers, so while not having a hard requirement that
> > the uapi headers are fresh would be nice, I don't think it buys all that much.
> > 
> > If we wanted to assert that x86, arm64, etc. enumerate __KVM_HAVE_READONLY_MEM,
> > i.e. ensure that read-only memory is supported as expected, then that can be done
> > as a completely unrelated test.
> 
> selftests have the luxury of having sync-ed kernel headers, but in general
> userspace won't, and that means __KVM_HAVE_READONLY_MEM would be a very poor
> userspace API.  Fortunately it has "__" so it is not userspace API at all,
> and I don't want selftests to treat it as one.

Wait, what?  How does double underscores exempt it from being uAPI?  AIUI, the C
standard effectively ensures that userspace won't define/declare symbols with
double underscores, i.e. ensures there won't be conflicts.  But pretty much all
of the kernel-defined types are prefixed with "__", e.g. __u8 and friends, so I
don't see how prefixing with "__" exempts something from becoming uAPI.

I completely agree that __KVM_HAVE_READONLY_MEM shouldn't be uAPI, but then it
really, really shouldn't be defined in arch/x86/include/uapi/asm/kvm.h.


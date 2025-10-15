Return-Path: <kvm+bounces-60077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD726BDEEDE
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 16:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F3B54845EC
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 14:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17AA124C077;
	Wed, 15 Oct 2025 14:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pYqjntsk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF22A1B6CE9
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760537095; cv=none; b=CTSL/TFhFsmNI7X7mTqH3kYstwcV+ls0JiMJOw2p58X8Sz0DuOTF7nsa/2tmAk3VZ4r1+DRblf10Mu2gyMieWKwAB2H5J1dxNqUJItTO5yTIpDcQ2MsWKh0Hw3V7eChpjFexfuW221ZNyz+2egQNM7Kom/hGQpDpR+lG8lsjols=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760537095; c=relaxed/simple;
	bh=FKP112/g/eo72651dC5ZG86Ojol6zoySUjFxfFoQock=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MNH0tofIFxRXVsSRoGWLYufO0h0xSmcXhlLgr397YShaUyB8Y6em/XdgxeAMQSB4d7NlM19xXhAF31b5Zh8A1mPH7cjnJX3aOgLdyrG0ZtaweXoy0/ve5wUBCODbXflCV3e/zmWIjlBftuSB/V+y/QvTZ4J9xEXp9ZaerdVlR/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pYqjntsk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ecab3865dso16646041a91.1
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 07:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760537093; x=1761141893; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4DiBH4L2zFebqfEoDk29CwM1Bc3n2gl1Oz2cKH7YPo=;
        b=pYqjntskY9j3TfhslNpiCmMoG6yq76t7UeNuSLWv37aKtqGmlsrqV1pBnKjBlku5PV
         s9XkvGwMZaE9yRYtUS/n8GmXclGg3TrXaxHu3nTtYL2PivX34qesYwvIxV3PGXJWAQ4H
         VmdL0ALMaZ9Zt4VHnuK8lJlcHjKVo7VALDXWwKRmiXwrwGSlzKxVcTFKg5GDzvDIRo2j
         BGipfeoBpBOwsduUiBN6pVP4sPuMFu9g3agDt3DwARtKQgYYTf/ekiQWsd9URbHtqcCb
         uDDfhWIPgSjdQ5N8DjvI+toOh5j7+CouMIuxtjpO+ro9oa4WagmXeQiMm3zoS5q3850A
         Aspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537093; x=1761141893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4DiBH4L2zFebqfEoDk29CwM1Bc3n2gl1Oz2cKH7YPo=;
        b=Azp23gJ2WaZNTpwOhK//jz9dCiYfNjk1hUJDQQ7OxrEgqW2YotOH98IDH2E2t/svLT
         ber2IkgPCet5ZxdCzUMqTX3vyEAFAtzCfsZBNvbIk0VMc/7m/rWEQdv4U4sBpvphxOV0
         t+K2RW6t2S2KMXD9BKeeqrQXXCacbTsvMdXHO3Dnv0j4+y3AoFhxDnKaaUr5WSfvh3+S
         zg2XEcuUwBdCxeFgUSLrcUgdifRnf4U8cw0ARWFCAKI0z5RHjLBqM36rp0ZMutti0qop
         F+bfHfQ2NR2V/6tCJpj5yU+zq9fyZdRYjIfwHuRadTmLESUnfi4YHrMg/YBL2owNbLc1
         elmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXy307Mlsy0mpkPS+4YwkJcqWtVMaXV+nWeadHb/U51OMC6jjXagT/o9bzGhdLSJIQrTUY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhoUYJ+q5ZK1+wI6QG4I9qi4AGJaRTqmzp2HeF5eW1yhBZ3O0Q
	9v7MM/K0M3YUu4sgpWa6RPekSqSa0v1+OtDvj8gkYJXT5fJCcpCyT3JaKvj+HXnFA2Sb93UO3P7
	AdNIX9w==
X-Google-Smtp-Source: AGHT+IE1+td5soWF05Hoahm6Hvpema7mHvLUqdyQlzOJZyQi5z9/sZLyyXRWNTOg3FlzXOK9GExt35QwxNQ=
X-Received: from pjbkx5.prod.google.com ([2002:a17:90b:2285:b0:327:c20a:364])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec4:b0:32e:d16c:a8c6
 with SMTP id 98e67ed59e1d1-33b5111bd79mr42350202a91.16.1760537092984; Wed, 15
 Oct 2025 07:04:52 -0700 (PDT)
Date: Wed, 15 Oct 2025 07:04:51 -0700
In-Reply-To: <81af1654-5cb1-405a-bd42-670058dd22b6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251014122857.1250976-1-maz@kernel.org> <81af1654-5cb1-405a-bd42-670058dd22b6@redhat.com>
Message-ID: <aO-qA0oz5PyqPtGj@google.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.18, take #1
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jan Kotas <jank@cadence.com>, Joey Gouly <joey.gouly@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Osama Abdelkader <osama.abdelkader@gmail.com>, Sascha Bischoff <sascha.bischoff@arm.com>, 
	Sebastian Ott <sebott@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Paolo Bonzini wrote:
> On 10/14/25 14:28, Marc Zyngier wrote:
> > You will notice that, just like I did with the main pull request, I'm
> > adding message-ids to the tag instead of putting them into the
> > individual patches. It looks rubbish, but I don't have a good
> > alternative, and I'm not prepared to remove provenance information
> > from the stuff I ferry upstream.
> > 
> > I'd welcome any guidance that would make things suck less for people
> > reporting bugs and backporting stuff, despite the "Link: is bad"
> > nonsense. Preferably something that we can adopt across architectures
> > supporting KVM.
> Because you're already unusually meticulous in tracking tags, I'm going to
> say whatever floats your boat.  If you want to add it to each patch, I'm
> certainly not going to be the one to complain, and/or to make your life
> harder, because of something like "Link".
> 
> Personally I think that there's a different between adding something
> mindlessly as a cargo cult, and adding it *unconditionally*.  Link is the
> latter, it's unconditional because it may be needed *later*.  In some cases
> it may not be strictly necessary (for example the tip bot used it to send
> replies, and that is served by notes just fine), but overall I don't get the
> hate either.
> 
> In fact, I'm very adamant about *needing* Link trailers for each patch in
> the RISC-V pull requests, which are the ones I look at most closely since
> the code is still in relative infancy.

FWIW, adding Link to every commit is a hill I'll die on (and Paolo has confirmed
that he doesn't object), it's simply far too valuable.  And as Paolo has mentioned
off-list, I don't think Linus will ever notice, so long as we don't send him
garbage and thus give him cause to see what lies behind the Link.


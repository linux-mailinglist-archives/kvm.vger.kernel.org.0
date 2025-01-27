Return-Path: <kvm+bounces-36684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88E1BA1DD04
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5F933A4B90
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3E0194C61;
	Mon, 27 Jan 2025 19:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ETPXi6Wr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D2313AA2E
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 19:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738007929; cv=none; b=tH2Wd65vy9v+LA0+4340sJ8BnzT+4uuTuPulvSRvHSqMKU+YRD65XCAzFNJR7QRKsJD05E4F8pnr7NLJCBl9ZlDp5mm1OI31qwEM5Q8+f5VbOKX7jGcARzv87O6rBdGGWHzsC3gZxwcUZ8Ow6Jkvugi1uJ6Xj2C1ry1vnk7fVgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738007929; c=relaxed/simple;
	bh=RUgNDZT6ZECX7QW5vw20WGkhGuxI06JM18uIhwsPvaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cogkq0sK/UGHORKdKLn5gJadAFuPJiWTKfRzvJv8PLwTvDe7F+0p8psJ4VRGP3Jch8vEyqD4btg8zy+Isy7DC25inPM1v4KAStAmRAho1nAkyjaYZfhS8mucpf5b4nB5bc1zCfFKwuNAjojZOHUQ7DGfFl5mW2BpRjDGauQ6j+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ETPXi6Wr; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e399e904940so6523249276.2
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 11:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738007927; x=1738612727; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cqA8Wv09Zhq2wnFDqyF66mZOvWwOTjKU2JnkWUmzo3Q=;
        b=ETPXi6WrFFIWV7QepbYRC2D+jDBK/8aPrE/Ny+YuGa+vnKQNdVXk1XdpedcN93dyPO
         TgsPL3k+e7ccrW0AAURXay76S/DEHYxPeNgAiwjV/OBEigso68Zst3h4IW2wsv6h/aLE
         dHHfYxcpj8r+f+8TIA41uZbyEnXAZxqZcOy5YzFrR5SbFVbu51CEvtkHvfvuMKdi4j5X
         VXwf1TA9o9BuLgln3TtbUmJ9oW/rEk/W10vIv7RHOfZADv6jblT85YNSxEFmLvdghCUT
         JWmi1lc8URz+VxOUijYjfgMTKzQaUBhnSy5d4lW9h1rAimyaxMe5z/6Rxrv82TQOVrov
         7IWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738007927; x=1738612727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cqA8Wv09Zhq2wnFDqyF66mZOvWwOTjKU2JnkWUmzo3Q=;
        b=sbIPdyw/CcfAx5Ev2GAGoEZVmicb+SFbGQAzqLVliugUL517vM+HswANnMuQXKZHsD
         qS0X19dgLjgG7CxgUHBBnU2WfzMhfHt8Yke1MajqmescQ8YAQTOQli3a16GWv8yZiAlU
         y7Vs+QRCDOFVvyC+X5Eo9ZielW05qqswUGJDHFN0T++l1zRzH6GhKxGu3eBmkEay1+zn
         F7JsGsgna9H9J4Tav9PFxPFpEWY8+PBa/yy37HA/qmRSebzK8sukPsEUhDmHSFGA1VkZ
         cgW1AL8wW14DmNAg9Gww8lR/f4mzsoO8BBazivfGWrV4FfR2NnlvH6m/JFpgHTI04WLY
         zM4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXq45S4eRXYuv4A2Jvevr+RHzARdB2P+9mn5lNLnJbzTIkYaU21yOj0ffe4GRv3si5PI30=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3gKE+lsSW5UQeiqUQ+V+N+XpP1ZFQqgMSANPuKgh0NKHzd0KP
	E3+JN5spsvNqjPm+svvrsH2KedCO9itfJx6gJ34FAFoy7dPHIS6IOeAx55qy72G2B+MpZShMHiG
	1+sL2/jbkLFcBClvgynjjBnyBPmweRdUEzr0S
X-Gm-Gg: ASbGncvAJ/W0ayFoNvobT1pTufm19y5TIabbrrHlTNVnyK84L2LlTyHCucTf5s7QeLb
	rQ62QuRAikfszRyV4TjnfSj4Bo7i33dNz7Z7QYntL3tibizQAgVNZVej4hxEwF3F+tnedWMviYF
	tladPOYjLyM0Opsb3r
X-Google-Smtp-Source: AGHT+IFK77zTdzpFbXHH8Ly+bnH3N/0s61hCvWOt6DOJqxZREt3FXYVwzvN56qYwb91PvSLuG4U20UofNSeWuX86p8E=
X-Received: by 2002:a05:690c:6812:b0:6f6:cba2:a881 with SMTP id
 00721157ae682-6f6eb93f1e7mr330768667b3.33.1738007926728; Mon, 27 Jan 2025
 11:58:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
 <20241105184333.2305744-6-jthoughton@google.com> <Z4GmS48TBDetli-X@google.com>
In-Reply-To: <Z4GmS48TBDetli-X@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 11:58:11 -0800
X-Gm-Features: AWEUYZnbJN6CbJXhOD4hYvtSjhj2toSwm_f0Tw0RcwjBx5GoH7xz6r4s2TeKbHc
Message-ID: <CADrL8HXHy5j6QLU_7+jeFbdiddeAMg_-HAWwO391qkOTuXCuQQ@mail.gmail.com>
Subject: Re: [PATCH v8 05/11] KVM: x86/mmu: Rearrange kvm_{test_,}age_gfn
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 2:59=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Nov 05, 2024, James Houghton wrote:
> > Reorder the TDP MMU check to be first for both kvm_test_age_gfn and
>
> () on functions, i.e. kvm_test_age_gfn().  That said, even better would b=
e to
> avoid using the function names.  Let the patch itself communicate which f=
unctions
> are affected, and instead write the changelog as you would verbally commu=
nicate
> the change.
>
> > kvm_age_gfn. For kvm_test_age_gfn, this allows us to completely avoid
>
> No "us" or "we".
>
>
> > needing to grab the MMU lock when the TDP MMU reports that the page is
> > young.
>
> The changelog should make it clear that the patch actually does this, i.e=
. that
> there is a functional change beyond just changing the ordering.  Ooh, and=
 that
> definitely needs to be captured in the shortlog.  I would even go so far =
as to
> say it should be the focal point of the shortlog.
>
> E.g. something like:
>
> KVM: x86/mmu: Skip shadow MMU test_young if TDP MMU reports page as young
>
> Reorder the processing of the TDP MMU versus the shadow MMU when aging
> SPTEs, and skip the shadow MMU entirely in the test-only case if the TDP
> MMU reports that the page is young, i.e. completely avoid taking mmu_lock
> if the TDP MMU SPTE is young.  Swap the order for the test-and-age helper
> as well for consistency.

Thanks, I think this is worded very clearly. Applied verbatim.

Noted your tips for future changelogs.


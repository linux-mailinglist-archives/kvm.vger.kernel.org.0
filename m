Return-Path: <kvm+bounces-43183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 040B2A86909
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 01:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8ED7467888
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 23:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13622BE7A2;
	Fri, 11 Apr 2025 23:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XkkEmCMf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7447E1E47C5
	for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 23:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744413235; cv=none; b=nNcONmoqrUU4IbNb6SlecHgC55iLJfrdJ+CeAM1b8zCc1GIDJ342G8fGr/dUPD85RHOpfa1jhfL3j9gOTteOmXEjutg330rDjCUwDjgoxebDkw6aqAnSaCr5Ov37FYLKRqQVZoTuEFn5slzZ4Rc5s69InCE60txQA1lTbJXNdYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744413235; c=relaxed/simple;
	bh=ZuIcrKzR77S3rywuzIWFvcaLlqxr+h3zktfH9J5ndLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zg5MBV6QupKVEUGVO2d4g/ok1EH8nAV6wOcYhjcOE1DP4wfWa4xJiPIasVL5kgq0td6/4Z/YiVNutdP9PEGyl7nVmNKZ1/kLzXn4hzQTxBubGstgSkf/lEKS5aXu6r8nP+eTonbxY5T5UbWDshbAKtXKP8xl5Zqs3+t1JHbaGZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XkkEmCMf; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e53a91756e5so2421391276.1
        for <kvm@vger.kernel.org>; Fri, 11 Apr 2025 16:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744413232; x=1745018032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKlZigizjEVKoGnzIAZvuzGR7lV+iJHJRXEgqXvc8+0=;
        b=XkkEmCMfN0uJqGZXi6WRXay8/vI6a3m9oAhYgehkxBT0V/1/RiVBzbByGSwUTK724j
         6olLgYKeTvxgbQc6FBbwy0vcS7ET6UBghEGUbQ8jV8PpDAGDIqyTW2XLJ6KzgwimnCv2
         SxmY5S3NFr+9DS6cH80Zmn2T61wqd+0cWJ6qevf0jJsXzQkYabVmSZ847H9CSRY9DdiY
         sfnar4tVdhGSUtteT8kLFZpZRh/ODtVSGxtEAzGZkAyrIc6SgIufDeybiHIY4XK0BrPe
         H1Nfw0Dsp6DZUAv3xzPyLHyvbosk4WkuHW4iStRmYhNGPfCg0wfEHoEeHQSW9kkXBxXB
         iDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744413232; x=1745018032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YKlZigizjEVKoGnzIAZvuzGR7lV+iJHJRXEgqXvc8+0=;
        b=sFnfbVOqzsrioorve5ZGhH7Q787ERg0j2YbCeul/J6PlCS+Ao8Vg0onQvb2eV/iIkH
         b5wp9dkGkCo/b6cgRS7XAl0Q5zE1OOU/BJSNK1DkxAuiK40ZgtZziuTpkh5aBIG6my20
         BZaZHKHAdJS2VugfADHRmX6Kd+aHg44OPuQiuFgcUS4hGAAL3EqxnWpS/4ZAPsYu3cKJ
         G2F70fmYC0E9v85hMZiNKqcqnrSGMXYX9+ECsRvxHeGNXbh3lIqPrLkLZAs3WOZLuMSp
         rHldtmaQ29T9sSFi2CcxpwuaFnplVXLfTp6gXzWfuEd/660PgfZDemVubHqXI1TNWM3w
         xy2A==
X-Gm-Message-State: AOJu0YwGh7dqZY/EALKho530fIWALmRGYHtygTU1eM8SOt0svdcRRkR7
	admwWP1HJkLNLsBHp4+WwYHriyWoR7um+W6ENv37oVqyLZu5B4By/aOZ3c0BUQvQjcTIFOFJCrW
	z54IC7/GPL1kvso9b6QnyFLd8nPg2GAvhOMaI
X-Gm-Gg: ASbGncuD/3xNRPQgEUm/BQoGlS3VE7lhVN1qLwtyFbwQ4gDBUPx/KYehbA5elrGRcQM
	BZTWsao1k1X2BTz93DyYw4CfdTHnHYZokjSlmUek7euFY7NHbX8dm9pHb/19YYToxn6C7R2Nb5O
	IkYy1CHIkK4bAwU/wOsgHeyA==
X-Google-Smtp-Source: AGHT+IHUa0aOwFiR93RonLdgGAycz902QQYijJ1KESM3WoGwo/vcnDBRRDtj6oj7TNBsL6Aa9rmB1pjYuwu+8AZzwxA=
X-Received: by 2002:a05:690c:f93:b0:703:b770:80fa with SMTP id
 00721157ae682-705599cd6e4mr85757587b3.13.1744413232272; Fri, 11 Apr 2025
 16:13:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250331213025.3602082-1-jthoughton@google.com>
 <20250331213025.3602082-2-jthoughton@google.com> <Z_mFxiXcWKcxRo8g@google.com>
In-Reply-To: <Z_mFxiXcWKcxRo8g@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 11 Apr 2025 16:13:16 -0700
X-Gm-Features: ATxdqUHr4RtBhVEB1WBBU3luDedsUJxjRd02o3MEmhcbXrN14SY5_nC8Tj2kKog
Message-ID: <CADrL8HWum=2uJu6N23SaWHd4r4Pu96GbEqELRms_tq8gtMBbMg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] KVM: selftests: Extract guts of THP accessor to
 standalone sysfs helpers
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yu Zhao <yuzhao@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2025 at 2:12=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Mar 31, 2025, James Houghton wrote:
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Extract the guts of thp_configured() and get_trans_hugepagesz() to
> > standalone helpers so that the core logic can be reused for other sysfs
> > files, e.g. to query numa_balancing.
> >
> > Opportunistically assert that the initial fscanf() read at least one by=
te,
> > and add a comment explaining the second call to fscanf().
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>
> Needs your SoB.  It's a bit absurd for this particular patch, but please =
provide
> it anyway, if only so that I can get a giggle out of the resulting chain =
of SoBs :-)

Ah! I meant to include it. I'll repost the v3 with David's change to
patch 3 and my SoB here. Thanks!


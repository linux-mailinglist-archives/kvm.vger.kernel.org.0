Return-Path: <kvm+bounces-30826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 112419BDB55
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:42:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C06C62849C6
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 01:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E62189F5C;
	Wed,  6 Nov 2024 01:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v0I6Y+Lp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD77E1865E2
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 01:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730857350; cv=none; b=BwxS9w4oPw6g55dn2Pd2pGcH28VyAAPA6apkWVn6Sulip6EPkaMVA+6Ay1yi1SIKVYV1OVXtMq9NZEPEiMrdp2Xut7e/pPZ7tM1XNUHgjfb4isikuBC6NC4E7/eQEug6Ta2HmuL9uh2CxfOIQrtrvwXlaymzfDQY/AQ9FnGThqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730857350; c=relaxed/simple;
	bh=fUj69fUtHJsNp2U8QyTi97PKN8BvhyDx7F71wiOBVfw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RAf+1J3ib2YmtlbufPWw1Qt7r4sK3sfWOLiUaPC5Cap3qpPAHxBk7qPu8zIxyiDrOJ0k/fYnW86pWHsePfhk5828RpftWgZApisjMZNZzrRAqIswHR3iUQFpqA9Z17s3TenbtAMAnqopadk7/63nsd9QC+7sLJdkWqisgxgbZxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v0I6Y+Lp; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e290947f6f8so10796963276.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 17:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730857348; x=1731462148; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=79NlkuP86plJrzGKUva1SSFLp344klrVOU35cyVmWNw=;
        b=v0I6Y+LpE2GEX+4m5lkFcwhT9IIMgxEsdczzqKbPv5ZTz0RcmX7JK+BR6ZSFalj9Er
         6Rrpy5rqFfTnA2m9ptwZEuJVbKdQkpDsRGY4BWLSKiqxJIqEYQOhjp1LTh8AORG+a+2s
         Ac6biAgs+28c+1Lf2IavD58u9lQ7s2Umz+dOp+cATum3/nudw3LncBOjNW5wGTTZFhMy
         9g0HkSkOEcLvRQgO9avtt6JsdvY1l/xw2rYDBCBKU3Sslljyz+6seqkPu7FUHJew6OY1
         Tn1ins/l+im/NUR/T2mkuOQFMG0a6pde9g7DPrdYrDd5fW05mPvcC+1+RKTj+FDIO+ja
         nc7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730857348; x=1731462148;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=79NlkuP86plJrzGKUva1SSFLp344klrVOU35cyVmWNw=;
        b=sATqL9FupNJ0xm4M1udp2A+A4uQrqzFucWfKwEVmw293WGXNXxJ5YM41+ECclMIMxb
         TdYug8CcTVQz3TTuLNhszsteXV0LJstudxiOx7tIJbKpZfXE0Snrrali+hg1Hkh6M0pp
         uzGPwDXk4azcDEWH9dseDZkuDnvZrYzjtyr2CfA7uZFp9KO+8ouAa4/EMwlkp5Dd+Xam
         kjiyML313oWGKw5rQSZ0ywWs3z8VQhZzWomRDcNjjlYcj1fRea3V4PxxWJ8lcNkMUyun
         8tIzaG7bKq9EJ3JGLpxSeaAbf+zoETz0mBjrqmrWbtbJFhaXAaCAA7a1xxBuRtsl1Xme
         jCwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYXQ9bsfEagfy2dN/Az/LJ6qntv7PPdY3UEiRAqhMpBe/cc6xSASEQoOn9BD13Q0E06Jo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5f3A0Q6IkRamRHURrTfn2D8fqDQfz4pivHyWT/2tmD/DNXmSk
	ivJcjSF4iDhrFKoi/yj5PsXLqpefm6fmNbFqXC2zgwg+heOePsmP7GReyDdEbIBRIdJKwO/qWh3
	T4w==
X-Google-Smtp-Source: AGHT+IE7MOG0VDSVDIX11bsiwcWg3GJ7OtgAr+VkxT8HH54dZtUVNELgdDPSd5EDlaV1+PN3XhDIrXF0jl0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:7486:0:b0:e29:74e3:616c with SMTP id
 3f1490d57ef6-e3302556d2bmr11973276.3.1730857347759; Tue, 05 Nov 2024 17:42:27
 -0800 (PST)
Date: Tue, 5 Nov 2024 17:42:26 -0800
In-Reply-To: <CANZk6aSUzdxT-QjCoaSe2BJJnr=W9Gz0WfBV2Lg+SctgZ2DiHQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241029031400.622854-1-alexyonghe@tencent.com>
 <20241029031400.622854-3-alexyonghe@tencent.com> <ZyD76t8kY3dvO6Yg@google.com>
 <CANZk6aSUzdxT-QjCoaSe2BJJnr=W9Gz0WfBV2Lg+SctgZ2DiHQ@mail.gmail.com>
Message-ID: <ZyrJgh_9q-PoDfL1@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: introduce cache configurations for previous CR3s
From: Sean Christopherson <seanjc@google.com>
To: zhuangel570 <zhuangel570@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com, 
	alexyonghe@tencent.com, junaids@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024, zhuangel570 wrote:
> On Wed, Oct 30, 2024 at 4:38=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Oct 29, 2024, Yong He wrote:
> > The only potential downside to larger caches I can think of, is that ke=
eping
> > root_count elevated would make it more difficult to reclaim shadow page=
s from
> > roots that are no longer relevant to the guest.  kvm_mmu_zap_oldest_mmu=
_pages()
> > in particular would refuse to reclaim roots.  That shouldn't be problem=
atic for
> > legacy shadow paging, because KVM doesn't recursively zap shadow pages.=
  But for
> > nested TDP, mmu_page_zap_pte() frees the entire tree, in the common cas=
e that
> > child SPTEs aren't shared across multiple trees (common in legacy shado=
w paging,
> > extremely uncommon in nested TDP).
> >
> > And for the nested TDP issue, if it's actually a problem, I would *love=
* to
> > solve that problem by making KVM's forced reclaim more sophisticated.  =
E.g. one
> > idea would be to kick all vCPUs if the maximum number of pages has been=
 reached,
> > have each vCPU purge old roots from prev_roots, and then reclaim unused=
 roots.
> > It would be a bit more complicated than that, as KVM would need a way t=
o ensure
> > forward progress, e.g. if the shadow pages limit has been reach with a =
single
> > root.  But even then, kvm_mmu_zap_oldest_mmu_pages() could be made a _l=
ot_ smarter.
>=20
> I not very familiar with TDP on TDP.
> I think you mean force free cached roots in kvm_mmu_zap_oldest_mmu_pages(=
) when
> no mmu pages could be zapped. Such as kick all VCPUs and purge cached roo=
ts.

Not just when no MMU pages could be zapped; any time KVM needs to reclaim M=
MU
pages due to n_max_mmu_pages.

> > TL;DR: what if we simply bump the number of cached roots to ~16?
>=20
> I set the number to 11 because the PCID in guest kernel is 6 (11+current=
=3D12),
> when there are more than 6 processes in guest, the PCID will be reused, t=
hen
> cached roots will not easily to hit.  The context switch case shows no
> performance gain when process are 7 and 8.

Do you control the guest kernel?  If so, it'd be interesting to see what ha=
ppens
when you bump TLB_NR_DYN_ASIDS in the guest to something higher, and then a=
djust
KVM to match.

IIRC, Andy arrived at '6' in 10af6235e0d3 ("x86/mm: Implement PCID based op=
timization:
try to preserve old TLB entries using PCID") because that was the "sweet sp=
ot" for
hardware.  E.g. using fewer PCIDs wouldn't fully utilize hardware, and usin=
g more
PCIDs would oversubscribe the number of ASID tags too much.

For KVM shadow paging, the only meaningful limitation is the number of shad=
ow
pages that KVM allows.  E.g. with a sufficiently high n_max_mmu_pages, the =
guest
could theoretically use hundreds of PCIDs will no ill effects.


Return-Path: <kvm+bounces-15112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A2A8A9EB8
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 17:40:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A878E1C2215D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A4216F84D;
	Thu, 18 Apr 2024 15:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R3NzpF91"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624483B18D
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 15:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454820; cv=none; b=R4juxLPdDWFiJKKaqobW8rnuXqt4vSChE5N4G4vUuqGK0MO57MNdD7uMF4yhUZZ4z6uqPsATxBZBv0gUC5ABlUFKZXdoe9zpKgW+81+k1Y1rULEeqnmzI6hZXuoBPFLaWzB58w/vRKEFq9IFjyUTNuFheGz4xQj/VSBWTwzrJek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454820; c=relaxed/simple;
	bh=rZoxkMP572cXD8H7MwmnRT7l2/u/u0aJXcnV7sPJgNg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qb3s1ZU/tSlE/QRYyCL/n6x5+kiSiDQX00mbtOw6CeAfvCtexIZhCewVw2gHttiA4smLKS92CIJYUad4ALnZwFnAUbUz948gY/qvoZkRkEbh43/nRBbphv6F9yxY2fHnKm0oeLJ/L7B6K4gYdV8h5irlPQERWlBzQaRV3J6ESHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R3NzpF91; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-619151db81cso27007597b3.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 08:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713454818; x=1714059618; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o/3CBX6p3XiGZWIm/Xco22tdx8X1TjRqWPXp8qWEXKo=;
        b=R3NzpF91xqZyAfNoGSnS0JerE/QeI4o+04iXKuWHzSUWSATecMeF2eaUEVUz7y1vZy
         jS/MSbDIxm571YeXrjHN/BxTO2KKfCPK4tGH5FzyY6s0zavuvf0nQXd4b8jn0sEDllGK
         oRmLDySGYSuwQZrXIPD7ZBeoHTTcR6pODbQEUpAxg8WyCM9PvdOO1h+mYhSO/Z9dSPKf
         wrl6r7VeR/pe8nDGWhoLI5bROELHlPuff7A9h4/mm8lIqPEUAhcqIel/HIlor3AVr/qE
         mYa1FNoSrjDwH5aSi25zYmv81nwPn0ZoYPZ5xi76EFQboAuhU/nvV6QElo9WL2I1GEf3
         8sxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713454818; x=1714059618;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o/3CBX6p3XiGZWIm/Xco22tdx8X1TjRqWPXp8qWEXKo=;
        b=J6Xom5RDZCiD8T10ujzAGQfOEJxKpzTVCyEjXkasPYTPeRvbPar/US2I3DZabpyUPt
         JHrIZTEyZqUy6CIaUHc1kvh0IilSphshWmtiS56Cs4N657xdqcJgBJpPh00nXwG1p8NZ
         NwB0sQwnqbOIbyoQ1fUIv8hwih10l10aPcSpwT42mfs+YtZlLfoJT9mnj/v8XzWoqbeX
         vh3P4oRUB9UWU0vZ51CPeEQGit8C4/2PRqWN8TfRagxuA9UlrSlbqRi9mR0IZcB3OXFh
         BBIlxLteoUYZeAExa1n5nFOvD7sFkfOJ10MtYP5r7YuRwQPYExTuIYImSUJrVgDhJil0
         jO4g==
X-Gm-Message-State: AOJu0YxbeFRgiyifiQ2zpsSyiUm6CrkAfCisuUnsq8UtyV9R0PuTvlDt
	Sn+TRgfvIvQeGdXCx4ggaZC5JlNz9jByAYF0/G0GrUhJslADyowsoyJzNu4J73Z/+fvh3gmW+/k
	F2w==
X-Google-Smtp-Source: AGHT+IFMflIA8Fy/KN5D3SfB3zzGK+sKaqWwXmXJ6gle7EfUrs/CN7CJxa/pJO6PUEK97j0Y9YWzQ7KYt90=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:748e:0:b0:dc6:deca:8122 with SMTP id
 p136-20020a25748e000000b00dc6deca8122mr560803ybc.5.1713454818493; Thu, 18 Apr
 2024 08:40:18 -0700 (PDT)
Date: Thu, 18 Apr 2024 08:40:16 -0700
In-Reply-To: <CABgObfaS7RhUPe_FYS9SCuDzOfFw4X9P8XOhJSspVdzsYeoX2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <CABgObfaS7RhUPe_FYS9SCuDzOfFw4X9P8XOhJSspVdzsYeoX2A@mail.gmail.com>
Message-ID: <ZiE-4EBOdbU0Zn8o@google.com>
Subject: Re: [PATCH 00/16] KVM: x86/mmu: Page fault and MMIO cleanups
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024, Paolo Bonzini wrote:
> On Wed, Feb 28, 2024 at 3:41=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> I have made a little hack for kvm-coco-queue, preserving for now the
> usage of PFERR_GUEST_ENC_MASK in case people were relying on the
> branch, to limit the rebase pain.
>=20
> The remaining parts are split into a "[TO SQUASH] KVM: x86/mmu: Use
> synthetic page fault error code to indicate private faults" commit at
> the end of the branch.

Ahh, I should have read this before reviewing the other patches.  Thanks!


Return-Path: <kvm+bounces-67074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C6B1CF53FE
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 19:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8B5F3060A76
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 18:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 871B33271F2;
	Mon,  5 Jan 2026 18:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IMStvlLB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA3A33FE05
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 18:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767637907; cv=none; b=iiKDXk3ZxI7pa/4XKIo+1UKLvmEt3eO6kWGm0SLNoOLyomn5lHYQsT7DIeIeQWITl8dySQIZz2U+9WXUxTkLEmVqdqqXV+tUZtESb54CoGCY1qP8GafUBOExAkJBTTIf5gV7xLlkx0IxgOpiJLCp5iPKr04hkiU6qoMp88V8D1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767637907; c=relaxed/simple;
	bh=Hjb9PEmk0CwZ04L7O6evq15v1hkM7p+EwzDaeZG5gbU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uoCvFhSaTIdHXd+B69X++mFv00iiYSguvZDZmbrMUyFbSmR0KdfGgVd2ixGblpEQheYNOwQNuQyQOhUrb7fuZlW7JXh2Z/wuT5tM57KU9PZwIU9ifueFpLoMC4cy3DwElrB6AOXC9BhqNDn+eezaYym4sUjLW3YKPkyljVheISo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IMStvlLB; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-598f81d090cso153895e87.2
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 10:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767637903; x=1768242703; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hjb9PEmk0CwZ04L7O6evq15v1hkM7p+EwzDaeZG5gbU=;
        b=IMStvlLB0+eiNPE7JXcKNqSOFV14AFx624sv2VzPPYZipiSGsxskYql/8lNoYTQLHx
         6wvKxdZzPbgodfqXxn5ksTeJZtJnqo9pQnrbBhp750UMOV48qf8ZL04sfIOSxckKhbWS
         ZMVQxz+4GRyNNHKJzOqA6UPxso5O1W+GjXS1WKPoT9bQwauU99EfcznLuHDIViGK1Wnn
         +UzG9iswK9EjuezFFHYmSGEtoGmw122JzIfXZty+rCkQUpqxDxA4IApmd7gI51pozPmB
         1fUWJOAR0f1tju3OZ2haysYLmk6XAg2mMPkBVNQ+jmrtwZ3R194BTkWoaeMPy7jXFbkD
         lEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767637903; x=1768242703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hjb9PEmk0CwZ04L7O6evq15v1hkM7p+EwzDaeZG5gbU=;
        b=P0AwR4K7/lXb42hRZXhL3anofoibC6dreqa4RpJGancnhBC8Ci3FeCtwnyPskPG4MM
         g3mzStKZmvRgXidv3DTWmyYiTHcwA42ZUJ8v/rgi4Xi1VPCHF3oTn8MTVhLbaSGhtTOK
         fxjWdMk/Oalo0FW/3HUG26oWzbgHVJSoYuqpoT9lm+8YFnLryl+nBjlHS5NuEjfs1bHc
         +jYkWhcHJSHj9VJj1WiABXqzS/W1m5ybu/cqsafiNlxi+NSHvpbgnh/ML7Eeu0fiPxKK
         3vXVQR66a46kqZFoXCiY4ZxVFS9XNyJwIqmmKwAb0KQrVi9J392Fbs9QnbMswOt7jehv
         FmuA==
X-Forwarded-Encrypted: i=1; AJvYcCV6uyIFWfKEkCPSi9qpmipJbf/xKVbTeS81UvXDdom7Ofnaa6d4HhizSb9mS13imokF6yE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLl2fScMklBjvUGpMCwcnUl0dFqsvV/Y5vuEtk/ERyid6ooqfb
	Xd/KKj8hekgTYJnqXWlhbj5ABf/U7kpQDDJEQHjUPHf73QKgBD4XHpczM6cBtmMcZJTQh30mLW1
	IYzVHRBJsIjELSSgKeFJ2xCIpmQSNFdQIBlpSno52
X-Gm-Gg: AY/fxX7wF/2syxc3XiMsmlRHYyXuK4MjdR4Fl75/z80GwN/IbCVUZlUwEChi38lc+Ox
	MMpzX20m7tIKbcUgB4faX62j1JD+gR7gCg+DwEu4KGrHMwvRQ/km818nPQVGr3k5EazxjHl8oSw
	pMxEwfd3CAnuDghTGTLdttnorqsEDr7jVDSLbQX65OxA4zUjWWa3k6y2BwNCzZeAGL93Jz1lInV
	V61xiWyYjU0wbnOkww/GHOvqsthPb2MOWkHTluHUZtPgwHVjmfGLHa71wx58QUP310or8lmRMJO
	W8/OJ9E=
X-Google-Smtp-Source: AGHT+IHdR2+io7/Yo4N4iYBgt1cqRemG+YBgtGJJ6X+momuowtZE6LCsA9lnKpeqVYlpau849KCt0SwwWBBAtMQk2pk=
X-Received: by 2002:a05:6512:3b20:b0:595:8258:ccc5 with SMTP id
 2adb3069b0e04-59b652544d2mr223814e87.26.1767637902982; Mon, 05 Jan 2026
 10:31:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223230044.2617028-1-aaronlewis@google.com>
 <20251223230044.2617028-2-aaronlewis@google.com> <aUtLrp2smpXZPpBO@nvidia.com>
 <CAAAPnDEcAGEBexGfC92pS=t9iYQRJFyFE9yPUU916T92Y465qw@mail.gmail.com> <20251230011241.GA23056@nvidia.com>
In-Reply-To: <20251230011241.GA23056@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 5 Jan 2026 10:31:14 -0800
X-Gm-Features: AQt7F2runKUQHU9-oW7zHMSmwf0lpU6DHnYPnmwP1ApVliyQmJbYgJ5T7nshrNY
Message-ID: <CALzav=c32W4d=_WtXHWDmjfQaJDyzdxWXS9_kVHvseUsqh=+NQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] vfio: Improve DMA mapping performance for huge pages
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Aaron Lewis <aaronlewis@google.com>, alex.williamson@redhat.com, kvm@vger.kernel.org, 
	seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 5:12=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
> On Mon, Dec 29, 2025 at 01:40:02PM -0800, Aaron Lewis wrote:
> > Can't we assume a single page will be mapped contiguously?
>
> No.
>
> pin_user_pages() ignores VMA boundaries and the user can create a
> combination of VMAs that slices a folio.
>
> In general the output of pin_user_pages() cannot be assumed to work
> like this.

Ack on the feedback that this is not a general solution and we should
switch to iommufd with memfd pinning for our use-case. But I think
Google will need to carry an optimization locally to type1 until we
can make that switch to meet our goals.

For HugeTLB mappings specifically, can it be assumed the VMA contains
the entire folio? I'm wondering what is the safest way to achieve
performance close to what Aaron achieved in his patch in type1 for
HugeTLB and DevDAX. (Not for upstream, just internally.)


Return-Path: <kvm+bounces-21362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 403C592DB56
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5BA6B23BCE
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F79414B082;
	Wed, 10 Jul 2024 21:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x+JLRtdo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAB81459E3
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 21:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720648593; cv=none; b=gO2akBm3gzAW/ExVq3JItajdl+PDGIhPOKIQPZAGVAqbkePVVxNSuLxcQIb+rL1DnfNPj8abk1dFZ4Law4Fepd/3QEHqmpdEx7SjtFGoSztJU6CaKJtIump//5VIrWsP/uybAK8gFd8HqBL1740u5a2Gywfw9LwzUhTHnZt0Qtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720648593; c=relaxed/simple;
	bh=v9gwvodIALaLZTiFk6iAF1MBNoj2kgdUYunqdySS94Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eGuZ9pDoon3Xy12LETwMXMMWGmRU2yV25QgPwjRXkDKVw2I6kq2QPqh92aQETjOmUv91g4h5lIVM6hi+RjQQNUZo++OAPh/xeX/P7gP4Jj2L0GIGABYzAaDUXgBMvyE2lhQuqDFC9R/nudwK2wQ9YDIKjTzk3/l5TZtEB7XrfHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x+JLRtdo; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fb05cfe1cbso1273095ad.2
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 14:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720648592; x=1721253392; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UOPY7FMtYeUU5dmTWp7HgAObmI5uYd1GYWNtWLDcPCg=;
        b=x+JLRtdoenShBIQt+J2J4r4i2Jzf4EFsIFG1RcyMtwoBV5Lfxi1zw0VtDsJ1ee5uTS
         SvOSgOrHnysBNoVL0aROIW6qbGzS2Rau4cOo5ujjicB2O2cCBPFRyNjM1WEnbcpTywJ9
         zmSy6B7Obzyi0nF5e7pGSKmnNJ3VmsrorT0jE04k6fJu24AF3OcAKHk2CnG2pcplk/Kc
         hhMNL3rpESY8VH12B4+4uGkIISUEHK8bkazHE9Q5lN3NRrBnLc88cJJq05HAuF1iF4I6
         0khy1v8ki4k/gi3jKN5ZQyB/lQkYkbP3Kf15m6K5e2UneBstb+0/HA+F8OY6XCIJ7WR7
         p2Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720648592; x=1721253392;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UOPY7FMtYeUU5dmTWp7HgAObmI5uYd1GYWNtWLDcPCg=;
        b=j1AtCjNpLqbcjb30MdJfkjspW7jeu+oTav/TGDud86XFLXCtgt5qCpGdmMNpG92xjG
         tai6L8MFHmlKcR9Y5Gh0Gpv7YBN3keCYhVRXfiPeAOoWe8Wns37ZBhn9tSJE+BI5d4ko
         XTzAE8CCOoXZjqaafxd1VzUoZKlFhHLmzAfknWZNa6+Ze/jHB+5qSiLh7tvHvjaFcGfx
         aFaY+VygadHdzbdaSXw8/MrLQTpVXAinVChvHGh69wADkrhaVLDsoLXJAUGB7A/LMzJS
         YjWeG6+2V62aEq5qErqDtRt5yp+LA9Zi2C6cP3ZHrPdxDW5Fbg1tHV/B6F56lVeAj5XC
         L77g==
X-Forwarded-Encrypted: i=1; AJvYcCUKe3F3MwWb3E/viqZ9phl/WmKCaIcvjDGMm1G7GRGRiuMg8Iv5a/QUByvqbBDT7uRfjMX5OV81vNghW3m0iJjpJSEV
X-Gm-Message-State: AOJu0YxECGngzfFd3yM9eYfd9Zrql+U7h8Kq84lFkoVMCMkMqIVr0yHc
	XX3S1McatqCqDnG45IChTFUjUQ+9JHB2eWdXbB9n7r0Kle9FNXva9cRQJTtuqIIlQy0Tc56OHcG
	FAg==
X-Google-Smtp-Source: AGHT+IEQe0aTdA93AgOP3bdo/+RIy3w6WTsIhnoelP3F0c9LSyPhjCsXCn6PU46FDaxB5eEK34EWvS5/yeU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e541:b0:1f6:fbea:7959 with SMTP id
 d9443c01a7336-1fbb6c228a7mr4802475ad.0.1720648591757; Wed, 10 Jul 2024
 14:56:31 -0700 (PDT)
Date: Wed, 10 Jul 2024 14:56:30 -0700
In-Reply-To: <CAF7b7mogOgTs5FZMfuUDms2uHqy3_CNu7p=3TanLzHkem=EMyA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710174031.312055-1-pbonzini@redhat.com> <20240710174031.312055-3-pbonzini@redhat.com>
 <CAF7b7mogOgTs5FZMfuUDms2uHqy3_CNu7p=3TanLzHkem=EMyA@mail.gmail.com>
Message-ID: <Zo8DjhQq3GOpmO5f@google.com>
Subject: Re: [PATCH v5 2/7] KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to
 pre-populate guest memory
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, binbin.wu@linux.intel.com, xiaoyao.li@intel.com, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024, Anish Moorthy wrote:
> On Wed, Jul 10, 2024 at 10:41=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.c=
om> wrote:
> >
> > +       if (!PAGE_ALIGNED(range->gpa) ||
> > +           !PAGE_ALIGNED(range->size) ||
> > ...
> > +               return -EINVAL;
>=20
> If 'gpa' and 'size' must be page-aligned anyways, doesn't it make
> sense to just take a 'gfn' and 'num_pages'  and eliminate this error
> condition?

The downside is that taking gfn+num_pages prevents supporting sub-page pre-=
faulting
in the future.  I highly doubt that sub-page mappings will ever be a thing =
in KVM,
but two PAGE_ALIGNED() checks is super cheap, so it's soft of a "why not?" =
scenario.


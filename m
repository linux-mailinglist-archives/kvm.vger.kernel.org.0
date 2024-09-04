Return-Path: <kvm+bounces-25897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D1B96C440
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 18:38:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F58F1F21871
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 16:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA6F1E0B6C;
	Wed,  4 Sep 2024 16:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HXRho4HE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E119B1E00AE
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 16:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725467919; cv=none; b=WP0fvUJlvkBFiY3HIYAznWiV6P29NXpuyQQPDyJ9pQjvbEGd/DsgVNtUO9bixqGZlHmCrDN6JicoWi3SuqdtPL7UgrBskobpso7iTWLjDjEzmiHIXcScrdlAJdX48ElpuAEKfRZ0toYBKzIMgef2jWYicqCwJsqjVzw6RZ2xxMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725467919; c=relaxed/simple;
	bh=/mxnS+fdjiP+kCtyiBUQuycjb8RUUN4u6LVfgbRPcPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tuoEkPW2lgmFN3nIADnZHZhlcJYEAtBZvPQ15lJIQh9g682V8TFXdYPz1xJa1L6ekUlQZe3xRGReCa26vQmiJ+DlSvpJenRpyB617SnKoSPgz5jVYuNdbAQToLJECj6fTp0DFtEPixda2vymKyATwkuLmPKeFW/R6g5KzPbMrH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HXRho4HE; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c24374d8b6so15015a12.1
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 09:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725467916; x=1726072716; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/mxnS+fdjiP+kCtyiBUQuycjb8RUUN4u6LVfgbRPcPw=;
        b=HXRho4HEnOa9kQiu5HKUi7Um9KzIoc/MajCczV10P0ibaEQ6yZTuKxTD+xnxz2Wou+
         o+Ep9P/a7mu7vrxOkl4dQoHuoqbHHUS18kZtDBol5LTOV9X7BXUwyLwL7KpaiY/znqsn
         wmfQrd71gZUnKE5qgAvtPFarL9+htSmPR5pW3UXqwtlmifuYX0jDsU8vBhXVgyfQeyvf
         u5r4vEZtyt/tlrKlsWvvV3IQObgP703DwVfou6Hw15UcFqc+f5pv4mwzufa6847M3n0d
         Zoy49sW2YcFp09RnEm0vvzZIRtRsyw4zMtdpyYtvIijNORvg/LOTBerqFXh/8vlys4oB
         /clQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725467916; x=1726072716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/mxnS+fdjiP+kCtyiBUQuycjb8RUUN4u6LVfgbRPcPw=;
        b=kH+Y8ZI7D2uIFHmcxEbRk/vtKhUzKBV0GItgBc7bNlFPVG0DuW4w8Ncpdpk+jJ5jdE
         EON9BUsGORLaEGT+JXwvwA3oIQSk3YBNDqzNmeoanDOMPUSmuYNL6Aas1qK5tw0H952e
         Sco2+oVKJG0QAJS2U9cFuXl/BuOXpUtpWlMe6JV05BcJm5CNFnR7nO+LEPu64WVBqjMP
         Isdhqg+5y2V81Yha4fSxPpDdvJQdpCXD/9MMOrL/HKWWGuAqphxXKe9KUTwSHs2AH4zv
         7ut9OAitb1vn3pbo1JG0U4IOBPu/VNgt5lxZ142/UEH9MDk1ae7PL8/k3cWFoY1iI18z
         bQdA==
X-Forwarded-Encrypted: i=1; AJvYcCWJdAeLOWgSN9Iyy1uRwX9U+lTKld85nNZxHCIejS9pqeuKCU1JL2eafGDtu1hDhLE/soE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFw0g5YyDArIocFO9NpILyrVpYdSDdTi+hTsOQFVSXKCicduNe
	7D1qMa8P5+YrV7C5TJePfrC8zVWBT0PhpZJNEpfycIT4mgJZSfwVXisbjSgHb1J81SoZScx2XGA
	H26c54QJhoHTa6ta382KFSvTwzkkpkWdpIWMh
X-Google-Smtp-Source: AGHT+IF6UKWmXapLL+d1BWCdn4AUAlZZFF1ra+TJue0mm7OLyZp7Lr+G5pXbIgCO7p3I8Y2jkaZWp5KGqk+tfX8/prk=
X-Received: by 2002:a05:6402:40cd:b0:5c0:aa37:660b with SMTP id
 4fb4d7f45d1cf-5c27858b48fmr241823a12.6.1725467915783; Wed, 04 Sep 2024
 09:38:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826204353.2228736-1-peterx@redhat.com> <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n> <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <20240828142422.GU3773488@nvidia.com> <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
 <20240828234958.GE3773488@nvidia.com> <CACw3F52dyiAyo1ijKfLUGLbh+kquwoUhGMwg4-RObSDvqxreJw@mail.gmail.com>
 <20240904155203.GJ3915968@nvidia.com>
In-Reply-To: <20240904155203.GJ3915968@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 4 Sep 2024 09:38:22 -0700
Message-ID: <CACw3F52qyX-Ea99zV4c8NjyWKgtqAKtNc8GP0JTcLOCOjnEajg@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>, 
	ankita@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 8:52=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Thu, Aug 29, 2024 at 12:21:39PM -0700, Jiaqi Yan wrote:
>
> > I think we still want to attempt to SIGBUS userspace, regardless of
> > doing unmap_mapping_range or not.
>
> IMHO we need to eliminate this path if we actually want to keep things
> mapped.
>
> There is no way to generate the SIGBUS without poking a 4k hole in the
> 1G page, as only that 4k should get SIGBUS, every other byte of the 1G
> is clean.

Ah, sorry I wasn't clear. The SIGBUS will be only for poisoned PFN;
clean PFNs under the same PUD/PMD for sure don't need any SIGBUS,
which is the whole purpose of not unmapping.

>
> Jason


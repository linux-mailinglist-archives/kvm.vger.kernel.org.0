Return-Path: <kvm+bounces-60354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C801BBEAF0C
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A692A7C32B5
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D20EC2E88AB;
	Fri, 17 Oct 2025 16:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="12AT3N/9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8427B2E7BD4
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760719762; cv=none; b=IlO4ZX8H/A9KkmbKPFNB5sHyAkbLthaPhqo82nqi+/WFqH3eXdoESJsSOkUjqp/+qCjNPHNTnEfyqcSxKm4nL/D+3iPHU6bEFmxtNt38rc+cdFhdgENH6LMM4jP2NMlQFVB8XtKhZiAzlMMS7f7H58xILKqt4evRIuUwnxZfLSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760719762; c=relaxed/simple;
	bh=gVgiYRt/rqFaySiyrmr5fh20anzP3rCx+EcjH3amo/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JkvLnRUJXgtgpnOxGvtlMJpoTB/hZKfdo6p+CimmPu1sUvuNUycwuyyi0/CyQX5KUk0aw3gB4TZ27SQKEbleqUSZ3xr80SFM3l/EAsqxT3Nmj/aSfunTeYa1BQoJsH/iN7+viDDG8nvurm7i1Jq1Uii5MGAknnGiCJ9f4xqvrrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=12AT3N/9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29085106b99so22556665ad.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 09:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760719760; x=1761324560; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hOIrByP8ZUQuvgPySyDlm6fhYAgi3WQo8mV8b43qPRw=;
        b=12AT3N/9cYYSiUxzv8icu5bnXMFwA1BBfhhmgMX6ik3Dws1rvaIXGxyG4gAuBajA24
         r7oz/g/ke6UT7zC1KgduHFUn8Boh9M1qMqG7n47AA+4+r2eGXHocdX99KmQV/jU6sPTv
         Qu7Ml2CjIrmGIEVanK485VbbMH0tlSNgf0O5qbAntCG5VuNQ1jGUpCucZHHD0brlx3Pk
         diX6f6POxLJbrF2uaauuy98HKO96AXYEjcBVvl1zFA6DeYJBu6kIX+ABX3RKAKS56UuT
         gOWcquuAcL8TkYO/h2hEjRZOs4wwdz+0feoLoPs2W0q2GFKfily4SlmDL1ejU18kUzwh
         AN8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760719760; x=1761324560;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hOIrByP8ZUQuvgPySyDlm6fhYAgi3WQo8mV8b43qPRw=;
        b=BEYOfefnjMDHiVi5TzzZTGMl9Iki7I6cBQXZVagqi9YXSb1Qzwn+EltnD7p2x+U8e4
         sLOhGvO8+VARuDE5CQe8ALMACrfKCNL+mw1MVFhtksoapcopLdADb2HFFqvRwhZGpGzs
         dtJ0pj5PyTNDy/NekXCQduUAKlPwRO/0NQC28MefzUx5Tg1pyJeC6zH5GfhiaCWdFPJX
         9Ecyc14ZRkd7A5F1mgUuu8w+CBuoKD44Va2bmLnx2UldcmwRBWBR6nztaXEXX3EbtHc2
         /4IGqFA/7exXKhq5NnGQaoVO+qGe9fuJa6DqF34L9eo8iSSrxaTnQCN11+Pp2/mKi+Zs
         Hrsw==
X-Forwarded-Encrypted: i=1; AJvYcCVJgaMMywEl7snERInPXHptSkVNxGV2Sowc+ya0M0s4adMB8jp3gSoIVzSpHHOpbb1Tcws=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhxZBOmAyXuw6+pKa0wQNsHfsxg1VIg1ZWQQR87rUx2vf8EfoN
	i9aI4pF+2d5XguQ4Twpa/KTRpqqJqRiAU5z4pLL+hclubydi/RQ7MrNYKBEHQUZvKa4qnwcoApd
	1QQtmtQ==
X-Google-Smtp-Source: AGHT+IEuqhHVpbBVF4PRy6ZWRfMuRBmBaTfUEEN01d1cgDPtR7abw4umz8fmd13HoIYheHHmygdWMEDHdzI=
X-Received: from plbkg4.prod.google.com ([2002:a17:903:604:b0:290:be3d:aff6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:40ca:b0:290:b928:cf3d
 with SMTP id d9443c01a7336-290cbd35d7dmr53537195ad.59.1760719759868; Fri, 17
 Oct 2025 09:49:19 -0700 (PDT)
Date: Fri, 17 Oct 2025 09:49:17 -0700
In-Reply-To: <CANiq72m0rNCaKandZgRa4dMhNOEN7ZanT5ht4kT8FLxYoWLVLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com> <CANiq72ntKAeXRT_fEGJteUfuQuNUSjobmJCbQOuJWAcNFb1+9w@mail.gmail.com>
 <aPFVcMdfFlxhgGZh@google.com> <CANiq72m6vWc9K+TLYoToGOWXXFB5tbAdf-crdx6U1UrBifEEBA@mail.gmail.com>
 <diqzqzv2762z.fsf@google.com> <CANiq72m0rNCaKandZgRa4dMhNOEN7ZanT5ht4kT8FLxYoWLVLQ@mail.gmail.com>
Message-ID: <aPJzjWzL4EbwDM66@google.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025, Miguel Ojeda wrote:
> On Fri, Oct 17, 2025 at 1:57=E2=80=AFAM Ackerley Tng <ackerleytng@google.=
com> wrote:
> >
> > Using the command on virt/ would pick it up. Would it be better to add
> > "virt/" to the "automation" + update .clang-format while we're at it?
>=20
> Yeah, that is what I was suggesting if you rely on it (and if the
> maintainers of the relevant folders are OK with it).

Hmm, my vote would be to go all-or-nothing for KVM (x86), i.e. include ever=
ything
in KVM, or explicitly filter out KVM.  I don't see how auto-formatting can =
be
useful if it's wildly inconsistent, e.g. if it works for some KVM for-each =
macros,
but clobbers others.

And I'm leaning towards filtering out KVM, because I'm not sure I want to e=
ncourage
use of auto-formatting.  I can definitely see how it's useful, but so much =
of the
auto-formatting is just _awful_.

E.g. I ran it on a few KVM files and it generated changes like this

-       intel_pmu_enable_fixed_counter_bits(pmu, INTEL_FIXED_0_KERNEL |
-                                                INTEL_FIXED_0_USER |
-                                                INTEL_FIXED_0_ENABLE_PMI);
+       intel_pmu_enable_fixed_counter_bits(
+               pmu, INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER |
+                            INTEL_FIXED_0_ENABLE_PMI);

and=20

-                       intel_pmu_enable_fixed_counter_bits(pmu, ICL_FIXED_=
0_ADAPTIVE);
+                       intel_pmu_enable_fixed_counter_bits(
+                               pmu, ICL_FIXED_0_ADAPTIVE);

There are definitely plenty of good changes as well, but overall I find the=
 results
to be very net negative.  That's obviously highly subjective, and maybe the=
re's
settings in clangd I can tweak to make things more to my liking, but my ini=
tial
reaction is that I don't want to actively encourage use of auto-formatting =
in KVM.

I think no matter what, any decision should be in a separate, dedicated pat=
ch/thread.
So for this series, I'll drop the .clang-format change when applying, assum=
ing
nothing else pops that requires a new version.


Return-Path: <kvm+bounces-47652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB3DAC2C88
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 653571C084D6
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3DD1F1538;
	Fri, 23 May 2025 23:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DgYjQqdb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC571EDA2F
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 23:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748044372; cv=none; b=B2Cq4PLUeT9ULhFJl5Hd4ocSh0oZtqHG/agpQWmYorCHqASFHguDihsw3udSGht/SgZ2T5d3AvoMTJ0RTlapQZi2OAFYqmL7i7jEk8GGdaV1+S1AftLlqpsUNlFwXwzbwtIA4ZSIxEOHk1Cw7Xq6VCQ21fPwlwBxn/mAbmGqcns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748044372; c=relaxed/simple;
	bh=M9hXUG12dQEzCbLn0FttmzohKmhmYluNMb8mwDu8KaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dvMCEn2PcLYCtmw6lNsbtu46NGVbJJDteYjZihS1BXjIO0CjudWAuU0PkhMOj+1//atp6JhS3KdRczyRTqerbI36hnxtZ5X/Nqtd1fMase0GzgMakNTXQ6v/+UqwW+j1TD1rMDfO9tY0ZV77OrzwLSuNpXsuja+OMcctbkrXKnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DgYjQqdb; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3280b1a25b1so2670501fa.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748044368; x=1748649168; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S0Fs7pz/z0EIB4gIzQ5oUac1XgvPmbJA7QXLi0jslE0=;
        b=DgYjQqdb59Hi2azpuFqbKyuLgbbc48aVe5/am3tWG3zkKXHvj7ht4qcZyozvZahoeV
         pdHeXHX3vUE9zU1EA4KbXwXq6TgHJP43HXuXOUMq/N8pJAWpMA12zTxzpoTovSdUYsZ/
         BCSLnqKN7YqtW7kg02ApyT68BEeT0wcGmAQZqqJ91UmBec1rzXRZHmPNzyTlQjY4sysw
         xdO7aA7sR4dtpEh5U5xJFK6hWCinuehG8Ff7mXflDJh5MSjwsD9nLIXo532VWlBC7njt
         5eisrpTVzqXH89NSLCoJGR1N9PHoChMFmeoMAqR1FKCP1IuwMBbmN8kTqBW9BZdz4HLB
         pzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748044368; x=1748649168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S0Fs7pz/z0EIB4gIzQ5oUac1XgvPmbJA7QXLi0jslE0=;
        b=mJP/BaQGqTUC3sN5uKszGR+xPJspsqxDVUm8BsKtTQRbq1tgNXK5UqQxUA4sspR4lW
         kvjFMzIVNyuUDSyu/T6I7/UMwa6OLd4cj+Y2G105L1IZskaO5rbTUqVak05kMntiqPtS
         TCUiFbg/r/h+z9ZSqdOPENzHBqjSUJr+jv67jXYc6ferkUrIrPM8gdz0S5jSIIKJptcV
         pweKAMHpUHDEXsurb7IKdZ1w70M5Tk8gxgTYU2TncZjuihe8qdXG7Wo2oQzKBmVy3N9c
         NPxTgwjP6ARusH4HUAUMOaCWEob8RA2HeP9hzUNoxc/brK16no8sQqNqoDxjzkXxc3JL
         gh0Q==
X-Forwarded-Encrypted: i=1; AJvYcCU46B1kNLhu1i1HxMUHzrsWhBchFa3kuxJf5Pn7BySDzS5iOJgnNfY3hMXz3sLAJ0+AVyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnImreM9Ml5aW8xJHkIdwEKEoLFGojSXDFoH2yLiqc+jbGXcKF
	HdnDpBt9leAlbQldH7v5tmTDmBh+UjUgSdbk76RoG9uYSHXn3RmJQvqxZflKTjh5cbTAUOv4ZJT
	UeUbDiGtCTi+huaQnv7AkUoOUTjGbH/jVNDHlY38Z
X-Gm-Gg: ASbGncuSUAwmZP4++rYiOfyul/Tze7d8MX/L1LXQUkXbsE7VW/Yv/8wMdPIzFKvERiv
	36oIwNYuKoUYqHkYJGK9vrRewzE3GfDdeh2QtiorC1B0S2wRB84tBvbT1WE0G/yAG+HryZes1YE
	I8IsYV0uSxCW+Y2/dQyzEnqYRCLStW8oUad2z8Ya731zw=
X-Google-Smtp-Source: AGHT+IH8NaXciis2Ap4OiAGLGhnQ9Gb49M8mILiHND/efN8rg1+lP6OwzfG1AqHxHePd1mY4UTi2wwWCDeKWqQoTLAs=
X-Received: by 2002:a05:651c:2109:b0:30c:1358:6400 with SMTP id
 38308e7fff4ca-3295b9aaa59mr2604071fa.5.1748044368078; Fri, 23 May 2025
 16:52:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <CALzav=dMSLy7kt6sJtRqAK8tOZwFz9Ktp3vzqggdD+J_aPVycg@mail.gmail.com>
In-Reply-To: <CALzav=dMSLy7kt6sJtRqAK8tOZwFz9Ktp3vzqggdD+J_aPVycg@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 23 May 2025 16:52:20 -0700
X-Gm-Features: AX0GCFuV-LnW4e9goCqhdbKeeGQfbApHZTPlR-dVtjKEnQHhsOcPMKn8qNDcilc
Message-ID: <CALzav=d22zi4zzebPJthKGF-uiD3qRTeTJM3Q-LB6UVBiwaAvg@mail.gmail.com>
Subject: Re: [PATCH 00/67] KVM: iommu: Overhaul device posted IRQs support
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 10:13=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Fri, Apr 4, 2025 at 12:39=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > This series is well tested except for one notable gap: I was not able t=
o
> > fully test the AMD IOMMU changes.  Long story short, getting upstream
> > kernels into our full test environments is practically infeasible.  And
> > exposing a device or VF on systems that are available to developers is =
a
> > bit of a mess.
> >
> > The device the selftest (see the last patch) uses is an internel test V=
F
> > that's hosted on a smart NIC using non-production (test-only) firmware.
> > Unfortunately, only some of our developer systems have the right NIC, a=
nd
> > for unknown reasons I couldn't get the test firmware to install cleanly=
 on
> > Rome systems.  I was able to get it functional on Milan (and Intel CPUs=
),
> > but APIC virtualization is disabled on Milan.  Thanks to KVM's force_av=
ic
> > I could test the KVM flows, but the IOMMU was having none of my attempt=
s
> > to force enable APIC virtualization against its will.
>
> (Sean already knows this but just sharing for the broader visibility.)
>
> I am working on a VFIO selftests framework and helper library that we
> can link into the KVM selftests to make this kind of testing much
> easier. It will support a driver framework so we can support testing
> against different devices in a common way. Developers/companies can
> carry their own out-of-tree drivers for non-standard/custom test
> devices, e.g. the "Mercury device" used in this series.
>
> I will send an RFC in the coming weeks. If/when my proposal is merged,
> then I think we'll have a clean way to get the vfio_irq_test merged
> upstream as well.

This RFC can be found here:
https://lore.kernel.org/kvm/20250523233018.1702151-1-dmatlack@google.com/


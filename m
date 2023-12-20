Return-Path: <kvm+bounces-4969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E6981A90D
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 23:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F82428DB57
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 22:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272654B15B;
	Wed, 20 Dec 2023 22:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nL3Ovklg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58D54B143
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 22:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-54744e66d27so3576a12.0
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 14:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703110963; x=1703715763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cd33Ad4E3sDi+/mK+pgctceQNxWnpSl3sfJKpANu8NM=;
        b=nL3OvklgjrFqezX5i4S6uXKUPs8B62I7DaY7FckHRNPlHKVpwr5zzvYBipZiJ7Td6/
         hK+DiNpLnbm25qDi8yCatG8Dhmcl3KvJldOAO94oOkXYWS7zECEhYr3Pk/DZo7bkSmOr
         a8Cuy3keZp/opISlpHqThi3QlbXpYjlwv8Y4XrtLdTJpByrdKxWIJJQU84VWZkv7AN10
         0Jj0K5P2nG9kDHtRdClbYpt0fouRw7KTE1FvgiCSAOzclVl2gCucWA5YXRS34qOMjJRB
         wH84HTLgw8FMAbbf3E9mpkPYCjLZmTN7BwzwZ04nRVVxJ6BuCu00cKjeJS8ukVMLIIyu
         0G7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703110963; x=1703715763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cd33Ad4E3sDi+/mK+pgctceQNxWnpSl3sfJKpANu8NM=;
        b=hlFCjkiI6HzZDdo0P9yU++f19oMatapHzBOB3Pg5F1QJo+Cp6BuknTHizeFWB/qni3
         /Ee/L3x9FHDWTifSzYA9lcfC4tejHhSz0SCYHIEFYCImEIE45r6xqw4Knnyd0vyYdTCa
         tngIq1tlAJXGMqbzKIAj/feJwYrpxbFjGWg7KssrH7JmejyCGhx2AHGthnyTgWSm7Uvq
         E314svaIX+THBZBniAROZUyBxhA1EC8TvBKY3vpXbmobg08e+eyfa3172mU2+sbmJOAQ
         e3ueDUbKHqCVTxYMUUhMfzouOWkXmYUHWceaCcOJKaTMTzJAQeUmUGM8/8ChG3d7OYt2
         2ufQ==
X-Gm-Message-State: AOJu0Yz44UkCwsWRFN/GT79mowzkgmV+XIxXJ8AYYiLH13NULm88eDGj
	ohnTJEt16wTieAtwy29/fRPWffcAPa2vzr9ZcAZGms9Uz1PF
X-Google-Smtp-Source: AGHT+IGxo+HpKWYou1rS3UzsDUFXZuOqMWKnWgs596ZFSvgI0efFZTNmx+tGBQpQZ2nFtwCYhDwQCbXUEr3S5uUq4q0=
X-Received: by 2002:a50:cd84:0:b0:553:5578:2fc9 with SMTP id
 p4-20020a50cd84000000b0055355782fc9mr4839edi.5.1703110962976; Wed, 20 Dec
 2023 14:22:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1699936040.git.isaku.yamahata@intel.com>
 <1c12f378af7de16d7895f8badb18c3b1715e9271.1699936040.git.isaku.yamahata@intel.com>
 <938efd3cfcb25d828deab0cc0ba797177cc69602.camel@redhat.com>
 <ZXo54VNuIqbMsYv-@google.com> <aa7aa5ea5b112a0ec70c6276beb281e19c052f0e.camel@redhat.com>
 <ZXswR04H9Tl7xlyj@google.com> <20231219014045.GA2639779@ls.amr.corp.intel.com>
 <CALMp9eRgWct3bb5en0=geT0HmMemipkzXkjL9kmEAV+1yJg-pw@mail.gmail.com>
 <20231219081104.GB2639779@ls.amr.corp.intel.com> <ZYNlhKCcOHgjTcFZ@google.com>
In-Reply-To: <ZYNlhKCcOHgjTcFZ@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 20 Dec 2023 14:22:28 -0800
Message-ID: <CALMp9eS7DgBkspdPmeB7m7SyWv42V1WEzWQHiyTB3nxtL7JqPQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Make the hardcoded APIC bus frequency vm variable
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	isaku.yamahata@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 20, 2023 at 2:07=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Dec 19, 2023, Isaku Yamahata wrote:
> > On Mon, Dec 18, 2023 at 07:53:45PM -0800, Jim Mattson <jmattson@google.=
com> wrote:
> > > > There are several options to address this.
> > > > 1. Make the KVM able to configure APIC bus frequency (This patch).
> > > >    Pros: It resembles the existing hardware.  The recent Intel CPUs
> > > >    adapts 25MHz.
> > > >    Cons: Require the VMM to emulate the APIC timer at 25MHz.
> > > > 2. Make the TDX architecture enumerate CPUID 0x15 to configurable
> > > >    frequency or not enumerate it.
> > > >    Pros: Any APIC bus frequency is allowed.
> > > >    Cons: Deviation from the real hardware.
>
> I don't buy this as a valid Con.  TDX is one gigantic deviation from real=
 hardware,
> and since TDX obviously can't guarantee the APIC timer is emulated at the=
 correct
> frequency, there can't possibly be any security benefits.  If this were t=
ruly a
> Con that anyone cared about, we would have gotten patches to "fix" KVM a =
long time
> ago.
>
> If the TDX module wasn't effectively hardware-defined software, i.e. was =
actually
> able to adapt at the speed of software, then fixing this in TDX would be =
a complete
> no-brainer.
>
> The KVM uAPI required to play nice is relatively minor, so I'm not totall=
y opposed
> to adding it.  But I totally agree with Jim that forcing KVM to change 13=
+ years
> of behavior just because someone at Intel decided that 25MHz was a good n=
umber is
> ridiculous.
>
> > > > 3. Make the TDX guest kernel use 1GHz when it's running on KVM.
> > > >    Cons: The kernel ignores CPUID leaf 0x15.
> > >
> > > 4. Change CPUID.15H under TDX to report the crystal clock frequency a=
s 1 GHz.
> > > Pro: This has been the virtual APIC frequency for KVM guests for 13 y=
ears.
> > > Pro: This requires changing only one hard-coded constant in TDX.
> > >
> > > I see no compelling reason to complicate KVM with support for
> > > configurable APIC frequencies, and I see no advantages to doing so.
> >
> > Because TDX isn't specific to KVM, it should work with other VMM techno=
logies.
> > If we'd like to go for this route, the frequency would be configurable.=
  What
> > frequency should be acceptable securely is obscure.  25MHz has long his=
tory with
> > the real hardware.

I am curious how many other hypervisors either offer a configurable
APIC frequency or happened to also land on 25 MHz.


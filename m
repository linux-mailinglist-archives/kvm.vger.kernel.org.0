Return-Path: <kvm+bounces-19771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 463EF90ACD4
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 13:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C63AA1F24C71
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 11:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6362B194AE9;
	Mon, 17 Jun 2024 11:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jfrW+++Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDBF194A6A
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 11:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718623395; cv=none; b=kknnWgI9XVLPNXu/ZJnD2MqD3JEo0ApNtL/HnjrOf3zfy5Z0LOkl5kMWX2MCSV7X1mcykwLGhC4lO7UlEwq+L95lVFm4sxEz24BTb/9cEv/tybR5xEbCGGu+s+CpkQT3va5Q8ds6JjhTcfTjBgOu68xSAmNHJMBAw9p4l/i4Ocs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718623395; c=relaxed/simple;
	bh=StZPGP5/i6bU5Xn6N3H5JCPZRkydWn4sCNBBZMzJ8cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INQlw9DkFxCLLcUL5QYQ5g1yQBLpOzvL8fCkKQu4aivcYgDyctCnmocqvmzTUl0g+UNuCSr4dRaJVBWLMir+Qyn1tqM6V9hH4q4Ii1DJGZ4iqdsD9uItGXaL3zlQrogNjMblFAkLSX6zfvolZx8t4XvrSSps+dMknxUe+PIaTS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jfrW+++Z; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-35f123bf735so2972986f8f.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 04:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718623391; x=1719228191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sM9D3IqfgB50OxP9LSaIkbOJs5yF44MMVnRSPz65e9Q=;
        b=jfrW+++Z8TzHScqOeauKH9oEvVxFKPu3HWLEdjbR+fJbloI7KeI1Vkkpgvdjh7YqOq
         dZYyczIeIUcPwd0SnAr4ZR5ReQS8y1jylvgos7aaW7z8s21FZExpAZIVDNq1XDrO8bOG
         njV2IEPApBmm8HOW1Q8xKwSeMPLXKGVMN3qJop4OQ/WEJjv1UofGhJWY37BLjb5holOj
         KC1NMxiUXYLRInGmu5Y5x1NdYYkhhDLMu67OkmFg3Niy6axcZJsbvOPAwOdhAnjhGK96
         m91gl6GFWFp4tpjZ3j29cnK8pH1RD8oUuuOkuQcbep6QjNPcr1b/ksFhhw1tLLdGkMd0
         H4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718623391; x=1719228191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sM9D3IqfgB50OxP9LSaIkbOJs5yF44MMVnRSPz65e9Q=;
        b=gyzmXNwURMAH+ozzYaohUWpqtHre270ainy1NIrSxJcIyU3vU2UBhR3ELEpgV8JUYe
         urmN/JRwxmpifsyZaeZ5IkSBCU4ifIeHGGTRpeZaFN306o/7TbB6qpMjMZ4LNsCulZHV
         FQ3tqIgUN7X0W2fAvS9l1OGEMps7MiJuplnOfi4EVsNVVXYGfzPJP/0DklqtkrXDq/Sa
         /NPqgowhcnotumPQWyPaHasZIXvTNS52Vv03K12unPjsWgsgzbLyiYe1+rk0sBZT76Kw
         VaIuEgnRTsh7TPAh/yNrNV3cyWj4AGp+lc7Gky7w+5PmFKutfjJm9sn5BIFFo9Xd6RLI
         eoCg==
X-Forwarded-Encrypted: i=1; AJvYcCVKgvzIiPGHfjP1ShtzPqSrn84WupW2/91TLjjJ1IraH9fiYZbMsEIpgHzcpkIVf1wiFBl7XnQI4u5xVSwKVJLhEXx/
X-Gm-Message-State: AOJu0Yzz5TF/NbSR3DCnGNc/ned9cuX1LIC7T9FsXuM6gq9FGj/qs6Vt
	80ZmqpORQLh9TXB/oxJmpGXN1halRo2UtkupRRmMUolKJXrx/+utnDzmGHQFFrg=
X-Google-Smtp-Source: AGHT+IETE+Maao3JAp1ZfgvsbcmTneajMGOq/KKGP7BvZAyqnGu9qO6mLUlHKQfEume52Ehz/Rt4gQ==
X-Received: by 2002:adf:f902:0:b0:360:727b:8b47 with SMTP id ffacd0b85a97d-3607a7e7c15mr8074845f8f.63.1718623390738;
        Mon, 17 Jun 2024 04:23:10 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-360750acf32sm11673653f8f.49.2024.06.17.04.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 04:23:10 -0700 (PDT)
Date: Mon, 17 Jun 2024 12:23:26 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	fvogt@suse.de
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
Message-ID: <20240617112326.GA1193@myrica>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-3-steven.price@arm.com>
 <20240612104023.GB4602@myrica>
 <3301ddd8-f088-48e3-bfac-460891698eac@arm.com>
 <20240613105107.GC417776@myrica>
 <CAFEAcA99bPtEr2OpE45wCgfSArZdtz4tu9rggLNb+=Rujh0ZvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA99bPtEr2OpE45wCgfSArZdtz4tu9rggLNb+=Rujh0ZvQ@mail.gmail.com>

On Mon, Jun 17, 2024 at 11:27:31AM +0100, Peter Maydell wrote:
> On Thu, 13 Jun 2024 at 11:50, Jean-Philippe Brucker
> <jean-philippe@linaro.org> wrote:
> >
> > On Wed, Jun 12, 2024 at 11:59:22AM +0100, Suzuki K Poulose wrote:
> > > On 12/06/2024 11:40, Jean-Philippe Brucker wrote:
> > > > On Wed, Jun 05, 2024 at 10:29:54AM +0100, Steven Price wrote:
> > > > > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > >
> > > > > Detect that the VM is a realm guest by the presence of the RSI
> > > > > interface.
> > > > >
> > > > > If in a realm then all memory needs to be marked as RIPAS RAM initially,
> > > > > the loader may or may not have done this for us. To be sure iterate over
> > > > > all RAM and mark it as such. Any failure is fatal as that implies the
> > > > > RAM regions passed to Linux are incorrect - which would mean failing
> > > > > later when attempting to access non-existent RAM.
> > > > >
> > > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > > Co-developed-by: Steven Price <steven.price@arm.com>
> > > > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > >
> > > > > +static bool rsi_version_matches(void)
> > > > > +{
> > > > > + unsigned long ver_lower, ver_higher;
> > > > > + unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
> > > > > +                                         &ver_lower,
> > > > > +                                         &ver_higher);
> > > >
> > > > There is a regression on QEMU TCG (in emulation mode, not running under KVM):
> > > >
> > > >    qemu-system-aarch64 -M virt -cpu max -kernel Image -nographic
> > > >
> > > > This doesn't implement EL3 or EL2, so SMC is UNDEFINED (DDI0487J.a R_HMXQS),
> > > > and we end up with an undef instruction exception. So this patch would
> > > > also break hardware that only implements EL1 (I don't know if it exists).
> > >
> > > Thanks for the report,  Could we not check ID_AA64PFR0_EL1.EL3 >= 0 ? I
> > > think we do this for kvm-unit-tests, we need the same here.
> >
> > Good point, it also fixes this case and is simpler. It assumes RMM doesn't
> > hide this field, but I can't think of a reason it would.
> >
> > This command won't work anymore:
> >
> >   qemu-system-aarch64 -M virt,secure=on -cpu max -kernel Image -nographic
> >
> > implements EL3 and SMC still treated as undef. QEMU has a special case for
> > starting at EL2 in this case, but I couldn't find what this is for.
> 
> That's a bit of an odd config, because it says "emulate EL3 but
> never use it". QEMU's boot loader starts the kernel at EL2 because
> the kernel boot protocol requires that (this is more relevant on
> boards other than virt where EL3 is not command-line disableable).
> I have a feeling we've occasionally found that somebody's had some
> corner case reason to use it, though. (eg
> https://gitlab.com/qemu-project/qemu/-/issues/1899
> is from somebody who says they use this when booting Windows 11 because
> it asserts at boot time that EL3 is present and won't boot otherwise.)

Thanks for the pointer. In this case it looks like Linux was used as
reproducer and not the main use-case, though I wonder if some CIs
regularly boot this particular configuration.

> 
> Your underlying problem here seems to be that you don't have
> a way for the firmware to say "hey, SMC works, you can use it" ?

We do: SMCCC recommends to look at the PSCI conduit declared in DT/ACPI.
Given that RMM mandates using the SMC conduit for both PSCI and RSI calls,
we could use this discovery mechanism here. The problem is that we have to
discover it very early at boot, before the DT infrastructure is ready,
so the implementation is a little awkward. I did post one earlier in this
thread but it doesn't yet account for ACPI-only boot, which will need
something similar. Testing ID_AA64PFR0_EL1.EL3 would be much simpler, but
it would break this config.

Thanks,
Jean



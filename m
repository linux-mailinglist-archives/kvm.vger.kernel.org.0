Return-Path: <kvm+bounces-19571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6553C906A74
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 12:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFF51281498
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 10:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A5A1428EF;
	Thu, 13 Jun 2024 10:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CjIn4ui/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC6214290C
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 10:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718275856; cv=none; b=QhTkmSrS+QdXB1aYfR4YouZl6z/JM/Blp58xssEc+WnVfDX3itBunNzCTsCTOUm/+y8dTtu9vTrZpzBhun8AgJVqYiUxsBXCv9Y8etS8UjEgu/6X80LPioi9JGzQw6l47j9ldzzd6l1PCSZ+qWblPtJZ0jfyXV+nZahIkRLXdkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718275856; c=relaxed/simple;
	bh=UgyBUaw5Cfb+8mR7p+p9qMbx6BdW9rHq+TZllqNkmHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAk2j/Vd+muKSy3c4xIMYsG0s3+i3jsQNUuf14wLHWOrXLhzrLb9Wx6W7yGm9jNOtfTe9tbOgYC7++4oQKmDHzMVaG10QeRY8vRW/61C7fBIG0XqwPGPFA2azq6iTvg3tDJcsDDPjPxBvYHNe6GTmWN9PZdr6UH3vzIuB4GNdwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CjIn4ui/; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ebdfe26217so7092051fa.2
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 03:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718275852; x=1718880652; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8BVG4kRdfLOofP57LybYLwKmto1z7Z4ok3Ssg9M2l0=;
        b=CjIn4ui/YvRaowrgfceqe7Bo0UxdNRXTeNdM+32ASt5jH/ft/7svKxiT9e5gSndnW+
         lTfj6PFeTBao7nFCAWL8tSQhOjDk2mWNZ44dRKgpBX/2XOGyBLn4cEzdQicSR7F91/nF
         AU3IJwDkXkPBLdShGb9h7gK4SCzTTbSh/+FHvQCT/QY89NyPYRVRQxcuDlDIhmZrfp7G
         K/T+/Duz/MTvuaxgavpO7dXWpjzpvXvf2+aLfOYA034IJn1Ny6bRh+wyWq86CcjsbrMr
         qAyOuIEWkFujRgAN+xazaaOQBF5tBxWpFVm2xj0q0cDQ+2Ep5eeGXd2aeJhvSgTQnXhf
         Yw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718275852; x=1718880652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8BVG4kRdfLOofP57LybYLwKmto1z7Z4ok3Ssg9M2l0=;
        b=lEMGeUMS+KL2Ff7MWuzH53alk2LTP3AB0wmeL7DAuFves4ZgfAgPGWY/Uf/qhveH1V
         kbx+JNZmJjXySwQHcyrdfgs3V0JtlcPKNluduA+7/15SEVFBuVn0XGTKotFm8M0vAEqi
         mInVb0Rky/0z31UKJDzFg0eQpdXCFP4b2Wu7HsYrxxU5aejumAPAe/FoNGDOMMHWtq8q
         3xh57/bonkAHnoi5s5Z8FlhI+YugGZGIzT9/Kl0i/QeTuNA7W3tna1FYAUntBP7d0xxI
         bCX6xsGK87yndOpc84+8KMrbG+g69YMaTlOtORSJtOzpUU0I4sFACJe4oGkPM4eLoy2L
         myag==
X-Forwarded-Encrypted: i=1; AJvYcCUIDTDjBrlx6PrULiFEo5cxvGCyZHy3KsXtLWYtDRU+PUBwXpC7qubplefH5DhJZGT0gn6ssNeGzPpvcsmz7KWMM5se
X-Gm-Message-State: AOJu0YwrHJStRy9t4zEQu6X80xmmiuNgriHN9Q3AYFmUaqk+GRWnqg49
	9I7Fq4UyQMAiAT7jyOv7Cx2dosEC5XZ0qDq99A+MaP9fgLfBcj6vTStrfZkPmWM=
X-Google-Smtp-Source: AGHT+IFHavbOr+OgWlX2a5b/dvGpv+Y/52aYQqWXG4No5o2I0ST7yMd4AjYSJZeNAegwsKQiKBFEvA==
X-Received: by 2002:a2e:681a:0:b0:2eb:db25:a68f with SMTP id 38308e7fff4ca-2ebfc9abdf4mr25206351fa.52.1718275852267;
        Thu, 13 Jun 2024 03:50:52 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb72ea3b2sm763316a12.55.2024.06.13.03.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 03:50:51 -0700 (PDT)
Date: Thu, 13 Jun 2024 11:51:07 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
	peter.maydell@linaro.org
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
Message-ID: <20240613105107.GC417776@myrica>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-3-steven.price@arm.com>
 <20240612104023.GB4602@myrica>
 <3301ddd8-f088-48e3-bfac-460891698eac@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3301ddd8-f088-48e3-bfac-460891698eac@arm.com>

On Wed, Jun 12, 2024 at 11:59:22AM +0100, Suzuki K Poulose wrote:
> On 12/06/2024 11:40, Jean-Philippe Brucker wrote:
> > On Wed, Jun 05, 2024 at 10:29:54AM +0100, Steven Price wrote:
> > > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > 
> > > Detect that the VM is a realm guest by the presence of the RSI
> > > interface.
> > > 
> > > If in a realm then all memory needs to be marked as RIPAS RAM initially,
> > > the loader may or may not have done this for us. To be sure iterate over
> > > all RAM and mark it as such. Any failure is fatal as that implies the
> > > RAM regions passed to Linux are incorrect - which would mean failing
> > > later when attempting to access non-existent RAM.
> > > 
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Co-developed-by: Steven Price <steven.price@arm.com>
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > 
> > > +static bool rsi_version_matches(void)
> > > +{
> > > +	unsigned long ver_lower, ver_higher;
> > > +	unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
> > > +						&ver_lower,
> > > +						&ver_higher);
> > 
> > There is a regression on QEMU TCG (in emulation mode, not running under KVM):
> > 
> >    qemu-system-aarch64 -M virt -cpu max -kernel Image -nographic
> > 
> > This doesn't implement EL3 or EL2, so SMC is UNDEFINED (DDI0487J.a R_HMXQS),
> > and we end up with an undef instruction exception. So this patch would
> > also break hardware that only implements EL1 (I don't know if it exists).
> 
> Thanks for the report,  Could we not check ID_AA64PFR0_EL1.EL3 >= 0 ? I
> think we do this for kvm-unit-tests, we need the same here.

Good point, it also fixes this case and is simpler. It assumes RMM doesn't
hide this field, but I can't think of a reason it would.

This command won't work anymore:

  qemu-system-aarch64 -M virt,secure=on -cpu max -kernel Image -nographic

implements EL3 and SMC still treated as undef. QEMU has a special case for
starting at EL2 in this case, but I couldn't find what this is for.

Treating SMC as undef is correct because SCR_EL3.SMD resets to an
architectutally UNKNOWN value. But the architecture requires that the CPU
resets to the highest implemented exception level (DDI0487J.a R_JYLQV). So
in my opinion we can use the ID_AA64PFR0_EL1.EL3 field here, and breaking
this particular configuration is not a problem: users shouldn't expect
Linux to boot when EL3 is implemented and doesn't run a firmware.

Thanks,
Jean

> 
> 
> Suzuki
> 
> > 
> > The easiest fix is to detect the SMC conduit through the PSCI node in DT.
> > SMCCC helpers already do this, but we can't use them this early in the
> > boot. I tested adding an early probe to the PSCI driver to check this, see
> > attached patches.
> > 
> > Note that we do need to test the conduit after finding a PSCI node,
> > because even though it doesn't implement EL2 in this configuration, QEMU
> > still accepts PSCI HVCs in order to support SMP.
> > 
> > Thanks,
> > Jean
> > 
> 


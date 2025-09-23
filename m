Return-Path: <kvm+bounces-58558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E16B969D5
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 971AF189F522
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9D6238D54;
	Tue, 23 Sep 2025 15:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="QYL8no54"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABE11C4A17
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 15:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641854; cv=none; b=S6xlREkg0oqQ8ZZsEcR86h6JlRxlLxR9hiQW6P+G1932mN25rgQEyyC6HZwXHKtu9BF4jqGRST3pU7TL2b69EFMJvKbD3rrtmAIMNSIDkOiVjvtE/vj9jfuMvyVeYkfQNhEskf/XHNn2HbCR4NwABbR+1sMFYaRzzb3r5PDgRHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641854; c=relaxed/simple;
	bh=VPsPP97J7NiYsQImvFBzCd/NUWkzwiH5aWFfTBKY7ns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7wt8z/qZqJ2XOiGLho3DMr2D1DfrmyV4hDInTmaJSoZxfSHqL0EdcIt7mngae+9ikpatqtUedhXFLEYTLRqTs5xHOZAUYH77OBr+VzjrG4gm9Ta6wR21Jd+irpGz33rZYCk45X0A0nb+qnWl4DNDBozJN343g910fj9I7DAShU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=QYL8no54; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-eb3671a7db4so12956276.0
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 08:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758641852; x=1759246652; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wa5b2Ox9cKpFtfieebnhk7CueJ3gddY86USQDYphg/s=;
        b=QYL8no544a9aasSptURayciMEqmX1gfPc6FXP5EPQr5zlyBcAwocQfTAxJpyWgVJnz
         VZiZZ9zj9uoq71tUJd0wYfFnKwIgYzGJ9yfzv58+6R3pHjk+XRAN32I/hF7bmOEfX3JK
         MdZyLoaPD6SUzuudvP8QJuJv9iPdkre4o6olZR4c8xa3dKPQHd3jdOYC4vjAq/nRujs2
         9ol21MWNB+WpIFX9po+zB80WlJs7OhtQFJxGt6R8a5kFNpFm1Cc0osEcF71KcBxUOeBt
         GCavLFtsY4s/leUcjp+GSke2dyRR491WddKoq3tUiw0fKc1ylD3OR4+V71MAZOgLYtu1
         E8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758641852; x=1759246652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wa5b2Ox9cKpFtfieebnhk7CueJ3gddY86USQDYphg/s=;
        b=cXa3pWjVKx5IQaUY7rFi0Ip1f4slC8WoyTQM50qxvQr8JNIuSmefuhu8y7dV2I6j+L
         dNmnptWtbuCwyle5smlu3hmJ5hvodPoyU3OznFK614cf/0EbstwcFgTT1irBca2XY037
         CkMz0QE7Vdm99uQXCV0R315nEwARjQfCLrsMsEkyZqqZ6MivrvKzlgu4lULoEEwAA7rm
         gSSGkVmI7hGCX5Jq42pk9pCWrHp1B/v3pGPdwF3Ra3v/Wh8MjZaBAZwg05IVEhDDc9GH
         yikbatu3k1ciKnRCmlzlQLfW14AnfJj1trSk0un6//jVRDpSTVMZZ5Ci0pHxRbbEMMPx
         L6oA==
X-Forwarded-Encrypted: i=1; AJvYcCVpD5Y1nxJzyxVGyZf3PoyoRKGLvSJM5/80YiNQE8FioEQuwX5G8V9ReMGDkSacdtjOe8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIKvU1LYthpwT/qIc7kpDDLcEvYXlx5kQ2zlvW7aWuZ6pD+0lf
	nl8rcFdUmg+HbWQmuh3gGqrWQm+FAEbh2s5YBXqasLtSxeRfGDyoDmBqrmFM0xDUwtk=
X-Gm-Gg: ASbGncsCbNUInM+B/EvzeKV0gHl77zaIHd8jVXAMkqohhOTwVN2hkjJVuPGlNvd1P02
	8IjovdtqtKdoX8ZIwfn+x3MY0W28MTvFjVKsxo42VYQChtqx3HHJX8axk35tuumxkLxwFTtCQX5
	fG0V1A0hKp4oWx9iwMhjwIp8EkUUsi8KuDgKqfI6Mbvg22HDxrvbwYW4o4vUUFIuhy/xeHdyNkh
	gSX+1Cqkx6MyoCSgZLr77nuO+MS/Ra6T+aEd6VqaXr4/+CpKLqlS6nlI5vRLrFPfRPn/uxhrYRz
	N5O+4uQJ+PhYNjUNCmjXaMvvXFLRUnqJMnX46s/KruzxU9cOXGioRk2EKn+ft9iW3MZ0jRxM906
	jcOEpVU8OsJ4b1ACzriWWPDa+
X-Google-Smtp-Source: AGHT+IEg1iVUs6leKP9cHj2cx58SzsL13TI+csDZL0P1k6w1OJijHfrbcJXnEnD/4J+xBKVTIxDONg==
X-Received: by 2002:a05:6902:1381:b0:eb3:6e74:dd0c with SMTP id 3f1490d57ef6-eb36e74defcmr792195276.24.1758641851831;
        Tue, 23 Sep 2025 08:37:31 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea5ce854f57sm5087789276.22.2025.09.23.08.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 08:37:31 -0700 (PDT)
Date: Tue, 23 Sep 2025 10:37:30 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, iommu@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, zong.li@sifive.com, tjeznach@rivosinc.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com, anup@brainfault.org, atish.patra@linux.dev, 
	alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
Message-ID: <20250923-54e8e0f39d672845e2979286@orel>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
 <20250922-50372a07397db3155fec49c9@orel>
 <20250922235651.GG1391379@nvidia.com>
 <87ecrx4guz.ffs@tglx>
 <20250923-de370be816db3ec12b3ae5d4@orel>
 <20250923145251.GP1391379@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923145251.GP1391379@nvidia.com>

On Tue, Sep 23, 2025 at 11:52:51AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 23, 2025 at 09:37:31AM -0500, Andrew Jones wrote:
> > undergoes a specified translation into an index of the MSI table. For the
> > non-virt use case we skip the "composes a new address/data pair, which
> > points at the remap table entry" step since we just forward the original
> > with an identity mapping. For the virt case we do write a new addr,data
> > pair (Patch15) since we need to map guest addresses to host addresses (but
> > data is still just forwarded since the RISC-V IOMMU doesn't support data
> > remapping). 
> 
> You should banish thinking of non-virt/virt from your lexicon. Linux
> doesn't work that way, and trying to force it too is a loosing battle.

Well, we need to consider virt when the hardware has virt-specific
features that we want to control. We also need to consider virt when
additional address translations to go from guest space to host space
are needed, as in this case.

> 
> If you have a remap domain then it should always be remapping. There
> is no such idea in Linux as a conditional IRQ domain dependent on
> external factors (like how the IOMMU is configured, if the device is
> "virt" or not, etc).

The remap domain is created when the platform supports MSIs and always
does remapping when the IOMMU supports the MSI table. It could even do
remapping when the IOMMU doesn't support the MSI table since it could
use the DMA table instead, but that's left for a later patch series if
hardware actually shows up like that.

The difference between virt and non-virt is what addresses get remapped
for the remapping. For virt, guest addresses get remapped, for non-virt,
we don't remap guest addresses. And, since we don't remap guest addresses
for non-virt, then, rather than invent some new, arbitrary address, we
just use the host address. Remapping is still in use, but, as I said
above, it's an identity mapping.

(Note, for the current riscv iommu, "remapping" for the non-virt case just
means keeping the set of IMSICs that a device may reach limited to just
what it should be allowed to reach.)

> 
> Be specific what you mean.

I'm always happy to clarify when asked. I'm not sure what I said that
would lead to thinking remapping was disabled for the non-virt case,
but hopefully what I wrote now clarifies that it is not.

Thanks,
drew


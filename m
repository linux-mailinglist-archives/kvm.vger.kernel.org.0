Return-Path: <kvm+bounces-28627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C73F899A4E0
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 15:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02D101C222A9
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4BF9219C99;
	Fri, 11 Oct 2024 13:19:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB872185B1;
	Fri, 11 Oct 2024 13:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728652781; cv=none; b=tAbaT79jPmdxuIlJcZfhqRh3uWSyhWXyZbZllhQc1Kf+D64nonGa8NUirH/SEQMItcAMasasWjYeQgXxRpOOnzCb1Vn4xNZqmB27oaRZ4L1TTBpp7ht/yI0jctIfaHgzsTNVW0ObAf65+7fnA8NXuKTfC99KsbniTiui/bpkGJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728652781; c=relaxed/simple;
	bh=KPk/oGQCSzHeJeEm1U6bQDYtA3wrtPagucVe1rAmc3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nS2eXTBl8l1OlAvFhVqeo24qnWzAAt7hF4XXPU0WCzBydAnlaKi3uYIe6iCy/mnTeXhP+Oy9AV7hKnHOI4U7NParDcLN/v5Mnubz/H+d1IELcvyq2WYQ+eAGewCXA25Gm20gEElkkacCPxlyJDGH0RvZHgp3PjEgnXYZfUklMLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A97C4CEC7;
	Fri, 11 Oct 2024 13:19:37 +0000 (UTC)
Date: Fri, 11 Oct 2024 14:19:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Gavin Shan <gshan@redhat.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <suzuki.poulose@arm.com>,
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
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v6 05/11] arm64: rsi: Map unprotected MMIO as decrypted
Message-ID: <Zwkl51C3DFEQQ0Jb@arm.com>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-6-steven.price@arm.com>
 <e21481a9-3e36-4a5d-9428-0f5ef8083676@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e21481a9-3e36-4a5d-9428-0f5ef8083676@redhat.com>

On Tue, Oct 08, 2024 at 10:31:06AM +1000, Gavin Shan wrote:
> On 10/5/24 12:43 AM, Steven Price wrote:
> > diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> > index d7bba4cee627..f1add76f89ce 100644
> > --- a/arch/arm64/kernel/rsi.c
> > +++ b/arch/arm64/kernel/rsi.c
> > @@ -6,6 +6,8 @@
> >   #include <linux/jump_label.h>
> >   #include <linux/memblock.h>
> >   #include <linux/psci.h>
> > +
> > +#include <asm/io.h>
> >   #include <asm/rsi.h>
> >   struct realm_config config;
> > @@ -92,6 +94,16 @@ bool arm64_is_protected_mmio(phys_addr_t base, size_t size)
> >   }
> >   EXPORT_SYMBOL(arm64_is_protected_mmio);
> > +static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
> > +{
> > +	if (arm64_is_protected_mmio(phys, size))
> > +		*prot = pgprot_encrypted(*prot);
> > +	else
> > +		*prot = pgprot_decrypted(*prot);
> > +
> > +	return 0;
> > +}
> > +
> 
> We probably need arm64_is_mmio_private() here, meaning arm64_is_protected_mmio() isn't
> sufficient to avoid invoking SMCCC call SMC_RSI_IPA_STATE_GET in a regular guest where
> realm capability isn't present.

I think we get away with this since the hook won't be registered in a
normal guest (done from arm64_rsi_init()). So the additional check in
arm64_is_mmio_private() is unnecessary.

-- 
Catalin


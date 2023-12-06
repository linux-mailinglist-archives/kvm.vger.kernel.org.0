Return-Path: <kvm+bounces-3770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 942F08079AC
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 21:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4ED7E28247C
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887B93FB30;
	Wed,  6 Dec 2023 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="kIlh4/LD";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="uKMrxTVR"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1937135;
	Wed,  6 Dec 2023 12:44:04 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1701895443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tt/d27mY59C3uUO6MUg2plSSXPKh9R05K6pzapnG0gA=;
	b=kIlh4/LDNh8d4Kj8mF2tshqjkGW8VUg6IY6TQZALVmfSU1bOYfxNCFkPNET+IL3SuoCHK7
	38cFzSwsoTIpPnaj2XHCvqHMpqZd25mTW7oDvJARAvwjU86YavzyZEAtxpG+ucN4kfMQW3
	87wk/GrPJnAjopOogtnHZjj/Gzh56ux4sIl8cb+7WqkkYopClnkB1saOBCXzKsDPsgNsgn
	qFF6W0h0V6+08QAtk6cKFTSlx4R+7pRVRKlsvhaXlMjzn1fRPRxryRgo++x34fpjC9QgkT
	fIJoKbzOioRZWjvDowdLAqmGbIz/qBjMbCAPpStUdL0vb2aWD8HYUUp5uuuMKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1701895443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tt/d27mY59C3uUO6MUg2plSSXPKh9R05K6pzapnG0gA=;
	b=uKMrxTVRbmTQOuVwzsvgOlKvSPYJrwjcJ2j6NmtCUTFAY0aZNpzQ6QzlKQz/zs3C1NujSf
	62DSSdDBuApYu8Bg==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH RFC 11/13] iommu/vt-d: Add an irq_chip for posted MSIs
In-Reply-To: <20231112041643.2868316-12-jacob.jun.pan@linux.intel.com>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-12-jacob.jun.pan@linux.intel.com>
Date: Wed, 06 Dec 2023 21:44:02 +0100
Message-ID: <87wmtrt625.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
>  static void fill_msi_msg(struct msi_msg *msg, u32 index, u32 subhandle)
>  {
>  	memset(msg, 0, sizeof(*msg));
> @@ -1361,7 +1397,7 @@ static int intel_irq_remapping_alloc(struct irq_domain *domain,
>  
>  		irq_data->hwirq = (index << 16) + i;
>  		irq_data->chip_data = ird;
> -		irq_data->chip = &intel_ir_chip;
> +		irq_data->chip = posted_msi_supported() ? &intel_ir_chip_post_msi : &intel_ir_chip;

This is just wrong because you change the chip to posted for _ALL_
domains unconditionally.

The only domains which want this chip are the PCI/MSI domains. And those
are distinct from the domains which serve IO/APIC, HPET, no?

So you can set that chip only for PCI/MSI and just let IO/APIC, HPET
domains keep the original chip, which spares any modification of the
IO/APIC domain.




Return-Path: <kvm+bounces-72519-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNQJBBnSpmnHWgAAu9opvQ
	(envelope-from <kvm+bounces-72519-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 13:20:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2F41EF48B
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 13:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8633C30492ED
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 12:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB4622E3F0;
	Tue,  3 Mar 2026 12:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Xi9hTjQX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62916267386
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 12:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772540112; cv=none; b=fIQ6T9RJlAsQ/AK69ZA+b2A+BAVflqDo7UVLEXizHbS6zrj3IYvrvOB1Do51VqvQj+y6pdTDsrgD5TgZN7hIOCji96yJzRR8PCrg2Zhmny4Y+Fc/L1XTjjndLkLILwTHmmJ9RaVy43ZD+CBL8gXQtfzSlmzSL7AHRsHlBt/+Zxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772540112; c=relaxed/simple;
	bh=7Rc9j3LNiGnIyTeHz2J0Avp/KOXJP6cs2JgWLFyvSoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UD22UZ+KuRkka832Vts3ewnmywTKvceph5XwHbZBWM+8/tIyvYCS247GpxkfYMO9wyKHROZlnLhhW3BArj+Kymt1J8GDAHHINw2ZSoWoZFcP5XAhXaU4qYrQAZFjBA9KlbEOlFtavexKAuOTlkzzA4goOLrr0j97f768Aj1mORU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Xi9hTjQX; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506cb1b63d0so67770621cf.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 04:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772540110; x=1773144910; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3MM4W4u3ny+cRpfXrxu8DnH970Z9q8VF2tWXlyBc85c=;
        b=Xi9hTjQXci5LpOXbCPKiygALDSRfu87R3o1ecGvrUT9JcQZayA37DX8wKo7FWuU/Ss
         DGy/hw1qNq+fCpNUaWmrUqz6xUbzVj3kKS33Yoy5tW6cDlvvsMN4Vbjm3/K8DWxUcW/O
         SvJIvzXO+4ah8oP9zc7edsqWininE/2EhJJ35uACW5teVJaBJfcKI4fDDRvF18JHcjOO
         eQ64C7iz2eTpKM+doTs8lq+zrc/4Dhh2x97Lueyk3dWxjNFntCknXcKk5LYo8P+F5KZh
         2uVqbTJ8LwpE3ZV6+0fq56VTkfHOAg+Z51M2fjrh+dHM5MMNJjDW3edk0q0thnAzAHGA
         u1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772540110; x=1773144910;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MM4W4u3ny+cRpfXrxu8DnH970Z9q8VF2tWXlyBc85c=;
        b=pWq+jMoHcmXJXHBDTTzDYYvxPUXt0gD/peh/VclLlHgxBsh7za1IUUcY+Lv8lJUFM8
         Fdc4qHA50PGeLKjjE35PIrqv34ES0iyyczc/aw/pcEAQzqfDl877GJH8bSE7zjA5bCDe
         PV7fGd1loCy1+J2Bs4OwpnZVZS4GaJa7OE9kaYEjS2661a5IXVKRG2sDu5sSQDM/V/zJ
         x4mDaq2OiZ5xRwE2QPBOttrB3V9f9ygITIsXqr/39Voz1vlvsh4U/YKMv4trvwUMGVo7
         dyQiIWbT/eAiraouSyHw8v0bGm2K3XY1eYOrJTdbcrH6q012zuN8rHKaNuWAv8NUfzGv
         7xKA==
X-Forwarded-Encrypted: i=1; AJvYcCX3rCP2FViScBnRhFRm0zpYL3vM4CV29CrPHtxVJuItAdw6F2MmcMD/5fJo7Glatdgqn/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXVPSzbLNfMNDHBEwQC9ObddQ2l9/dqI4qX9OHt0XlM8Q3myv7
	lvPC6SuwDntBfzw3WNUaOV+hCUublyet3TqPnaMLk8hf/v7/rcs9E/F1RONey4SCL02o9M65d7d
	UkMG4
X-Gm-Gg: ATEYQzxe1LOBBltIJSkwcWH3lq+6tYWHcA96hQEof5SMboojEoTskNt0sasj3NUpQyZ
	4f9O6l1h4K2AeoLfY6USS6V09Sap6YRAcZuqETkelLVOS9Kqeei1ds4RRrTbYz+KxpTqfsjTz2q
	wtt7AYfwaQQovlqKb6BtWm/KM9M6RG3CfsmGyHp9uCMftRFdrPX8yRKacjJ17HtUmP+ne9R0W7/
	pGruDAyp2vqKINjzHoOPpJBTob2IJbnxvBjqkbTbvpFXUvdzmnI+yBlCkebaY4G0UtgqIxTg5No
	ibF07MpNeFxCxLlpvSL9ND7szbjx5mOI9vpN8ToqtAohG9ZuHY6npabvJrSP8c76GxlqKR5SV0m
	DYlV4CRc2tGPHzsIGQ3SZUcLHlMRANVNI3iQY5IRUMYIJ2l7DLIIG8Bj7W2qxoEv6EgdFIAYViO
	hv93vwa6dWjudxh6J2lJq0uFZrTdWkwG1rTzpwG6pVBQhVuUXjHqGtRC4x/k/8TCPMEdMiw/xrr
	CKE2oS9
X-Received: by 2002:ac8:5908:0:b0:506:a287:a87 with SMTP id d75a77b69052e-50752849955mr200806971cf.40.1772540110255;
        Tue, 03 Mar 2026 04:15:10 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5075feb4db9sm79588961cf.22.2026.03.03.04.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 04:15:09 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vxOea-00000004CWJ-1Uzg;
	Tue, 03 Mar 2026 08:15:08 -0400
Date: Tue, 3 Mar 2026 08:15:08 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Robin Murphy <robin.murphy@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Melody Wang <huibo.wang@amd.com>,
	Seongman Lee <augustus92@kaist.ac.kr>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Denis Efremov <efremov@linux.com>,
	Geliang Tang <geliang@kernel.org>,
	Piotr Gregor <piotrgregor@rsyncme.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kim Phillips <kim.phillips@amd.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
	iommu@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page
 state for TDISP devices
Message-ID: <20260303121508.GD964116@ziepe.ca>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-7-aik@amd.com>
 <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
 <20260228000630.GN44359@ziepe.ca>
 <2a5b2d8c-7359-42bd-9e8e-2c3efacee747@amd.com>
 <20260302003535.GU44359@ziepe.ca>
 <500e3174-9aa1-464a-b933-f0bcc2ddde68@amd.com>
 <20260302133527.GV44359@ziepe.ca>
 <9cf2e2e6-0fe2-4804-9c62-bc60c89d57c1@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cf2e2e6-0fe2-4804-9c62-bc60c89d57c1@amd.com>
X-Rspamd-Queue-Id: 0A2F41EF48B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	TAGGED_FROM(0.00)[bounces-72519-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_GT_50(0.00)[58];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 07:19:36PM +1100, Alexey Kardashevskiy wrote:

> > It seems from your email that the CPU S2 has the Cbit as part of the
> > address and the S1 feeds it through to the S2, so it is genuinely has
> > two addres spaces?
> 
> S1/S2 PTEs have Cbit. Addresses to look up those PTEs - do not.

So we are back to what I was saying before: using phys_addr_t to
encode a PTE bit is probably a very confusing idea - especially when
contrasted with the other arches that have a legitimate address bit.

> > Same way it knows if there is no S1?
> 
> If no S1 - then sDTE decides on Cbit for the entire ASID (with the help of vTOM).

Sounds like the intention was the IOMMU shared/private space would be
controlled with vTOM which actually does a create a legitimate address
bit in the phys_addr_t.

A sDTE global control is OK for non-TDISP devices, or even devices
that haven't entered RUN yet, but it is not OK for a TDISP device that
must still be able to access shared memory.

> I understand I am often confusing, trying to unconfuse (including myself)... Thanks,

It seems to me the AMD architecture itself is pretty confusing. :\

Jason
 
 


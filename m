Return-Path: <kvm+bounces-71909-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GELVIOGSn2k9cwQAu9opvQ
	(envelope-from <kvm+bounces-71909-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:25:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE1A19F612
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 41E773023159
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39757224AF1;
	Thu, 26 Feb 2026 00:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4m715XQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B941F0E2E;
	Thu, 26 Feb 2026 00:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772065501; cv=none; b=i05qN+MFAyBy61xDDWVFGTF7MRmNCbS0amo1eVnShnDTg82FOrdeCJ8hsHNx7ZJDPfJ6oVY3UIv40D1INAO2lat/x3wa3nwearbFfgOBASfgQKZhd6S2+upKa5NyAiXr83iEOQNW836hvl3D0ApW6CcghinzbLEahd3eIey8NGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772065501; c=relaxed/simple;
	bh=b52uu2gH2CgKqF70w9+b2jEYlCH0p2KqXL61mISEp7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=QDThzkyE6Ek+87djMujXYup3um96AwtVnHXk/uUWLKElHxTmTnXOgp/vMtqAO2fi8LQ7DdJBi14L6Ex4ej2VOL471Hk9nucnbdfsEO1K0veAi7pgEvuGb2WH6d08ySNHp7iHlxLs59YRmcD6+IkpLiInSoiyagIqHoHZLbjrxCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4m715XQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D284EC116D0;
	Thu, 26 Feb 2026 00:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772065501;
	bh=b52uu2gH2CgKqF70w9+b2jEYlCH0p2KqXL61mISEp7Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=U4m715XQwA1fAW3ZZ4WgxiaMzzAojlHtUmPVEzQex1vE6/DOCoWxyAS9EB6y4h7iF
	 OLVK0TV/6C2vK+k5ePvkOxTAw/CIt+Q8UpeAAxqEOKHxP3A7t4d2DwKXtL6imdfqlA
	 4V8ORT+SSqP/b0p0484nlsyBnpgnm3gyEV/xfJOxNixdSENszEMyNxtjZjCYFs3Zhu
	 LBCC6LiarhgfQUKJcAqfzTco/C3kdrqpt7nteSnmbFxP0m7fssOaDOSNXK/OwmrYRX
	 botdSpWXigio83YadoMfz9Caw79VmYBD2DOkMCFhEPiFKollV0uDlR5BemKk86CPA7
	 Lycmaj1135p3Q==
Date: Wed, 25 Feb 2026 18:24:59 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
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
	iommu@lists.linux.dev
Subject: Re: [PATCH kernel 8/9] RFC: PCI: Avoid needless touching of Command
 register
Message-ID: <20260226002459.GA3795172@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225053806.3311234-9-aik@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71909-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_GT_50(0.00)[58];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[helgaas@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1AE1A19F612
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 04:37:51PM +1100, Alexey Kardashevskiy wrote:
> Once locked, a TDI's MSE and BME are not allowed to be cleared.

Disallowed by hardware, by spec, by convention?  Spec reference would
be helpful.

> Skip INTx test as TEE-capable PCI functions are most likely IOV VFs
> anyway and those do not support INTx at all.

"Most likely" doesn't sound like a convincing argument for skipping
something.

> Add a quirk preventing the probing code from disabling MSE when
> updating 64bit BAR (which cannot be done atomically).

Say more about this please.  If there's something special about this
device, I'd like to know exactly what that is.

> Note that normally this happens too early and likely not really
> needed for the device attestation happening long after PCI probing.

I don't follow this either.  Please make it meaningful for
non-TEE/TDI/whatever experts.  And mention that context in the subject
line.

> @@ -1930,6 +1930,11 @@ static int pci_intx_mask_broken(struct pci_dev *dev)
>  {
>  	u16 orig, toggle, new;
>  
> +	if (dev->devcap & PCI_EXP_DEVCAP_TEE) {
> +		pci_warn_once(dev, "(TIO) Disable check for broken INTX");
> +		return 1;

s/INTX/INTx/

Why do users need to know this?  Why as a warning?  What can they do
about it?  "TIO"?


Return-Path: <kvm+bounces-10753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D6386FA58
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 07:57:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 110C7280FB0
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 06:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570DE125B0;
	Mon,  4 Mar 2024 06:57:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7081811C89;
	Mon,  4 Mar 2024 06:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709535430; cv=none; b=J25kTagMBnmm02dRiR3aOSXnJzaspIbLZgALpYh+wmrhVphV7MUVN9tNyqBqwhUc4svG58EMFRmdoCNV3E3RLIbUqLgaEsJ86B9jsjG2zbjZz4HJEqpSih5Phx9Yc+VNJa4dcgEeGc1r2DO/hydwuP/KG4UjF1Y+1FkRSW1WF2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709535430; c=relaxed/simple;
	bh=kop2TSr8/P5YK+OY67Fn7ooNzY6XSya1pVvnxs+jX5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o9a1Ei+7QvieDzMVFXXJSze3sIOpfnpHl4JGtI/sb6DLNnfrXpjVrCnPqG8KbGHvtGrXeZ7Vn1B+WxbPxsY8hHGypQYKtVjpq5BrFt1dz0HHXBFchcy2kcYmvaxAhk/veR2wR+TAh3xp0pzVc5aLE37HlsQfzzi9PHKJKYNHiSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id A0F87300002C4;
	Mon,  4 Mar 2024 07:57:03 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 950D437E2F; Mon,  4 Mar 2024 07:57:03 +0100 (CET)
Date: Mon, 4 Mar 2024 07:57:03 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, linuxarm@huawei.com,
	David Box <david.e.box@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, "Li, Ming" <ming4.li@intel.com>,
	Zhi Wang <zhi.a.wang@intel.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 03/12] X.509: Move certificate length retrieval into new
 helper
Message-ID: <20240304065703.GA24373@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
 <16c06528d13b2c0081229a45cacd4b1b9cdff738.1695921657.git.lukas@wunner.de>
 <65205cc1c1f40_ae7e72949d@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65205cc1c1f40_ae7e72949d@dwillia2-xfh.jf.intel.com.notmuch>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Oct 06, 2023 at 12:15:13PM -0700, Dan Williams wrote:
> Lukas Wunner wrote:
> > The upcoming in-kernel SPDM library (Security Protocol and Data Model,
> > https://www.dmtf.org/dsp/DSP0274) needs to retrieve the length from
> > ASN.1 DER-encoded X.509 certificates.
> > 
> > Such code already exists in x509_load_certificate_list(), so move it
> > into a new helper for reuse by SPDM.
[...]
> > +EXPORT_SYMBOL_GPL(x509_get_certificate_length);
> 
> Given CONFIG_PCI is a bool, is the export needed? Maybe save this export
> until the modular consumer arrives, or identify the modular consumer in the
> changelog?

The x509_get_certificate_length() helper introduced by this patch
isn't needed directly by the PCI core, but by the SPDM library.

The SPDM library is tristate and is selected by CONFIG_PCI_CMA,
which is indeed bool.

However SCSI and ATA (both tristate) have explicitly expressed an
interest to use the SPDM library.

If I drop the export, I'd have to declare the SPDM library bool.

I'm leaning towards keeping the SPDM library tristate (and keep the
export) to accommodate SCSI, ATA and possibly others.

Please let me know if you disagree.

Thanks,

Lukas


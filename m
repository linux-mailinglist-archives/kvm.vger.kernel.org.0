Return-Path: <kvm+bounces-72373-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGxRINiTpWnXEAYAu9opvQ
	(envelope-from <kvm+bounces-72373-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:42:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F331D9FEE
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 14:42:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 12B17309A2C7
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 13:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301EC3FB045;
	Mon,  2 Mar 2026 13:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="I1M0dET2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0B368287
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 13:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772458531; cv=none; b=a3z82JTZ2rNnz2zWQktaPPufVoJCJYxbX/xC6kyQMI0FRgw/X5X35j+NjQoObBRaVQUFLqDJYsY4XkXXIIh2lQbGQmCf8nlm3I6PLbGKzuq0TFgTzOShm4KWH6J+Lgvi1izKe2fJnf8ABQs2od7mxGCNCe3ZqZ/4IyN6TX8Rd8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772458531; c=relaxed/simple;
	bh=FbvCdNY37UamTN31SSyauOm8sq3E53gqKRjT2KA5HYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQRkVqR29Df6FPd76/Pb4n3hCWYJj5h6/yLJAy9j/hBdmPt0D053wSJAcWz0dAMSIJN6geD4inG2vwsthx5StyipDB3YJbASbMGpClJcAh9lESldNNkGC/1M5tsNTwbLaCb06k6og/f58T/GWjheevmaDsdApxdlKiTzU/YDsKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=I1M0dET2; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-899ab9d13d0so34878336d6.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 05:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772458529; x=1773063329; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o+HFg2ochnrDtRr4Pe6iIPk9bCWPHCXlKNRCptQLo7I=;
        b=I1M0dET2Ho1B+9mNKm59IIWPjOOp4DFEB6sr8tvyhIGtableCz4iUafcseALk0B3Mg
         58uC+8aJDwvTfa5jdgPiuGUPA5do6INXBHg7IS41vIFJHJ+Qa4CkEccCPcCd8usLq3zY
         w/TYwl/chBBA+PGiOkvRsJ6OpDZ9wqBFD/ErtLLkbn4HAYMNRXcsNufcZQtS0dfKmcr3
         uIIyGiWDpd2zJStNUIALQAvzj39dkaU72ozsfsL6vS1UMd7JOM+uptBiUwMOK3bZXjqp
         orbE3ZKzdDCd8M4bJYJZ/rmXlKncVepAJ7MyoGVqS2shEwyJHI8okw6m/Pgp3pUyKaSJ
         9IBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772458529; x=1773063329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o+HFg2ochnrDtRr4Pe6iIPk9bCWPHCXlKNRCptQLo7I=;
        b=ulkDDv83n+HiayJ6t42Kz19LmzJ8rR/PBVWHRpmr6gLwGQ+m0hZhAn6dAglnNJ2RZ2
         EjHL50CKoawoybJ3ElG+Bl8Hp/ru3YcTol162WAu6juEpj2JNYkLiWZWmOArRs0qHEgJ
         vfg6G+x2NvBL7aPy9iLckAIvtcfCtII7jfXgkol5IOTxwWTpwQUykgxhvVhBPNc4KAVY
         bSVAEinmdEK+l/NyUbwRVZrCdN+PY203wOolpyZXSFIwTTY/1TkleodMbupFoSEIvNQN
         Mq1sMe/WelXlcqeNyUIrYtUrNFdt8kRUOhnIZjP7TkEfDlwIIFoYqu3dFOCKezXy/jFn
         ZhAw==
X-Forwarded-Encrypted: i=1; AJvYcCXYP9sxuO5P3L5oQ2Ra6Er50myrS3OBMDNRFuuC3aGwoDRJ2/xhsEj/bAB5t/AqHehn27U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKmqj3yApBvHNlfie4zgtY5GY+STLuzYUeROALAKWTneCLX2JC
	CEH/xTpHeJQOPzhsXEaRL2QnGvegtNcF54ewmDco/OSO4gDyyQlqXmrqUvZYFjBR9z8=
X-Gm-Gg: ATEYQzwEovXJPDmC80xkBR2nXiZ4rf298uMfnCRxN8cbtyQiWbHQ8bl4P/+7v7XFcBp
	/K7Lfi0ij0ronZaJL105j1IZWo6JPPMqPTdWom+c1x/JBExxGscVbT/v6PYU114RSbEi8TUc0T6
	vrvwfXv9quprjGvfqB+7CXAkuolfMdvO2Yzxc6Wav+a/Ewa/8TI/txS0e/Wd5jejHPu88ytW0Br
	z3iPqPhy8tLWrK6vStsG2y2y4s2yj5WDLTP+VyB4yjyA+m65vjGjRHiftX6i48vUKT1TpDc3YIe
	Jsi4F8yNdAvzWl6LZdGQSH3bSt2VX1S60gp5E6w/n3NN+nI8+NQ700pjwpCrRinYgwfhdpze3Mv
	om1AVVpclTR04Ffx2wvOiWgTbUNTE9tofaS6s2oJbSKb8lV2tC1jZhpnrRb8OFR6MRuIsSjDITi
	kxEK8Y9GgPHQkRjJbw0qmNJ34ABQ5qlc0Py2iHFgpJ71cjE+M3VAuYsXoOONZ/Q4VQNM9IOeuz4
	0uT2D2P
X-Received: by 2002:a05:6214:21e1:b0:895:4b4f:133a with SMTP id 6a1803df08f44-899d1d8459dmr178895326d6.5.1772458528769;
        Mon, 02 Mar 2026 05:35:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899f4fb208dsm35628906d6.28.2026.03.02.05.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 05:35:28 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vx3Ql-00000003fNz-1MAa;
	Mon, 02 Mar 2026 09:35:27 -0400
Date: Mon, 2 Mar 2026 09:35:27 -0400
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
	iommu@lists.linux.dev, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page
 state for TDISP devices
Message-ID: <20260302133527.GV44359@ziepe.ca>
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-7-aik@amd.com>
 <d8102507-e537-4e7c-8137-082a43fd270d@arm.com>
 <20260228000630.GN44359@ziepe.ca>
 <2a5b2d8c-7359-42bd-9e8e-2c3efacee747@amd.com>
 <20260302003535.GU44359@ziepe.ca>
 <500e3174-9aa1-464a-b933-f0bcc2ddde68@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500e3174-9aa1-464a-b933-f0bcc2ddde68@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	TAGGED_FROM(0.00)[bounces-72373-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_GT_50(0.00)[59];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: 15F331D9FEE
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 04:26:58PM +1100, Alexey Kardashevskiy wrote:

> > > Without secure vIOMMU, no Cbit in the S2 table (==host) for any
> > > VM. SDTE (==IOMMU) decides on shared/private for the device,
> > > i.e. (device_cc_accepted()?private:shared).
> > 
> > Is this "Cbit" part of the CPU S2 page table address space or is it
> > actually some PTE bit that says it is "encrypted" ?
> > 
> > It is confusing when you say it would start working with a vIOMMU.
> 
> When I mention vIOMMU, I mean the S1 table which is guest owned and
> which has Cbit in PTEs.

Yes, I understand this.

It seems from your email that the CPU S2 has the Cbit as part of the
address and the S1 feeds it through to the S2, so it is genuinely has
two addres spaces?

While the IOMMU S1 does not and instead needs a PTE bit which is
emphatically not an address bit because it does not feed through the
S2?

> > If 1<<51 is a valid IOPTE, and it is an actually address, then it
> > should be mapped into the IOMMU S2, shouldn't it? If it is in the
> > IOMMU S2 then shouldn't it work as a dma_addr_t?
> 
> It should (and checked with the HW folks), I just have not tried it  as, like, whyyy.

Well, I think things work more sensibly if you don't have to mangle
the address..

> > But in this case I would expect the vIOMMU to also use the same GPA
> > space starting from 0 and also remove the C bit, as the S2 shouldn't
> > have mappings starting at 1<<51.
> 
> How would then IOMMU know if DMA targets private or shared memory?
> The Cbit does not participate in the S2 translation as an address
> bit but IOMMU still knows what it is.

Same way it knows if there is no S1? Why does the S1 change anything?

> > > There is vTOM in SDTE which is "every phys_addr_t above vTOM is no
> > > Cbit, below - with Cbit" (and there is the same thing for the CPU
> > > side in SEV) but this not it, right?
> > 
> > That seems like the IOMMU HW is specially handling the address bits in
> > some way?
> 
> Yeah there is this capability. Except everything below vTOM is
> private and every above is shared so SME mask for it would be
> reverse than the CPU SME mask :) Not using this thing though (not
> sure why we have it). Thanks,

Weird!!

Jason


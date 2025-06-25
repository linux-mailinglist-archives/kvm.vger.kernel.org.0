Return-Path: <kvm+bounces-50732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E978AE89C4
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 18:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D8E1176ABB
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 255D62C325C;
	Wed, 25 Jun 2025 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJ4yL4EO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440842797B1;
	Wed, 25 Jun 2025 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750868916; cv=none; b=a57m/F7J1ELWzIErE0CpkLcwFvO4UftXSx7AyalQ8+A7G5e942auBFE7Yf0sTrztxwP+OblE9mKZDHXgtmCa/UaHZijUNFqnn6Qaig0kuWJuhX32WOlusZztbc7pV6gXs7YEMY9olUHuKrQsLNVURUCpEUFIDup2pLtN14acoDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750868916; c=relaxed/simple;
	bh=Gtn2/RJXk3N8rLfOkqro/QRdn5WC9y7iQgSI+nXfE4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUQ5bFi/3cW5A7CY6XlZX3GfOqu0v5TUe4zGi31ZGlMOKLQ96tBBaAT4uJdp3GMNbsR7R9UaRXFuU++jfwLbTutSVjo9/QWDOqBDdQ7WflNwVtAiXbXmESf03dk8OHSsp4qJgQNVXM86D1mM5bCfnDLm5Yd4Rkip4l0UpByz+h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJ4yL4EO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAD7C4CEEA;
	Wed, 25 Jun 2025 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750868915;
	bh=Gtn2/RJXk3N8rLfOkqro/QRdn5WC9y7iQgSI+nXfE4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YJ4yL4EObsN4SG0w35Sknhmux2/v59i5yLNqBmajQXXjvs72JfQBAlNptH/Vrnixo
	 jA8wwNq0kFTB03a9nSe/szugrDqvBjEH+4sIMUtzTeJZ6dNiesDauYiGIEq+7LPN5n
	 srgIdsgIqeUIvBvOorqGubJHot+rAMjwT3L4dXIrUaiBBmRY53NcePHjTDs115K/8A
	 mN1irGM8kqVt9/NcvYwpidFuN6wzzEdC3UXpi4byhcPHrls+yXc6xeglKYQPIhgoO4
	 XOdt1KM/fpf6dvkmdvy9k0PGUPMa80fCP3IDFejd4hIfJcjntvk2sPk9q/ezSkcryX
	 y4q9QnZyAC3QA==
Date: Wed, 25 Jun 2025 10:28:29 -0600
From: Manivannan Sadhasivam <mani@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Bjorn Helgaas <bhelgaas@google.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Kai-Heng Feng <kai.heng.feng@canonical.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Santosh Shukla <santosh.shukla@amd.com>, 
	"Nikunj A. Dadhania" <nikunj@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] PCI: Add quirk to always map ivshmem as write-back
Message-ID: <opdpelyb26bzp723lyxljjb2dmxgunkcjlvpkxgbrxaxhoycv6@eigu7etse3g7>
References: <20250612082233.3008318-1-aik@amd.com>
 <52f0d07a-b1a0-432c-8f6f-8c9bf59c1843@amd.com>
 <930fc54c-a88c-49b3-a1a7-6ad9228d84ac@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <930fc54c-a88c-49b3-a1a7-6ad9228d84ac@amd.com>

On Tue, Jun 24, 2025 at 11:42:47AM +1000, Alexey Kardashevskiy wrote:
> Ping? Thanks,
> 
> 
> On 12/6/25 18:27, Alexey Kardashevskiy wrote:
> > Wrong email for Nikunj :) And I missed the KVM ml. Sorry for the noise.
> > 
> > 
> > On 12/6/25 18:22, Alexey Kardashevskiy wrote:
> > > QEMU Inter-VM Shared Memory (ivshmem) is designed to share a memory
> > > region between guest and host. The host creates a file, passes it to QEMU
> > > which it presents to the guest via PCI BAR#2. The guest userspace
> > > can map /sys/bus/pci/devices/0000:01:02.3/resource2(_wc) to use the region
> > > without having the guest driver for the device at all.
> > > 
> > > The problem with this, since it is a PCI resource, the PCI sysfs
> > > reasonably enforces:
> > > - no caching when mapped via "resourceN" (PTE::PCD on x86) or
> > > - write-through when mapped via "resourceN_wc" (PTE::PWT on x86).
> > > 
> > > As the result, the host writes are seen by the guest immediately
> > > (as the region is just a mapped file) but it takes quite some time for
> > > the host to see non-cached guest writes.
> > > 
> > > Add a quirk to always map ivshmem's BAR2 as cacheable (==write-back) as
> > > ivshmem is backed by RAM anyway.
> > > (Re)use already defined but not used IORESOURCE_CACHEABLE flag.
> > > 

It just makes me nervous to change the sematics of the sysfs attribute, even if
the user knows what it is expecting. Now the "resourceN_wc" essentially becomes
"resourceN_wb", which goes against the rule of sysfs I'm afraid.

> > > This does not affect other ways of mapping a PCI BAR, a driver can use
> > > memremap() for this functionality.
> > > 
> > > Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> > > ---
> > > 
> > > What is this IORESOURCE_CACHEABLE for actually?
> > > 
> > > Anyway, the alternatives are:
> > > 
> > > 1. add a new node in sysfs - "resourceN_wb" - for mapping as writeback
> > > but this requires changing existing (and likely old) userspace tools;
> > > 

I guess this would the cleanest approach. The old tools can continue to suffer
from the performance issue and the new tools can work more faster.

- Mani

-- 
மணிவண்ணன் சதாசிவம்


Return-Path: <kvm+bounces-24155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF14951E74
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1278B2C3A6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEED1B4C43;
	Wed, 14 Aug 2024 15:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Aipv7Dl3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083051B3724
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723648829; cv=none; b=hlgrowRq88G5ccaleJWV1Sw+hgdGMjKNPMKaMBELK5ybLmLn34GEM6KzYBjF8ysyKPxqK3nCTd4LxJumixa9XBTvGtJNZlu4g/C0ahOPlmW2FxCm7mAn5a9I6gdpRWJrTMqu3UJWriTDCBG7cAjZVzj90IyNvqcF2J5g/zizNlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723648829; c=relaxed/simple;
	bh=hcduPUJ63plKYFg5sMgJaJoxpYnUDTuhe5B+9+bWdAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWOKSOX/AJPWn0fV+3gqadmwqBo8PQvdA4zDVszY7+Me4PxP2hcDj/fcIfWdWmx0rtt84p26wAZb+l6ovWsdkNV23fIhykW+LDE2TOOmUEP+0rCnkh25BeIgYvF8BfPNhpmnlfHxSv0XbXhM0Xt6kqALIuBiZ1SvoM37+CNUBYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Aipv7Dl3; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6b79c969329so35385396d6.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1723648827; x=1724253627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mg23CNEDMD4zHjO1hlkwyk+loYx0YTVZ8r/y6/PQnrA=;
        b=Aipv7Dl35A35n50CHlvE2Ny2Rcf5RG1ObGB6eBe2bwytvgn6GuzVO/07MTV2HVdZQP
         nw9iaMHh+1JxaHnggMdkHiEMXCz+l4lOXl+Mbz2l27L9AagE99qRGppvVEOnVRKBzrTi
         RSd2q/XoyAihwP2WR3bAzIa0nrJwJuXjDvQViDoloHqpU//SwwkIJbuvEBQu0gvP3pAI
         Cy8b6AqicfkZmaUj3dzdDVdZGF7KdGyzLLwAfMDa9G6ZgXESa7Eq/DPpgWaOjL0nC3tX
         0dgViQFXyz/bITfJa4K6GIDwEzvxFT7wnsxyrQ9bFIkS9mLQ6T+O/XxeGccfs5F233yL
         D26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723648827; x=1724253627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mg23CNEDMD4zHjO1hlkwyk+loYx0YTVZ8r/y6/PQnrA=;
        b=LWd2mCQz+1R6t2VIWR0rhWvXiMeiVrxCdr4uSKHK32+4dg4UtJZuXOmHKCkiiPUxNG
         lcYLpDa9XkxISiGxMvkRtiW8+EK6ruPN8JmlGL1S7eksli9h9YYunZYzuNPeKm37qocK
         h2TyvqcubCG0th20NnmvB9XvhSFUT77EHX4P702J4vgqpLuEZxpgSRJyzsenjOaYXE1t
         0/Y8TjBixJLHXjHtOriEj4GWDOubsSKvOcP6bu49AsvJk819iavGmFoORJA30gHWyfiu
         VOPmdsoZs7dCNyXJzuvc2P1KpfDOKU4z1STSPNAoBHb78vY/I2Bfh8Lo1MEPk7VkziQd
         aEVw==
X-Forwarded-Encrypted: i=1; AJvYcCUjJzLuncD+1SsHR/+I1YOC1XyYQ7zgiJjk7IPGePIW+1ZNI2ZYMT5K5kR7DfBUTI+xPr3AxnUbdlAhUWn9SVAyF//L
X-Gm-Message-State: AOJu0Yy8WUACBdhAHXPD0CH3p+O5lZ6YNyqyAhObeTSqZdVEm52/796L
	dwyl9wkSz1Exd54WgKwBxMjtB+wxTNSBjxfWZ22gLMa8zmQ9J1Pt+sqHc3jV4HI=
X-Google-Smtp-Source: AGHT+IFs/BQEZjr8h6unAsrJ2o06RGnXrm/il5j+/wDCwXIvEtQlOlvpOhTjJBqTcjF825DsnYbpEw==
X-Received: by 2002:a05:6214:3c9f:b0:6bd:6ff2:bb3c with SMTP id 6a1803df08f44-6bf5d056a6dmr44429756d6.0.1723648826791;
        Wed, 14 Aug 2024 08:20:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bd82e4e5d3sm44550136d6.110.2024.08.14.08.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 08:20:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1seFnV-00EfQF-Mk;
	Wed, 14 Aug 2024 12:20:25 -0300
Date: Wed, 14 Aug 2024 12:20:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	quic_bqiang@quicinc.com, kvalo@kernel.org, prestwoj@gmail.com,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	dwmw2@infradead.org, iommu@lists.linux.dev, kernel@quicinc.com,
	johannes@sipsolutions.net, jtornosm@redhat.com
Subject: Re: [PATCH RFC/RFT] vfio/pci: Create feature to disable MSI
 virtualization
Message-ID: <20240814152025.GA3468552@ziepe.ca>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
 <20240812170014.1583783-1-alex.williamson@redhat.com>
 <20240813163053.GK1985367@ziepe.ca>
 <20240813151401.789c578f.alex.williamson@redhat.com>
 <20240813231642.GR1985367@ziepe.ca>
 <20240814085505.60819623.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814085505.60819623.alex.williamson@redhat.com>

On Wed, Aug 14, 2024 at 08:55:05AM -0600, Alex Williamson wrote:
> Let's imagine the guest driver does change to implement an irq_domain.
> How does that fundamentally change the problem for the VMM that guest
> MSI values are being written to other portions of the device?

If changed to irq_domain the VM will write addr/data pairs into those
special register that are unique to that interrupt source and will not
re-use values already set in the MSI table.

This means the VMM doesn't get any value from inspecting the MSI table
because the value it needs won't be there, and alos that no interrupt
routing will have been setup. The VMM must call VFIO_DEVICE_SET_IRQS
to setup the unique routing.

These two patches are avoiding VFIO_DEVICE_SET_IRQS based on the
assumption that the VM will re-use a addr/data pair already setup in
the MSI table. Invalidating that assumption is the fundamental change
irq_domain in the VM will make.

> The guest driver can have whatever architecture it wants (we don't
> know the architecture of the Windows driver) but we still need to
> trap writes of the guest MSI address/data and replace it with host
> values.

Yes you do. But the wrinkle is you can't just assume one of the
existing MSI entries is a valid replacement and copy from the MSI
table. That works right now only because the Linux/Windows driver is
re-using a MSI vector in the IMS registers.

I suggest the general path is something like:

 1) A vfio variant driver sets up an irq_domain for the additional
    interrupt source registers
 2) Somehow wire up VFIO_DEVICE_SET_IRQS so it can target vectors in
    the additional interrupt domain
 3) Have the VMM trap writes to the extra interrupt source registers
    and execute VFIO_DEVICE_SET_IRQS
 4) IRQ layer will setup an appropriate unique IRQ and route it to the
    guest/whatever just like MSI. Callbacks into the variant driver's
    irq_domain will program the HW registers.

Basically exactly the same flow as MSI, except instead of targetting a
vector in the PCI core's MSI irq_domain it targets a vector in the
variant driver's IMS IRQ domain.

Then we don't make any assumptions about how the VM is using these
interrupt vectors, and crucially, SET_IRQs is called for every
interrupt source and we rely on the kernel to produce the correct
addr/data pair. No need for copying addr/data pairs from MSI tables.

> As noted above, this does not provide any visible change to a QEMU
> guest, it only enables QEMU to implement the quirk in the other
> patch.

I see, I definitely didn't understand that it only reaches qemu from
the commit message..

Jason

